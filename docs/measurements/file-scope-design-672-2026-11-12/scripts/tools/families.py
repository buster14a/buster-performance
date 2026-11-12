#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# families.py WORK.tsv [WORK2.tsv ...] [--top N]: `uarch symbols`' tables by family of function (a name's prefix), in
# millions of user cycles and of instructions, a column pair a table; with --top N, each table's N largest functions.
import sys, collections

FAMILIES = [
    ('the asm matcher and its index (x86_match_*)', ('x86_match',)),
    ('the reader: declarations (check_input_declarat*, _specifiers, _tag*, _bind*, _attribute*, _enum*, _member*, _parameter*, _typedef*)',
     ('check_input_declarat', 'check_input_specifiers', 'check_input_tag', 'check_input_bind', 'check_input_attribute', 'check_input_enum',
      'check_input_member', 'check_input_parameter', 'check_input_typedef', 'check_input_capture', 'check_input_record', 'check_input_function_type')),
    ('the reader: the walk in source order (check_input_resolve_range)', ('check_input_resolve_range',)),
    ('the reader: expressions (check_input_expression*, literals)', ('check_input_expression', 'check_literal', 'check_input_string', 'check_input_literal')),
    ('the reader: setup and unit-wide passes (check_input_run, _intrinsic_initialize, _count_tokens, _binding_answers, _controls, _system_tokens, ...)',
     ('check_input',)),
    ('constants (check_constant_*)', ('check_constant',)),
    ('bindings and environment (c_bindings_*, c_environment_*)', ('c_bindings', 'c_environment')),
    ('the type table (type_*)', ('type_',)),
    ('builtins (cbuiltin_*, builtin_*)', ('cbuiltin', 'builtin_')),
    ('the graph run and its rules (check_graph_*, check_action_*)', ('check_graph', 'check_action')),
    ('warnings (check_common_*, check_unseq_*, check_driver_common_warnings, check_warning_*)', ('check_common', 'check_unseq', 'check_driver_common_warnings', 'check_warning')),
    ('the program and its controls (check_program*, check_control_*, check_return_*)', ('check_program', 'check_control', 'check_return')),
    ('the lowering (check_lower_*)', ('check_lower',)),
    ('initializers and static data (check_init*, check_data_*, check_const_*)', ('check_init', 'check_data', 'check_const_')),
    ('the checker\'s other functions (check_*)', ('check_',)),
    ('the preprocessor (pp_*, predefines_*)', ('pp_', 'predefines')),
    ('the lexer, refinement and interning (tokenize_*, refine_*, intern_*)', ('tokenize', 'refine', 'intern')),
    ('files (files_*, c_files_*, file_*)', ('files_', 'c_files', 'file_')),
    ('the parser (parse_*)', ('parse_',)),
    ('Tier 0 (tier0_*)', ('tier0',)),
    ('the encoder, semantics, sizing, unwind (x86_*, branch_sizing_*, unwind_*)', ('x86_', 'branch_sizing', 'unwind')),
    ('the object writer and the link (object_*, link_*)', ('object_', 'link_')),
    ('arenas and lanes (arena_*, lane_*)', ('arena', 'lane')),
    ('libc memset', ('__memset',)),
    ('libc memcpy and memmove', ('__memmove', '__memcpy')),
    ('libc strcmp, memcmp, strchr, strlen', ('__strcmp', '__memcmp', '__strchr', '__strlen', '__strncmp', '__memchr', '__strnlen', '__stpcpy', '__strcpy')),
    ('libc printf', ('__printf', '_IO_', '__vfprintf', '_itoa', '__vsnprintf', '__snprintf', '___snprintf')),
    ('no symbol ([unknown])', ('[unknown]',)),
]

def family(name):
    for label, prefixes in FAMILIES:
        if any(name.startswith(p) for p in prefixes):
            return label
    return 'everything else'

top = 0
paths = []
arguments = sys.argv[1:]
while arguments:
    a = arguments.pop(0)
    if a == '--top':
        top = int(arguments.pop(0))
    else:
        paths.append(a)
tables = []
for path in paths:
    rows = {}
    header = None
    for line in open(path):
        p = line.rstrip('\n').split('\t')
        if header is None:
            header = p
            continue
        if len(p) >= 3:
            rows[p[0]] = (float(p[1]), float(p[2]))
    tables.append(rows)
labels = [f[0] for f in FAMILIES] + ['everything else']
sums = [collections.defaultdict(lambda: [0.0, 0.0]) for _ in tables]
for i, rows in enumerate(tables):
    for name, (c, n) in rows.items():
        f = family(name)
        sums[i][f][0] += c
        sums[i][f][1] += n
print('family\t' + '\t'.join(f'{p} cycles M\t{p} instructions M' for p in paths))
order = sorted(labels, key=lambda l: -sums[0][l][0])
for l in order:
    if any(s[l][0] for s in sums):
        print(l + '\t' + '\t'.join(f'{s[l][0] / 1e6:.1f}\t{s[l][1] / 1e6:.1f}' for s in sums))
print('total\t' + '\t'.join(f'{sum(v[0] for v in s.values()) / 1e6:.1f}\t{sum(v[1] for v in s.values()) / 1e6:.1f}' for s in sums))
if top:
    for path, rows in zip(paths, tables):
        print(f'\n## {path}: the {top} largest')
        whole = sum(c for c, n in rows.values())
        for name, (c, n) in sorted(rows.items(), key=lambda x: -x[1][0])[:top]:
            print(f'{name}\t{c / 1e6:.1f}\t{100 * c / whole:.2f}%\t{n / 1e6:.1f}')
