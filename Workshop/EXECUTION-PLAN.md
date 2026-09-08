# Workshop delivery plan

Goal: deliver a complete, practical, three-version skills workshop in 165 minutes, with editable slides and all learning materials available through Hatch on GitHub.

## Deliverables and sequence

1. Preserve the verified full project/deck backup and record the current Git index. Work on new workshop files; publish through an isolated checkout so existing staged work is preserved.
2. Write the teacher guide, student activities, exact prompts, and short presenter notes. Use one worked component to teach the method and reserve another section for transfer.
3. Create three actual reference skills: a brief baseline, an explicit checking procedure, and a compact structured skill with conditional references. Include invocation teaching examples and validation.
4. Produce a standalone participant app with all intended visual differences and information, no comparison route or answer-key imports. Package a source-free static download for the audit environment. Keep the instructor comparison and answer map separate.
5. Complete the existing presentation as editable PPTX and PDF files for GitHub. Preserve its style, illustrations, and personal TODO placeholders. Add private notes to the instructor deck and remove them from participant exports.
6. Prepare reference inputs, worksheets, startup instructions, and a working offline fallback. Make the repository's entry point a short participant guide.
7. Review three times: (a) teaching sequence and ambiguity, (b) simplicity and hands-on participation, (c) artifact completeness, technical behavior, presentation appearance, and evidence isolation. Record actual changes and limitations.
8. Publish the scoped changes to GitHub, verify the remote commit and downloads, and provide direct links.

Added output requirement: every skill produces an HTML discrepancy report. Version 1 chooses its own layout; version 3 follows the supplied Figma issue format at node `17:6587`: dark issue header, current behavior on the left, expected behavior on the right, matching evidence panels, and clear annotations. Test each actual skill on the same approved screenshot inputs and render its HTML. Organize and label the workshop Figma references after completing the artifacts, preserving the source designs.

## Completion criteria

- Every taught method has simple teacher actions, student actions, a prompt or manual procedure, an output to save, and a checkpoint.
- The 165-minute schedule includes its break and creates three skill versions total.
- Students work after short demonstrations and compare actual outcomes; no invented benchmark scores or guaranteed failures.
- Reference skills are usable files, have valid metadata, and contain no seeded answers.
- Participant app output matches the intended practice screen and preserves its information.
- Participant downloads exclude the reference implementation, answer map, private notes, and Git history. Strict blind runs require an isolated environment, because the repository also contains learning references and its old history may contain answers.
- Every slide is editable where it was editable in the source, the source style is retained, and personal content stays marked for Aswin.
- Links, scripts, builds, package contents, and the remote publication are verified.

## Status

- [x] Requirements review and full local backup
- [x] Comprehensive execution plan
- [x] Teacher guide, prompts, participant activities, and slide notes
- [x] Three skill files and references
- [x] Exercise packages and fallback
- [x] Completed instructor and participant presentations
- [x] Three simplification/evaluation passes
- [x] GitHub publication and remote verification

The original backup is at `/Users/aswin/Documents/1-Projects/Hatch Backups/2026-09-08_21-41-06_before-workshop-preparation`. It includes Git state and the original presentation. Personal introduction and project stories are the only intentionally unfinished presentation content. The event year remains as supplied: Hatch 2027.

Completed artifacts: [workshop entry](README.md), [full-day schedule](instructor/RUN-OF-SHOW.md), [teacher guide](instructor/TEACHER-GUIDE.md), [three review passes](instructor/EVALUATION.md), and [Figma organization](instructor/FIGMA-ORGANIZATION.md). The clean publication checkout preserves the existing local Git index.
