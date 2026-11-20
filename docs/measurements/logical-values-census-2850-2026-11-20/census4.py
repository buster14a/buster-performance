#!/usr/bin/env python3
# census4.py FILE...: the candidate rules simulated over the census's lines: which of the expressions the window lists
# for a logical operator, a conditional or a comma alone the piece would take, and why not the others.
import sys, collections
sys.path.insert(0, __import__('os').path.dirname(__import__('os').path.abspath(__file__)))
from census1 import load, OPS, REASONS, REFUSALS
from census2 import T, state_name, parents, addressable
BOOL = 0x10
def narrow(c):
    return 1 <= c <= 4
def why_not(e):
    lr = {d['r']: d for d in e['lr']}
    par = parents(e['lr'])
    reasons = []
    for w in e['wr']:
        if not w['listed']:
            continue
        d = lr[w['r']]
        op, t = d['op'], d['template']
        ev = d['state'] & 1
        if op == 28:
            if ev and (t != 6 or d['context'] & 1):
                reasons.append('comma: no PASS or read for its address')
        elif op in (21, 22, 23):
            if not ev:
                reasons.append('a logical operator or conditional that is not evaluated')
            elif t == 16:
                a = lr[d['left']]
                if a['state'] & 64 and a['op'] not in (21, 22):
                    reasons.append('condition branched over a `!`')
                if op == 23:
                    b = lr[d['right']]
                    if b['tfacts'] & BOOL and b['type'] != b['target'] and not (b['facts'] & BOOL):
                        reasons.append('first arm converted to bool')
                    if b['state'] & 16 or (lr[d['third']]['state'] & 0) :
                        reasons.append('arm tested')
                else:
                    if narrow(d['c1class']):
                        reasons.append('second operand of a narrow class')
            elif t == 21:
                pr = par.get(d['r'])
                p = lr[pr[0]] if pr else None
                if not (p and p['op'] in (21, 22, 23) and (pr[1] == 0 or p['template'] == 21)):
                    reasons.append('branched under ' + ((OPS.get(p['op'], 'other') + '.' + str(pr[1])) if p else 'root'))
            elif t in (17, 18, 6):
                reasons.append('condition known: ' + T[t])
            else:
                reasons.append('template ' + T[t])
        elif op == 3:
            reasons.append('a `!` over or under a logical operator')
        else:
            reasons.append('op ' + str(op))
    return reasons
if __name__ == '__main__':
    for path in sys.argv[1:]:
        E = load(path)
        name = path.split('/')[-1].split('.')[0]
        n = taken = 0
        records = taken_records = 0
        nots = collections.Counter()
        labels = collections.Counter()
        refused = collections.Counter()
        for e in E.values():
            if not addressable(e):
                continue
            if e['le']['swept'] != 0:
                refused[REFUSALS[e['le']['swept']]] += 1
                continue
            n += 1
            records += e['le']['count']
            r = why_not(e)
            if r:
                nots[r[0]] += 1
            else:
                taken += 1
                taken_records += e['le']['count']
                holders = sum(1 for d in e['lr'] if d['labeled'])
                calls = sum(1 for d in e['lr'] if d['state'] & 1 and d['template'] == 19)
                labels[(min(holders, 4), min(calls, 3))] += 1
        print('==', name, ': addressable and taken by the reference:', n, 'expressions,', records, 'records; the rules take', taken, 'of them,', taken_records, 'records')
        for k, v in sorted(nots.items(), key=lambda kv: -kv[1]):
            print('    not taken, first reason: %5d  %s' % (v, k))
        print('    taken, by (label holders, calls):', dict(sorted(labels.items())))
        print('    addressable and refused by the reference:', dict(refused))
