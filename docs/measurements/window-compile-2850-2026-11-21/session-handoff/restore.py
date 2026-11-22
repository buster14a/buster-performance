#!/usr/bin/env python3
"""Restore one indexed Buster research checkout from a full GitHub clone and this packet."""
import argparse
import csv
import hashlib
import pathlib
import subprocess
import tarfile

packet = pathlib.Path(__file__).resolve().parent
cli = argparse.ArgumentParser(description=__doc__)
cli.add_argument('repo', type=pathlib.Path, help='existing Buster clone with main history')
cli.add_argument('snapshot', help='first column of source-index.tsv')
cli.add_argument('destination', type=pathlib.Path, help='new worktree path')
cli.add_argument('--overlay', action='store_true', help='also restore local staged, unstaged and new source files')
args = cli.parse_args()
repo = args.repo.resolve()
dest = args.destination.resolve()
if dest.exists():
    cli.error('choose a new destination directory')

def table(filename):
    with (packet / filename).open() as f:
        return list(csv.DictReader(f, delimiter='\t'))

matches = [row for row in table('source-index.tsv') if row['snapshot'] == args.snapshot]
if len(matches) != 1:
    cli.error('unknown snapshot')
commit = matches[0]['commit']
bundle = packet / 'compiler-sources.bundle'
subprocess.run(['git', '-C', repo, 'fetch', '--quiet', str(bundle),
                'refs/heads/snapshot/*:refs/2850-handoff/snapshot/*'], check=True)
subprocess.run(['git', '-C', repo, 'worktree', 'add', '--quiet', '--detach', dest, commit], check=True)
if args.overlay:
    with tarfile.open(packet / 'uncommitted-patches.tar.gz') as archive:
        for row in table('overlays.tsv'):
            if row['snapshot'] != args.snapshot:
                continue
            if row['base_commit'] != commit:
                raise ValueError('overlay base differs from selected commit')
            data = archive.extractfile(row['file']).read()
            if hashlib.sha256(data).hexdigest() != row['sha256']:
                raise ValueError('overlay digest differs')
            if row['layer'] == 'new-file':
                relative = pathlib.Path(row['file']).relative_to(args.snapshot, 'new')
                target = (dest / relative).resolve()
                if not target.is_relative_to(dest) or target.exists():
                    raise ValueError('invalid new file destination')
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(data)
            else:
                stage = ['--index'] if row['layer'] == 'staged' else []
                subprocess.run(['git', '-C', dest, 'apply', '--binary', '--whitespace=nowarn', *stage, '-'], input=data, check=True)
print(f'{dest}  {commit}')
