# Visual Taste Capture — Design

## Goal

Create a living `design.md` that captures the user’s visual design taste as product changes are made. The document will later become the source material for a reusable skill, so it must distinguish durable preferences from one-off project decisions and retain evidence for every inference.

## Structure

The document will contain six sections:

1. **Taste profile** — concise universal preferences supported by repeated evidence or an explicit user statement.
2. **Current project direction** — visual rules that apply specifically to Favourite Menu.
3. **Preference evidence** — approved choices and the concrete interface context that supports each preference.
4. **Avoidances** — rejected alternatives and why they were rejected.
5. **Open hypotheses** — tentative preferences that require more evidence.
6. **Change log** — dated summaries of material updates to the preference model.

## Evidence rules

- Record an explicit user statement as high-confidence evidence.
- Record an approved concrete design choice as project-specific evidence.
- Do not infer a universal preference from a single project choice.
- Promote a project-specific preference to the universal taste profile only when it repeats across contexts or the user explicitly generalizes it.
- Preserve rejected directions and their rationale; they are as useful to a future skill as approved choices.
- When a later choice contradicts an earlier rule, revise the rule and retain the evolution in the change log rather than silently overwriting history.

## Initial evidence source

Favourite Menu provides the first evidence set. Approved choices currently support a warm editorial direction, restrained restaurant-menu styling, serif-led hierarchy, price-free presentation, limited theme choices, mobile-first composition, progressive construction of an artifact, and subtle functional motion. These begin as project-specific preferences or open hypotheses, not universal rules.

## Update workflow

After each meaningful visual change:

1. Identify whether the choice was approved, rejected, or merely explored.
2. Update the relevant project rule.
3. Add evidence with the affected surface and rationale.
4. Update an avoidance when a direction was rejected.
5. Promote or revise a universal preference only when the evidence rule is satisfied.
6. Add a dated change-log entry when the preference model materially changes.

Minor implementation corrections that reveal no taste preference—such as fixing unreadable contrast—do not become preference evidence unless the user comments on the visual result.

## Future skill boundary

The eventual skill should use this document to guide visual decisions, explain which preferences are high confidence, and avoid repeating rejected directions. Creating that skill is explicitly deferred; this phase only builds and maintains the evidence base.
