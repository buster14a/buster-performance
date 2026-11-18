#!/usr/bin/env python3
# parse.py OUT.npz FILE: the census's lines of one corpus (measure-node-machine --shadow --passes 0 --census-c-lines) as
# columns, one numpy array a field, the fields named as in the lines.
import sys
import numpy

DECIMAL = ('e', 'r', 'n', 'p', 'x', 'stop', 'op', 'tr', 'mo', 'ac', 'dc', 'lop', 'rop', 'top', 'slot', 'cop', 'ctpl', 'sop', 'caop', 'same', 'tpl', 'depth', 'hk')
HEX = ('w', 'st', 'fl', 'ex', 'ob', 'c0', 'c1', 'cf0', 'cf1', 'lw', 'lst', 'lfl', 'lex', 'rw', 'rst', 'rfl', 'rex', 'tst', 'cw', 'cst', 'cfl', 'cctx', 'cstate', 'ctw', 'cc', 'ccf',
       'sw', 'sst', 'sfl', 'sex', 'lob', 'ro', 'cast', 'cafl', 'caex', 'state', 'ctx', 'tw', 'ts', 'up')


def main():
    out, path = sys.argv[1], sys.argv[2]
    names = None
    bases = None
    columns = None
    refusals = {}
    for line in open(path, errors='replace'):
        if line.startswith('cx:'):
            refusals[line.strip()] = refusals.get(line.strip(), 0) + 1
            continue
        if not line.startswith('cc:'):
            continue
        tokens = [t for t in line.split()[1:] if t != '|']
        if names is None:
            names = [t.split('=')[0] for t in tokens]
            assert sorted(names) == sorted(DECIMAL + HEX), sorted(set(names) ^ set(DECIMAL + HEX))
            bases = [16 if n in HEX else 10 for n in names]
            columns = [[] for _ in names]
        for column, token, base in zip(columns, tokens, bases):
            column.append(int(token[token.index('=') + 1:], base))
    arrays = {n: numpy.array(c, dtype=numpy.int64) for n, c in zip(names, columns)}
    numpy.savez_compressed(out, **arrays)
    print('%s: %d records, %d expressions; refusals before C: %s' % (path.split('/')[-1], len(columns[0]), len(set(columns[names.index('e')])), refusals))


main()
