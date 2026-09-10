# Home screen visual QA audit

## Audit contract

| Field | Value |
|---|---|
| Audit ID | `food-delivery-home-2026-09-10` |
| Design | Penpot board `df77d7bb-581c-802a-8008-9cfedd0a50ef` |
| Reference | Penpot board `ff0d05ea-5e35-8009-8008-9df8b67262bc` |
| App / route | `http://127.0.0.1:5173/` |
| State | Discover default; empty search; light theme; no saved items or cart |
| Capture | 428 × 3680 CSS px, DPR 1, Chrome, zoom 100%, `en-US` |
| App revision | `6b21e4c` with uncommitted local changes |
| Design evidence | `penpot-reference.png` (428 × 3680) |
| App evidence | `app-actual.png` (428 × 3680) |

The reference and app captures share the same dimensions. Findings below are confirmed by side-by-side image comparison and the computed implementation rule; values labelled **expected** come from the Penpot reference/capture, and **actual** values from `src/styles.css`. Pixel differences are supporting evidence only; font anti-aliasing is excluded.

## State matrix

| State ID | Scope | Result |
|---|---|---|
| `discover-default` | Full home / default viewport | fail |
| `search-active` | No supplied Penpot design state | unavailable |
| `detail-sheet`, `cart-sheet`, `profile-sheet`, `address-sheet` | No supplied Penpot design state | unavailable |

## Summary

- **Fail:** 54 confirmed comparison records (grouped into 9 root-cause issues)
- **Pass:** 0 full-screen state comparisons
- **Unavailable:** 4 app-only interaction states
- **Needs review:** 0

## Confirmed issues

### QA-01 — Hero, address, and search controls use the wrong shape and spacing (P1)

| Component / property | Expected | Actual | Delta |
|---|---:|---:|---|
| Hero fill | `#ffc042` | `#ffcf68` | wrong color |
| Address control radius | `999px` | `10px` | not pill-shaped |
| Address horizontal padding | `12px` | `20px` | +8px per side |
| Greeting left inset | `16px` | `24px` | +8px |
| Greeting paragraph top margin | `4px` | `12px` | +8px |
| Search radius | `999px` | `12px` | not pill-shaped |
| Search horizontal padding | `16px` | `8px` | -8px per side |
| Search placeholder color | `#838486` | `#b1b2b5` | wrong token |
| Address shadow | none | `0 4px 0 #16161726` | extraneous |
| Search inset shadow | none | `inset 0 2px 5px #16161726` | extraneous |
| Hero bottom curve | visible | hidden | missing visual divider |

**Implementation:** `src/styles.css` hero/address/search rules (lines 129–321).  
**Fix:** restore the pill radii, base spacing/color tokens, remove added shadows, and display `header-curve`.

### QA-02 — Section headings and navigation affordances lose intended emphasis (P1)

| Component / property | Expected | Actual |
|---|---:|---:|
| Top-restaurants heading weight | `700` | `500` |
| Top-restaurants subtitle position | baseline | `translateY(-4px)` |
| Info icon size | `16px` | `12px` |
| Arrow-button fill | `#f2f2f3` | transparent |
| Active Discover navigation color | `#000` | `#838486` |
| Newcomers subtitle | muted regular | ink, weight `500` |

**Implementation:** `src/styles.css` section/arrow/nav rules (lines 398–430, 1074–1098, 1222–1264).  
**Fix:** use the supplied heading, icon, button-fill, and active-nav tokens.

### QA-03 — Top restaurant ranking cards are materially different (P1)

| Component / property | Expected | Actual |
|---|---:|---:|
| Card radius | `16px` | `6px` |
| Card horizontal padding | `16px` | `10px` |
| Rank type size | `28px` | `24px` |
| Restaurant-logo radius | `16px` | `50%` |
| Promo badge radius | `8px` | `50%` |
| Card shadow | none | `3px 3px 0 #16161726` |

**Implementation:** `src/styles.css` ranked-card/logo/promo rules (lines 466–570).  
**Fix:** restore card/logo/badge corner radii, padding and type scale; remove the shadow.

### QA-04 — “You visited before” cards have incorrect treatment (P1)

| Component / property | Expected | Actual |
|---|---:|---:|
| Card radius | `16px` | `3px` |
| Shadow | shared soft card shadow | `0 8px 10px #16171740` |
| Image-to-card curve | visible | hidden |
| Product rotations | `4°`, `-8°`, `10°` | first forced to `0°`; design loses rotation treatment |
| Product border | `2px #1617170d` | transparent |
| Product shadow | none | `0 5px 5px #16161740` |

**Implementation:** `src/styles.css` visited/tall-card/mini-product rules (lines 626–696).  
**Fix:** use the common card styling and preserve the curve, border, and individual product transforms.

### QA-05 — Friends grid uses incorrect geometry and avatars (P1)

| Component / property | Expected | Actual |
|---|---:|---:|
| Grid / tile gaps | `7.9779px` | `12px` |
| Tile radii | `16px`; featured `24px` | `3px` |
| Avatar radius | `50%` | `5px` |
| Overlapping avatars | `-4px` | `+3px` |
| Price badge radius | `4px` | `999px` |
| Price badge horizontal padding | `4px` | `9px` |

**Implementation:** `src/styles.css` friends rules (lines 708–807).  
**Fix:** restore the grid precision, intended card corners, circular overlapping avatar stack, and compact price label.

### QA-06 — Fast/saved/newcomer restaurant cards deviate in image and icon styling (P1)

| Component / property | Expected | Actual |
|---|---:|---:|
| Store image radius | `16px` | `30px` |
| Store image shadow | none | `0 5px 7px #16161733` |
| Save icon target/image | `24px` | `16px` |
| Exclusive label radius | `4px` | `999px` |
| Exclusive label horizontal padding | `4px` | `10px` |
| Fast-card rating layout | single-line normal | wraps; variable card height |

**Implementation:** `src/styles.css` store-card / fast-section / exclusive rules (lines 882–957).  
**Fix:** use the 16px image radius, 24px save control, compact label, and standard rating flow.

### QA-07 — Grocery section loses its curved surface and card styling (P1)

| Component / property | Expected | Actual |
|---|---:|---:|
| Surface edges | curved SVG top/bottom | curves not displayed; square edges |
| Grocery logo radius | `16px` | `0` |
| Grocery logo shadow | none | `3px 3px 0 #16161726` |
| In-store badge position | `right:-4px; top:-4px` | `right:2px; top:2px` |

**Implementation:** `src/styles.css` grocery rules (lines 974–1067).  
**Fix:** render the supplied top/bottom curves, restore rounded logo cards, remove the added shadow, and restore badge offset.

### QA-08 — Local-favourite review cards have wrong typography and metadata alignment (P2)

| Component / property | Expected | Actual |
|---|---:|---:|
| Review quotation | `16px/20px` | `12px/16px` |
| “2 hours ago” location | left `12px` | right `12px` |

**Implementation:** `src/styles.css` review rules (lines 1087–1108).  
**Fix:** reinstate the 16px review type and left-aligned timestamp.

### QA-09 — Lunch product rail and labels use incorrect tokens (P1)

| Component / property | Expected | Actual |
|---|---:|---:|
| Rail gap | `16px` | `8px` |
| Product image radius | `16px` | `4px` |
| Discount badge position | left `8px` | right `8px` |
| Discount badge radius | `4px` | `0` |
| Struck-through old price | `12px`, regular, muted | `14px`, bold, ink |
| Delivery tag | yellow, bold, `4px` radius | neutral, regular, square |
| Ordered icon | `24px` | `16px` |

**Implementation:** `src/styles.css` product-card rules (lines 1114–1212).  
**Fix:** restore the rail rhythm, 16px media corners, discount placement, price typography, yellow delivery tag and ordered-icon scale.

### QA-10 — Modal/sheet and toast controls also do not match the design system (P2, not in supplied home-frame capture)

| Component / property | Expected design-system value | Actual |
|---|---:|---:|
| Bottom sheet radius | `24px 24px 0 0` | `4px 4px 0 0` |
| Detail image radius | `16px` | `0` |
| Primary/secondary button radius | `999px` | `6px` |
| Toast radius | `12px` | `0` |

These are source-confirmed shared-token regressions, but are **unavailable** for frame-level visual confirmation because no matching Penpot modal/toast state was supplied.

## Comparison evidence and limitations

- Full-frame capture evidence: [`penpot-reference.png`](penpot-reference.png) and [`app-actual.png`](app-actual.png).
- Source mappings: [`src/styles.css`](../../../src/styles.css), [`src/App.tsx`](../../../src/App.tsx).
- The Penpot editor did not expose inspectable per-layer metadata in this audit session. Board IDs and full-frame reference are therefore recorded; node-level mappings remain unavailable.
- No hidden, focused, loading, search, or modal design states were inferred as visual failures.
