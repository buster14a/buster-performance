#!/usr/bin/env python3
# census2.py FILE...: of the expressions the window lists for a logical operator, a conditional or a comma alone and the
# reference takes: each listed record by what the reference makes of it.
import sys, collections
sys.path.insert(0, __import__('os').path.dirname(__import__('os').path.abspath(__file__)))
from census1 import load, OPS, REASONS, REFUSALS
T = {0: 'NONE', 1: 'CONSTANT', 2: 'VOID', 3: 'ADDRESS', 4: 'LOCAL', 5: 'GLOBAL', 6: 'PASS', 7: 'DEREF', 8: 'MEMBER', 9: 'UNARY', 10: 'TRUTH', 11: 'BINARY', 12: 'POINTER',
     13: 'STORE_LOCAL', 14: 'STORE_GLOBAL', 15: 'STORE', 16: 'BRANCH', 17: 'DECIDED', 18: 'SECOND', 19: 'CALL', 20: 'UPDATE', 21: 'BRANCHES', 255: '-'}
def state_name(s):
    bits = [(1, 'E'), (2, 'cond'), (4, 'arm'), (8, 'split'), (16, 'tested'), (32, 'true'), (64, 'branched')]
    return '+'.join(n for b, n in bits if s & b) or '0'
def parents(lr):
    p = {}
    for d in lr:
        for k, name in enumerate(('left', 'right', 'third')):
            c = d[name]
            if c < d['r'] and c not in p:
                p[c] = (d['r'], k)
    return p
def addressable(e):
    if 'le' not in e or 'we' not in e or e['we']['verdict'] != 1:
        return False
    s = {REASONS[w['reason']] for w in e['wr'] if w['listed']}
    return s <= {'logical', 'comma'} and len(s) != 0
if __name__ == '__main__':
    total = collections.Counter()
    for path in sys.argv[1:]:
        E = load(path)
        name = path.split('/')[-1].split('.')[0]
        rows = collections.Counter()
        for e in E.values():
            if not addressable(e) or e['le']['swept'] != 0:
                continue
            lr = {d['r']: d for d in e['lr']}
            par = parents(e['lr'])
            for w in e['wr']:
                if not w['listed']:
                    continue
                d = lr[w['r']]
                pr = par.get(d['r'])
                consumer = (OPS.get(lr[pr[0]]['op'], 'other') + '.' + str(pr[1]) + ':' + T[lr[pr[0]]['template']]) if pr else 'root'
                rows[(OPS.get(d['op'], str(d['op'])), T[d['template']], state_name(d['state']), consumer)] += 1
        print('==', name, 'listed records of the addressable expressions the reference takes:', sum(rows.values()))
        for k, v in sorted(rows.items(), key=lambda kv: -kv[1])[:45]:
            print('  %5d  %-6s %-9s %-22s under %s' % (v, *k))
        total.update(rows)
    print('== all')
    for k, v in sorted(total.items(), key=lambda kv: -kv[1])[:60]:
        print('  %5d  %-6s %-9s %-22s under %s' % (v, *k))
