# Three preparation and evaluation passes

Completed 8 September 2026. These are preparation checks, not measured audience outcomes.

## Pass 1 — Teaching sequence and completeness

Changed the workshop to exactly three skill versions over 165 minutes. Kept the first run short and allocated more time to demonstrating judgment and pruning. Mapped each method to teacher actions, student actions, exact prompts/manual steps, saved outputs, and a checkpoint. Reordered anti-patterns into version 3. Retained the original visual teaching style and personal TODO placeholders.

Outcome: the eight methods form one exercise rather than eight unrelated demonstrations. A full-day run of show connects the earlier tool exercises to the afternoon skill lab.

## Pass 2 — Simplicity and participation

Removed duplicated one-shot framing, reduced projected explanations to one message, and moved detailed procedures into presenter notes and the teacher guide. Released participant instructions in three short round handouts. Kept the demo to one component and reserved a section for transfer. Added prediction, pair evidence review, a ten-minute break, and fallback activities during model waiting time. Version 3 moves optional detail into linked references; the HTML example is loaded where reporting happens.

Outcome: students create, run, inspect, and revise in every round. No first-run failure or final perfection is scripted. Optional discussion is the first time-saving lever, not removal of practice.

## Pass 3 — Actual artifacts and evidence

All three actual skill files passed the skill-creator metadata validator. Independent fresh test tasks received only their version and approved screenshots. Their raw HTML and notes are preserved in the instructor package.

The first test inputs contained a capture-state mismatch: the browser's fixed navigation appeared at the viewport boundary while the long Figma frame placed it at the design bottom. Those diagnostic runs remain preserved but are not used as matched comparisons. The corrected tests use the same 428 × 735 upper-page crops, exclude the overlay, and allow five minutes per run.

| Test | Actual result | Interpretation |
| --- | --- | --- |
| V1 matched | 7 grouped visual findings, standalone HTML | Baseline chose its own layout. |
| V2 matched | 9 visual findings, paired evidence | More explicit checking and coverage. |
| V3 matched | 8 grouped findings, Figma-style cards | Current left, Expected right, screenshot windows, correction and limitations. |
| V3 clean control | 0 discrepancies; all decoded pixels identical | Did not manufacture issues for identical inputs. |

Counts are not accuracy scores. Runs used the same inherited model, not a controlled comparison of cheap models. Tests cover only the supplied crop, not all seeded page differences or live interactions. They do not establish recall, performance across repeated trials, or generalization to other products. The actual participant model and full-page capture workflow still need event-day rehearsal.

All three matched HTML reports were opened in the browser. At effective CSS widths of 914 and 393 pixels, they had no horizontal overflow; embedded evidence rendered, and narrow layouts stacked. V3 follows the provided discrepancy frame without copying its unrelated sample issue or branding. Raw reports were not rewritten to improve the apparent result.

The participant app built successfully. Its visible text matched the original practice route, and search, detail dialog, saving, and empty-cart behavior were checked without page errors. Production/reference screenshots differed only slightly in rasterization (mean channel delta 0.003763/255); this is not a claim of byte-identical rendering. The static ZIP excludes answer-map imports, source maps, source files, and Git history. Strict evidence isolation still requires restricting the audit environment.

The 51-slide editable deck passed package integrity, geometry/heading checks, and first-party re-import. Every slide was rendered into the PDF and visually reviewed in contact sheets. No clipping was visible; the source illustrations and serif-led style were retained. The participant deck has no teacher note text. About Me and My Projects are intentionally left for Aswin.

The instructor package was encrypted and decrypted, and the recovered ZIP hash matched. The recovered instructor app and the published participant source both passed a fresh dependency install and production build. Final link, ZIP-content, note-separation, and publication checks are recorded in `validation/package-checks.json` and the delivery manifest.

## What to evaluate with participants

Have a partner verify one claim against the paired images, identify one unchecked region, and explain the next action. Compare useful supported findings, unsupported claims, duplicated findings, clarity, and coverage. Do not grade skill quality by length or issue count alone. Record one instruction deletion and the behavior of the resulting fresh run.
