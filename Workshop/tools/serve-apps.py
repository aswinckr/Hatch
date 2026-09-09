"""Run independent static apps; expose compiled files only, with no app-switching routes."""
from pathlib import Path
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from functools import partial
import argparse,tempfile,zipfile,threading
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--only',choices=['exercise','reference','both'],default='exercise')
parser.add_argument('--exercise-port',type=int,default=5173)
parser.add_argument('--reference-port',type=int,default=5174)
args=parser.parse_args()
root=Path(__file__).resolve().parents[1]/'exercise'
class Handler(SimpleHTTPRequestHandler):
 def list_directory(self,path):
  self.send_error(404);return None
servers=[]
with tempfile.TemporaryDirectory(prefix='hatch-independent-apps-') as temp:
 try:
  for kind,archive,folder,port in [('exercise','participant-app.zip','participant-app',args.exercise_port),('reference','reference-app.zip','reference-app',args.reference_port)]:
   if args.only not in [kind,'both']:continue
   target=Path(temp)/kind;target.mkdir()
   with zipfile.ZipFile(root/archive) as z:
    # Packages are built by this project; reject unexpected archive paths before extraction.
    for name in z.namelist():
     p=Path(name)
     if p.is_absolute() or '..' in p.parts:raise ValueError('Unsafe archive member')
    z.extractall(target)
   webroot=target/folder
   (webroot/'README.md').unlink(missing_ok=True)
   server=ThreadingHTTPServer(('127.0.0.1',port),partial(Handler,directory=str(webroot)))
   servers.append(server)
   threading.Thread(target=server.serve_forever,daemon=True).start()
   print(f'{kind.capitalize()}: http://127.0.0.1:{port}/',flush=True)
  print('Separate origins and static roots. Ctrl+C stops this launcher.',flush=True)
  threading.Event().wait()
 except KeyboardInterrupt:pass
 finally:
  for server in servers:server.shutdown();server.server_close()
