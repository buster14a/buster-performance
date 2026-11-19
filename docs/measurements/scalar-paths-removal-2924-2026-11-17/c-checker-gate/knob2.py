# EXPERIMENT ONLY (#2924 C12c's gate): gates the checker's and the program's scalar paths by area, where the flag's
# name is defined, so every read in a function agrees.
# Run from src/buster/compiler of a copy of the tree, after the front-end gate's patch (its roots). Rules:
# 1. A definition's `bool scalar` parameter becomes `scalar_raw`, and the body starts with
#    `const bool scalar = scalar_raw || buster_scalar_area(FILE_BIT);`.
# 2. A flag local (`const bool scalar = <the flag's field>;`, a macro around it stripped) gets the same pair.
# 3. What leaves a function goes raw: a whole call argument `scalar` or a store `= scalar` becomes `scalar_raw`; a
#    callee outside the rewritten files gets the foreign bit instead (the driver's own callees outside: raw, emission
#    keeps the command's flag).
# 4. A field read (`X->scalar`, `X.scalar`): in a branch or a macro, `(X || buster_scalar_area(FILE_BIT))`; a whole
#    argument or a store's right side: raw (foreign bit for a callee outside, as in 3).
# 5. The roots (`scalar || buster_scalar_area(N)` from the front-end patch) read `scalar_raw`.
# What the rules don't decide goes to the residue list (knob2.residue), for hand edits; the rules' decisions to
# knob2.log.
import re, glob, os, sys, collections

HERE = os.path.dirname(os.path.abspath(__file__))
# Callees outside the rewritten files, by their module: 22 the front end's (types, bindings, the builtins' filter),
# 27 the builtins' lowering, 28 emission's (Tier 0, the IR, the emitted code's metadata, the assembler).
def foreign_bit(home):
    if home is None:
        return 22
    if home.startswith('c_builtin') and 'lower' in home:
        return 27
    if home.startswith(('tier0', 'ssa', 'ir', 'emission', 'emitted', 'assembler', 'x86', 'tier1', 'unwind')):
        return 28
    return 22
AREAS = {
    10: 'reader', 11: 'bindings', 12: 'warnings', 13: 'attested', 14: 'core', 15: 'program', 16: 'lowering',
    17: 'alias', 18: 'emit', 19: 'select', 20: 'asm', 21: 'driver', 22: 'foreign-front', 23: 'data', 24: 'lazy',
    25: 'node', 26: 'tier1', 27: 'foreign-builtin-lowering', 28: 'foreign-back',
}
NAMED = {
    'c_check_input.c': 10, 'c_check_source_prepare.c': 10, 'c_check_string_pool.c': 10,
    'c_check_body_bindings.c': 11, 'c_check_binding.c': 11,
    'c_check_common_warnings.c': 12, 'c_check_warning_graph.c': 12, 'c_check_warning_undefined.c': 12,
    'c_check_ignored_result.c': 12, 'c_check_typo.c': 12, 'c_check_return_flow.c': 12, 'c_check_noderef_graph.c': 12,
    'c_check_overload_graph.c': 12, 'c_check_common_candidates.c': 12,
    'c_check_attested.c': 13,
    'c_check_program.c': 15,
    'c_check_program_lower.c': 16, 'c_check_lower_inventory.c': 16,
    'c_check_program_alias.c': 17, 'c_check_program_emit.c': 18, 'c_check_program_select.c': 19,
    'c_check_program_asm.c': 20,
    'c_checker_driver.c': 21, 'c_checker_units.c': 21, 'c_check_corpus.c': 21,
}

def file_bit(f):
    if f in NAMED:
        return NAMED[f]
    if f.startswith('c_check_node_'):
        return 25
    if f.startswith('c_check_tier1'):
        return 26
    if f.startswith('c_check_lazy'):
        return 24
    if f.startswith('c_check_data'):
        return 23
    if f.endswith('_input.c'):
        return 10
    if f.startswith('c_check_program_') or f == 'c_check_tier0_inline.c':
        return 15
    return 14

KEYWORDS = {'if', 'while', 'for', 'switch', 'return', 'sizeof', '_Alignof', 'alignof', 'do', 'else', 'case',
            'typeof', '__typeof__', '_Static_assert', 'static_assert', '__attribute__', 'defined', 'void'}
BRANCH_MACROS = {'BUSTER_SCALAR_PATH', 'BUSTER_VECTOR_PATH', '__builtin_expect'}
# Fields named scalar that are not the flag.
NOT_FLAG = {'entry->scalar', 'shadow.scalar'}
ASSIGN = {'=', '|=', '&=', '^=', '+=', '-=', '*=', '/=', '%=', '<<=', '>>='}

TOKEN = re.compile(r'''
    (?P<ws>\s+)
  | (?P<comment>//[^\n]*|/\*.*?\*/)
  | (?P<pp>^[ \t]*\#(?:[^\n\\]|\\.)*(?:\\\n(?:[^\n\\]|\\.)*)*)
  | (?P<string>"(?:[^"\\\n]|\\.)*"|'(?:[^'\\\n]|\\.)*')
  | (?P<ident>[A-Za-z_]\w*)
  | (?P<number>\.?\d(?:[\w.]|[eEpP][+-])*)
  | (?P<punct>->|\+\+|--|<<=|>>=|<<|>>|<=|>=|==|!=|&&|\|\||[-+*/%&|^!=<>]=|\.\.\.|[^\s\w])
''', re.S | re.M | re.X)

def tokenize(text):
    out = []
    for m in TOKEN.finditer(text):
        kind = m.lastgroup
        if kind in ('ws', 'comment'):
            continue
        out.append((kind, m.group(), m.start(), m.end()))
    return out

PAIRS = {'(': ')', '[': ']', '{': '}'}

def matching(toks, i):
    depth = 0
    for j in range(i, len(toks)):
        if toks[j][0] != 'punct':
            continue
        t = toks[j][1]
        if t in PAIRS:
            depth += 1
        elif t in (')', ']', '}'):
            depth -= 1
            if depth == 0:
                return j
    return None

def functions(toks):
    # File-scope `name ( params ) {`: (name, param open, param close, body open, body close).
    depth = 0
    i = 0
    while i < len(toks):
        k, t = toks[i][0], toks[i][1]
        if k == 'punct' and t == '{':
            depth += 1
        elif k == 'punct' and t == '}':
            depth -= 1
        elif depth == 0 and k == 'ident' and t not in KEYWORDS and i + 1 < len(toks) and toks[i + 1][1] == '(':
            close = matching(toks, i + 1)
            if close is not None and close + 1 < len(toks) and toks[close + 1][1] == '{':
                body_close = matching(toks, close + 1)
                yield (t, i + 1, close, close + 1, body_close)
                i = body_close + 1
                continue
        i += 1

def definitions(paths):
    found = {}
    for p in paths:
        for name, *_ in functions(tokenize(open(p, errors='replace').read())):
            found.setdefault(name, os.path.basename(p))
    return found

FLAG_INIT = re.compile(r'^(?:BUSTER_SCALAR_PATH\()?((?:[A-Za-z_]\w*(?:->|\.))+scalar)\)?$')

class File:
    def __init__(self, f, stage_set, defs, log, residue, counts):
        self.f = f
        self.bit = file_bit(f)
        self.text = open(f, errors='replace').read()
        self.toks = tokenize(self.text)
        self.edits = []
        self.stage_set = stage_set
        self.defs = defs
        self.log = log
        self.residue = residue
        self.counts = counts

    def line(self, pos):
        return self.text.count('\n', 0, pos) + 1

    def note(self, kind, pos, what):
        self.counts[(self.bit, kind)] += 1
        print(f'{self.f}:{self.line(pos)}\t{self.bit}\t{kind}\t{what}', file=self.log)

    def leftover(self, pos, why):
        self.counts[(self.bit, 'residue')] += 1
        src = self.text[self.text.rfind('\n', 0, pos) + 1:self.text.find('\n', pos)].strip()
        print(f'{self.f}:{self.line(pos)}\t{self.bit}\t{why}\t{src[:170]}', file=self.residue)

    def callee_area(self, name):
        if name in BRANCH_MACROS:
            return 'branch'
        home = self.defs.get(name)
        if home is None:
            return 'unknown'
        if home in self.stage_set:
            return 'stage'
        return 'driver-out' if self.bit == 21 else 'foreign'

    def context(self, a, b, lo):
        # The expression toks[a..b]: ('arg', callee) as a whole call argument, ('store',) as a whole store's right
        # side, ('return',), ('positional',) in a brace list, ('derived-arg', callee) inside a larger argument,
        # ('derived-store',) inside a larger store's right side, else ('branch',).
        toks = self.toks
        prev = toks[a - 1][1]
        nxt = toks[b + 1][1]
        # Walk back to the innermost unclosed opener, noting a store on the way.
        depth = 0
        store = False
        opener = None
        for j in range(a - 1, lo, -1):
            if toks[j][0] != 'punct':
                if toks[j][1] == 'return' and depth == 0:
                    return ('return',) if prev == 'return' and nxt == ';' else ('branch',)
                continue
            tj = toks[j][1]
            if tj in (')', ']', '}'):
                depth += 1
            elif tj in PAIRS:
                if depth == 0:
                    opener = j
                    break
                depth -= 1
            elif depth == 0 and tj in ASSIGN:
                store = True
                break
            elif depth == 0 and tj in (';',):
                break
        if store:
            whole = prev in ASSIGN and nxt in (';', ',', '}', ')')
            return ('store',) if whole else ('derived-store',)
        if opener is None:
            return ('branch',)
        o = toks[opener][1]
        if o == '{':
            whole = prev in ('{', ',') and nxt in ('}', ',')
            return ('positional',) if whole else ('branch',)
        if o == '(' and toks[opener - 1][0] == 'ident' and toks[opener - 1][1] not in KEYWORDS:
            callee = toks[opener - 1][1]
            if prev in ('(', ',') and nxt in (')', ','):
                return ('arg', callee)
            if callee in BRANCH_MACROS:
                return ('branch',)
            # Inside a nested group of an argument: is it still within a call's argument?
            return ('derived-arg', callee)
        if o == '(':
            # A grouping parenthesis: look further out.
            ctx = self.context(opener, matching(toks, opener), lo)
            if ctx[0] in ('arg', 'derived-arg'):
                return ('derived-arg', ctx[1])
            if ctx[0] in ('store', 'derived-store'):
                return ('derived-store',)
            return ('branch',)
        return ('branch',)

    def wrap(self, s, e, bit):
        self.edits.append((s, e, f'({self.text[s:e]} || buster_scalar_area({bit}))'))

    def function(self, name, popen, pclose, bopen, bclose):
        toks = self.toks
        bit = self.bit
        gate = f'scalar_raw || buster_scalar_area({bit})'
        param_edits = []
        for j in range(popen + 1, pclose):
            if toks[j][1] == 'scalar' and toks[j][0] == 'ident' and toks[j - 1][1] == 'bool':
                param_edits.append((toks[j][2], toks[j][3], 'scalar_raw'))
        flag_param = bool(param_edits)
        # Declarations named scalar in the body: `TYPE scalar` or `TYPE* scalar`.
        decls = []
        for j in range(bopen + 1, bclose):
            if toks[j][1] != 'scalar' or toks[j][0] != 'ident':
                continue
            p1, p2 = toks[j - 1], toks[j - 2]
            is_decl = (p1[0] == 'ident' and p1[1] not in KEYWORDS and p2[1] not in ('.', '->')) or \
                      (p1[1] == '*' and p2[0] == 'ident' and toks[j - 3][1] in (';', '{', '}', 'const', '('))
            if not is_decl:
                continue
            end = j + 1
            init = None
            if toks[end][1] == '=':
                k = end + 1
                d = 0
                while k < bclose:
                    tk = toks[k][1]
                    if tk in PAIRS:
                        d += 1
                    elif tk in (')', ']', '}'):
                        d -= 1
                    elif tk in (';', ',') and d == 0:
                        break
                    k += 1
                init = (end + 1, k - 1)
                end = k
            decls.append((j, p1[1], init, end))
        flag_locals = []
        other_decls = []
        for j, typ, init, end in decls:
            compact = ''.join(t[1] for t in toks[init[0]:init[1] + 1]) if init else ''
            if typ == 'bool' and init and FLAG_INIT.match(compact) and toks[end][1] == ';':
                flag_locals.append((j, init, end, compact))
            else:
                other_decls.append((j, typ, compact))
        has_flag = flag_param or bool(flag_locals)
        if has_flag and other_decls:
            self.leftover(toks[bopen][2], f'function {name}: the flag and another scalar ({other_decls[0][1]} = {other_decls[0][2][:60]}), left whole')
            return
        self.edits += param_edits
        if flag_param:
            pos = toks[bopen][3]
            self.edits.append((pos, pos, f' const bool scalar = {gate}; (void)scalar; (void)scalar_raw;'))
            self.note('parameter', toks[bopen][2], name)
        skip = set()
        for j, init, end, compact in flag_locals:
            raw = FLAG_INIT.match(compact).group(1)
            self.edits.append((toks[j][2], toks[end][2], f'scalar_raw = {self.text[toks[init[0]][2]:toks[init[1]][3]]}, scalar = {gate}'))
            if compact.startswith('BUSTER_SCALAR_PATH('):
                # Strip the macro: the raw local is the field.
                self.edits[-1] = (toks[j][2], toks[end][2], f'scalar_raw = {raw}, scalar = {gate}')
            pos = toks[end][3]
            self.edits.append((pos, pos, ' (void)scalar; (void)scalar_raw;'))
            self.note('local', toks[j][2], f'{name}: {compact}')
            skip.update(range(j, end + 1))
        decl_positions = set(d[0] for d in decls)
        j = bopen + 1
        while j < bclose:
            k, t, s, e = toks[j]
            if j in skip or k != 'ident' or t != 'scalar':
                j += 1
                continue
            if toks[j - 1][1] not in ('.', '->'):
                # A read of the name.
                if j in decl_positions:
                    j += 1
                    continue
                if not has_flag:
                    if not other_decls:
                        self.leftover(s, f'function {name}: scalar with no declaration here')
                    j += 1
                    continue
                if toks[j + 1][1] == '||' and toks[j + 2][1] == 'buster_scalar_area':
                    self.edits.append((s, e, 'scalar_raw'))
                    self.note('root', s, name)
                    j += 1
                    continue
                ctx = self.context(j, j, bopen)
                if ctx[0] == 'arg':
                    area = self.callee_area(ctx[1])
                    if area == 'branch':
                        self.note('branch-macro', s, ctx[1])
                    elif area in ('stage', 'driver-out'):
                        self.edits.append((s, e, 'scalar_raw'))
                        self.note('forward-' + area, s, ctx[1])
                    elif area == 'foreign':
                        self.edits.append((s, e, f'(scalar_raw || buster_scalar_area({foreign_bit(self.defs.get(ctx[1]))}))'))
                        self.note('forward-foreign', s, f'{ctx[1]} ({self.defs.get(ctx[1])})')
                    else:
                        self.leftover(s, f'argument of {ctx[1]} (unknown callee)')
                elif ctx[0] == 'store':
                    self.edits.append((s, e, 'scalar_raw'))
                    self.note('store', s, name)
                elif ctx[0] == 'branch':
                    self.note('branch', s, name)
                else:
                    self.leftover(s, f'{ctx[0]} {ctx[1] if len(ctx) > 1 else ""} (gated value left)')
                j += 1
                continue
            # A field read: the chain's first identifier.
            if toks[j - 1][1] == '.' and toks[j - 2][1] in ('{', ','):
                j += 1
                continue  # a designator
            if toks[j + 1][1] in ASSIGN:
                j += 1
                continue  # a store's target
            a = j - 2
            if toks[a][0] != 'ident':
                self.leftover(s, 'field read of an unusual expression')
                j += 1
                continue
            while toks[a - 1][1] in ('.', '->') and toks[a - 2][0] == 'ident':
                a -= 2
            if toks[a - 1][1] in ('.', '->', ']', ')') or toks[a - 1][1] == '*' and toks[a - 2][1] in ('(',):
                self.leftover(s, 'field read of an unusual expression')
                j += 1
                continue
            if self.text[toks[a][2]:e] in NOT_FLAG:
                j += 1
                continue
            ctx = self.context(a, j, bopen)
            if ctx[0] == 'arg':
                area = self.callee_area(ctx[1])
                if area == 'branch':
                    self.wrap(toks[a][2], e, bit)
                    self.note('field-branch-macro', s, ctx[1])
                elif area in ('stage', 'driver-out'):
                    self.note('field-forward-' + area, s, ctx[1])
                elif area == 'foreign':
                    self.wrap(toks[a][2], e, foreign_bit(self.defs.get(ctx[1])))
                    self.note('field-forward-foreign', s, f'{ctx[1]} ({self.defs.get(ctx[1])})')
                else:
                    self.leftover(s, f'field read, argument of {ctx[1]} (unknown callee)')
            elif ctx[0] == 'store':
                self.note('field-store', s, name)
            elif ctx[0] == 'branch':
                self.wrap(toks[a][2], e, bit)
                self.note('field-branch', s, name)
            else:
                self.wrap(toks[a][2], e, bit)
                self.leftover(s, f'field read, {ctx[0]} {ctx[1] if len(ctx) > 1 else ""} (wrapped in the file bit)')
            j += 1

    def run(self):
        for k, t, s, e in self.toks:
            if k == 'pp' and re.search(r'\bscalar\b', t):
                self.leftover(s, 'preprocessor line')
        for fn in functions(self.toks):
            self.function(*fn)
        if self.edits:
            new = self.text
            last = None
            for s, e, r in sorted(self.edits, key=lambda x: (-x[0], -x[1])):
                assert last is None or e <= last, (self.f, s, e, last)
                new = new[:s] + r + new[e:]
                last = s
            open(self.f, 'w').write(new)

def main():
    stage = sorted(set(f for f in glob.glob('c_check*.c') if not f.endswith(('_test.c', '_benchmark.c'))))
    stage_set = set(stage)
    defs = definitions(glob.glob('*.c') + glob.glob('*.h'))
    log = open(os.path.join(HERE, 'knob2.log'), 'w')
    residue = open(os.path.join(HERE, 'knob2.residue'), 'w')
    counts = collections.Counter()
    for f in stage:
        File(f, stage_set, defs, log, residue, counts).run()
    for key, v in sorted(counts.items()):
        print(key[0], AREAS.get(key[0], '?'), key[1], v)

if __name__ == '__main__':
    main()
