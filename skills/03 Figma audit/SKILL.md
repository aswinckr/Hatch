---
name: design-reference-audit
description: Audit a web app against specified Penpot or Figma design frames, producing reproducible visual evidence and structured, actionable discrepancies. Use when comparing an implemented UI to a design reference; do not use for general UX critique without a reference design.
---

# Design reference audit

Compare only equivalent design and application states. Produce a repeatable evidence bundle and an audit report that distinguishes measured mismatches from reviewer judgment.

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
8. Re-run the same contract after fixes. Mark a result resolved only when its original comparison passes.

Read [the detailed workflow](references/workflow.md) for a full component/state pass. Read [the audit data reference](references/audit-data.md) before creating manifests, comparisons, or issues. Read [the report reference](references/report.md) when rendering or reviewing results.

## Required deliverables

Produce, or clearly identify, these artifacts:

- an audit contract and state matrix;
- design and app captures at identical capture settings;
- component mapping and comparison data;
- issue records with expected/current values, tolerance, result, evidence, and design/code locators;
- an audit report that separates `pass`, `fail`, `unavailable`, and `needs-review`;
- a run manifest with design revision/export, app revision, environment, and artifact paths.

Use pixel diffs as supporting evidence, not automatic truth: anti-aliasing, font rasterization, and deliberately responsive layouts require property comparison and reviewer judgment. Do not claim a mismatch is confirmed when design data, state equivalence, or component mapping is unavailable.
