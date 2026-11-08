"""Check actual nginx responses in an unprivileged modern frontend image."""
from pathlib import Path
import re
import subprocess
import sys
import tempfile

APPS = {'workspace':('cedar-workspace/app',4201), 'template-designer':('cedar-template-designer/app',4202),
        'openview':('cedar-openview-dist',4220), 'monitoring':('cedar-monitoring-dist',4300),
        'bridging':('cedar-bridging-dist',4340), 'content':('cedar-content-distribution',4240)}


def verify(image):
    app=image.rsplit('/',1)[-1].split(':',1)[0].removeprefix('cedar-frontend-')
    root,port=APPS[app]
    container=subprocess.check_output(['docker','create','--entrypoint','nginx',image,'-g','daemon off;'],text=True).strip()
    try:
        with tempfile.TemporaryDirectory() as directory:
            probes={'mjs':('export const ready = true;','application/javascript'),
                    'js':('window.ready=true;','application/javascript'),
                    'css':('body { color: black; }','text/css'), 'html':('<p>ready</p>','text/html')}
            for extension,(body,_) in probes.items():
                path=Path(directory)/('cedar-mime-probe.'+extension);path.write_text(body)
                subprocess.run(['docker','cp',str(path),f'{container}:/srv/cedar/{root}/{path.name}'],check=True)
            subprocess.run(['docker','start',container],check=True)
            def request(path):
                return subprocess.check_output(['docker','exec',container,'curl','--silent','--show-error',
                    '--retry','20','--retry-connrefused','--retry-delay','1','--max-time','5',
                    '--dump-header','-',f'http://127.0.0.1:{port}/{path}'],text=True,timeout=40)
            for extension,(body,mime) in probes.items():
                response=request('cedar-mime-probe.'+extension)
                headers,content=response.split('\n\n',1)
                assert re.search(r'^HTTP/\S+ 200 ',headers), headers
                assert re.search(r'^Content-Type: '+re.escape(mime)+r'(?:;[^\r\n]*)?$',headers,re.M|re.I), headers
                assert content==body, 'Static payload bytes changed'
            missing=request('cedar-mime-missing.mjs').split('\n',1)[0]
            assert ' 404 ' in missing, 'Missing module fell back to HTML: '+missing
        print('Verified JavaScript module MIME, unchanged existing MIME types, and missing-module 404: '+image)
    finally:
        subprocess.run(['docker','rm','--force','--volumes',container],check=True)


if __name__=='__main__':verify(sys.argv[1])
