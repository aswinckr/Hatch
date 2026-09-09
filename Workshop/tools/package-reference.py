"""Package only the compiled original app, independently of the exercise."""
from pathlib import Path
import zipfile
root=Path(__file__).resolve().parents[1]
dist=root/'exercise/reference-source/dist'
if not (dist/'index.html').is_file():raise SystemExit('Build reference-source first.')
with zipfile.ZipFile(root/'exercise/reference-app.zip','w',zipfile.ZIP_DEFLATED) as z:
 for p in sorted(dist.rglob('*')):
  if p.is_file():z.write(p,Path('reference-app')/p.relative_to(dist))
 z.writestr('reference-app/README.md','# Original reference app\n\nRun python3 -m http.server 5174 --bind 127.0.0.1 inside this folder, then open http://127.0.0.1:5174/. This app contains only the original screen.\n')
print('Packaged standalone reference app.')
