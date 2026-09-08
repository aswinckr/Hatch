"""Validate the published handout without reading any exercise answer key."""
from pathlib import Path
import re,json,zipfile,hashlib,xml.etree.ElementTree as ET
root=Path(__file__).resolve().parents[1]
errors=[];checked=0
for p in root.rglob('*.md'):
 if any(x in p.parts for x in ['node_modules','rehearsal']):continue
 for raw in re.findall(r'\[[^\]]*\]\(([^\)]+)\)',p.read_text()):
  if raw.startswith(('https:','http:','mailto:','#')):continue
  target=raw.split('#')[0].split(' "')[0].strip('<>')
  if not target:continue
  from urllib.parse import unquote
  if not (p.parent/unquote(target)).exists():errors.append(f'Broken link: {p.relative_to(root)} -> {target}')
  checked+=1
with zipfile.ZipFile(root/'exercise/participant-app.zip') as z:
 names=z.namelist(); forbidden=[n for n in names if any(t in n for t in ['node_modules/','/.git/','/src/','Compare','INTENTIONAL','practice-issues','.map'])]
 if forbidden:errors.append('Participant ZIP contains forbidden files: '+str(forbidden))
 z.testzip()
slides={}
for who in ['instructor','participant']:
 with zipfile.ZipFile(root/f'presentation/Hatch-workshop-{who}.pptx') as z:
  ns=z.namelist(); count=sum(bool(re.fullmatch(r'ppt/slides/slide\d+\.xml',n)) for n in ns)
  notes=''.join(z.read(n).decode() for n in ns if re.fullmatch(r'ppt/notesSlides/notesSlide\d+\.xml',n))
  private='PRIVATE' in notes
  slides[who]={'slides':count,'has_private_notes':private}
  if count!=51:errors.append(who+' slide count')
  if private!=(who=='instructor'):errors.append(who+' note separation')
for v in [1,2,3]:
 p=root/f'skills/design-qa-v{v}/SKILL.md';s=p.read_text()
 if not s.startswith('---\n') or f'name: design-qa-v{v}\n' not in s or 'description:' not in s:errors.append(f'Invalid metadata v{v}')
 if 'HTML' not in s and 'html' not in s:errors.append(f'Missing HTML output v{v}')
report={'relative_links_checked':checked,'slides':slides,'participant_zip_files':len(names),'errors':errors,'passed':not errors}
out=root/'instructor/validation/package-checks.json';out.parent.mkdir(exist_ok=True);out.write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))
raise SystemExit(bool(errors))
