import re, sys
# Usage: scan.py inventory.txt preprocessed.i  -> builtins used in user files (not under /usr), and whether in inventory
inv = set(open(sys.argv[1]).read().split())
user = {}
current = ''
for line in open(sys.argv[2], errors='replace'):
    m = re.match(r'# (\d+) "([^"]*)"', line)
    if m:
        current = m.group(2)
        continue
    if current.startswith('/usr') or current.startswith('<'):
        continue
    for name in re.findall(r'__builtin_ia32_\w+', line):
        user.setdefault(name, set()).add(current.rsplit('/', 1)[-1])
for name in sorted(user):
    print(('in   ' if name in inv else 'OUT  ') + name)
