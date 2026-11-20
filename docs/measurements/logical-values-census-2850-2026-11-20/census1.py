#!/usr/bin/env python3
# census1.py FILE...: the logical operators' census, its first counts: the expressions with `&&`, `||`, `?:`, a comma or
# a selection by what the window makes of them and why it lists them, and what the reference makes of them.
import sys, collections, gzip
OPS = {3: '!', 21: '&&', 22: '||', 23: '?:', 28: ',', 52: 'select', 37: 'CONDITION'}
REASONS = ['none', 'call', 'logical', 'update', 'comma', 'division', 'wide', 'operator']
REFUSALS = ['taken', 'shape', 'code', 'leaf', 'context', 'diagnostic', 'template', 'row', 'root', 'callee']
def load(path):
    E = {}
    for line in (gzip.open(path, 'rt', errors='replace') if path.endswith('.gz') else open(path, errors='replace')):
        if line[:3] not in ('le\t', 'lr\t', 'we\t', 'wr\t'):
            continue
        f = line.rstrip('\n').split('\t')
        key = (path, int(f[1]), int(f[2]), int(f[3]))
        e = E.setdefault(key, {'lr': [], 'wr': []})
        if f[0] == 'le':
            e['le'] = dict(count=int(f[4]), swept=int(f[5]), stopped=int(f[6]), context=int(f[7]), target=int(f[8]), labels=int(f[9]), entries=int(f[10]),
                           tests_refuse=int(f[11]), tclass=int(f[12]), tfacts=int(f[13]))
        elif f[0] == 'lr':
            names = ['r', 'op', 'left', 'right', 'third', 'state', 'context', 'template', 'target', 'type', 'class', 'facts', 'c0', 'c1', 'constkind', 'category']
            d = {n: int(v) for n, v in zip(names, f[4:20])}
            d['flags'] = int(f[20], 16)
            names2 = ['hook', 'labeled', 'label_base', 'tclass', 'tfacts', 'c0class', 'c1class', 'c0facts', 'c1facts', 'known', 'truth']
            d.update({n: int(v) for n, v in zip(names2, f[21:32])})
            d['entries'] = [tuple(int(p, 16) if i == 2 else int(p) for i, p in enumerate(t.split(':'))) for t in f[32].split(',')] if len(f) > 32 and f[32] else []
            e['lr'].append(d)
        elif f[0] == 'we':
            e['we'] = dict(verdict=int(f[4]), count=int(f[5]), size=int(f[6]), ran=int(f[7]))
        else:
            names = ['r', 'x', 'op', 'classkind', 'reason', 'listed', 'alive', 'wtemplate', 'tclass', 'facts', 'kind', 'standing', 'flags', 'up', 'place', 'left_d', 'right_d', 'size', 'source']
            e['wr'].append({n: int(v) for n, v in zip(names, f[4:23])})
    return E
if __name__ == '__main__':
    for path in sys.argv[1:]:
        E = load(path)
        print('==', path.split('/')[-1].split('.')[0])
        both = {k: e for k, e in E.items() if 'le' in e and 'we' in e}
        print('expressions with such an operator: the reference ran on', sum('le' in e for e in E.values()), '; the window has a verdict for', sum('we' in e for e in E.values()), '; both', len(both))
        wv = collections.Counter()
        for e in both.values():
            wv[(['-', 'listed', 'taken', 'refused'][e['we']['verdict']], REFUSALS[e['le']['swept']])] += 1
        for k, v in sorted(wv.items()):
            print('  window', k[0], '; reference', k[1], ':', v)
        # The listed ones, by the set of their listed records' reasons.
        sets = collections.Counter()
        for e in both.values():
            if e['we']['verdict'] == 1:
                s = tuple(sorted({REASONS[w['reason']] for w in e['wr'] if w['listed']}))
                sets[(s, REFUSALS[e['le']['swept']])] += 1
        print('  listed, by its listed records\' reasons and the reference\'s verdict:')
        for k, v in sorted(sets.items(), key=lambda kv: -kv[1]):
            print('   ', '+'.join(k[0]), ';', k[1], ':', v)
