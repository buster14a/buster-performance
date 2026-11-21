#!/usr/bin/env python3
# extract.py OUT_DIR TEST_FILE...: the C string literals of the compiler's own test files that look like programs
# (adjacent literals joined, their escapes undone, a `;` and a `(` or a `{` in them), each a file of OUT_DIR, named by
# the test file and the literal's line; a literal seen before is skipped. A line of OUT_DIR/index.tsv a file.
import os, re, sys, hashlib
out = sys.argv[1]
os.makedirs(out, exist_ok=True)
literal = re.compile(r'"((?:[^"\\\n]|\\.)*)"')
joined = re.compile(r'(?:"(?:[^"\\\n]|\\.)*"[ \t\r\n]*)+')
simple = {'n': '\n', 't': '\t', 'r': '\r', '\\': '\\', '"': '"', "'": "'", '0': '\0', 'a': '\a', 'b': '\b', 'f': '\f', 'v': '\v', '?': '?', '\n': ''}
def unescape(s):
    r = []
    i = 0
    while i < len(s):
        c = s[i]
        if c != '\\':
            r.append(c); i += 1; continue
        d = s[i + 1]
        if d == 'x':
            j = i + 2
            while j < len(s) and s[j] in '0123456789abcdefABCDEF':
                j += 1
            r.append(chr(int(s[i + 2:j], 16) & 0xff)); i = j
        elif d in '01234567':
            j = i + 1
            while j < len(s) and j < i + 4 and s[j] in '01234567':
                j += 1
            r.append(chr(int(s[i + 1:j], 8) & 0xff)); i = j
        else:
            r.append(simple.get(d, '\\' + d)); i += 2
    return ''.join(r)
seen = set()
index = open(os.path.join(out, 'index.tsv'), 'w')
count = 0
for path in sys.argv[2:]:
    text = open(path, errors='replace').read()
    # Comments first, so that a quote in one opens no literal: a line comment's and a block's, outside literals.
    text = re.sub(r'"(?:[^"\\\n]|\\.)*"|//[^\n]*|/\*.*?\*/', lambda m: m.group(0) if m.group(0).startswith('"') else ' ' * 0 + '\n' * m.group(0).count('\n'), text, flags=re.S)
    for m in joined.finditer(text):
        parts = literal.findall(m.group(0))
        try:
            source = unescape(''.join(parts))
        except Exception:
            continue
        if ';' not in source or ('(' not in source and '{' not in source) or len(source) < 8 or '\0' in source or '%' in source and ('%s' in source or '%u' in source or '%d' in source or '%.*s' in source):
            continue
        key = hashlib.sha1(source.encode('utf-8', 'replace')).hexdigest()
        if key in seen:
            continue
        seen.add(key)
        line = text.count('\n', 0, m.start()) + 1
        name = '%s-%05d-%05d.c' % (os.path.basename(path)[:-2], line, count)
        with open(os.path.join(out, name), 'w', errors='replace') as f:
            f.write(source if source.endswith('\n') else source + '\n')
        index.write('%s\t%s\t%d\n' % (name, path, line))
        count += 1
print(count, 'programs from', len(sys.argv) - 2, 'files')
