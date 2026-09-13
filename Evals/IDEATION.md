# Evals workshop: Tinder interview synthesis

## Objective

Teach designers what evals are by asking them to create a skill that synthesizes a fixed set of 20 synthetic user interviews about Tinder. Students will compare the skill's output with a reference answer, evaluate it themselves, and use LLMs as judges.

This phase defines the exercise. It does not generate the transcripts yet.

## The app

Use **Tinder**, an existing app whose central interaction is already familiar. Students should not need a fictional product explanation before they can reason about the research.

## Keep the research question narrow

Recommended question:

> What makes a Tinder match turn into a conversation—or disappear without one?

This is better than interviewing people about “their Tinder experience” in general. It gives every transcript a shared frame while leaving room for different behaviors, expectations, frustrations, and interpretations.

The interviews can cover:

- how people decide to swipe right;
- what they look at before sending a first message;
- who they expect to initiate;
- what makes an opening message feel engaging or generic;
- how profiles help or hinder conversation;
- why people stop replying;
- how safety, authenticity, effort, timing, and overwhelm affect behavior;
- the difference between what people say they want and what they actually do.

Keep the synthetic material non-explicit and avoid unnecessary sensitive personal data. The topic is matching and conversation behavior, not participants' intimate histories.

## The target output

Each student's skill should transform all 20 interviews into the same research readout:

1. a short executive summary;
2. five key findings;
3. evidence and participant IDs for every finding;
4. contradictions and minority perspectives;
5. design opportunities framed as hypotheses rather than certain solutions;
6. limitations and confidence.

The reference answer should establish the expected voice, level of specificity, structure, evidence threshold, and citation style.

## The most useful role for OpenRouter

OpenRouter should make the workshop **multi-model**, not merely generate the final prose. Its unified API can run the same skill against different model families without rebuilding the workflow for each provider.

The core experiment:

> Does the skill reliably produce a good research synthesis, or did it only happen to work with one model?

Run each student skill against three deliberately different model classes:

- a high-capability reasoning model;
- a fast, inexpensive model;
- an open-weight model.

Hide the model names during evaluation. Students score the outputs first and discover the models afterward. This separates output quality from model reputation and demonstrates that a skill can be robust, brittle, or model-dependent.

Do not lock the workshop brief to model names yet. Available models, versions, prices, and supported parameters change. At setup time, query OpenRouter's model catalog and choose current models that support the required context window and structured output.

## Creative workshop mechanics

### 1. Blind date with a model

Give each team three anonymous outputs—Model A, B, and C—produced from the same interviews and the same skill. Teams evaluate them before the model identities are revealed.

What it teaches: model choice is an experimental variable, and confidence in a brand name is not an eval.

### 2. Evidence graph

Require every model to return a structured evidence ledger alongside the prose:

```text
Participant -> source passage -> theme -> finding
```

Render this as a graph. Supported findings have several visible paths back to interviews. Unsupported claims appear as nodes with no source edge. Minority findings appear as small but legitimate branches instead of disappearing inside a majority summary.

What it teaches: a polished finding is not necessarily grounded.

### 3. The red-flag deck

Design a handful of known traps into the synthetic dataset:

- two participants with easily confused details;
- a memorable quote that represents only one person;
- a majority pattern with an important exception;
- conflicting statements from the same participant;
- a plausible product recommendation that nobody actually requested;
- participant counts that are easy to overstate.

Students do not initially see the answer key. Their evals should detect when the model merges people, promotes anecdotes to trends, erases contradictions, or invents evidence.

What it teaches: eval cases should be deliberately diagnostic, not just a collection of normal examples.

### 4. Cross-model jury

Use three different models as judges. Each judge receives the same rubric and structured scoring schema. Display their scores as a matrix:

| Output | Human | Judge A | Judge B | Judge C |
| --- | ---: | ---: | ---: | ---: |
| Model A output | — | — | — | — |
| Model B output | — | — | — | — |
| Model C output | — | — | — | — |

Students investigate disagreement rather than averaging it away immediately.

What it teaches: “LLM as judge” is itself a system that needs evaluation.

### 5. Judge-model affinity

Compare whether a judge systematically prefers the output of its own model family or a similar writing style. Keep generation and judging identities hidden until the end.

What it teaches: judges can have style preferences and correlated biases.

### 6. The one-interview shock

After teams finish their first synthesis, add one new interview containing a credible minority perspective that challenges a major finding. Rerun the skill and visualize what changed.

Good behavior: confidence shifts, wording becomes more nuanced, and the new evidence is acknowledged without erasing the other 20 interviews.

What it teaches: robustness includes responding proportionally to new evidence.

### 7. Shuffle test

Run the identical dataset again with interview order randomized and participant names replaced by IDs. Material conclusions should remain stable.

What it teaches: a synthesis should not depend strongly on document order, vivid names, or the last interview in the context.

### 8. Speed-dating iteration

Give teams three short rounds to improve their skill:

1. baseline run;
2. inspect failures and revise;
3. rerun on hidden cases.

Plot metric movement after each round. The goal is not the highest single score; it is demonstrating that a change to the skill caused a repeatable improvement.

## Visualizations that carry real meaning

Use a small workshop dashboard with four views:

1. **Evidence graph:** interviews to quotes to findings.
2. **Score heatmap:** outputs crossed with human and LLM judges.
3. **Human–LLM disagreement plot:** where human and automated ratings diverge.
4. **Iteration chart:** metric changes across skill versions.

Avoid word clouds. They are visually lively but weak evidence of whether a synthesis is accurate or useful.

## Evaluation dimensions

Separate the score into dimensions so a fluent answer cannot hide other failures:

- **Grounded accuracy:** Are claims supported by the interviews?
- **Citation correctness:** Do participant IDs and source passages actually support each claim?
- **Coverage:** Are the important patterns represented?
- **Minority preservation:** Are exceptions and underserved perspectives retained?
- **Contradiction handling:** Does the output acknowledge meaningful tension?
- **Structure:** Does it follow the required research-readout format?
- **Tone:** Is it clear, empathetic, appropriately cautious, and free from sensationalism?
- **Usefulness:** Do the implications help a designer decide what to investigate next?
- **Calibration:** Does certainty match the strength and quantity of evidence?

Some dimensions can be tested programmatically, some need human judgment, and some benefit from an LLM judge. Keeping them separate is part of the lesson.

## Recommended workshop shape

Use OpenRouter in three places:

1. **Generation:** run the student skill with three different models.
2. **Structured verification:** have a separate model extract claims, citations, and participant counts into JSON for comparison with the answer key.
3. **Judging:** use a cross-model jury, then compare it with students' own ratings.

The key creative concept is a **model dating experiment**: anonymous model outputs, evidence “red flags,” cross-model judges, and a reveal at the end. The Tinder theme makes the mechanics memorable, but every activity still teaches a genuine property of eval design.

## Next step before transcript generation

Create the hidden evidence blueprint first. It should define:

- the 20 participant profiles;
- the true recurring patterns;
- contradictions and minority findings;
- planted diagnostic traps;
- the claims that the reference synthesis should and should not make.

Only after that blueprint is fixed should the 20 interview documents be written. Otherwise, the reference answer will be reverse-engineered from loosely generated text instead of grounded in an intentional evaluation dataset.
