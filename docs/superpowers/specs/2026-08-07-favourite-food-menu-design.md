# Favourite Food Menu — Product Design

## Product goal

Create an iPhone-first Flutter prototype that turns photos of favourite restaurant dishes into a polished, price-free personal menu. The prototype must demonstrate the complete journey without requiring a backend, account, network connection, or API keys.

The experience should feel intelligent and presentation-ready while using deterministic mock analysis. Its central interaction is a menu that begins empty and visibly grows as each dish is finalized.

## Audience and success criteria

The primary user is someone who photographs memorable restaurant dishes and wants to curate those favourites into a beautiful physical artifact.

The prototype succeeds when a user can:

1. Take or select a food photo on an iPhone.
2. Receive believable suggested dish and restaurant details.
3. Correct those details and assign the dish to Breakfast, Lunch, or Dinner.
4. Finalize the dish and immediately see it added to a live menu.
5. Edit or remove saved dishes.
6. Select a visual theme.
7. Generate, share, or print a clean PDF menu.
8. Close and reopen the app without losing the collection.

## Scope

### Included

- iPhone-only Flutter application
- Camera and photo-library intake
- Guided, single-dish creation flow
- Deterministic mock dish analysis with realistic loading feedback
- Editable dish name, restaurant, short description, and meal section
- Persistent Add Dish and My Menu tabs
- Live menu grouped into Breakfast, Lunch, and Dinner
- Local on-device persistence
- Dish editing and removal
- Editorial, Modern, and Bistro themes
- PDF creation using the selected theme
- Native iOS share and print sheets
- Bundled sample dishes for demonstration
- Empty, loading, failure, and permission-denied states

### Excluded

- Real image recognition or restaurant lookup
- Network requests, accounts, authentication, or cloud sync
- Prices, ratings, reviews, dates, or personal journal notes
- Android, web, iPad, and desktop targets
- Freeform page-layout editing
- Collaboration or social sharing beyond the native iOS share sheet

## Core experience

The app has two persistent bottom tabs.

### Add Dish

The user takes a photo or selects one from the photo library. After a brief simulated analysis state, the app proposes a dish name, restaurant, concise menu description, and meal section. All values are editable. The user finalizes the dish with one primary action.

Finalizing returns clear confirmation, saves the dish locally, and updates the My Menu tab immediately. A badge or restrained animation draws attention to the newly added item without interrupting the flow. The user can then add another dish.

### My Menu

The menu begins as an elegant empty page with visible Breakfast, Lunch, and Dinner headings and tasteful prompts. As dishes are finalized, they appear beneath the relevant heading.

Each entry contains:

- Dish name
- Short menu-style description
- Restaurant attribution

The user can edit or remove an entry, change the menu theme, and open a printable preview. Empty meal sections remain visible while building the collection but are omitted from the generated PDF.

## Visual design

The default Editorial theme uses a warm cream paper background, dark espresso typography, and a muted terracotta accent. Elegant serif typography carries menu titles and dish names; a clean sans-serif handles controls and form fields.

Food photography is prominent during intake and review. The final menu is deliberately text-led so it resembles a boutique restaurant menu rather than a photo album.

Three themes provide meaningful variation without becoming a general-purpose design tool:

- **Editorial:** warm, refined, typographic
- **Modern:** high-contrast, spacious, minimal
- **Bistro:** intimate, classic, lightly decorative

Motion is subtle and functional: analysis feedback, successful finalization, menu-tab attention, and insertion of the new dish into its section.

## Architecture

The codebase is divided into focused Flutter layers:

- **Presentation:** screens, tabs, reusable controls, theme previews, and responsive iPhone layouts
- **Application:** add, edit, remove, categorize, and export use cases
- **Domain:** dish, meal section, menu collection, and menu theme models
- **Infrastructure:** local persistence, image intake, mock analysis, PDF rendering, and iOS share/print adapters

The UI reads observable menu state from a single application-level store. Finalizing or editing a dish updates that store; persistence and the live preview respond to the same state change. PDF generation receives an immutable menu snapshot and selected theme so print output does not depend on transient screen state.

The mock analyzer is accessed through an interface that can later be replaced by a real AI-backed implementation without changing the creation flow. It selects from bundled scenarios and always returns editable suggestions.

## Data model

A dish stores:

- Stable identifier
- Local image reference
- Dish name
- Restaurant name
- Short description
- Meal section: breakfast, lunch, or dinner
- Created and updated timestamps

Application preferences store the selected menu theme and whether sample content has been offered. The generated PDF is derived output and is not part of persistent menu state.

## Error and edge-case behavior

- If camera or photo-library access is denied, explain why access is useful, offer a Settings shortcut, and allow selection of a bundled sample image.
- If an image cannot be read, retain the visible preview when possible and open blank editable fields.
- If mock analysis fails, show a concise message and continue with manual entry.
- Required fields are dish name, restaurant, and meal section. The description may be blank.
- If no dishes exist, PDF generation is disabled and the empty menu explains how to begin.
- Destructive removal requires confirmation and immediately updates local state.
- Long names and descriptions wrap gracefully in both the live preview and PDF.
- PDF generation errors preserve the collection and offer a retry.

## Accessibility and iOS behavior

- Respect safe areas, Dynamic Type, and reduced-motion settings.
- Provide semantic labels for photos, tabs, fields, and actions.
- Maintain sufficient contrast in every theme.
- Use iOS camera and photo-library permission descriptions.
- Present PDF sharing and printing through native iOS sheets.
- Optimize for portrait orientation across currently common iPhone screen sizes.

## Verification strategy

Unit tests cover categorization, validation, persistence serialization, mock-analysis selection, and PDF menu transformation. Widget tests cover empty state, dish review, editing, removal, theme selection, and long-text layout. An integration test covers the primary journey from bundled sample photo through finalization and menu appearance.

Manual verification on an iPhone simulator covers camera/photo permission states where simulation allows, photo-library intake, persistence across relaunch, common iPhone viewport sizes, Dynamic Type, theme previews, PDF pagination, and the native share/print handoff.

## Delivery boundary

The deliverable is a runnable Flutter project configured for iOS, with bundled demo assets and setup instructions. A developer with Flutter and Xcode installed can launch it in an iPhone simulator without external credentials or services.
