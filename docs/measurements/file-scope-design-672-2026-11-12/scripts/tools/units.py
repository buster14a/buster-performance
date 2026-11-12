#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# units.py IN_DIR SPINE_DIR CENSUS.tsv DECLARATIONS.tsv: for every preprocessed unit IN_DIR/NAME.i (-E -P's text):
#  - writes SPINE_DIR/NAME.i, the unit without its function bodies, by the rule of the first record's spine.py (each
#    file-scope `{` that follows a `)` is replaced, to its `}`, by `;`);
#  - one CENSUS row: its tokens, those in function bodies, in file-scope braces and in the rest of file scope, its
#    bodies, and its file-scope declarations (a `;` at depth 0, or a function definition) by kind;
#  - DECLARATIONS rows, one per distinct file-scope declaration text over all units (bodies cut): its kind, its tokens,
#    and how many units it is in. A declaration's text is its tokens joined by one space.
# The lexer is the first record's census.py's: enough for a count of preprocessing tokens.
import os, re, sys, collections, hashlib

TOKEN = re.compile(r'''
    (?P<space>\s+)
  | (?P<pragma>\#[^\n]*)
  | (?P<string>(?:u8|[uUL])?"(?:\\.|[^"\\\n])*")
  | (?P<char>(?:u8|[uUL])?'(?:\\.|[^'\\\n])*')
  | (?P<number>\.?[0-9](?:[eEpP][+-]|[0-9a-zA-Z_.])*)
  | (?P<ident>[A-Za-z_$][A-Za-z_0-9$]*)
  | (?P<punct>\.\.\.|<<=|>>=|->|\+\+|--|<<|>>|<=|>=|==|!=|&&|\|\||[-+*/%&|^]=|\#\#|[-+*/%&|^~!<>=?:;,.()\[\]{}\#])
''', re.X)

def kind_of(tokens, defined):
    # A file-scope declaration's kind, by its spelling.
    if not tokens:
        return 'empty'
    first = tokens[0]
    has_paren = '(' in tokens
    has_brace = '{' in tokens
    has_assign = '=' in tokens
    if defined:
        return 'function definition'
    if first == 'typedef':
        if has_brace:
            return 'typedef with a record or enum body'
        return 'typedef of a function type or pointer' if has_paren else 'typedef'
    if first == '_Static_assert' or first == 'static_assert':
        return 'static assertion'
    if has_brace and not has_assign:
        return 'record or enum definition' if not has_paren else 'record or enum definition with declarators'
    if has_assign:
        return 'object with an initializer'
    if has_paren:
        return 'prototype or function-pointer object'
    if first in ('struct', 'union', 'enum') and len(tokens) <= 3:
        return 'tag declaration'
    return 'object without an initializer'

def unit(text, spine_path, distinct):
    out = []
    depth = 0
    skipping = False
    previous = ''
    counts = collections.Counter()
    kinds = collections.Counter()
    kind_tokens = collections.Counter()
    current = []
    region = 'file'
    position = 0
    n = len(text)
    def end_declaration(defined):
        nonlocal current
        if current:
            k = kind_of(current, defined)
            kinds[k] += 1
            kind_tokens[k] += len(current)
            key = ' '.join(current)
            entry = distinct.get(key)
            if entry is None:
                distinct[key] = [k, len(current), 1]
            else:
                entry[2] += 1
        current = []
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
        counts['tokens'] += 1
        if token == '{':
            if depth == 0:
                if previous == ')':
                    skipping = True
                    counts['bodies'] += 1
                    out.append(';')
                    region = 'body'
                    end_declaration(True)
                else:
                    region = 'braces'
            depth += 1
            counts[region] += 1
            if not skipping:
                out.append(token)
                current.append(token)
        elif token == '}':
            counts[region] += 1
            depth -= 1
            if skipping:
                if depth == 0:
                    skipping = False
                    region = 'file'
            else:
                out.append(token)
                current.append(token)
                if depth <= 0:
                    depth = 0
                    region = 'file'
        else:
            counts[region] += 1
            if not skipping:
                out.append(token)
                current.append(token)
                if token == ';' and depth == 0:
                    end_declaration(False)
        previous = token
    end_declaration(False)
    if spine_path:
        open(spine_path, 'w', errors='surrogateescape').write(''.join(out))
    return counts, kinds, kind_tokens

in_dir, spine_dir, census_path, declarations_path = sys.argv[1:5]
os.makedirs(spine_dir, exist_ok=True)
distinct = {}
names = sorted(f for f in os.listdir(in_dir) if f.endswith('.i'))
all_kinds = collections.Counter()
all_kind_tokens = collections.Counter()
with open(census_path, 'w') as census:
    census.write('unit\ttokens\tbody\tbraces\tfile\tbodies\tdeclarations\n')
    for name in names:
        text = open(os.path.join(in_dir, name), errors='surrogateescape').read()
        counts, kinds, kind_tokens = unit(text, os.path.join(spine_dir, name), distinct)
        all_kinds.update(kinds)
        all_kind_tokens.update(kind_tokens)
        census.write(f"{name}\t{counts['tokens']}\t{counts['body']}\t{counts['braces']}\t{counts['file']}\t{counts['bodies']}\t{sum(kinds.values())}\n")
    census.write('# kind\tdeclarations\ttokens\n')
    for k, c in all_kinds.most_common():
        census.write(f'# {k}\t{c}\t{all_kind_tokens[k]}\n')
with open(declarations_path, 'w') as out:
    out.write('kind\ttokens\tunits\tsha1\n')
    for key, (k, tokens, units) in sorted(distinct.items(), key=lambda x: -x[1][1] * x[1][2]):
        out.write(f'{k}\t{tokens}\t{units}\t{hashlib.sha1(key.encode("utf-8", "surrogateescape")).hexdigest()[:16]}\n')
