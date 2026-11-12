#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# unit_command.py COMPILE_COMMANDS.json UNIT: the build's own compile command of UNIT (main_unit_checker,
# c_parser_benchmark, ...), from the published compile commands, one argument a line, without its output and its
# dependency file's options (-o, -MD, -MT, -MF and their values), which the caller replaces.
import json
import shlex
import sys

commands, unit = sys.argv[1:3]
matches = [entry for entry in json.load(open(commands)) if entry['file'].endswith('/' + unit + '.c')]
if len(matches) != 1:
    sys.exit(f'{unit}: {len(matches)} compile commands')
arguments = shlex.split(matches[0]['command'])
kept = []
skip = 0
for argument in arguments:
    if skip:
        skip -= 1
    elif argument in ('-o', '-MT', '-MF'):
        skip = 1
    elif argument != '-MD':
        kept.append(argument)
print('\n'.join(kept))
