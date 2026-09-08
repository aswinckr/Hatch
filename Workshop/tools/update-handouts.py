"""Refresh student prompt excerpts from the teacher guide; no app or skill execution."""
from pathlib import Path
import re
base=Path(__file__).resolve().parents[1]
guide=(base/'instructor/TEACHER-GUIDE.md').read_text()
sections={int(n):body for n,body in re.findall(r'^## (\d+)\. ([\s\S]*?)(?=^## |\Z)',guide,re.M)}
rounds=[('01-one-shot.md','Version 1: one-shot',[1],'Create a first skill, run it in a fresh task, and verify one finding. You have 17 minutes.'),('02-teach-your-process.md','Version 2: teach your process',[2,3,4],'Explain your checks, demonstrate a component using matching images, then review a checklist. You have 24 minutes.'),('03-refine-and-test.md','Version 3: refine and test',[5,6,7,8,9],'Address one failure, clarify the trigger, organize a reference, and test a simplification. You have 25 minutes, then the transfer activity.')]
for filename,title,nums,intro in rounds:
 out=f'# {title}\n\n{intro}\n\nUse the shared inputs and evidence rules in [START-HERE](START-HERE.md). Save observations in [the worksheet](WORKSHEET.md). Copy only the relevant prompt and inputs into the agent. Every version produces a standalone HTML report.\n'
 for n in nums:
  body=sections[n];out+='\n## '+body.split('\n')[0]+'\n\n'
  if n==3:out+='Compare one matching component manually. Attach reference and app crops, then narrate at least three checks and record an observation. A voice transcript alone does not show the agent your screen.\n\n'
  if n==2:out+='Dictate or type the advice you would give a junior designer, including your checking sequence and a decision rule. Correct the transcript before sending it.\n\n'
  for i,block in enumerate(re.findall(r'```text\n([\s\S]*?)```',body),1):out+=f'### Prompt or working template {i}\n\n```text\n{block}```\n\n'
  students=re.search(r'\*\*Students do[^\n]*\n([\s\S]*?)(?=\n\*\*|\Z)',body)
  if students:out+='### Your actions\n\n'+students.group(1).strip()+'\n'
  else:
   inline=re.search(r'\*\*Students do[^*]*\*\*:? ([^\n]+)',body)
   if inline:out+='### Your action\n\n'+inline.group(1)+'\n'
 out+='\n## Save your checkpoint\n\nKeep your skill folder, report.html or labeled partial output, and worksheet. Use the same model, viewport, state, scope, and budget in the next main run. Do not fix the app during the exercise.\n'
 (base/'participants'/filename).write_text(out)
print('Updated three student handouts.')
