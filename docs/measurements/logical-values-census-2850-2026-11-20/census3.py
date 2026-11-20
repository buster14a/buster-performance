#!/usr/bin/env python3
# census3.py FILE...: the features of the reference's value templates (BRANCH, DECIDED, SECOND, a conditional's PASS) and
# of the commas in the addressable expressions the reference takes.
import sys, collections
sys.path.insert(0, __import__('os').path.dirname(__import__('os').path.abspath(__file__)))
from census1 import load, OPS, REASONS, REFUSALS
from census2 import T, state_name, parents, addressable
def narrow(c):
    return 1 <= c <= 4
if __name__ == '__main__':
    for path in sys.argv[1:]:
        E = load(path)
        name = path.split('/')[-1].split('.')[0]
        C = collections.Counter()
        labels = collections.Counter()
        exprs = 0
        for e in E.values():
            if not addressable(e) or e['le']['swept'] != 0:
                continue
            exprs += 1
            labels[min(e['le']['labels'], 9)] += 1
            lr = {d['r']: d for d in e['lr']}
            par = parents(e['lr'])
            for d in e['lr']:
                if not d['state'] & 1:
                    continue
                op = d['op']
                t = d['template']
                if op in (21, 22, 23) and t == 16:
                    o = OPS[op]
                    a = lr[d['left']]
                    b = lr[d['right']]
                    C[(o, 'records')] += 1
                    C[(o, 'condition: ' + ('branched' if a['state'] & 64 else 'hooked value'))] += 1
                    if not a['state'] & 64:
                        C[(o, 'hooked condition: target class narrow' if narrow(a['tclass']) else 'hooked condition: target class not narrow')] += 1
                        own = len(a['entries']) - (4 if narrow(d['c0class']) else 3)
                        C[(o, 'hooked condition: its type is its target' if a['type'] == a['target'] else 'hooked condition: converted (class %d to %d)' % (a['class'], a['tclass']))] += 1
                    C[(o, 'own class void' if d['class'] == 0 else 'own class a value\'s')] += 1
                    same = d['target'] == 0 or d['target'] == d['type']
                    C[(o, 'target: ' + ('none' if d['target'] == 0 else 'its type' if d['target'] == d['type'] else 'void' if d['tclass'] == 0 else 'another type, same class' if d['tclass'] == d['class'] else 'another class'))] += 1
                    C[(o, 'context %d' % d['context'])] += 1
                    if op == 23:
                        c = lr[d['third']]
                        for arm, an in ((b, 'first arm'), (c, 'second arm')):
                            C[(o, an + ': ' + ('its type is its target' if arm['type'] == arm['target'] else 'converted, same class' if arm['class'] == arm['tclass'] else 'converted to another class'))] += 1
                            C[(o, an + ' entries: %d' % min(len(arm['entries']), 13))] += 1
                            C[(o, an + ' op: ' + OPS.get(arm['op'], 'other') + ' ' + T[arm['template']])] += 1
                    else:
                        C[(o, 'second operand: target class narrow' if narrow(d['c1class']) else 'second operand: target class not narrow')] += 1
                        C[(o, 'second operand: ' + ('its type is its target' if b['type'] == b['target'] else 'converted'))] += 1
                        C[(o, 'own row entries: %d' % len(d['entries']))] += 1
                        C[(o, 'second operand op: ' + OPS.get(b['op'], 'other') + ' ' + T[b['template']])] += 1
                    pr = par.get(d['r'])
                    C[(o, 'under ' + ((OPS.get(lr[pr[0]]['op'], 'other') + '.' + str(pr[1])) if pr else 'root'))] += 1
                elif op in (21, 22, 23) and t in (17, 18, 6):
                    o = OPS[op] + ' known'
                    a = lr[d['left']]
                    C[(o, T[t])] += 1
                    C[(o, 'condition evaluated for effects' if a['state'] & 1 else 'condition not evaluated')] += 1
                    C[(o, 'condition op: ' + OPS.get(a['op'], 'leaf' if a['op'] == 0 else 'other'))] += 1
                elif op == 28 and t == 6:
                    o = ','
                    a = lr[d['left']]
                    b = lr[d['right']]
                    C[(o, 'records')] += 1
                    C[(o, 'context %d' % d['context'])] += 1
                    C[(o, 'target: ' + ('none' if d['target'] == 0 else 'its type' if d['target'] == d['type'] else 'void' if d['tclass'] == 0 else 'another type, same class' if d['tclass'] == d['class'] else 'another class'))] += 1
                    C[(o, 'first operand: context %d, op %s %s, class %d, entries %d' % (a['context'], OPS.get(a['op'], 'leaf' if a['op'] == 0 else 'call' if a['op'] == 34 else 'assign' if a['op'] == 27 else 'update' if 38 <= a['op'] <= 51 else 'cast' if a['op'] in (24, 36) else 'other'), T[a['template']], min(a['class'], 1), min(len(a['entries']), 9)))] += 1
                    C[(o, 'second operand: context %d, target %s' % (b['context'], 'void' if b['tclass'] == 0 else 'its type' if b['target'] == b['type'] else 'none' if b['target'] == 0 else 'another'))] += 1
                    pr = par.get(d['r'])
                    C[(o, 'under ' + ((OPS.get(lr[pr[0]]['op'], 'other') + '.' + str(pr[1]) + ' ' + T[lr[pr[0]]['template']]) if pr else 'root'))] += 1
                elif op == 52:
                    C[('select', T[t])] += 1
        print('==', name, ': addressable expressions the reference takes:', exprs, '; by their labels:', dict(sorted(labels.items())))
        last = None
        for k, v in sorted(C.items(), key=lambda kv: (kv[0][0], -kv[1])):
            if k[0] != last:
                print(' ', k[0])
                last = k[0]
            print('    %5d  %s' % (v, k[1]))
