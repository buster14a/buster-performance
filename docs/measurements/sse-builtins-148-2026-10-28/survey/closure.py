import re, sys
# Usage: closure.py inventory.txt x86.c preprocessed.i
# Builtins the unit's own code reaches: directly (macros) and through the header functions it calls, transitively.
inv = set(open(sys.argv[1]).read().split())
rows = open(sys.argv[2]).read()
system, user = [], []
current = ''
for line in open(sys.argv[3], errors='replace'):
    m = re.match(r'# (\d+) "([^"]*)"', line)
    if m:
        current = m.group(2)
        continue
    (system if current.startswith('/usr') or current.startswith('<') else user).append(line)
text = ''.join(system)
# Header function bodies: name( ... ) { body } found by brace matching after each definition's parameter list.
bodies = {}
for m in re.finditer(r'\b(_\w+)\s*\(([^;{}()]|\([^()]*\))*\)\s*\{', text):
    name = m.group(1)
    i = m.end(); depth = 1
    while depth and i < len(text):
        c = text[i]
        depth += c == '{'
        depth -= c == '}'
        i += 1
    bodies.setdefault(name, text[m.end():i])
utext = ''.join(user)
seen, stack = set(), [n for n in set(re.findall(r'\b(_\w+)\s*\(', utext)) if n in bodies]
reached = set(re.findall(r'__builtin_ia32_\w+', utext))
while stack:
    n = stack.pop()
    if n in seen:
        continue
    seen.add(n)
    reached |= set(re.findall(r'__builtin_ia32_\w+', bodies[n]))
    stack += [c for c in set(re.findall(r'\b(_\w+)\s*\(', bodies[n])) if c in bodies and c not in seen]
for b in sorted(reached):
    stem = re.sub(r'(128|256|512)$', '', b)
    has_row = re.search(r'"' + b + r'"', rows) or re.search(r'"' + stem + r'"', rows)
    print(('checked ' if b in inv else 'UNCHECKED ') + ('row ' if has_row else 'NO-ROW ') + b)
