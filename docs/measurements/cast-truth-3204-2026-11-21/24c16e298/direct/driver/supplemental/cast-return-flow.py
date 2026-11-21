#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE.
"""Compare Clang's three return-flow outcomes by function, under ordinary and strict FP."""
import argparse
import itertools
from pathlib import Path
import re
import subprocess
import tempfile


def nested():
    bases = ['256', '0', '1', '(1ULL<<44)', '((1ULL<<54)+1)', '1.0', '0.5',
             '(x||1)', '(x&&0)', '(1||x)', '(0&&x)', '(long)&g', '((_Bool)&g)',
             '(int _Complex)256', '__extension__ 1.0i', '((void)x,42)']
    types = ['char', 'unsigned char', 'int', 'long', 'double', 'float', 'long double',
             '_Float16', '_Bool', 'double _Complex', 'float _Complex', 'int _Complex']
    for value, inner, outer in itertools.product(bases, types, types):
        yield f'({outer})({inner})({value})'


def wide():
    types = ['float', 'double', 'long double', '_Float16', '__bf16', '__float128',
             'float _Complex', 'int']
    terms = [(0, 0), (1, 0), (-1, 0), (-1, 1), (1, 15), (1, 65), (-1, 100),
             (1, 127), (3, 127), (1, 190)]
    for width, sign, target, (value, shift), delta in itertools.product(
            (129, 257), ('', 'unsigned '), types, terms, (0, 1)):
        if shift >= width or (value < 0 and shift):
            continue
        if value >= 0 and value.bit_length() + shift >= width and not sign:
            continue
        yield f'({target})((({sign}_BitInt({width})){value}<<{shift})+{delta})'


def wide_chain():
    bases = ['(unsigned _BitInt(257))256', '(unsigned _BitInt(257))1',
             '(unsigned _BitInt(257))0', '((unsigned _BitInt(257))1<<190|1)',
             '(long)&g', '(_BitInt(257))(long)&g']
    types = ['float', 'double', '_Float16', '__float128', 'int', 'unsigned char', '_Bool']
    for value, inner, outer in itertools.product(bases, types, types):
        yield f'({outer})({inner})({value})'


def queries():
    bases = ['(__builtin_constant_p(x))', '(__builtin_constant_p(1))', '(__builtin_constant_p(g))',
             '(__builtin_expect(x||1,1))', '(x||1)==1', '(long)&g', '(long)&w', '(long)&a[1]',
             '(long)&fun', '((_Bool)(long)&g)', '(char)(long)&g', '1.0', '(x||1)', '(1||x)',
             '(x&&0)', '(0&&x)', '!x', '(x,1)', '(x=1)', '(1.0/10.0)', '(x?1:1)']
    types = ['_Bool', 'char', 'double', 'long double', 'float', 'int', 'long', '__int128', '']
    for value, target in itertools.product(bases, types):
        sub = (f'({target})' if target else '') + f'({value})'
        yield sub
        yield f'!({sub})'
        yield f'(double)({sub})'
        yield f'({sub}) || x'


def measure(compiler, source):
    process = subprocess.run([compiler, '-fsyntax-only', '-Wno-everything', '-Wreturn-type',
                              '-fno-caret-diagnostics', str(source)], capture_output=True, text=True)
    if process.returncode:
        raise SystemExit(process.stderr)
    outcomes = {}
    for row in process.stderr.splitlines():
        match = re.fullmatch(r'.*?:(\d+):\d+: warning: non-void function does not return a value( in all control paths)? \[-Wreturn-type\]', row)
        if not match:
            raise ValueError(f'unclassified diagnostic: {row}')
        outcomes[int(match[1])] = 'mixed' if match[2] else 'never'
    return outcomes


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('clang', 'baseline', 'candidate'):
        parser.add_argument('--' + name, required=True, type=Path)
    args = parser.parse_args()
    compilers = [str(path.resolve()) for path in (args.clang, args.baseline, args.candidate)]
    print('matrix\tfenv\tfunctions\tbaseline-differences\tcandidate-differences\tnew-differences')
    new_total = 0
    with tempfile.TemporaryDirectory() as directory:
        for generator, env in itertools.product((nested, wide, wide_chain, queries), ('OFF', 'ON')):
            script = [f'#pragma STDC FENV_ACCESS {env}', 'long g;', 'int a[3];',
                      'extern int w __attribute__((weak));', 'int fun(void);']
            rows = {}
            for expression in generator():
                line = len(script) + 1
                script.append(f'int f{line}(int x) {{ if ({expression}) return 1; }}')
                rows[line] = expression
            source = Path(directory, f'{generator.__name__}-{env}.c')
            source.write_text('\n'.join(script) + '\n')
            clang, baseline, candidate = [measure(compiler, source) for compiler in compilers]
            before = sum(baseline.get(line) != clang.get(line) for line in rows)
            after = sum(candidate.get(line) != clang.get(line) for line in rows)
            new = sum(candidate.get(line) != clang.get(line) and candidate.get(line) != baseline.get(line) for line in rows)
            print(generator.__name__, env, len(rows), before, after, new, sep='\t')
            new_total += new
    return int(new_total != 0)


if __name__ == '__main__':
    raise SystemExit(main())
