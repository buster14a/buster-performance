# The branches' rows on the window (buster#2850's step 2), 2026-11-20

The evidence for the piece that makes, on the front's window, what the node machine's X sweep writes for a statement's
condition evaluated as branches (`node_machine_classify_branches`'s states and `node_machine_branch_hook`'s entries):
a tested value's test and its branch. The piece before it is
[x-update-rows-2850-2026-11-20](../x-update-rows-2850-2026-11-20/), and the census its specification reads again is
[x-rows-census-2850-2026-11-19](../x-rows-census-2850-2026-11-19/).

## 1. Before the specification (`before/`)

**What the piece before left listed** (`before/before-counts.py` on that piece's final runs on the 9700X,
`../x-update-rows-2850-2026-11-20/final/9700x/xu8/rows-on1-CORPUS-1.txt`):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions C takes on the window | 49,155 | 9,909 | 39,712 |
| their tapes made today | 47,027 (95.67%) | 9,689 (97.78%) | 38,705 (97.46%) |
| **listed for X, first for an operator evaluated as branches** | 2,046 | 200 | 790 |
| the records C's loop evaluates as branches | 5,613 (1.75% of the records swept) | 570 (0.62% of the records swept) | 2,364 (0.63% of the records swept) |
| of them a statement's CONDITION | 2,198 | 230 | 877 |
| listed first for an update; a refused conversion; a constant to a floating class | 73; 1; 8 | 10; 0; 10 | 4; 20; 193 |

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

| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| **listed for X, first for a record evaluated as branches** | 2,046 | 200 | 790 | 3,217 |
| of them with another record that lists them | 0 | 1 | 0 | 0 |
| their records evaluated as branches; of them roots | 5,126; 2,046 | 465; 199 | 2,102; 790 | 8,668; 3,217 |
| the values those test | 4,860 | 428 | 1,814 | 7,941 |
| with a conversion's part of their own | 0 | 0 | 0 | 759 |
| of a narrow class (the test has four entries, and three otherwise) | 227 | 5 | 122 | 2,296 |
| own entries: none; one; two; three; four | 0; 4,509; 39; 312; 0 | 0; 419; 0; 9; 0 | 0; 1,651; 107; 56; 0 | 0; 7,645; 16; 280; 0 |
| a row over eight entries with the test; the expressions with one | 0; 0 | 0; 0 | 0; 0 | 759; 559 |

**The values with a conversion's part of their own** are a `const` bool's reads, which the lowering converts to bool
by four entries (a CONVERT to I32, a CONST, NE and a CONVERT to U8) before the test's four. One-statement programs
through the count's build (`before/probes/p1.c` to `p5.c`, `before/const-bool-probes.txt`): a `const _Bool`
parameter's and a `_Bool` member's through a pointer to const have the part, and a `_Bool`'s, a `char`'s and a
comparison's do not.

**The census's lines again** (`before/tested-values.py` on `../x-rows-census-2850-2026-11-19/second/census-*.tsv`: X
on T's columns, every expression it takes, where the count above is of those C takes on the window):

| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| values an operator evaluated as branches tests | 4,970 | 607 | 1,994 | 9,367 |
| with a conversion before the test | 0 | 0 | 0 | 1,009 |
| the test and the branch: three entries | 4,740 | 600 | 1,867 | 6,629 |
| four (a narrow class's) | 230 | 7 | 127 | 2,738 |
| another number | 0 | 0 | 0 | 0 |
| own entries: 0 | 3 | 36 | 19 | 6 |
| own entries: 1 | 4,611 | 560 | 1,805 | 9,012 |
| own entries: 2 | 41 | 0 | 109 | 21 |
| own entries: 3 | 315 | 11 | 61 | 328 |
| own entries: 4 | 0 | 0 | 0 | 0 |
| rows over eight entries | 0 | 0 | 0 | 1,009 |
| a branch of kind 37 | 1,059 | 114 | 549 | 1,768 |
| a branch of kind 36 | 3,911 | 493 | 1,445 | 7,599 |
| operators evaluated as branches | 5,223 | 621 | 2,260 | 9,646 |

`before/gen-spec.py` made [the specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7037879405)'s
text of these lines (`before/spec-template.md`; `before/specification.md` is the text as posted). What the counts
found of a `const` bool's read is [buster14a/buster#3185](https://github.com/buster14a/buster/issues/3185).
