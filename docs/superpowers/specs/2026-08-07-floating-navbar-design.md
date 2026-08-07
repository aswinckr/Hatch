# Floating Translucent Navbar — Design

## Goal

Replace the standard full-width bottom tab bar with a floating translucent navigation capsule inspired by the supplied reference, while preserving Favourite Menu’s two existing destinations: Add Dish and My Menu.

## Visual design

The navbar is a single horizontal pill inset 16 px from both screen edges and positioned 12 px above the bottom safe area. It has fully rounded ends, a milky translucent surface, background blur, a thin low-contrast white border, and a soft diffuse shadow.

The pill contains two equal-width destinations. Each destination combines an icon and short label. The selected destination sits on a soft frosted oval segment with the app accent color applied to its icon and label. The unselected destination uses a quieter neutral tone while preserving accessible contrast.

The menu badge remains a small restrained dot near the My Menu icon. It must not change the capsule’s size or alignment.

## Behavior

- Tapping either destination changes tabs without route animation.
- The selected segment animates subtly between destinations.
- Content can extend behind the floating bar, but every screen reserves enough bottom padding that controls and menu content remain reachable.
- Reduced-motion mode removes the segment transition.
- The bar respects the iPhone bottom safe area.
- The browser preview uses the same translucent color, border, radius, and shadow; blur may degrade gracefully if unsupported.

## Component boundary

Create a focused `FloatingTabBar` presentation component. It accepts the selected index, a selection callback, and whether My Menu has unseen content. `AppShell` continues to own tab state and new-dish badge behavior.

The component uses two stable destinations only:

1. Add Dish — camera icon
2. My Menu — document icon

## Accessibility

- Each destination exposes a button semantic with its label and selected state.
- Minimum interactive height is 56 px.
- Selected and unselected states are distinguishable without relying solely on color.
- Text scales without clipping at supported Dynamic Type sizes.

## Preference capture

After implementation, add the first entry to `design.md`: an explicit preference for floating translucent navigation with a pill silhouette, fully rounded ends, a softly emphasized selected destination, and minimal persistent destinations. Cite the supplied navbar image and this approved Favourite Menu application as evidence. Do not infer unrelated universal preferences.

## Verification

Widget tests cover two destinations, selection callbacks, selected semantics, and the unseen-menu dot. Layout tests cover 320 px and 430 px widths, enlarged text, and safe-area spacing. Browser verification covers the glass appearance and tab switching at an iPhone-sized viewport.
