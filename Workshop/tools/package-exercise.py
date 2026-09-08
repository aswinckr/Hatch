"""Package the compiled participant site without app source, answers, or Git history."""
from pathlib import Path
import zipfile, shutil, json, hashlib
root=Path(__file__).resolve().parents[1]
dist=root/'exercise/participant-source/dist'
if not (dist/'index.html').is_file(): raise SystemExit('Build participant-source first with npm run build.')
readme='''# Design QA exercise app

This download contains only the compiled practice website and its assets.

1. Extract this folder outside the Hatch Git checkout.
2. In a terminal, enter this folder.
3. Run: python3 -m http.server 5173 --bind 127.0.0.1
4. Open http://127.0.0.1:5173/ in your browser.

On Windows, `py -m http.server 5173 --bind 127.0.0.1` may be the available command. If the port is occupied, choose another port and record the new URL. Stop the server with Ctrl+C.

Give the audit agent the URL and approved reference images, not this folder's compiled JavaScript or the source repository. A browser downloads compiled assets to display the app, so strict screenshot-only evaluation also requires appropriate tool and environment restrictions.

Use the teacher's agreed viewport and initial state. Do not fix the app. It is an intentionally imperfect exercise. Reset site data if you changed saved items, address, or cart before comparing runs.
'''
files=list(dist.rglob('*'))
for p in files:
 if not p.is_file():continue
 if p.suffix in ['.js','.css','.html']:
  s=p.read_text()
  for token in ['UX-01','practice-issues','INTENTIONAL-ISSUES','Compare.tsx','sourceMappingURL']:
   if token in s:raise SystemExit(f'Forbidden answer/source marker in {p.name}: {token}')
with zipfile.ZipFile(root/'exercise/participant-app.zip','w',zipfile.ZIP_DEFLATED) as z:
 for p in files:
  if p.is_file():z.write(p,Path('participant-app')/p.relative_to(dist))
 z.writestr('participant-app/README.md',readme)
(root/'exercise/START-APP.md').write_text(readme)
print('Packaged participant-app.zip and verified forbidden markers are absent.')
