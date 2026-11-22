#!/usr/bin/env python3
"""Replay the #2850 source differential with two Buster binaries and native Clang."""
import argparse
import csv
import gzip
import hashlib
import json
import subprocess
import sys
from collections import Counter
from functools import lru_cache
from pathlib import Path

HERE = Path(__file__).resolve().parent
SUITES = ('focused', 'options', 'warnings', 'real', 'runtime', 'sequence')


def digest(data):
    return hashlib.sha256(data).hexdigest()


@lru_cache(maxsize=None)
def padding(name, count):
    return ''.join(f'typedef int {name}{i};\n' for i in range(count))


def load_sources():
    with gzip.open(HERE / 'sources.jsonl.gz', 'rt') as entries:
        for line in entries:
            record = json.loads(line)
            source = (padding(record['padding'], record['count']) + record['body']).encode()
            if digest(source) != record['sha256']:
                raise ValueError(f"Corrupt source {record['group']}/{record['id']}")
            yield record, source


def run(args):
    result = subprocess.run(args, capture_output=True, timeout=60)
    return result.returncode, result.stdout, result.stderr


def compile_unit(compiler, flags, source, target, suite):
    target.unlink(missing_ok=True)
    if suite == 'options':
        command = [compiler, flags[0], source, '-o', target, *flags[1:]]
    else:
        command = [compiler, *flags, source, '-o', target]
    status, stdout, stderr = run(command)
    native = target.read_bytes() if target.exists() else b''
    return status, stdout, stderr, native


def stable_stderr(stderr, mode):
    if mode == '--selection-census':
        return b''.join(line for line in stderr.splitlines(keepends=True)
                        if not line.startswith(b'selection-census-ticks\t'))
    return stderr


def native_result(clang, obj, exe):
    status, _, stderr = run([clang, '-no-pie', obj, '-o', exe])
    if status:
        raise RuntimeError(f'Native link failed\n{stderr.decode(errors="replace")}')
    return run([exe])


def source_filename(record):
    if record['group'] == 'real':
        return 'probe.c'
    if record['group'] in ('runtime', 'sequence'):
        return f"test{record['id']}.c"
    return record['id'] + '.c'


def check_case(args, suite, mode, flags, path, oracle, directory):
    values = []
    executions = []
    obj = directory / ('out.s' if '-S' in flags else 'out.o')
    for compiler in (args.reference, args.candidate):
        result = compile_unit(compiler, flags, path, obj, suite)
        values.append(result)
        if oracle is not None:
            if result[0] != 0:
                raise RuntimeError(f'{compiler} failed to compile native case {path}')
            executions.append(native_result(args.clang, obj, directory / 'unit'))
    ref, candidate = values
    same = (ref[0] == candidate[0] and ref[1] == candidate[1]
            and stable_stderr(ref[2], mode) == stable_stderr(candidate[2], mode)
            and ref[3] == candidate[3] and executions[:1] == executions[1:])
    clang_match = int(executions[1] == oracle) if executions else ''
    if not same:
        discrepancy = directory / 'differences' / path.stem / mode.replace(' ', '_')
        discrepancy.mkdir(parents=True, exist_ok=True)
        (discrepancy / 'input.c').write_bytes(path.read_bytes())
        for label, (status, stdout, stderr, native) in zip(('ref', 'candidate'), values):
            (discrepancy / f'{label}.status').write_text(str(status) + '\n')
            (discrepancy / f'{label}.stdout').write_bytes(stdout)
            (discrepancy / f'{label}.stderr').write_bytes(stderr)
            (discrepancy / f'{label}.output').write_bytes(native)
    return same, clang_match, ref[0], candidate[0], digest(ref[3]), digest(candidate[3])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--reference', required=True, type=Path)
    parser.add_argument('--candidate', required=True, type=Path)
    parser.add_argument('--clang', required=True, type=Path)
    parser.add_argument('--output', required=True, type=Path, help='an empty or new directory')
    parser.add_argument('--suite', choices=SUITES, action='append', help='repeat to select suites')
    parser.add_argument('--case', help='run a single source id in the selected suites')
    args = parser.parse_args()
    args.output = args.output.resolve()
    if args.output.is_dir() and any(args.output.iterdir()):
        parser.error('choose an empty output directory')
    args.output.mkdir(exist_ok=True, parents=True)
    for name in ('reference', 'candidate', 'clang'):
        tool = getattr(args, name).resolve(strict=True)
        setattr(args, name, tool)
        print(f'{name} {digest(tool.read_bytes())} {tool}', flush=True)
    selected = set(args.suite or SUITES)
    modes = json.loads((HERE / 'modes.json').read_text())
    counts, matched, clang_agreed = Counter(), Counter(), Counter()
    with (args.output / 'replay.tsv').open('w', buffering=1) as stream:
        receipt = csv.writer(stream, delimiter='\t', lineterminator='\n')
        receipt.writerow(('suite', 'case', 'mode', 'same', 'clang_same', 'reference_status',
                          'candidate_status', 'reference_object', 'candidate_object'))
        for entry, source in load_sources():
            if args.case is not None and args.case != entry['id']:
                continue
            applicable = {'focused': ('focused', 'options'), 'pragmas': ('options',)}
            for suite in applicable.get(entry['group'], (entry['group'],)):
                if suite not in selected:
                    continue
                directory = args.output / suite
                directory.mkdir(exist_ok=True)
                path = directory / source_filename(entry)
                path.write_bytes(source)
                oracle = None
                if suite in ('runtime', 'sequence'):
                    exe = directory / 'clang-unit'
                    status, _, stderr = run([args.clang, '-Wno-everything', '-O0', path, '-o', exe])
                    if status:
                        raise RuntimeError(stderr.decode(errors='replace'))
                    oracle = run([exe])
                for mode, flags in modes[suite].items():
                    result = check_case(args, suite, mode, flags, path, oracle, directory)
                    same, clang_match, *evidence = result
                    receipt.writerow((suite, entry['id'], mode, int(same), clang_match, *evidence))
                    counts[suite] += 1
                    matched[suite] += same
                    clang_agreed[suite] += int(clang_match or 0)
    for suite in SUITES:
        if counts[suite]:
            print(f'{suite}: {matched[suite]}/{counts[suite]} matched', end='')
            if suite in ('runtime', 'sequence'):
                print(f', {clang_agreed[suite]}/{counts[suite]} matched Clang', end='')
            print()
    if not counts:
        parser.error('no such case in these suites')
    return int(matched != counts or clang_agreed['sequence'] != counts['sequence'])


if __name__ == '__main__':
    sys.exit(main())
