#!/usr/bin/env python3
# counts.py [--npz DIR]: what the census counts without a gate: the expressions with rows of their own (a segment, a
# branch, an update), what a kernel from the root down would wait for (a consumer's distance, the rounds a block of 64
# records takes), and by operator what an answer reads that is no byte of the window.
import sys
import collections
import numpy
import features as F
import rules

T = rules.T
O = rules.O


def percent(a, b):
    return '%.2f%%' % (100.0 * a / max(1, b))


def main():
    directory = sys.argv[2] if len(sys.argv) > 2 and sys.argv[1] == '--npz' else 'columns'
    for corpus in F.CORPORA:
        d = F.load(corpus, directory)
        raw, a = d['raw'], d['a']
        count = d['count']
        made = d['made']
        answered = d['answered']
        index, parent, child = rules.links(raw)
        expression = raw['e']
        expressions = int(expression.max()) + 1
        taken = raw['x'] == 0
        print('== %s: %d expressions (%d taken, %d refused for a template, %d for a row), %d records, %d C answers for, %d evaluated with a template (%s of the records)' %
              (corpus, expressions, len(set(expression[taken].tolist())), len(set(expression[raw['x'] == 6].tolist())), len(set(expression[raw['x'] == 7].tolist())), count,
               int(answered.sum()), int(made.sum()), percent(int(made.sum()), count)))
        tpl = a['template']
        state = raw['state']

        def having(mask):
            return len(set(expression[mask & made].tolist()))

        segment = numpy.isin(tpl, (T['BRANCH'], T['DECIDED'], T['SECOND'])) | ((tpl == T['PASS']) & (raw['op'] == O['CONDITIONAL']))
        branched = (state & 0x40) != 0
        update = tpl == T['UPDATE']
        call = tpl == T['CALL']
        any_row = segment | branched | update
        print('   expressions with a segment (`&&`, `||` or `?:` as a value) %d (%s), a branched operator %d (%s), an update %d (%s), any of the three %d (%s); a call %d (%s)' %
              (having(segment), percent(having(segment), expressions), having(branched), percent(having(branched), expressions), having(update), percent(having(update), expressions),
               having(any_row), percent(having(any_row), expressions), having(call), percent(having(call), expressions)))
        labeled = (tpl == T['BRANCH']) | (branched & numpy.isin(raw['op'], (O['LOGICAL_AND'], O['LOGICAL_OR'])))
        hooked = (state & 0x16) != 0
        print('   records with a hook after their row (a condition\'s test, an arm\'s jump, a branch) %d (%s of the evaluated); an update\'s destination %d; evaluated calls %d; '
              'records below an evaluated call %d (%s)' %
              (int((hooked & made).sum()), percent(int((hooked & made).sum()), int(made.sum())), int(((state & 0x08) != 0).sum()), int((call & made).sum()),
               int(((a['depth'] > 0) & made).sum()), percent(int(((a['depth'] > 0) & made).sum()), int(made.sum()))))
        depths = collections.Counter(a['depth'][made].tolist())
        print('   call depth of the evaluated records: %s' % ', '.join('%d: %d' % (k, v) for k, v in sorted(depths.items())))
        # The consumer's distance forward.
        inner = parent >= 0
        distance = (parent - index)[inner]
        print('   a record\'s consumer is %s records ahead at the median, within 15 for %s, within 63 for %s, within 255 for %s; the farthest %d' %
              (int(numpy.median(distance)), percent(int((distance <= 15).sum()), len(distance)), percent(int((distance <= 63).sum()), len(distance)),
               percent(int((distance <= 255).sum()), len(distance)), int(distance.max())))
        sizes = raw['n'][raw['r'] == 0]
        print('   records an expression: mean %.2f, median %d, 99th percentile %d, most %d' % (float(sizes.mean()), int(numpy.median(sizes)), int(numpy.percentile(sizes, 99)), int(sizes.max())))
        # Rounds from the root down, 64 records a step, the records in the order the reader made them: a record waits
        # for its consumer where both are in one block. Every record waits (its consumer's template says whether it is
        # evaluated), or only the records whose rule reads one of its consumer's answers beyond that.
        block = index // 64
        p = rules.operands(d)
        chained = (p['need'] & 2) != 0
        logical_chain = numpy.isin(raw['ctpl'], (T['BRANCHES'],)) & answered
        waits_all = numpy.zeros(count, dtype=numpy.int64)
        waits_some = numpy.zeros(count, dtype=numpy.int64)
        depth_all = numpy.zeros(count, dtype=numpy.int64)
        order = numpy.argsort(-index)
        parent_list = parent.tolist()
        block_list = block.tolist()
        chained_list = (chained | logical_chain).tolist()
        all_list = [0] * count
        some_list = [0] * count
        tree_list = [0] * count
        for g in range(count - 1, -1, -1):
            q = parent_list[g]
            if q >= 0:
                tree_list[g] = tree_list[q] + 1
                if block_list[q] == block_list[g]:
                    all_list[g] = all_list[q] + 1
                    some_list[g] = some_list[q] + 1 if chained_list[g] else 0
        waits_all = numpy.array(all_list)
        waits_some = numpy.array(some_list)
        tree = numpy.array(tree_list)
        blocks = int(block.max()) + 1
        rounds_all = numpy.zeros(blocks, dtype=numpy.int64)
        numpy.maximum.at(rounds_all, block, waits_all + 1)
        rounds_some = numpy.zeros(blocks, dtype=numpy.int64)
        numpy.maximum.at(rounds_some, block, waits_some + 1)
        print('   depth below the root: mean %.2f, 99th percentile %d, most %d' % (float(tree.mean()), int(numpy.percentile(tree, 99)), int(tree.max())))
        print('   rounds a block of 64 records, every record waiting for its consumer: mean %.2f, median %d, 90th percentile %d, 99th %d, most %d (%d blocks)' %
              (float(rounds_all.mean()), int(numpy.median(rounds_all)), int(numpy.percentile(rounds_all, 90)), int(numpy.percentile(rounds_all, 99)), int(rounds_all.max()), blocks))
        print('   rounds a block where only a rule that reads its consumer\'s answer waits (a comma\'s or a selection\'s context, a branched operator\'s operands): '
              'mean %.2f, 99th percentile %d, most %d; blocks with one round %s' %
              (float(rounds_some.mean()), int(numpy.percentile(rounds_some, 99)), int(rounds_some.max()), percent(int((rounds_some == 1).sum()), blocks)))
        # Unevaluated records: under what.
        dead = answered & (a['evaluated'] == 0)
        why = collections.Counter(zip(raw['ctpl'][dead].tolist(), raw['cop'][dead].tolist(), raw['slot'][dead].tolist()))
        under = int((~answered).sum())
        print('   records C doesn\'t evaluate: %d by their consumer\'s rule, %d more below those (or below a refusal): %s' %
              (int(dead.sum()), under, ', '.join('%s as %s, operand %d: %d' % (F.op_name(k[1]), F.template_name(k[0]), k[2], v) for k, v in why.most_common(8))))
        kills = dead & (raw['lop'] != 255)
        print('      of them with records below %d, which are %d records in all' % (int(kills.sum()), int(((~answered) & (raw['x'] != 6)).sum())))
        dead_leaf = dead & (raw['lop'] == 255)
        print('      of them leaves %d (%s)' % (int(dead_leaf.sum()), percent(int(dead_leaf.sum()), int(dead.sum()))))
        # What a template's rule reads that is no byte of the window, by operator.
        t, need = rules.templates(d, p)
        names = ('bytes', 'down', 'payload', 'identity', 'deep', 'operand', 'converted')
        for bit, word in ((3, 'identity'), (2, 'payload')):
            mask = made & (((need >> bit) & 1) != 0)
            by = collections.Counter(zip(raw['op'][mask].tolist(), tpl[mask].tolist()))
            print('   templates whose rule reads %s: %d (%s): %s' % (word, int(mask.sum()), percent(int(mask.sum()), int(made.sum())),
                                                                   ', '.join('%s as %s %d' % (F.op_name(k[0]), F.template_name(k[1]), v) for k, v in by.most_common(14))))
        storage = made & (((raw['op'] == O['VALUE']) & numpy.isin(tpl, (T['LOCAL'], T['GLOBAL'], T['ADDRESS']))) | numpy.isin(tpl, (T['STORE_LOCAL'], T['STORE_GLOBAL'])) |
                          ((tpl == T['UPDATE']) & (raw['lop'] == O['VALUE'])))
        static_flag = ((raw['fl'] >> 7) & 1) != 0
        leaf_storage = made & (raw['op'] == O['VALUE']) & numpy.isin(tpl, (T['LOCAL'], T['GLOBAL']))
        agree = leaf_storage & (static_flag == (tpl == T['GLOBAL']))
        print('   templates that read an object\'s storage (a name\'s read, a store or an update by name): %d (%s); a name\'s read whose flags\' static bit says it: %d of %d' %
              (int(storage.sum()), percent(int(storage.sum()), int(made.sum())), int(agree.sum()), int(leaf_storage.sum())))
        pointer = made & ((tpl == T['POINTER']) | ((tpl == T['UPDATE']) & ((raw['up'] & 16) != 0)))
        print('   templates that read a type\'s row: a pointer\'s stride %d (%s), a call\'s parameters %d (%s)' %
              (int(pointer.sum()), percent(int(pointer.sum()), int(made.sum())), int((made & (raw['op'] == O['CALL'])).sum()), percent(int((made & (raw['op'] == O['CALL'])).sum()), int(made.sum()))))
        logical = made & numpy.isin(raw['op'], (O['LOGICAL_AND'], O['LOGICAL_OR'], O['CONDITIONAL'])) & ~branched
        known = logical & (((raw['lst'] >> 2) & 7) != 0)
        divisor = made & numpy.isin(raw['op'], (O['DIVIDE'], O['REMAINDER'], O['DIVIDE_ASSIGN'], O['REMAINDER_ASSIGN'])) & (((raw['rst'] >> 2) & 7) == 1)
        print('   templates that read a constant\'s value: a condition that is a constant %d, a division or a remainder by an integer constant %d (%s together)' %
              (int(known.sum()), int(divisor.sum()), percent(int(known.sum()) + int(divisor.sum()), int(made.sum()))))
        sunk = made & (tpl == T['NONE']) & numpy.isin(raw['op'], (O['LOGICAL_AND'], O['LOGICAL_OR'], O['CONDITIONAL']))
        print('   `&&`, `||` and `?:` C refuses (their consumer\'s conversion goes into their arms, or an operand is no scalar): %d' % int(sunk.sum()))
        differ = made & (t != tpl)
        by = collections.Counter(zip(raw['op'][differ].tolist(), tpl[differ].tolist(), t[differ].tolist()))
        print('   templates the restated rules miss: %d: %s' % (int(differ.sum()), ', '.join('%s: C %s, rule %s: %d' % (F.op_name(k[0]), F.template_name(k[1]), F.template_name(k[2]), v)
                                                                                           for k, v in by.most_common())))
        # The refusals.
        stop = (raw['x'] == 6) & (raw['r'] == raw['stop'])
        by = collections.Counter(raw['op'][stop].tolist())
        print('   refused for a template, by the record it stopped at: %s' % ', '.join('%s %d' % (F.op_name(k), v) for k, v in by.most_common(12)))
        arguments = made & (raw['slot'] >= 3) & (raw['slot'] <= 8)
        print('   a call\'s arguments among the evaluated records: %d (%s), their target T\'s conversion of the argument, which no line holds' %
              (int(arguments.sum()), percent(int(arguments.sum()), int(made.sum()))))


main()
