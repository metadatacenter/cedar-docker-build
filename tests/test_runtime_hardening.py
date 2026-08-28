import json
from pathlib import Path
import re
import unittest


ROOT = Path(__file__).resolve().parents[1]


class RuntimeHardeningTest(unittest.TestCase):
    def test_every_cedar_base_image_reference_uses_the_configurable_identity(self):
        cedar_base = re.compile(r"^FROM\s+\S*cedar-(?:java|microservice):\S+")
        configurable = re.compile(
            r"^FROM \$\{CEDAR_IMAGE_PREFIX\}/cedar-(?:java|microservice):"
            r"\$\{CEDAR_DOCKER_VERSION\}(?: AS [A-Za-z0-9._-]+)?$"
        )
        references = []
        for dockerfile in sorted(ROOT.glob("*/Dockerfile")):
            for line_number, line in enumerate(
                dockerfile.read_text(encoding="utf-8").splitlines(), start=1
            ):
                if cedar_base.match(line):
                    references.append((dockerfile, line_number, line))
                    self.assertRegex(
                        line,
                        configurable,
                        f"{dockerfile.relative_to(ROOT)}:{line_number} must use the configurable "
                        "CEDAR image prefix and version",
                    )
        self.assertTrue(references, "No internal CEDAR base-image references were found")

    def test_keycloak_realm_seed_contains_no_generated_key_material(self):
        realm = json.loads((
            ROOT
            / "cedar-infra-keycloak"
            / "config"
            / "keycloak-realm.CEDAR.development.2023-07-05.json"
        ).read_text(encoding="utf-8"))
        providers = realm.get("components", {}).get(
            "org.keycloak.keys.KeyProvider", []
        )
        self.assertEqual(
            [],
            providers,
            "Realm seeds must let each Keycloak installation generate unique providers",
        )

    def test_microservice_base_runs_as_fixed_non_root_user_without_dead_toolchain(self):
        dockerfile = (ROOT / "cedar-microservice" / "Dockerfile").read_text(encoding="utf-8")
        self.assertIn("USER cedar:cedar", dockerfile)
        self.assertIn("useradd --uid 10001 --gid 10001", dockerfile)
        for package in ("gcc", "python3-devel", "yum-utils"):
            self.assertNotRegex(dockerfile, rf"microdnf[^\n]*install[^\n]*\b{package}\b")

    def test_java_runtime_images_fetch_their_jars_in_a_throwaway_stage(self):
        java = (ROOT / "cedar-java" / "Dockerfile").read_text(encoding="utf-8")
        for package in ("maven", "wget", "bsdtar", "unzip"):
            self.assertNotRegex(
                java,
                rf"microdnf[^\n]*install[^\n]*\b{package}\b",
                "cedar-java is a runtime base; build tooling belongs in the jar-fetch stage",
            )
        for dockerfile in sorted(ROOT.glob("cedar-server-*/Dockerfile")):
            with self.subTest(dockerfile=dockerfile.parent.name):
                text = dockerfile.read_text(encoding="utf-8")
                self.assertIn("AS jarfetch", text)
                self.assertIn(
                    "COPY --from=jarfetch --chown=cedar:cedar",
                    text,
                    "the runtime stage takes the fetched jars and nothing else from the fetch stage",
                )
                fetch, runtime = text.split("\nFROM ", 2)[1:]
                self.assertIn("install_deps.sh", fetch)
                self.assertNotIn(
                    "install_deps.sh", runtime,
                    "the runtime stage must not run Maven",
                )

    def test_frontend_nginx_runs_unprivileged(self):
        for dockerfile in sorted(ROOT.glob("cedar-frontend-*/Dockerfile")):
            with self.subTest(dockerfile=dockerfile.parent.name):
                text = dockerfile.read_text(encoding="utf-8")
                self.assertIn(
                    "ENV CEDAR_HOME=/srv/cedar",
                    text,
                    "the app-home variable used during ownership setup must be defined",
                )
                self.assertIn("USER nginx:nginx", text)
                self.assertIn("pid /tmp/nginx.pid;", text)
                self.assertRegex(
                    text, r"chown -R nginx:nginx [^\n]*/var/cache/nginx",
                    "nginx's cache and the app home must belong to the unprivileged user",
                )

    def test_no_server_downgrades_the_shared_redis_client(self):
        for dockerfile in sorted(ROOT.glob("cedar-server-*/Dockerfile")):
            with self.subTest(dockerfile=dockerfile.parent.name):
                self.assertNotIn("redis==2.10.6", dockerfile.read_text(encoding="utf-8"))

    def test_runtime_uses_a_user_owned_ca_truststore(self):
        dockerfile = (ROOT / "cedar-microservice" / "Dockerfile").read_text(encoding="utf-8")
        entrypoint = (
            ROOT / "cedar-microservice" / "scripts" / "docker-entrypoint.sh"
        ).read_text(encoding="utf-8")
        self.assertIn("CEDAR_TRUSTSTORE", dockerfile)
        self.assertIn('-keystore "${CEDAR_TRUSTSTORE}"', entrypoint)
        self.assertIn('-Djavax.net.ssl.trustStore="${CEDAR_TRUSTSTORE}"', entrypoint)
        self.assertNotIn("${JAVA_HOME}/lib/security/cacerts", entrypoint)

    def test_immediate_security_base_updates_are_applied(self):
        java = (ROOT / "cedar-java" / "Dockerfile").read_text(encoding="utf-8")
        manifest = (ROOT / "bin" / "cedar-images-base.sh").read_text(encoding="utf-8")
        self.assertNotIn("17.0.8_7-jre-ubi9-minimal", java)
        nginx = re.search(r"^export NGINX_VERSION=(\S+)$", manifest, re.MULTILINE)
        self.assertIsNotNone(nginx)
        self.assertNotEqual("1.23.4", nginx.group(1))

    def test_renovate_configuration_exposes_a_dashboard_and_manages_base_pins(self):
        config = json.loads((ROOT / "renovate.json").read_text(encoding="utf-8"))
        self.assertTrue(config["dependencyDashboard"])
        managers = config["customManagers"]
        self.assertTrue(any("bin/cedar-images-base" in " ".join(
            manager.get("managerFilePatterns", [])) for manager in managers))
        java = (ROOT / "cedar-java" / "Dockerfile").read_text(encoding="utf-8")
        self.assertRegex(java, r"^FROM eclipse-temurin:", re.MULTILINE)


if __name__ == "__main__":
    unittest.main()
