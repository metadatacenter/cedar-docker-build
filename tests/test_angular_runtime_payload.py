import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
ENTRYPOINTS = [ROOT/f'cedar-frontend-{app}/scripts/docker-entrypoint.sh'
              for app in ('openview', 'monitoring', 'bridging')]


class AngularRuntimeTest(unittest.TestCase):
    def run_entry(self, root, domain='metadatacenter.orgx'):
        return subprocess.run(['bash', str(ENTRYPOINTS[0]), 'touch', 'started'], cwd=root,
                              env={**os.environ, 'CEDAR_HOST':domain}, capture_output=True, text=True)

    def fixture(self, root):
        (root/'main-123.js').write_bytes(b'import {x} from "./chunk-env.js";import("./chunk-lazy.js");')
        (root/'chunk-lazy.js').write_bytes(b'export const lazy=1;')
        (root/'chunk-env.js').write_bytes(b'const x={cedarDomain:"metadatacenter.org",ui:"unchanged"};\r\nexport{x};')
        (root/'chunk-env.js').chmod(0o640)
        (root/'index.html').write_text('<script src="main-123.js" type="module"></script>')
        (root/'standalone-cee.js').write_text('/* never touched */')
        (root/'orphan.js').write_text('cedarDomain:"orphan.invalid"')

    def snapshot(self, root):
        return {p.name:(p.read_bytes(),p.stat().st_mode & 0o777) for p in root.iterdir() if p.name!='started'}

    def test_build_contexts_share_the_same_entrypoint(self):
        self.assertTrue(all(p.read_bytes()==ENTRYPOINTS[0].read_bytes() for p in ENTRYPOINTS))

    def test_only_reachable_domain_changes_and_restart_restores_exact_bytes(self):
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory); self.fixture(root); before=self.snapshot(root)
            run=self.run_entry(root); self.assertEqual(run.returncode,0,run.stderr)
            expected=dict(before)
            expected['chunk-env.js']=(before['chunk-env.js'][0].replace(b'metadatacenter.org',b'metadatacenter.orgx'),0o640)
            self.assertEqual(self.snapshot(root),expected)
            self.assertTrue((root/'started').exists())
            self.assertEqual(self.run_entry(root).returncode,0)
            self.assertEqual(self.snapshot(root),expected)
            self.assertEqual(self.run_entry(root,'metadatacenter.org').returncode,0)
            self.assertEqual(self.snapshot(root),before)

    def test_invalid_or_ambiguous_payload_never_mutates_or_starts(self):
        for problem in ('missing-setting','duplicate-setting','missing-chunk','multiple-main','invalid-domain','symlink'):
            with self.subTest(problem=problem), tempfile.TemporaryDirectory() as directory:
                root=Path(directory); self.fixture(root)
                if problem=='missing-setting': (root/'chunk-env.js').write_text('export const x={};')
                if problem=='duplicate-setting': (root/'chunk-lazy.js').write_text('cedarDomain:"another.invalid"')
                if problem=='missing-chunk': (root/'chunk-lazy.js').unlink()
                if problem=='multiple-main': (root/'main-stale.js').write_text('')
                if problem=='symlink':
                    (root/'chunk-lazy.js').unlink(); (root/'chunk-lazy.js').symlink_to('orphan.js')
                before=self.snapshot(root)
                run=self.run_entry(root,'bad";alert(1)' if problem=='invalid-domain' else 'metadatacenter.orgx')
                self.assertNotEqual(run.returncode,0)
                self.assertFalse((root/'started').exists())
                self.assertEqual(self.snapshot(root),before)
