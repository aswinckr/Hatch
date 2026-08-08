# Flutter Wireframe Workshop Project Design

## Summary

Create `flutter-wireframe` as a standalone, plain Flutter counterpart to
`flutter-ui`. It is a workshop starting point for teaching visual UI design:
participants receive the same application structure, layout hierarchy, data
flow, and interactions as the finished prototype, but every screen begins as a
neutral Material 3 wireframe.

The wireframe must be functional software, not a static mockup. Camera and photo
selection, analysis, form editing, validation, persistence, feed updates, tab
navigation, scrolling, and menu-page swiping must continue to work.

## Goals

- Give workshop participants an immediately runnable Flutter application whose
  UX structure matches `flutter-ui`.
- Preserve the finished prototype's screens, layout hierarchy, navigation,
  state transitions, and interactions.
- Remove the finished prototype's visual design language so participants can
  practice applying one themselves.
- Use standard Material 3 components and Flutter's built-in defaults throughout.
- Keep the project self-contained so it can be copied, taught, modified, and
  run without `flutter-ui`, the packaged skill, or repository design guidance.

## Non-goals

- Do not change `flutter-ui` or extract shared runtime code from it.
- Do not create a shared package between the two Flutter projects.
- Do not teach architecture, backend development, or image recognition.
- Do not include a custom design system, custom component library, custom font,
  generated food photography, styled menu posters, or design instructions.
- Do not include `design.md`, a Codex skill, or references to the repository's
  packaged skill.
- Do not reproduce glassmorphism, floating navigation, forest-green styling,
  pill geometry, editorial typography, image treatments, or bespoke animation.

## Project Boundary

`flutter-wireframe` is created by copying the functional project structure from
`flutter-ui` and neutralizing its presentation. After creation it owns its
source, tests, configuration, iOS and web runners, storage, mock analysis, and
dependencies. No import, path dependency, asset reference, or build step may
reach into `flutter-ui` or `skill`.

Use a distinct Flutter package name, `hatch_wireframe`, while retaining the
prototype's platform support and minimum toolchain requirements. The workshop
project remains iOS-first and must also run in Flutter web for easy classroom
preview.

## Architecture

Retain the existing feature boundaries where they help preserve behavior:

- `app`: application startup, two-destination shell, and selected-tab state.
- `features/add_dish`: capture, analysis, review, validation, and completion.
- `features/menu`: dish model, local repository, controller, feed data, and menu
  carousel.

Keep domain and persistence behavior independent from widgets. Presentation
widgets may be renamed or divided when necessary to express the Material 3
structure clearly, but unrelated refactoring is outside scope.

Remove the `core/design` token layer. The app-level theme is
`ThemeData(useMaterial3: true)` without a branded color scheme or typography.
Wireframe-specific grey fills may use Flutter's built-in `Colors.grey` swatches
directly at the placeholder widget that needs them; they must not become a new
design-token system.

## Material 3 Component Baseline

Use standard Flutter Material widgets for visible controls and structure:

- `MaterialApp` for application configuration.
- `Scaffold` for every primary screen.
- `AppBar` for screen titles.
- `NavigationBar` with Dishes and My Menu destinations.
- `FloatingActionButton` for the primary capture action.
- `Card`, `ListView`, `Row`, `Column`, `AspectRatio`, `SizedBox`, and
  `Divider` for feed and wireframe structure.
- `TextField` or `TextFormField`, standard validation messages, and Material
  selection controls for the review form.
- `FilledButton`, `TextButton`, and `IconButton` for actions.
- `CircularProgressIndicator` for analysis.
- `AlertDialog`, `SnackBar`, and bottom sheets where the equivalent interaction
  requires them.
- `PageView` plus a standard Material page-position indicator for the menu.

Do not recreate standard components with gesture detectors, custom painters,
blur filters, bespoke shadows, or decorative containers. Custom widgets remain
acceptable as behavioral composition units, such as `DishFeedCard` or
`WireframeImagePlaceholder`, when their visible children are standard Flutter
widgets.

## Content and Wireframe Treatment

The project starts with four generic dish records so both destinations are
populated on first launch. Do not use real dish or restaurant names. Seed and
analysis values use generic workshop copy:

- Dish name: `Dish name`
- Restaurant: `Restaurant name`
- Description: `Short dish description`
- Menu sections: `Breakfast`, `Lunch`, and `Dinner`

The four records may vary only by stable identifiers, timestamps, and meal
section. Visible copy remains generic. Relative posting times remain functional
because they demonstrate information hierarchy rather than visual taste.

All food photos and finished poster images are removed from the project. Every
image position is rendered as a neutral grey rectangle containing a standard
image icon and a concise semantic label. A selected camera or library photo
path is still retained in the data flow and persisted, but the wireframe never
renders the photograph. User-entered text is shown after submission so workshop
participants can observe the completed interaction.

The project uses the platform's default sans-serif typeface. It must not bundle
or declare Outfit or any other custom font.

## Screen Specification

### Dishes feed

The initial destination preserves the finished app's vertical feed hierarchy:

1. An `AppBar` titled `Your dishes`.
2. Four feed entries ordered newest first.
3. Each entry contains a restaurant/timestamp metadata row, a full-width square
   grey image placeholder, a dish-name line, and description lines.
4. The feed scrolls vertically and leaves enough inset for the standard bottom
   navigation and capture action.

Use standard cards and default spacing. Do not reproduce rounded image corners,
branded icons, large editorial headers, custom shadows, or bespoke feed styling.

### Capture and review flow

The standard `FloatingActionButton` remains available from the Dishes feed. The
capture flow exposes both real sources supported by the existing application:
camera and photo library. Selecting a source invokes the platform picker through
`image_picker`; cancelling returns safely to the feed.

After a successful selection:

1. Show the analyzing state with `CircularProgressIndicator` and neutral copy.
2. Run the existing deterministic local analyzer contract.
3. Open the review state with a grey image placeholder and editable Material
   fields for dish name, restaurant, and description.
4. Prepopulate the fields with generic values and retain Breakfast, Lunch, and
   Dinner selection.
5. Reject submission when dish name or restaurant is blank and display an
   inline Material validation error.
6. On successful submission, persist the dish and show the existing completion
   state with standard iconography and buttons.
7. Allow the user to return to the feed or begin another capture.

Photo permission and picker failures use a standard `AlertDialog` with useful,
non-product-specific instructions. There is no sample-dish shortcut, empty feed
state, dish-detail review interaction from a feed item, or export flow.

### My Menu carousel

The second destination preserves the full-screen horizontal menu experience.
It starts with four pages corresponding to the same four seed records. Each page
contains only grey layout blocks and generic dish copy while maintaining the
approximate information hierarchy and proportions of the finished poster.

The first page may include the generic menu heading used to represent the cover
hierarchy. Subsequent pages show only the image placeholder, generic dish name,
description, and section metadata needed by the established layout.

Use `PageView` for touch swiping. Web users must be able to drag with a pointer
or use standard scroll input. A visible Material page indicator communicates
the current page and total page count. Adding a dish creates an additional menu
page without navigating automatically.

### Bottom navigation

Use a full-width, out-of-the-box Material 3 `NavigationBar` in the scaffold's
`bottomNavigationBar` slot. Its destinations are Dishes and My Menu, using
standard Material icons. It retains selection state and the new-item indication
after a dish is added; opening My Menu clears that indication.

Do not float, blur, clip, tint, or manually animate the navigation bar. Safe-area
behavior comes from the standard scaffold and navigation widgets.

## State and Data Flow

The app initializes its controller from a local repository before rendering the
shell. The repository seeds four generic records on a clean install and persists
subsequent additions with `shared_preferences`. Existing stored data from
`flutter-ui` is not imported because the apps are independent.

The capture sequence is:

`feed -> source selection -> platform picker -> analyzing -> review -> validate
-> persist -> completion -> feed/menu`

The selected photo path remains part of the `Dish` domain object so the
interaction contract matches the finished prototype. Presentation always maps
that path to a grey placeholder. Controller notification updates both the feed
and menu, and sets the My Menu new-item indicator until that destination opens.

## Responsive and Platform Behavior

- Support the current iPhone-first portrait layout without fixed device widths.
- Keep content readable at narrow mobile widths and centered within sensible
  constraints on wide web viewports.
- Avoid overflow with text scaling and long user-entered content.
- Make feed scrolling, form scrolling, picker cancellation, and menu swiping
  work on both iOS and web where the platform capability exists.
- Preserve iOS camera and photo-library permission strings.
- Use no network services or runtime API keys.

## Accessibility

- Every action has an accessible Material tooltip or semantic label.
- Navigation destinations expose selected state through `NavigationBar`.
- Grey image blocks have semantic labels such as `Dish image placeholder` and
  are not announced as actual photographs.
- Form fields use visible labels rather than hint text alone.
- Validation errors are readable by assistive technology.
- Touch targets use standard Material component sizing.
- Text remains usable with increased system text scaling and reduced motion.

## Error Handling

- Picker cancellation is a no-op and does not surface an error.
- Camera or library permission failures show a standard Material dialog and
  leave the app in a recoverable state.
- Analyzer failure opens the review form with empty editable fields and an
  explanatory inline message.
- Missing required values prevent persistence.
- Malformed saved data falls back to the four generic seed records.
- Missing decorative assets cannot break the app because the wireframe has no
  image or font assets.

## Testing and Acceptance Criteria

Rewrite copied tests to import `hatch_wireframe`, use Material test hosts, and
assert behavior rather than custom colors, radii, fonts, or pixel styling.

The project is accepted when all of the following are true:

1. `flutter-wireframe` runs independently on Flutter web and an iOS simulator.
2. A clean launch shows four generic dishes in the Dishes feed and four matching
   pages in My Menu.
3. No visible seed content contains a real dish or restaurant name.
4. No selected or seeded photograph is rendered; every image area is grey.
5. The Dishes feed scrolls and preserves its metadata, image, name, and
   description hierarchy.
6. The Material `NavigationBar` switches destinations and exposes the selected
   destination.
7. The Material `FloatingActionButton` can invoke the real camera flow, and the
   capture UI also exposes the real photo-library picker.
8. Picker cancellation, permission failure, analysis, field editing, required
   field validation, successful persistence, completion, and adding another
   dish all work.
9. A newly submitted dish appears in both destinations and triggers the menu
   new-item indication until My Menu is opened.
10. The menu supports touch swipe and browser pointer drag, shows a visible page
    position indicator, and includes newly added records.
11. The project contains no `design.md`, skill instructions, custom design-token
    directory, custom font declaration, generated dish imagery, or finished menu
    poster assets.
12. The project contains no runtime or build dependency on `flutter-ui` or
    `skill`.
13. Accessibility tests cover labels, selected navigation state, form labels,
    validation feedback, and image-placeholder semantics.
14. `dart format --output=none --set-exit-if-changed lib test integration_test`,
    `flutter analyze`, and `flutter test` pass from `flutter-wireframe`.
15. The end-to-end capture-to-menu journey passes on an iOS simulator, and the
    web build completes successfully.

## Documentation

The wireframe project has a short `README.md` explaining that it is a functional
Material 3 workshop starting point. It documents how to run tests, launch iOS,
and launch web. It must not teach or prescribe a visual design language and must
not refer participants to `design.md` or a skill.
