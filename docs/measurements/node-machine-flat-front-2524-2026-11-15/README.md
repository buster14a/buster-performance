# The node machine's front by passes (buster#2524), 2026-11-15

The front's walk, [claimed on buster#2524](https://github.com/buster14a/buster/issues/2524#issuecomment-6901949510):
the lean front's records made without its stack, then by passes over a chunk instead of a token at a time. The code is
buster's `c_check_node_machine_flat.c` (`measure-node-machine --shadow --front-flat`); the design's section is "The
front by passes" in buster's `docs/node-machine.md`.

**Result.** Exact: every record the flat front and the lean front both make is equal, field for field, on `sqlite3.c`,
Lua and musl. With its own compaction the flat front is 1.46, 1.13 and 1.18 times faster than the lean front with the
walk's. On `sqlite3.c` it is 36 cycles an acting token (the lean front 52), where the claim's line was 15: not met.
What is left is each class's loads from the reader's per-token columns and about a hundred instructions a record.

## How it was measured

- The 9700X (`benchpress`), CPU 2, every build and run under the host's lock (`scripts/lock.sh`), Release builds
  (`scripts/build-label.sh`). The TSC is 3,792.9 MHz there, 1.4625 cycles a tick at the core's clock.
- The inputs are the 9700X job's corpora: the frozen `sqlite3.c` with its `compile_time` options, Lua 5.4.8's
  `src/*.c`, and musl's 1,336 units by their own options (`scripts/front-o.sh`, `scripts/front-musl-o.sh`).
- A run is `measure-node-machine --shadow --passes 0` with the front's options: the files read once, the fronts' ticks
  by `rdtsc` around their passes (the comparison is outside them). Seven runs for `sqlite3.c` and Lua, three for musl,
  the specs in turn inside a run; the tables have the medians (`scripts/flats.py`).
- "Before the walk" is `--front-flat-first` (the flat front before the walk acts at a chunk, where the machine would
  run) and, for the lean front, `--front-first --front-lean`. "After the walk" is `--front-flat`: the same passes with
  the reader's columns just read by the walk.
- Cycles, instructions and mispredicted branches by function are `perf record` samples by symbol, five processes an
  event with periods two apart (`scripts/perf-events5.sh`, `-all` for every symbol); by source line,
  `scripts/annotate-flat.sh` (thirty processes).

## Builds

Each is buster `55ad392b4` (the head of buster#2867: main `fdf0de745` with that branch merged) with
`patches/LABEL.patch`.

| label | what |
| --- | --- |
| `v1` | no stack, a token at a time: a token's values by hops over its children's lengths, one word a position; the passing tokens marked by the front's own compaction and not visited; a record one 16-byte store |
| `v2` | `v1` with the hops' lengths in a ring the compaction writes (so the hops wait for nothing the pass stores), a record's place advanced under a branch, the counters out of the pass |
| `v2b` | `v2` with the two rings off a 4 KB multiple apart |
| `v3` | by passes: the classes and their lists, the leaves, the places, each class's records, the empty records |
| `v3b` | `v3` with hops that store each word as it comes (no selects), the consumer's two bytes from the distance at hand, and the places' pass a 16-byte copy of a record the classes' pass prepared |
| `v3c` | `v3b` with a statement that is one expression read without a hop |
| `v4` | `v3c` with the comparison's and the tests' last changes: the pull request's sources |
| `u1` | the base for a compile: `55ad392b4` itself (the reader-types record's build) |

## 1. Exact

`results/9700x/v4/front-flatfirst-*-w-1.txt`:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| acting tokens (the lean front's) | 466,925 | 282,317 | 2,828,420 |
| of them, only passing values on: not visited | 125,696 | 165,289 | 1,605,428 |
| records both fronts make, differences | 315,962, 0 | 90,801, 0 | 618,853, 0 |
| records only the lean front makes | 4 | 0 | 0 |
| records only the flat front makes | 0 | 0 | 0 |
| places the flat front leaves empty | 4,656 | 2,255 | 95,511 |
| children hopped over, a visited token | 1.47 | 2.40 | 1.51 |
| distances a byte doesn't hold for the empty places in them | 11 | 0 | 2 |

- The four records are tokens whose value is further back than the rings' 8,192 positions: a condition before a very
  long body. The lean front's stack keeps such a value however far its consumer is.
- An empty place is a token the lean front leaves (its values are not what its operator takes, or one is unknown):
  the flat front keeps its place so that a chunk's places are known before any operand is read. A flat distance is
  the lean one plus the empty places between; 13 distances are then past a byte where the lean front's are not.
- Every run of every build compared the two fronts, and the lean front with the walk's nodes: no difference in any.

## 2. What it costs

Before the walk, ms, each front with the compaction it reads (`results/9700x/flats-LABEL.txt`):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| the lean front, and the walk's compaction (`v4`'s runs) | 4.414 + 0.457 | 1.415 + 0.300 | 13.468 + 1.818 |
| `v1` | 3.899 + 0.270 | 1.190 + 0.215 | 9.434 + 1.857 |
| `v2` | 3.825 + 0.327 | 1.284 + 0.263 | 9.603 + 2.043 |
| `v2b` | 3.823 + 0.325 | 1.312 + 0.267 | 9.342 + 1.942 |
| `v3` | 3.071 + 0.325 | 1.348 + 0.226 | 11.181 + 1.933 |
| `v3b` | 3.022 + 0.326 | 1.308 + 0.226 | 10.839 + 1.924 |
| `v3c` | 2.994 + 0.327 | 1.299 + 0.227 | 10.846 + 1.923 |
| `v4` | 3.012 + 0.329 | 1.287 + 0.225 | 11.080 + 1.925 |
| the lean front against `v4`, compactions included | 1.46 times | 1.13 | 1.18 |

The lean front before the walk read 4.410 and 4.454 ms on `sqlite3.c` in `v1`'s and `v2`'s runs.

`v4` on `sqlite3.c` by stage, ms, before the walk and after it:

| | before | after |
| --- | ---: | ---: |
| the compaction | 0.329 | 0.317 |
| the classes | 0.157 | 0.160 |
| the leaves | 0.498 | 0.368 |
| the places | 0.882 | 0.840 |
| the records | 1.442 | 1.108 |
| the empty records | 0.031 | 0.030 |
| the passes after the compaction | 3.012 | 2.509 |

- **The stack was not the cost.** `v1` is 14% under the lean front on `sqlite3.c` with the compactions, 18% on Lua and
  25% on musl.
- **Nor a dependency of the hops on the pass's stores.** `v2` and `v2b` read as `v1` on `sqlite3.c` and worse on Lua.
- **By passes `sqlite3.c` is 20% under `v1`, Lua 8% over and musl 15% over.** Most of Lua's and musl's visited tokens
  are declarations', which make nothing: a token at a time each is a well-predicted branch and a few loads, and by
  passes each pays every pass.
- **Against the claim's line**, 15 cycles an acting token on `sqlite3.c`: `v4`'s passes are 35.8 and its compaction
  3.9; the lean front's 52.4 and the walk's compaction 5.4.

## 3. Where it goes

By function on `sqlite3.c`, before the walk, millions a process (`results/9700x/LABEL/events5-flatfirst-*.txt`):

| | cycles | instructions | mispredicted branches |
| --- | ---: | ---: | ---: |
| the lean front's pass (`v1`'s `leanfirst`) | 21.6 | 57.0 | 0.193 |
| `v1`'s pass | 19.9 | 42.2 | 0.173 |
| `v2`'s pass | 18.0 | 38.5 | 0.162 |
| `v4`: the places | 4.96 | 15.4 | 0.061 |
| the classes (with the comparison's scalar twin) | 2.92 | 12.5 | 0.001 |
| the conditions | 1.72 | 1.60 | 0.007 |
| the calls | 1.56 | 6.16 | 0.015 |
| the binary operators | 1.44 | 5.12 | 0.006 |
| the leaves | 1.20 | 2.72 | 0.003 |
| the members | 1.00 | 2.32 | 0.002 |
| the casts | 1.00 | 1.92 | 0.001 |
| the returns | 0.36 | 0.40 | 0.001 |
| the subscripts, prefixes, initializers, postfixes, conditionals | 0.68 | 2.00 | 0.004 |
| the empty records | 0.24 | 0.56 | 0.003 |

`node_flat_compact`'s samples include the comparison's scalar twin of it, which no tick counts: the compaction's own
cost is its ticks.

- **A token at a time** (`v2`): 52.9 cycles, 113 instructions and 0.48 mispredicted branches a visited token. By line
  (`results/9700x/v2/annflat-*.txt`) 40% of the cycles and of the mispredicted branches' samples are on the first
  lines after the branch on the class.
- **By passes** the mispredicted branches are 0.10 M a process against 0.162 M, 0.061 M of them in the places' pass:
  its branch on a statement's terminator, whose discards are made there (`results/9700x/v3c/annflat-cycles-node_flat_places.txt`:
  24% of that pass's cycles on the terminator's first line).
- **The classes' own columns.** Over `v3`, `v3b` and `v4` a condition is 110 to 156 cycles, a return 83 to 175 and a
  cast 70 to 114 (few samples each): a condition reads its keyword through the tree's first-child column, a return
  its type's column, a cast its type's. A binary operator is 27 to 33 cycles in `v3b` and `v4` and about 117 instructions, a
  member 31 to 34.
- **The leaves** are 19 cycles a leaf before the walk and 14 after it: an identifier's declared type, its declaration
  and that declaration's flags, three loads by token.
- **Lighter loops changed little.** `v3b` took a seventh of the binary operators' instructions and a twelfth of the
  places'; the stages read 1.445 for 1.421 ms and 0.890 for 0.978.

## 4. A compile

`-c sqlite3.c`, whole processes from three fresh copies of each executable, 21 runs a build (`scripts/ab-copies-n.sh`):

| | wall ms, `u1` | `v4` | against `u1` (over copies) | instructions |
| --- | ---: | ---: | --- | --- |
| first | 122.983 | 122.875 | -0.09% (-0.40% to +0.26%) | 1,363,464,079 and 1,363,807,943 |
| second | 122.853 | 122.743 | -0.09% (-0.37% to +0.12%) | 1,363,464,082 and 1,363,807,944 |

The 344,000 instructions are not the front's: no hook is in the coded walk's loop, and the one call in its start has
a new name. `scripts/symdiff.py` (`results/9700x/symbols-u1-v4.txt`) shows the Release build's parts falling elsewhere
with the new file (other functions are at the parts' ends), and the coded walk's function 41 bytes longer.

## 5. Faults

24 single faults put into the flat front's source one at a time (`scripts/mutate_flat.py`), each built and run through
the census's part of `test-checker` and the comparison on `sqlite3.c` and Lua (`scripts/run_flat.sh`, in the cloud:
`results/cloud/mutations.txt`).

- **As first written the tests showed 15**, the corpora three more (a left literal that gives its place, an earlier
  chunk's empty record taken, a statement of one unknown value discarded), and nothing five others. The 24th didn't
  build as first written (an unused variable) and was written again.
- **The fixture was extended** for what can be reached: a left condition whose body ends in a later chunk, four whose
  bodies are over 255 records, a declaration of two initializers with one left, a left literal under an operator and
  alone, and a switch. The tests then show 21.
- **Three show on no input here:** an identifier with no declared type that the walk acts at (fault 6), a member
  operator without its name (fault 23), and the hops' loop ending a child early (fault 21), which the general loop
  behind it then answers.

## Traps

- **An unknown value read as a place hides.** With fault 14 a statement's unknown value was taken as a record's
  place, and "the ring holds it" refused it wherever the unit had made more than 4,094 records. The fixture's
  statement is the unit's first.
- **A profile by symbol counts the twin.** The comparison runs the compaction's and the classes' scalar twins in the
  same functions: their samples are in the symbols' counts, not in the ticks.
- **The mispredicted-branch event's samples are on the branch's target:** the first line of each case, not the
  `switch`.
- **A 4 KB multiple between two arrays was not it.** The words' and the steps' rings were exactly 32 KB apart, a
  token's word stored just before its consumer loads its step: moving them changed nothing here (`v2b`).

## Files

- `scripts/`: `build-label.sh`, `lock.sh`; the readings `front-o.sh`, `front-musl-o.sh`, `flats.py`; the profiles
  `perf-events5.sh`, `perf-events5-all.sh`, `annotate-flat.sh`; the jobs `job16.sh` (`v1`), `job17.sh` (`v2`),
  `job18.sh` (`v2b`, `v3`), `job19.sh` (`v3b`, `v3c`), `job20.sh` (`v4`, and the compile); `ab-copies.sh`,
  `ab-copies-n.sh`, `symdiff.py`; the faults' `mutate_flat.py` and `run_flat.sh`.
- `patches/`: `v1.patch` to `v4.patch`, each against buster `55ad392b4` (sources only), and `pull-request.patch`: the
  commit that is to be the pull request (`v4`'s sources with the docs), `git format-patch`'s, on the same base.
- `results/9700x/LABEL/`: each build's revision and checksum; `front-TAG-CORPUS-SUFFIX-N.txt` (tags `flat`: the flat
  front after the walk beside the lean one; `flatfirst`: the flat front before the walk; `leanfirst`: the lean front
  before the walk; suffixes `p` to `w` by job); `events5-*.txt`; `annflat-*.txt` and `.chains.txt`.
- `results/9700x/flats-LABEL.txt` (`flats.py`'s output), the jobs' logs, the holds, `ab-copies-u1-v4-*`,
  `symbols-u1-v4.txt`.
- `results/cloud/mutations.txt`: the faults' four runs.
