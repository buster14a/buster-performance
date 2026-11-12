#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# census.py FILE.i.gz: a count of a preprocessed unit's tokens by where they are: inside a function's body (a `{` at
# file scope that follows a `)`, to its `}`), inside a file-scope record or enum body or an initializer's braces, and
# the rest of file scope. A lexer of C's preprocessing tokens, enough for a count; `#pragma census_unit NAME` lines
# (census.sh's) separate units. The compiler's own token count differs slightly (it splits `::`, and counts pragmas'
# tokens otherwise), so the shares are what this gives, not the absolute counts.
import gzip, re, sys, collections

TOKEN = re.compile(r'''
    (?P<space>\s+)
  | (?P<pragma>\#[^\n]*)
  | (?P<string>(?:u8|[uUL])?"(?:\\.|[^"\\\n])*")
  | (?P<char>(?:u8|[uUL])?'(?:\\.|[^'\\\n])*')
  | (?P<number>\.?[0-9](?:[eEpP][+-]|[0-9a-zA-Z_.])*)
  | (?P<ident>[A-Za-z_$][A-Za-z_0-9$]*)
  | (?P<punct>\.\.\.|<<=|>>=|->|\+\+|--|<<|>>|<=|>=|==|!=|&&|\|\||[-+*/%&|^]=|\#\#|[-+*/%&|^~!<>=?:;,.()\[\]{}\#])
''', re.X)

def census(text):
    total = collections.Counter()
    units = 0
    depth = 0
    region = 'file scope'
    stack = []
    previous = ''
    bodies = 0
    statements = 0
    body_identifiers = 0
    body_numbers = 0
    body_strings = 0
    position = 0
    n = len(text)
    while position < n:
        m = TOKEN.match(text, position)
        if not m:
            position += 1
            continue
        position = m.end()
        kind = m.lastgroup
        if kind == 'space':
            continue
        if kind == 'pragma':
            if 'census_unit' in m.group():
                units += 1
                depth = 0; region = 'file scope'; stack = []; previous = ''
            continue
        token = m.group()
        if token == '{':
            if depth == 0:
                region = 'function bodies' if previous == ')' else 'file-scope braces (records, enums, initializers)'
                bodies += region == 'function bodies'
            stack.append(region)
            depth += 1
            total[region] += 1
        elif token == '}':
            total[region] += 1
            depth -= 1
            if stack: stack.pop()
            if depth <= 0:
                depth = 0
                region = 'file scope'
        else:
            total[region] += 1
            if region == 'function bodies':
                if token == ';': statements += 1
                if kind == 'ident': body_identifiers += 1
                if kind == 'number': body_numbers += 1
                if kind == 'string': body_strings += 1
        previous = token
    return total, units, bodies, statements, body_identifiers, body_numbers, body_strings

for path in sys.argv[1:]:
    text = gzip.open(path, 'rt', errors='replace').read()
    total, units, bodies, statements, identifiers, numbers, strings = census(text)
    whole = sum(total.values())
    print(f'{path}: {whole} tokens, {max(units, 1)} units, {bodies} function bodies')
    for region, count in total.most_common():
        print(f'  {region}\t{count}\t{100 * count / whole:.1f}%')
    body = total['function bodies']
    if body:
        print(f'  in bodies: {statements} `;` ({body / max(statements, 1):.1f} tokens each), identifiers {100 * identifiers / body:.1f}%, numbers {100 * numbers / body:.1f}%, strings {100 * strings / body:.1f}%; {body / max(bodies, 1):.0f} tokens a body')
