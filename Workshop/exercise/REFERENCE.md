# Reference inputs

The discovery-screen reference is a Figma export captured during the original implementation:

- [Discovery screen PNG](reference/figma-reference.png), 1284 × 11040 pixels, representing the 428 × 3680 design at 3× scale.
- [Original Figma frame](https://www.figma.com/design/GWYvRH1opeuY2lZpIs7Esi/Hatch-Conference---MCP?node-id=5-24131).
- [Discrepancy report-format PNG](reference/discrepancy-format.png), exported from the supplied frame during workshop preparation.
- [Report-format Figma frame](https://www.figma.com/design/GWYvRH1opeuY2lZpIs7Esi/Hatch-Conference---MCP?node-id=17-6587).

Use the discovery-screen export to audit the app. Use the report-format export to discuss how the resulting HTML should communicate a discrepancy. They serve different purposes.

The report-format frame has a dark issue header, Current behavior on the left, Expected behavior on the right, and paired evidence panels. Its sample title, platform label, logo, and example issue are not answers for the discovery app.

## Matching captures

Compare the same component at the same scale and state. A full-page browser capture can place a fixed navigation bar at the current viewport boundary, while a long Figma frame places it at the bottom of the design. Do not count that capture-state mismatch as a proven implementation defect. Use matching regions that avoid the overlay, or capture equivalent prototype states.

For the included skill forward tests, the final matched inputs cover only the top 735 pixels at 428px width. They exclude the fixed-navigation overlay. Those tests verify a bounded visual comparison and HTML output; they do not establish complete page coverage or live interaction behavior.

## Offline fallback

Download the images before the workshop. If Figma access or MCP quota is unavailable, provide the actual exported screenshots directly. Record the evidence source and scale on the worksheet. Screenshot-only runs cannot verify unshown interactions.
