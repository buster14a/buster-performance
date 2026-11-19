#!/usr/bin/env python3
# shapes.py NPZ...: from the census of C's answers (c-answers-census-2850-2026-11-18's lines as columns), what an update
# and a logical operator or a conditional look like to C: by template, plan and place.
import sys, json, collections
import numpy as np
S = '/tmp/claude-0/-home-user/750b08ae-4cd9-565b-b66d-6cb5ef06cd50/scratchpad/'
ops = json.load(open(S + 'ops.json')); tp = json.load(open(S + 'templates.json'))
opn = {v: k[9:] for k, v in ops.items()}; tpn = {v: k.replace('CHECK_LOWER_TEMPLATE_', '').replace('NODE_MACHINE_TEMPLATE_', 'M_') for k, v in tp.items()}
tpn[254] = 'not-reached'; tpn[255] = 'not-evaluated'
UPD = set(range(ops['CHECK_OP_PRE_INCREMENT'], ops['CHECK_OP_POST_DECREMENT'] + 1)) | {v for k, v in ops.items() if k.endswith('_ASSIGN') and k != 'CHECK_OP_ASSIGN'}
LOG = {ops['CHECK_OP_LOGICAL_AND'], ops['CHECK_OP_LOGICAL_OR'], ops['CHECK_OP_CONDITIONAL']}
for path in sys.argv[1:]:
    d = np.load(path); n = len(d['op'])
    op = d['op']; tpl = d['tpl']; e = d['e']
    is_upd = np.isin(op, list(UPD)); is_log = np.isin(op, list(LOG)); is_call = op == ops['CHECK_OP_CALL']; is_comma = op == ops['CHECK_OP_COMMA']
    ne = int(e.max()) + 1
    def per(mask):
        out = np.zeros(ne, dtype=bool); out[e[mask]] = True; return out
    eu, el, ec, ek = per(is_upd), per(is_log), per(is_call), per(is_comma)
    refused = np.zeros(ne, dtype=np.int64); refused[e] = d['x']
    print('== %s: %d records, %d expressions' % (path.split('/')[-1], n, ne))
    print('  expressions with: an update %d, a logical/conditional %d, both %d; update and no logical %d; logical and no update %d; either %d' % (
        eu.sum(), el.sum(), (eu & el).sum(), (eu & ~el).sum(), (el & ~eu).sum(), (eu | el).sum()))
    print('  of those with either: C refuses the expression (x != 0) in %d; with a call too %d; with a comma too %d' % ((refused != 0)[eu | el].sum(), (ec & (eu | el)).sum(), (ek & (eu | el)).sum()))
    # Updates.
    c = collections.Counter()
    for o, t, u, lo, cx in zip(op[is_upd], tpl[is_upd], d['up'][is_upd], d['lop'][is_upd], d['ctx'][is_upd]):
        kind = 'inc/dec' if o <= ops['CHECK_OP_POST_DECREMENT'] else opn[o]
        c[(kind, tpn.get(int(t), str(t)), 'direct' if u & 1 else ('address' if u & 64 else '-'), 'pointer' if u & 16 else '', 'power' if u & 32 else '', opn.get(int(lo), str(lo)))] += 1
    print('  update records: %d' % is_upd.sum())
    for k, v in c.most_common(18):
        print('    %6d  %s' % (v, ' '.join(x for x in k if x)))
    print('    ... %d shapes in all; with M_UPDATE %d, other templates: %s' % (len(c), (tpl[is_upd] == tp['NODE_MACHINE_TEMPLATE_UPDATE']).sum(), dict(collections.Counter(tpn.get(int(t), str(t)) for t in tpl[is_upd] if t != tp['NODE_MACHINE_TEMPLATE_UPDATE']))))
    # Logical operators and conditionals.
    c = collections.Counter()
    for o, t, st, co, ct in zip(op[is_log], tpl[is_log], d['state'][is_log], d['cop'][is_log], d['ctpl'][is_log]):
        c[(opn[int(o)], tpn.get(int(t), str(t)), 'branched' if st & 0x40 else '', 'hooked:%x' % (st & 0x16) if st & 0x16 else '', 'under ' + (opn.get(int(co), 'root') if co != 255 else 'root'))] += 1
    print('  logical and conditional records: %d' % is_log.sum())
    for k, v in c.most_common(22):
        print('    %6d  %s' % (v, ' '.join(x for x in k if x)))
    print('    ... %d shapes in all; by template: %s' % (len(c), dict(collections.Counter(tpn.get(int(t), str(t)) for t in tpl[is_log]))))
    # Records with a branch's state that are no logical operator: a `!`, a CONDITION, an operand tested after its row.
    st = d['state']; other = ~is_log & ((st & 0x56) != 0)
    print('  other records with a hook or a branch: %d: %s' % (other.sum(), dict(collections.Counter((opn.get(int(o), str(o)) if o in (ops['CHECK_OP_NOT'], ops['CHECK_OP_CONDITION']) else 'operand', '%x' % (s & 0x76)) for o, s in zip(op[other], st[other])).most_common(10))))
    # Per expression: how many logical records.
    counts = np.bincount(e[is_log], minlength=ne)
    print('  logical records an expression (of those with one): 1: %d, 2: %d, 3: %d, 4 to 7: %d, 8 or more: %d; most %d' % ((counts == 1).sum(), (counts == 2).sum(), (counts == 3).sum(), ((counts >= 4) & (counts <= 7)).sum(), (counts >= 8).sum(), counts.max()))
