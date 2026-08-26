import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
FRONTENDS = (
    "cedar-frontend-main",
    "cedar-frontend-workspace",
    "cedar-frontend-template-designer",
    "cedar-frontend-openview",
    "cedar-frontend-content",
    "cedar-frontend-monitoring",
    "cedar-frontend-bridging",
)
SOURCE_FRONTENDS = (
    "cedar-frontend-main",
    "cedar-frontend-workspace",
    "cedar-frontend-template-designer",
)


class FrontendReproducibilityTest(unittest.TestCase):

    def dockerfile(self, image: str) -> str:
        return (ROOT / image / "Dockerfile").read_text(encoding="utf-8")

    def test_every_frontend_enforces_the_manifest_tarball_hash_for_trains(self):
        for image in FRONTENDS:
            with self.subTest(image=image):
                dockerfile = self.dockerfile(image)
                self.assertIn("tarballSha256", dockerfile)
                self.assertIn("sha256sum -c -", dockerfile)
                self.assertIn("cedar-build-manifest.json", dockerfile)

    def test_source_frontends_use_the_vendored_shrinkwrap(self):
        for image in SOURCE_FRONTENDS:
            with self.subTest(image=image):
                dockerfile = self.dockerfile(image)
                self.assertIn("test -f npm-shrinkwrap.json", dockerfile)
                self.assertIn("npm ci", dockerfile)
                self.assertNotIn("npm install -g", dockerfile)

    def test_openview_extracts_both_verified_runtime_tarballs_without_train_npm_install(self):
        dockerfile = self.dockerfile("cedar-frontend-openview")
        self.assertIn('install_package "@org.metadatacenter/cedar-embeddable-editor"', dockerfile)
        self.assertIn('install_package "@webcomponents/webcomponentsjs"', dockerfile)
        self.assertIn("package_field", dockerfile)

    def test_main_uses_the_lockfile_local_gulp_binary(self):
        entrypoint = (
            ROOT / "cedar-frontend-main" / "scripts" / "docker-entrypoint.sh"
        ).read_text(encoding="utf-8")
        self.assertIn("./node_modules/.bin/gulp", entrypoint)
        self.assertNotIn("\ngulp\n", entrypoint)


if __name__ == "__main__":
    unittest.main()
