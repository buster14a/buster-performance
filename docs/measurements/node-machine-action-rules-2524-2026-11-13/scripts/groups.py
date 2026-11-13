#!/usr/bin/env python3
# groups.py OPS DIAG: diag.c's lines (DIAG) counted by the rule that would take them (the PR's groups); OPS is ops.txt.
import sys, re, collections
ops = {}
for l in open(sys.argv[1]):
    n, name = l.split(); ops[n] = name.replace('CHECK_OP_', '')
folds = {'POSITIVE','NEGATIVE','BIT_NOT','ADD','SUBTRACT','MULTIPLY','DIVIDE','REMAINDER','SHIFT_LEFT','SHIFT_RIGHT','BIT_AND','BIT_OR','BIT_XOR','LESS','LESS_EQUAL','GREATER','GREATER_EQUAL','EQUAL','NOT_EQUAL'}
g = collections.Counter(); total = 0
for l in open(sys.argv[2]):
    if not l.startswith('NMDIAG'): continue
    f = l.split(); op = ops[f[1].split('=')[1]]
    operands = f[4:]
    consts = [re.match(r'o\d=k(\d+)/c(\d+)', o).group(2) for o in operands]
    kinds = [re.match(r'o\d=k(\d+)', o).group(1) for o in operands]
    total += 1
    if op in folds and consts and all(c == '1' for c in consts): key = 'integer constant folds'
    elif op == 'CAST': key = 'casts'
    elif op == 'MEMBER': key = 'a static object\'s member'
    elif op in ('EQUAL','NOT_EQUAL') and '7' in kinds and ('1' in consts or any(re.match(r'o\d=k7/c3/cat0', o) for o in operands)):
        key = 'a pointer and a null pointer constant'
    elif op in ('ASSIGN','CONVERT','INITIALIZE'): key = 'stores'
    elif op in ('SIZEOF','ALIGNOF'): key = 'sizeof, _Alignof'
    elif op == 'CONDITIONAL': key = '?:'
    elif op == 'COMMA': key = 'comma'
    elif op == 'SUBSCRIPT': key = 'subscripts'
    else: key = 'other'
    g[key] += 1
print('total', total)
for k, v in g.most_common(): print('%6d %s' % (v, k))
