#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# spine.py IN.i OUT.i: a preprocessed unit without its function bodies: each file-scope `{` that follows a `)` is
# replaced, to its matching `}`, by `;`, which turns the definition into a declaration. What is left is the unit's
# file scope (its declarations, record and enum bodies and initializers): compiled beside the whole unit, it gives each
# stage's time for the file scope alone, and by difference the bodies'. Everything else is copied byte for byte.
import re, sys

TOKEN = re.compile(r'''
    (?P<space>\s+)
  | (?P<pragma>\#[^\n]*)
  | (?P<string>(?:u8|[uUL])?"(?:\\.|[^"\\\n])*")
  | (?P<char>(?:u8|[uUL])?'(?:\\.|[^'\\\n])*')
  | (?P<number>\.?[0-9](?:[eEpP][+-]|[0-9a-zA-Z_.])*)
  | (?P<ident>[A-Za-z_$][A-Za-z_0-9$]*)
  | (?P<punct>\.\.\.|<<=|>>=|->|\+\+|--|<<|>>|<=|>=|==|!=|&&|\|\||[-+*/%&|^]=|\#\#|[-+*/%&|^~!<>=?:;,.()\[\]{}\#])
''', re.X)

text = open(sys.argv[1], errors='surrogateescape').read()
out = []
depth = 0
skipping = False
previous = ''
bodies = 0
kept = 0
dropped = 0
position = 0
n = len(text)
while position < n:
    m = TOKEN.match(text, position)
    if not m:
        if not skipping: out.append(text[position])
        position += 1
        continue
    position = m.end()
    kind = m.lastgroup
    token = m.group()
    if kind in ('space', 'pragma'):
        if not skipping: out.append(token)
        continue
    if token == '{':
        if depth == 0 and previous == ')':
            skipping = True
            bodies += 1
            out.append(';')
        depth += 1
        if skipping: dropped += 1
        else: out.append(token); kept += 1
    elif token == '}':
        depth -= 1
        if skipping:
            dropped += 1
            if depth == 0: skipping = False
        else:
            out.append(token); kept += 1
    else:
        if skipping: dropped += 1
        else: out.append(token); kept += 1
    previous = token
open(sys.argv[2], 'w', errors='surrogateescape').write(''.join(out))
print(f'{bodies} bodies dropped: {dropped} tokens of {kept + dropped}; {kept + bodies} kept (a `;` for each body)')
