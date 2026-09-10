# Reproducible component audit workflow

Use this procedure after the audit contract is defined. Keep the same contract for a baseline and every verification rerun.

## 1. Make the state matrix

For each design frame, list the screen state, component, and variant being compared. Include default, selected, focused, disabled, loading, empty, error, expanded, modal, carousel/overflow, and breakpoint states only where a reference design provides them. Give every row a stable `state_id`.

For each row, assign one of these scopes:

- `comparable`: a design and application state are both available;
- `unavailable`: the implementation state has no design reference, or the reference cannot be accessed;
- `not-applicable`: the state does not apply to the implementation;
- `needs-review`: the equivalence of the two states cannot be established automatically.

## 2. Stabilize the implementation

Use a clean browser context. Clear or seed local storage, session storage, cookies, and server fixtures as needed. Set the route, viewport, device-pixel ratio, zoom, locale, theme, authenticated identity, time, and feature flags from the contract. Wait for network idle where meaningful and for fonts and images to load. Disable animation, transitions, timers, and random content only if doing so does not change the referenced design state.

Record the start command, readiness condition, and reset actions in the run manifest.

## 3. Extract and capture

For the design, export a full-frame image and component crops at the agreed scale. Capture node ID, name, parent relationship, bounds, visible text, style values, effect values, and asset identifiers whenever the design tool exposes them.

For the app, capture the matching full page or viewport and component crops. Collect the mapped element's bounding box, computed style values, visible content, asset source, and source-code locator. Use stable test IDs when available; otherwise document the selector used.

## 4. Compare in this order

1. **State and structure:** visibility, order, text/content, asset identity, variant, and semantic state.
2. **Geometry:** x/y position, width, height, padding, margin, gap, alignment, crop, clipping, and layer position.
3. **Style:** fill, opacity, border, radius, shadow, typography, color, icon size, and effects.
4. **Pixels:** aligned expected/current captures and an overlay or heatmap.

Stop a row as `needs-review` when the component mapping, scale, or state is not equivalent. Do not turn an unmatched screenshot into a numeric style claim.

## 5. Record and triage results

Apply the declared tolerance policy property by property. Save the raw expected/current values even for passing checks. Group failures by root cause: a shared token or CSS rule should generally be one issue with multiple affected components rather than many duplicate issues.

Classify severity only after the deterministic comparison. Severity, user impact, and recommended fixes are reviewer conclusions; expected/current values and deltas are evidence.

## 6. Render the QA issue page

For every confirmed root-cause issue, select the smallest useful expected/current crops and store the per-side annotation bounds with the issue record. Copy `qa-audit-template.html` into the audit output directory, then populate it with one article for each issue. The template's sample articles and marks are illustrative: replace them, duplicate the article when more findings exist, and remove unused placeholders.

The page must reference preserved crop files and draw marks as HTML/CSS overlays. Do not bake boxes or labels into the evidence images. Keep unavailable and needs-review records out of the annotated issue list; summarize them as scope limitations.

## 7. Verify fixes and archive

Run the original state matrix and contract again after a change. Preserve the original artifacts and add a new run manifest instead of overwriting them. A baseline changes only when the design revision intentionally changes and the report records that reason.
