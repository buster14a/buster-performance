#!/usr/bin/env python3
# classify.py CENSUS.txt: the call census's lines (BUSTER_CALL_CENSUS, the experiment's hook in T's loop) by what each
# argument's conversion is. Calls T types again are counted once (the same graph, node, position and lines).
import sys, re, collections
KINDS = {}
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
        d = fields(line)
        key = None
    elif line.startswith('ARG ') and current is not None:
        current.append(line)
    if current is not None:
        d0 = fields(current[0])
        if len(current) == 1 + int(d0['count']):
            key = '\n'.join(current)
            calls.setdefault(key, 0)
            calls[key] += 1
            current = None
print('distinct calls', len(calls), 'typed', sum(calls.values()))
CONST = {0: 'none', 1: 'integer', 2: 'floating', 3: 'address', 4: 'complex', 5: 'label'}
CONVERT = {}
call_classes = collections.Counter()
arg_classes = collections.Counter()
arg_examples = {}
conv_flags = collections.Counter()
per_call_args = collections.Counter()
reader_calls = 0
for key in calls:
    lines = key.split('\n')
    c = fields(lines[0])
    if c['reader'] != '1':
        continue
    reader_calls += 1
    count = int(c['count']); parameters = int(c['parameters']); flags = int(c['flags'], 16)
    action = c['action'] == '1'
    wide = (int(c['standing'], 16) & 0x80) != 0
    per_call_args[min(count, 9)] += 1
    worst = 'all-same'
    order = ['all-same', 'lvalue-same', 'decay', 'arith', 'int-const', 'null', 'pointer-pair', 'variadic', 'float-const', 'other']
    def bump(k):
        global worst
    classes = []
    for l in lines[1:]:
        a = fields(l)
        own = int(a['own'], 16); ownword = int(a['ownword'], 16); standing = int(a['standing'], 16); aflags = int(a['flags'], 16)
        destination = int(a['destination'], 16); conversion = int(a['conversion'], 16); cflags = int(a['conversionflags'], 16)
        value = int(a['value'], 16); promoted = int(a['promoted'], 16); kind = int(a['kind'])
        category = standing & 3; ck = (standing >> 2) & 7; widearg = (standing & 0x80) != 0
        variadic = int(a['i']) >= parameters
        conv_flags[cflags] += 1
        if widearg:
            k = 'wide-argument'
        elif variadic:
            if ck in (2, 4, 5):
                k = 'variadic:' + CONST[ck] + '-constant'
            elif value == 0:
                k = 'variadic:decay'
            elif conversion == value:
                k = 'variadic:unchanged' + (':int-const' if ck == 1 else '')
            elif conversion == promoted:
                k = 'variadic:promoted' + (':int-const' if ck == 1 else '')
            else:
                k = 'variadic:other'
        elif conversion != destination:
            k = 'not-the-destination'
        elif ck == 2:
            k = 'floating-constant' + (':same' if value == destination else ':converted')
        elif ck in (4, 5):
            k = CONST[ck] + '-constant'
        elif ck == 1:
            dk = (int(a['destinationword'], 16) >> 16) & 0xff
            k = 'integer-constant:' + ('same' if value == destination else 'pointer' if a['pointers'] == '0' and dk == KINDS.get('pointer', -1) else 'converted')
            k = 'integer-constant:' + ('same' if value == destination else 'to-kind-%d' % dk)
        elif value == 0:
            k = 'decay'
        elif value == destination:
            k = ('lvalue' if category == 1 else 'rvalue') + ':same' + (':address-constant' if ck == 3 else '')
        elif a['pointers'] == '1':
            k = 'pointer-pair:' + ('assignable' if a['assignable'] == '1' else 'not-assignable') + (':address-constant' if ck == 3 else '')
        elif a['arithmetic'] == '1':
            k = 'arithmetic'
        else:
            k = 'other'
        if action:
            k = 'ACTION ' + k
        classes.append(k)
        arg_classes[k] += 1
        arg_examples.setdefault(k, l)
    call_classes[('action' if action else 'rule') + (' wide' if wide else '') + (' variadic' if flags & 2 else '')] += 1
print('reader-time calls', reader_calls)
for k, v in sorted(call_classes.items(), key=lambda kv: -kv[1]):
    print('  call %-30s %7d' % (k, v))
total = sum(arg_classes.values())
print('arguments', total)
for k, v in sorted(arg_classes.items(), key=lambda kv: -kv[1]):
    print('  %-52s %7d %6.2f%%' % (k, v, 100.0 * v / total))
print('arguments a call:', ' '.join('%d:%d' % (k, v) for k, v in sorted(per_call_args.items())))
print('conversion flags:', ' '.join('%x:%d' % (k, v) for k, v in sorted(conv_flags.items(), key=lambda kv: -kv[1])[:12]))
if len(sys.argv) > 2:
    for k in sorted(arg_examples):
        print('EXAMPLE', k, '|', arg_examples[k])
