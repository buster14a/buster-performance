#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# constructs.py FILE.i.gz...: which constructs the function bodies of a preprocessed unit hold, by spelling: for each
# construct, the bodies with at least one and those bodies' share of the body tokens, and for some sets of constructs
# the bodies free of all of them. A lexical proxy (census.py's lexer and its rule for a body): it sees spellings, not
# types, so a bit-field's access, an aggregate's copy or a variable-length array is not in it (the inventory counts
# those by node). `#pragma census_unit` lines separate units.
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

WORDS = {
    'asm': {'asm', '__asm__', '__asm'},
    '_Generic': {'_Generic'},
    'typeof or __auto_type': {'typeof', '__typeof__', '__typeof', 'typeof_unqual', '__auto_type'},
    'va_arg and friends': {'__builtin_va_arg', '__builtin_va_start', '__builtin_va_end', '__builtin_va_copy'},
    'goto': {'goto'},
    'switch': {'switch'},
    'static local': {'static'},
    'extern in a body': {'extern'},
    'long double, _Complex, _Atomic, __int128, _BitInt': {'_Complex', '__complex__', '_Atomic', '__int128', '_BitInt', '__float128', '_Float128'},
    'float or double': {'float', 'double'},
    'sizeof or alignof': {'sizeof', '_Alignof', '__alignof__', 'alignof', '__alignof'},
    '__attribute__ in a body': {'__attribute__', '__attribute'},
    '__extension__': {'__extension__'},
    'struct, union or enum keyword': {'struct', 'union', 'enum'},
    '__func__': {'__func__', '__FUNCTION__', '__PRETTY_FUNCTION__'},
}

def bodies_of(text):
    position = 0
    n = len(text)
    depth = 0
    in_body = False
    previous = ''
    before = ''
    tokens = 0
    found = set()
    while position < n:
        m = TOKEN.match(text, position)
        if not m:
            position += 1
            continue
        position = m.end()
        kind = m.lastgroup
        if kind == 'space':
            continue
        token = m.group()
        if kind == 'pragma':
            if 'census_unit' in token:
                depth = 0; in_body = False; previous = ''
            elif in_body:
                found.add('#pragma in a body')
            continue
        if token == '{':
            if depth == 0 and previous == ')':
                in_body = True; tokens = 0; found = set()
            elif in_body:
                if previous == '(':
                    found.add('statement expression')
                elif previous == ')' :
                    pass
                elif previous in ('=', ',', '{', '[', ']') or before == '=':
                    found.add('brace initializer')
            depth += 1
        elif token == '}':
            depth -= 1
            if depth <= 0:
                depth = 0
                if in_body:
                    yield tokens + 1, found
                in_body = False
        if in_body:
            tokens += 1
            if kind == 'ident':
                if token.startswith('__builtin_') and token not in WORDS['va_arg and friends']:
                    found.add('__builtin_ name' if token != '__builtin_expect' else '__builtin_expect')
                for name, words in WORDS.items():
                    if token in words:
                        if name == 'long double, _Complex, _Atomic, __int128, _BitInt' or name != 'float or double':
                            found.add(name)
                        else:
                            found.add(name)
            elif kind == 'string':
                found.add('string literal')
            elif token == '?':
                found.add('?:')
            elif token in ('&&', '||'):
                found.add('&& or ||')
            elif token == '*' and previous == 'goto':
                found.add('computed goto')
            elif token == '{' and previous == ')' and depth > 1 and before != 'B':
                pass
            if token == 'double' and previous == 'long':
                found.add('long double, _Complex, _Atomic, __int128, _BitInt')
        before = 'B' if token == ')' else previous
        previous = token

for path in sys.argv[1:]:
    text = gzip.open(path, 'rt', errors='replace').read()
    counts = collections.Counter()
    weights = collections.Counter()
    bodies = 0
    total = 0
    rows = []
    for tokens, found in bodies_of(text):
        bodies += 1
        total += tokens
        rows.append((tokens, found))
        for name in found:
            counts[name] += 1
            weights[name] += tokens
    print(f'{path}: {bodies} bodies, {total} body tokens')
    print('  construct\tbodies with it\tshare of bodies\ttheir share of the body tokens')
    for name, count in counts.most_common():
        print(f'  {name}\t{count}\t{100 * count / bodies:.1f}%\t{100 * weights[name] / total:.1f}%')
    sets = [
        ('never native at first: asm, _Generic, typeof, statement expression, computed goto, #pragma, wide types', {'asm', '_Generic', 'typeof or __auto_type', 'statement expression', 'computed goto', '#pragma in a body', 'long double, _Complex, _Atomic, __int128, _BitInt'}),
        ('those, and __builtin_ names but __builtin_expect', {'asm', '_Generic', 'typeof or __auto_type', 'statement expression', 'computed goto', '#pragma in a body', 'long double, _Complex, _Atomic, __int128, _BitInt', '__builtin_ name'}),
        ('those, and va_arg and friends', {'asm', '_Generic', 'typeof or __auto_type', 'statement expression', 'computed goto', '#pragma in a body', 'long double, _Complex, _Atomic, __int128, _BitInt', '__builtin_ name', 'va_arg and friends'}),
        ('those, and brace initializers', {'asm', '_Generic', 'typeof or __auto_type', 'statement expression', 'computed goto', '#pragma in a body', 'long double, _Complex, _Atomic, __int128, _BitInt', '__builtin_ name', 'va_arg and friends', 'brace initializer'}),
        ('those, and static locals, extern and attributes in a body', {'asm', '_Generic', 'typeof or __auto_type', 'statement expression', 'computed goto', '#pragma in a body', 'long double, _Complex, _Atomic, __int128, _BitInt', '__builtin_ name', 'va_arg and friends', 'brace initializer', 'static local', 'extern in a body', '__attribute__ in a body'}),
        ('those, and struct, union or enum keywords, goto and switch', {'asm', '_Generic', 'typeof or __auto_type', 'statement expression', 'computed goto', '#pragma in a body', 'long double, _Complex, _Atomic, __int128, _BitInt', '__builtin_ name', 'va_arg and friends', 'brace initializer', 'static local', 'extern in a body', '__attribute__ in a body', 'struct, union or enum keyword', 'goto', 'switch'}),
    ]
    print('  bodies free of a set\tbodies\tshare of bodies\ttheir share of the body tokens')
    for label, excluded in sets:
        free = [(t, f) for t, f in rows if not (f & excluded)]
        print(f'  {label}\t{len(free)}\t{100 * len(free) / bodies:.1f}%\t{100 * sum(t for t, _ in free) / total:.1f}%')
