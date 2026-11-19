#!/usr/bin/env python3
# first-piece.py: the X census's lines (xx:, from stdin), an expression at a time: which expressions the first piece
# of X's rows on the window would take (every record evaluated with nothing after its row, and no template of an
# update, a logical operator's or a conditional's value, or an operator evaluated as branches), and what their rows
# are: the lists of kinds of a record's own entries and of its conversion's, the longest rows, the constants whose
# conversion folds or does not by their target's class, and a truth's operand's conversion's class.
import sys, re, collections
P = re.compile(r'xx: e=(\d+) r=(\d+) n=(\d+) op=(\d+) tpl=(\d+) w=([0-9a-f]+) st=([0-9a-f]+) fl=([0-9a-f]+) ctx=([0-9a-f]+) state=([0-9a-f]+) tw=([0-9a-f]+) same=(\d+) c0=([0-9a-f]+) c1=([0-9a-f]+) ob=([0-9a-f]+) off=(\d+) mo=(\d+) fold=(\d+) up=([0-9a-f]+) uk=([0-9a-f]+) hop=(\d+) hw=([0-9a-f]+) hc0=([0-9a-f]+) last=(\d+) \| own=(\S+) conv=(\S+) after=(\S+)')
LATER = {16: 'logical', 17: 'logical', 18: 'logical', 20: 'update', 21: 'branches'}
expressions = collections.Counter(); records = collections.Counter(); entries = collections.Counter()
owns = collections.Counter(); convs = collections.Counter(); lengths = collections.Counter(); folds = collections.Counter(); truths = collections.Counter()
rows = collections.Counter(); own_multi = 0; sames = collections.Counter(); templates = collections.Counter()
def kinds(text):
    return '-' if text == '-' else ','.join(e.split(':')[0] for e in text.split(','))
def count(text):
    return 0 if text == '-' else text.count(',') + 1
def flush(lines):
    global own_multi
    why = 'first'
    for g in lines:
        tpl = int(g[4]); state = int(g[9], 16)
        if tpl in LATER:
            why = LATER[tpl]; break
        if state != 1:
            why = 'update' if (state & 8) != 0 else 'branches' if (state & 0x50) != 0 else 'logical'; break
    expressions[why] += 1
    records[why] += len(lines)
    entries[why] += sum(count(g[24]) + count(g[25]) + count(g[26]) for g in lines)
    if why == 'first':
        for g in lines:
            tpl = int(g[4]); w = int(g[5], 16); st = int(g[6], 16); ctx = int(g[8], 16); tw = int(g[10], 16); same = int(g[11]); c0 = int(g[12], 16)
            own = kinds(g[24]); conv = kinds(g[25])
            owns[(tpl, own)] += 1
            convs[conv] += 1
            rows[(own, conv)] += 1
            lengths[count(g[24]) + count(g[25])] += 1
            own_multi += count(g[24]) > 1
            templates[tpl] += 1
            sames[(same, ctx == 0)] += 1
            if tpl == 1 and ((st >> 2) & 7) == 1 and same == 0 and ctx == 0:
                target = tw & 0xff
                folds[('folded' if g[17] == '1' else 'not folded: ' + conv, 'integer' if 1 <= target <= 8 else 'floating' if target in (9, 10) else 'class %d' % target)] += 1
            if tpl == 10:
                truths[('narrow' if 1 <= (c0 & 0xff) <= 4 else 'wide', own)] += 1
current = None; lines = []
for line in sys.stdin:
    if not line.startswith('xx: '):
        continue
    m = P.match(line)
    if not m:
        continue
    g = m.groups()
    if g[0] != current:
        if lines:
            flush(lines)
        current = g[0]; lines = []
    lines.append(g)
if lines:
    flush(lines)
total_e = sum(expressions.values()); total_r = sum(records.values()); total_n = sum(entries.values())
print('expressions %d records %d entries %d' % (total_e, total_r, total_n))
for why in ('first', 'update', 'branches', 'logical'):
    print('   %-8s expressions %d (%.2f%%) records %d (%.2f%%) entries %d (%.2f%%)' % (why, expressions[why], 100.0 * expressions[why] / total_e, records[why], 100.0 * records[why] / total_r,
                                                                                 entries[why], 100.0 * entries[why] / total_n))
first = records['first']
print('the first piece: lists of kinds: own %d (by template and list), conversion %d, a record\'s own and conversion together %d; records whose own entries are two or more: %d (%.2f%%)' % (
    len(owns), len(convs), len(rows), own_multi, 100.0 * own_multi / first))
print('   entries a record (own and conversion): ' + ', '.join('%d: %d' % kv for kv in sorted(lengths.items())))
print('   own lists: ' + '; '.join('t%d %s x%d' % (k[0], k[1], v) for k, v in owns.most_common(60)))
print('   conversion lists: ' + '; '.join('%s x%d' % kv for kv in convs.most_common()))
print('   target against type (0 another, 1 the same, 2 none) and a value\'s context: ' + ', '.join('%d/%s %d' % (k[0], 'value' if k[1] else 'other', v) for k, v in sorted(sames.items())))
print('   an integer constant that converts: ' + ', '.join('%s to %s %d' % (k[0], k[1], v) for k, v in folds.most_common()))
print('   a truth by its operand\'s conversion\'s class: ' + ', '.join('%s %s %d' % (k[0], k[1], v) for k, v in truths.most_common()))
