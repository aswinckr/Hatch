# Glovo discovery screen

A React + TypeScript + Vite recreation of [the supplied Figma screen](https://www.figma.com/design/GWYvRH1opeuY2lZpIs7Esi/Hatch-Conference---MCP?node-id=5-24131).

## Run

```sh
npm install
npm run dev
```

Open the local URL printed by Vite. For a production build:

```sh
npm run build
npm run preview
```

## Design fidelity

The reference frame is 428 × 3680 px, with a 430 px internal layout clipped at the right edge. The app preserves those dimensions and section positions at the reference width. On desktop, the mobile app is centered; smaller phones adapt to the viewport. The navigation stays at the bottom of the viewport, matching Figma’s fixed positioning.

Every section is built with HTML and CSS, with selectable text, real controls, and horizontal carousels. Original photographs and illustrations are stored locally. Glovo Sans Book, Medium, and Bold are self-hosted from Glovo’s public font CDN. Small navigation/search glyphs and the grocery badge are extracted from the original 3× Figma export. No full-screen screenshot is used to render the app.

The Figma connector reached its plan limit during extraction. The remaining original photographs were recovered from a local `.fig` export. Source export files and inspection artifacts are kept in the gitignored `design-reference/` folder. `public/assets/provenance.json` records image provenance.

## Working interactions

- Search restaurants and dishes, including a no-results state.
- Swipe, scroll, or use section arrows to browse carousels.
- Open restaurant and dish details.
- Save or remove restaurants; saved picks persist locally.
- Edit the delivery address; the address persists locally.
- Add dishes to a demo cart, adjust quantities, and see the subtotal.
- Open the profile and view saved picks.

This is a frontend demonstration. Menus outside the supplied screen are labeled as preview content. There is no backend, ordering, payment, or live delivery data.

## Validation

- TypeScript and Vite production build pass.
- Browser checks at 428 px and 375 px: no document-level horizontal overflow or missing images.
- Every major section matches the source’s vertical position to browser subpixel rounding.
- Search → product details → add to cart → quantity changes → empty cart verified.
- Saved restaurant persistence verified across reload.
- No browser console errors or warnings during those interactions.

Browser text rasterization can differ from Figma’s renderer; visual checks establish close fidelity rather than a guarantee that every rasterized pixel is identical.

## Detail-audit exercise

- `/` — original, unchanged visual reference.
- `/practice` — a copy with 64 deliberate styling defects with all information retained.
- `/compare` — side-by-side comparison on desktop, version tabs on mobile, linked desktop scrolling, and a collapsed facilitator answer key.

Both versions share the original images and Glovo fonts. Cart, saved items, and address changes are stored separately for each version. See [INTENTIONAL-ISSUES.md](INTENTIONAL-ISSUES.md) for the full checklist and `src/practice-issues.json` for machine-readable ground truth. Keep the practice defects intact when building an audit skill.
