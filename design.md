---
version: alpha
name: Aswin Visual Taste
description: A living set of reusable visual principles built only from explicit design preferences.
omitted:
  - section: spacing
    reason: No general spacing system has been established yet.
colors:
  primary: "#1F4D3A"
  onPrimary: "#FFFFFF"
typography:
  heading:
    fontFamily: "Outfit"
  body:
    fontFamily: "Outfit"
rounded:
  full: 9999px
components:
  floating-navbar:
    backgroundColor: "rgba(255, 255, 255, 0.32)"
    rounded: "{rounded.full}"
    height: 72px
    width: 236px
  floating-navbar-selected:
    backgroundColor: "rgba(31, 77, 58, 0.18)"
    rounded: "{rounded.full}"
  floating-primary-action:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.onPrimary}"
    rounded: "{rounded.full}"
    size: 64px
  primary-page-surface:
    backgroundColor: "#FFFFFF"
---

## Overview

This file grows only through explicit design choices. Record principles at a level that can guide decisions across products, platforms, and feature areas. Product-specific implementations may serve as evidence, but should not become universal rules unless the underlying preference is broadly applicable.

## Colors

Use dark forest green as the consistent interactive accent for buttons, selected controls, active navigation, and closely related action icons. Pair it with white content for strong contrast. Use pale green tints for selected backgrounds when a full dark fill would feel too heavy.

## Typography

Use Outfit throughout the interface and generated artifacts. Create hierarchy through size, weight, spacing, and placement rather than mixing type families. This keeps functional controls and expressive content visually coherent.

## Layout

Prefer one continuous background color across a primary screen. Use white when the interface should feel clean, spacious, and content-led. Navigation, safe areas, scrolling regions, and the space behind floating controls should share that surface rather than forming separate horizontal bands.

When a screen represents a singular immersive artifact or canvas, let that artifact own the full viewport. Remove redundant top bars, carry its surface color to every edge, and preserve only essential safe-area and persistent-navigation clearance.

## Elevation & Depth

Floating controls should read as lightweight glass objects rather than heavy containers. Approximate Apple’s regular Liquid Glass with strong backdrop blur, a low-opacity adaptive tint, a diagonal specular highlight, an extremely subtle hairline highlight, and a soft diffuse shadow. Allow content to move behind translucent surfaces so colors and forms visibly infuse the material without reducing legibility.

## Shapes

Use simple geometric silhouettes to make persistent controls feel approachable and self-contained. Horizontal navigation may use a pill with fully rounded ends, with selection communicated by a softer nested shape rather than a hard divider.

Use fully rounded, pill-shaped corners for button surfaces. The radius should resolve to half the control height or greater so the ends remain completely rounded at any supported size. Icon-only floating actions may use a circle as the equivalent fully rounded form.

## Components

### Floating navbar

- Float above the bottom safe area as a narrow centered capsule.
- Size the bar to provide only comfortable padding around its icons and labels; do not stretch it across the screen.
- Keep the surface genuinely translucent so underlying content can peek through and influence its appearance.
- On a white page, establish the glass edge with blur, highlights, border, and shadow rather than a nearly opaque grey fill.
- Give persistent destinations equal visual weight unless product hierarchy clearly requires otherwise.
- Name destinations after the content or place they represent, and use representative icons rather than action-oriented symbols.
- Emphasize the selected destination with a softly tinted frosted segment, colored icon, and stronger label.
- Keep unselected destinations quiet but readable.
- Use a small restrained dot for unseen content without changing the component’s alignment.
- Preserve a minimum interactive height of 56px and expose selected state semantically.

### Floating primary action

- When a screen has one frequent, unmistakable action, place it in a circular floating button near persistent navigation.
- Place a floating primary action in the lower trailing corner, above persistent navigation and clear of safe areas.
- Keep deliberate breathing room between the action and navigation so each control reads as an independent layer.
- An icon-only action is appropriate when the symbol is widely understood; always provide an accessible semantic label.
- Use a distinctive accent fill and soft shadow to establish primacy without making the control oversized.
- Keep headers free of secondary actions when the primary creation path is already clear and persistent.

### Image-led collections

- When saved items are inherently visual, let their imagery lead the home-screen hierarchy.
- Prefer a single-column chronological feed when sequence, recency, and the story of each item matter more than rapid comparison.
- Give each feed item a compact context header, prominent image, clear title, supporting detail, and a quiet timestamp.
- Place the newest items first so newly created content produces immediate, predictable feedback.
- Use large, consistently proportioned, softly rounded imagery and only the metadata needed for recognition and context.
- Prefer natural, handheld photography with believable restaurant context over polished stock imagery; slight framing imperfections and mixed ambient light make personal collections feel authentic.
- In visual collections, vary the subject, composition, and setting across adjacent items so the feed feels alive rather than templated.
- Treat the empty state as part of the product experience: keep it calm, generous, and focused on the first meaningful action.
- Preserve clear hierarchy between collection browsing, the primary creation action, and secondary import or management actions.

### Opinionated presentation

- Prefer one intentional default presentation over exposing cosmetic style selectors.
- Keep configuration out of the primary experience when it does not change the user’s core outcome.
- Avoid persistent output actions when viewing and maintaining the content is the primary task.

### Editorial image menus

- When transforming a personal visual collection into a menu, reuse the exact captured imagery so the artifact retains its provenance.
- Use image-first poster layouts for a small number of high-value items: combine a generous food image, an organic color field, and a compact text panel.
- Keep decorative shapes behind the image and information, so the dish remains the unmistakable focal point.
- When the experience calls for a single menu artifact, make it one uninterrupted composition rather than a page of independently framed cards.
- Limit the poster copy to the section, name, short description, and venue; omit transactional details when the menu is a memory artifact rather than an order surface.

## Do's and Don'ts

- Do use a single floating capsule for persistent navigation.
- Do use fully rounded ends on both the outer bar and selected segment.
- Do keep the number of destinations minimal.
- Do keep the capsule compact and content-sized.
- Do use fully rounded ends consistently across primary, secondary, and destructive buttons.
- Do reserve a floating circular action for one clear, high-frequency primary task.
- Do let visual content lead when recognition is faster through imagery than text.
- Do make recency visible in chronological feeds without letting timestamps dominate.
- Do keep content-feed headers focused on orientation rather than redundant actions.
- Do let a clear screen title stand alone when supporting copy adds no new information.
- Do carry a screen’s background through every edge and safe area.
- Do remove redundant chrome when the content already supplies its own title and hierarchy.
- Do use the same dark green to connect interactive elements across screens.
- Do use Outfit consistently for headings, body copy, controls, metadata, and generated outputs.
- Do make a clear visual choice on the user’s behalf when alternatives add complexity without meaningful utility.
- Don’t replace the translucent glass treatment with a full-width opaque system tab bar.
- Don’t make the floating capsule span the available screen width.
- Don’t use separate floating buttons when the elements represent persistent destinations.
- Don’t place multiple competing floating actions on the same screen.
- Don’t divide a continuous page into differently colored zones without a functional reason.
- Don’t frame an immersive artifact inside a second page surface.
- Don’t turn a product-specific label, content type, or workflow into a universal design rule.
- Don’t mix mildly rounded rectangular buttons with pill-shaped buttons in the same interface.
- Don’t introduce competing warm accent colors for standard actions.
- Don’t introduce a second display or body typeface for hierarchy alone.
- Don’t expose multiple cosmetic themes merely to make an interface feel customizable.
