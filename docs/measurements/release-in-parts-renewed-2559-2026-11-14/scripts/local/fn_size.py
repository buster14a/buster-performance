# fn_size.py NAME FILE...: the IR instructions of NAME's definition (or NAME.buster_split's) in each FILE that defines it.
import re, sys
name = sys.argv[1]
pat = re.compile(r'^define (?!available_externally).*@"?' + re.escape(name) + r'(\.buster_split)?"?\(')
for path in sys.argv[2:]:
    count = None
    with open(path) as f:
        inside = False
        for line in f:
            if not inside and pat.match(line):
                inside = True; count = 0; continue
            if inside:
                if line.startswith('}'):
                    break
                s = line.strip()
                if s and not s.endswith(':') and not s.startswith(';') and not re.match(r'^[\w.]+:', s):
                    count += 1
    if count is not None:
        print(path, count)
