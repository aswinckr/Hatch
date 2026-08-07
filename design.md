# Visual Taste

This is a living record of Aswin’s visual design preferences. It separates durable taste from project-specific choices and records the evidence behind each conclusion. Future updates should refine this document rather than silently replacing earlier conclusions.

## Taste profile

These preferences are supported by several approved decisions within one product conversation. They are **medium-confidence** until they repeat across other projects or Aswin explicitly confirms them as universal.

### Prefer focused, guided experiences

Favor a clear sequence of meaningful decisions over a dense workspace full of simultaneous controls. Each screen should have an obvious purpose and one dominant next action.

### Make progress visible

When users are creating something over several steps, show the artifact taking shape. The result should not be hidden until the final step; progress itself should provide motivation and orientation.

### Curate choices instead of exposing every option

Offer a small set of distinct, well-designed directions rather than unrestricted customization. Variants should feel meaningfully different and individually resolved.

### Keep interaction simple and output polished

The creation process should feel approachable even when the resulting artifact feels refined, expressive, and ready to share or print.

## Current project direction: Favourite Menu

These choices are approved for Favourite Menu. They are not universal rules.

### Overall character

- Warm, editorial, and quietly refined
- Inspired by boutique restaurant menus rather than generic productivity software
- Tactile enough to suggest paper, while remaining clean on screen
- Expressive through typography, spacing, and composition instead of decoration-heavy UI

### Color

- Default to warm cream paper, dark espresso text, and muted terracotta accents
- Use color sparingly to establish hierarchy and warmth
- Maintain a deliberate light appearance rather than inheriting system dark mode
- Alternative themes may shift the palette, but must remain coherent and print-oriented

### Typography

- Use an elegant serif for titles, dish names, and expressive hierarchy
- Use a restrained sans serif for controls, fields, and supporting interface copy
- Let typography carry the personality of the printable menu
- Preserve legibility for accented restaurant and dish names

### Composition

- Design mobile-first for iPhone portrait layouts
- Keep the Add Dish and My Menu destinations persistently available
- Begin the menu as an intentional empty artifact rather than a blank or broken state
- Divide content clearly into Breakfast, Lunch, and Dinner
- Omit empty meal sections from the final printed menu

### Photography and output

- Give food photography a prominent role during capture and review
- Keep the printable artifact text-led rather than turning it into a photo album
- Do not display prices
- Attribute each dish discreetly to its restaurant

### Choice and motion

- Offer three curated visual themes: Editorial, Modern, and Bistro
- Avoid freeform layout controls in the prototype
- Use motion only to explain analysis, completion, tab attention, or insertion into the live menu
- Keep transitions restrained and respect reduced-motion preferences

### Artifact-building behavior

- The My Menu tab begins empty and visibly grows as dishes are finalized
- A finalized dish appears immediately in its meal section
- The interface should gently draw attention to new additions without interrupting continued capture
- Editing, removal, theme selection, and printing belong beside the live artifact

## Preference evidence

| Preference | Evidence | Scope | Confidence |
| --- | --- | --- | --- |
| Guided creation over a menu-first canvas | Approved the guided mobile wizard after comparing it with camera-roll organization and a freeform menu canvas | Project; supports broader hypothesis | Medium |
| Visible artifact construction | Explicitly requested that the menu start empty in its own tab and update whenever a dish is finalized | Strong project evidence; supports broader hypothesis | High for project, medium universally |
| Curated variation | Approved three focused themes instead of deep customization | Project; supports broader hypothesis | Medium |
| Restaurant-style rather than journal-style output | Selected a polished restaurant menu without prices over a dining journal | Favourite Menu | High |
| Meal-based organization | Explicitly selected Breakfast, Lunch, and Dinner for a cross-restaurant collection | Favourite Menu | High |
| Mobile-first interaction | Selected mobile-first rather than desktop-first or split mobile/desktop editing | Favourite Menu | High |
| Warm editorial visual direction | Approved cream, espresso, terracotta, serif-led hierarchy, and restrained motion | Favourite Menu | High |
| Text-led printable artifact | Approved prominent photography during capture but restrained menu typography for print | Favourite Menu | High |
| Offline, believable prototype | Selected realistic mocked analysis rather than real external services | Prototype behavior, not universal visual taste | High |

## Avoidances

These directions were explicitly rejected or displaced by approved alternatives.

### Crowded editor-style interfaces

Avoid presenting many design controls at once on mobile. The experience should not resemble a desktop publishing tool compressed onto a phone.

### Freeform customization without strong defaults

Avoid open-ended styling controls when a small set of resolved themes can produce better outcomes with less effort.

### Price-led menu presentation

Do not include prices in Favourite Menu. The artifact celebrates memorable dishes rather than recreating a commercial transaction.

### Photo-album-like print output

Do not let photographs dominate the printable menu. Photography belongs in capture and review; print should feel typographic and composed.

### Hidden or delayed progress

Do not make users complete the entire collection before seeing the result. The menu should be visible from the beginning and update continuously.

### Uncritical system theming

Do not inherit appearance changes that undermine the intended art direction or readability. Platform conventions should support the design, not override its palette.

## Open hypotheses

These may reflect broader taste, but need evidence from other projects.

- Warm, tactile palettes may be preferred over cool or highly saturated product palettes.
- Editorial serif typography may be a recurring preference for expressive consumer products.
- Visible construction of the final artifact may be preferred across creative tools.
- A few opinionated themes may be preferred over extensive personalization in other domains.
- Restrained, functional motion may be favored over playful or decorative animation.
- Interfaces may be preferred when they borrow the visual language of the artifact being created.

## Change log

### 2026-08-07

- Created the initial taste profile from the Favourite Menu design process.
- Separated medium-confidence universal preferences from high-confidence project rules.
- Recorded explicit avoidances and tentative cross-project hypotheses.
- Established evidence and confidence as requirements for future updates.
