#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# chain_dump.py [--order FILE] IN_DIR OUT.bin: the units IN_DIR/NAME.i as the columns the design's passes would read
# in the compiler, for tools/chain.c, the prototype that times them: for each unit its tokens' kinds and names (every
# spelling interned to one id over the whole command, as a lane's intern table gives identifiers theirs), and for each
# file-scope declaration (attest.py's split and analyse: the parser's tree and roles stand behind these in the
# compiler) its tokens' range, whether it is eligible, a definition or a pragma, and the names it looks up, declares,
# mentions as tags and spells. Little-endian 32-bit words:
#   "BCD2", units, spellings; a byte a spelling for its class and one for its flags (padded to 4 each), which
#   tools/chain.c's own scan of the tokens reads in place of the spelling: a bracket, comma, semicolon, colon, `=` or
#   `*`; struct or union, enum, typedef, extern, a type's keyword, another keyword, a name; and whether its parenthesis
#   holds an operand (an attribute's, sizeof's), a type (typeof's), whether it makes the declaration ineligible, and
#   whether it is __extension__;
#   per unit: declarations, tokens, list words;
#             kinds (a byte a token, padded to 4); names (a word a token);
#             per declaration 8 words: first token, tokens, flags (1 eligible, 2 definition, 4 pragma), its lists'
#             offset, lookups, names, tags, spelled;
#             the lists: per declaration its lookups, its names, its tags (two words each: the name, and 1 for a
#             definition or a declaration of the tag, 2 for a mention inside a parameter list), its spelled names.
import os, re, struct, sys
import attest

arguments = sys.argv[1:]
order_file = None
if arguments and arguments[0] == '--order':
    order_file = arguments[1]
    arguments = arguments[2:]
in_dir, out_path = arguments[:2]
names = sorted(f for f in os.listdir(in_dir) if f.endswith('.i'))
if order_file:
    wanted = [os.path.basename(l.strip())[:-2] + '.i' for l in open(order_file) if l.strip()]
    present = set(names)
    names = [w for w in wanted if w in present]
ids = {}


def intern(text):
    value = ids.get(text)
    if value is None:
        value = len(ids) + 1
        ids[text] = value
    return value


KINDS = {'punct': 0, 'ident': 1, 'number': 2, 'string': 3, 'char': 4, 'pragma': 5}
chunks = []
for name in names:
    text = open(os.path.join(in_dir, name), errors='surrogateescape').read()
    declarations = attest.split(text)
    kinds = bytearray()
    token_names = []
    table = []
    lists = []
    for d in declarations:
        attest.analyse(d)
        first = len(token_names)
        for t, k in zip(d.tokens, d.kinds):
            kinds.append(6 if k == 'ident' and t in attest.KEYWORDS else KINDS[k])
            token_names.append(intern(t))
        offset = len(lists)
        lists.extend(intern(n) for n in d.lookups)
        lists.extend(intern(n) for n in d.names)
        for tag, form, in_parameters in d.tags:
            lists.append(intern(tag))
            lists.append((1 if form != 'mention' else 0) | (2 if in_parameters else 0))
        lists.extend(intern(n) for n in d.spelled)
        flags = (1 if d.eligible else 0) | (2 if d.definition else 0) | (4 if d.pragma else 0)
        table.append((first, len(d.tokens), flags, offset, len(d.lookups), len(d.names), len(d.tags), len(d.spelled)))
    while len(kinds) % 4:
        kinds.append(0)
    chunk = struct.pack('<3I', len(table), len(token_names), len(lists)) + bytes(kinds) + struct.pack(f'<{len(token_names)}I', *token_names)
    chunk += b''.join(struct.pack('<8I', *row) for row in table) + struct.pack(f'<{len(lists)}I', *lists)
    chunks.append(chunk)
PUNCT = {'{': 1, '}': 2, '(': 3, ')': 4, '[': 5, ']': 6, ',': 7, ';': 8, ':': 9, '=': 10, '*': 11}
IDENT = re.compile(r'[A-Za-z_$][A-Za-z_0-9$]*$')
classes = bytearray(len(ids) + 1)
flags = bytearray(len(ids) + 1)
for text, value in ids.items():
    if text in PUNCT:
        classes[value] = PUNCT[text]
    elif IDENT.match(text):
        classes[value] = 20 if text in ('struct', 'union') else 21 if text == 'enum' else 22 if text == 'typedef' else 23 if text == 'extern' else \
                         24 if text in attest.TYPE_KEYWORDS else 25 if text in attest.KEYWORDS else 26
        flags[value] = (1 if text in attest.SKIP_PARENS else 0) | (2 if text in attest.TYPE_PARENS else 0) | (4 if text in attest.INELIGIBLE_WORDS else 0) | \
                       (8 if text == '__extension__' else 0)
while len(classes) % 4:
    classes.append(0)
    flags.append(0)
with open(out_path, 'wb') as out:
    out.write(b'BCD2' + struct.pack('<2I', len(chunks), len(ids) + 1) + bytes(classes) + bytes(flags))
    for chunk in chunks:
        out.write(chunk)
print(f'{len(chunks)} units, {len(ids)} spellings, {sum(len(c) for c in chunks)} bytes')
