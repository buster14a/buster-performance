# #2850's take-over: where `-c sqlite3.c` stands at `d541430bf`, and #3270's reading

Raw results of [buster14a/buster#2850](https://github.com/buster14a/buster/issues/2850)'s take-over of
2026-11-22 ([the claim](https://github.com/buster14a/buster/issues/2850#issuecomment-7077096460)). The Ryzen 7
9700X (`benchpress`), CPU 2, one lane, Release, every run under the lock. The input is the frozen `sqlite3.c`
(9,507,037 bytes, 716,136 preprocessed tokens) with the 9700X job's options:
`--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`.
`scripts/` has what ran: `setup.sh` (an independent clone and a Release build a revision), `stages.sh`,
`profile.sh`, `pair.sh` and its reducer `reduce.py`, and `agg.py`, which sums the profiles.

## The stage table at main `d541430bf`

`stages-d541430bf/`: seven fresh processes with `--time-stages`. Medians, in milliseconds (the lowest and the highest
in the files):

| stage | ms |
| --- | ---: |
| setup | 0.21 |
| preprocess (read 0.58, lex 2.45, refine 1.85, directives 0.36, the main loop 4.35) | 9.57 |
| parse | 6.82 |
| check-input | 42.08 |
| check-expressions | 10.57 |
| check-declarations and static data | 2.54 |
| check-program | 18.85 |
| select | 0.98 |
| lower (prepare 0.97, statements 8.11, bodies 1.28, validate 1.15) | 11.61 |
| Tier 0 | 4.91 |
| the emission's setup, branch sizing, the encoder, unwinding, the code's atoms | 2.43 |
| the data's publication, the object's build and write | 1.31 |
| **total** | **111.94** |

The process: 98.7 ms user, 16.3 ms system, 5,643 minor faults, 238.6 MB peak. One of the seven, the second, ran on
base pages (56,408 faults, 179 MB peak, 143.0 ms): its report says `huge-pages busy`, the arenas' page policy having
found 9 tasks runnable when it started (`before-2.txt`), where the other six found 1 and say `system`. The medians
leave it out of sight; a comparison of two builds has to look for it.

## The profile at main `d541430bf`

`profile-d541430bf/`: eight runs under `perf record -e cycles -c 100003` (user and kernel), reported by symbol
(`report-N.txt`), and five under `perf stat` (`stat.csv`): 545.3 M user cycles, 74.2 M kernel cycles, 1,235.2 M user
instructions, 3.15 M mispredicted branches and 17.2 M first-level data misses a compile, 110.9 ms.
`by-function.txt` is `agg.py`'s sum: the forty functions with the most cycles, then the families. Cycles a token and
milliseconds at 5.49 GHz:

| family | share | cycles a token | ms |
| --- | ---: | ---: | ---: |
| the reader but its expressions (`check_input_*`) | 17.4% | 155.3 | 20.3 |
| the kernel (`clear_page_erms` alone 8.4%, 75 cycles a token) | 13.1% | 117.0 | 15.3 |
| the graph's construction (`check_input_expression*`, the literals) | 9.3% | 82.9 | 10.8 |
| the lowering (`check_lower*`) | 9.0% | 80.4 | 10.5 |
| the program and its controls | 8.6% | 76.7 | 10.0 |
| the warnings | 8.3% | 74.1 | 9.7 |
| Tier 0, the encoder, the emission | 6.1% | 54.7 | 7.1 |
| the parser | 4.7% | 42.3 | 5.5 |
| the graph run (`check_graph*`) | 4.6% | 40.8 | 5.3 |
| other `check_*` | 4.4% | 39.1 | 5.1 |
| the preprocessor and the lexer | 4.0% | 36.0 | 4.7 |
| the C rules for a node (`check_action*`) | 2.6% | 23.0 | 3.0 |
| libc's `memset`, `memmove`, `memcmp` | 2.5% | 22.3 | 2.9 |
| the types, the bindings, the node machine, the rest | 5.6% | 49.8 | 6.5 |

The families are name prefixes (`agg.py`'s rules), so a function inlined into another family's is counted there.

## #3270 on the 9700X: the selected operands' storage on demand

`pair-d541430bf-afde6c1c9/`: main `d541430bf` against buster14a/buster#3270's head merged with it (`afde6c1c9`).
Seven rounds, each parent, candidate, candidate, parent or the reverse; each position takes the lock once and runs a
warm-up, a wall-clock run and a counters run, all fresh processes. `summary.txt` is `reduce.py`'s: a round's value is
the mean of its two runs of an arm, the columns are the medians of the rounds and of the rounds' differences.

| | main | #3270 | paired | lowest | highest | rounds lower |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| wall, ms | 112.720 | 112.662 | -0.058 | -0.286 | +25.247 | 4 of 7 |
| user cycles a token | 757.156 | 753.479 | -1.269 | -4.954 | -0.282 | 7 of 7 |
| kernel cycles a token | 108.753 | 108.559 | -0.133 | -1.281 | +1.365 | 4 of 7 |
| user instructions, M | 1,235.184 | 1,235.084 | -0.101 | -0.101 | -0.101 | 7 of 7 |
| page faults | 5,469 | 5,469.5 | 0 | -1.5 | +1.5 | 3 of 7 |

All 56 objects are one object and the diagnostics one stream. The +25.2 ms round holds one wall run of 165.7 ms (the
candidate's, round 1, position 1); the other 27 wall runs are 111.8 to 115.7 ms. That run's faults were not recorded
(`pair.sh` counted them in the counters run alone, and has recorded the wall run's since), so that it ran on base
pages, as the stage table's second run did, is likely and not shown. On this host, with its 2 MB pages, the faults don't move (the 902 fewer of the pull request's
description are the 7940HS's); what the change saves here is the column's clearing, 1.3 user cycles a token in every
round, and the wall clock doesn't resolve it.

A load average of 4.1 at the first rounds is this session's own build of the candidate, just before (`*.load`); the
lock's `busy` lines, if any, are in `lock.log`.

## #3270 on four workloads

`pair2-WORKLOAD-d541430bf-afde6c1c9/`: `pair2.sh`, the same pairing for `sqlite3.c`, the compiler's own source
(`main.c` at `84a7d3d76`, 2,433,563 tokens), Lua's 34 units as one command and musl's 1,336 as one command; a wall
run is timed by `wallrun.py`, which records its faults too. Seven rounds each; the paired medians (`summary.txt`):

| | wall, ms | paired | rounds lower | user instructions, M, paired | rounds lower |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 111.914 | -0.057 | 4 of 7 | -0.100 | 7 of 7 |
| the compiler's own source | 601.222 | -1.655 | 4 of 7 | -2.318 | 7 of 7 |
| Lua | 64.004 | +0.057 | 3 of 7 | -0.050 | 7 of 7 |
| musl | 668.459 | -0.321 | 4 of 7 | -0.937 | 7 of 7 |

Every run's objects are one set a workload and its diagnostics one stream. An earlier form of the change (buster#3262)
cost musl 3.0 ms; this one costs no workload anything the wall clock resolves, and retires fewer instructions on all four.

## `codex/2850-packed-comma-contexts` on four workloads

`pair2-WORKLOAD-d541430bf-comma-ctx/`: main against the branch's one commit (`7e5a53d39`, the comma contexts as a bit
a token where they were a byte) merged with it on the 9700X (`fbb4c1739`, a local merge).

| | wall, ms | paired | rounds lower | user cycles, M, paired | rounds lower | user instructions, M, paired |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 112.146 | +0.080 | 3 of 7 | -0.993 | 4 of 7 | +0.232 |
| the compiler's own source | 601.486 | -0.540 | 4 of 7 | -14.193 | 5 of 7 | +2.115 |
| Lua | 64.112 | -0.238 | 7 of 7 | -0.960 | 7 of 7 | +0.079 |
| musl | 668.601 | -2.287 | 6 of 7 | -5.147 | 5 of 7 | +1.113 |

It retires a few more instructions everywhere and takes less time on the two workloads of small units. One of
`sqlite3.c`'s wall runs took 25,430 faults more than its pair's (base pages): the +20.9 ms in that summary's range.

## The window's options at main

`pair-d541430bf-d541430bf-__node_window_assignments_/` (seven rounds; its wall runs failed, for want of
`/usr/bin/time` on the host, and only its counters stand) and `pair2-sqlite-d541430bf-d541430bf-__node_window/` (one
round): main against itself with the option. `--node-window-assignments` takes 8,990 expressions and replaces 26,183
graph nodes, and costs 10.69 M user instructions and 9.3 cycles a token more, in every round; `--node-window` (7,617
expressions, 20,691 nodes) 14.3 M instructions and 1.4 ms more in its one round. Either option also turns off the
statement controls' path main has had since buster#3267, so these don't price a node.

## What a first compile could take: the slice count

`slice-count-sqlite.txt`: `measure-node-machine --shadow --window-rows --passes 0` with `scripts/slice-count.patch`
(an experiment's counter, not for merge), which sorts each expression whose tape X makes whole on the window by what
the tests said of it and by what its tape names of its function's. Of 321,434 records swept, in records:

| the tests | plain | with a call | with a label of its own, a temporary or a branch to its control's label | all |
| --- | ---: | ---: | ---: | ---: |
| nothing listed, silent | 126,473 (39.3%) | 77,522 | 20,255 | 224,250 (69.8%) |
| listed, then silent on T's records | 27,816 | 12,679 | 14,052 | 54,547 (17.0%) |
| refused | | | | 45 |

(49,839 tapes, 278,842 records; "plain" is no call, no label of its own, no temporary and no branch to the
control's label; a tape with a call and a label is counted under the label's column.)

## The flip's ceiling: the middle without its taken expressions

`bound-d541430bf/`. The question: if every expression the window's machine takes cost the compile one leaf, what
would the stages between the parser and Tier 0 take? It is what step 2 can save at most, before any of it is built.

- `sqlite3.c` preprocessed by main (`-E`, 716,136 tokens; compiled, it is the ordinary object but for its file's name).
- The shadow, with the patch, prints each whole tape's expression's tokens and root (`experiment-span`);
  `scripts/tok.py` tokenizes the preprocessed file (716,136 tokens, the compiler's count) and `scripts/transform.py`
  replaces each such full expression of a statement, a condition or a `switch` by `__z`, a volatile global: one leaf
  under the root the reader makes. A `return`'s value and an initializer are left as they are (7,670 expressions,
  22,743 records). `transform-counts.txt` has what each variant replaced.
- Removing calls leaves most static functions unreferenced, and the selection then lowers 179 of 2,399
  (`bound-first-d541430bf/`, that first, biased run). So every variant ends with `scripts/keeper.c`, a function that
  names each static function and object: all four then emit the same 2,399 static functions.
- Seven `--time-stages` runs a variant, in a rotating order, each under the lock (`bound.sh`, `bound-reduce.py`).

Medians, ms; the middle is `check-input` to `lower`:

| | none replaced | plain | nothing listed | all whole tapes |
| --- | ---: | ---: | ---: | ---: |
| records replaced | 0 | 119,834 | 215,630 | 256,069 |
| check-input | 42.441 | 37.792 | 31.753 | 29.485 |
| check-expressions | 10.747 | 8.980 | 6.485 | 5.052 |
| check-program | 19.150 | 16.215 | 12.233 | 13.775 |
| lower | 11.814 | 9.923 | 7.016 | 5.808 |
| **the middle** | **87.633** | **76.291** | **60.234** | **56.738** |
| **less than none replaced** | | **-11.342** | **-27.399** | **-30.895** |
| a record replaced, ns | | 94.6 | 127.1 | 120.7 |

What it says:

- **Step 2's ceiling on `sqlite3.c` is about 31 ms of 112** with every whole tape taken at no cost, 27 with those the
  tests decide on the window alone, 11 with the plain ones alone. The shadow's own first-run readings put the
  machine at about 120 TSC ticks a record swept (the front 55, the kernel with its names 22, the tests 27 to 38, C 8,
  X 9), 10 ms a compile, whatever it takes. So: about 21, 17 and 1 ms net, 1.23, 1.18 and 1.01 times.
- **The plain slice alone does not pay.** A first compile has to take calls to gain anything.
- **With no taken expression left, the middle is still 57 ms**: the bodies' statements, declarations and scopes, the
  file scope, and what the machine refuses. That is the part of the 9.5 ms target no expression machine reaches.

The stand-in is one leaf where a summary node is one node and its rows' splice, and the leaf's own lowering and
emission are in the variants' later stages, which the middle leaves out: the bound is rough to a millisecond or two
either way, and it is a ceiling, not a forecast.

### The residue's profile

`bound-d541430bf/profile-all/` and `profile-none/`: eight cycle profiles each (`profile-file.sh`) of the variant with
every whole tape replaced and of the one with none, summed by `agg.py` (`by-function.txt`; its cycles a token are over
the unit's 716,136, not the variant's). With no taken expression left, 407 M cycles a compile: the reader's walks that
are no expression's 15.5 ms (`check_input_declaration`, `_declarator_step`, `_specifiers` and `_declarator` 5.5 of
them, `check_input_resolve_range` 3.7), the kernel 12.2 (`clear_page_erms` 7.7; the peak is 185 MB where the unit's is
237), the program and its controls 7.1, the graph's construction 5.7, the lowering 5.0, the warnings 4.6, Tier 0 and
the emission 4.2.

## The redesign's two bounds: bodies whole, and the fixed costs' floor

### With no function body

`bound-bodies-d541430bf/`: the preprocessed `sqlite3.c` whole, and with each of its 2,674 function definitions' bodies
replaced by `;` (`scripts/nobody.py`: 568,641 of the 716,136 tokens), seven `--time-stages` runs each (`bound.sh`). The
variant without bodies gives 106 warnings (static functions an initializer names, now undefined), which are in its time.

| | whole | no bodies |
| --- | ---: | ---: |
| preprocess and parse | 10.475 | 2.613 |
| check-input | 41.353 | 10.815 |
| check-expressions | 10.593 | 0.183 |
| check-program | 18.767 | 2.652 |
| lower | 11.495 | 0.131 |
| **the middle** | **85.797** | **14.245** |
| Tier 0, the emission, the object | 8.756 | 0.150 |
| total | 105.267 | 17.991 |

The bodies' part of the middle is 71.6 ms, where every whole tape's expression is 30.9: a body taken whole, with no
token of it read by the stages between the parser and Tier 0, is worth 2.3 times what its expressions are.

### What a fresh process pays whatever it compiles

`floor/` (`scripts/floor.c`, `floor.sh`, `floor-reduce.py`): a static program that maps `sqlite3.c`, reads every byte
once (a newline count, 64 bytes a step), writes one byte a line of N megabytes of new anonymous memory, and writes
2,061,192 bytes to a file; eleven fresh processes a variant under `perf stat`, and eleven timed by `wallrun.py`.

| | wall, ms | user, M cycles | kernel, M cycles | faults |
| --- | ---: | ---: | ---: | ---: |
| `/bin/true` | 0.196 | 0.19 | 0.23 | 55 |
| the source mapped and read | 0.297 | 0.48 | 0.30 | 78 |
| and 8 MB touched, the object written | 1.377 | 0.95 | 3.13 | 82 |
| 16 MB | 1.786 | 1.60 | 3.87 | 86 |
| 32 MB | 2.842 | 2.92 | 7.31 | 94 |
| 64 MB | 4.506 | 4.94 | 13.80 | 110 |
| 128 MB | 7.844 | 7.56 | 30.00 | 142 |
| 238 MB, the compile's peak | 13.154 | 12.15 | 54.34 | 198 |
| 238 MB on base pages | 35.125 | 39.70 | 137.28 | 61,007 |
| main compiling an empty `main` | 0.525 | 0.73 | 1.35 | 242 |

New memory costs 51 µs a megabyte on 2 MB pages (0.27 M cycles, 0.22 M of them the kernel's): the 238 MB a compile
of `sqlite3.c` touches today are 12 ms before any work, more than the 9.5 ms asked. Reading every byte of the source
costs 0.1 ms. (Here the object's file exists and is truncated; `floor-output/` separates that.)

`floor-output/` (`scripts/output.c`, `output.sh`): the object's 2,061,192 bytes alone, the file removed before each run
or rewritten, on the benchmark directory's btrfs and on tmpfs.

| | wall, ms | kernel, M cycles |
| --- | ---: | ---: |
| the buffer filled, nothing written | 0.353 | 0.85 |
| one `write` to a new file | 0.729 | 2.36 |
| one `write` over an existing file | 1.090 | 3.42 |
| a new file mapped and filled in place | 0.757 | 2.61 |
| tmpfs, one `write` to a new file | 0.663 | 1.87 |
| tmpfs, mapped | 0.508 | 1.46 |

Writing the object to a new file costs 0.38 ms on this filesystem, 4% of the target, and rewriting an existing one 0.36
more. So the floor of a compile that keeps 8 MB and writes this object is about 1.0 ms of the wall clock: 0.2 for the
process, 0.4 for its memory, 0.4 for the write.
