#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# attest.py [--warm] [--order FILE] IN_DIR OUT_DIR REPORT.tsv: an emulation, on preprocessed text, of the design's
# rule for file-scope declarations ("attested declarations"), for a command of every unit IN_DIR/NAME.i in turn on
# one lane:
#
#  - Every file-scope declaration gets a semantic hash: of its own tokens, of the hash of the latest declaration of
#    every name its reading looks up or declares (ordinary names and tags apart), and of every `#pragma` line before
#    it. Two declarations with one hash are the same tokens read in the same environment.
#  - A declaration is ELIGIBLE when it defines nothing and can raise nothing at the unit's end: no body, no
#    initializer, no `static`, an object only with `extern`, no alias, ifunc or asm label, no pragma inside, no tag
#    first declared in a parameter list (clang warns of one).
#  - It is a HIT when an earlier unit of the command read a declaration of the same hash (the memo: a set of hashes).
#  - It is LIVE when the unit's own code reaches it: the roots are the function definitions and every declaration that
#    isn't an eligible hit; a live declaration reaches (a) every earlier declaration of a name it spells, and (b)
#    every later declaration of a name it declares (a tag's completion, a redeclaration).
#  - An eligible hit that isn't live is SKIPPED: OUT_DIR/NAME.i has it blanked (spaces, its line breaks kept, so that
#    every other token keeps its line and column).
#
# The emulation assumes what the design's memo records at a first reading: that an eligible declaration read without
# a diagnostic. The compile of OUT_DIR's units checks that assumption and the rule's soundness on these units: their
# objects and diagnostics must be IN_DIR's.
#
# --semi DIR also writes DIR/NAME.i, in which each token of a skipped declaration is a `;` at the token's own place: an
# empty declaration a token, so that every other token keeps its index in the unit as well as its line and column
# (the compiler names a string literal's symbol by its token's index). OUT_DIR's units are for the time, DIR's for the
# comparison of the objects.
# --skips FILE also writes, a line a unit sorted by unit, the skipped declarations' ordinals among the unit's
# declarations (pragma lines apart) and the count of those: "UNIT<TAB>DECLARATIONS<TAB>ORDINAL,ORDINAL,...", which
# probe.patch's BUSTER_PROBE_SKIPS makes the compiler's own reader pass unread.
# --warm starts with every unit's declarations in the memo (a second command with a memo kept from the first: a bound).
# --order FILE reads the units in FILE's order (paths, a line each; their base names).
# REPORT.tsv: a row a unit and a summary: tokens by class.
import hashlib, os, re, sys, collections

TOKEN = re.compile(r'''
    (?P<space>\s+)
  | (?P<pragma>\#[^\n]*)
  | (?P<string>(?:u8|[uUL])?"(?:\\.|[^"\\\n])*")
  | (?P<char>(?:u8|[uUL])?'(?:\\.|[^'\\\n])*')
  | (?P<number>\.?[0-9](?:[eEpP][+-]|[0-9a-zA-Z_.])*)
  | (?P<ident>[A-Za-z_$][A-Za-z_0-9$]*)
  | (?P<punct>\.\.\.|<<=|>>=|->|\+\+|--|<<|>>|<=|>=|==|!=|&&|\|\||[-+*/%&|^]=|\#\#|[-+*/%&|^~!<>=?:;,.()\[\]{}\#])
''', re.X)

# The type specifiers that are keywords of the compiler's default language (gnu17, as clang has them on x86-64). A name
# that only some library's headers declare is not one: glibc declares _Float32, _Float64 and _Float128 by typedef for a
# compiler without the keywords, as clang is, and a first version of this list that held them made such a typedef
# declare nothing, so that the emulation skipped it and broke the one generated unit whose code reaches a later use
# (results/glibc-first: "unknown type name '_Float128'"). The design takes these facts from the parser, not from a list.
TYPE_KEYWORDS = {'void', 'char', 'short', 'int', 'long', 'float', 'double', 'signed', 'unsigned', '_Bool', '_Complex', '_Imaginary',
                 '__int128', '__signed__', '__signed', '_Float16', '__float128', '__builtin_va_list', '_Decimal32', '_Decimal64', '_Decimal128',
                 '_BitInt', '__auto_type'}
OTHER_KEYWORDS = {'typedef', 'extern', 'static', 'register', 'auto', '_Thread_local', '__thread', 'thread_local', 'const', 'volatile', 'restrict',
                  '__restrict', '__restrict__', '__const', '__const__', '__volatile__', '__volatile', '_Atomic', 'inline', '__inline', '__inline__',
                  '_Noreturn', '__extension__', 'struct', 'union', 'enum', '__attribute__', '__attribute', '__asm__', '__asm', 'asm', 'sizeof',
                  '_Alignof', '__alignof__', '__alignof', '_Alignas', 'alignas', 'alignof', '__typeof__', '__typeof', 'typeof', 'typeof_unqual',
                  '_Static_assert', 'static_assert', '_Generic', '__declspec', 'constexpr', 'nullptr', 'true', 'false', '__builtin_offsetof',
                  'if', 'else', 'for', 'while', 'do', 'switch', 'case', 'default', 'break', 'continue', 'return', 'goto', '__label__',
                  '_Nonnull', '_Nullable', '_Null_unspecified', '__nonnull', '__nullable', '__cdecl', '__stdcall'}
KEYWORDS = TYPE_KEYWORDS | OTHER_KEYWORDS
SKIP_PARENS = {'__attribute__', '__attribute', '__asm__', '__asm', 'asm', '__typeof__', '__typeof', 'typeof', 'typeof_unqual', '_Alignas', 'alignas',
               '_Atomic', '_Static_assert', 'static_assert', 'sizeof', '_Alignof', '__alignof__', '__alignof', '__declspec', '_BitInt'}
TYPE_PARENS = {'__typeof__', '__typeof', 'typeof', 'typeof_unqual', '_Atomic', '_BitInt'}
INELIGIBLE_WORDS = {'static', '__alias__', 'alias', 'ifunc', '__ifunc__', 'weakref', '__weakref__', '__asm__', '__asm', 'asm', '__thread',
                    '_Thread_local', 'thread_local', 'register', '__auto_type', 'constexpr', '__label__'}


def h64(*parts):
    m = hashlib.blake2b(digest_size=8)
    for p in parts:
        if isinstance(p, int):
            m.update(p.to_bytes(8, 'little'))
        else:
            m.update(p.encode('utf-8', 'surrogateescape'))
        m.update(b'\0')
    return int.from_bytes(m.digest(), 'little')


class Declaration:
    __slots__ = ('tokens', 'kinds', 'definition', 'pragma', 'names', 'lookups', 'tags', 'spelled', 'eligible', 'reason', 'hash', 'declares',
                 'hit', 'dead', 'body_tokens', 'begin', 'end', 'starts')


def split(text):
    # The unit's top-level declarations: runs of tokens to a `;` at depth 0, or to a function body's `}`; a pragma line is
    # a declaration of its own.
    declarations = []
    current = None
    depth = 0
    previous = ''
    in_body = False
    body_depth = 0
    for m in TOKEN.finditer(text):
        kind = m.lastgroup
        if kind == 'space':
            continue
        token = m.group()
        if kind == 'pragma' and depth == 0:
            if current is not None:
                declarations.append(current)
                current = None
            d = Declaration()
            d.tokens = [token]; d.kinds = [kind]; d.begin = m.start(); d.end = m.end(); d.definition = False; d.pragma = True; d.body_tokens = 0
            d.starts = [m.start()]
            declarations.append(d)
            previous = ''
            continue
        if current is None:
            current = Declaration()
            current.tokens = []; current.kinds = []; current.begin = m.start(); current.definition = False; current.pragma = False; current.body_tokens = 0
            current.starts = []
        current.starts.append(m.start())
        current.tokens.append(token)
        current.kinds.append(kind)
        current.end = m.end()
        if in_body:
            current.body_tokens += 1
        if token == '{':
            if depth == 0 and previous == ')' and not in_body:
                in_body = True
                current.definition = True
                current.body_tokens += 1
            depth += 1
        elif token == '}':
            depth -= 1
            if depth == 0 and in_body:
                in_body = False
                declarations.append(current)
                current = None
                previous = ''
                continue
        elif token == ';' and depth == 0:
            declarations.append(current)
            current = None
            previous = ''
            continue
        previous = token
    if current is not None:
        declarations.append(current)
    return declarations


def analyse(d):
    # What the declaration's spelling says: the ordinary names it declares at file scope (declarator names,
    # enumerators), its tags' mentions (a definition `struct T {`, a declaration `struct T;`, or another mention, and
    # whether inside a parameter list), the ordinary names its reading looks up (a type specifier's typedef name, and
    # every name in an array bound, a bit-field's width, an enumerator's value, a typeof's or an attribute's operand),
    # every name it spells, and whether it is eligible. A small scanner of C's declaration syntax: a stack of
    # contexts, each with whether its declaration has its type specifier yet. Parameters' and members' names are
    # neither declared at file scope nor looked up.
    tokens, kinds = d.tokens, d.kinds
    d.spelled = list(dict.fromkeys(t for t, k in zip(tokens, kinds) if k == 'ident' and t not in KEYWORDS))
    d.names = []
    d.lookups = []
    d.tags = []
    d.eligible = False
    d.reason = ''
    if d.pragma:
        d.reason = 'pragma'
        return
    if d.definition:
        d.reason = 'function definition'
        return
    names = []
    looked_up = []
    tags = []
    stack = [['top', False]]  # [kind, has its type specifier]
    reason = ''
    is_typedef = False
    is_extern = False
    object_declarator = False
    pending = None        # 'struct' or 'enum' after its keyword, until its tag or `{`
    tagged = -1           # the index in `tags` of the tag just named
    after_name = False    # the previous token was a declarator's name at file scope
    last_closed = ''
    bit_field = False
    previous = ''

    def base():
        for kind, _ in reversed(stack):
            if kind != 'group':
                return kind
        return 'top'

    def set_type():
        for entry in reversed(stack):
            if entry[0] != 'group':
                entry[1] = True
                return

    def has_type():
        for kind, has in reversed(stack):
            if kind != 'group':
                return has
        return False

    count = len(tokens)
    for i in range(count):
        t, k = tokens[i], kinds[i]
        if k == 'pragma':
            reason = reason or 'pragma inside'
            continue
        named = after_name
        after_name = False
        context = base()
        declarator_context = context in ('top', 'params', 'struct') and not bit_field
        if named and not (t == '(' and declarator_context):
            object_declarator = True
        if k == 'ident' and t in INELIGIBLE_WORDS and not reason:
            reason = 'static, register or thread storage' if t in ('static', 'register', '__thread', '_Thread_local', 'thread_local') else \
                     'asm label' if t in ('__asm__', '__asm', 'asm') else 'alias, ifunc or weakref' if ('alias' in t or 'ifunc' in t or 'weakref' in t) else t
        if tagged >= 0:
            # What follows a tag's name says what its mention is.
            if t == '{':
                tags[tagged][1] = 'body'
            elif t == ';' and len(stack) == 1 and all(x in ('struct', 'union', 'enum', '__extension__') or j == i - 1 for j, x in enumerate(tokens[:i])):
                tags[tagged][1] = 'alone'
            tagged = -1
        if t == '{':
            if pending is not None:
                stack.append(['enum' if pending == 'enum' else 'struct', False])
            else:
                stack.append(['expr', False])
            pending = None
        elif t == '}':
            if len(stack) > 1:
                last_closed = stack.pop()[0]
            set_type()
            bit_field = False
        elif t == '(':
            if previous in SKIP_PARENS:
                if previous in TYPE_PARENS and declarator_context:
                    set_type()
                stack.append(['type' if previous in TYPE_PARENS else 'expr', False])
            elif declarator_context and (named or (previous in (')', ']') and last_closed in ('group', 'params', 'square'))):
                stack.append(['params', False])
            elif declarator_context:
                stack.append(['group', False])
            else:
                stack.append(['expr', False])
            pending = None
        elif t == ')':
            if len(stack) > 1:
                last_closed = stack.pop()[0]
        elif t == '[':
            stack.append(['expr', False])
            pending = None
        elif t == ']':
            if len(stack) > 1:
                stack.pop()
            last_closed = 'square'
        elif k == 'ident':
            if t in ('struct', 'union', 'enum'):
                pending = 'enum' if t == 'enum' else 'struct'
                if declarator_context:
                    set_type()
            elif t in KEYWORDS:
                if declarator_context:
                    if t == 'typedef' and context == 'top': is_typedef = True
                    elif t == 'extern' and context == 'top': is_extern = True
                    elif t in TYPE_KEYWORDS: set_type()
            elif pending is not None and previous in ('struct', 'union', 'enum', ')'):
                tags.append([t, 'mention', any(kind == 'params' for kind, _ in stack)])
                tagged = len(tags) - 1
            elif context == 'enum':
                if previous in ('{', ','):
                    names.append(t)
                else:
                    looked_up.append(t)
            elif declarator_context:
                if not has_type():
                    set_type()
                    looked_up.append(t)  # a typedef name as the type specifier
                elif context == 'top':
                    names.append(t)
                    after_name = True
                # else a parameter's or a member's name
            else:
                looked_up.append(t)
        else:
            if t == ',' and stack[-1][0] == 'params':
                stack[-1][1] = False
            elif t == ';' and stack[-1][0] == 'struct':
                stack[-1][1] = False
                bit_field = False
            elif t == ',' and stack[-1][0] == 'struct':
                bit_field = False
            elif t == ':' and stack[-1][0] == 'struct':
                bit_field = True
            elif t == '=' and stack[-1][0] == 'top' and not reason:
                reason = 'initializer'
            if t in ('*', ';', ',', '=') and pending is not None:
                pending = None
        previous = t
    d.names = list(dict.fromkeys(names))
    d.lookups = list(dict.fromkeys(looked_up))
    d.tags = tags
    if not reason and not is_typedef and object_declarator and not is_extern:
        reason = 'object without extern (a tentative definition)'
    d.reason = reason
    d.eligible = not reason


def kind_of(d):
    tokens = d.tokens
    if d.pragma: return 'pragma'
    if d.definition: return 'function definition'
    first = next((t for t in tokens if t != '__extension__'), '')
    if first == 'typedef': return 'typedef'
    if first in ('_Static_assert', 'static_assert'): return 'static assertion'
    if '{' in tokens and '=' not in tokens: return 'record or enum definition'
    if '=' in tokens: return 'object with an initializer'
    if '(' in tokens: return 'prototype or function-pointer object'
    if first in ('struct', 'union', 'enum') and len(tokens) <= 3: return 'tag declaration'
    if tokens == [';']: return 'empty'
    return 'object without an initializer'


def chain(declarations):
    # The semantic hashes and what each declaration declares, in source order. A tag's mention that is neither its
    # definition nor its declaration declares the tag where none is visible, and names the visible one otherwise.
    namehash = {}
    ambient = 0
    for d in declarations:
        d.declares = []
        if d.pragma:
            ambient = h64(ambient, d.tokens[0])
            d.hash = 0
            continue
        if d.definition:
            # Every name the definition spells is its to change (a block's extern declaration, an implicit function's).
            keys = ['o:' + n for n in d.spelled] + ['t:' + n for n in d.spelled]
            d.hash = h64(ambient, ' '.join(d.tokens), *[namehash.get(key, 0) for key in keys])
            d.declares = keys
        else:
            dependencies = ['o:' + n for n in d.lookups] + ['o:' + n for n in d.names] + ['t:' + n for n, _, _ in d.tags]
            d.hash = h64(ambient, ' '.join(d.tokens), *[namehash.get(key, 0) for key in dependencies])
            declares = ['o:' + n for n in d.names]
            for name, form, in_parameters in d.tags:
                if form != 'mention' or 't:' + name not in namehash:
                    declares.append('t:' + name)
                    if form == 'mention' and in_parameters and d.eligible:
                        d.eligible = False
                        d.reason = 'a tag first declared in a parameter list'
            d.declares = list(dict.fromkeys(declares))
        for key in d.declares:
            namehash[key] = h64(namehash.get(key, 0), d.hash, key)


def live(declarations):
    # The declarations the unit's own code reaches: from the roots (a definition, a pragma, a declaration that isn't an
    # eligible hit), (a) to every earlier declaration of a name a reached one spells, (b) to every later declaration of
    # a name it declares.
    declarers = collections.defaultdict(list)
    for index, d in enumerate(declarations):
        for key in d.declares:
            declarers[key].append(index)
    reached = [not d.hit for d in declarations]
    work = [index for index, d in enumerate(declarations) if not d.hit]
    while work:
        index = work.pop()
        d = declarations[index]
        for name in d.spelled:
            for key in ('o:' + name, 't:' + name):
                for other in declarers.get(key, ()):
                    if other >= index:
                        break
                    if not reached[other]:
                        reached[other] = True
                        work.append(other)
        for key in d.declares:
            for other in declarers[key]:
                if other > index and not reached[other]:
                    reached[other] = True
                    work.append(other)
    for index, d in enumerate(declarations):
        d.dead = not reached[index]


def main():
    arguments = sys.argv[1:]
    warm = False
    order_file = None
    semi_dir = None
    skips_path = None
    skips = {}
    while arguments and arguments[0].startswith('--'):
        a = arguments.pop(0)
        if a == '--warm': warm = True
        elif a == '--order': order_file = arguments.pop(0)
        elif a == '--semi': semi_dir = arguments.pop(0)
        elif a == '--skips': skips_path = arguments.pop(0)
    in_dir, out_dir, report_path = arguments[:3]
    os.makedirs(out_dir, exist_ok=True)
    if semi_dir:
        os.makedirs(semi_dir, exist_ok=True)
    names = sorted(f for f in os.listdir(in_dir) if f.endswith('.i'))
    if order_file:
        wanted = [os.path.basename(l.strip())[:-2] + '.i' for l in open(order_file) if l.strip()]
        present = set(names)
        names = [w for w in wanted if w in present]

    units = []
    for name in names:
        text = open(os.path.join(in_dir, name), errors='surrogateescape').read()
        declarations = split(text)
        for d in declarations:
            analyse(d)
        units.append((name, text, declarations))


    memo = set()
    if warm:
        for name, text, declarations in units:
            chain(declarations)
            memo.update(d.hash for d in declarations if d.eligible)
    totals = collections.Counter()
    reasons = collections.Counter()
    kinds_total = collections.Counter()
    kinds_skipped = collections.Counter()
    declaration_counts = collections.Counter()
    with open(report_path, 'w') as report:
        report.write('unit\ttokens\tskipped\thit, reached\tmiss\tnot eligible\tfunction definitions\tdeclarations\tdeclarations skipped\n')
        for name, text, declarations in units:
            if not warm:
                chain(declarations)
            for d in declarations:
                d.hit = d.eligible and d.hash in memo
            live(declarations)
            row = collections.Counter()
            out = list(text)
            semi = list(text) if semi_dir else None
            skipped_declarations = 0
            for d in declarations:
                count = len(d.tokens)
                kind = kind_of(d)
                kinds_total[kind] += count
                declaration_counts['all'] += 1
                if d.dead:
                    row['skipped'] += count
                    kinds_skipped[kind] += count
                    skipped_declarations += 1
                    declaration_counts['skipped'] += 1
                    for at in range(d.begin, d.end):
                        if out[at] != '\n':
                            out[at] = ' '
                            if semi is not None:
                                semi[at] = ' '
                    for at in d.starts if semi is not None else ():
                        semi[at] = ';'
                elif d.hit:
                    row['hit, reached'] += count
                    declaration_counts['hit, reached'] += 1
                elif d.eligible:
                    row['miss'] += count
                    declaration_counts['miss'] += 1
                elif d.definition:
                    row['function definitions'] += count
                    declaration_counts['function definitions'] += 1
                else:
                    row['not eligible'] += count
                    reasons[d.reason] += count
                    declaration_counts['not eligible'] += 1
            memo.update(d.hash for d in declarations if d.eligible)
            proper = [d for d in declarations if not d.pragma]
            skips[name[:-2]] = (len(proper), [index for index, d in enumerate(proper) if d.dead])
            tokens = sum(len(d.tokens) for d in declarations)
            open(os.path.join(out_dir, name), 'w', errors='surrogateescape').write(''.join(out))
            if semi is not None:
                open(os.path.join(semi_dir, name), 'w', errors='surrogateescape').write(''.join(semi))
            report.write(f"{name}\t{tokens}\t{row['skipped']}\t{row['hit, reached']}\t{row['miss']}\t{row['not eligible']}\t{row['function definitions']}\t{len(declarations)}\t{skipped_declarations}\n")
            totals.update(row)
            totals['tokens'] += tokens
        report.write('# class\ttokens\tshare\n')
        for k in ('skipped', 'hit, reached', 'miss', 'not eligible', 'function definitions'):
            report.write(f"# {k}\t{totals[k]}\t{100 * totals[k] / max(totals['tokens'], 1):.2f}%\n")
        report.write(f"# all\t{totals['tokens']}\n")
        report.write('# declarations\tcount\n')
        for k, c in declaration_counts.most_common():
            report.write(f'# {k}\t{c}\n')
        report.write(f'# distinct hashes in the memo\t{len(memo)}\n')
        report.write('# not eligible, by reason\ttokens\n')
        for k, c in reasons.most_common():
            report.write(f'# {k}\t{c}\n')
        report.write('# kind\ttokens\ttokens skipped\n')
        for k, c in kinds_total.most_common():
            report.write(f'# {k}\t{c}\t{kinds_skipped[k]}\n')

    if skips_path:
        with open(skips_path, 'w') as out:
            for unit in sorted(skips):
                count, ordinals = skips[unit]
                out.write(f"{unit}\t{count}\t{','.join(str(o) for o in ordinals)}\n")


if __name__ == '__main__':
    main()
