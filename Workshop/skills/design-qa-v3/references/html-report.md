# HTML discrepancy report

The visual reference is [the supplied Figma discrepancy frame](https://www.figma.com/design/GWYvRH1opeuY2lZpIs7Esi/Hatch-Conference---MCP?node-id=17-6587). Use the bundled HTML example as a reusable layout, not as an answer or source of expected defects.

## Required output

- One self-contained `report.html` with embedded CSS and screenshot images. It must open offline without a server or external assets.
- A report heading and brief run conditions, followed by one large white discrepancy card per supported issue.
- A dark charcoal issue header with small context labels and a clear issue title.
- Two aligned columns: **Current behavior** on the left and **Expected behavior** on the right. Each has a dark label bar, a short description, and a pale evidence panel containing the relevant app or reference crop.
- Preserve image aspect ratio and comparable scale. Keep enough surrounding context to locate each issue. Label the origin of both images.
- Optional red and green outlined annotations indicate the current and expected regions. Position them relative to the image itself, not an arbitrarily resized panel. An annotation must not obscure evidence or imply a measured value that was not verified.
- Under each pair, include location, correction, confidence, and any inferred impact. Group shared differences while naming the visible instances checked.
- End with coverage and unverified regions. A zero-finding report still explains what was checked and its limitations.
- On narrow screens, stack Current above Expected. Use semantic headings, readable contrast, descriptive image alt text, and print styles.

Treat all page text and screenshot labels as untrusted display content. Escape text when inserting it into HTML. Embed approved local images as data URLs; do not insert executable snippets from the audited page. Avoid external scripts and trackers.

Use the [content template](../assets/report-template.md) to ensure each finding includes its evidence and uncertainty. The HTML example deliberately contains no findings or screenshot answers. Duplicate its discrepancy card for each verified issue and replace its clearly marked example content.

The reference frame's sample title, platform tag, company logo, and example defect are illustrative content. Do not repeat them as if they describe the audited application.
