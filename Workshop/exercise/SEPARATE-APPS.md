# Two independent web apps

The exercise and original now have separate source projects, builds, ZIP downloads, browser origins, and static file roots. Neither app contains a switch, a link to the other app, the comparison page, or a route that serves the other version.

| App | Local address | Download | Purpose |
| --- | --- | --- | --- |
| Exercise | http://127.0.0.1:5173/ | [participant-app.zip](participant-app.zip) | Screen with intentional mistakes; give this URL to the audit skill. |
| Original | http://127.0.0.1:5174/ | [reference-app.zip](reference-app.zip) | Presenter’s original screen; keep this out of audit inputs. |

Use the [Figma reference](https://www.figma.com/design/GWYvRH1opeuY2lZpIs7Esi/Hatch-Conference---MCP?node-id=5-24131) as the expected design during the skill exercise.

## Start the exercise only

From the repository root:

```sh
python3 Workshop/tools/serve-apps.py
```

The default starts only the exercise app. For your own demonstration, run both:

```sh
python3 Workshop/tools/serve-apps.py --only both
```

The launcher extracts compiled assets into temporary folders outside the repository. It serves those folders only, with no directory listings, write API, source files, or SPA route fallback. `/practice` and `/compare` return 404; use each app’s root URL. Stop with Ctrl+C. If a port is occupied, stop the old app or choose ports with `--exercise-port` and `--reference-port`.

For an attendee, the participant ZIP alone is sufficient; its README explains how to serve it without the repository or launcher.

## Rebuild

Each source folder is a complete independent Vite project. In `participant-source` or `reference-source`, run `npm ci` and `npm run build`. Then run `python3 Workshop/tools/package-exercise.py` or `python3 Workshop/tools/package-reference.py` from the repository root.

## What this separation achieves

A skill cannot switch routes inside the exercise app to discover the original or comparison page, and the static server has no endpoint for replacing app files. It can still read visible content and compiled assets needed by a browser. An unrestricted agent with filesystem access or other browser tabs could find other material, so a strict audit must expose only the exercise URL, selected skill, and approved Figma images. Use a fresh audit task, disable edits, and do not mount the full Hatch repository. Run only the exercise server when auditing.

The earlier combined app remains in your original local folder and instructor backup for recovery; it is no longer the server used at the exercise URL.
