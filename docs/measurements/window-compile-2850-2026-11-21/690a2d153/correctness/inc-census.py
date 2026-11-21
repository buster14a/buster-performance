from pathlib import Path
import collections, gzip, struct, sys
records = Path(sys.argv[1])
opener = gzip.open if records.suffix == '.gz' else open
values = Path(sys.argv[2])
read_values = gzip.open if values.suffix == '.gz' else open
with read_values(values, 'rb') as raw:
    tokens = {token for token, op, slot, value in struct.iter_unpack('<III96s', raw.read())}
counts, proofs, places = [collections.Counter() for i in range(3)]
def root(record, nodes):
    if record is None: return
    graph_root, operand, op_token, term, records, warning, mismatch, parent_role, line = map(int,record[1:])
    op = nodes[operand]
    lhs = nodes.get(int(op[5]))
    if op[4] not in ('x++', 'x--') or not lhs or lhs[4] != 'value' or int(lhs[14]) != 1 or int(lhs[8]) != 64: return
    taken = int(op[3]) in tokens
    counts[op[4], taken] += 1
    proofs[taken, warning, mismatch, all(int(row[-1]) for row in nodes.values())] += 1
    places[taken, parent_role, int(nodes[graph_root][15])] += 1
    if not taken and int(nodes[graph_root][15]) == 9: print('for step outside the cut', line, op[3], term, 'operand flags', lhs[13])
record, nodes = None, {}
with opener(records, 'rt') as source:
    for line in source:
        fields = line.rstrip().split('\t')
        if fields[0] == 'assignment-shape':
            root(record, nodes)
            record, nodes = fields, {}
        elif fields[0] == 'assignment-node':
            nodes[int(fields[2])] = fields
root(record, nodes)
print('op,taken', dict(counts))
print('taken,warning,conversion mismatch,raw parity', dict(proofs))
print('taken,enclosing parser role,terminator token kind',dict(places))
