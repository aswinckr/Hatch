# Version 2: teach your process

Explain your checks, demonstrate a component using matching images, then review a checklist. You have 24 minutes.

Use the shared inputs and evidence rules in [START-HERE](START-HERE.md). Save observations in [the worksheet](WORKSHEET.md). Copy only the relevant prompt and inputs into the agent. Every version produces a standalone HTML report.

## Advise your intern

Dictate or type the advice you would give a junior designer, including your checking sequence and a decision rule. Correct the transcript before sending it.

### Prompt or working template 1

```text
Use my explanation below to improve design-qa-v2, copied from version 1.
Turn my practical judgment into clear checking steps. Keep the shared evidence
rules. Do not add facts about this particular app as reusable instructions.
Save the revision and show me the meaningful changes. Do not run an audit yet.

My explanation:
[paste the corrected voice transcript or typed explanation]
```

### Your actions

- In their own words, dictate or type the checks they would give a junior designer.
- Include one decision rule, such as how they distinguish a repeated pattern from an isolated difference.
- Read the generated instructions and remove anything they did not mean.

## Watch me work

Compare one matching component manually. Attach reference and app crops, then narrate at least three checks and record an observation. A voice transcript alone does not show the agent your screen.

### Prompt or working template 1

```text
I am going to demonstrate how I compare one component. Use the two attached
images and the observations I send. Do not audit the rest of the screen or
edit the skill yet. Keep track of my sequence of checks and the decisions I make.
```

### Prompt or working template 2

```text
Location: [section and component]
Reference: [what I can actually see]
App: [what I can actually see]
Result: match / difference / uncertain
Evidence: reference-card and app-card, [specific region]
Suggested correction, if justified: [plain visual instruction]
```

### Prompt or working template 3

```text
Extract a reusable checking procedure from my demonstration. Separate my
sequence of checks from the observations about this one card. Show me the
procedure first. Do not turn this card's contents or observed defects into
expected findings for other screens.
```

### Prompt or working template 4

```text
Add the reviewed procedure to design-qa-v2. Merge it with the existing checks
instead of appending a second copy. Keep the one-card findings out of the
skill. Do not run the full audit yet.
```

### Your actions

- Choose one component and make their own matching captures.
- Manually compare it, narrating or typing at least three checks and one observation.
- Give those images and observations to the authoring agent and ask it to extract the method.
- Correct the method before merging it into version 2.

## List 'em first

### Prompt or working template 1

```text
Using design-qa-v2, propose the checklist you would use before auditing.
For each item, name the region or component, the property being compared,
and the evidence needed. Do not report differences yet.
Keep the checklist usable during a short audit and avoid duplicate checks.
```

### Prompt or working template 2

```text
Add this checklist-first step to design-qa-v2. During a run, record whether
each check matched, differed, was not applicable, or could not be verified.
Require a standalone HTML report with Current behavior on the left and
Expected behavior on the right, each with matching screenshot evidence.
Keep the evidence rules. Save the skill without auditing the app yet.
```

### Your actions

- 4 min: Explain their checks and revise the copied skill.
- 6 min: Demonstrate one component and extract the method.
- 4 min: Review the checklist and save version 2.
- 8 min: Run version 2 in a fresh audit task with the same shared inputs.
- 2 min: Save report.html and select one finding for pair review.

## Save your checkpoint

Keep your skill folder, report.html or labeled partial output, and worksheet. Use the same model, viewport, state, scope, and budget in the next main run. Do not fix the app during the exercise.
