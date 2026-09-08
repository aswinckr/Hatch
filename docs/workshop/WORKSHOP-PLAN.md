# Hatch workshop preparation plan

Updated: 8 September 2026

## Confirmed brief

The workshop runs for a full day. The skills section uses a design QA exercise for 2.5–3 hours, with three skill versions total, including the initial one-shot. The aim is to teach designers how to turn their judgment into reusable instructions. Each version should introduce a useful technique they can apply to another task.

The first version may work reasonably well. The third version may still miss issues. Demonstrate actual results and discuss what the instructions changed. Do not manufacture failure or promise perfect coverage.

Preserve the presenter's existing teaching style: one message per slide, brief explanations, and substantial practical work. Keep a relevant slide on screen while demonstrating or while participants work. Detailed instructions belong in presenter notes marked `PRIVATE — PRESENTER ONLY` and the instructor guide, not in dense projected slides. Keep those notes out of participant exports. Speaker notes are not an access-control boundary for people who can access the instructor deck.

Personal introduction, biography, and project stories remain placeholders for Aswin. Use the existing About Me and Projects slides with a short TODO or an empty content area. Do not research or invent a personal narrative. Complete the instructional narrative around those placeholders.

## Current status

This is the preserved planning record. The completed materials and current delivery status are in [Workshop](../../Workshop/README.md) and its [execution plan](../../Workshop/EXECUTION-PLAN.md).

Original deck: https://docs.google.com/presentation/d/1BbLX-yzhnm64zwGhqZCiI_G9zxLpsJ2yy-KKys0ke0E/edit

## Backup and recovery

Backup directory: `/Users/aswin/Documents/1-Projects/Hatch Backups/2026-09-08_21-41-06_before-workshop-preparation`

The backup contains a complete copy of Hatch, including `.git`, staged and unstaged work, untracked files, dependencies, Flutter projects, skills, app assets, and hidden files. All 6,550 regular-file and symlink entries were verified against the source after copying. Regular files total 953,421,227 bytes. `file-manifest.json` records hashes and symlink targets. `RESTORE.md` explains retrieval.

The `presentation` directory contains an editable PPTX export and a PDF snapshot of the original 50-slide deck. The original Google Slides file remains unchanged. The exports do not preserve native Google revision history or guarantee every Google-specific feature.

Keep backups outside the participant package and outside the audit agent's accessible environment. A separate folder within the same unrestricted workspace is not sufficient isolation.

## Recommended timing: 165 minutes

Use unequal blocks so the first attempt is short and later rounds have room for demonstration, practice, and discussion. Timing includes the skills introduction and transitions. It does not allocate the rest of the full-day workshop.

| Elapsed time | Block | Purpose |
| --- | --- | --- |
| 0–40 min | Version 1: Let's one-shot this | Establish a baseline and learn to evaluate what the skill actually produces |
| 40–95 min | Version 2: Teach your process | Explain and demonstrate personal judgment, then turn it into a checklist |
| 95–105 min | Break | Ten minutes away from the exercise |
| 105–165 min | Version 3: Make it reusable | Add boundaries, organize instructions, prune, and test in a fresh task |

For 150 minutes, shorten each version by five minutes using optional sharing and discussion time. Retain the break, hands-on practice, and the final transfer check. For 180 minutes, add 15 minutes for participant troubleshooting and questions. Do not add more concepts simply to fill the longer slot.

### Version 1: Let's one-shot this — 40 minutes

- 5 min: Frame the task and recap what a skill is. Show the Figma reference and participant screen. Establish the common evidence rules for every version.
- 8 min: Presenter creates the first skill from a short request and runs it. Explain only what participants need to begin.
- 17 min: Participants create and run their own version. Save the skill and its unchanged output.
- 10 min: Compare a few findings against the visible reference. Discuss unsupported claims, useful findings, missed areas, and whether another person could act on the report.

Transferable lesson: a short request leaves procedural choices to the model. Evaluate the resulting behavior before deciding what to teach it.

Participant artifact: version 1 of the skill, its original report, and a short note identifying one behavior to improve. Do not require a polished report format yet.

Private presenter outline:

> Okay, let's ask it to do the job. I'm going to keep the request short. Then we'll look at what it actually did. Pick one finding: can you see the difference it is talking about? Would you know what to fix from this description? Keep this result. We will come back to it.

### Version 2: Teach your process — 55 minutes

- 8 min: **Advise your intern.** Narrate the checks in everyday language, using voice input if useful. Show how that explanation expands the instructions.
- 10 min: **Watch me work.** Manually compare one component in Figma and the app. Narrate the order of checks, the evidence, and how to express a finding.
- 5 min: **List 'em first.** Ask for a checklist before execution. Review whether the checklist covers the process that was demonstrated.
- 24 min: Participants teach their own process, revise the skill, and run it again in a fresh audit task. Carry only the revised skill, reference, app URL, and common task inputs into that run.
- 8 min: Review the difference between versions. Inspect coverage and usefulness, not just the number of findings.

Transferable lesson: an explanation and a worked example reveal the decisions that a broad instruction leaves implicit. A checklist makes coverage reviewable before execution.

Participant artifact: version 2, a checklist, a second report, and a short description of the instruction change that helped or did not help.

Private presenter outline:

> Imagine you hired an intern to do this. What would you tell them to look at? I'm going to explain it out loud first. Now I'll do one card myself so you can see the order. Before we run the skill again, let's ask it to list what it plans to check. Is anything missing from that list?

Keep the worked example small. Let the model apply the method to other components. Avoid supplying an inventory of seeded defects.

### Version 3: Make it reusable — 60 minutes

- 7 min: **Anti-patterns.** Use examples from the reports to explain what to avoid: guessed measurements, unsupported findings, duplicated findings, and confusing a visual mismatch with demonstrated usability harm.
- 8 min: **Invocation and structure.** Explain when a person should deliberately invoke the skill and when automatic selection is useful. Show the main workflow and supporting references. Verify actual platform settings when preparing the artifacts.
- 10 min: **Steer and prune.** Remove repeated or ineffective instructions. Demonstrate a deletion test on one passage rather than reducing length blindly.
- 25 min: Participants revise and run version 3 in a fresh task. Compare results with earlier versions. Preserve the evidence boundary across all runs.
- 10 min: Try a withheld section or a separate example, discuss remaining limitations, and name a different task each participant could teach this way.

Transferable lesson: a reusable skill needs a clear trigger and evidence rules, an organized procedure, and instructions that earn their place through observed behavior.

Participant artifact: version 3 with any supporting references, a third report, a comparison worksheet, and one next-use idea.

Private presenter outline:

> We have more instructions now. Let's check which ones are doing useful work. What did it get wrong, and what rule would prevent that? Which detail belongs in a reference? If I remove this paragraph, does the behavior change? Then let's give it another example and see what carries over.

## Presentation approach

Retain the existing visual style, typography, illustrations, and simple compositions. Reuse existing teaching slides where possible. Avoid turning the artifact list into extra projected slides.

The instructional narrative is:

1. Personal introduction and project examples: TODO for Aswin.
2. The intern question: identify a repeatable task the participant already understands.
3. Existing tool exercises: experience what a skill and the surrounding tools let an agent do.
4. Skills introduction: connect those exercises to reusable instructions and the anatomy of a skill.
5. The QA task: establish the shared reference, screen, and evidence rules.
6. Three versions: run, teach, and refine, with practical work inside each block.
7. Transfer: choose a real task to apply the same teaching methods to after the workshop.

### Changes to the existing deck to prepare

| Existing slides | Planned treatment |
| --- | --- |
| 5–6: About Me and Projects | Leave editable placeholders or short TODO text for Aswin |
| 7: Agenda | Complete with the full-day sequence and a 2.5–3 hour skills block, without inventing start times |
| 8–12: Setup and starter project | Verify prerequisites and links against the final exercises; remove legacy requirements only if they are no longer needed |
| 13–30: Tools and exercises | Preserve the practical rhythm and add concise private facilitation notes where needed |
| 31–38: Skills introduction | Connect the earlier exercises to teaching a skill; avoid running an additional lengthy one-shot before the QA baseline |
| 39–41: Design QA and one-shot | Frame version 1 and leave its exercise slide on screen during participant work |
| 42–46: Teaching methods | Teach advice, demonstration, and checklist preparation in version 2; use the anti-patterns concept in version 3 |
| 47–50: Customization | Connect invocation, structure, and pruning to participants' own skill files |
| Closing | Add a concise transfer/takeaway slide if the existing deck has no suitable ending |

Leave the relevant concept or exercise slide projected during practical work. Do not add slides for every substep. A break slide is optional.

### Private presenter-note format

Each practical slide gets this outline in the instructor deck's speaker notes and facilitator guide:

```text
PRIVATE — PRESENTER ONLY

Time:
What I am teaching:
Say:
Show or do:
Participants do:
What they should save:
What to listen or look for:
Debrief question:
If the demo fails or time runs short:
```

Use natural, concise outlines in the presenter's voice. Avoid a word-for-word script for every action. Keep answer keys and complete examples in instructor materials. Make a separate participant export that excludes private notes and facilitator-only slides.

## Artifacts to prepare

| Artifact | Audience | Contents and completion condition |
| --- | --- | --- |
| Recoverable backup | Instructor only | Full local snapshot, original deck exports, manifest, and restore instructions; complete |
| Revised Google Slides draft | Instructor | Existing style, completed teaching narrative, editable personal placeholders, practical slides, private speaker notes |
| Participant deck or handout | Participants | Exercise instructions and shared concepts, without private notes or answers |
| Facilitator guide | Instructor | 165-minute schedule, exact demo sequence, spoken outlines, checkpoints, setup, fallback paths |
| Finished demo package | Instructor | App comparison, reference, three prepared skill versions, supporting resources, and private evaluation materials |
| Participant starter package | Participants | Standalone practice app or hosted URL, shared inputs, instructions, empty work areas and worksheets; no completed skill or answer key |
| Version 1 materials | Instructor and staged participant release | Short creation prompt and baseline checkpoint; recorded outputs must come from actual runs |
| Version 2 materials | Instructor and staged participant release | Voice explanation outline, one-component demonstration, checklist preparation prompt, revised skill example |
| Version 3 materials | Instructor and staged participant release | Anti-pattern examples, invocation and organization exercise, deletion test, final skill with references |
| Report and comparison worksheets | Participants | Evidence-backed findings, uncertain or unchecked areas, changes between versions, and transfer reflection |
| Evaluation key and rehearsal record | Instructor only | Seeded issue map, grouping rules, false positives, misses, evidence quality, and honest outcomes for each run |
| Fallback pack | Instructor, with selected participant inputs | Figma screenshot reference, saved real demo outputs, local app instructions, and recovery steps for connection or tool problems |
| Repository guide | Instructor | Clear folder purpose, local archive location, startup instructions, and participant distribution instructions |

The finished and unfinished packages describe preparation level. The participant app intentionally retains its visual defects. Do not accidentally hand participants a corrected screen.

## Evidence and fair comparison

- Use the same reference, app state, viewport, model, and run budget across the three primary comparisons where practical. Record any variation.
- Choose an affordable available model during preparation. Verify access and cost rather than hardcoding a current price in teaching materials.
- Use Figma to obtain the reference screenshots. Use screenshots and browser interactions to assess the app. Do not let the audit task inspect app source, CSS, DOM attributes, network payloads, source maps, answer keys, or Git history.
- Keep the common evidence rules in the exercise setup for all three versions. They are not an advantage introduced only in the final skill.
- Separate skill authoring from audit execution. Authoring can edit the skill. A fresh audit task gets the skill and approved inputs, not prior reports or this conversation.
- Create a distribution that contains no answers. Merely opening the practice route does not prevent a bundled answer key from being read.
- Remove original/comparison routes and answer-key imports from the participant build. Inspect the built output and confirm the displayed content still matches the intended practice screen.
- Use actual tool restrictions or a separate environment for a strict blind assessment. Prompt instructions alone are not guaranteed isolation when the agent can access the repository and other local files.
- Group repeated defects sensibly. Distinguish visual fidelity from tested interaction problems and inferred usability impact. Do not tell the audit agent the seeded issue count or require a target number of findings.
- Freeze each report before private grading. Test transfer using a withheld section or unseen example and include a clean control when rehearsing.

## Preparation task list

- [x] Review the supplied requirements and all 50 slides.
- [x] Capture the 2.5–3 hour target, three versions, sparse slide style, and personal placeholders.
- [x] Back up the complete local project and export the original presentation.
- [x] Verify the local backup and write recovery instructions.
- [ ] Inventory the existing exercises and skills before cleanup; map any links that depend on their paths.
- [ ] Finalize the practical sequence using the timing and learning objectives above.
- [ ] Prepare instructor and participant app packages with clearly different access and distribution rules.
- [ ] Verify that the participant bundle contains no answer keys or reference implementation, and visually compare it with the existing practice screen.
- [ ] Prepare the three skill versions, exact creation/revision prompts, demonstration examples, worksheets, and supporting references.
- [ ] Prepare the facilitator guide and private evaluation/fallback materials.
- [ ] Update a working copy of the Google Slides deck, preserving the original, with private notes and personal TODO placeholders.
- [ ] Check every revised slide for visual fit and every participant export for private-note leakage.
- [ ] Rehearse the three versions, record genuine results, and adjust timeboxes around actual tool speed.
- [ ] Archive superseded Flutter and skill materials only after checking dependencies and the verified backup.
- [ ] Organize Hatch and document how to restore archived material and run each package.
- [ ] Reconcile existing Git changes deliberately; keep unrelated staged work separate from workshop changes.

## Remaining placeholders

Aswin supplies the personal introduction and project stories later. The exact full-day start time, lunch arrangement, and timing of the earlier tool exercises are not specified. Keep these editable without delaying the skills-section draft.

The source deck is named Hatch 2027. Retain that name until the event year is confirmed rather than silently renaming it.
