import sys, re, collections
# Classify column-0 brace blocks of each file: a block opens at a line that is exactly "{" and closes at the next line
# starting with "}" at column 0.
files = [l.strip() for l in open(sys.argv[1]) if l.startswith('/home/user/buster-wt-develop/src')]
kinds = collections.Counter()
odd = []
for path in files:
    lines = open(path, encoding='latin-1').read().split('\n')
    i = 0
    while i < len(lines):
        if lines[i] == '{':
            j = i + 1
            while j < len(lines) and not lines[j].startswith('}'):
                j += 1
            close = lines[j] if j < len(lines) else '<eof>'
            # header: previous non-empty lines up to one ending in ';', '}', or a preprocessor line or blank
            k = i - 1
            header = []
            while k >= 0 and lines[k].strip() != '' and not lines[k].startswith('#') and not lines[k].rstrip().endswith((';', '}')) and not lines[k].startswith('//'):
                header.insert(0, lines[k]); k -= 1
            h = ' '.join(header)
            if close == '}':
                kind = 'function' if '(' in h else 'other-}'
                if kind == 'function' and re.search(r'\bstatic\b', h): kind = 'static-function'
                if 'inline' in h or 'BUSTER_INLINE' in h: kind += '-inline'
            elif close.startswith('};'):
                kind = 'initializer' if '=' in h else ('struct' if re.search(r'\b(struct|union|enum)\b', h) else 'other-};')
                if kind == 'initializer':
                    kind += '-static' if re.search(r'\bstatic\b', h) else '-extern'
                    kind += '-const' if 'const' in h else '-mutable'
            else:
                kind = 'other:' + close[:12]
            kinds[kind] += 1
            if kind.startswith('other') and len(odd) < 30: odd.append((path.split('/')[-1], i + 1, h[:100], close[:30]))
            i = j + 1
        else:
            i += 1
for k, v in sorted(kinds.items(), key=lambda x: -x[1]): print(v, k)
for o in odd: print(o)
