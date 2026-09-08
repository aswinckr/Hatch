# Practice copy: intentional issues

The original at `/` is the visual reference. `/practice` contains 64 deliberate styling defects for an audit exercise. `/compare` shows both versions and keeps the answer key collapsed by default. Do not fix these defects as routine cleanup.

All information is retained: subtitles, prices, promotion and exclusivity labels, timestamps, icons, and action confirmations. Changes to a repeated icon family apply to every matching icon, not a single card. The grocery section retains its cream background with straight boundaries; review copy is smaller but complete.

Each version uses separate saved-item, cart and address storage. The images, fonts, text and core actions are shared. Base `src/styles.css` is unchanged.

| ID | Area | Intentional difference | Expected reference |
| --- | --- | --- | --- |
| UX-01 | Hero | Brand yellow is too pale | Background is #ffc042. |
| UX-02 | Address | Pill corners become shallow corners | Pill radius is 999px. |
| UX-03 | Address | Horizontal padding is too generous | Horizontal padding is 12px. |
| UX-04 | Hero | Greeting is shifted off the content grid | Left edge aligns at 16px. |
| UX-05 | Hero | Helper text is too far from its heading | Heading-to-helper gap is 4px. |
| UX-06 | Hero | Curved bottom edge is missing | Original curve remains visible. |
| UX-07 | Search | Search field loses its pill shape | Pill radius is 999px. |
| UX-08 | Search | Icon is crowded against the field edge | Horizontal padding is 16px. |
| UX-09 | Search | Placeholder contrast is reduced | Placeholder uses #838486. |
| UX-10 | Top restaurants | Section heading is too light | Heading weight is 700. |
| UX-11 | Top restaurants | Subtitle sits too close to the heading | Subtitle follows the original heading spacing. |
| UX-12 | Top restaurants | Ranked card corners are too square | Card radius is 16px. |
| UX-13 | Top restaurants | Card content is inset too little | Horizontal padding is 16px. |
| UX-14 | Top restaurants | Ranking numerals lose emphasis | Rank size is 28px. |
| UX-15 | Top restaurants | All promotion badges are clipped into circles | Promotion badges retain their 8px rounded containers. |
| UX-16 | You visited before | Cards cast an overly dark, low shadow | Cards use the original soft diffuse shadow. |
| UX-17 | You visited before | Image-to-body curve is missing | Curved image edge is visible. |
| UX-18 | You visited before | Product thumbnails are straight instead of tilted | Thumbnails rotate 4deg, -8deg, and 10deg. |
| UX-19 | You visited before | Thumbnail outlines are missing | Subtle 2px thumbnail outlines are visible. |
| UX-20 | Fast & well-rated | Delivery price wraps onto an orphaned next line | Delivery fee stays on the metadata row. |
| UX-21 | From your friends | Photo gutters are too wide | Photo gaps are approximately 8px. |
| UX-22 | From your friends | Friend avatars no longer overlap | Following avatars overlap by 4px. |
| UX-23 | From your friends | Featured price badge becomes a pill | Price badge has 4px corners and 4px horizontal padding; price remains visible. |
| UX-24 | Top grocery stores | Cream background has straight boundaries | The cream background has organic curved top and bottom boundaries. |
| UX-25 | Top grocery stores | All grocery badges are displaced inward | Badges overlap the logo edge at -4px on top and right. |
| UX-26 | Information icons | All help icons are undersized | Information icons measure 16px and remain visible. |
| UX-27 | Save icons | All save affordances are undersized | Save buttons and icons measure 24px across every restaurant row. |
| UX-28 | Restaurant labels | All exclusivity labels become pills | Only on Glovo labels have 4px corners and 4px horizontal padding. |
| UX-29 | Local favourites | Review copy is too small | The full Super large portions and arrived hot review uses 16px text and 20px line-height. |
| UX-30 | Local favourites | Review timestamps are displaced to the right | Review timestamps align with the text at the left edge; wording is retained. |
| UX-31 | Lunch offers | Product cards sit too close together | Product rail gap is 16px. |
| UX-32 | Lunch offers | Product image corners are too square | Image radius is 16px. |
| UX-33 | Lunch offers | Discount badge is on the wrong side | Discount sits 8px from the left edge. |
| UX-34 | Lunch offers | Original prices have too much emphasis | Original prices are secondary 12px regular text; the strikethrough remains visible. |
| UX-35 | Lunch offers | All highlighted delivery badges lose emphasis | Highlighted delivery badges have a yellow background and bold label. |
| UX-36 | Lunch offers | All order-count icons are too small | Every order-count icon is visible and measures 24px. |
| UX-37 | Newcomers | Supporting copy has too much emphasis | Supporting copy uses secondary color and regular weight; all wording remains visible. |
| UX-38 | Navigation | Selected tab label loses its active emphasis | Selected tab label uses black. |
| UX-39 | Section arrows | Every section arrow loses its circular background | Every section arrow has a neutral circular background. |
| UX-40 | Feedback | Confirmation toasts have hard square corners | Confirmation toasts have 12px corners; action messages remain visible. |
| UX-41 | Address | Address control casts a hard downward shadow | Address control does not cast a shadow. |
| UX-42 | Search | Search field has an incorrect inset shadow | Search field has a flat neutral fill and thin border. |
| UX-43 | Top restaurants | All ranked logos become circular | Ranked logos use 16px corners. |
| UX-44 | Top restaurants | Ranked cards have hard offset shadows | Ranked cards are flat with no shadow. |
| UX-45 | You visited before | Tall restaurant cards are nearly square | Tall restaurant card corners have a 16px radius. |
| UX-46 | You visited before | Straight product thumbnails also lose corner rounding | All product thumbnail corners have an 8px radius. |
| UX-47 | You visited before | Product thumbnails cast excessive shadows | Thumbnails use subtle outlines without individual shadows. |
| UX-48 | From your friends | Every food tile has sharp corners | Ordinary tiles have 16px corners and the featured tile has 24px corners. |
| UX-49 | From your friends | Friend avatar circles become rounded squares | All friend avatars are circular. |
| UX-50 | Restaurant photography | All restaurant photo corners are exaggerated | Restaurant photos use a 16px radius. |
| UX-51 | Restaurant photography | All restaurant photos have incorrect drop shadows | Restaurant photos do not cast individual shadows. |
| UX-52 | Top grocery stores | Every grocery logo has square corners | Logo containers and cropped logo images use 16px corners, with original artwork-specific exceptions. |
| UX-53 | Top grocery stores | All grocery logos cast hard offset shadows | Grocery logos have no individual shadows. |
| UX-54 | Local favourites | Review cards have excessive corner rounding | Review cards use 16px corners. |
| UX-55 | Local favourites | Review card shadows are hard and lean left | Review cards use the original soft diffuse shadow. |
| UX-56 | Lunch offers | Product photos have overly heavy shadows | Product photos have no individual shadows. |
| UX-57 | Lunch offers | Every overlaid restaurant logo becomes circular | Overlaid restaurant logos use an 8px corner radius. |
| UX-58 | Lunch offers | All delivery labels have square corners | Delivery labels use a 4px radius. |
| UX-59 | Lunch offers | Discount badge has square corners | Discount badge has a 4px radius. |
| UX-60 | Navigation | Navigation casts a hard upward shadow | Navigation has a thin top border without a hard shadow. |
| UX-61 | Detail panels | Bottom sheets have nearly square upper corners | Bottom sheets have 24px upper corners. |
| UX-62 | Detail panels | All primary and secondary actions lose their pill shape | Action buttons have a pill radius. |
| UX-63 | Detail panels | Detail imagery loses its rounded corners | Detail imagery has a 16px radius. |
| UX-64 | Address form | Address field has an incorrect inset shadow | Address field has 12px corners and no inset shadow. |

Machine-readable ground truth: `src/practice-issues.json`. CSS implementation: `src/practice.css`. Some differences require opening a detail panel or address form.
