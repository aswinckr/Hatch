"""Serve only this app's compiled build, without route fallbacks or write endpoints."""
from pathlib import Path
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from functools import partial
import argparse
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--port',type=int,default=5173)
args=parser.parse_args()
root=Path(__file__).resolve().parent/'dist'
if not (root/'index.html').is_file():raise SystemExit('Run npm run build first.')
class Handler(SimpleHTTPRequestHandler):
 def list_directory(self,path):
  self.send_error(404);return None
server=ThreadingHTTPServer(('127.0.0.1',args.port),partial(Handler,directory=str(root)))
print(f'App: http://127.0.0.1:{args.port}/ — Ctrl+C to stop',flush=True)
try:server.serve_forever()
except KeyboardInterrupt:pass
finally:server.server_close()
