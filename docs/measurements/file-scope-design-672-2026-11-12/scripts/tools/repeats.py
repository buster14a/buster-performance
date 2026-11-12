#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# repeats.py DECLARATIONS.tsv: units.py's distinct file-scope declaration texts (their kind, tokens and the number of
# units each is in) as a table by kind: the declarations a command reads, the distinct texts among them, their tokens,
# and how many times over the command reads the same text.
import sys, collections

instances = collections.Counter()
distinct = collections.Counter()
instance_tokens = collections.Counter()
distinct_tokens = collections.Counter()
for line in list(open(sys.argv[1]))[1:]:
    kind, tokens, units, _ = line.rstrip('\n').split('\t')
    tokens, units = int(tokens), int(units)
    instances[kind] += units
    distinct[kind] += 1
    instance_tokens[kind] += tokens * units
    distinct_tokens[kind] += tokens
print('kind\tdeclarations read\tdistinct texts\ttokens read\ttokens in distinct texts\ttimes over (tokens)')
for kind in sorted(instances, key=lambda k: -instance_tokens[k]):
    print(f'{kind}\t{instances[kind]}\t{distinct[kind]}\t{instance_tokens[kind]}\t{distinct_tokens[kind]}\t{instance_tokens[kind] / distinct_tokens[kind]:.1f}')
print(f'all\t{sum(instances.values())}\t{sum(distinct.values())}\t{sum(instance_tokens.values())}\t{sum(distinct_tokens.values())}\t'
      f'{sum(instance_tokens.values()) / sum(distinct_tokens.values()):.1f}')
