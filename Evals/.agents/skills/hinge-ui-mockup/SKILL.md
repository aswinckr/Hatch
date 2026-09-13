---
name: hinge-ui-mockup
description: Turn a Hinge feature brief into one high-fidelity iOS mockup using bundled Hinge screenshots and Google Gemini 3 Pro Image through OpenRouter. Use when visualizing or iterating on a Hinge product feature. Requires OPENROUTER_API_KEY for generation.
---

# Hinge UI Mockup

## What this skill does

Input: a description of a Hinge feature or screen.

Output: one polished mobile UI mockup and a manifest containing the prompt, model, references, settings, and API usage.

The generator uses the screenshots in `assets/hinge-references/` and the rules in [references/design-language.md](references/design-language.md).

## Use it

In Codex:

```text
$hinge-ui-mockup Design an AI profile reviewer results screen with three prioritized recommendations and one primary action.
```

For a useful brief, describe:

- where this screen appears in the feature flow
- what the user should understand or do
- any content or actions that must appear

Request one screen at a time.

## Generate the mockup

1. Read the design-language reference.
2. Turn the feature brief into one clear screen state without changing the user's idea.
3. Run `scripts/generate_mockup.py --prompt "<feature brief>"`. The script automatically loads `.env` from the skill folder.
4. Inspect the image. If it misses the feature or visual language, retry with specific corrections.
5. Return the image and manifest. Keep every version instead of overwriting earlier work.

## Quality bar

- Make it look like a real Hinge iOS screen, not a poster or mood board.
- Make the feature and primary action immediately clear.
- Match the reference hierarchy, spacing, typography, surfaces, icons, and restrained accent colors.
- Keep visible text short and legible.
- Use fictional content. Never copy faces, names, photos, or profile answers from the references.
- Present AI recommendations as respectful guidance and preserve user control.

If the API key is missing, ask the user to configure `.env`. If the model returns garbled text, shorten the interface copy and retry.
