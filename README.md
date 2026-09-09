# Hatch

Two independent web apps for a design QA exercise. Start your own skills from scratch.

| Folder | What it contains | Local address |
| --- | --- | --- |
| `app-with-mistakes/` | The screen with intentional mistakes | http://127.0.0.1:5173/ |
| `app-original/` | The original screen | http://127.0.0.1:5174/ |
| `skills/` | Empty workspace for the skills you create | — |

## Run an app

Requires Node.js/npm and Python 3. In a terminal:

```sh
cd app-with-mistakes
npm ci
npm run build
npm start
```

For the original, open another terminal and run the same commands inside `app-original`. Each app runs independently. Stop it with Ctrl+C. Use `npm run dev` instead when actively editing the app; for the audit exercise, use `npm start` to serve only the compiled build.

## Figma reference

[Open the expected screen in Figma](https://www.figma.com/design/GWYvRH1opeuY2lZpIs7Esi/Hatch-Conference---MCP?node-id=5-24131).

Give the audit skill the mistakes-app URL and the Figma reference. Neither app contains a comparison page or a switch to the other version. Keep source files and the original app out of the audit agent’s accessible inputs when testing screenshot-only comparison.

The local `skills/` folder is intentionally empty. Git does not track empty directories; after a fresh clone, create it with `mkdir -p skills` (or create a folder named `skills` in your file manager).

Earlier workshop materials and exercises are preserved in a local backup outside this folder and in prior GitHub commits.
