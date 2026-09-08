# Reference geometry

Measured at a 428 px browser viewport. All values are CSS pixels.

| Section | Figma top | Browser top | Height |
|---|---:|---:|---:|
| Top restaurants | 362 | 362 | 355 |
| You visited before | 749 | 749 | 360 |
| From your friends | 1141 | 1141 | 422.102 |
| Fast & well-rated | 1595.104 | 1595.102 | 264 |
| Top grocery stores | 1891.104 | 1891.102 | 303.102 |
| Saved for later | 2226.209 | 2226.203 | 248 |
| Local favourites | 2506.209 | 2506.203 | 380 |
| Lunch for less than 9,99€ | 2918.209 | 2918.203 | 370 |
| Highly-rated newcomers | 3320.209 | 3320.203 | 248 |

Full document height: **3680 px**. Document width: **428 px**. At the tested 375 px phone width, document width remains **375 px**.

Visual review covered original fonts, photograph crops, logos, shadows, curved boundaries, grocery spacing, friend avatars, card dimensions, and navigation. The source Figma file remains the authority for any further pixel-level review.

## Practice copy (2026-09-08)

- Added 40 deliberately scoped defects at `/practice`; original `styles.css` SHA-256 remains `65d166b1df4bb0d3a3cfb265a8b24f60a4185cbe91343524e24bcc8abedca43d`.
- Browser checked desktop side-by-side comparison and mobile version switching at 390px.
- Confirmed practice delivery fee moves 24px below its row, thumbnail transform becomes zero rotation, grocery background becomes white, original-price strike is removed, and saved-heart size is 16px. Original counterparts retained their expected styles.
- Practice imagery loaded successfully. Search, details, add-to-cart, remove-from-cart and save persistence worked. Test cart and saved item were restored afterwards.
- Linked scrolling works on desktop; hidden mobile panes are excluded from synchronization.
- Independent code review found all 40 entries have implemented selectors and original/practice storage is isolated. Mechanical UI detector returned no findings; browser comparison error log was empty.
- Intentional accessibility/feedback defects in the practice route are exercise data, not production recommendations.

## Practice refinement (2026-09-08)

- Supersedes the earlier 40-issue version: 64 styling differences, with all text, badges, prices, timestamps, icons and action confirmations restored.
- Browser verified all 9 arrow backgrounds are transparent, all 4 order-count icons are visible at 16px, all 4 help icons are visible at 12px, the full review is 12px, and grocery cream is #f9efdc with no curve layers.
- Added more radius and shadow errors across complete component families. Enlarged the fast-store rail cards/section so the deliberately wrapped delivery fee is fully visible.
- Original stylesheet checksum remains unchanged.
