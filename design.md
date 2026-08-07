---
version: alpha
name: Aswin Visual Taste
description: A living set of reusable visual principles built only from explicit design preferences.
omitted:
  - section: colors
    reason: No general color preference has been established yet.
  - section: typography
    reason: No general typography preference has been established yet.
  - section: spacing
    reason: No general spacing system has been established yet.
rounded:
  full: 9999px
components:
  floating-navbar:
    backgroundColor: "rgba(255, 255, 255, 0.90)"
    rounded: "{rounded.full}"
    height: 72px
    width: 236px
  floating-navbar-selected:
    backgroundColor: "rgba(244, 238, 231, 0.87)"
    rounded: "{rounded.full}"
  floating-primary-action:
    backgroundColor: "#B35B42"
    textColor: "#FFFFFF"
    rounded: "{rounded.full}"
    size: 64px
  primary-page-surface:
    backgroundColor: "#FFFFFF"
---

## Overview

This file grows only through explicit design choices. Record principles at a level that can guide decisions across products, platforms, and feature areas. Product-specific implementations may serve as evidence, but should not become universal rules unless the underlying preference is broadly applicable.

## Elevation & Depth

Floating controls should read as lightweight glass objects rather than heavy containers. Use background blur, a thin luminous border, and a soft diffuse shadow. Allow content to move behind translucent surfaces when doing so reinforces depth without reducing legibility.

## Page Surfaces

Prefer one continuous background color across a primary screen. Use white when the interface should feel clean, spacious, and content-led. Navigation, safe areas, scrolling regions, and the space behind floating controls should share that surface rather than forming separate horizontal bands.

## Shapes

Use simple geometric silhouettes to make persistent controls feel approachable and self-contained. Horizontal navigation may use a pill with fully rounded ends, with selection communicated by a softer nested shape rather than a hard divider.

## Components

### Floating navbar

- Float above the bottom safe area as a narrow centered capsule.
- Size the bar to provide only comfortable padding around its icons and labels; do not stretch it across the screen.
- Keep the surface translucent rather than opaque.
- Give persistent destinations equal visual weight unless product hierarchy clearly requires otherwise.
- Emphasize the selected destination with a softly tinted frosted segment, colored icon, and stronger label.
- Keep unselected destinations quiet but readable.
- Use a small restrained dot for unseen content without changing the component’s alignment.
- Preserve a minimum interactive height of 56px and expose selected state semantically.

### Floating primary action

- When a screen has one frequent, unmistakable action, place it in a circular floating button above persistent navigation.
- An icon-only action is appropriate when the symbol is widely understood; always provide an accessible semantic label.
- Use a distinctive accent fill and soft shadow to establish primacy without making the control oversized.
- Keep related alternatives available but visually secondary and closer to the content they affect.

### Image-led collections

- When saved items are inherently visual, let their imagery lead the home-screen hierarchy.
- Use a consistent grid, softly rounded imagery, and only the minimum metadata needed for recognition.
- Treat the empty state as part of the product experience: keep it calm, generous, and focused on the first meaningful action.
- Preserve clear hierarchy between collection browsing, the primary creation action, and secondary import or management actions.

## Do's and Don'ts

- Do use a single floating capsule for persistent navigation.
- Do use fully rounded ends on both the outer bar and selected segment.
- Do keep the number of destinations minimal.
- Do keep the capsule compact and content-sized.
- Do reserve a floating circular action for one clear, high-frequency primary task.
- Do let visual content lead when recognition is faster through imagery than text.
- Do carry a screen’s background through every edge and safe area.
- Don’t replace the translucent glass treatment with a full-width opaque system tab bar.
- Don’t make the floating capsule span the available screen width.
- Don’t use separate floating buttons when the elements represent persistent destinations.
- Don’t place multiple competing floating actions on the same screen.
- Don’t divide a continuous page into differently colored zones without a functional reason.
- Don’t turn a product-specific label, content type, or workflow into a universal design rule.
