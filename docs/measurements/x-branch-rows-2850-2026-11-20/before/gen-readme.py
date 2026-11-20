#!/usr/bin/env python3
# gen-readme.py RECORD FETCH: the branches' rows' record's README, its first section: the count before the
# specification, with its tables made of the record's own lines (count-table.py, before-counts.py, tested-values.py).
import subprocess, sys
record, fetch = sys.argv[1], sys.argv[2]
run = lambda *a: subprocess.run([sys.executable] + list(a), capture_output=True, text=True, check=True).stdout.strip()
before = run(record + '/before/before-counts.py', fetch)
count = run(record + '/before/count-table.py', record + '/before/9700x-count.txt', record + '/before/cloud-own-count.txt')
census = run(record + '/before/tested-values.py', record + '/../x-rows-census-2850-2026-11-19/second')
text = '''# The branches' rows on the window (buster#2850's step 2), 2026-11-20

The evidence for the piece that makes, on the front's window, what the node machine's X sweep writes for a statement's
condition evaluated as branches (`node_machine_classify_branches`'s states and `node_machine_branch_hook`'s entries):
a tested value's test and its branch. The piece before it is
[x-update-rows-2850-2026-11-20](../x-update-rows-2850-2026-11-20/), and the census its specification reads again is
[x-rows-census-2850-2026-11-19](../x-rows-census-2850-2026-11-19/).

## 1. Before the specification (`before/`)

**What the piece before left listed** (`before/before-counts.py` on that piece's final runs on the 9700X,
`../x-update-rows-2850-2026-11-20/final/9700x/xu8/rows-on1-CORPUS-1.txt`):

''' + before + '''

**One count, on the piece before's code** (`before/count.patch` on main `903bf7ef4`: that piece's source and, in its
shadow's loop over the listed expressions, a line of counts at exit). Of the expressions the rows list first for a
record evaluated as branches: those another record lists for another reason; and of the others, their records
evaluated as branches, the values those test (an operand of such a record that is none itself), and of those values
how many have a conversion's part of their own, a narrow class, each number of own entries and a row over eight
entries with the test's three or four. A Develop build on the 9700X (`before/dev-xr-develop.sh`), then
`measure-node-machine --shadow --passes 0 --window-rows` on `sqlite3.c`, Lua and musl, CPU 2, each run its own hold of
the lock (`before/dev-xr-corpora.sh`): `before/corpus-CORPUS.txt` are the runs' outputs and `before/9700x-count.txt`
their lines of counts, in the corpora's order. The compiler's own source's line is the cloud container's
(`before/cloud-own-count.txt`; `before/count-own.patch` has one count more, the expressions with a row over eight).
`before/count-table.py` makes the table; its rows after the second are of the expressions no other record lists:

''' + count + '''

**The values with a conversion's part of their own** are a `const` bool's reads, which the lowering converts to bool
by four entries (a CONVERT to I32, a CONST, NE and a CONVERT to U8) before the test's four. One-statement programs
through the count's build (`before/probes/p1.c` to `p5.c`, `before/const-bool-probes.txt`): a `const _Bool`
parameter's and a `_Bool` member's through a pointer to const have the part, and a `_Bool`'s, a `char`'s and a
comparison's do not.

**The census's lines again** (`before/tested-values.py` on `../x-rows-census-2850-2026-11-19/second/census-*.tsv`: X
on T's columns, every expression it takes, where the count above is of those C takes on the window):

''' + census + '''

`before/gen-spec.py` made the specification's text of these lines (`before/spec-template.md`).
'''
open(record + '/README.md', 'w').write(text)
print('written', len(text))
