---
name: flutter-ui-design
description: Translate wireframes, screenshots, mockups, sketches, Figma designs, or existing screens into working Flutter interfaces using an iOS visual design language. Use when implementing or restyling Flutter application UI while preserving the source design's information architecture and interactions.
---

# Flutter UI Design

Implement working Flutter interfaces from visual references using the bundled
iOS visual design language.

## Required context

Before changing UI code, read `references/design.md` completely. It is the
single source of truth for visual preferences. Inspect the supplied reference
and the Flutter app's component, token, routing, state, and test conventions.

When the target project does not already provide Outfit, copy
`assets/Outfit.ttf` using its native font setup and retain `assets/OFL.txt`
with the distributed font. Do not add the font if the user asks to preserve an
existing brand typeface.

If the design is a local image, inspect it visually. If it is an existing
screen, examine its live behavior as well as its source. Ask only when a
material interaction or content decision cannot be inferred from the design or
the project.

## Workflow

1. Extract the source's content hierarchy, layout regions, responsive intent,
   and interaction model. Preserve these unless the request says to change
   them.
2. Reuse existing Flutter primitives where possible. Prefer Cupertino widgets
   and iOS interaction conventions; retain an established Material component
   only when the existing app or a platform integration requires it. Add or
   refine tokens and components only when that makes the implementation more
   coherent.
3. Translate the source through `references/design.md`:
   - Use Outfit, the forest-green interactive accent, and fully rounded button
     geometry consistently.
   - Prefer continuous, quiet surfaces; use a compact translucent glass
     navigation capsule only where persistent destinations are needed.
   - Let imagery lead visual collections and give immersive artifacts the full
     available viewport when their content warrants it.
   - Apply editorial hierarchy and restraint without importing food, menu, or
     other product-specific content into unrelated interfaces.
4. Implement real, responsive Flutter widgets with semantic labels, accessible
   touch targets, focus behavior, selected and disabled states, and suitable
   empty, loading, and error states when those states exist in the product.
5. Use generated imagery only when the request needs a new visual asset. Do
   not replace an interface implementation with a flattened image.
6. Run `dart format`, `flutter test`, and `flutter analyze`, then perform a
   visual check in an iOS simulator, browser, or screenshot at the relevant
   viewport. If the app cannot be launched visually, report that limitation
   explicitly. Fix visible hierarchy, spacing, clipping, and contrast issues
   before handing off.

## Evolve the language deliberately

When the user explicitly gives a new visual preference that generalizes across
products, update `references/design.md` at the principle level and apply it to
the current UI. Keep product names, labels, content types, and one-off
workflows out of the shared language. Do not infer a new universal preference
from a single design request.

Lint `references/design.md` after changing it. Keep the skill instructions
focused on the workflow; keep evolving visual rules in the reference file.
