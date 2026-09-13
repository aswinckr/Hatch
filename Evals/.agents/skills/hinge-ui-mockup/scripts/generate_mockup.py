#!/usr/bin/env python3
"""Generate a Hinge-style feature mockup with OpenRouter's Image API."""

from __future__ import annotations

import argparse
import base64
import json
import mimetypes
import os
import re
import sys
import urllib.error
import urllib.request
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


DEFAULT_MODEL = "google/gemini-3-pro-image"
DEFAULT_API_BASE = "https://openrouter.ai/api/v1"
SUPPORTED_SUFFIXES = {".png", ".jpg", ".jpeg", ".webp"}
MAX_REFERENCES = 14

SKILL_DIR = Path(__file__).resolve().parents[1]
EVALS_DIR = SKILL_DIR.parents[2]
DEFAULT_REFERENCES_DIR = SKILL_DIR / "assets" / "hinge-references"
DEFAULT_OUTPUT_ROOT = EVALS_DIR / "generated" / "hinge-ui-mockup"
DESIGN_LANGUAGE_PATH = SKILL_DIR / "references" / "design-language.md"
DOTENV_PATH = SKILL_DIR / ".env"


def load_dotenv(path: Path) -> None:
    """Load simple KEY=VALUE entries without overriding the shell environment."""
    if not path.is_file():
        return

    try:
        lines = path.read_text(encoding="utf-8").splitlines()
    except OSError as exc:
        raise SystemExit(f"Could not read environment file: {exc}") from exc

    for line_number, line in enumerate(lines, start=1):
        entry = line.strip()
        if not entry or entry.startswith("#"):
            continue
        if entry.startswith("export "):
            entry = entry[7:].lstrip()

        key, separator, value = entry.partition("=")
        key = key.strip()
        if not separator or not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", key):
            raise SystemExit(f"Invalid .env entry on line {line_number}.")

        value = value.strip()
        if len(value) >= 2 and value[0] == value[-1] and value[0] in {"'", '"'}:
            value = value[1:-1]
        os.environ.setdefault(key, value)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Generate one high-fidelity Hinge-style mobile UI mockup using local "
            "reference screenshots and OpenRouter's Image API."
        )
    )
    prompt_group = parser.add_mutually_exclusive_group(required=True)
    prompt_group.add_argument("--prompt", help="Feature concept to visualize.")
    prompt_group.add_argument(
        "--prompt-file", type=Path, help="UTF-8 text file containing the feature concept."
    )
    parser.add_argument(
        "--reference",
        action="append",
        type=Path,
        default=[],
        help="Reference image path. Repeat to use multiple images.",
    )
    parser.add_argument(
        "--references-dir",
        type=Path,
        default=DEFAULT_REFERENCES_DIR,
        help=f"Directory used when --reference is omitted (default: {DEFAULT_REFERENCES_DIR}).",
    )
    parser.add_argument("--model", default=DEFAULT_MODEL, help="OpenRouter image model ID.")
    parser.add_argument("--aspect-ratio", default="9:16", help="Output aspect ratio.")
    parser.add_argument("--resolution", default="2K", help="Output resolution tier.")
    parser.add_argument(
        "--output-dir",
        type=Path,
        help="Empty destination directory. Defaults to a new timestamped directory.",
    )
    parser.add_argument(
        "--api-base",
        default=os.environ.get("OPENROUTER_API_BASE", DEFAULT_API_BASE),
        help="OpenRouter API base URL.",
    )
    parser.add_argument(
        "--timeout", type=int, default=240, help="HTTP timeout in seconds (default: 240)."
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Validate inputs and print a redacted request summary without calling OpenRouter.",
    )
    return parser.parse_args()


def read_feature_prompt(args: argparse.Namespace) -> str:
    if args.prompt is not None:
        prompt = args.prompt
    else:
        try:
            prompt = args.prompt_file.expanduser().resolve().read_text(encoding="utf-8")
        except OSError as exc:
            raise SystemExit(f"Could not read prompt file: {exc}") from exc

    prompt = prompt.strip()
    if not prompt:
        raise SystemExit("The feature prompt cannot be empty.")
    return prompt


def find_references(args: argparse.Namespace) -> list[Path]:
    if args.reference:
        paths = [path.expanduser().resolve() for path in args.reference]
    else:
        directory = args.references_dir.expanduser().resolve()
        if not directory.is_dir():
            raise SystemExit(f"Reference directory does not exist: {directory}")
        paths = sorted(
            path.resolve()
            for path in directory.iterdir()
            if path.is_file() and path.suffix.lower() in SUPPORTED_SUFFIXES
        )

    if not paths:
        raise SystemExit("No supported reference images were found.")
    if len(paths) > MAX_REFERENCES:
        raise SystemExit(
            f"Found {len(paths)} references; {DEFAULT_MODEL} supports at most {MAX_REFERENCES}."
        )

    for path in paths:
        if not path.is_file():
            raise SystemExit(f"Reference image does not exist: {path}")
        if path.suffix.lower() not in SUPPORTED_SUFFIXES:
            allowed = ", ".join(sorted(SUPPORTED_SUFFIXES))
            raise SystemExit(f"Unsupported reference type for {path}; use one of: {allowed}")
    return paths


def data_url(path: Path) -> str:
    media_type, _ = mimetypes.guess_type(path.name)
    media_type = media_type or "image/png"
    encoded = base64.b64encode(path.read_bytes()).decode("ascii")
    return f"data:{media_type};base64,{encoded}"


def read_design_language() -> str:
    try:
        return DESIGN_LANGUAGE_PATH.read_text(encoding="utf-8").strip()
    except OSError as exc:
        raise SystemExit(f"Could not read design-language guide: {exc}") from exc


def build_generation_prompt(feature_prompt: str, design_language: str) -> str:
    return f"""Create one high-fidelity iOS mobile product UI mockup for a proposed feature inside Hinge.

FEATURE CONCEPT
{feature_prompt}

REFERENCE RULES
The supplied screenshots are references for design language only. Infer layout rhythm, hierarchy, typography roles, color roles, corner radii, button treatment, icon style, illustration character, and native iOS framing. Do not copy any person's face, name, profile answer, photo, or identifying detail. Use fictional, non-identifying placeholder content. This is an exploratory concept, not an official Hinge screen.

DESIGN-LANGUAGE NOTES
{design_language}

OUTPUT REQUIREMENTS
- Produce exactly one portrait mobile app screen, not a mood board, presentation slide, device-on-desk render, or marketing poster.
- Show the complete screen edge to edge in a believable iOS state, with clean safe areas and no external phone frame.
- Make the feature purpose and primary action immediately understandable.
- Prefer one dominant action, restrained accent color, generous whitespace, and a small number of coherent components.
- For AI behavior, use warm human language, explain recommendations clearly, preserve user control, and avoid attractiveness ratings.
- Render all visible interface text carefully and legibly. Keep copy short enough for reliable text rendering.
- Do not place annotations, arrows, measurements, color swatches, or explanatory captions outside the interface.
""".strip()


def default_output_dir(feature_prompt: str) -> Path:
    timestamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    slug = re.sub(r"[^a-z0-9]+", "-", feature_prompt.lower()).strip("-")[:48]
    slug = slug or "concept"
    return DEFAULT_OUTPUT_ROOT / f"{timestamp}-{slug}"


def ensure_empty_output_dir(path: Path) -> Path:
    resolved = path.expanduser().resolve()
    if resolved.exists() and any(resolved.iterdir()):
        raise SystemExit(f"Output directory is not empty; choose a new directory: {resolved}")
    resolved.mkdir(parents=True, exist_ok=True)
    return resolved


def make_payload(
    model: str,
    prompt: str,
    references: list[Path],
    aspect_ratio: str,
    resolution: str,
) -> dict[str, Any]:
    return {
        "model": model,
        "prompt": prompt,
        "input_references": [
            {"type": "image_url", "image_url": {"url": data_url(path)}}
            for path in references
        ],
        "aspect_ratio": aspect_ratio,
        "resolution": resolution,
        "n": 1,
    }


def redacted_summary(
    endpoint: str,
    model: str,
    feature_prompt: str,
    references: list[Path],
    aspect_ratio: str,
    resolution: str,
    output_dir: Path,
) -> dict[str, Any]:
    return {
        "endpoint": endpoint,
        "model": model,
        "feature_prompt": feature_prompt,
        "references": [
            {"path": str(path), "bytes": path.stat().st_size} for path in references
        ],
        "aspect_ratio": aspect_ratio,
        "resolution": resolution,
        "n": 1,
        "output_dir": str(output_dir),
        "note": "Base64 image data and API credentials are omitted.",
    }


def call_openrouter(
    endpoint: str, payload: dict[str, Any], api_key: str, timeout: int
) -> dict[str, Any]:
    request = urllib.request.Request(
        endpoint,
        data=json.dumps(payload).encode("utf-8"),
        method="POST",
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
            "Accept": "application/json",
            "HTTP-Referer": "https://local.hinge-ui-mockup.invalid",
            "X-Title": "Hinge UI Mockup Skill",
        },
    )
    try:
        with urllib.request.urlopen(request, timeout=timeout) as response:
            return json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")
        try:
            detail = json.loads(body).get("error", body)
        except json.JSONDecodeError:
            detail = body
        raise SystemExit(f"OpenRouter returned HTTP {exc.code}: {detail}") from exc
    except urllib.error.URLError as exc:
        raise SystemExit(f"Could not reach OpenRouter: {exc.reason}") from exc
    except json.JSONDecodeError as exc:
        raise SystemExit("OpenRouter returned a non-JSON response.") from exc


def suffix_for_media_type(media_type: str | None) -> str:
    return {
        "image/jpeg": ".jpg",
        "image/png": ".png",
        "image/webp": ".webp",
        "image/svg+xml": ".svg",
    }.get(media_type or "", ".png")


def save_result(
    result: dict[str, Any],
    output_dir: Path,
    feature_prompt: str,
    expanded_prompt: str,
    model: str,
    references: list[Path],
    aspect_ratio: str,
    resolution: str,
    endpoint: str,
) -> tuple[list[Path], Path]:
    items = result.get("data")
    if not isinstance(items, list) or not items:
        raise SystemExit("OpenRouter returned no image data.")

    image_paths: list[Path] = []
    for index, item in enumerate(items, start=1):
        if not isinstance(item, dict) or not item.get("b64_json"):
            raise SystemExit(f"Image {index} is missing b64_json data.")
        media_type = item.get("media_type")
        suffix = suffix_for_media_type(media_type)
        image_path = output_dir / f"mockup-{index:02d}{suffix}"
        try:
            decoded = base64.b64decode(item["b64_json"], validate=True)
            with image_path.open("xb") as handle:
                handle.write(decoded)
        except (ValueError, base64.binascii.Error) as exc:
            raise SystemExit(f"Image {index} contained invalid base64 data.") from exc
        image_paths.append(image_path)

    manifest = {
        "created_at": datetime.now(timezone.utc).isoformat(),
        "feature_prompt": feature_prompt,
        "expanded_prompt": expanded_prompt,
        "model": model,
        "endpoint": endpoint,
        "references": [str(path) for path in references],
        "parameters": {
            "aspect_ratio": aspect_ratio,
            "resolution": resolution,
            "n": 1,
        },
        "outputs": [str(path) for path in image_paths],
        "usage": result.get("usage"),
    }
    manifest_path = output_dir / "manifest.json"
    with manifest_path.open("x", encoding="utf-8") as handle:
        json.dump(manifest, handle, indent=2, ensure_ascii=False)
        handle.write("\n")
    return image_paths, manifest_path


def main() -> int:
    load_dotenv(DOTENV_PATH)
    args = parse_args()
    feature_prompt = read_feature_prompt(args)
    references = find_references(args)
    design_language = read_design_language()
    expanded_prompt = build_generation_prompt(feature_prompt, design_language)
    endpoint = f"{args.api_base.rstrip('/')}/images"
    requested_output = args.output_dir or default_output_dir(feature_prompt)

    summary = redacted_summary(
        endpoint=endpoint,
        model=args.model,
        feature_prompt=feature_prompt,
        references=references,
        aspect_ratio=args.aspect_ratio,
        resolution=args.resolution,
        output_dir=requested_output.expanduser().resolve(),
    )
    if args.dry_run:
        print(json.dumps(summary, indent=2, ensure_ascii=False))
        return 0

    api_key = os.environ.get("OPENROUTER_API_KEY", "").strip()
    if not api_key:
        raise SystemExit(
            f"OPENROUTER_API_KEY is not set. Add it to {DOTENV_PATH} or export it in the shell."
        )

    output_dir = ensure_empty_output_dir(requested_output)
    payload = make_payload(
        model=args.model,
        prompt=expanded_prompt,
        references=references,
        aspect_ratio=args.aspect_ratio,
        resolution=args.resolution,
    )
    result = call_openrouter(endpoint, payload, api_key, args.timeout)
    image_paths, manifest_path = save_result(
        result=result,
        output_dir=output_dir,
        feature_prompt=feature_prompt,
        expanded_prompt=expanded_prompt,
        model=args.model,
        references=references,
        aspect_ratio=args.aspect_ratio,
        resolution=args.resolution,
        endpoint=endpoint,
    )

    print("Generated mockup:")
    for path in image_paths:
        print(path)
    print(f"Manifest: {manifest_path}")
    usage = result.get("usage")
    if usage:
        print(f"Usage: {json.dumps(usage, ensure_ascii=False)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
