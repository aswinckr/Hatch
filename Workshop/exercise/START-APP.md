# Design QA exercise app

This download contains only the compiled practice website and its assets.

1. Extract this folder outside the Hatch Git checkout.
2. In a terminal, enter this folder.
3. Run: python3 -m http.server 5173 --bind 127.0.0.1
4. Open http://127.0.0.1:5173/ in your browser.

On Windows, `py -m http.server 5173 --bind 127.0.0.1` may be the available command. If the port is occupied, choose another port and record the new URL. Stop the server with Ctrl+C.

Give the audit agent the URL and approved reference images, not this folder's compiled JavaScript or the source repository. A browser downloads compiled assets to display the app, so strict screenshot-only evaluation also requires appropriate tool and environment restrictions.

Use the teacher's agreed viewport and initial state. Do not fix the app. It is an intentionally imperfect exercise. Reset site data if you changed saved items, address, or cart before comparing runs.
