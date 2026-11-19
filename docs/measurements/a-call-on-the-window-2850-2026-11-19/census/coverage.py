#!/usr/bin/env python3
# coverage.py CENSUS.txt: of the reader-time calls T's rule types, how many have every argument in the cases the
# kernel's assignment conversion has today (node_facts_store_made's: a builtin arithmetic pair, the same pointer type,
# a null pointer constant, an assignable pointer pair, each after the operand's own conversion), an estimate from the
# census's fields; and what the first argument outside them is.
import sys, collections
def fields(line):
    parts = line.split()
    d = {'tag': parts[0], 'graph': parts[1], 'node': parts[2], 'r': parts[3]}
    for p in parts[4:]:
        k, v = p.split('=')
        d[k] = v
    return d
calls = collections.OrderedDict()
current = None
for line in open(sys.argv[1]):
    line = line.rstrip('\n')
    if line.startswith('CALL '):
        current = [line]
    elif line.startswith('ARG ') and current is not None:
        current.append(line)
    if current is not None and len(current) == 1 + int(fields(current[0])['count']):
        calls.setdefault('\n'.join(current), 0)
        current = None
INTEGER, FLOATING, POINTER = 2, 3, 7
def builtin(t):
    return (t & 7) == 0 and (t >> 3) < 24
why = collections.Counter()
kept = 0; total = 0; action = 0; arguments = 0; kept_arguments = 0
for key in calls:
    lines = key.split('\n')
    c = fields(lines[0])
    if c['reader'] != '1':
        continue
    total += 1
    if c['action'] == '1':
        action += 1
        why['the action typed the call'] += 1
        continue
    parameters = int(c['parameters'])
    first = None
    for l in lines[1:]:
        a = fields(l)
        arguments += 1
        standing = int(a['standing'], 16); category = standing & 3; ck = (standing >> 2) & 7
        ck = 0 if category == 1 else ck
        destination = int(a['destination'], 16); conversion = int(a['conversion'], 16); value = int(a['value'], 16)
        dword = int(a['destinationword'], 16); dkind = (dword >> 16) & 0xff
        cword = int(a['conversionword'], 16); ckind = (cword >> 16) & 0xff
        variadic = int(a['i']) >= parameters
        reason = None
        if standing & 0x80:
            reason = 'a wide argument'
        elif ck in (2, 4, 5):
            reason = 'a floating, complex or label constant'
        elif variadic:
            if value == 0:
                reason = None if ckind == POINTER else 'variadic: other'
            elif ckind == POINTER and conversion == value:
                reason = None
            elif builtin(conversion) and ckind in (INTEGER, FLOATING) and builtin(value):
                reason = None
            else:
                reason = 'variadic: no builtin arithmetic type or pointer'
        elif conversion != destination:
            reason = 'not the destination'
        elif value == 0:
            reason = None if dkind == POINTER else 'a decay to no pointer'
        elif dkind == POINTER:
            if value == destination and ck in (0, 3):
                reason = None
            elif ck == 1:
                reason = None
            elif a['pointers'] == '1' and a['assignable'] == '1' and ck in (0, 3):
                reason = None
            else:
                reason = 'a pointer the pair does not take'
        elif builtin(destination) and builtin(value) and dkind in (INTEGER, FLOATING):
            reason = None
        elif value == destination:
            reason = 'the same type, of kind %d' % dkind
        else:
            reason = 'another conversion, to kind %d' % dkind
        if reason is None:
            kept_arguments += 1
        elif first is None:
            first = reason
    if first is None:
        kept += 1
    else:
        why[first] += 1
print('reader-time calls %d; the action typed %d; every argument in the cases: %d (%.2f%%); arguments %d, in the cases %d (%.2f%%)' % (
    total, action, kept, 100.0 * kept / total, arguments, kept_arguments, 100.0 * kept_arguments / max(arguments, 1)))
for k, v in sorted(why.items(), key=lambda kv: -kv[1]):
    print('  left for: %-48s %6d' % (k, v))
