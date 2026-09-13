# Review agent workflow

When the user asks for a complete UX, conversion, or interface review, delegate the whole review to the project-scoped `review_orchestrator` custom agent.

- Give the orchestrator the live application URL and all relevant user constraints.
- Let the orchestrator spawn `ux_reviewer`, `conversion_reviewer`, and `ui_reviewer` concurrently, wait for them, and synthesize their independent reports.
- The orchestrator and reviewers are read-only and must not edit files.
- Require component scores, a calculated overall score, five prioritized improvements, a comparison of all three UI variants, the recommended variant, and an A/B testing plan.
- Require conversion improvements to be clearly labeled as hypotheses.
- Preserve disagreements and uncertainty instead of manufacturing consensus.
