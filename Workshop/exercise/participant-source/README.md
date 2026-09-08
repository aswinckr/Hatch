# Participant app source

This is the standalone practice application. It retains the intended visual discrepancies and content, with no comparison route or answer-key imports.

For the workshop audit, prefer the [compiled download](../participant-app.zip). Do not expose this source project or the Hatch repository to the audit agent.

To rebuild locally:

```sh
npm ci
npm run build
npm run dev
```

The generated `dist` folder is a static site. Use a static web server at its root. The app stores demonstration preferences locally and does not submit payments or orders. Reset site data before comparing versions if you have changed saved items, the address, or the cart.
