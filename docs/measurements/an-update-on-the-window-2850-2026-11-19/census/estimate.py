#!/usr/bin/env python3
# estimate.py NPZ...: from the census of C's answers, how many expressions an update's case on the window would decide:
# those with an update and none of what stays listed (a logical operator or a conditional, a comma or a selection, a
# division or a remainder by an integer constant, a compound one among them, a value the columns don't hold whole).
import sys, json
import numpy as np
S = '/tmp/claude-0/-home-user/750b08ae-4cd9-565b-b66d-6cb5ef06cd50/scratchpad/'
ops = json.load(open(S + 'ops.json')); tp = json.load(open(S + 'templates.json'))
UPD = sorted(set(range(ops['CHECK_OP_PRE_INCREMENT'], ops['CHECK_OP_POST_DECREMENT'] + 1)) | {v for k, v in ops.items() if k.endswith('_ASSIGN') and k != 'CHECK_OP_ASSIGN'})
for path in sys.argv[1:]:
    d = np.load(path); op = d['op']; e = d['e']; ne = int(e.max()) + 1
    def per(mask):
        out = np.zeros(ne, dtype=bool); out[e[mask]] = True; return out
    is_upd = np.isin(op, UPD)
    logical = per(np.isin(op, [ops['CHECK_OP_LOGICAL_AND'], ops['CHECK_OP_LOGICAL_OR'], ops['CHECK_OP_CONDITIONAL']]))
    comma = per(np.isin(op, [ops['CHECK_OP_COMMA'], ops.get('CHECK_OP_SELECT', -1)]))
    right_int = ((d['rst'] >> 2) & 7) == 1
    div = per(np.isin(op, [ops['CHECK_OP_DIVIDE'], ops['CHECK_OP_REMAINDER']]) & right_int)
    updiv = per(np.isin(op, [ops['CHECK_OP_DIVIDE_ASSIGN'], ops['CHECK_OP_REMAINDER_ASSIGN']]) & right_int)
    wide = per((d['st'] & 0x80) != 0)
    upd = per(is_upd)
    only = upd & ~logical & ~comma & ~div & ~updiv & ~wide
    refused = np.zeros(ne, dtype=np.int64); refused[e] = d['x']
    none = per(is_upd & (d['tpl'] == 0))
    print('%s: expressions %d; with an update %d; of them with nothing else listed %d (C refuses %d of these; an update with no template in %d); a compound division by a constant in %d expressions, records: /= %d, %%= %d' % (
        path.split('/')[-1], ne, upd.sum(), only.sum(), (refused != 0)[only].sum(), (none & only).sum(), updiv.sum(),
        (np.isin(op, [ops['CHECK_OP_DIVIDE_ASSIGN']]) & right_int).sum(), (np.isin(op, [ops['CHECK_OP_REMAINDER_ASSIGN']]) & right_int).sum()))
