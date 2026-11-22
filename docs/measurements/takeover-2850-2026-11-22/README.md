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

### What a fill costs: only its first touch (`memory/fresh-*.txt`, `scripts/memory-fresh.py`)

The sources fill 24 token-sized columns of 2.9 MB with zeros or `NONE` (69 MB in all, `memset` by its caller). A fill
pays the kernel only where it is the memory's first touch, so the experiment now reads, at each push of 512 KB or more,
how much of its range is not resident yet (`mincore`), and at the end of the push's stage how much of it is resident
and how much of that holds a byte that is neither 0 nor 0xff. `scripts/memory-fresh.py` reduces it; here, in base
pages (sizes, not times):

| | MB |
| --- | ---: |
| pushed, 345 pushes | 2,335.4 |
| of it not resident at the push | 1,802.8 |
| made resident by the end of its stage | 174.6 |
| of that, 4 KB pages with nothing but zeros or all-ones | 26.7 |

The 26.7 MB by caller: the reader's own columns 12.2 (in pushes that hold 51.4 MB of data), four columns `sqlite3.c`
never writes 6.8 (the intrinsics' 2.7, the deprecated uses' 2.7 and 0.7, the parser's tree's 0.7), the graph run's
2.4, the program's about 3.6, the rest under 0.5 each. The stages after `check-declarations` push 1,121 MB and make
14 MB resident: their fills land on pages an earlier stage touched, and cost their `memset` alone (1.9% of the
compile's cycles for all the fills, 2 ms).

So sparse columns are worth at most 26.7 MB of first touches, 1.4 ms at 51 µs a MB, if every one of some twenty
columns were made sparse at no cost to its readers; the four never-written ones alone are 0.35 ms. Under the 1.5 ms
at which the track was to be dropped: dropped. In huge pages the same count is 98.1 MB of 217.0
(`memory/fresh-huge-pages-reduced.txt`), the difference being the slack counted above, which is a layout's, not a
fill's.

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

**Closed at `666262658`** (`wall-666262658.txt`, `default-666262658.txt`): with `-Wall -Wextra` and by default flags, every
variant's objects and diagnostics are the ordinary compile's on the four corpora, 0 differences in 32 comparisons
(`sqlite3.c` with 2,565 bodies supplied under `-Wall -Wextra`, 24 refused for a warning in them; musl with 1,256, 922
refused), and on the three units that showed the holes (`boundary-b1/fixtures/`: `w1.c` the unit-end warning, `w3.c`
the unused analysis, `w6.c` a common warning). What closed it:

- the reader's unused analysis records each body's uses of the declarations outside it (its function's parameters,
  the unit's declarations) and whether each reads, and a supplying compile marks the declarations' chains from them;
- the driver's unit-end check runs for a unit with a mask (main's own `-flazy-system-headers` had the same hole:
  [buster14a/buster#3274](https://github.com/buster14a/buster/pull/3274)), and the body with the first use that an
  undefined internal function's warning notes is refused;
- a warning refuses the body its own token or a note's is in, not the body at its place among the diagnostics: a
  common warning is published right after its body's closing brace, and an unused parameter's at its body's end. A
  diagnostic placed between two bodies refuses both.

Before that, by default flags it held on these corpora and not in general (`boundary-b1/unit-end/`): `w1.c` has a `static`
function that is used and never defined, of which the ordinary compile warns at the unit's end
(`-Wundefined-internal`, on by default; `w1-plain.err`). The driver gives a unit with a mask no unit-end warnings, so
the compile with `w1.c`'s two bodies supplied is silent about it (`w1-sup.err`; the object is the same). None of the
four corpora has such a function.

Two things the first runs found, both fixed in the scaffold: a command of several units reads each through a view
without its attested declarations' tokens, and a mask holds the view off, so the recording names tokens by their index
in the unit's own parse; and an asm statement that leaves no row in its function (an empty template's barrier) still
numbers the unit's asm helpers, so any asm statement refuses its body.

Again at `37c096c36` (the scaffold with main `e20c6ff98` merged in, which has the unit-end warnings' fix of
buster#3274 that the scaffold carried as a cherry-pick): 0 differences in both flag modes on the four corpora
(`boundary-b1/37c096c36/`), with 2,588, 1,081, 1,357 and 2,158 bodies supplied.

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

## After the boundary: what the stream must cover, and what the host does when bodies are free

### The bodies' constructs (`boundary-census/`, `scripts/boundary-census.py`)

The recording lists each body's control kinds and expression ops (`sqlite3.bodies`: tokens, refusal, entries, name, the
two masks, nodes, controls). `sqlite3.c`'s 2,668 bodies (568,438 tokens, 290,681 nodes, 381,191 entries) use 9 of the 22
control kinds (END, EVALUATE, BRANCH_FALSE, RETURN, JUMP, INITIALIZE, BRANCH_TRUE, SWITCH, CASE) and 56 of the 69
expression ops. Adding constructs in the order that frees the most tokens (`sqlite3-census.txt`):

| constructs supported | bodies whole | their tokens |
| --- | ---: | ---: |
| every op that 2% of the bodies have, and END, EVALUATE, RETURN, INITIALIZE (46 constructs) | 24.8% | 4.6% |
| and BRANCH_FALSE | 47.3% | 13.3% |
| and JUMP | 86.3% | 53.1% |
| and the rest but SWITCH and CASE | 96.9% | 79.8% |
| all | 100% | 100% |

So nothing smaller than the expression language whole, with branches and jumps, takes a body: a slice by constructs
does not exist. What takes bodies takes nearly all of them or nearly none.

### References from the function (`scripts/boundary-references.py`)

Of `sqlite3.c`'s 2,589 supplied bodies, 2,587 have a reference list equal to the set of objects their lowered function
names; the other two name one object more (a runtime function the unit declares, which their code calls and their
source doesn't). So a supplier that makes the function has the references.

### Profiles: every body masked, the eligible bodies supplied, the ordinary compile (`profile-*/`)

`scripts/profile-env.sh` (the 9700X, CPU 2, one lane, eight runs each, `perf record` of cycles, by symbol):

| | ordinary (`bbe80f1a9`) | bodies supplied (`bbe80f1a9`) | every body masked (`0b150b71b` + the mask) |
| --- | ---: | ---: | ---: |
| cycles a run, M | 631.7 | 370.7 | 243.8 |
| kernel | 13.0% | 20.7% | 25.3% |
| `clear_page_erms` | 8.65% | 13.73% | 18.17% |
| `memset` | 1.89% | 3.00% | 4.40% |

With every body masked, a quarter of the compile is the kernel and the largest symbol by far is the page clearing
(44 M cycles, 7.7 ms): the reader still makes its columns for every token of the unit, masked or not (the peak is 216
to 222 MB against 238). The bodies' tokens removed from a preprocessed source left 14.2 ms between `check-input` and
`lower` ("With no function body" above, at `d541430bf`); masked in place in the frozen source they leave 25.5 (at
`0b150b71b`). The two are not one experiment, so the 11 ms between them is an estimate of what the masked tokens cost
by being there. A reader that reads a view without them (as it reads a view without a unit's attested declarations)
is not built, and what it saves is not measured.

In the ordinary compile no function is 5%: `check_input_expressions_coded_range` 4.66, `check_input_resolve_range`
4.24, `check_graph_run` 4.17, `check_lower_drain` 3.55, `tier0_generate` 2.72, `check_program_references` 2.42. A
lowering made lean for simple bodies could drop the controls' building (about 3 ms), most of the lowering's walk (8 to
10) and, with the references from the function, their walk (2.6): about 11 ms net of its own cost, with every body
covered. The rest of `check-program`'s 18.8 ms is the warnings' analyses, which are owed either way.

## The profile-guided build (`pgo-168c45a88/`, `scripts/job-pgo2.sh`)

`BUSTER_PGO=1 ./build.sh` did not build at main: a static build compiles its units with `-ffunction-sections` since
the start's code order (buster#2885, `1f86f3339`), the training passes the units' flags to the instrumented compiler,
and the compiler refuses the option at the first training compile. `168c45a88` (branch `claude/2850-pgo-training`, main
`d5fbf14ee` and that one change to `CMakeLists.txt`) trains without it. With it the build finishes on the 9700X
(`pgo-168c45a88/build.log`: 129 units, 219.7 s), with the default training: the compiler's own units, each
preprocessed, checked and compiled.

The profile-guided compiler against the ordinary Release build of the same sources (`scripts/pair2.sh`, seven rounds,
CPU 2, one lane; paired medians). Every run's objects and diagnostics are one set, the ordinary build's:

| | ordinary | profile-guided | paired | range | |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c`, wall ms | 111.730 | 108.348 | -3.293 | -4.123 to -3.158 | -2.9% |
| `sqlite3.c`, user cycles M | 536.672 | 518.096 | -18.372 | -23.284 to -16.550 | -3.4% |
| `sqlite3.c`, user instructions M | 1,215.957 | 1,150.922 | -65.035 | | -5.3% |
| `main.c`, wall ms | 600.145 | 563.055 | -36.897 | -38.598 to -34.985 | -6.1% |
| `main.c`, user cycles M | 3,015.283 | 2,804.012 | -210.265 | -216.334 to -203.831 | -7.0% |
| Lua (34 units), wall ms | 64.310 | 60.019 | -4.262 | -4.385 to -4.191 | -6.6% |
| Lua, user cycles M | 292.804 | 270.327 | -22.578 | -22.727 to -22.311 | -7.7% |
| musl (1,336 units), wall ms | 668.810 | 604.227 | -64.973 | -65.573 to -62.542 | -9.7% |
| musl, user cycles M | 2,717.894 | 2,387.992 | -328.575 | -331.690 to -323.230 | -12.1% |

The kernel's cycles do not move (within a round's noise on three of the four; musl's fall 2.9%). So the build is worth
3.3 ms of the frozen compile and 6% to 10% of the other three, and no pull request's CI builds it: nothing would have
said it broke. Every other pair in this record is of ordinary Release builds, and stays so.

### A profile fitted to the benchmark (`pgo-168c45a88/fitted/`, `scripts/job-pgo3.sh`, `scripts/train-sqlite.sh`)

The same sources with `BUSTER_PGO_TRAIN` naming a script that compiles the frozen `sqlite3.c` once, as the timed
compile does, in place of the default training. This profile is fitted to the benchmark: it is the bound of what a
profile gives the timed compile, and what it costs the other three, not a lever. Seven rounds each, paired medians;
every run's objects and diagnostics are the ordinary build's:

| wall ms | ordinary | fitted profile | paired | | default training, from above |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 111.312 | 106.174 | -5.337 | -4.8% | -3.293, -2.9% |
| `main.c` | 601.084 | 584.532 | -16.005 | -2.7% | -36.897, -6.1% |
| Lua | 64.155 | 59.959 | -4.357 | -6.8% | -4.262, -6.6% |
| musl | 668.769 | 615.514 | -53.895 | -8.1% | -64.973, -9.7% |

Fitted against default training on `sqlite3.c`, paired: -2.056 ms (-3.054 to -1.664, seven of seven), 44.988 M fewer
instructions. So a profile is worth 3.3 ms of the frozen compile as the build trains it today and 5.3 at most; the
fitted one gives up 21 ms of `main.c` and 11 of musl for its 2. One round of the first pair read +8.9 ms (its range's
upper end); the cycles' range has no such reading.

## What the bodies cost each stage (`profile-bodies.txt`, `scripts/profile-bodies.py`)

The ordinary compile's profile (`profile-whole-bbe80f1a9/`) less the one with every body masked
(`profile-masked-0b150b71b/`), by symbol, summed by stage; cycles a token of the frozen `sqlite3.c` and ms at 5.49
GHz. The two profiles are of two trees, so each line is an estimate; their sum is the two runs' difference.

| | ordinary | every body masked | the bodies | ms |
| --- | ---: | ---: | ---: | ---: |
| the program, the warnings, the data | 168.8 | 22.7 | 146.2 | 19.1 |
| the lowering | 86.8 | 2.4 | 84.3 | 11.0 |
| the reader: the expressions' walk | 89.3 | 15.1 | 74.2 | 9.7 |
| the graph run | 64.6 | 2.5 | 62.1 | 8.1 |
| Tier 0 and the emission | 48.3 | 0.1 | 48.2 | 6.3 |
| the kernel, libc and the rest | 147.9 | 104.4 | 43.6 | 5.7 |
| the reader: the names' resolution | 52.5 | 10.9 | 41.6 | 5.4 |
| the reader: declarations, types and the rest | 101.8 | 70.9 | 30.9 | 4.0 |
| the reader: literals and constants | 14.8 | 5.0 | 9.8 | 1.3 |
| the preprocessor and the parser | 107.3 | 106.6 | 0.7 | 0.1 |
| all | 882.1 | 340.5 | 541.6 | 70.6 |

- A stream that keeps the reader's resolution, declarations and literals for a body it takes keeps 10.7 ms of the
  bodies' 70.6 and what they make: the uses the unused analysis reads, a block's static objects, the strings in
  their order, the unit's end's warnings. One that reads a body from its tokens alone owes all four.
- What a taken body can leave is the walk, the graph run, the program and the lowering: 47.9 ms, with Tier 0 and the
  emission owed either way.
- With every body masked the unit is still 340 cycles a token, 44 ms: the preprocessor and the parser 14, the
  reader's file scope 11, the kernel and the rest 14.

## The boundary with the reader's resolution kept (`boundary-resolve/`, scaffold `cc5d1f8c4`)

B1 and B2 above masked a supplied body's tokens whole: nothing of it was resolved, and the scaffold replayed its
strings and its uses from the recording. A stream that keeps the reader's resolution for a body it takes runs in another
state: the body's names are bound and its locals declared and typed, and nothing after the resolution reads it. That
state had never run. `BUSTER_BOUNDARY_RESOLVE` (the scaffold, `cc5d1f8c4`, not for merge) makes it with the same
recordings:

- the mask is withheld from the reader until `check_input_resolve_range` has read the unit, then given to it, so every
  pass before the resolution and the resolution itself read a supplied body as any body, and the expressions' walk and
  every stage after leave it out;
- the scaffold's replays of a supplied body's strings and of its uses are off: the resolution makes both
  (`check_input_resolve_range` calls `check_input_string` at a string's token; the uses are its binding events);
- the initializers' stage skips a supplied body's declarations (`check_init_declarations`): they are declared, and
  their initializers have no node;
- a recording made in this mode refuses a body with a stack allocation or a variably modified type's bound (a
  declaration's or a type name's), whose bound is the walk's node: 10 of musl's bodies, none of the other three's.

**Exact** (`scripts/b1m.sh`, Develop builds on this session's machine; `boundary-resolve/b1/`): 0 differences in
objects, diagnostics and status on `sqlite3.c`, Lua, `main.c` and musl, with every eligible body supplied and with each
half, with the default warnings and with `-Wall -Wextra` (32 comparisons; 2,588, 1,081, 1,357 and 2,149 bodies
supplied by default). The masked supply on the same build is still exact. What it took to get there, each a run kept
beside it: with the mask seen by the passes before the resolution, the intrinsics' scan and the variable-length
arrays' pass left the supplied bodies out and `main.c` and musl failed (first attempt); a type name's variably
modified bound in a `sizeof` failed one unit of musl (third).

**What it costs** (`boundary-resolve/9700x/`, `scripts/boundary4.sh`: the 9700X, CPU 2, one lane, Release, under the
lock; 14 `--time-stages` runs each in turn, medians; `sqlite3.c` with its 2,588 eligible bodies supplied, 480,192 of
its 568,438 body tokens; all 42 objects one):

| ms | ordinary | supplied, masked whole | supplied, the resolution kept |
| --- | ---: | ---: | ---: |
| `check-input` | 40.994 | 26.595 | 34.358 |
| `check-expressions` | 10.624 | 2.061 | 2.054 |
| `check-declarations` | 2.139 | 0.808 | 0.965 |
| `check-program` | 18.845 | 5.408 | 5.401 |
| `lower` | 11.352 | 2.696 | 3.032 |
| the middle | 85.474 | 38.822 | 47.106 |
| **total** | **110.894** | **65.406** | **73.585** |
| least and most | 110.453 to 113.701 | 65.059 to 66.597 | 73.001 to 74.272 |
| peak, MB | 238.5 | 230.9 | 236.3 |

The resolution of the supplied bodies is 8.2 ms (7.8 of them in `check-input`), against the 10.7 the profiles'
difference gave all the bodies' ("What the bodies cost each stage"). A body taken with its resolution kept leaves the
compile 37.3 ms at this coverage: 77.7 ns a supplied body token, 295 TSC ticks, 427 cycles. That is what a machine
has to stay under, a token of the bodies it takes, with what it sweeps and then refuses counted in.

So what a kept resolution gives a taken body is checked, not read off the code: its strings in the unit's order, its
uses, and the unit's end's warnings, with no replay; a block's static object is still refused (its initializer's data
are the walk's nodes).

## What the machine takes whole at reader time (`reader-verdicts/`)

`measure-node-machine --shadow --front --front-types --front-tests --front-sweeps` on `sqlite3.c`, with two dumps
(the scaffold's, `BUSTER_EXPERIMENT_BODY_VERDICTS` and `BUSTER_EXPERIMENT_ROOT_VERDICTS`): for each root the lowering
popped, whether the reference machine ran on it at reader time (the front made its expression whole), T took it, the
census's tests left it silent, and C and X took it. `scripts/reader-verdicts.py` groups them by body against the
recording's list; `scripts/reader-blockers.py` sorts what stops a root.

Of 52,368 roots, 2,092 are not taken at reader time (4.0%), and they are in the large bodies:

| a body, by the first step that stops one of its roots | bodies | body tokens | |
| --- | ---: | ---: | ---: |
| every root taken | 1,855 | 202,636 | 35.6% |
| a root the front made no expression of | 519 | 279,730 | 49.2% |
| a root the tests refuse | 131 | 37,014 | 6.5% |
| a root C or X refuses | 107 | 28,144 | 5.0% |
| a root T refuses | 56 | 20,914 | 3.7% |

Of the 1,855, the boundary takes 1,825 (34.8% of the body tokens), and 1,793 have no `switch`, label, cleanup or
stack allocation (32.3%).

What stops a root, and the order that frees the most body tokens soonest (a class by the source line where the
front left the expression):

| | roots | bodies | whole so far |
| --- | ---: | ---: | ---: |
| nothing more | | | 35.6% |
| `sizeof` or `_Alignof`, which the front leaves | 597 | 379 | 45.6% |
| a bit-field (the tests) | 495 | 187 | 53.3% |
| an operator with no template of C's (a pointer difference, a conditional, a division or remainder, a comma) | 279 | 192 | 64.7% |
| a callee T refuses (a library call computed in place, returns_twice, no prototype) | 133 | 90 | 70.0% |
| no expression of the front's, another reason, a statement's | 152 | 92 | 75.2% |
| the same, a condition's | 90 | 62 | 80.7% |
| a brace initializer's element | 82 | 19 | 88.5% |
| an aggregate's value (the tests) | 66 | 33 | 94.8% |
| a character or string with an escape, an initializer's, a builtin, a return's, a declaration's flag | 198 | | 100% |

So a first version that takes a body whole, with the machine as it stands, takes a third of `sqlite3.c`'s body
tokens, and would sweep the other two thirds for nothing unless a body is refused before its sweeps. Six classes
take it to 80%.

## The machine with no node of the walk's (`machine-alone/`, buster branch `claude/2850-machine-alone`)

The stream's first piece as [specified](https://github.com/buster14a/buster/issues/2850#issuecomment-7081094449):
`measure-node-machine --shadow --front-alone`, at the branch's `8f8fe98cd`. For each function body, before the coded
walk acts at its first token, a front of the piece's own makes the body's records from its postorder positions, each
record is written to a graph of the piece's own, and the reference machine (T, the census's tests, C and X) runs on
each root with that graph for its own, the reader's graph without its columns of nodes while it does. After the
pipeline each root's results are compared with the ones the machine made of the walk's nodes.

**V1, exact** (`machine-alone/develop/head-8f8fe98cd/`, Develop builds on this session's machine, `scripts/alone.sh`,
with the default warnings, with `-g` and with `-Wall -Wextra`; and the 9700X's 17 Release runs,
`machine-alone/9700x-head/alone-8f8fe98cd/`, every one's status 0):

| | bodies read before the walk | roots compared | differ | roots only one of the two ran on |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 2,674 | 51,306 | 0 | 0 |
| Lua, 34 units | 1,096 | 10,900 | 0 | 0 |
| the compiler's own source | 8,685 | 53,916 | 0 | 0 |
| musl, 1,336 units | 18,584 | 43,196 | 0 | 0 |

A root's records' count, T's refusal, the records' digest, the tests' bits and the root's kind, C's and X's refusal,
the root's target and object, the tape and the side's digest are the same in each of the three flag sets, and nothing
faults with the reader's node columns taken away. On the way: a node's columns that the walk's flush fills from its
token alone had to be filled the same way (musl's floating-point pragmas: 243 roots T refused for their context on the
walk's nodes and took on the others); and the records' digest held a fault's node as the graph's number, which is now
its record of the expression's (3 roots). Two departures from the specification: a condition's root is not made
early (the piece's graph keeps a body's records, so the operand's are there when the root comes); and the poison is
the reader's own graph's columns set to null for the machine's run.

**V2, no diagnostic missed: on the corpora.** Two counts, each 0 in every run above: the roots taken before the walk
that had an event of the walk's at one of their tokens after it; and the roots taken with, among their expression's
tokens, one the walk's class actions left to its visit, which the walk marks (`expression_declined`) and the piece
reads after the walk's last chunk: 0 of 141,223 taken roots with the default warnings and with `-g`, 0 of 130,008 with
`-Wall -Wextra`. A reading of the code says why: of 114 call sites of the reader's three warning functions, 32 can
run while the walk acts at a token, through the literal's action (a literal the front leaves), the walk's own visit
(tokens the front leaves), the string's action (strings the resolution has decoded) and the call's (which reports
nothing). The fixture has one of each of the first three.

**V3, by body.** Each body's verdict is kept as it stands before the walk acts at the body. On `sqlite3.c`'s 2,668
lowered bodies: every root taken in 1,856 (35.62% of the body tokens), a root the front lost in 514 (48.99%), T's
refusal in 52, the tests' in 130, C's or X's in 116; the front lost its waiting values in none. Against the machine on
the walk's nodes (every root the lowering popped taken there): 1,852 whole for both, 4 for this piece alone (a braced
initializer's elements are roots of the lowering's and none of the front's), 1 for the other alone and 2 more with a
block's static declaration (a root the front lost or refused that the lowering never pops). Lua: 630 whole (29.71%),
the same 630 for both. musl: 1,871 (31.76%), 1,329 for both, 542 for it alone, 7 and 1 for the other. The compiler's
own source: 222 (3.62%). With `-Wall -Wextra`: 23.62%, 25.29%, 24.21% and 2.80%.

**V4, its cost in place: over its gate, under what refutes it** (`machine-alone/9700x-head/alone-8f8fe98cd/`,
`scripts/alone-9700x.sh`, `scripts/job-alone4.sh`; the 9700X, CPU 2, Release, under the lock; medians of 7 runs,
musl's of 3; TSC ticks at 3,792.9 MHz):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| postorder positions of the bodies | 568,641 | 203,029 | 1,424,367 |
| its reading, M ticks (ms) | 53.0 (13.97) | 15.9 (4.19) | 97.3 (25.65) |
| … the compaction and the entries | 10.2 (2.68) | 2.4 (0.64) | 18.5 (4.87) |
| … the front | 21.3 (5.61) | 6.2 (1.64) | 50.8 (13.38) |
| … its graph's writing | 18.0 (4.76) | 6.2 (1.64) | 19.5 (5.15) |
| the machine's first run on the roots: T, the tests, C and X | 100.8 (26.59) | 28.0 (7.39) | 125.9 (33.20) |
| **ticks a position** | **270.5** (269.3 to 271.5) | **216.4** (215.9 to 218.0) | **156.7** (155.3 to 157.6) |
| of them the compaction, the entries and the front | 55.3 | 42.6 | 48.6 |

The gate was 180 and the refutation 295. On `sqlite3.c` the piece is 40.6 ms a unit whose every body is swept: 14.0
to read the bodies (4.8 of them a copy of the front's records into a graph, which a T that read the records would
not make), and 26.6 for the reference's sweeps with the census's tests, where the parts read separately had 16 to 22.
A taken body token is worth 295 ticks, so this machine as it stands gains 25 ticks a token it takes and loses 270 a
token it sweeps and refuses: with every token of `sqlite3.c`'s bodies taken, 3.7 ms. The specification's forecast
for the compile that takes bodies (5.6 to 8.5 ms at 53% taken, a gate of 4) was built on 141 to 178 ticks and does
not stand. What its parts were measured at in their own pieces says where it goes: the tests in the machine's own
form are half the census's, and on the window a fifth; the window's kernel, C and X are 39 ticks a record, where the
reference's four sweeps here are 345 a record together (the run is not split by sweep).

**V5, nothing else moves** (`machine-alone/9700x-head/pair2-*-0a408b6a3-8f8fe98cd/`: main `0a408b6a3` against the
piece's head, the ordinary compile, seven paired rounds a workload, the objects and diagnostics one set):

| | main | the piece's head | paired | range | user instructions M |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c`, wall ms | 111.771 | 111.635 | -0.165 | -0.508 to +0.476 | 1,215.937 and 1,215.364 |
| `main.c` | 602.330 | 600.270 | -1.395 | -3.135 to +3.640 | 8,929.771 and 8,927.312 |
| Lua | 64.206 | 64.218 | -0.028 | -0.316 to +0.149 | 724.553 and 724.335 |
| musl | 663.786 | 663.166 | -0.138 | -1.909 to +17.103 | 6,635.856 and 6,634.508 |

**Its fixture's faults** (`machine-alone/faults/`, `scripts/alone-faults.py`): fifteen single changes to the piece
and to the two functions it leans on, each built and run against the fixture, at `eda9d7b51` (whose fixture had 17 of
the head's 18 bodies) and again at the pull request's head, `61cd6d100`: each fails it. At the head fourteen fail it
by its counts or by a root that differs, and one makes the run fault: with the tests reading the reader's graph, its
node columns are null while the machine runs.

### The machine's run by sweep (`machine-alone/9700x-split/`, branch `claude/2850-alone-split` at `2aeb81306`)

`measure-node-machine --shadow --front-alone-split`: the same run with a clock's read before each sweep and after the
last (five a root; the run's whole reads the same with them, 100.8 M ticks on `sqlite3.c`). The 9700X, CPU 2, Release,
under the lock; medians of 7 runs, musl's of 3; ms at 3,792.9 MHz, and ticks a body's postorder position:

| | `sqlite3.c` | | Lua | | musl | |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| T | 6.20 | 41.3 | 2.04 | 38.1 | 9.79 | 26.1 |
| the census's tests | 13.37 | 89.2 | 3.65 | 68.1 | 15.44 | 41.1 |
| C | 2.90 | 19.3 | 0.78 | 14.5 | 3.69 | 9.8 |
| X | 2.44 | 16.3 | 0.59 | 11.0 | 2.90 | 7.7 |
| the rest of the run (its loop, the roots' ranges, the settling) | 1.67 | 11.2 | 0.40 | 7.5 | 2.04 | 5.4 |
| the machine's first run | 26.56 | 177.3 | 7.48 | 139.9 | 34.01 | 90.6 |

The tests are half the machine's run on each corpus, and a third of the piece whole (89 of `sqlite3.c`'s 270 ticks a
position; the front is 37, the graph's writing 32, T 41). So the first cheaper form to bring in is the tests': in the
machine's own form they read half the census's in their own piece, and on the window a fifth.

The same branch (`f5073d2dd`) counts what the walk's marks are read against: `sqlite3.c`'s bodies hold 3,642 tokens the
walk's class actions left to its visit, and none of the 50,323 roots the machine took has one among its expression's
tokens (the fixture's bodies hold 7, which it asserts).

### The piece's ticks by a body's verdict, and what a scan of the tokens would refuse (`machine-alone/9700x-verdicts/`, branch at `b3bb0de89`)

The same command, with each lowered body's ticks kept beside its verdict: its reading's, its machine's first run's,
and those spent by the end of the chunk in which it is first stopped; and whether a scan of its tokens alone finds a
`sizeof` or `_Alignof` (by the token's kind) or a token of the walk's own visit (by its class's byte): what could
refuse the body before its compaction. The 9700X, CPU 2, Release, under the lock; medians of 7 runs, musl's of 3; ms.

| `sqlite3.c`, 568,438 body tokens | bodies | their tokens | reading | the machine's first run | by the chunk that stops them | the scan refuses: bodies | tokens |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| every root taken | 1,856 | 35.6% | 4.65 | 9.89 | | 33 | 14,422 |
| a root the front lost | 514 | 49.0% | 5.39 | 11.98 | 11.30 | 499 | 273,311 |
| T refuses a root | 52 | 2.7% | 0.33 | 0.83 | 1.10 | 3 | 1,483 |
| the tests refuse one | 130 | 6.9% | 0.87 | 1.93 | 2.54 | 5 | 2,105 |
| C or X refuses one | 116 | 5.9% | 0.69 | 1.60 | 2.13 | 4 | 1,023 |

Lua: 29.7% whole (50 of its 630 bodies scanned out), 49.5% with a root lost (260 of 279 bodies by the scan, 96.9% of
their tokens), 20.8% refused after their sweeps (2.47 ms of the piece's 11.3). musl: 31.8%, 54.2% (548 of 584, 97.3% of
their tokens) and 14.0% (4.26 ms).

- **A scan of the tokens decides nearly every root-lost body before any work on it:** 98.1% of their tokens on
  `sqlite3.c`. It costs the whole bodies it also finds one in: 33 of 1,856, 7.1% of their tokens (a `sizeof` under a
  declarator or a label loses no root).
- **The bodies refused after their sweeps are 15.4% of `sqlite3.c`'s body tokens and 6.25 ms of the 38.2 its lowered bodies take**
  (5.77 if a body stopped at the chunk that refuses it). They are the loss the forecasts lacked.
- **Stopping at the first refusal saves little:** 11.30 of 17.37 ms for the root-lost bodies, and 5.77 of 6.25 for
  the rest: a refused root is late in its body as often as early.

### Every body read before the walk's first chunk (`machine-alone/develop/first-18fd6b349/`, branch at `18fd6b349`)

The comparison above reads a body before the walk acts at it, with the bodies before it walked already. A compile
that takes bodies in a row walks none of them. `measure-node-machine --shadow --front-alone-first` reads every body of
the unit before the walk's first chunk (`scripts/alone-opt.sh` with `ALONE_OPTION=--front-alone-first`; Develop build
on this session's machine, the default warnings): the same 51,306, 10,900, 53,916 and 43,196 roots on `sqlite3.c`,
Lua, the compiler's own source and musl, no difference, none run by one of the two alone, none taken before an event
of the walk's or with a token its actions left. So nothing the machine reads of a body is left there by the walk of
another.

### A scan of a body's tokens for a root the front would lose (`machine-alone/9700x-scan/`, branch at `90c42e997`)

The count above was of a blunt scan: any `sizeof` or visit of the walk's own in the body. The branch's scan
(`node_alone_scan`) follows the token's value: a token the front leaves (a `sizeof` or `_Alignof` by its kind, a token
of the walk's own visit by its class's byte, a character constant with an escape or of several characters by its
spelling) loses a root where its value reaches a root's token (a statement's terminator, a condition, a return, an
initialization) through the parents that take values; under a declarator or a label it reaches none. It reads the
parser's kinds and parents and the reader's visit bytes, before any of the body is compacted. In the shadow it refuses
nothing: every body is read as before, and the report has, by a body's verdict, the bodies the scan finds a lost root
in, with the scan's own ticks and the tokens it read.

`scripts/job-scan1.sh` (`alone-split.sh` at the branch's `90c42e997`; the 9700X, CPU 2, Release, under the lock; 7 runs,
musl's 3; `scripts/scan-reduce.py`, `machine-alone/9700x-scan/reduced.txt`; every run's status 0 and no root differs):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| bodies whose root the front lost (lowered) | 514 | 279 | 584 |
| … of them the scan finds one in | 513 | 279 | 584 |
| … their tokens found | 278,079 of 278,483 | 100,404 of 100,404 | 163,234 of 163,234 |
| whole bodies the scan finds one in | 0 of 1,856 | 0 of 630 | 0 of 1,871 |
| bodies refused after their sweeps the scan finds one in | 0 of 298 | 0 of 187 | 1 of 301 |
| tokens the scan read (it stops at the first it finds) | 374,620 | 121,860 | 619,925 |
| its ticks, M (ms) | 1.45 (0.383) | 0.55 (0.146) | 8.70 (2.294) |
| ticks a token read; a body's postorder position | 3.88; 2.56 | 4.54; 2.73 | 14.03; 6.11 |

- **The scan decides the root-lost bodies before any work, and costs no whole body:** on `sqlite3.c` the 17.4 ms the
  piece spends reading and sweeping those bodies (5.35 and 12.05 here) against 0.38 ms for the scan over every body.
  The compiler's own source, on this session's machine (`machine-alone/develop/scan-90c42e997/`): 748 of 748, and none
  of its 222 whole bodies.
- The one `sqlite3.c` body it leaves is `sqlite3OpcodeName` (`sqlite3.c:38923`, 404 tokens), a block's static table of
  strings: the front's report counts a root lost there, and the scan finds no token of its three kinds whose value
  reaches a root's. Why the front loses one there was not read.
- musl's ticks a token are four times the others': its 18,584 bodies are 77 tokens each on average (the headers'
  inline functions among them), and each scan is timed by two reads of the clock.
- The specification's gate for a refusal before the sweeps was 20 ticks a body token on the refused bodies.
- **Its fixture's faults** (`machine-alone/faults/scan-faults-0dd1dfafa.txt`, `scripts/scan-faults.sh`): three single
  changes to the scan, each built and run against the fixture, which asserts the three bodies it finds a lost root in
  (a `sizeof`, an `_Alignof`, a character constant of several characters) and none in another verdict's. With the
  kinds and classes unread it finds 1 of 3; with every token left taken for a lost root it finds one in a whole body
  (the escape under a label); with several characters unread, 2 of 3. Each fails it.

**Where the shadow's run goes, by symbol** (`machine-alone/9700x-scan/profile-walk-90c42e997/`, `profile-alone-90c42e997/`;
`scripts/profile-alone.sh`: four `perf record` runs each of `measure-node-machine --shadow` on `sqlite3.c`, with
`--front --front-types --front-tests --front-sweeps` and with `--front-alone`): 2,068 M and 2,485 M cycles a run, most
of either the shadow's own passes after the pipeline. The run with the piece has 417 M more, by symbol: the tests' node
function (`node_census_node`) 66 M, T (`node_machine_type_in_context` and `node_machine_rule`) 48 M, the records'
digest 28 M, the walk's function with the piece's compaction inlined 26 M, the front 25 M, the reader-time driver 26 M,
C 25 M, `node_alone_bodies` (the graph's writing) 28 M, the kernel's page clearing 25 M, X 11 M. These differences are
not the piece's timed run: they hold the driver's second pass over every root, which keeps the results (the digest is
made there), and what the comparison after the pipeline adds; the timed run is 154 M ticks, about 223 M cycles. What
they do show is that 25 M cycles of the run with the piece are first touches of its own memory (its graph, its front,
its tests' state), some of which may fall inside the timed writing: not separated here.

### Is the reference's cost its place's? Every body first, and its memory touched first (`machine-alone/9700x-first/`, `9700x-touch/`)

Two readings of whether the piece's 271 ticks a position are the reference's own or come from where and when it runs.

**Every body read before the walk's first chunk** (`scripts/alone-first.sh`, the branch's `90c42e997`: `--front-alone-first`
and `--front-alone` in turn, 7 rounds, the 9700X, CPU 2, Release, under the lock; `scripts/first-reduce.py`,
`machine-alone/9700x-first/reduced.txt`):

| | `sqlite3.c`, each body before the walk acts at it | every body first | Lua | every body first |
| --- | ---: | ---: | ---: | ---: |
| its reading, ms | 14.23 | 14.85 | 4.34 | 4.34 |
| the machine's first run, ms | 26.47 | 26.17 | 7.42 | 7.47 |
| ticks a position | 271.5 | 273.6 | 219.7 | 220.6 |
| ticks a token of the bodies a compile would sweep after the scan (every verdict but a root the front lost) | 271.2 | 274.3 | 264.1 | 266.7 |

No: with the bodies read in a row and no walk between them the machine costs the same. (On this session's machine, a
Develop build, the same pair read a third less for the reading with every body first; the Release build on the 9700X
does not.)

**Its own memory touched before any timed run** (`scripts/experiment-alone-touch.patch` on the branch's `0dd1dfafa`, not
for merge: with `BUSTER_EXPERIMENT_ALONE_TOUCH` set, every 4 KB page of what the piece takes from the reader's two
arenas at its start is read and written before the first body; `scripts/job-touch1.sh`, the same binary with and
without in turn, 7 rounds; `scripts/touch-reduce.py`, `machine-alone/9700x-touch/reduced.txt`):

| `sqlite3.c`, ms | as it is | its memory touched first |
| --- | ---: | ---: |
| the compaction and the entries | 2.66 | 2.68 |
| the front | 5.63 | 5.64 |
| its graph's writing | 4.73 | 3.36 |
| T | 6.15 | 6.17 |
| the census's tests | 13.43 | 13.13 |
| C; X | 2.92; 2.40 | 2.95; 2.40 |
| ticks a position | 272.5 | 261.9 |

The piece reserves 162 MB of the scratch arena and 65 of the reader's at its start (a second front, a graph and a
store of results sized for the unit's nodes), and their first touches are 1.4 ms of the graph's writing and 0.3 of the
tests: 10.6 ticks a position of the 272.5. So the reference's own cost on `sqlite3.c` is about 262 ticks a position
swept, against the 295 a taken token is worth. It is a ceiling for a machine that kept a body's records in one small
place, not much of one.

## Whether the window's forms take bodies alone (`window-bodies/`)

`scripts/experiment-window-bodies.patch` on the branch's `0dd1dfafa` (not for merge; the earlier `experiment.patch`
with two lines more): `measure-node-machine --shadow --front-types --front-sweeps --front-tests --window-rows
--passes 0` on `sqlite3.c` prints each root the lowering popped with its body (`experiment-pop`) and each expression
whose tape X makes whole on the window with what the tests said of it and whether the kernel made every wanted record
(`experiment-span`). `scripts/window-bodies.py` groups them by body (`window-bodies/sqlite-reduced.txt`; a Develop build
on this session's machine: counts, not times). Of 2,668 lowered bodies and 568,438 body tokens:

| every root the lowering popped of the body is | bodies | their tokens |
| --- | ---: | ---: |
| taken by the reference at reader time (this run's front is the lean one with the window; the whole front's reads 35.6%) | 1,831 | 32.03% |
| whole on the window (its tape X's, equal to the reference's) | 1,758 | 29.20% |
| … with nothing listed for the tests on T's records | 675 | 4.73% |
| … and every wanted record the kernel's own | 604 | 3.99% |
| … and no call, label of its own or temporary in a tape | 143 | 0.69% |

Of the bodies the reference takes whole and the window's forms do not take alone, nearly all have a listed
expression (936 bodies with that alone, 19.2% of the body tokens; 147 with a record left to T too, 5.3%): an
initialization's root is always listed, and so are an assignment of a constant, a constant subscript and the others
the tests still read T's records for. So the window's forms as they stand decide 4% of `sqlite3.c`'s body tokens
without the reference: a body-level machine made of them needs T behind it for the listed expressions (8,877 of the
49,839 expressions with a whole tape, 19.6% of their records), or those tests moved to the window first.

## What a body-level proof of silence leaves (`silence-bodies/`)

The machine's verdicts are of expressions. A body it takes whole runs none of the stages after the reader, so every
diagnostic those stages decide of a body and not of one expression has to be proved absent, or the body refused. An
inventory of them from the sources (this session's reading, by an agent, each row with its place in the code; not a
measurement, and not yet checked row by row). Enabled by default, and lost for a body no stage after the reader sees:

- the return flow's two: "non-void function does not return a value", and a `noreturn` function that falls off its end
  (`check_program_return_flow`, over the controls);
- a `switch`'s: an enumeration's values not handled, a case value outside it, an empty case range, and the errors of a
  duplicate case, a second default, a condition that is no integer and a case that is no constant;
- the walk's own, at a statement: a `return;` in a function with a result (an error by default), a `_Static_assert` in
  a body, a case label's constant's warnings, a statement's shape it does not support;
- a call's, read from the selected program: a callee that needs a target feature the caller lacks (an error), an AVX
  vector argument's ABI (`-Wpsabi`), a call from an interrupt routine (`-Wexcessive-regsave`);
- an `asm` statement's operands' and constraints' errors; a `musttail` return's errors; an initializer's (excess
  elements, a string too long, braces around a scalar, a static local's that is no constant).

Not lost: the unused objects', parameters' and labels' warnings and an empty body's and a dangling else's, which come
from the resolution's events and the token passes a taken body keeps; and the uninitialized read's and the
unused-but-set parameter's are `-Wall`'s and `-Wextra`'s, where they need their own proofs.

The count below is of the first row's first half alone, by the most conservative test of it. It refuses no `noreturn`
function (a void one that falls off passes it), no call of the fourth row and none of the others: each needs its own
refusal, read at its place in the code and held by a body that stays loud, before a compile takes a body. So the
figure is an upper bound of what that test leaves, and what the other rows refuse on `sqlite3.c` is not counted.

`scripts/experiment-window-bodies.patch` prints, for each lowered body, the tokens' facts the most conservative proof
of the return flow's silence reads (`experiment-silence`): the result is void, or the function is `main`, or the
body's last statement at its own level is a return with a value. `measure-node-machine --shadow --front-alone
--passes 0` on `sqlite3.c`, a Develop build on this session's machine (counts); `scripts/silence-bodies.py`,
`silence-bodies/sqlite-reduced.txt`:

| of `sqlite3.c`'s 568,438 body tokens | bodies | their tokens |
| --- | ---: | ---: |
| whole before the walk | 1,856 | 35.62% |
| … whose result is void | 664 | 12.61% |
| … void, or `main`, or ending in a return with a value | 1,303 | 22.28% |
| … none of the three: the return flow's proof is owed | 553 | 13.34% |
| whole, the test holds, with no `switch` and no `goto` | 1,267 | 18.64% |

So the boundary's 77.7 ns a taken token, read with a recorder that refused a body with a diagnostic by hindsight, is
owed a proof that the token test gives for 63% of the whole bodies' tokens. The rest end in an `if` whose arms return,
a loop or a block: the return flow itself, run on the controls a statement layer has to make anyway, decides them, and
needs each condition's truth where it folds and each call's callee's contract, which the window's summary facts have
in the shadow and nothing has before the walk.

## A body's entries from its controls and its roots' tapes (`bodies-entries/`, buster branch `claude/2850-bodies-entries`)

The statements' first piece as [specified](https://github.com/buster14a/buster/issues/2850#issuecomment-7083062068):
`measure-node-machine --shadow --bodies`, at the branch's `eec7ca784`. After the pipeline, each lowered body the piece
attempts is made again from the program's controls and the tapes the machine makes of the body's roots (a temporary's
local absolute, a branch's target an entry, a call's row the body's, each control's own entries after its root's, the
implicit return last), and compared with the lowered function's, entry for entry: kind, class and value.

**Exact** (`bodies-entries/develop-eec7ca784/`, Develop builds on this session's machine, `scripts/bodies.sh` and
`scripts/main-only.sh`: the default warnings, `-g`, and `-Wall -Wextra`; every run's status 0):

| | `sqlite3.c` | Lua, 34 units | the compiler's own source | musl, 1,336 units |
| --- | ---: | ---: | ---: | ---: |
| lowered bodies; their tokens | 2,668; 568,438 | 1,096; 203,029 | 1,498; 399,421 | 2,756; 300,990 |
| every popped root the machine's: bodies; of the tokens | 2,134; 48.58% | 728; 38.35% | 281; 4.82% | 1,499; 33.15% |
| attempted: bodies; of the tokens; their entries | 2,086; 44.35%; 159,437 | 671; 29.94%; 29,079 | 271; 4.18%; 11,997 | 1,447; 29.38%; 54,399 |
| the lowered function's; that differ | 2,086; 0 | 671; 0 | 271; 0 | 1,447; 0 |
| left out with every root the machine's: a control of another kind | 48 (4.23% of the tokens) | 57 (8.41%) | 8 (0.61%) | 51 (3.72%) |
| … an initialization of another form; a result of another class | 0; 0 | 0; 0 | 1; 1 | 1; 0 |
| `-g`: attempted; that differ | 2,086; 0 | 671; 0 | 271; 0 | 1,447; 0 |
| `-Wall -Wextra`: attempted; that differ | 1,704; 0 | 602; 0 | 226; 0 | 1,286; 0 |

12,768 bodies in the three flag sets, none differing, on the piece's first run on each: no change was made to it
between a difference and this table, since there was none. The lowered bodies here are the selected ones (musl's
headers' unreferenced inline functions are not lowered), and the machine is the one after the pipeline, on the walk's
nodes: before the walk the machine with no node of the walk's takes every root of 35.6% of `sqlite3.c`'s body tokens,
where this one takes 48.58%.

**Its fixture's faults** (`bodies-entries/faults-eec7ca784.txt`, `faults-cbdcbc070.txt`, `scripts/bodies-faults.py`):
sixteen single changes to the piece, each built and run against the fixture. At `eec7ca784` thirteen failed it, one did
not build, and two were not caught: a branch of the other sense (the fixture's only do statement's condition was
branches, so its control wrote none of its own), and a tape's label moved by one (no tape had a label of its own). At
`cbdcbc070` the fixture has a body for each, and all sixteen fail it.

**What it leaves out, by kind** (`bodies-entries/develop-cbdcbc070/`, the default warnings again at `cbdcbc070`, which
counts the first control of another kind): a `switch`'s in each of `sqlite3.c`'s 48 and Lua's 57, in 7 of the
compiler's own 8 and 34 of musl's 51; an `asm` statement in the others.

**Nothing else moves** (`bodies-entries/pair2-*-0dd1dfafa-eec7ca784/`: the ordinary compile at the piece's `eec7ca784`
against the branch it stands on, seven paired rounds a workload on the 9700X, CPU 2, Release, under the lock; the
objects and diagnostics one set):

| | the branch it stands on | the piece | paired | range | user instructions M |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c`, wall ms | 111.435 | 111.341 | +0.247 | -0.189 to +18.056 | 1,215.364 and 1,215.364 |
| the compiler's own source | 598.519 | 600.362 | +1.472 | +0.209 to +4.140 | 8,927.314 and 8,927.370 |
| Lua | 64.054 | 64.085 | +0.035 | -0.235 to +0.071 | 724.335 and 724.334 |
| musl | 663.097 | 661.096 | -1.976 | -3.547 to +1.988 | 6,634.680 and 6,634.105 |

No compile runs the piece's code. The compiler's own source reads 0.25% slower in all seven rounds with 54 thousand
instructions more of 8,927 M: the executable's layout with the piece in it, not work of the piece's.
