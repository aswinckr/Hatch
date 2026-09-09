# Original reference app

An independent app containing only the original screen. It has no exercise switch, comparison route, or issue list.

Run `npm ci`, `npm run build`, then serve `dist` as its own static website. For live authoring, use `npm run dev -- --port 5174 --strictPort`.

Keep this app out of the audit agent’s inputs. Give that agent the separate exercise URL and the approved Figma screenshot instead.
