#!/usr/bin/env python3
"""Compare Figma and app screenshots and emit simple visual-diff artifacts."""

from __future__ import annotations

import argparse
import json
import math
from pathlib import Path
from typing import Iterable

try:
    from PIL import Image, ImageChops, ImageFilter
except ImportError as exc:  # pragma: no cover - environment dependent
    raise SystemExit(
        "Pillow is required. Install it with `python3 -m pip install Pillow` "
        "or use a Python environment that already provides PIL."
    ) from exc


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--design", required=True, type=Path, help="Figma/design screenshot path")
    parser.add_argument("--actual", required=True, type=Path, help="Implemented app screenshot path")
    parser.add_argument("--out-dir", default=Path("visual-audit"), type=Path, help="Output directory")
    parser.add_argument("--threshold", default=18, type=int, help="Per-channel diff threshold, 0-255")
    parser.add_argument(
        "--resize-actual",
        action="store_true",
        help="Resize the actual screenshot to the design dimensions before comparing",
    )
    return parser.parse_args()


def open_rgb(path: Path) -> Image.Image:
    if not path.exists():
        raise SystemExit(f"Missing screenshot: {path}")
    return Image.open(path).convert("RGB")


def rms(values: Iterable[int]) -> float:
    values = list(values)
    if not values:
        return 0.0
    return math.sqrt(sum(value * value for value in values) / len(values))


def image_data(image: Image.Image):
    if hasattr(image, "get_flattened_data"):
        return image.get_flattened_data()
    return image.getdata()


def main() -> None:
    args = parse_args()
    threshold = max(0, min(255, args.threshold))
    args.out_dir.mkdir(parents=True, exist_ok=True)

    design = open_rgb(args.design)
    actual = open_rgb(args.actual)
    original_actual_size = actual.size

    size_note = None
    if design.size != actual.size:
        size_note = {
            "design": {"width": design.width, "height": design.height},
            "actual": {"width": actual.width, "height": actual.height},
        }
        if args.resize_actual:
            actual = actual.resize(design.size, Image.Resampling.LANCZOS)
        else:
            width = min(design.width, actual.width)
            height = min(design.height, actual.height)
            design = design.crop((0, 0, width, height))
            actual = actual.crop((0, 0, width, height))

    diff = ImageChops.difference(design, actual)
    gray = diff.convert("L")
    mask = gray.point(lambda value: 255 if value > threshold else 0)
    mask_data = image_data(mask)
    diff_data = image_data(diff)
    gray_data = image_data(gray)
    changed_pixels = sum(1 for value in mask_data if value)
    total_pixels = mask.width * mask.height

    heat = diff.filter(ImageFilter.GaussianBlur(radius=1))
    overlay = Image.new("RGB", design.size, (255, 42, 42))
    diff_overlay = Image.blend(actual, overlay, 0.55)
    highlighted = Image.composite(diff_overlay, actual, mask)

    diff_path = args.out_dir / "diff.png"
    mask_path = args.out_dir / "mask.png"
    metrics_path = args.out_dir / "metrics.json"
    heat_path = args.out_dir / "heat.png"

    highlighted.save(diff_path)
    mask.save(mask_path)
    heat.save(heat_path)

    channel_extrema = diff.getextrema()
    channel_means = [
        sum(channel) / total_pixels
        for channel in zip(*diff_data)
    ]
    metrics = {
        "design": str(args.design),
        "actual": str(args.actual),
        "comparedSize": {"width": design.width, "height": design.height},
        "originalActualSize": {"width": original_actual_size[0], "height": original_actual_size[1]},
        "sizeMismatch": size_note,
        "threshold": threshold,
        "changedPixels": changed_pixels,
        "totalPixels": total_pixels,
        "changedPercent": round(changed_pixels / total_pixels * 100, 4),
        "meanChannelDiff": [round(value, 4) for value in channel_means],
        "rmsChannelDiff": round(rms(gray_data), 4),
        "maxChannelDiff": max(max(pair) for pair in channel_extrema),
        "artifacts": {
            "diff": str(diff_path),
            "mask": str(mask_path),
            "heat": str(heat_path),
        },
        "notes": [
            "The diff highlights pixels above the threshold in red over the actual screenshot.",
            "Human review is still required for hierarchy, semantics, and expected dynamic content.",
        ],
    }
    metrics_path.write_text(json.dumps(metrics, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(metrics, indent=2))


if __name__ == "__main__":
    main()
