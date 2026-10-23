#!/usr/bin/env python3
"""Positive manifest plus single-fault controls for every GTM gate rule."""
import json
from pathlib import Path
import subprocess
import sys

gate = [sys.executable, 'scripts/check-gtm.py', '--manifest']
subprocess.run(gate + ['fixtures/gtm/manifest.json'], check=True)
cases = json.loads(Path('fixtures/gtm-invalid/expected.json').read_text())
for name, rule in cases.items():
    result = subprocess.run(gate + [f'fixtures/gtm-invalid/{name}/manifest.json'],
                            text=True, capture_output=True)
    lines = [line for line in result.stderr.splitlines() if ' [' in line]
    if result.returncode != 1 or len(lines) != 1 or f'[{rule}]' not in lines[0]:
        sys.exit(f'{name}: expected one {rule} fault, got {result.returncode}\n'
                 f'{result.stdout}{result.stderr}')
    print(f'OK: GTM rejects {name} only for {rule}')
