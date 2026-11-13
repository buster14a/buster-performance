#!/usr/bin/env python3
# #2627 prototype: one main.c unit's own source files, rewritten into PIECES trees. Piece p's tree holds every file:
# the files of piece p whole, the others' with each function body that isn't inline blanked to a declaration and each
# mutable one-line file-scope variable made an extern declaration. A `static` function that isn't inline (and the
# macros that expand to such a `static`) and a mutable variable become BUSTER_PIECE_HIDDEN (hidden, external)
# everywhere, so another piece's call reaches it; constant tables and inline functions stay in every piece, internal.
# Every rewrite keeps the file's lines where they were.
#   pieces.py FILES ROOT PIECES OUT
# FILES: the unit's dependencies in include order; files under ROOT are rewritten. Pieces: contiguous runs of FILES'
# own files, balanced by bytes. Writes OUT/pP/... and OUT/assignment.txt; a file whose text is unchanged isn't
# rewritten (its mtime stays, for Ninja's restat).
import os, re, sys
files_path, root, pieces, out = sys.argv[1], sys.argv[2].rstrip('/') + '/', int(sys.argv[3]), sys.argv[4]
own = []
for l in open(files_path):
    l = l.strip()
    if l.startswith(root) and l not in own: own.append(l)
sizes = [os.path.getsize(f) for f in own]
total = sum(sizes); assign = {}; acc = 0
for f, s in zip(own, sizes):
    assign[f] = min(pieces - 1, acc * pieces // total); acc += s
HIDDEN = 'BUSTER_PIECE_HIDDEN'
small = int(os.environ.get('SMALL', '0'))
static_re = re.compile(r'\bstatic\b')
attribute_re = re.compile(r'__attribute__\s*\(\((?:[^()]|\((?:[^()]|\([^()]*\))*\))*\)\)|\b(?:_Alignas|alignas|__declspec)\s*\((?:[^()]|\([^()]*\))*\)')
kept_directive = re.compile(r'^\s*#\s*(if|ifdef|ifndef|elif|elifdef|elifndef|else|endif|define|undef)\b')
import hashlib, json, pickle
class Texts(dict):
    def __missing__(self, f):
        value = open(f, encoding='latin-1').read().split('\n'); self[f] = value; return value
texts = Texts()
# The cache (OUT/cache.pickle): each file's pass-1 findings and its two rewrites' hashes, by its mtime and size, so that
# a run reads and rewrites only the files that changed.
cache_path = os.path.join(out, 'cache.pickle')
try:
    cache = pickle.load(open(cache_path, 'rb'))
except Exception:
    cache = {'files': {}, 'macros': None}
stamps = {f: (os.stat(f).st_mtime_ns, os.stat(f).st_size, os.environ.get('SMALL', '0')) for f in own}

# Macros, by their values at the unit's end (MACROS, clang -dM -E of the unit): which object-like macros expand to an
# inline specifier, and which to `static` without one. A source `#define NAME static` line is rewritten only where the
# unit's own value of NAME is that static.
macros_stamp = (os.stat(os.environ['MACROS']).st_mtime_ns, os.stat(os.environ['MACROS']).st_size)
macros = {}
for line in (open(os.environ['MACROS'], encoding='latin-1') if cache['macros'] is None or cache['macros'][0] != macros_stamp else []):
    m = re.match(r'^#define ([A-Za-z_]\w*) (.*)$', line.rstrip('\n'))
    if m: macros[m.group(1)] = m.group(2)
def expand(text, depth=0):
    if depth > 16: return text
    return re.sub(r'\b[A-Za-z_]\w*\b', lambda m: expand(macros[m.group(0)], depth + 1) if m.group(0) in macros and not macros[m.group(0)].startswith('(') else m.group(0), text)
inline_macros = set(); static_macros = set()
for name, value in macros.items():
    full = expand(value)
    if re.search(r'\binline\b|__forceinline|always_inline', full): inline_macros.add(name)
    elif re.match(r'static\b', full.strip()): static_macros.add(name)
if macros:
    cache['macros'] = (macros_stamp, inline_macros, static_macros)
else:
    inline_macros, static_macros = cache['macros'][1], cache['macros'][2]
inline_re = re.compile(r'\binline\b|__forceinline|always_inline' + ''.join(r'|\b%s\b' % re.escape(n) for n in sorted(inline_macros)))

def header_of(lines, i):
    k = i - 1; header = []
    while k >= 0 and lines[k].strip() != '' and not lines[k].lstrip().startswith('#') and not lines[k].rstrip().endswith((';', '}', '{')) and not lines[k].lstrip().startswith('//'):
        header.insert(0, k); k -= 1
    return header

def name_of(text):
    m = re.search(r'([A-Za-z_]\w*)\s*\(', attribute_re.sub(' ', text))
    return m.group(1) if m else None

def blocks(lines):
    i = 0
    while i < len(lines):
        if lines[i] == '{':
            j = i + 1
            while j < len(lines) and not lines[j].startswith('}'):
                j += 1
            yield i, j, header_of(lines, i)
            i = j + 1
        else:
            i += 1

# Pass 1: which functions are inline, by any of their declarations; which static macros head a function.
inline_names = set(); header_macros = set()
for f in own:
    entry = cache['files'].get(f)
    if entry is not None and entry['stamp'] == stamps[f]:
        inline_names |= entry['inline']; header_macros |= entry['headers']
        continue
    before_inline, before_headers = set(inline_names), set(header_macros)
    mine_inline = set(); mine_headers = set()
    lines = texts[f]
    for i, j, header in blocks(lines):
        h = ' '.join(lines[k] for k in header)
        if j < len(lines) and lines[j] == '}' and '(' in h and header:
            n = name_of(h)
            # SMALL (lines): a static function's body that short stays whole in every piece, as an inline one does, so that
            # every piece's inliner sees it.
            first_word = lines[header[0]].split()[0] if lines[header[0]].split() else ''
            # Not one an attribute keeps (used, a constructor): its one copy is what that asks for.
            internal = (re.search(r'\bstatic\b', h) is not None or first_word in static_macros) and re.search(r'\b(used|constructor|destructor)\b', h) is None
            if (inline_re.search(h) or 'no_builtin' in h or (internal and j - i - 1 <= small)) and n: mine_inline.add(n)
            first = lines[header[0]].split()
            if first and first[0] in static_macros: mine_headers.add(first[0])
    for line in lines:
        if line.endswith(';') and inline_re.search(line) and '(' in line:
            n = name_of(line)
            if n: mine_inline.add(n)
    # What was written for it stays known, so that a piece whose text of it is unchanged keeps its file (and mtime).
    cache['files'][f] = {'stamp': stamps[f], 'inline': mine_inline, 'headers': mine_headers, 'written': entry['written'] if entry is not None else {}, 'digest': None}
    inline_names |= mine_inline; header_macros |= mine_headers
rewrite_macros = static_macros & header_macros

def is_variable(line):
    if not line.endswith(';') or not re.match(r'^[A-Za-z_]', line):
        return False
    if line.startswith(('typedef', 'struct ', 'union ', 'enum ', 'return', 'extern', '_Static_assert', 'static_assert', 'BUSTER_STATIC_ASSERT')):
        return False
    head = re.sub(r'\[[^\]]*\]', '[]', attribute_re.sub(' ', line.split('=', 1)[0]))
    if '(' in head or inline_re.search(head):
        return False
    # A constant: the declared object itself is const (const after the last '*', or const and no '*').
    tail = head.rsplit('*', 1)[1] if '*' in head else head
    if re.search(r'\bconst\b', tail):
        return False
    first = head.split()[0]
    if first in static_macros and first not in rewrite_macros:
        return False  # a data macro's constant table: stays in every piece
    return True

def rewrite(path, mine):
    lines = texts[path]
    result = list(lines)
    for i, j, header in blocks(lines):
        h = ' '.join(lines[k] for k in header)
        if j < len(lines) and lines[j] == '}' and '(' in h and header:
            # Inline, or an attribute only a definition takes (no_builtin): stays whole and internal in every piece.
            if name_of(h) in inline_names or inline_re.search(h) or 'no_builtin' in h:
                continue
            first = header[0]
            result[first] = static_re.sub(HIDDEN, lines[first], count=1)
            if not mine:
                result[i] = ';'
                for k in range(i + 1, j + 1):
                    result[k] = lines[k] if kept_directive.match(lines[k]) else ''
    inside = set()
    for i, j, header in blocks(lines):
        inside.update(range(i, j + 1))
    for i, line in enumerate(lines):
        if i in inside or result[i] != line:
            continue
        m = re.match(r'^(\s*#\s*define\s+([A-Za-z_]\w*)\s+)static\b(.*)$', line)
        if m and m.group(2) in rewrite_macros:
            result[i] = m.group(1) + HIDDEN + m.group(3)
            continue
        if line.startswith('static') and '(' in re.sub(r'\[[^\]]*\]', '[]', attribute_re.sub(' ', line.split('=', 1)[0])):
            n = name_of(line)
            stripped = attribute_re.sub(' ', line)
            pointer = re.match(r'[^(]*\(\s*\*', stripped) is not None
            if n and n not in inline_names and not pointer and not inline_re.search(line):
                result[i] = static_re.sub(HIDDEN, line, count=1)
            continue
        if is_variable(line):
            decl = line[:-1].split('=', 1)[0].rstrip()
            if mine:
                # A tentative definition (no initializer) may repeat in another file: weak, so the join keeps one.
                tentative = '=' not in line
                result[i] = static_re.sub(HIDDEN + (' __attribute__((weak))' if tentative else ''), line, count=1) if static_re.search(line) else (('__attribute__((weak)) ' if tentative else '') + line)
            else:
                result[i] = 'BUSTER_PIECE_EXTERN ' + static_re.sub(HIDDEN, decl, count=1) + ';'
    return '\n'.join(result)

os.makedirs(out, exist_ok=True)
with open(os.path.join(out, 'assignment.txt'), 'w') as a:
    for f in own: a.write('%d %s\n' % (assign[f], f[len(root):]))
digest = hashlib.sha256(repr((sorted(inline_names), sorted(rewrite_macros), sorted(static_macros), sorted(inline_macros), pieces, assign)).encode()).hexdigest()
written = 0; redone = 0
for f in own:
    entry = cache['files'][f]
    if entry['digest'] == digest:
        continue
    redone += 1
    versions = {True: rewrite(f, True), False: rewrite(f, False)}
    for p in range(pieces):
        text = versions[assign[f] == p]
        h = hashlib.sha1(text.encode('latin-1')).hexdigest()
        dest = os.path.join(out, 'p%d' % p, f[len(root):])
        if entry['written'].get(p) != h or not os.path.exists(dest):
            os.makedirs(os.path.dirname(dest), exist_ok=True)
            open(dest, 'w', encoding='latin-1').write(text); written += 1
            entry['written'][p] = h
    entry['digest'] = digest
pickle.dump(cache, open(cache_path + '.next', 'wb')); os.replace(cache_path + '.next', cache_path)
print('files %d, rewritten %d, written %d, inline names %d, static macros rewritten %s' % (len(own), redone, written, len(inline_names), sorted(rewrite_macros)))
