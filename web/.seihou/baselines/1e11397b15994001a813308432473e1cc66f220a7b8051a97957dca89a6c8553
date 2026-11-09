"""Copy the explicit publication selection; never crawl the content root."""
import hashlib
import json
from pathlib import Path
import shutil
import sys
root, config_path, output, commit, date = sys.argv[1:]
root, output = Path(root).resolve(), Path(output)
config = json.loads((root / config_path).read_text())
assert config['schemaVersion'] == 1
files = config['documents'] + config['assets']
if len(set(files)) != len(files):
    raise ValueError('Duplicate publication path')
output.mkdir(parents=True)
inventory = []
for relative in sorted(files):
    path = root / relative
    if path.is_symlink() or not path.resolve().is_relative_to(root) or not path.is_file():
        raise ValueError(f'Invalid publication file: {relative}')
    dest = output / relative
    dest.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(path, dest)
    inventory.append({'path': relative, 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()})
(output / 'content.config.json').write_text(json.dumps(config, indent=2) + '\n')
(output / 'content-inventory.json').write_text(json.dumps({'schemaVersion': 1, 'commit': commit, 'date': date, 'files': inventory}, indent=2) + '\n')
