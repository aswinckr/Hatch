# Version 1: one-shot

Create a first skill, run it in a fresh task, and verify one finding. You have 17 minutes.

Use the shared inputs and evidence rules in [START-HERE](START-HERE.md). Save observations in [the worksheet](WORKSHEET.md). Copy only the relevant prompt and inputs into the agent. Every version produces a standalone HTML report.

## Let's one-shot this

### Prompt or working template 1

```text
Create an instruction-only skill called design-qa-v1 that compares a rendered
web app with a Figma screenshot reference and reports design differences as a standalone HTML file showing current and expected
behavior with screenshot evidence. Choose your own layout.
Follow the exercise rules already provided. Save the skill in my authoring
workspace. Do not run the audit or change the app yet.
```

### Prompt or working template 2

```text
Use design-qa-v1 and the exercise rules to compare this app with the reference.
App URL: [paste the supplied URL]
Reference: [attach the supplied images or paste the Figma frame link]
Viewport: 428 × 900 CSS pixels, browser zoom 100%.
State: initial discovery screen, search empty, no dialog open, no saved changes.
Scope: discovery page except Highly-rated newcomers, reserved for transfer.
Audit time budget: 8 minutes. Report what you verified before the budget ends.
Do not change the skill or the app. State any evidence or coverage limitation.
```

### Your actions

- Spend 3 minutes creating and saving their first skill.
- Spend up to 8 minutes running it in a fresh task.
- Spend 6 minutes saving the raw report and checking one claim against the two images.
- Write one sentence: “I want the next version to be better at ___.”

## Save your checkpoint

Keep your skill folder, report.html or labeled partial output, and worksheet. Use the same model, viewport, state, scope, and budget in the next main run. Do not fix the app during the exercise.
