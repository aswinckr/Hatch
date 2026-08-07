---
version: alpha
name: Aswin Visual Taste
description: A living visual identity built only from explicit design preferences.
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
---

## Overview

This file grows only through explicit design choices. It currently describes one approved preference: floating translucent navigation.

## Elevation & Depth

The navigation should read as a floating glass object. Use background blur, a thin luminous border, and a soft diffuse shadow. Content may move behind the bar so the translucency remains visible.

## Shapes

Navigation uses a horizontal pill silhouette with fully rounded ends. The selected destination is emphasized with a second soft frosted pill nested inside the outer capsule.

## Components

### Floating navbar

- Float above the bottom safe area as a narrow centered capsule.
- Size the bar to provide only comfortable padding around its icons and labels; do not stretch it across the screen.
- Keep the surface translucent rather than opaque.
- Use two equal-width persistent destinations in Favourite Menu: **Add Dish** and **My Menu**.
- Emphasize the selected destination with a softly tinted frosted segment, colored icon, and stronger label.
- Keep unselected destinations quiet but readable.
- Use a small restrained dot for unseen menu content without changing the component’s alignment.
- Preserve a minimum interactive height of 56px and expose selected state semantically.

## Do's and Don'ts

- Do use a single floating capsule for persistent navigation.
- Do use fully rounded ends on both the outer bar and selected segment.
- Do keep the number of destinations minimal.
- Do keep the capsule compact and content-sized.
- Don’t replace the translucent glass treatment with a full-width opaque system tab bar.
- Don’t make the floating capsule span the available screen width.
- Don’t use separate floating buttons when the elements represent persistent destinations.
