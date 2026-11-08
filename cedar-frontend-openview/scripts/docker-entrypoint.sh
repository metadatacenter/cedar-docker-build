#!/bin/bash
set -euo pipefail

# Angular derives all API/SSO URLs from this compiled setting. index.html no longer
# contains window.cedarDomain. Keep this entrypoint identical in the three independent
# Docker build contexts; test_angular_runtime_payload.py enforces that contract.
python3 - <<'PY'
import os
from pathlib import Path
import re
import tempfile

root = Path.cwd().resolve()
domain = os.environ.get('CEDAR_HOST', '')
label = r'[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?'
if len(domain) > 253 or not re.fullmatch(label + r'(?:\.' + label + r')+', domain):
    raise SystemExit('CEDAR_HOST must be a valid DNS hostname suffix')
entries = list(root.glob('main-*.js'))
if len(entries) != 1:
    raise SystemExit('Expected exactly one Angular main-*.js entrypoint')
imports = re.compile(rb'''(?:\bfrom\s*|\bimport\s*(?:\(\s*)?)(["'])(\./[A-Za-z0-9_.-]+\.js)\1''')
setting = re.compile(rb'cedarDomain:"[^"\r\n]*"')
pending, visited, matches = entries[:], set(), []
while pending:
    path = pending.pop()
    if path in visited:
        continue
    visited.add(path)
    if path.is_symlink() or not path.is_file() or path.resolve().parent != root:
        raise SystemExit('Missing or external Angular module: ' + path.name)
    content = path.read_bytes()
    matches.extend((path, content) for _ in setting.finditer(content))
    pending.extend(root / match[1].decode('ascii') for match in imports.findall(content))
if len(matches) != 1:
    raise SystemExit('Expected exactly one reachable compiled cedarDomain; found ' + str(len(matches)))
path, before = matches[0]
after = setting.sub(b'cedarDomain:"' + domain.encode('ascii') + b'"', before)
if after != before:
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(dir=root, prefix='.cedar-domain-', delete=False) as stream:
            temporary = Path(stream.name)
            stream.write(after)
        temporary.chmod(path.stat().st_mode & 0o777)
        os.replace(temporary, path)
    finally:
        if temporary is not None:
            temporary.unlink(missing_ok=True)
print('Configured Angular deployment domain: ' + domain)
PY
exec "$@"
