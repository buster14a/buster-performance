# sanitize.py IN OUT: C text with no byte the window lexer stops at: comments, directive lines, literals, '/', '\\'
# and the characters with no token kind replaced, so that its blocks are all full blocks.
import sys, re
s = open(sys.argv[1], 'rb').read().decode('latin-1')
out = []
i = 0; n = len(s); bol = True
while i < n:
    c = s[i]
    if c == '/' and i + 1 < n and s[i+1] == '*':
        j = s.find('*/', i + 2); j = n if j < 0 else j + 2
        out.append(' '); i = j; continue
    if c == '/' and i + 1 < n and s[i+1] == '/':
        j = s.find('\n', i); j = n if j < 0 else j
        i = j; continue
    if c == '#' and bol:
        j = i
        while True:
            k = s.find('\n', j); k = n if k < 0 else k
            if k > 0 and s[k-1] == '\\': j = k + 1; continue
            break
        i = k; continue
    if c == '"' or c == "'":
        j = i + 1
        while j < n and s[j] != c and s[j] != '\n':
            j += 2 if s[j] == '\\' else 1
        out.append('0'); i = j + 1; bol = False; continue
    if c == '\n': out.append(c); bol = True; i += 1; continue
    if c in ' \t\r\f\v': out.append(c); i += 1; continue
    bol = False
    if c in '/\\#@`' or ord(c) >= 127 or ord(c) < 32: out.append(' ' if c != '/' else '+')
    else: out.append(c)
    i += 1
open(sys.argv[2], 'wb').write(''.join(out).encode('latin-1'))
