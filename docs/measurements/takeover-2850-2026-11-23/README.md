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
