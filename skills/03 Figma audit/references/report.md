# Audit report requirements

Render the report from the structured audit records. The report is a review artifact, not the source of truth.

## Summary

Show the design source and revision, implementation revision, state scope, capture environment, and counts for `pass`, `fail`, `unavailable`, `not-applicable`, and `needs-review`. State the pixel-diff method and its limits if one was used.

## Per issue

For each confirmed issue, show:

- stable ID, concise title, severity, component, and tested state;
- expected and actual component crops, plus overlay/diff when useful;
- a table of expected value, actual value, delta, tolerance, and result;
- design node URL/ID and implementation file/line/locator;
- a minimal recommended fix and any affected components;
- uncertainties or reviewer decisions.

Use one issue for a root cause. For example, a wrong shared elevation token should list every affected tile as evidence rather than generate an issue per tile.

## Reporting rules

- Never call an app-only or inaccessible design state a failure; report it as `unavailable`.
- Never use a pixel-diff percentage alone as proof of a visual defect.
- Preserve source screenshots and values; annotations must not replace original evidence.
- State whether values came from design metadata, measured pixels, browser computed style, or reviewer interpretation.
- Use `needs-review` when fonts, scale, state, responsive behavior, or component mapping make an automatic conclusion unreliable.
