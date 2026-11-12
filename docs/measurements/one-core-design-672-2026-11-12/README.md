# Where one core's time goes, node by node: the measurements behind buster#2524's design (2026-11-12)

These are the measurements that [buster#2524](https://github.com/buster14a/buster/issues/2524)'s design
(`docs/node-machine.md` in buster) rests on, taken for
[buster#672](https://github.com/buster14a/buster/issues/672)'s one-core target. They attribute the compile of the
frozen `sqlite3.c` to the compiler's stages by hardware counters, split it between the unit's function bodies and its
file scope, compare it with tcc's own split on the same file, and count what a table of node transitions could take.
Section 9 runs a prototype of the design's three sweeps over the compile's real nodes, for what tables decide and what
the sweeps cost. Nothing here measures the design itself: it isn't built.

- **Source:** buster `d96b2e731e42a4a4740fa78e494578f90eaff5a5` (main on 12 November), a clean clone built on the host
  by `./build.sh` (Release, `-O3 -march=native`, debug information), `raw/build.log`. The executable's SHA-256 is
  `7c5d15c6d70d778704ac6c2c59a64e029295ab90deec710496085a7f617bd897`.
- **Host:** the Ryzen 7 9700X (`benchpress`), Linux 6.18.50, clang 23.1.1, perf 7.2.9. `env.txt` has the kernel, the
  CPUs, the governors, transparent huge pages, the tools' versions and every script's and input's hash.
- **Every run** was one hold of the machine's lock (`scripts/lock.sh`), pinned to CPU 2, whose SMT sibling is offline
  and whose governor is `performance`. Each script writes the lock's own line for its hold first
  (`raw/*/holder.txt`, `raw/*/*.holder.txt`).
- **Workload:** `-c` of the frozen corpus's `sqlite3.c` (SHA-256 `0a409f16…`, 9,507,037 bytes) with the 9700X job's
  `compile_time` options (`-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5
  -DSQLITE_ENABLE_RTREE`, the system's headers): 716,136 preprocessed tokens. The second workload is the corpus's musl:
  the first source of each base name, 1,336 units, as one command on one lane.

## 1. The whole process and its stages

`scripts/baseline.sh stages`: `measure-compile --runs 11` against tcc, the 9700X job's step. `raw/baseline/measure-compile.txt`.

| | wall ms | user cycles | user instructions | per token: ns, cycles, instructions |
| --- | ---: | ---: | ---: | --- |
| buster `-c` | 123.798 (123.028 to 125.444) | 596.2 M | 1,338.8 M | 172.9, 832.6, 1,869 |
| tcc `-c` | 42.845 (42.573 to 43.473) | 219.9 M | 537.6 M | 59.8, 307.1, 751 |

2.89 times tcc. The stages' medians, in ms: `check-input` 45.832, `check-program` 23.692, `check-expressions` 11.462,
`lower` 11.373, `preprocess` 9.374, `parse` 7.206, `tier0` 5.530, `check-declarations` 1.978, `select` 1.126,
`emit-setup` 1.012, and the rest under 1 ms each; the span is 122.796. The checker's stages from `check-input` to
`lower` are 96.0 ms, 78% of the span. The object is `raw/baseline/object.txt`'s.

`scripts/baseline.sh counters` (`raw/baseline/stat-*.csv`, `perf stat -r 5`, each group never multiplexed), per compile:
595.2 M user and 86.3 M kernel cycles, 1,338.8 M user instructions (2.25 a cycle), 3.56 M mispredicted branches of
202.4 M, 11.27 M L1D demand fills (8.67 M from L2, 1.27 M from L3, 1.44 M from DRAM), 48.2 M op-cache misses of
364.1 M accesses, and a load not complete at retirement in 247.6 M of the cycles (41.5%). Of the dispatch slots
(8 a cycle), 26% retire, 9% are bad speculation, 24% wait for the frontend and 40% for the backend.

`scripts/baseline.sh chains` (cycles and instructions with DWARF call chains) gave empty chains for all but 131 of
12,243 samples. The cause wasn't looked into; a frame that starts at a stack page nothing has touched, which the
sampling interrupt can't copy, has given such chains before. Its record log is kept; the stages' counters below come
from sample times instead.

## 2. Counters by stage

`scripts/stagecounters.sh 6`: three leader-sampled groups, six `--time-stages` compiles each under
`perf record -T -c 100003` (55,000 samples a second, under the host's cap of 63,300), each run's own stage report
beside its samples. `scripts/tools/stage_reduce.py` puts each sample in the stage its time falls in: the clock's start
on perf's clock is the median of three estimates (the first sample of a function of the parser, of the reader and of
Tier 0, each less the stages before it), which agree within 0.15 to 0.35 ms. The first run of the first group, the
first process of its hold, ran its preprocessing and parsing 2.3 times slower than the others (its other stages as
theirs) and is left out; the cause wasn't looked into. Sampling made the runs 6% slower (130.4 against 122.8 ms), each
stage by 5% to 8%.
`tables/stage-work.tsv`, `stage-td.tsv`, `stage-lat.tsv` are the reductions, `tables/stage-work-functions.tsv` every
stage's functions, and `tables/stage-summary.md` this table, per preprocessed token:

| stage | cycles | instructions | IPC | mispredicts | L1D fills | from L2 | from L3 | from DRAM | op-cache misses | retiring | bad speculation | frontend | backend | a load not complete |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| preprocess | 60.3 | 173.6 | 2.88 | 0.33 | 1.72 | 1.47 | 0.22 | 0.02 | 5.0 | 36% | 9% | 24% | 31% | 20% |
| parse | 32.6 | 67.7 | 2.08 | 0.17 | 0.95 | 0.80 | 0.14 | 0.02 | 1.0 | 26% | 9% | 17% | 47% | 17% |
| check-input | 307.1 | 629.8 | 2.05 | 1.24 | 6.74 | 5.19 | 0.48 | 1.06 | 32.1 | 25% | 6% | 27% | 42% | 43% |
| check-expressions | 82.1 | 264.8 | 3.23 | 0.63 | 1.10 | 0.93 | 0.11 | 0.05 | 7.6 | 35% | 12% | 27% | 26% | 35% |
| check-declarations | 15.3 | 34.8 | 2.28 | 0.04 | 0.17 | 0.08 | 0.05 | 0.04 | 1.0 | 25% | 4% | 16% | 55% | 60% |
| static-data | 2.9 | 3.3 | 1.13 | 0.03 | 0.06 | 0.03 | 0.01 | 0.02 | 0.1 | 11% | 13% | 28% | 48% | 42% |
| check-program | 183.4 | 293.2 | 1.60 | 1.51 | 2.73 | 1.81 | 0.40 | 0.53 | 4.8 | 18% | 13% | 24% | 44% | 54% |
| select | 7.2 | 10.8 | 1.50 | 0.06 | 0.24 | 0.15 | 0.04 | 0.03 | 0.1 | 17% | 12% | 23% | 47% | 51% |
| lower | 87.7 | 221.7 | 2.53 | 0.53 | 1.25 | 0.94 | 0.16 | 0.14 | 6.4 | 28% | 9% | 26% | 37% | 43% |
| emission | 66.0 | 148.9 | 2.26 | 0.38 | 1.08 | 0.93 | 0.10 | 0.05 | 11.4 | 31% | 8% | 34% | 27% | 28% |
| publish-data | 3.7 | 12.4 | 3.33 | 0.04 | 0.03 | 0.02 | 0.00 | 0.00 | 0.1 | 36% | 13% | 25% | 26% | 26% |
| object-build | 2.7 | 8.4 | 3.14 | 0.03 | 0.07 | 0.06 | 0.01 | 0.01 | 0.0 | 34% | 16% | 28% | 22% | 27% |
| total | 852.7 | 1871.7 | 2.19 | 5.01 | 16.16 | 12.46 | 1.72 | 1.98 | 69.8 | 26% | 9% | 26% | 39% | 41% |

`emission` is the stages from `tier0` to `code-atoms` as one row: the emission's loop runs them function by function,
so a sample's time can't split them (`tier0_generate`'s samples fall in four of their buckets). The lowering runs
before that loop, and the stages before it one after another, so their rows are their own. The cycles include the
sampling's overhead (852.7 a token against `perf stat`'s 831).

## 3. tcc's split on the same file

`scripts/tccprofile.sh`: the package's `tcc -c` of the same command, 8 compiles under the first group.
The package's `libtcc.so` is stripped, and exports its `ST_FUNC` functions; its text keeps its source files' order but
for a few small functions (`raw/tcc/libtcc-symbols.txt`), so `scripts/tools/tcc_regions.py` puts each sample in a
source file by its address between chosen exported symbols, a static function's by the library's load base in its
process. `tables/tcc-regions.tsv`, per token of buster's count:

| tcc's part | cycles | instructions | share |
| --- | ---: | ---: | ---: |
| `tccpp.c`: lexer and preprocessor | 147.4 | 344.8 | 47.9% |
| `tccgen.c`: parser, semantics, code generation | 101.8 | 255.5 | 33.0% |
| `x86_64-gen.c`, `i386-asm.c`: machine code | 28.9 | 70.7 | 9.4% |
| libc | 12.4 | 30.2 | 4.0% |
| `tccelf.c` and the rest of the object file's | 8.7 | 21.9 | 2.8% |
| `libtcc.c`: allocation, strings | 5.3 | 13.8 | 1.7% |
| the loader and the rest | 3.5 | 6.7 | 1.1% |

So tcc parses, checks and generates machine code for about 131 cycles a token, where buster's stages from `parse` to
the object take about 790, and buster preprocesses for 60 where tcc takes 147. The split is by address ranges of a
link-time-optimized library: a function placed outside its file's range is counted in the wrong part. A build of tcc
with its symbols, which would settle that, wasn't made (the session wasn't allowed to build external code on the host).

## 4. The file scope alone, and the bodies by difference

`scripts/census.sh` preprocesses the unit (`-E -P`); `scripts/tools/spine.py` replaces each file-scope `{` that follows
a `)`, to its `}`, by `;`: 2,674 bodies and 568,641 of the 716,136 tokens go, and 150,169 stay
(`raw/spine/spine.txt`). `scripts/spine.sh 11` compiles both preprocessed units, alternating, 11 times each with
`--time-stages`. The unit without bodies compiles with status 0 and 106 `-Wundefined-internal` warnings.
`tables/spine-stages.tsv`, medians in ms:

| stage | whole, `-c` | file scope, `-c` | the bodies' |
| --- | ---: | ---: | ---: |
| preprocess (of a preprocessed unit) | 2.439 | 1.106 | 1.333 |
| parse | 7.283 | 1.674 | 5.609 |
| check-input | 45.399 | 11.530 | 33.869 |
| check-expressions | 11.434 | 0.251 | 11.183 |
| check-declarations | 1.970 | 0.217 | 1.753 |
| static-data | 0.502 | 0.143 | 0.359 |
| check-program | 23.701 | 2.051 | 21.650 |
| select | 1.148 | 0.140 | 1.008 |
| lower | 11.413 | 0.137 | 11.276 |
| tier0 | 5.539 | 0.000 | 5.539 |
| the rest of the emission and the object | 4.355 | 0.153 | 4.202 |
| total | 115.623 | 17.939 | 97.684 |

The bodies, 79.4% of the tokens, are 84.5% of the time; from `check-input` to `lower` they are 81.1 of 95.6 ms. Peak
RSS is 228.5 MB whole and 84.7 MB without bodies (`time-process peak-rss-kb`), and `-fsyntax-only`'s kernel cycles
74.4 M and 26.0 M (`raw/spine/stat-*.csv`).

`scripts/spineprofile.sh` profiles both by function (8 compiles each), and `scripts/tools/body_share.py` takes the
difference, per body token (`tables/body-share.tsv`): the bodies cost 875 cycles and 1,814 instructions a body token,
497.5 M of the whole unit's 575.2 M user cycles (86.5%). By the stage a function's samples fell in most:
`check-input` 300.1, `check-program` 216.6, `lower` 107.2, `check-expressions` 102.3, the emission's loop 65.8 and
more in the object's stages, `parse` 31.8, `check-declarations` 19.3, `select` 7.0. The stages from `check-input` to
`lower` are 752 cycles and 1,524 instructions a body token.

By family of function, a name's prefix (`scripts/tools/body_families.py`, `tables/body-families.tsv`), in cycles and
instructions a body token:

| family | cycles | instructions |
| --- | ---: | ---: |
| the reader's other functions (`check_input_*` but its expressions', `c_bindings_*`, `check_constant_*`) | 152.9 | 287.7 |
| the program and its controls (`check_program*`, `check_control_*`) | 126.2 | 205.2 |
| warnings (`check_common_*`, `check_unseq_*`, `check_driver_common_warnings`, `check_input_warning_graph`) | 121.6 | 180.3 |
| the graph's construction (`check_input_expression*`, the literals) | 98.9 | 157.3 |
| the lowering (`check_lower_*`) | 93.0 | 239.3 |
| the emission (`tier0_*`, `x86_*`, `branch_sizing_*`, `unwind_*`) | 76.0 | 186.6 |
| the graph run's loop (`check_graph_*`) | 52.3 | 186.7 |
| the parser and the tree's columns (`parse_*`) | 44.4 | 115.7 |
| the C rules for a node (`check_action_*`) | 30.9 | 110.7 |
| libc's `memset`, `memmove`, `memcmp` | 26.7 | 17.1 |
| initializers and static data (`check_init*`, `check_data_*`, `check_const_*`) | 24.6 | 51.5 |
| the type table (`type_*`) | 5.9 | 14.7 |
| the preprocessor and the lexer | 5.9 | 24.0 |
| everything else | 15.7 | 37.0 |

The bodies hold 266,707 evaluated nodes (below), 2.13 body tokens each: the stages from `check-input` to `lower` spend
about 1,600 cycles and 3,250 instructions on each.

## 5. What a table of node transitions could take

`scripts/inventory.sh` and `inventory2.sh` run the tree's own counts (`raw/inventory/`): #1048's
`measure-lowering-templates`, as it is and with categories counted as ordinary (`--allow`), and #1050's
`--check-transitions` on `-c`.

| `sqlite3.c`: 2,668 lowered bodies, 266,707 evaluated nodes, 406,765 typed entries | |
| --- | ---: |
| entries owned by nodes, by their conversions, by statements and frames | 79.3%, 13.1%, 7.6% |
| nodes: ordinary, calls, `&&` `\|\|` `?:`, bit-fields, builtins and `va_arg` | 93.01%, 5.13%, 1.53%, 0.27%, 0.07% |
| ordinary keys, deterministic | 2,055, 2,050 (92.98% of the nodes) |
| abstract patterns, and the first 64's nodes | 189, 91.9% |
| with calls, selections and bit-fields ordinary: keys, deterministic, abstract patterns | 2,254, 2,206, 240 |
| bodies without an exception: ordinary alone | 12.41% of the bodies, 2.82% of the nodes |
| … with calls and selections ordinary | 91.30%, 67.04% |
| … and bit-fields | 98.16%, 92.41% |
| … and builtins and `va_arg` | 100%, 100% |
| statements' expressions, and those whose nodes are all ordinary with a deterministic key | 52,368, 69.3% |
| memoized transitions on `-c`: hits, misses, entries | 150,819, 26,227, 26,135 |

With calls counted as ordinary the inventory's key, which has no argument count, gives a call's key several patterns
(16,634 nodes of undetermined keys): that is the key's, not the calls'.

musl's 1,336 units (2,756 lowered bodies, 131,092 nodes, 207,461 entries): ordinary 92.11% of the nodes, calls 4.71%,
selections 1.92%, complex, atomic and vector values 0.57%, compound literals' second pops 0.47%, builtins and
`va_arg` 0.18%; bodies without an exception 32.84% (7.88% of the nodes), with calls and selections 87.77% (73.56%),
with bit-fields 88.03% (74.97%), with builtins and `va_arg` 90.24% (80.74%).

## 6. The tokens, by where they are

`scripts/tools/census.py` and `constructs.py` on `census.sh`'s preprocessed text (`tables/census.txt`,
`tables/constructs.txt`). The text itself isn't in the record: `census.sh` makes it again from the corpus.

| | `sqlite3.c` | musl, 1,336 units |
| --- | ---: | ---: |
| tokens | 716,136 | 5,039,561 |
| in function bodies | 568,641 (79.4%), 2,674 bodies | 1,424,367 (28.3%), 18,584 bodies |
| in file-scope braces (records, enums, initializers) | 42,876 (6.0%) | 536,945 (10.7%) |
| the rest of file scope | 104,619 (14.6%) | 3,078,249 (61.1%) |
| largest body, and the ten largest's share of the body tokens | 28,599 tokens, 15.5% | 3,290 tokens, 1.6% |

The census's lexer counts `sqlite3.c`'s tokens as the compiler does. Its rule for a body is lexical. `constructs.txt`
counts, by spelling, the bodies that hold each construct: in `sqlite3.c`, `&&` or `||` is in bodies with 73.0% of the
body tokens, `?:` 47.2%, `sizeof` 44.9%, a string literal 43.9%, `goto` 27.1%, `switch` 20.2%, a brace initializer
18.5%, a `static` local 15.5%, a `__builtin_` name 9.2% (`va_arg`'s 1.6%), and asm, a statement expression, `typeof`
or a computed goto in none.

## 7. musl as one command

`scripts/musl.sh` and `muslprofile.sh`: 1,336 units, `-c --lanes 1`, CPU 2: 980.0 ms; 4,372 M user and 1,054 M kernel
cycles, 11,461 M user instructions, 343,019 page faults (`raw/musl/stat-c.csv`). A many-unit command reports its
units' stages as one, so `scripts/tools/stage_of.py` divides each function's samples among the stages in the
proportions `sqlite3.c`'s timed samples gave it (`tables/musl-stages.tsv`): `check-input` 46.6% of the user cycles,
`preprocess` 16.8%, `check-program` 7.3%, the emission's functions 6.3%, `parse` 5.7%, `check-expressions` 3.7%,
`lower` 3.5%, and 5.4% in functions `sqlite3.c`'s compile gave no stage. The kernel has 22.1% of all cycles
(`raw/musl/cycles-dso.txt`).

## 8. The estimate

`scripts/tools/gains.py` (`tables/gains.txt`) is the design's estimate of its gains, not a measurement: the cycles a
body token that each of the design's steps would stop spending for what its machine takes (a reading of the tables of
section 4: which functions run for a node today), three sets of assumed coverage and of the machine's own cost, and
the compile's 681.5 M cycles. It gives 1.24, 1.34 and 1.39 times after the design's step 2, 1.38, 1.57 and 1.68 after
step 3, and 1.61, 2.00 and 2.40 after step 4, and 2.91 times if the bodies' work from `check-input` to `lower` were
free. The design's first two steps exist to replace its assumptions with counts and times.

Section 9's prototype measures part of two of those assumptions. Its sweeps cost 46.8 cycles a body token, of the 90,
55 and 45 that the three cases give the machine's whole work on expressions: the expected case's 55 would leave 8 for
the lookups, the records and the silence tests that the prototype doesn't do, so a first machine is likelier between
the expected and the conservative cases. The estimate depends little on it: with 90% of the nodes in taken
expressions, step 2 gives 1.34 at 55 cycles a body token, 1.31 at 75, 1.29 at 90, 1.25 at 120 and 1.22 at 150
(`tables/gains.txt`'s last rows). And the prototype's tables take expressions holding 96.5% of `sqlite3.c`'s nodes
and 88.2% of musl's before any test for diagnostics, against the cases' 80%, 90% and 95%.

## 9. A prototype of the design's sweeps over the real nodes

**The data.** `scripts/dump.sh` rebuilds the tree with `scripts/inventory-dump.patch`, a patch to
`measure-lowering-templates` alone (no compile's code changes; the patched executable's hash is in
`raw/sweeps/dump-identity.txt`, and every other section is the unpatched one's), and has the inventory write, for
every lowered body, each expression task's pop with the lowering's own key for its node (its operator, its context,
its type's class and facts, its constant kind, category and flags, its first two operands' types and its conversion
target), the node whose task pushed it, and every typed entry with the pop that wrote it: 28.7 MB for `sqlite3.c`
and 14.3 MB for musl's 1,336 units (`raw/sweeps/dump-sizes.txt` has their hashes; the dumps aren't stored).

**The prototype.** `scripts/tools/sweeps.c` reads a dump and runs the design's three sweeps over it, one full
expression's tree at a time, with no graph, stream or task:

- **T**, up the postorder: each node's facts (its type's class and facts, its constant kind, its category, its flags,
  its object's kind) from a table keyed by its operator, its evaluated operands' facts and its first two operands'
  types.
- **C**, down from the root: each operand's context (address, initialized, discard, `_BitInt`, popped twice) and
  conversion target from a table keyed by its node's operator, context and facts and by its own operator and facts.
- **X**: the lowering's key of each node rebuilt from that state alone, the node's template (its entries' kinds and
  classes, in runs before, between and after its operands' entries, and the conversion asked of it) from a table by
  that key and the operand count, and the expression's entries written in evaluation order with fixed-width stores:
  straight down the postorder when no node of the tree writes before or between its operands, by a walk otherwise.

It is **not the machine**: it reads no source, binds no name, reads no type table, tests nothing for diagnostics. What
a declaration or the type table would give the machine, it is given: a leaf's facts; the facts of a cast, a member, a
subscript, a dereference, a call, a conversion and a builtin; the targets of a call's and a builtin's operands; a
root's context; and every entry's value, in its node's template's order. Its tables are **learned from the dump**
and hashed (one 16-byte slot a key, a multiply or two a lookup over the nodes' 64-bit fact codes), where the design's
are baked from the rules and indexed by small codes. A key that two nodes answer differently is a conflict and
refuses the expressions of its nodes; a node whose entries no template of this shape holds (more than 16, a run of
more than 8, an entry inside an operand's entries, a node popped twice) gives its key no template. An expression is
taken when every node of it is in the tables, with nothing of the pipeline's answers deciding that, and its emitted
entries are then compared with the stream's own, kind, class and value. `scripts/sweeps.sh` ran it three times a unit
with 31 passes each and once with the other unit's tables (`raw/sweeps/sweeps-*.txt`), and `scripts/probes.sh` the
readings of the dumps that chose the keys (`scripts/tools/key_probes.py`, `raw/sweeps/key-probes-*.txt`).
Both ran under `lock.sh` as every script here did, each in a hold of its own, but they don't write the lock's line
as the others do. `tables/sweeps.md` (`scripts/tools/sweeps_summary.py`) has all of it; in short:

| | `sqlite3.c` | musl's 1,336 units |
| --- | ---: | ---: |
| evaluated nodes, in full expressions | 266,707 in 52,368 | 131,092 in 26,451 |
| leaves; nodes typed by the table; nodes whose facts a lookup gives | 42.1%; 22.2%; 35.7% | 44.4%; 27.8%; 27.7% |
| type keys, in conflict | 3,075, 0 | 2,835, 0 |
| operands the context table is asked; its keys, in conflict | 179,916; 9,742, 0 | 92,119; 9,476, 14 |
| template keys, in conflict; templates | 2,400, 3; 787 | 2,396, 4; 865 |
| rebuilt keys that differ from the lowering's | 0 | 0 |
| nodes in taken expressions | 257,465 (96.5%) | 115,610 (88.2%) |
| emitted entries, and those that differ from the stream's | 346,998, 0 | 154,132, 0 |
| cycles, instructions, mispredicted branches a node, an expression at a time | 99.7, 264, 1.16 | 100.6, 268, 1.16 |
| … a unit at a time, cycles: T, C, the templates' choice, the expansion | 15.8, 32.1, 37.2, 21.3 | 16.9, 30.5, 36.5, 21.0 |

What it shows:

- **The operands' facts decide a node's facts** for every operator outside the lookups' (all of the arithmetic, the
  comparisons, the logical operators, `?:`, the comma, `&x`, the assignments, the increments, the condition): no key
  in conflict in either unit, and with the other unit's tables no wrong answer for the 51,514 and 27,324 nodes whose
  keys they know. The first two operands' types have to be in the key: without them a store to an object that isn't
  evaluated as an operand is undecided (6,233 of `sqlite3.c`'s assignments).
- **Most types are lookups, not transitions.** 42% of `sqlite3.c`'s evaluated nodes are leaves and 36% take their type
  from a declaration or the type table: 39,998 casts (37,534 of them to void: the discards), 31,435 member accesses,
  13,545 calls, 6,938 subscripts, 1,988 conversions and 1,145 dereferences. The table types 22%. T's cost in the
  machine is then mostly the lookups it shares with today's rules, which the prototype is given.
- **An operand's context and target are its node's to decide, with the operand's own operator.** No key in conflict
  in `sqlite3.c`; 14 in musl (97 operands). Without the operand's operator in the key, 30,375 operands of
  `sqlite3.c`'s casts are undecided: a discard's cast to void gives a comma the discard itself and any other operand a
  conversion to void. A call's and a builtin's operands (16% of `sqlite3.c`'s) take their targets as given.
  That the tasks pop a node twice (a compound literal's value wherever it is used, and in musl some dereferences at a
  root with their operand: 613 nodes, none in `sqlite3.c`) isn't in the node's key, so the context carries it, and
  the table gives it to an operand without a new conflict.
- **The lowering's key and the operand count decide a node's entries**, but for 3 keys in `sqlite3.c` (an aggregate's
  assignment in two keys, 50 nodes one way and 3 the other, and an atomic builtin, whose entry's class the key
  doesn't hold) and 4 in musl (the aggregate's two; a complex local's conversion to `float`, by its parts' class; and
  a local array's value, `LOCAL_ADDRESS` for 1,152 nodes and `LOCAL` for 47, which the key has no fact for). Every
  taken expression's entries are the stream's, entry for entry.
- **What it refuses is mostly its own templates' shape**, not the design's: in `sqlite3.c` a node of more than 16
  entries or of a run of more than 8 (2.4% of the nodes are in such expressions: the post-increments and
  post-decrements, the bit-field stores and reads, `va_arg`) and a node with an entry inside an operand's entries
  (0.9%: compound assignments and increments), then the conflicting keys (0.2%). The four runs themselves serve the
  5,770 nodes (2.2%) that write before or between their operands: `&&`, `||`, `?:` and the compound assignments. In
  musl also the nodes popped twice (3.2%) and the conflicting keys, the array's above first (6.3%).
- **Learned tables are not the design's.** With the other unit's tables the sweeps take 59% of `sqlite3.c`'s nodes and
  42% of musl's, since a key here is a node's whole facts, and `sqlite3.c`'s tables give musl 23 wrong entries, all
  that array's key's: `sqlite3.c` has no node of its second answer. Tables baked from the rules over every key, and
  the pipeline kept as their check, are the design's answer to both.
- **The cost.** 99.7 cycles, 264 instructions and 1.16 mispredicted branches a node of `sqlite3.c` (99.5 to 101.7
  over the three runs), 103.3 a taken node: 46.8 cycles a body token, against the 752 that the stages between the
  parser and Tier 0 spend and the 391 that the design's step 2 would stop spending. An expression at a time, the
  design's order, costs 6% less than a unit at a time and mispredicts a third less. The hashed keys and the branches
  on a node's kind are the prototype's; the lookups it is given are not in its time.

## Limits

- **One host, one day, one revision.** Each table is `d96b2e73`'s on the 9700X; the runs of a table are interleaved
  or repeated, but tables taken in different holds are not an A/B of anything.
- **Per-stage counters are sampled**, at 100,003 cycles a sample: a stage under about 1 ms holds few samples, and a
  boundary is known to about 0.3 ms. The emission's stages aren't separable (above).
- **The bodies' cost is a difference** of two units: the file scope's own time includes the 106 warnings it prints,
  and the bodies' includes what they cost the file scope's passes (their tokens in every unit-wide pass).
- **Functions stand for stages on musl**, by `sqlite3.c`'s proportions.
- **tcc's parts are address ranges** of a stripped, link-time-optimized library.
- **The inventory counts the lowering's view** (which typed entries a node gives). It doesn't count which nodes could
  raise a diagnostic, which the design's first milestone has to.
- **The prototype is not the machine** (section 9): its lookups, its entries' values and its roots' contexts are
  given, its tables are learned from the unit they are used on, and it tests nothing for diagnostics. Its counts say
  what keys decide in two corpora, not in C; its time is the sweeps' mechanics over 31 passes of one unit's nodes, with
  the tables warm, not a compile's.
- No run here used more than one lane or more than one process at a time.

## Files

- `env.txt`: the host and the identities. `raw/COMMIT`, `raw/build.log`: the tree and its build.
- `scripts/`: `lock.sh` (the hold), `build.sh`, `env.sh`, and one script a measurement; `scripts/tools/` the reducers
  and `sweeps.c`, the prototype. `scripts/inventory-dump.patch` is section 9's patch to the tree; `env.txt`'s hashes
  are from before it, and `raw/sweeps/scripts-hashes.txt` has section 9's scripts'.
- `raw/`: every run's output as written, by measurement. `raw/stagecounters/*.samples.gz` are `perf script`'s samples.
- `tables/`: the reductions, each made from `raw/` by the tool named above, and `gains.txt`, the estimate.
