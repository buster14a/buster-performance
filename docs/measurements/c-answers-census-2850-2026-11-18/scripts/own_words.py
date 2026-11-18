#!/usr/bin/env python3
# own_words.py: whether a template's rule needs T's conversions' types' words. rules.py's templates made again with each
# operand's own type's word in the conversions' place (an array's and a function's as a pointer's; a binary operator's
# two operands' as the wider of their classes, as one type converts both), and compared with the first.
import sys
import collections
import numpy
import features as F
import rules


def value_word(w):
    kind = (w >> 16) & 0xff
    return numpy.where(numpy.isin(kind, (8, 9, 10, 11)), 0x070808, w)


def main():
    for corpus in F.CORPORA:
        d = F.load(corpus)
        raw = d['raw']
        p = rules.operands(d)
        base, _ = rules.templates(d, p)
        saved0, saved1 = raw['c0'].copy(), raw['c1'].copy()
        left, right = value_word(raw['lw']), value_word(raw['rw'])
        op = raw['op']
        binary = ((op >= 5) & (op <= 20)) | ((op >= 42) & (op <= 51))
        shifts = numpy.isin(op, (10, 11, 47, 48))
        wider = numpy.where((left & 0xff) > (right & 0xff), left, right)
        arithmetic = binary & ~shifts & ((left & 0x0800) == 0) & ((right & 0x0800) == 0) & (raw['lop'] != 255) & (raw['rop'] != 255)
        raw['c0'] = numpy.where(arithmetic, wider, numpy.where(raw['lop'] == 255, 0, left))
        raw['c1'] = numpy.where(arithmetic, wider, numpy.where(raw['rop'] == 255, 0, right))
        derived, _ = rules.templates(d, p)
        raw['c0'], raw['c1'] = saved0, saved1
        made = d['made']
        differ = made & (base != derived)
        by = collections.Counter(zip(op[differ].tolist(), base[differ].tolist(), derived[differ].tolist()))
        print('%s: templates with the operands\' own types\' words in the conversions\' place: %d of %d differ%s' %
              (corpus, int(differ.sum()), int(made.sum()),
               ''.join('; %s %s for %s %d' % (F.op_name(k[0]), F.template_name(k[2]), F.template_name(k[1]), v) for k, v in by.most_common(10))))


main()
