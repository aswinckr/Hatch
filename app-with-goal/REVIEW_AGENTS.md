# UX review agents

This project contains one orchestrator and the same three read-only specialists for Codex and Claude Code:

| Role | Codex name | Claude Code name |
| --- | --- | --- |
| Review orchestration and synthesis | `review_orchestrator` | `review-orchestrator` |
| UX review | `ux_reviewer` | `ux-reviewer` |
| Conversion review | `conversion_reviewer` | `conversion-reviewer` |
| UI and layout review | `ui_reviewer` | `ui-reviewer` |

## Codex

Project definitions live in `.codex/agents/*.toml`. Start Codex from this project, then ask:

> Use `review_orchestrator` to review the app. Have it run all three specialists independently and return the scored synthesis.

The project `.codex/config.toml` enables four concurrent subagent threads so a spawned orchestrator and its three children can run together.

## Claude Code

Project definitions live in `.claude/agents/*.md`. Start Claude Code from this project, then ask:

> Use the `review-orchestrator` agent to review the app. Have it run all three specialists independently and return the scored synthesis.

You can also start it as the main Claude Code agent:

```sh
claude --agent review-orchestrator
```

This is the recommended invocation on Claude Code versions that predate nested subagents. The checked-in definitions use the legacy `Task(...)` spelling, which current Claude Code continues to accept as an alias for `Agent(...)`.

If `.claude/agents/` did not exist when the current Claude Code session started, restart that session once so the new directory is discovered.

## Designer skills

The reviewer prompts request these designer-skills when they are installed:

- UX: `information-architecture`
- Conversion: `metrics-definition`
- UI: `layout-grid`, `visual-hierarchy`, and `responsive-design`

If a required skill is unavailable, the reviewer must disclose that limitation rather than silently replacing it with another design skill.

## Scoring rule

The orchestrator calculates the overall current-interface score as the arithmetic mean of the UX, conversion, and UI current-interface scores, rounded to one decimal place. Proposed layout-variant scores are reported separately and never included in that average.
