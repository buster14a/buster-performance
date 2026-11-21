import glob, re, subprocess, sys, collections
compiler = sys.argv[1]
groups = collections.Counter()
example = {}
files = sorted(glob.glob('s*/found-*.c'))[:int(sys.argv[2])]
for f in files:
    r = subprocess.run([compiler, '-fsyntax-only'] + sys.argv[3:] + [f], capture_output=True, text=True)
    ws = re.findall(r'^[^\n]*?:(\d+):\d+: warning: ([^\n]*)', r.stderr, re.M)
    line = 62
    text = open(f).read().split('\n')
    n = [i for i, l in enumerate(text, 1) if l.startswith('    ') and i > 55 and not l.startswith('    return local')]
    msgs = set()
    for ln, w in ws:
        w = re.sub(r"'[^']*'", "T", w)
        w = re.sub(r'\[-W[^\]]*\]', lambda m: m.group(0), w)
        msgs.add(w)
    key = ' && '.join(sorted(msgs)) or 'NO WARNING'
    groups[key] += 1
    example.setdefault(key, f)
for k, c in groups.most_common():
    print('%5d  %s   [%s]' % (c, k[:230], example[k]))
