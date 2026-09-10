---
name: design-reference-audit
description: Audit a web app against specified Penpot or Figma design frames, producing reproducible visual evidence and structured, actionable discrepancies. Use when comparing an implemented UI to a design reference; do not use for general UX critique without a reference design.
---

# Design reference audit

Compare only equivalent design and application states. Produce a repeatable evidence bundle and an audit report that distinguishes measured mismatches from reviewer judgment. The human-facing issue report must be rendered from the bundled [QA audit HTML template](references/qa-audit-template.html), with real captures and CSS callouts rather than a custom report layout.

## Start with an audit contract

Before inspecting the UI, record the design URL and target frame/node, implementation URL and route, state, viewport, device-pixel ratio, browser, zoom, theme, locale, and code revision. Reset or seed any persisted app state so the capture can be rerun. If a required input is missing, make the smallest reasonable assumption and state it in the report.

Treat an application state with no corresponding design reference as `unavailable`, not a visual failure. Do not infer hidden states or expected values from a screenshot when inspectable design data is available.

## Audit workflow

1. Build a state matrix covering every referenced screen, component, and supplied variant. Include interactive states only when the design supplies them.
2. Extract the design frame, node metadata, component crops, dimensions, styles, effects, typography, and assets. Use the available Penpot/Figma access method; preserve node IDs and export revision information.
3. Start the app, wait for fonts and images, freeze animation and nondeterministic content where possible, then capture the defined state at the contract viewport.
4. Map each design component to an implementation locator and source location. Verify the mapping before comparing details.
5. Compare structure, then geometry, styles, assets, and finally aligned visual pixels. Use the same property set and tolerances for every comparable component.
6. Generate expected/current crops plus an overlay or diff visualization for material mismatches. Record raw values and deltas; do not rely on screenshots alone.
7. Group symptoms with the same root cause into one issue. Report evidence, source references, and a constrained recommended fix.
8. Copy and populate the QA audit template to create the human-facing issue report. Add one article per root-cause issue and annotate the expected and current captures where the discrepancy appears. Keep the original captures unmodified; the callouts must be HTML/CSS overlays.
9. Re-run the same contract after fixes. Mark a result resolved only when its original comparison passes.

Read [the detailed workflow](references/workflow.md) for a full component/state pass. Read [the audit data reference](references/audit-data.md) before creating manifests, comparisons, or issues. Read [the report reference](references/report.md) and [the QA audit template](references/qa-audit-template.html) before rendering or reviewing results.

## Required deliverables

Produce, or clearly identify, these artifacts:

- an audit contract and state matrix;
- design and app captures at identical capture settings;
- component mapping and comparison data;
- issue records with expected/current values, tolerance, result, evidence, and design/code locators;
- an audit report that separates `pass`, `fail`, `unavailable`, and `needs-review`;
- a run manifest with design revision/export, app revision, environment, and artifact paths.

Use pixel diffs as supporting evidence, not automatic truth: anti-aliasing, font rasterization, and deliberately responsive layouts require property comparison and reviewer judgment. Do not claim a mismatch is confirmed when design data, state equivalence, or component mapping is unavailable.

## QA issue page

Use `references/qa-audit-template.html` as the starting point for the HTML issue page. Copy it into the audit output directory (for example, `audits/<audit-id>/qa-issues.html`) so the skill reference stays reusable. Do not substitute a bespoke report page merely because the audit has additional metadata or more than two findings.

Populate the template as follows:

- Replace every `{{...}}` token and placeholder image. Duplicate the sample `article` for each confirmed root-cause issue, use its stable issue ID as the anchor, and delete unused samples.
- Place the expected and current crops side by side. Their `src`, intrinsic dimensions, and `alt` text must point to preserved evidence files relative to the generated page; never embed an altered screenshot just to show a highlight.
- Add `.mark` elements as CSS overlays on the relevant area in each capture. Record their normalized `left`, `top`, `width`, and `height` values in the issue data. Use independent bounds on the two sides when the comparable region moved or changed size. A mark explains a confirmed difference; it is not proof by itself.
- Keep annotation bounds tight and use more than one mark only when a single issue has distinct, related manifestations. Do not use a page-sized box for an issue that can be localized.
- Write the expected/current descriptions in plain language, and retain measured values, tolerance, design node ID/URL, implementation locator/source, and the minimal recommendation in the issue's source-evidence disclosure or linked structured data.
- Only render confirmed `fail` issues as issue articles. Summarize `pass`, `unavailable`, `not-applicable`, and `needs-review` in the page header/footer or linked report; never turn them into annotated failures.

The generated HTML is a review surface, not the source of truth: keep its issue IDs, image paths, and annotations traceable to the structured issue records and run manifest.
