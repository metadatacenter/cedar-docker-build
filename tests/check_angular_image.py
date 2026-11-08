"""Run the image's real unprivileged entrypoint on its published Angular payload."""
import json
from pathlib import Path
import re
import subprocess
import sys
import tempfile


def command(*args):
    return subprocess.check_output(args, text=True).strip()


def verify(image):
    container = command('docker','create','--env','CEDAR_HOST=metadatacenter.orgx',image,'sleep','300')
    try:
        root=json.loads(command('docker','image','inspect',image))[0]['Config']['WorkingDir']
        with tempfile.TemporaryDirectory() as directory:
            def snapshot(name):
                target=Path(directory)/name; target.mkdir()
                subprocess.run(['docker','cp',container+':'+root+'/.',str(target)],check=True)
                return {str(p.relative_to(target)):(p.read_bytes(),p.stat().st_mode & 0o777)
                        for p in target.rglob('*') if p.is_file()}
            before=snapshot('before')
            command('docker','start',container)
            # exec waits until the original entrypoint has completed; both invocations are
            # serialized by waiting for the configured output before doing restart checks.
            subprocess.run(['docker','exec',container,'sh','-c',
                'for i in $(seq 1 60); do [ "$(cat /proc/1/comm)" = sleep ] && exit 0; sleep 1; done; exit 1'],check=True)
            after=snapshot('after')
            assert before.keys()==after.keys(), 'Payload files added/removed'
            changed=[name for name in before if before[name]!=after[name]]
            assert len(changed)==1 and changed[0].endswith('.js'), changed
            name=changed[0]
            expected,count=re.subn(rb'cedarDomain:"[^"]*"',b'cedarDomain:"metadatacenter.orgx"',before[name][0])
            assert count==1 and after[name]==(expected,before[name][1]), 'More than the domain changed'
            command('docker','exec',container,'/docker-entrypoint.sh','true')
            assert snapshot('repeated')==after, 'Configuration is not idempotent'
            command('docker','exec','--env','CEDAR_HOST=metadatacenter.org',container,'/docker-entrypoint.sh','true')
            assert snapshot('restored')==before, 'Production configuration did not restore exact bytes'
            rejected=subprocess.run(['docker','exec','--env','CEDAR_HOST=bad/host',container,'/docker-entrypoint.sh','true'],capture_output=True)
            assert rejected.returncode!=0, 'Invalid domain accepted'
            assert snapshot('rejected')==before, 'Invalid configuration modified payload'
        print('Verified production/non-production runtime configuration, unchanged UI bytes, and restart: '+image)
    finally:
        subprocess.run(['docker','rm','--force',container],check=True)


if __name__=='__main__': verify(sys.argv[1])
