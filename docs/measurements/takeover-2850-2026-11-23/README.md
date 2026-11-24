# #2850 after the 2026-11-23 handoff: main read again, and a unit preprocessed twice

Records of the session that took [buster14a/buster#2850](https://github.com/buster14a/buster/issues/2850) over on
2026-11-23 ([its claim](https://github.com/buster14a/buster/issues/2850#issuecomment-7101547626)), after
[the handoff](https://github.com/buster14a/buster/issues/2850#issuecomment-7101108212) of
[`takeover-2850-2026-11-22`](../takeover-2850-2026-11-22). Everything here is the 9700X (`benchpress`), Release builds
by `./build.sh --config Release --target compiler` under the lock, one lane on CPU 2, the frozen `sqlite3.c` with the
9700X job's `compile_time` options unless a line says otherwise. `scripts/` has what ran:

- `setup.sh REV` builds a revision; `exp.sh NAME BASE PATCH CONFIG` builds a tree with a patch.
- `stages.sh REV` is seven `--time-stages` runs; `profile.sh REV` eight `perf record` runs (`cycles`, one sample each
  100,003) and a counters run.
- `prof2.sh NAME TREE [OPTIONS]` is both with the compiler's options given, reduced to `by-function.txt` (cycles a run
  by symbol, every symbol) and `stages.txt` (`stages-reduce.py`: each line's median, least and most of seven runs).
- `pair2.sh PARENT CANDIDATE WORKLOAD ROUNDS` and `reduce2.py` are the earlier record's: each round runs the two
  builds in ABBA or BAAB order, each position one hold of the lock with a warm-up, a wall-clock run and a counters run,
  and every run's objects and diagnostics are hashed.
- `job-main1.sh`, `job-nb1.sh` and `job-fix1.sh` are the three jobs as they ran.

The lock's wait lines that name other sessions are removed from the `lock.log` files.

## Main at `55008c81e` (`main-55008c81e/`)

The handoff's last reading of main was 117.4 ms at `96fac43e0`. Twenty-eight merges later:

| `--time-stages`, ms, medians of 7 | `d541430bf` (11-22, the earlier record) | `55008c81e` |
| --- | ---: | ---: |
| preprocess | 9.505 | 9.511 |
| parse | 6.821 | 6.835 |
| check-input | 41.735 | 41.474 |
| check-expressions | 10.555 | 12.093 |
| check-declarations | 2.077 | 2.198 |
| check-program | 18.986 | 35.068 |
| lower | 11.603 | 11.942 |
| tier0 | 4.908 | 4.952 |
| total | 111.696 | 130.094 |

(`main-55008c81e/stages/`; its fifth run read 1,489 ms with 1,401 of them in `check-input`, one stall the medians leave
out.) The counters (`main-55008c81e/profile/stat.csv`, five runs): 622.2 M user cycles, 82.6 M kernel, 1,428.7 M user
instructions, where `96fac43e0` ran 1,287.8 M.

**Where it went.** `main-55008c81e/profile/by-symbol.txt` is the cycles a run by symbol (734.5 M in all). Against the
earlier record's `profile-whole-bbe80f1a9/by-function.txt`, every symbol of the preprocessor doubled:
`tokenize_c_raw_no_separators` 10.4 M to 20.8 M, `pp_run_contexts` 8.3 to 16.9, `refine_pass_b_64_plain` 7.7 to 14.4,
`pp_invoke` 3.1 to 6.5, and `pp_prepared_directive`, `pp_scan_arguments`, `pp_expand_current`,
`pp_emit_simple_write`, `pp_substitute`, `pp_finish_directives`, `pp_without_splices` and `pp_append_tokens` each
appear with 1.4 M to 2.4 M, while the `preprocess` stage reads what it read. The unit is preprocessed a second time,
inside `check-program`.

**Why.** buster14a/buster#3381 (merged 2026-11-23 11:04Z) made `check_common_stmt_marker` ask of every discarded
statement that is no call whether a macro's body wrote it (`check_common_unused_quiet`), before knowing that the
statement would warn. For a token a macro gave, the answer reads the unit's expansion history
(`check_common_ignored_macro`), and the driver defers that history: `pp_history_ensure` records it by preprocessing
the unit again. A break at `pp_history_ensure` in a Release build of `55008c81e` stops first under
`check_common_stmt_marker` (`c_check_common_warnings.c:4555`) on `sqlite3.c`, which prints no diagnostic.

## The fix (`history-fix/`, [buster14a/buster#3405](https://github.com/buster14a/buster/pull/3405))

The question is asked last, of a value that would warn otherwise (`scripts/history-fix.patch`, the pull request's
commit `2b01af6e` as a patch on `55008c81e`; the tree is `fix1`). `--time-stages` gains a line, `time-process
history-replays`, the command's units preprocessed again for their history.

Paired against main `55008c81e` (`history-fix/pair2-*/summary.txt`); each workload's objects and diagnostics are one
set in every run:

| | rounds | main, ms | the fix, ms | paired, ms | lower | user instructions, M |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 7 | 128.716 | 117.786 | -10.828 | 6/7 | 1,428.686 to 1,290.523 |
| the compiler's own source | 5 | 663.709 | 621.041 | -42.316 | 5/5 | 9,981.438 to 9,175.536 |
| Lua, 34 units | 5 | 84.728 | 65.463 | -19.241 | 5/5 | 998.292 to 745.421 |
| musl, 1,336 units | 5 | 682.750 | 668.642 | -14.113 | 5/5 | 6,854.265 to 6,731.247 |

`sqlite3.c`'s one round that is not lower took base pages for a run (24,792 more faults in its wall-clock run: the
host busy as it started); its cycles are lower in 7 of 7 rounds: 707.6 M to 648.1 M in all (-58.6 M), 988 to 905 a
token.

Its stages (`history-fix/prof2/stages.txt`): `check-program` 23.928 ms where main reads 35.068, the total 117.295
where main reads 130.094, `history-replays` 0, the peak 245.8 MB where main's is 264.0.

## `--node-bodies` at buster14a/buster#3373's head (`node-bodies-3ef312992/`)

`prof2.sh` on `3ef312992` (main `94ec1ca8c` merged in, so with the second preprocessing above in both arms), without
the option (`plain/`) and with it (`bodies/`):

| ms, medians of 7 | without | with | |
| --- | ---: | ---: | ---: |
| check-input | 41.252 | 69.984 | +28.732 |
| check-expressions | 12.193 | 8.773 | -3.420 |
| check-declarations | 2.185 | 1.737 | -0.448 |
| check-program | 34.814 | 29.422 | -5.392 |
| lower | 11.939 | 10.946 | -0.993 |
| total | 128.548 | 147.035 | +18.487 |

734.9 M cycles a run without it and 843.7 M with it (`by-function.txt` of each). What the option adds, by symbol, M
cycles a run: `node_census_node` 20.1, `node_alone_bodies` 16.6, `node_front_chunk` 14.8, `clear_page_erms` 11.4,
`node_alone_begin` 9.3, `node_machine_type_in_context` 8.8, `node_twin_build` 7.3, `node_machine_contexts` 7.2,
`check_lower_taken_body` 6.8, `node_machine_rule` 6.7, `node_machine_reader_chunk` 5.9, `node_machine_reader_side`
5.9, `node_machine_expand` 5.0, `node_producer_before` 4.6, `check_input_expression_literals` 4.5,
`node_census_walk` 3.7, `check_input_expression_identifiers` 3.5: about 183 M (33 ms) over the sixty symbols that
grow most. What it removes is about 61 M (11 ms) over the thirty that shrink most: `check_graph_run` 7.7,
`check_lower_drain` 7.7, `check_program_references` 6.3, `check_input_expressions_coded_range` 5.1,
`check_input_warning_graph` 4.3, `check_common_own_reach` 3.1.

## A post-link layout of the executable from a branch profile (`bolt/`)

A measurement, not a change to the build. The profile-guided build gives `sqlite3.c` about 3% (the earlier record),
the default path's profile is flat, and an earlier survey read 28% of the compile's slots as front-end bound. This asks
what laying out the linked executable's code from a branch profile would add.

- **The executable:** the fix's tree linked again with its relocations kept (`scripts/relocs1.patch`: the fix and
  `-Wl,--emit-relocs`; the tree is `relocs1`, the same code and sizes as `fix1`).
- **The profile:** `scripts/lbr-train.sh relocs1 train1 main lua musl`: `perf record -e cycles:u -j any,u -c 20011`
  of the compiler's own source, Lua's 34 units and musl's 1,336, **not `sqlite3.c`**, each a hold of the lock on CPU 2.
  `perf script -F brstack` reduced by `scripts/preagg.py` to BOLT's pre-aggregated form: 110,290 samples, 30,244
  branches and 33,212 fall-throughs (`bolt/train-preagg.log`; perf's rate cap kept about a third of the samples asked
  for).
- **The layout:** LLVM 23.1.6's `llvm-bolt` on this session's cloud container, on the executable with its debug
  sections stripped and its file symbols kept: `llvm-bolt compiler-relocs1 -o compiler-bolt1 -p preagg-train1.txt -pa
  -reorder-blocks=ext-tsp -reorder-functions=cdsort -split-functions -split-all-cold -dyno-stats`. It ran in its lite
  mode: 1,277 of 14,455 functions have a profile, the blocks of 1,178 are laid out again, 1.21 MB of hot bytes split
  from 2.83 MB of cold ones, and in its own count of the profile the taken branches fall by 56.7%.
  (`perf2bolt` alone refuses the executable in strict mode: 1,755 relocations in `.sframe` and `.eh_frame` it does
  not claim.)

Paired against the same executable before the layout (`bolt/pair2-*/summary.txt`), every object and diagnostic the
same:

| | rounds | before, ms | after, ms | paired, ms | lower | user cycles, M | user instructions, M |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c`, not in the training | 7 | 117.443 | 116.741 | -0.800 | 6/7 | -7.936 | -9.434 |
| the compiler's own source | 5 | 624.299 | 617.750 | -4.559 | 5/5 | -34.731 | -72.290 |
| Lua, 34 units | 5 | 65.908 | 62.708 | -3.168 | 5/5 | -15.972 | -6.636 |
| musl, 1,336 units | 5 | 669.161 | 603.661 | -65.916 | 5/5 | -321.357 | -66.608 |
| `sqlite3.c`, with `sqlite3.c` added to the training (`pair2-sqlite-fitted/`, a ceiling) | 7 | 117.730 | 116.533 | -1.146 | 7/7 | -5.085 | -9.579 |

So the layout is worth 0.7% to `sqlite3.c` and 1% at most with the benchmark itself in its training, and 9.9% to a
command of many small units, each of which runs every stage's code cold. It was measured on the ordinary Release
build; what it adds to `BUSTER_PGO=1` is not measured.

## The bodies' cost by batch size (`locality/`)

Whether a unit's bodies cost less when fewer of them are in the compiler's memory at once: what a compile by windows
(buster14a/buster#2536) would gain on one core beside the pages it no longer faults.

`scripts/locality.sh fix1 fix1 5 4 16 64` preprocesses the frozen `sqlite3.c` once (`-E` of the fix's build) and
`scripts/chunks.py` cuts it: `whole.i`; `none.i`, every function definition's body replaced by `;`; and for K of 4, 16
and 64, K variants that each keep the bodies of one run of the bodies in source order (about equal body tokens) and
replace the rest. Every variant ends with a table of pointers to the functions it defines, so that a static function
is emitted in a batch whose callers of it are gone, as it is in the whole unit. Each variant is compiled five times
(`-c -Wno-undefined-internal`, one lane on CPU 2), in a rotating order, each run a hold of the lock with a warm-up
before its counters. No variant prints a diagnostic. `locality/kept/runs.tsv` has every run (variant, round, user
cycles, kernel cycles, user instructions, first-level data misses, faults, the object's hash, stderr's lines), and
`scripts/locality-reduce.py` gives the medians (`locality/kept/reduced.txt`):

| medians of 5, M | user cycles | kernel cycles | user instructions | first-level misses |
| --- | ---: | ---: | ---: | ---: |
| the whole unit | 554.203 | 76.841 | 1,265.493 | 18.098 |
| no bodies | 64.301 | 18.882 | 191.575 | 2.259 |
| the bodies: the whole unit less none | 489.902 | 57.959 | 1,073.918 | 15.839 |
| the bodies in 4 batches: each batch less none, summed | 458.129 | 83.838 | 1,096.573 | 15.484 |
| in 16 batches | 461.354 | 121.731 | 1,114.738 | 15.693 |
| in 64 batches | 553.479 | 154.564 | 1,188.196 | 16.444 |

- **In 4 and in 16 batches the bodies take 6.5% and 5.8% fewer user cycles** for 2.1% and 3.8% more instructions (each
  batch's own fixed work): 8.4% and 9.3% fewer cycles an instruction. That is about 32 M cycles, 6 ms.
- **The first-level misses do not fall** (97.8% and 99.1% of the whole unit's): what a batch of 140 thousand or 35
  thousand body tokens gains is in the levels behind.
- **64 batches cost more than the whole unit:** a batch of 9 thousand body tokens is a process of its own here, and its
  start and its file scope's code run cold 64 times. The kernel's cycles rise with the batches for the same reason
  (each maps and faults its own memory), so this says nothing about a window that reuses its memory in one process.
- **`locality/unkept/` is the first run, without the table of pointers**, and is confounded: a static function whose
  callers' bodies are gone is not selected, so the batches ran 17% fewer instructions than the whole unit's bodies. It
  is kept for that count alone.

## The references' pass as one descending sweep: refuted (`references/`)

A prototype, paired before any specification. `check_program_references` walks each body's graph from its roots with a
stack, about 50 cycles a node (16.1 M a compile; `lines/whole-unit-passes.txt` has its cycles by source line, from
`scripts/lines.sh`). I took it for bound by misses in the order of the tree, and replaced the stack with a worklist of a
bit a node read from the highest node down, the per-node rules unchanged (`scripts/references-sweep.patch`, on
`55008c81e` with the fix; the tree is `refs1`). The objects and the diagnostics are the same.

| against the fix | rounds | paired, ms | lower | user cycles, M | user instructions, M |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 7 | +0.388 | 1/7 | +1.953 | +6.316 |
| the compiler's own source | 5 | +1.999 | 2/5 | +8.575 | |

Predicted -1.8 ms on `sqlite3.c`, to be dropped above -0.9: dropped. A node's operands are the nodes made just before
it, and the stack pops the last one pushed, so the walk already reads the columns nearly in descending order; the
sweep added its bit arithmetic to the same loads.

`lines/reader.txt` is the same attribution for the reader's largest functions (`check_input_expressions_coded_range`,
`check_graph_run`, `check_input_resolve_range`, `check_lower_drain`, `check_input_declaration`,
`check_input_expression_flush`), at the fix: no line of any holds more than 6 M cycles.

## Which fresh memory needs its zeros (`fresh-zeros/`)

A count, on a build that is not for merge. The kernel's 15 ms of `-c sqlite3.c` are mostly faults (82% in the earlier
census), and most of those the clearing of fresh pages: an arena promises that bytes no push took before are zero. This
asks how much of the compile's fresh memory is ever read before it is written, which is what any reuse of memory
without clearing (a pool kept between units or between processes, a window's arena) would need to know.

- **The build** (`scripts/experiment-fresh-zeros.patch`, on `55008c81e` with the fix, Release with `BUSTER_BAKE=0`, on
  this session's cloud container: counts, not times). Every `arena_push` and `arena_push_array` names its call site
  (file and line). The bytes of a push past its arena's peak, which nothing pushed before, are counted by site; for the
  sites a list marks they are filled with `0xA5`; and each site's resident pages are counted before its arena gives
  them back and at exit (`mincore`, a page counted for the push that holds its first byte). A measuring arena's pushes
  (`arena_measure`) have no memory and are left out. `lane.c`'s own pushes (its tables' reservations) are one site,
  `internal`, never filled.
- **The bisection** (`scripts/fresh-bisect.py`): 358 sites push fresh bytes in `-c sqlite3.c` (`fresh-zeros/sites.txt`:
  bytes pushed, pushes, site). With every site filled the compile hangs. A site needs its zeros when the compile gives
  the same object and an empty stderr with the sites before it filled, and not with it filled too; each one found is
  left zero and the search repeated (`fresh-zeros/progress.txt`, 202 compiles).

**15 of the 358 sites need their zeros** (`fresh-zeros/zero-sites.txt`); with the other 343 filled with garbage
(`fresh-zeros/final.list`) the object is the default compile's. They are what the code says of them: the reader's
sparse columns and its binding table's heads (`c_check_input.c:17982`, `:17998`, `:17983`, `c_bindings.c:120`), the
sparse pool's directories (`c_check_sparse.c:246`), three of the reader's token columns (`c_check_input.c:17753`,
`:17758`, `:17829`), the stream's sparse columns (`c_checker.c:4218` to `:4233`, six of them) and the intern table's
(`c_intern.c:676`).

**By resident memory** (`fresh-zeros/resident.txt`; base pages here, as this container has no huge pages): of 188.4 MB
resident by fresh pushes (the process's peak is 180.2 MB), the 15 sites hold 20.8 MB, `lane.c`'s own 18.7 MB, and the
343 sites that never read their zeros **148.9 MB, 79%**.

**What it does not show.** One input and the default options. The same list filled with garbage gives a spurious
diagnostic with `-Wall -Wextra` (241 bytes of stderr, the object the same) and another object with `-g`; `-fPIC` is
the same object. So other options and other inputs have sites of their own, and a list for a change of the arenas'
promise needs the whole inventory run this way, not `sqlite3.c`.

### The same over the tests' sources and the options (`fresh-zeros/wide/`)

`scripts/fresh-campaign.py` on the experiment's build at the session's branch with main `ef400844` merged in (the
sites' lines are that tree's), with garbage as the default: every fresh push is filled but `lane.c`'s own and the
sites a list keeps zero (`BUSTER_EXPERIMENT_FRESH_DEFAULT=G`). 4,714 cases (`wide/cases.txt`): each of the 1,567
`.c` files under `tests/` by `-fsyntax-only -Wall -Wextra`, by `-c -g` and by `-c -O1`; `sqlite3.c` in ten option
sets (`-c` plain, with `-Wall -Wextra`, `-Weverything`, `-g`, `-fPIC`, `-O1`, `-g -O1`, `-fPIC -g -Wall`,
`-fsyntax-only`, `-S`); `shell.c`; and the compiler's own `main.c` checked and compiled. A case differs when its
status, its stderr and stdout, or its output file do against the run with nothing filled. For the first case that
differs, its own sites are bisected and the ones it needs are added to the list; then every differing case runs again.

- With `sqlite3.c`'s 15 sites alone, 593 of the cases differ (`wide/first-pass-differ.txt`, from
  `scripts/fresh-campaign-first.py`, which fills only the sites `sqlite3.c` has).
- **With 28 sites kept zero no case differs** (`wide/zero-sites.txt`, `wide/progress.txt`: ten rounds). Six of the 28
  are the first list's lines in the tree before the merge, which name nothing in this one, so 22 are sites of this
  tree: the reader's sparse columns and token columns (`c_check_input.c:17757` to `:17774`, `:17833`, `:17986`,
  `:17987`, `:18002`), the stream's (`c_checker.c:4218` to `:4233`), the sparse pool's directories, the binding
  table's heads and the intern table's.
- **In `sqlite3.c`'s compile** (`wide/resident-by-site.log`): of 188.4 MB resident by fresh pushes, those sites hold
  32.3 MB, `lane.c`'s own 18.7 MB, and the 336 other sites **137.4 MB, 73%**.

What the cases do not reach: commands of several units on lanes, `--node-bodies`, `-E`, the links, lazily read
headers and deferred bodies, and the tests' and benchmarks' own commands.

## Where the kernel's cycles of musl's command are (`musl-profile/`)

`scripts/prof-musl.sh fix1 fix1`: musl's 1,336 units as one command, one lane on CPU 2, three `perf record` runs
(`cycles`, user and kernel) and a counters run, at the fix. 3,721.7 M cycles a run, **27.1% in the kernel**
(`musl-profile/by-function.txt`): `unmap_page_range` 121.0 M, `lock_vma_under_rcu` 106.3, `_raw_spin_lock` 77.3,
`clear_page_erms` 74.9, `asm_exc_page_fault` 63.5, `_raw_spin_trylock` 47.9, `mas_walk` 42.0, `folio_add_lru` 29.1.
The command takes 266,235 faults (`stat.csv`), 199 a unit: its arenas' pages go back to the kernel after each unit and
are faulted in again, a base page at a time, so what it pays is the faults themselves more than the clearing.

## A pool that keeps its arenas' pages and clears what each push takes: refuted (`keep-pages/`)

A prototype, paired before any specification (`scripts/experiment-keep-pages.patch`, on the fix's branch with main
`ef400844` merged in, `b7e3552c`; the tree is `keep1`). With `BUSTER_EXPERIMENT_KEEP_PAGES=1` a thread's pool no longer
gives a released arena's pages back to the kernel (but an arena of tables'); the arena carries how far it may hold an
earlier user's bytes, and each push clears what it takes of them past the arena's own peak, so that every push still
gets the zeros a fresh arena promises. Nothing is annotated: it is the form that changes no promise.

One executable, the switch off and on (`scripts/pair-env.sh`, five rounds each, the objects and diagnostics one set):

| | off, ms | on, ms | paired, ms | lower | user cycles, M | kernel cycles, M | faults |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| musl, 1,336 units | 662.908 | 643.262 | -19.810 | 5/5 | +77.042 | -191.045 | 266,487 to 148,865 |
| Lua, 34 units | 65.345 | 72.075 | +6.741 | 0/5 | +23.947 | +9.798 | 15,464 to 17,407 |
| `sqlite3.c`, `shell.c` and two of Lua's | 172.196 | 176.776 | +4.580 | 0/5 | +13.197 | +9.040 | 9,805 to 9,860 |

Predicted for musl's command about 15% and to be dropped under 8%: it gives 3.0%, and Lua's and the mixed command
lose. A push takes its column's whole capacity and a unit writes part of it; clearing the capacity in user space
touches pages the kernel would never have mapped, where the kernel's own clearing is of the pages written. So this
form pays only where units are small enough that capacity and use are the same pages, and even there it leaves 149
thousand of musl's faults (the scratch's discards inside a unit and the tables' arenas are as they were). What the
count above offers is the other form: the sites that never read their zeros take kept pages with no clearing at all,
which needs those sites named.

## Main with the three pull requests merged (`state-f26d9c012/`)

Main `f26d9c012` has buster14a/buster#3373, buster14a/buster#3405 and buster14a/buster#3398. `scripts/job-state.sh`:
its ordinary Release build's stages and profile by symbol (`prof2/`), and the profile-guided build (`BUSTER_PGO=1`,
the default training) paired against the ordinary one (`pair2-*/summary.txt`; each workload's objects and
diagnostics are one set in every run):

| | rounds | ordinary, ms | profile-guided, ms | paired, ms | lower | user instructions, M |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 7 | 115.811 | 112.557 | -3.322 | 7/7 | 1,273.202 to 1,206.644 |
| the compiler's own source | 5 | 615.575 | 580.610 | -36.218 | 5/5 | 9,122.285 to 8,257.853 |
| Lua, 34 units | 5 | 65.204 | 60.841 | -4.363 | 5/5 | 742.244 to 687.346 |
| musl, 1,336 units | 5 | 666.843 | 601.591 | -66.065 | 5/5 | 6,728.522 to 6,127.441 |

The ordinary build's stages (`prof2/stages.txt`, medians of seven, ms): the total 114.807; preprocess 9.527, parse
6.785, check-input 40.816, check-expressions 10.872, check-declarations 2.148, check-program 23.769, select 1.016,
lower 11.527, Tier 0 4.216, the emission and the object 3.6. The profile is 656.0 M cycles a run, the kernel 12.7% of
them (`clear_page_erms` 54.6 M). The target is 9.507 ms: the compile is twelve times it.

## Main through a day, 15 of its 115 merges (`sweep-day1/`)

`scripts/sweep.sh`: every eighth first-parent merge from `d541430bf` (2026-11-22 04:33Z) to `94ec1ca8c` (2026-11-23
11:04Z), each built (Release) and run in one hold of the lock: a warm-up, three counted runs and five `--time-stages`
runs of `-c sqlite3.c` on CPU 2. `table.txt`'s columns: the revision, user instructions (M), user and kernel cycles
(M, means of three, one hold; some held a busy host's base pages), then the stages' medians, ms: preprocess, parse,
check-input, check-expressions, check-declarations, check-program, select, lower, Tier 0, the total; and the object's
hash.

The instructions are exact to a thousandth and place each step:

| between | instructions, M | the stage that moves, ms | the merge |
| --- | ---: | --- | --- |
| `8cd0dd307` and `4874b2a90` | +32.340 | check-program 18.78 to 20.92 | buster14a/buster#3181, the statements clang does not emit (its own pair: +30.7 M, +1.883 ms) |
| `9ba3d792b` and `d43345393` | +8.747 | check-program 20.84 to 21.09 | eight merges, not separated |
| `d43345393` and `2a613c7b6` | +16.035 | check-program 21.09 to 22.81 | buster14a/buster#3324, clang's CFG heuristics (its symbols are 8.7 M cycles of the profile) |
| `2a613c7b6` and `9730190c3` | +18.214 | check-expressions 10.53 to 12.15 | buster14a/buster#2937, constant logical operands (buster14a/buster#3398 takes 11.5 M back: 10.87 at `f26d9c012`) |
| `ff9bad73b` and `94ec1ca8c` | +139.591 | check-program 23.53 to 34.61 | buster14a/buster#3381, the expansion history asked of every discarded statement (buster14a/buster#3405 takes it back) |

So the day cost the compile 18 ms (110.84 to 128.81), of which the two fixes return 12.3; the 5.0 ms that stay
(115.8 ordinary at `f26d9c012` against 110.8) are three features' own work, less 0.7 that Tier 0 gained since. No
check of a pull request reads this number.

## The statements' reach, two cuts: under the line (`reach/`)

buster14a/buster#3181's walk (`c_check_program_reach.c`), against main `a5e760845`, throwaway patches
(`scripts/reach1.patch`, `scripts/reach2.patch`; `scripts/job-reach1.sh`):

- `reach1`: a `while`'s and a `for`'s body is scanned for a `break` only where the answer needs it (a condition
  constantly true, a `for (;;)`), where main scans every loop's body.
- `reach2`: that, and a block asks whether a statement completes only when a later kept statement needs the answer:
  the block's last statement's is never read.

| | rounds | paired, ms | lower | user instructions, M |
| --- | ---: | ---: | ---: | ---: |
| `reach1`, `sqlite3.c` | 7 | +0.022 | 3/7 | -2.042 |
| `reach2`, `sqlite3.c` | 7 | -0.269 | 6/7 | -12.022 |
| `reach2`, the compiler's own source | 5 | +1.698 | 2/5 | -24.509 |
| `reach2`, Lua | 5 | -0.280 | 5/5 | -3.414 |
| `reach2`, musl | 5 | +0.201 | 2/5 | -4.883 |

Every object and diagnostic is the parent's; on this session's machine also the 1,568 files under `tests/` each
compiled two ways, Lua's 34 two ways and `sqlite3.c` and `shell.c` five ways (3,214 commands, 1,200 objects, none
differs). The walk gives up 12.0 M of the 30.7 M instructions the change added and a quarter of a millisecond: they
were its cheap ones. Under 1 ms, so not specified.

## Main from 17 to 22 November, 22 of its merges (`sweep-week1/`)

The same sweep (`scripts/sweep.sh`) over every tenth first-parent merge from `4b9c9fa21` (17 November) to `d335da08d`
(22 November), to see whether steps like the day's above hide earlier. `table.txt` has the same columns.

They do not. User instructions of `-c sqlite3.c` go from 1,362.108 M to 1,262.185 M and only fall, but for one step
of +3.854 M (`e31c90375` to `875c08e9d`); the total goes from 121.05 ms to 112.71. So what the compile gained by
features in this window is the day of 22 to 23 November, whose five steps the section above places.

## The producer at main `da652ae8d`, and its setup as scans (`producer/`)

**Where `--node-bodies`' cost is** (`producer/where-da652ae8d/`: `scripts/job-nb2.sh`; `prof2.sh` without the option,
`plain/`, and with it, `bodies/`; `scripts/lines2.sh` for the cycles by source line within the symbols the option adds
most to, `lines-bodies.txt`). The stages' medians, ms: the total 114.199 without and 133.518 with (+19.319);
check-input 40.988 to 69.760, check-expressions 10.946 to 7.842, check-program 23.341 to 18.187, lower 11.635 to
10.642. By symbol the option adds 197.5 M cycles a run and removes 88.5 M:

| what it adds, M cycles a run | |
| --- | ---: |
| the census's tests (`node_census_node` 19.7, `_walk` 4.4, `_expression` 2.9, `_unsequenced` 2.5, `_reader_expression` 2.0, the constants' 2.9, others) | 36 |
| `node_alone_bodies`, the loop with a body's reading and writing inlined | 16.4 |
| T (`node_machine_type_in_context` 8.3, `node_machine_rule` 6.1, `node_machine_call_rule` 1.3) | 15.7 |
| `node_front_chunk` | 14.5 |
| `node_machine_reader_chunk` 6.0 and `node_machine_reader_side` 6.0 | 12.0 |
| the twin (`node_twin_build` 6.9, `node_twin_gates` 3.0, `node_twin_unreached` 1.6) | 11.5 |
| `clear_page_erms` | 11.0 |
| what is asked before a reading (`node_producer_before` 4.6, `node_front_started` 2.8, `node_alone_scan` 2.5) | 9.9 |
| `node_alone_begin` | 9.85 |
| C, `node_machine_contexts` | 6.7 |
| `check_lower_taken_body` | 6.6 |
| the tokens prepared a second time (`check_input_expression_literals` +3.25, `_identifiers` +2.8) | 6.0 |
| X, `node_machine_expand` | 5.45 |

What it removes: `check_graph_run` 7.6, `check_lower_drain` 6.7, `check_program_references` 6.55,
`check_input_expressions_coded_range` 4.7, `check_input_warning_graph` 3.2, `check_control_drain` 2.8 and seventy
smaller. So it pays once what it adds is under 88.5 M: 45% of today's.

By source line only `node_alone_begin` has a shape: five passes over every token of the unit, a token at a time
(`c_check_node_machine_alone.c`'s count of the bodies and its test of each body's run of the postorder,
`c_check_node_bodies.c`'s largest body, defined functions and the enumerations' two passes). The others are flat.

**Its setup as scans** (`producer/setup/`; `scripts/setup1.patch` on `da652ae8d`, `scripts/job-setup1.sh`): the
bodies' opening braces and the `enum` keywords listed by 64 tokens a compare, the passes reading those lists, and a
body's run tested 16 positions a step. The option in both arms (`pair2-*/summary.txt`; each workload's objects and
diagnostics one set):

| | rounds | main, ms | the scans, ms | paired, ms | lower | user cycles, M | user instructions, M |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 7 | 133.656 | 133.113 | -0.977 | 5/7 | -6.376 (7/7) | -23.395 |
| Lua, 34 units | 5 | 73.443 | 72.884 | -0.595 | 5/5 | -2.791 | -9.733 |
| musl, 1,336 units | 5 | 749.126 | 746.624 | -2.118 | 5/5 | -19.787 | -66.781 |
| the compiler's own source (takes no body) | 5 | 607.436 | 605.855 | -1.999 | 4/5 | -10.726 (3/5) | +0.002 |

`sqlite3.c`'s two rounds that are not lower held base pages for a run (one read +16.4 ms); its cycles are lower in
seven of seven.

## Pages kept between a command's units, three ways (`kept-pages/`), and the instructions' baseline (`baseline/`)

After David's decisions of 23 November (the check; the arenas' contract and `shmem_enabled=advise`; the rebuild after).
None of the patches is for merge. The 9700X's lock was about twenty jobs deep, so each experiment is one executable
with a switch and every workload's rounds in ONE hold (`scripts/keep-hold.sh`, `keep4-hold.sh`, `keep5-hold.sh`: a
warm-up a workload, then a counted run a position; reduced by `scripts/keep-reduce.py` and its two siblings; their
"wall ms" column is not filled, `perf stat` gives the cycles). Every run's status, objects and diagnostics are one
set but where said.

**The list of sites that need zeros, again** (`zero-sites-f5d89b84.list`, `zero-sites-campaign-progress.txt`): on the
tree of 23 November the list is 26 sites, not the 28 of the morning's: three of the reader's sites were rewritten by
the day's merges and one of Tier 0's is new (`tier0.c:14799`). With garbage in every other fresh push none of the
4,714 cases differs.

**The pool keeping its arenas' pages** (`scripts/experiment-kept-pool-pages.patch` on `f5d89b84`;
`pool-pages-summary.txt`; `off`, `sites` = only the 26 sites' pushes cleared, `all` = every push cleared), cycles, M:

| | off: user, kernel | sites: user, kernel | all: user, kernel | faults: off, sites, all |
| --- | --- | --- | --- | --- |
| musl, 1,336 units | 2,792.8, 939.6 | -24.9 (4/4), -196.5 (4/4) | +80.6, -191.2 | 266,778, 146,638, 148,670 |
| two units of `sqlite3.c` | 1,160.3, 153.9 | +0.4, -7.4 (5/5) | +59.1, +158.9 | 10,390, 10,259, 56,985 |
| `sqlite3.c`, `shell.c`, two of Lua's | 800.7, 145.4 | +1.6, -4.6 (5/5) | +13.3, +7.8 | 10,192, 10,226, 10,247 |
| Lua, 34 units | 305.3, 64.4 | +3.5 (0/5), +0.9 (0/5) | +23.8, +10.2 | 15,810, 14,596, 17,680 |
| `sqlite3.c` alone | 562.7, 83.8 | nothing | nothing | 5,678 |

So with only the sites cleared musl's command takes 221 M fewer cycles of 3,732 M (5.9%), and Lua's loses 4 M: its
callers that ask whether an arena is untouched clear again what the site's push cleared.

**The units' lane's three discards skipped** (`scripts/experiment-kept-lane-discards.patch` on `90bb2d83`;
`lane-discards-summary.txt`): nothing moves, on any workload; faults the same to a page. That path
(`check_units_memory_give`) is not taken on one lane.

**Every stage-end discard skipped** (`scripts/experiment-kept-stage-discards.patch` on `3f4ff4c7`, with the pool's
keeping beside it; `stage-discards-summary.txt`): musl's kernel -12.6 M cycles (5/5), two units of `sqlite3.c` -7.5 M
(5/5), faults 17 fewer of 10,390. With a fill of 0xA5 in the discards' place every workload's objects are the same:
nothing reads those pages as zeros. (Its third setting, the pool's keeping with the list of `f5d89b84`, is void on
musl and Lua: the list's lines are stale on `3f4ff4c7` and those compiles fail, two sets of objects.)

**Why two units of `sqlite3.c` gain nothing** (`two-units-memory-calls.strace`, `second-unit-kernel-*.txt`,
`two-units-stages-main.txt`): the command's peak is 463,440 KB for two units and 231 MB for one, so the second
unit's arenas are new while the first's are held; with everything kept the kernel still clears 93% of what it
cleared (`clear_page_erms` 105.97 against 98.11, the reports' units). The two units make 42 `MADV_DONTNEED` calls;
musl's six units 103.

**The baseline** (`baseline/measure-compile-90bb2d83.txt`, `scripts/job-base.sh`): main `90bb2d83` built as the 9700X
job builds it (`BUSTER_HOST_ARCH=znver5`, `BUSTER_DEBUG_INFO=0`), the job's own arguments, three runs:
1,279,713,311, 1,279,713,338 and 1,279,713,340 user instructions. buster14a/buster#3471's file states the median.

## A pool file for the arenas: the premise measured, the first prototype not (`pool-file/`)

**What first touches cost by where the pages come from** (`scripts/shm-bench.c`, `shm-hold.sh`, `shm2-hold.sh`; the
9700X, CPU 2, 256 MB, a byte written a 4 KB page):

| the pages | ms | faults |
| --- | ---: | ---: |
| fresh anonymous memory, huge pages (what a compile's arenas take today) | 11.2 to 11.6 | 258 |
| a `/dev/shm` file a process left, base pages (`first-touches-dev-shm.txt`) | 9.5 | 4,098 |
| a file a process left on a tmpfs mounted `huge=always` (`first-touches-huge-tmpfs.txt`) | 0.67 to 0.69 | 130 |

So left huge pages cost a seventeenth of fresh ones, 10.7 ms less a 256 MB touched, and left base pages are no
gain. A tmpfs file's huge pages are its MOUNT's option (`huge=`): `shmem_enabled=advise` alone, which the first hold
set and put back, changed nothing for a `/dev/shm` file (`ShmemHugePages` did not grow; the file still took 65,538
faults to make). `shmem_enabled` governs memfd and System V segments. The second hold mounted a tmpfs for itself and
unmounted it.

**The first prototype does not measure the gain** (`scripts/experiment-pool-file.patch` on `3f4ff4c7`, not for
merge; `scripts/pool-hold.sh`, `job-pool1.sh`; `prototype-sqlite-summary.txt`; the list `zero-sites-3f4ff4c7.list`,
35 entries, none of 4,714 cases differing with garbage elsewhere). The stretch's upper half maps the file, its arenas
are dirty from their start, and a push at a site that needs zeros takes fresh anonymous pages in its place. Every
object is the same, also after another compile's leftovers. But only 20.6 MB of the compile's memory lands in the
file: the arenas with a base-page part of 2 MB or more are carved from the stretch's lower half, others are mapped on
their own, and the pushes remapped anonymous lose their huge pages (39,550 faults against 5,680; user +44 M cycles,
kernel +52 M). A first version that cleared the zero sites' pushes in place touched 790 MB and took 212 thousand
faults on this session's machine: a sparse site's room must come fresh, never cleared.

**The count a hosted runner can take** (`baseline/instrumented-counts.txt`, `scripts/count-rev.sh`; this session's
machine): the sum of the raw profile's counters of the instrumented compiler after one `-c sqlite3.c` is
316,076,643, 316,077,895 and 316,078,023 at `ff9bad73b`, and 338,233,072 three times at `94ec1ca8c`, which has
buster14a/buster#3381's second preprocessing: +7.0% where the instructions rose 10.8%, and a spread of 0.0004% at
most.

## The compile's memory by arena (`arenas/`)

What a pool could take as the arenas stand, and what it could take if the pushes that need zeros moved out. On this
session's machine (a virtual one; `BUSTER_HUGE_PAGES` 0 and 1), main `db3c3e22` with
`scripts/experiment-arenas-census.patch` (not for merge): every reservation named by its call's file and line, each
fresh push's resident pages (`mincore`, when its range is given back) added to its reservation's, and a push at a
site of the list (`zero-sites-db3c3e22.list`, 30 entries; none of 4,714 cases differs with garbage elsewhere) or one
of `lane.c`'s own counted as needing zeros; nothing is filled (`BUSTER_EXPERIMENT_FRESH_NOFILL`).
`scripts/arenas.py` reduces the logs to `sqlite-base-pages.txt` and `sqlite-huge-pages.txt`.

`-c sqlite3.c`, MB resident by the pushes of the registered reservations (base pages, then huge):

| reservation | resident | of it, the zero-needing pushes' pages | such pushes |
| --- | ---: | ---: | ---: |
| the driver's arena (`c_checker_driver.c:15097`): the reader's output, the graph | 51.2, 78.6 | 15.2, 17.7 | 10 |
| the driver's output arena (`:15099`): the run's stream, the program | 35.9, 44.0 | 13.5, 15.7 | 10 |
| the preprocessor's files (`c_preprocessor.c:4394`, five) | 11.5, 15.4 | 0 | 0 |
| the reader's sparse arena (`c_check_input.c:17666`) | 11.0, 11.0 | 6.8 | 40 |
| the parser's tables (`c_parser_impl.c:11330`), the preprocessor's (`c_preprocessor_impl.c:50`) | 17.0, 25.8 | all | tables |
| the object's two arenas (`c_checker_driver.c:10988`, `:10989`) | 3.3, 3.4 | 0 | 0 |
| **all 27 reservation sites** | **136.2, 190.9** | 54.4, 67.9 | |
| in arenas none of whose pushes needs zeros | 36.8, 55.8 | | |

(The driver's scratch, `:15098`, reads nothing here: its pushes' pages are not attributed by this census, a gap of
about 80 MB against the process's peak. It is the first thing the next census has to place.)

So as the arenas stand a pool takes 37 to 56 MB, a fifth of the compile's memory. The two large arenas mix both
kinds: ten pushes each need zeros and own 15 to 18 MB of 51 to 79 and 13.5 to 15.7 of 36 to 44. With those twenty
pushes in an arena of their own, the two arenas' other 58 to 89 MB are the pool's too.

## The reader's and the run's arenas from a pool file: 3.7 ms of `sqlite3.c` (`pool-file/driver-arenas/`)

**No push has to move.** `arenas/zero-sites-by-reservation.txt` (`scripts/pairs.py`: the 4,714 cases, each
zero-needing push's site with its reservation's) shows what the driver's two large arenas take that needs zeros: the
reader's ten output columns and the sparse columns' directory, and the run's stream's ten columns. Each of those
asks first whether its arena is untouched (`arena_untouched`, #628's fresh output) and clears or writes for itself
where it is not, as a command's later units already make it. So an arena of left pages only has to read as used
before: its peak at its capacity. Checked with garbage (`scripts/experiment-arenas-census-touched.patch`,
`scripts/touched-campaign.py`): the two arenas' peaks at their capacities, every push of theirs filled with 0xA5, and
garbage in every other fresh push but seven sites of other arenas: none of the 4,714 cases differs.

**What their own clearing costs** (`used-before-summary.txt`; `scripts/experiment-used-before.patch` on `db3c3e22`,
`scripts/touched-hold.sh`; the 9700X, one hold, the memory fresh in both settings): `sqlite3.c` +10.139 M user
instructions (0.79%) and +5.4 M user cycles, about a millisecond; musl's command, Lua's, the mixed one and two units
of `sqlite3.c` nothing.

**With their memory the file's** (`pool-summary.txt`, `stages-a.txt`, `stages-p.txt`;
`scripts/experiment-pool-driver-arenas.patch`, `scripts/pooldrv-hold.sh`; a tmpfs mounted `huge=always` for the hold
and unmounted, `mount.txt`; the file made by one compile, then seven rounds of main, used before, the file, the file,
used before, main):

| `sqlite3.c`, M cycles | main | used before | the file |
| --- | ---: | ---: | ---: |
| user | 551.759 | +5.470 (0/7 lower) | +3.944 (0/7 lower) |
| kernel | 75.827 | +1.520 (0/7) | **-24.534 (7/7 lower)** |
| user instructions, M | 1,282.146 | +10.139 | +10.138 |
| page faults | 5,574 | the same | the same |

So the file's two arenas take 20.6 M cycles off the compile, 3.7 ms at the core's clock; the two stage tables read
113.871 ms and 109.821 (check-input's system time 10.2 ms and 3.3, check-expressions' 2.9 and 0). The file holds
131 MB after one compile (`file-after-make.txt`) and 191 MB after Lua's `lvm.c`, `shell.c` and the rounds
(`file-at-end.txt`). Every object and diagnostic is main's in the three settings, and `lvm.c`'s and `shell.c`'s on
`sqlite3.c`'s leftovers are theirs without the file (`leftovers.txt`).
