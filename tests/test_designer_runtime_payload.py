import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ENTRYPOINT = Path(__file__).resolve().parents[1]/'cedar-frontend-template-designer/scripts/docker-entrypoint.sh'


class DesignerPayloadTest(unittest.TestCase):
    def test_startup_configures_frozen_payload_without_build_inputs_and_rejects_corruption(self):
        for corrupt in (False, True):
            with self.subTest(corrupt=corrupt), tempfile.TemporaryDirectory() as directory:
                root=Path(directory);(root/'app/components').mkdir(parents=True);(root/'app/config').mkdir();(root/'scripts').mkdir();(root/'identity').mkdir()
                bundle=b'/* preserved shared CEE and CED */';(root/'app/components/cedar-editors.js').write_bytes(bundle)
                inventory={'files':[{'path':'components/cedar-editors.js','sha256':hashlib.sha256(bundle).hexdigest()}]}
                (root/'app/components/page-size.json').write_text(json.dumps(inventory))
                (root/'identity/cedar-source-commit').write_text('a'*40);(root/'identity/cedar-package-sha256').write_text('b'*64)
                (root/'scripts/designer.mjs').write_text("import fs from 'node:fs'; if(process.argv[2]!=='configure') throw new Error('Runtime compilation forbidden'); fs.writeFileSync('app/config/version.js','configured');")
                script=ENTRYPOINT.read_text().replace('/usr/local/share/',str(root/'identity')+'/')
                (root/'entrypoint.sh').write_text(script)
                if corrupt:(root/'app/components/cedar-editors.js').write_text('tampered')
                run=subprocess.run(['bash',str(root/'entrypoint.sh'),'true'],cwd=root,capture_output=True,text=True,
                    env={**os.environ,'CEDAR_HOST':'metadatacenter.orgx','CEDAR_APPLICATION_ID':'cedar-template-designer','PACKAGE_VERSION':'fixed'})
                self.assertEqual(run.returncode==0,not corrupt,run.stderr)
                if not corrupt:
                    self.assertEqual((root/'app/components/cedar-editors.js').read_bytes(),bundle)
                    self.assertEqual((root/'app/config/version.js').read_text(),'configured')
                    self.assertEqual(json.loads((root/'app/config/build-info.json').read_text())['sourceCommit'],'a'*40)
                else:self.assertFalse((root/'app/config/version.js').exists())
