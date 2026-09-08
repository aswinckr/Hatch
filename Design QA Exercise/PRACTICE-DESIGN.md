# Practice and comparison surfaces

This addition supports an observation and interface-audit exercise. The original discovery screen remains the reference at `/`; its Figma contract remains in `DESIGN.md`. This document covers only the practice copy and comparison surface.

## Routes and isolation

- `/`: original discovery screen.
- `/practice`: the shared discovery screen with 64 deliberate styling defects, exceeding the requested minimum of 25.
- `/compare`: both versions in separate iframes, with comparison controls and a collapsed facilitator answer key.

Practice overrides in `src/practice.css` are scoped to `.practice-copy`. The versions share images, fonts, content, and core actions. Saved restaurants, cart contents, and address use separate local-storage prefixes (`hatch` and `hatch-practice`) so interactions in one version do not overwrite the other. The base stylesheet and original design documentation remain unchanged.

## Comparison behavior

Above 760px, the comparison displays equal-width panes in a centered container capped at 920px, with a 24px gap. Each pane identifies its version and provides a link to open it full screen. Link scrolling is enabled initially and synchronizes vertical pixel positions between visible panes; it can be switched off. Back to top resets both embedded screens.

At 760px and below, the container is capped at 468px and shows one pane at a time. Original and Practice copy buttons switch the visible version, with Practice copy selected initially. The link-scrolling control is hidden, and hidden panes do not synchronize scrolling. The answer key changes from two columns to one. Iframe heights respond to viewport height with minimum heights that preserve usable screen space.

## Exercise content

The 64 numbered issues cover color, alignment, spacing, radii, incorrect shadows, hierarchy, and imagery details. All information and repeated icons remain visible. The grocery section has a cream rectangular background, all section arrows have no background, and review copy is 12px. Some differences require opening a detail panel or address form.

`src/practice-issues.json` supplies the comparison answer key; `INTENTIONAL-ISSUES.md` lists the defects and expected reference behavior. Keep the answer key closed during the exercise. These flaws are intentional training material, not design guidance or routine cleanup targets. Corrections should be made only when the exercise explicitly calls for them.
