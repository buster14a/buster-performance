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

### Again after #3270 (`pair2-WORKLOAD-610b32c3e-5647be701/`, `scripts/job-comma2.sh`)

The branch merged with main `610b32c3e` (`5647be701`: main no longer allocates the selected tokens' column for every
unit, #3270, and the merge keeps that), against that main, seven rounds each:

| | wall, ms | paired | rounds lower | user instructions, M, paired | page faults, paired |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 111.630 | +0.105 | 2 of 7 | +0.241 | +0.5 |
| the compiler's own source | 600.911 | +0.185 | 3 of 7 | +2.548 | -15.0 |
| Lua | 64.456 | -0.063 | 6 of 7 | +0.091 | -4.5 |
| musl | 670.444 | -0.187 | 4 of 7 | +1.140 | -4.0 |

Nothing is left of the first reading's time on Lua and musl: each wall difference is inside its rounds' spread, and
the branch retires more instructions on every workload. It was not proposed. (musl's `*.stderr` files are left out of
the record as before; their hashes are the `.diag` files.)

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

### With every body masked in place: the body flip's real ceiling

`mask-exp-mask/` (`scripts/mask.sh`, `mask-reduce.py`; the tree is main `d541430bf` with `scripts/experiment.patch`,
Release). With `BUSTER_EXPERIMENT_MASK_BODIES` set, the driver masks every function body as `-flazy-system-headers`
masks a deferred one (2,674 bodies, 568,641 tokens): the reader's walk jumps over it and no later stage sees it, while
its tokens stay in the unit's columns. The object then has no function; the times are what the unit costs around its
bodies. Seven runs a variant, in turn, medians, ms:

| | the preprocessed file | masked | `sqlite3.c` | masked |
| --- | ---: | ---: | ---: | ---: |
| preprocess and parse | 10.498 | 10.441 | 16.056 | 16.170 |
| check-input | 41.356 | 22.585 | 41.859 | 22.841 |
| check-expressions | 10.654 | 0.280 | 10.612 | 0.285 |
| check-program | 18.737 | 2.821 | 18.829 | 2.749 |
| lower | 11.631 | 0.351 | 11.464 | 0.368 |
| **the middle** | **85.840** | **27.010** | **86.489** | **27.142** |
| Tier 0, the emission, the object | 8.750 | 0.202 | 8.801 | 0.203 |
| total | 105.413 | 37.974 | 111.684 | 43.799 |
| peak, MB | 232 | 210 | 238 | 216 |

- **A body flip in today's host is worth 59 ms of the middle, not 72.** The 13 ms between this residue (27.1) and
  the unit without its bodies' tokens (14.2) are the reader's unit-wide passes, which read every token whether the
  walk does or not, and the memory, which does not fall (216 MB): 21 ns for each of the bodies' 568,641 tokens.
- With the mask the reader's coded walk is off for the unit (`check_input_expressions_coded_range`'s condition), so
  the file scope's few expressions take the older walk here.
- So `sqlite3.c` with every body taken by something that costs nothing would compile in 43.8 ms and the bodies' code
  (8.6 ms of Tier 0 and emission today); what takes the bodies adds its own cost.

### What blocks a body, and the order that unlocks the most

`census/` (`scripts/experiment.patch`'s `experiment-body` lines, reduced by `scripts/unlock.py`; `census/*.txt` have the
four corpora's slice, placement and body lines). A body is free where every expression of it is the census's and the
reference machine's, and its controls are the plain ones (an evaluation, an initialization, a return, a branch, a
jump, an exit, a result). On `sqlite3.c`'s 2,668 lowered bodies and 262,863 evaluated nodes:

| unlocked, in the order that frees the most | bodies with it | bodies whole | their nodes |
| --- | ---: | ---: | ---: |
| nothing more | | 2,086 (78.2%) | 43.4% |
| bit-fields | 188 | 83.4% | 52.2% |
| the machine's refusals (291 expressions) | 201 | 89.1% | 63.6% |
| the callee's tests (library calls) | 141 | 93.7% | 74.6% |
| the operator's tests | 54 | 95.4% | 76.5% |
| aggregate values | 33 | 96.4% | 78.3% |
| braced initializers | 19 | 96.9% | 80.2% |
| `switch` and `case` | 82 | 100% | 100% |

The placement lines (`experiment-whole`) are an upper bound of what the window decides alone: an expression counts
where every record of a made kind is the kernel's own, and a record of a kind the kernel never makes is not counted
against it.

## The body boundary's first increment: the reader's fast paths under a mask

`claude/2850-body-boundary` at `0b150b71b` against its parent, main `3b518936a`. A lazy mask turned three of the
reader's paths off for the whole unit: the coded walk's class actions, the packed simple declarations (#3268) and the
statement heads (#3267). The branch keeps them on.

### Every body masked (`mask-mask-main/`, `mask-mask-branch/`)

Both trees with `scripts/experiment-mask-only.patch` (the every-body mask of the section above, and nothing else),
Release, `scripts/job-boundary1.sh`; seven rounds, medians of `--time-stages`, ms:

| frozen `sqlite3.c`, every body masked | main | branch |
| --- | ---: | ---: |
| `check-input` | 22.93 | 21.27 |
| `check-program` | 2.76 | 2.62 |
| `check-input` to `lower` | 27.32 | 25.60 |
| total | 43.91 | 42.06 |
| peak, MB | 216.2 | 222.3 |

The same unit unmasked reads 111.24 and 111.12 ms in the two trees' interleaved runs. The 6 MB more under the mask
are the statement heads' columns, which a masked unit didn't allocate.

### Nothing moves without a mask (`pair2-sqlite-3b518936a-0b150b71b/`)

Seven ABBA rounds of the ordinary `-c sqlite3.c`: 112.06 and 111.87 ms (paired -0.24, between -0.77 and +0.26), 1,216.053 M
and 1,216.049 M user instructions, one set of objects and one of diagnostics.

### Kept bodies beside masked ones (`maskdiff/`, `scripts/maskdiff.sh`)

The every-body mask leaves no kept body for the packed declarations and the statement heads to act on, so the
difference between the old conditions and the new was read with a partial mask too: `scripts/experiment-mask-modulus.patch`
masks the bodies whose ordinal modulo N is K. Develop builds of main and of the branch with it, on this session's
machine (not the 9700X: nothing is timed), over `sqlite3.i`, Lua's 34 units, musl's 1,336 and `main.c`, by default and
with `-Wall -Wextra`, with no mask and with the masks 2:0, 2:1 and 3:1: 32 configurations, each one's objects and
diagnostics one set in the two builds (`maskdiff/summary.txt`; a masked musl unit that both reject counts as the same).
With half of `sqlite3.i`'s bodies masked (2:0) the branch's compile is 649.8 M user instructions and main's 797.2 M
(Develop builds; unmasked, 1,160.047 M and 1,160.048 M), so the paths do run in the compared compiles.

## Type ids under a mask (`typeids/`)

What the boundary's interface turns on. `ty.h` is a system header whose unused static function makes types (a pointer
to an array of a struct, a pointer to a pointer, a pointer to a complex); `ty.c` includes it and then has a function
whose expressions use types made after it. `--dump-typed` of `ty.c`, by the branch's Develop build at `0b150b71b`:
read whole (`eager.txt`), the comparison `pp != 0` has its operands at type 608; with `-flazy-system-headers`
(`lazy.txt`: the planner masks the unused body, `deferred=1`), at type 568. So a type made after a masked body has
another id than in the whole read, and nothing recorded from a whole read that names a type by its id can be given to a
masked read. A lowered function (`Tier0Function`) names nothing by type id: only symbols.

## Where the unit's memory is (`memory/`)

`scripts/experiment-memory.patch` on main `3b518936a` (not for merge): every arena reservation registered with its
caller and stage; at each of the stage clock's marks, each arena's resident bytes (`mincore`) and the bytes of its 4 KB
pages that hold a nonzero byte; the same at an arena's release; and for every push of 512 KB or more, its range's
resident and filled bytes at the reader's end and at the object's. Release build, the frozen `sqlite3.c` with the
record's flags, one lane, on this session's machine (not the 9700X: sizes, not times), once with the arenas in base
pages (`BUSTER_EXPERIMENT_BASE_PAGES`, `base-pages.txt`) and once in huge pages (`BUSTER_HUGE_PAGES=1`,
`huge-pages.txt`); `scripts/memory-attribute.py` reduces them (`*-reduced.txt`). The peak here is 237.7 MB in huge
pages, the 9700X's 238.5.

By stage on the 9700X (`mask-exp-mask3/c-whole-3.stages`' `peak-kb-added`): setup 4.7 MB, preprocess 39.6, parse 59.1,
`check-input` 118.8 (106.0 with every body masked), `check-declarations` 5.5, and nothing after. So the peak is the
reader's, and every later stage lives in memory an earlier one touched (its minor faults are a few hundred).

| at its most resident, MB | base pages | filled | huge pages |
| --- | ---: | ---: | ---: |
| the driver's scratch arena | 71.7 | 55.6 | 84.1 |
| the driver's retained arena (the reader's output) | 52.0 | 45.3 | 78.0 |
| the driver's output arena (the checked graph and after) | 35.9 | 31.4 | 46.1 |
| the reader's own arena, released at its end | 11.2 | 10.9 | 11.2 |
| the parser's columns (two arenas) | 10.3 | 10.3 | 13.7 |
| the preprocessor's (file caches, tables, the interner) | 16.6 | 16.6 | 24.9 |
| the program's, the object's and Tier 0's small arenas | 4.2 | 4.0 | 14.1 |
| the compiler's own file pages and the source | 22.9 | | 22.9 |
| peak of the process | 185.8 | | 237.7 |

What it says:

- Of the 238 MB the kernel clears on the 9700X, about 52 are huge pages' slack: columns pushed at their capacity and
  filled in part, each leaving the rest of its last huge page (the graph's twelve 3.1 MB columns hold 1.1 MB each and
  take a 2 MB page each), columns written at a few places across their extent (2.7 MB of huge pages for 0.1 MB of
  written 4 KB pages, three times), and small arenas that touch one huge page for a few hundred KB (the program's 6.0
  MB for 1.0, Tier 0's inline body's 2.0 for nothing, the preprocessor's 8.2 for 4.1).
- Of what a base-page run touches, about 28 MB are 4 KB pages left zero at the marks (16 in the scratch arena, 7 in
  the retained, 5 in the output; the arenas' most resident less their filled): cleared columns that few tokens write,
  and one 2.9 MB column the reader's intrinsics initialize and `sqlite3.c` never writes.
- The rest holds data: the base-page peak is 185.8 MB, 22.9 of them file pages the kernel doesn't clear, so about 135
  MB of anonymous memory with something in it. At 51 µs a MB (`floor/`) that is 7 ms of the 112 that no layout removes:
  it is the cost of whole-unit columns, and goes only with them.
- The parser pushes 98 MB of scratch and touches 59 in huge pages (25 in base pages), but the reader's scratch then
  takes the same pages, so the union is what counts.

Candidates this leaves, none measured as a change: the graph's columns at a tight capacity and packed (about 10 MB),
the small arenas in base pages (about 17 MB), the never-written columns (about 6 MB). Together under 2 ms.

## The body boundary with a recorded supplier (`boundary-*/`, `boundary-b1/`)

The scaffold on `claude/2850-boundary-scaffold` (not for merge; [its specification, as
amended](https://github.com/buster14a/buster/issues/2524#issuecomment-7079102369)): a function body's lowered function
supplied from outside the reader. `BUSTER_BOUNDARY_RECORD=DIRECTORY` makes an ordinary compile write each unit's
bodies' functions, references, string tokens, runtime calls and jump tables; `BUSTER_BOUNDARY_SUPPLY=DIRECTORY` makes a
compile of the same unit mask those bodies from the reader and take them at the lowering (`BUSTER_BOUNDARY_SELECT=N:K`
takes the eligible bodies whose ordinal modulo N is K). A body the recording can't carry is read as ever.

### B1, exactness (`boundary-b1/`, `scripts/b1.sh`; Develop builds on this session's machine)

For `sqlite3.c`, Lua's 34 units, `main.c` and musl's 1,336 units: the ordinary compile, the recording, and the compile
with every eligible body supplied and with each half of them.

| by default flags, at `bbe80f1a9` | bodies | supplied | their tokens | refused |
| --- | ---: | ---: | ---: | --- |
| `sqlite3.c` | 2,668 | 2,589 | 480,204 | 79 with a block-scope `static` or `extern` |
| Lua | 1,096 | 1,081 | 156,805 | 14 with `static` or `extern`, 1 with labels as values |
| `main.c` | 1,498 | 1,358 | 285,353 | 114 `static` or `extern`, 11 asm, 10 objects, 4 helpers, 1 initializer pool |
| musl | 2,756 | 2,161 | 249,484 | 510 asm, 68 `static` or `extern`, 17 with a diagnostic |

Every variant's objects and diagnostics are the ordinary compile's (`default-bbe80f1a9.txt`: 0 differences in 16
comparisons; `default-e38e1bfb0.txt` is the same before jump tables were supplied).

With `-Wall -Wextra` (`wall-bbe80f1a9.txt`) the objects are the ordinary compile's in every variant and the diagnostics
are not: a supplied body's uses of its parameters and of the unit's declarations are missing from the reader's unused
analysis, which then warns of them. B1's second half is open.

Two things the first runs found, both fixed in the scaffold: a command of several units reads each through a view
without its attested declarations' tokens, and a mask holds the view off, so the recording names tokens by their index
in the unit's own parse; and an asm statement that leaves no row in its function (an empty template's barrier) still
numbers the unit's asm helpers, so any asm statement refuses its body.

### B2, what the unit costs with its bodies supplied (`boundary-6bc8d41a5/`, `boundary-bbe80f1a9/`)

The 9700X, Release, CPU 2, one lane, under the lock, `scripts/boundary.sh`: seven rounds, each the ordinary compile
twice, the compile with every eligible body supplied twice, and with each half once; `--time-stages` medians, ms. All 43
objects of a run are one.

| frozen `sqlite3.c` | ordinary | supplied, without jump tables (`6bc8d41a5`) | supplied, with them (`bbe80f1a9`) |
| --- | ---: | ---: | ---: |
| bodies supplied (their tokens) | | 2,550 (431,126) | 2,589 (480,204) |
| share of the bodies' 568,438 tokens | | 76% | 84% |
| `check-input` | 41.49 | 28.11 | 26.54 |
| `check-expressions` | 10.50 | 2.95 | 2.06 |
| `check-program` | 18.83 | 6.58 | 5.24 |
| `lower` | 11.48 | 3.35 | 2.70 |
| `check-input` to `lower` | 85.76 | 43.07 | 38.58 |
| Tier 0 and emission | 8.77 | 8.91 | 8.92 |
| total | 110.93 | 69.50 | 64.92 |
| with half of them (2:0, 2:1) | | 93.41, 94.07 | 92.61, 91.22 |
| peak, MB | 238.4 | 230.7 | 230.8 |

(The ordinary column is `bbe80f1a9`'s; `6bc8d41a5`'s read 110.71.) Reading the recording, 6.4 MB, is 1.7 ms of the
supplied compile (its `setup` stage; `load-ticks` in the report beside the recording).

The gate was 56 ms, refuted at 62: **refuted, at 64.9 ms with 84% of the bodies' tokens supplied.** The three points
(0%, 76%, 84%) are a line of 0.544 ms a percent, which reaches 56.5 ms with every body supplied: what the host costs
when bodies cost nothing is about what the gate allowed in all. What is left is the reader's passes over every token
(21 ms with every body masked), the front (16), Tier 0 and emission (9), and the memory: the peak moves from 238 MB to
231.

### B3, nothing else moves (`pair2-sqlite-f1fcdf2a0-6bc8d41a5/`)

Main `f1fcdf2a0` against the scaffold with nothing recorded or supplied, seven ABBA rounds of the ordinary `-c
sqlite3.c`: 111.73 and 111.32 ms (paired -0.47, between -0.84 and +0.67), 1,215.957 M and 1,215.946 M user instructions,
one set of objects and diagnostics.
