import os, sys
exec(open(os.path.expanduser('~/.cache/claude-2639/grid3.py')).read().split("rows = []")[0].replace("for name, d in [('memory-local', os.path.expanduser('~/.cache/claude-2639/local')), ('address-9700x', os.path.expanduser('~/.cache/claude-2639/results/trace2-address-checker'))] + ", "for name, d in [] + "))
for name, ds in sets.items():
    X = ds['X']; on = X[:, 10] > 0
    cur = np.where(on, (X[:, 0] + 3) // 4, X[:, 0]) + 8
    first = np.where(on, (X[:, 0] + 3) // 4, X[:, 0] + 2 * X[:, 1] + X[:, 0] ** 2 / 50000) + 30
    refit = np.where(on, (X[:, 0] + 3) // 4, X[:, 0] + X[:, 0] ** 2 / 50000) + 60
    for label, pred in (('count', cur), ('first', first), ('refit', refit), ('measured', ds['y'] * 1e6 + ds['c1'] * 1e6)):
        print(name, label, 'rule %.1f' % longest(ds, pred, True)[0], 'padded %.1f' % longest(ds, pred, False)[0], 'even %.1f' % longest(ds, pred, False)[1])
