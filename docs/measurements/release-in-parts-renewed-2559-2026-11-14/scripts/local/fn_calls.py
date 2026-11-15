# fn_calls.py NAME FILE: the functions NAME's definition calls, with counts.
import re, sys, collections
name, path = sys.argv[1], sys.argv[2]
pat = re.compile(r'^define (?!available_externally).*@"?' + re.escape(name) + r'(\.buster_split)?"?\(')
calls = collections.Counter()
with open(path) as f:
    inside = False
    for line in f:
        if not inside and pat.match(line):
            inside = True; continue
        if inside:
            if line.startswith('}'): break
            for m in re.finditer(r'call [^@]*@"?([A-Za-z0-9_.$]+)"?\(', line):
                n = m.group(1).replace('.buster_split', '')
                if not n.startswith('llvm.'): calls[n] += 1
for n, c in sorted(calls.items()): print(c, n)
