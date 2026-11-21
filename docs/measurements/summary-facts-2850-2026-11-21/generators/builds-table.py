#!/usr/bin/env python3
# builds-table.py NAME=FILE.json...: how the side facts' sweep came to its cost: a row a build, from xs-table.py's files,
# in the order given. NAME is the row's own text's key below.
import json, sys
what = {
    'xs1': "the masks, the lists and the counts' column; the references' mask by two compares of the kinds and two tests under a mask of the chunk's records; both lists compressed in every block; the reduction for every expression with a call that stops; the tests' loop's mask of plain callees from three columns (the operators, the standings, the lines' bytes)",
    'xs2': "the references' mask by a table's shuffle and one test, with no mask of the chunk's records (the tests' sweep writes a block's bytes whole); the calls' list only in a block that has one; the counts' stores aligned; the reduction only where the expression has an `&&`, an `||` or a `?:`",
    'xs3': "a line's byte's two bits a plain function's and a noreturn one's (they were a noreturn one's and an unknown name's): the tests' loop's test is one AND of the lines' bytes, with no standing read",
    'xs4': "the code as first frozen: the terms the first three fault rounds took out",
    'xs5': "a cast's term in C's loop and the value's column's choice, both in a run with the facts and without them alike",
    'final': "**the code here**: the objects by a gather of eight where a loop wrote them one a step",
}
corpora = ('sqlite3', 'lua', 'musl')
def three(t, key, digits=2, signed=False): return ', '.join(('%+.*f' if signed else '%.*f') % (digits, t[c][key]['median']) for c in corpora)
print("| build | the sweep, a record swept, a chunk's second run | a first run less a second, ticks a chunk | the tests' loop, more | the rows' sweeps with the facts, a second run, more | readings |")
print('| --- | ---: | ---: | ---: | ---: | ---: |')
for a in sys.argv[1:]:
    name, path = a.split('=', 1)
    t = json.load(open(path))
    print('| %s | %s | %s | %s | %s | %d |' % (what[name], three(t, 'sweep_second'), three(t, 'sweep_cold', 0), three(t, 'loop', 2, True), three(t, 'rows_all_second', 2, True), t['sqlite3']['runs']))
print()
print('(`sqlite3.c`, Lua and musl in each cell.)')
