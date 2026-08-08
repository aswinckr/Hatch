# Visual Taste Capture Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create an evidence-based `design.md` that captures universal visual preferences separately from Favourite Menu decisions and remains easy to update after future design changes.

**Architecture:** Use one human-readable Markdown document at the project root as the canonical preference source. Each preference carries scope and confidence through its section placement, while evidence and change history prevent unsupported generalization.

**Tech Stack:** Markdown and Git.

## Global Constraints

- Keep universal taste separate from Favourite Menu-specific direction.
- Record approved choices, rejected alternatives, rationale, and tentative hypotheses.
- Do not promote a one-off project choice to a universal preference.
- Preserve preference evolution in a dated change log.
- Defer creation of the reusable skill.

---

### Task 1: Create the living visual taste document

**Files:**
- Create: `design.md`

**Interfaces:**
- Consumes: approved Favourite Menu design choices and `docs/superpowers/specs/2026-08-07-visual-taste-capture-design.md`.
- Produces: the canonical `design.md` preference source for future design updates and later skill creation.

- [ ] **Step 1: Write the initial document**

Create these exact top-level sections:

```markdown
# Visual Taste
## Taste profile
## Current project direction: Favourite Menu
## Preference evidence
## Avoidances
## Open hypotheses
## Change log
```

In Taste profile, state only preferences directly supported by explicit approval across multiple design decisions: favor focused, guided experiences; make progress visible; use limited meaningful choices instead of unrestricted customization; and keep output polished while interaction remains simple. Mark these as medium confidence because they originate from one product conversation.

In Current project direction, record the approved warm editorial palette, serif-led typography, restrained text-led printable output, prominent food photography during capture, three curated themes, subtle functional motion, mobile-first layout, and live menu construction.

In Preference evidence, tie each rule to an explicit Favourite Menu decision. In Avoidances, record crowded editor-style interfaces, price display, deep customization, and photo-album-like print output. In Open hypotheses, list preferences that require cross-project evidence. Add the initial dated change-log entry for 2026-08-07.

- [ ] **Step 2: Self-review the evidence boundaries**

Confirm every universal statement has either repeated approval evidence or an explicit medium-confidence qualifier. Confirm every Favourite Menu-only choice remains in the project section. Remove speculative personality claims and any instruction that would force future designs to copy the current palette or typography.

- [ ] **Step 3: Validate document quality**

Run:

```bash
rg -n 'TBD|TODO|FIXME|placeholder' design.md
git diff --check
```

Expected: the placeholder scan returns no matches and `git diff --check` returns no errors.

- [ ] **Step 4: Commit**

```bash
git add design.md
git commit -m "docs: capture initial visual taste profile"
```
