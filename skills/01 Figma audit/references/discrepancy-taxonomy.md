# Discrepancy Taxonomy

Use this guide to turn visual differences into actionable findings.

## Severity

- **P0 Blocker:** The screen cannot be evaluated or used: blank render, fatal error, wrong route, missing core content, unreadable text, or inaccessible primary action.
- **P1 Major:** A user-visible mismatch that changes meaning, task completion, visual hierarchy, or brand-critical appearance: wrong component, missing section, incorrect state, substantial layout shift, wrong image, clipped text, broken responsive behavior, or key interaction mismatch.
- **P2 Minor:** A visible mismatch that should be fixed but does not block comprehension or task completion: spacing off by a few pixels, slightly different radius/shadow, small typography mismatch, secondary copy difference, small icon alignment issue.
- **P3 Note:** Ambiguous or low-impact issue worth mentioning: likely asset-rendering difference, expected dynamic content, anti-aliasing, OS font rendering, or a design/code ambiguity.

## Categories

- **Content:** Text, labels, counts, prices, dates, ordering, truncation, missing or extra copy.
- **Layout:** Position, spacing, alignment, dimensions, scrolling, responsive breakpoints, sticky/fixed elements.
- **Typography:** Font family, size, weight, line height, letter spacing, text wrapping, baseline alignment.
- **Color and Effects:** Fill, stroke, opacity, elevation, blur, gradients, shadows, overlays.
- **Assets and Icons:** Image choice, crop, aspect ratio, icon glyph, asset resolution, missing masks, incorrect vector export.
- **Component State:** Selected, disabled, pressed, focus, loading, empty, error, hover, active navigation, modal/sheet state.
- **Behavior:** Interaction, animation timing, scroll snapping, keyboard behavior, route transitions, persisted state.
- **Accessibility:** Name/role/state mismatch, contrast risk, focus order, reduced-motion handling, hit target size.

## Report Shape

Lead with findings. For each discrepancy include:

- Severity and category.
- Where it appears in the screen.
- Expected Figma behavior or appearance.
- Actual app behavior or appearance.
- Evidence: screenshot path, diff artifact, DOM selector, code location, or Figma node when available.
- Suggested fix when the likely code change is clear.

End with tested viewport(s), commands run, artifacts generated, and any evidence gaps such as inaccessible Figma context, missing auth, dynamic data, or unverified interactions.
