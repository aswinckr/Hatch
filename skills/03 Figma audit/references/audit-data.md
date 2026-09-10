# Audit data reference

Use structured data as the source for generated reports. Paths and exact serialization may vary, but retain the fields below.

## Audit contract

```yaml
audit_id: checkout-mobile-2026-09-10
design:
  tool: penpot # or figma
  url: https://...
  file_revision: revision-or-export-hash
  frame_id: design-node-id
implementation:
  url: http://127.0.0.1:5173/
  route: /
  revision: git-sha
environment:
  browser: Chromium 123
  viewport: { width: 428, height: 926 }
  device_pixel_ratio: 1
  zoom: 100
  locale: en-US
  theme: light
state:
  id: discover-default
  reset: clear localStorage; clear sessionStorage; seed fixture user
```

## Component mapping

```yaml
- component_id: search-field
  state_id: discover-default
  design: { node_id: 'abc-123', name: Search }
  implementation:
    locator: '[data-testid="search"]'
    component: SearchField
    source: src/components/SearchField.tsx:18
  scope: comparable
```

Use a design node ID and implementation locator for every `comparable` result. Names alone are not durable identifiers.

## Comparison record

```yaml
component_id: search-field
property: border-radius
expected: '999px'
actual: '12px'
delta: different
tolerance: exact
result: fail # pass | fail | unavailable | needs-review | not-applicable
evidence:
  expected_crop: artifacts/design/search-field.png
  actual_crop: artifacts/app/search-field.png
  overlay: artifacts/diff/search-field-overlay.png
references:
  design_node_id: abc-123
  implementation_source: src/styles.css:302
```

## Property and tolerance policy

Declare the policy in the contract. A useful default is:

| Property class | Default comparison |
|---|---|
| Asset source, text content, color, font family/weight, border radius, shadow | Exact after normalizing equivalent serializations |
| Position, width, height, padding, margin, gap, icon dimensions | ±1 CSS pixel |
| Typography size, line-height, letter spacing | Exact when extracted from both sources; otherwise reviewer check |
| Pixel image diff | Threshold and ignored regions must be declared; never sole pass/fail criterion |

Normalizing means comparing canonical values, such as resolved RGB colors and normalized shadow syntax, rather than raw tool-specific strings.

## Issue record

An issue contains one root cause and one or more failed comparison records. Include a stable ID, title, component/state scope, severity, expected/current evidence, design/code locators, recommendation, and status. Do not create an issue for a result marked `unavailable` or `needs-review` until a reviewer confirms it.

## Run manifest

Include the audit contract, browser and OS version, capture time, commands used, reset actions, artifact paths, design export hash, app revision, and report path. Never overwrite an old manifest; link a rerun to its prior audit ID.
