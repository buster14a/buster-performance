import collections, os, sys
logs = sys.argv[1]
modes = ('default', 'wall', 'deferred', 'syntax', 'scalar'); lists = ('sqlite', 'musl', 'buster', 'fixture')
files = ('c_check_environment', 'c_check_input.c:66', 'c_check_condition', 'c_check_overload', 'c_check_mangle', 'c_check_unsequenced',
         'c_check_deferred', 'c_check_common_warnings.c:75', 'c_check_constant', 'c_check_builtin.c')
counts = {}
for m in modes:
    for l in lists:
        c = collections.defaultdict(lambda: [0, 0]); counts[m, l] = c
        p = os.path.join(logs, f'{m}-{l}.census')
        if not os.path.exists(p): continue
        for line in open(p):
            w = line.split()
            if w[0] != 'path': continue
            k = w[1].split('src/buster/compiler/')[-1]
            c[k][0] += int(w[2]); c[k][1] += int(w[3])
keys = sorted({k for c in counts.values() for k in c if any(k.startswith(f) for f in files)})
for m in modes:
    print(f'== {m} (scalar arm taken/not) ' + '  '.join(f'{l:>14}' for l in lists))
    for k in keys:
        print(f'{k:40s} ' + '  '.join((f'{counts[m,l][k][1]}/{counts[m,l][k][0]}' if k in counts[m,l] else '-').rjust(14) for l in lists))
