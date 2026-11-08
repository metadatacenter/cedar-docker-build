import os
from pathlib import Path
import subprocess
import tempfile
import unittest
import zipfile

INSTALLER = Path(__file__).resolve().parents[1] / 'cedar-server-resource/include/install_cedarat_deps.sh'


class BootstrapArtifactTest(unittest.TestCase):
    def run_installer(self, mode):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory); binaries = root/'bin'; binaries.mkdir()
            (root/'.m2').mkdir(); (root/'.m2/settings.xml').write_text('<settings/>')
            with zipfile.ZipFile(root/'source.jar','w') as archive:
                archive.writestr('META-INF/MANIFEST.MF','Manifest-Version: 1.0\n')
            fake = '''#!/bin/bash
set -eu
[ "$1" = --settings ] && [ "$2" = "$CEDAR_HOME/.m2/settings.xml" ] || exit 90
if [[ "$*" == *:copy* ]]; then
  case "$TEST_MODE" in
    failed) exit 7 ;;
    absent) exit 0 ;;
    valid) cp "$CEDAR_HOME/source.jar" cedar-admin-tool.jar ;;
    corrupt) echo 'not a jar' > cedar-admin-tool.jar ;;
  esac
fi
'''
            (binaries/'mvn').write_text(fake); (binaries/'mvn').chmod(0o755)
            return subprocess.run(['bash',str(INSTALLER)],cwd=root,capture_output=True,text=True,
                env={**os.environ,'PATH':str(binaries)+os.pathsep+os.environ['PATH'],
                     'CEDAR_HOME':str(root),'CEDAR_VERSION':'fixed-train','TEST_MODE':mode}).returncode

    def test_fetch_uses_explicit_settings_and_requires_a_readable_jar(self):
        self.assertEqual(self.run_installer('valid'),0)
        for mode in ('failed','absent','corrupt'):
            with self.subTest(mode=mode):self.assertNotEqual(self.run_installer(mode),0)
