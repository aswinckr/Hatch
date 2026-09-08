"""Copy exact exported assets into stable semantic filenames.

Run with Pillow installed, after downloading the Figma reference assets and
exporting source.fig. Original raster bytes are kept; only small unavailable
navigation glyphs are cropped from the 3x Figma export.
"""
import json
import shutil
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
REF = ROOT / 'design-reference'
DEST = ROOT / 'public' / 'assets'
assets = json.loads((REF / 'assets.json').read_text())
originals = json.loads((REF / 'originals.json').read_text())
mapping = {
 'magnifier': ('5-25990', 'imgMagnifyingGlass'),
 'cellular': ('5-25990', 'imgCellularConnection'),
 'wifi': ('5-25990', 'imgWifi'), 'battery': ('5-25990', 'imgBattery'),
 'chevron': ('5-25990', 'imgTrailingAccessory'),
 'header-blob-yellow': ('5-25990', 'imgBlob'),
 'header-blob-cream': ('5-25990', 'imgBlob1'),
 'header-curve': ('5-25990', 'imgCurve'),
 'arrow': ('5-24137', 'imgIcon1'), 'thumb': ('5-24137', 'imgIcon'),
 'thumb-blob': ('5-24137', 'imgSocialRatingInfoLeadingIconBlob'),
 'delivery': ('5-24137', 'imgStoreDeliveryPricingInfoFeeIcon'),
 'promo-blob': ('5-24137', 'imgIconBlob'), 'promo-icon': ('5-24137', 'imgIcon2'),
 'nudes': ('5-24149', 'imgRectangle3303'), 'jalebi': ('5-24149', 'imgRectangle3304'),
 'smoothie': ('5-24149', 'imgImage'), 'juices': ('5-24149', 'imgImage1'),
 'wrap': ('5-24149', 'imgImage2'), 'jalebi-cup': ('5-24149', 'imgImage3'),
 'jalebi-bowl': ('5-24149', 'imgImage4'), 'jalebi-curry': ('5-24149', 'imgImage5'),
 'card-curve': ('5-24149', 'imgVector154'),
 'grosso': ('5-24293', 'imgImage'), 'mayura': ('5-24293', 'imgImage1'),
 'heart': ('5-24293', 'imgIcon3'),
 'grocery-curve-top': ('5-24296', 'imgCurve'),
 'grocery-curve-bottom': ('5-24296', 'imgCurve1'),
 'store-badge-blob': ('5-24296', 'imgIconBlob'),
 'store-badge': ('5-24296', 'imgIcon1'),
 'store-promo-blob': ('5-24296', 'imgIconBlob1'),
 'store-promo': ('5-24296', 'imgIcon2'),
 'info': ('5-24439', 'imgIcon1'),
 'goiko': ('5-24439', 'imgRectangle3303'), 'popeyes': ('5-24439', 'imgRectangle3304'),
}
for name, (section, key) in mapping.items():
    filename = assets[section][key].split('/')[-1]
    shutil.copyfile(DEST / filename, DEST / (name + Path(filename).suffix))

photos = {
 'gonzalez-logo': 42, 'healthy-logo': 90, 'redant-logo': 56, 'elg-logo': 38,
 'honest-logo': 0, 'goiko-logo': 58, 'condis-logo': 50, 'dia-logo': 4,
 'caprabo-logo': 1, 'ametller-logo': 7, 'manolo-logo': 2, 'super-logo': 84,
 'glovo-logo': 94, 'carrefour-logo': 8,
 'friend-curry': 5, 'friend-burger': 82, 'friend-chicken': 46,
 'friend-wings': 47, 'friend-bowl': 61, 'friend-pizza': 40,
 'burrito': 54, 'caraquena': 36, 'pita': 25, 'burger': 31,
 'kiena': 88, 'kemako': 18, 'healthy-product-logo': 89, 'incheon-logo': 6,
}
for name, index in photos.items():
    source = REF / 'archive' / 'images' / originals[str(index)]
    ext = '.png' if Image.open(source).format == 'PNG' else '.jpg'
    shutil.copyfile(source, DEST / (name + ext))

source = Image.open(REF / 'figma-3x.png')
for name, (x, y, w, h) in {
    'nav-home': (36, 3600, 32, 32), 'nav-discover': (144, 3600, 32, 32),
    'nav-cart': (251, 3600, 32, 32), 'nav-profile': (359, 3600, 32, 32),
    'grocery-badge-exact': (56, 1950.208984375, 28, 28),
    'search': (32, 294, 24, 24), 'ordered': (16, 3246.208984375, 24, 24),
}.items():
    box = tuple(round(v * 3) for v in (x, y, x + w, y + h))
    source.crop(box).save(DEST / (name + '.png'))

# Keep a small, auditable manifest of the source for each asset.
(DEST / 'provenance.json').write_text(json.dumps({'figma': mapping, 'archiveImages': {
    name: originals[str(i)] for name, i in photos.items()
}, 'glyphs': 'Cropped from the original 3x Figma export, node 5:24131'}, indent=2))
print(f'Prepared {len(mapping) + len(photos) + 6} assets.')
