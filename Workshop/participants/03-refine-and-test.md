# Version 3: refine and test

Address one failure, clarify the trigger, organize a reference, and test a simplification. You have 25 minutes, then the transfer activity.

Use the shared inputs and evidence rules in [START-HERE](START-HERE.md). Save observations in [the worksheet](WORKSHEET.md). Copy only the relevant prompt and inputs into the agent. Every version produces a standalone HTML report.

## Anti-patterns

### Prompt or working template 1

```text
Improve design-qa-v3 using this failure example:
[paste one finding and explain why its evidence or wording is insufficient]

Propose one narrow rule that prevents this mistake and a positive instruction
for what to do instead. Explain where it fits in the workflow. After I review
it, merge it into the skill without duplicating existing rules.
```

### Your actions



## User-invoked or model-invoked

### Prompt or working template 1

```text
Review the trigger description for design-qa-v3. It should apply to comparing
a rendered interface with a supplied design reference, not general app
implementation or unrelated writing. Propose a concise description and three
example requests: a direct invocation, a natural matching request, and an
unrelated request. Do not run the audit.
```

### Your actions



## Structure the skill

### Prompt or working template 1

```text
Organize design-qa-v3. Keep its purpose, input requirements, evidence rules,
and short workflow in SKILL.md. Move the detailed visual checklist and any
interaction-only instructions into focused references. Link each reference
at the step where it is needed. Preserve behavior and remove duplication.
Use the supplied discrepancy-template.html and HTML report specification
for the output: a dark issue header, current and expected columns, and paired
embedded screenshot evidence. Save a standalone report.html that opens offline.
Do not add scripts unless the workflow actually needs them.
```

### Your actions



## Steer and prune

### Prompt or working template 1

```text
Review design-qa-v3 for repeated instructions, vague wording, and detail that
does not affect the workflow. Propose up to three simplifications. For each,
explain the behavior that must stay the same and a small test that could
detect a regression. Do not apply the changes yet.
```

### Prompt or working template 2

```text
Apply only the selected simplification and preserve a before copy outside
the active skill folder. Show the difference. Keep the evidence rules and
reference links intact. I will compare the before and after behavior in
separate audit tasks.
```

### Your actions

- 4 min: Add an anti-pattern rule and review the trigger.
- 4 min: Organize one reference and choose one simplification.
- 7 min: Compare before/after on a small screenshot pair and decide whether to keep the change.
- 8 min: Run the full version 3 audit with the same main-run inputs.
- 2 min: Save version 3 and its report, including unfinished areas.

## Transfer and close

### Prompt or working template 1

```text
Use design-qa-v3 on only the supplied Highly-rated newcomers section and its
matching reference. Use the same evidence rules. Do not read earlier reports.
Spend up to three minutes, then report verified findings and limitations.
```

### Your actions



## Save your checkpoint

Keep your skill folder, report.html or labeled partial output, and worksheet. Use the same model, viewport, state, scope, and budget in the next main run. Do not fix the app during the exercise.
