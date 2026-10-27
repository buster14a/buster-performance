# Salter's expression fragments against the postorder: #106's identity and #107's four paths

2026-10-26 and 27. The evidence for
[buster14a/buster#106](https://github.com/buster14a/buster/issues/106), the
fragment consumer's identity with the checker's postorder reader, and
[#107](https://github.com/buster14a/buster/issues/107), the four complete paths
from a unit's preprocessed tokens to the checker's results and the decision
between them, made on branch `claude/salter-fragments-106-107-21a90f`, whose
pull request links here. The decision, by #107's rule: the postorder stays, and
the fragment code was removed. The decision record, buster's
`docs/c-parser-fragments.md` from that pull request on, has the design, the
analysis and the decision; this record has what they were measured with.

## Revisions

- **The experiment**, `7808e81132186b937ee8bd5110401b04f8d70bd2`, the measured
  tree: the sink (#105, [#315](https://github.com/buster14a/buster/pull/315)),
  the readers ([#344](https://github.com/buster14a/buster/pull/344),
  [#358](https://github.com/buster14a/buster/pull/358)), the consumer
  (`8211678fca0c5a6e644d44b727bf562803737338`, #106) and `benchmark-parser
  --expressions` (`47276329…` and `7808e811`, #107). The branch's next commit,
  `6c5b21a18eda1dd620322d889295980178a97999`, changed only comments in
  `c_check_fragments.c` and dropped a cursor's field that was written and never
  read.
- **The earlier series**, `47276329888e003875aaba18028226359db96691`: the same
  tree but for the benchmark's handling of many files, which `7808e811` changed
  to batches of 128 (its only file, `c_check_fragments_benchmark.c`) after the
  libc corpus exhausted the address space locally. A run of it went on beside
  the `7808e811` run, each step under its own hold of the lock, until it was
  stopped after SQLite's five processes: those and its identity steps are a
  second series. Its SQLite identity step checked a manifest of a relative path
  and didn't run, as did `7808e811`'s, which `rerun-sqlite-identity.sh` ran
  again; its branches step, stopped while it waited for the lock, wrote only the
  lock's message, which this record leaves out.
- **main**, `e04462c12f1ce25c70e41e8aa4acf48f4d7c4004`, and **the head without
  the experiment**: the default paths' A/B (`ab.sh`, `ab2.sh`). The measured
  head was the removal as a provisional local commit on `7808e811`, never
  pushed, whose files `manifests/head-measured.sha256` lists (the scripts call
  it `29b23335`, its id); the branch's removal commit, as pushed, has the same
  files but three documents (`docs/c-parser-fragments.md`, `docs/c-files.md` and
  `docs/c-parser.md`).

`manifests/` lists the sha256 of every file of each tree, from `git archive`.
The trees on the 9700X were those archives, and matched the manifests file for
file (`build/` aside).

## Host and builds

AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, transparent huge pages `always`, CPU
2's governor and energy preference `performance`, the trees and outputs on
btrfs. clang 23.1.1 built each tree with `./build.sh` (`-O3 -g -march=native`,
one compile per core), under its own hold of the shared lock. `build/compiler`:

| Tree | sha256 | Build |
| --- | --- | --- |
| `7808e811` | `f34536caeb62f6272ce8a8d1517238aa96f7060c218ee8762e75ae84a28b5a0f` | 42 sources in 47.6 s |
| `47276329` | `38755affe0d15bf05081227f9bfd5ac63ba9f0c22a6642f76d06a0c16b60a1f0` | 42 sources in 47.6 s |
| main | `31230dd83b0ae3bc3929374b459ab843f721bca4dd59b25e91eece8b52fa91ab` | 42 sources in 39.2 and 39.3 s |
| head (measured) | `ccad495824e8527fd8f5587840c2c53e9747b912993a87be7e74e03ef905ca97` | 41 sources in 38.9 and 39.0 s |

main and the head were each built twice, in turn (`ab.sh`), into the same
executable both times.

## Inputs

| Input | Identity |
| --- | --- |
| SQLite 3.53.4's amalgamation, `sqlite3.c` (706,586 parser tokens) | sha256 `b1dd5d74ec7f29055a6684fa06fb3c2f6821c87dd38f9a458dfd2e8a1db28189` |
| the libc corpus: 733 files of Zig 0.14.1's `lib/libc` that clang accepts (3,867,223 tokens) | `inputs/libc.txt`, sha256 `273746d61ccef7b27ecf8833e9bdc4ef4dd8a3a3f36aa4c258cc5b17f6d718ef`; every file's sha256 in `inputs/libc.sha256` |
| long expressions, `generate long 107` (700,209 tokens) | sha256 `883ed9d2f4f9ddb4fdf3b5cf65c47e61abe0081d49fdf9c5c2ce318d02f04ba7` |
| small functions, `generate small 107` (759,127 tokens) | sha256 `35c2a0e3a503b6e74e37a9b070d96cb9854c802a8c8807cdc4c3e0f467854845` |
| `tools/generate.c` | sha256 `49d06adea0b74e139c6933ada0bd3063d6dbff8a078b2a7028bdc3660850099f` |
| the default paths' SQLite | the pinned corpus of #125, `/var/lib/buster-9700x/corpora/preprocessor-391e729af658` (SQLite 3.53.2, frozen headers and predefines) |

SQLite and the libc list are the frozen inputs of #315's qualification; the
benchmark and the identity test preprocess each file with the host's headers
and no options, as #315 did. Every step checked its inputs' sha256 before it
ran. `generate.c` writes C of `int` and `unsigned` arithmetic on parameters and
locals: long expressions are 60 functions each returning one expression of 500
to 8,000 operators, balanced or chained to either side; small functions are
6,000 functions of a few statements each.

## Commands

Every step held the shared lock alone (`~/buster-fast-bench/exclusive.sh`) and
ran pinned to CPU 2 (`taskset -c 2`).

- `scripts/run.sh`, run as `TREE=47276329` and as `TREE=7808e811`: the build;
  the identity (`test-fragments`: its fixtures and the parser's snippets;
  `test-fragments --no-fixtures --checker-fixtures`; SQLite; the generated
  corpora; the libc corpus in four parts); then SQLite's five pipeline
  processes. Both runs were stopped there (a branches step each had started
  and was waiting for the lock).
- `scripts/rerun-sqlite-identity.sh`: SQLite's identity at `7808e811`.
- `scripts/run2.sh`: the rest at `7808e811`. Three processes each of the libc
  corpus, long expressions and small functions, in turn; then SQLite's and
  libc's branch counters, SQLite's `--to-ir`, its stall and memory counters,
  the interleave's scalar twin (`--interleave scalar`) and the 48-byte payload
  (`--payload 48`).
- Each benchmark process is `benchmark-parser --expressions all --passes 21
  [--counters SET] FILE | --files-from LIST`. It preprocesses every file and
  sets up the type table and the arenas outside the time, checks that every
  path gives every file A's graph, token nodes, reports and typed stream, then
  times 21 passes after a warm-up, the four paths in an order that rotates by
  pass, each run one file through one path: `parse_translation_unit`,
  `check_input` and `check_graph_run` (the vector schedule, the default). A
  perf group (cycles, instructions and the set's three events) is read around
  each run, with the cost of reading it around nothing subtracted, and TSC
  stamps split the phases. A process prints each measure's median over the
  passes per token, with the fastest and slowest pass; the files of a corpus
  are summed per pass. The counter sets are Zen 5's raw events: `pipeline`
  (`ex_ret_ops`, `de_no_dispatch_per_slot.no_ops_from_frontend` and
  `.backend_stalls`), `branches` (`ex_ret_brn`, `ex_ret_brn_misp`,
  `ex_ret_brn_tkn`), `memory` (`ls_dmnd_fills_from_sys.local_l2`,
  `.local_ccx`, `.dram_io_near`) and `stalls` (`ls_bad_status2.stli_other`,
  the dispatch slots the power cap takes (#199), and
  `de_dispatch_stall_cycle_dynamic_tokens_part1.fp_sch_rsrc_stall`).
- `tools/summarize.c` (`summarize LOG...`) gives each path's median over the
  processes of each measure, with the processes' range and the change from A.
- `scripts/ab.sh`: main and the head built twice each, in turn; each driven
  once on the pinned SQLite, `-fsyntax-only` (status 0 on both) and `-c`
  (refused on both, status 1, at `sqlite3.c:31581`, an atomic store the
  backend doesn't support); then `ab --rounds 5` of `time-runs --runs 21` of
  `-fsyntax-only` and `time-runs --runs 11` of `-c`, the trees' order
  alternating by round. It was stopped after two rounds, since the `-c` list
  timed the refusal, not a compile.
- `scripts/ab2.sh`: three more rounds, `-fsyntax-only` alone.
- On the owner's laptop (AMD Ryzen 9 7940HS, Linux 7.3, clang 23.1.4), a
  checkout of `6c5b21a1` built with `./build.sh`
  (`logs-local/build.log`), then `test-fragments --no-fixtures --files-from
  repository-units.txt -march=native -Isrc -fwrapv -funsigned-char`, the 42
  sources `build.sh` compiles, preprocessed with its flags; and each source's
  first error from `-fsyntax-only` with the same options.

The `status` in `run.sh`'s progress lines is `date`'s, which expands after the
step (an error of the script), and `run2.sh`'s have none: each log was checked
by its contents instead. Every identity step that ran ends its log with
`test-fragments: 0 failures` (`run.sh`'s SQLite steps show their manifest's
failure), every benchmark log has its four paths' lines, and every process's
first pass found the four paths' results equal.

## Results

### Identity

| Inputs | Log | Units | The checker accepted | Fragment readings | Differences |
| --- | --- | ---: | ---: | ---: | ---: |
| `test-fragments`' fixtures | `identity-fixtures.log` | 45 | 30 | 540 | 0 |
| the parser's snippets | `identity-fixtures.log` | 96 | 62 | 1,152 | 0 |
| `test-checker`'s source fixtures | `identity-checker-fixtures.log` | 747 | 433 | 8,964 | 0 |
| SQLite (53,349 expressions) | `identity-sqlite-rerun.log` | 1 | 1 | 12 | 0 |
| the libc corpus | `identity-libc-libc-chunk-0[0-3].log` | 733 | 733 | 8,796 | 0 |
| the generated corpora | `identity-generated.log` | 2 | 2 | 24 | 0 |
| this repository's translation units (the owner's laptop) | `logs-local/identity-repository.log` | 42 | 2 | 504 | 0 |

A reading is one fragment mode (B and C; the interleave's AVX-512 path and its
scalar twin; 16-, 32- and 48-byte payloads) over one unit, compared column for
column with the postorder reader's result (`check_corpus_equal`). The
`47276329` series' identity logs give the same counts. The repository's 40
units the checker rejects stop at x86 rotate intrinsics it doesn't support yet:
23 at `_mm512_rol_epi32` in `x86_64_encoder.c`, 17 at `__builtin_rotateleft8`
in clang's `ia32intrin.h` (`logs-local/repository-first-errors.tsv`).

### The four paths

Each path's median over the processes of each process's median over its 21
passes, per token. Cycles, and the change from A:

| Corpus | Processes | A, postorder | B, prefix | C, fragments | D, sorted |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite | 5 | 883.5 | 1,302.3 (+47.4%) | 1,287.0 (+45.7%) | 757.5 (−14.3%) |
| the libc corpus | 3 | 514.8 | 585.6 (+13.8%) | 584.5 (+13.6%) | 390.9 (−24.1%) |
| long expressions | 3 | 828.3 | 1,249.7 (+50.9%) | 1,241.8 (+49.9%) | 719.2 (−13.2%) |
| small functions | 3 | 879.4 | 1,281.3 (+45.7%) | 1,267.6 (+44.1%) | 769.2 (−12.5%) |

The processes' medians of each path were within 0.56% (SQLite), 0.47% (libc),
1.03% (long expressions) and 0.85% (small functions) of each other. The
`47276329` series gave SQLite 887.3, 1,294.5 (+45.9%), 1,294.5 (+45.9%) and
762.8 (−14.0%). Instructions, the same in every process:

| Corpus | A, postorder | B, prefix | C, fragments | D, sorted |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 2,392.6 | 3,343.2 (+39.7%) | 3,321.7 (+38.8%) | 1,878.1 (−21.5%) |
| the libc corpus | 1,855.2 | 2,169.2 (+16.9%) | 2,167.7 (+16.8%) | 1,312.5 (−29.3%) |
| long expressions | 2,618.4 | 3,894.7 (+48.7%) | 3,868.5 (+47.7%) | 2,173.9 (−17.0%) |
| small functions | 2,483.7 | 3,402.8 (+37.0%) | 3,378.3 (+36.0%) | 1,987.9 (−20.0%) |

Nanoseconds:

| Corpus | A, postorder | B, prefix | C, fragments | D, sorted |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 161.2 | 237.0 (+47.0%) | 234.3 (+45.3%) | 141.6 (−12.2%) |
| the libc corpus | 100.2 | 113.4 (+13.1%) | 113.0 (+12.7%) | 80.9 (−19.3%) |
| long expressions | 151.5 | 228.0 (+50.5%) | 226.4 (+49.5%) | 134.4 (−11.3%) |
| small functions | 160.6 | 233.4 (+45.4%) | 230.9 (+43.8%) | 143.4 (−10.7%) |

With `--to-ir` (one process, SQLite), each run also checked the asm operands,
the initializers and the static data, built the checked program, selected its
reachable functions and lowered them to Tier 0's typed streams: A 1,230.7
cycles a token, B 1,639.8 (+33.2%), C 1,633.6 (+32.7%), D 1,103.1 (−10.4%).

### Phases

TSC ticks per token (3.8 GHz), the median over the processes:

| SQLite | A | B | C | D |
| --- | ---: | ---: | ---: | ---: |
| the parse, with the sink for B and C | 86.2 | 141.0 | 140.9 | 48.4 |
| the reader's index and state | — | 57.7 | 57.7 | — |
| the rest of `check_input` | 289.0 | 288.8 | 288.9 | 251.5 |
| the expressions' walk | 138.3 | 312.5 | 302.0 | 138.9 |
| `check_graph_run` | 97.7 | 98.1 | 98.0 | 97.6 |
| total | 611.3 | 898.1 | 887.6 | 536.4 |

| The libc corpus | A | B | C | D |
| --- | ---: | ---: | ---: | ---: |
| the parse, with the sink for B and C | 96.4 | 115.6 | 114.6 | 69.8 |
| the reader's index and state | — | 17.8 | 17.7 | — |
| the rest of `check_input` | 254.3 | 256.5 | 256.8 | 207.2 |
| the expressions' walk | 24.4 | 35.3 | 34.5 | 24.2 |
| `check_graph_run` | 5.1 | 5.2 | 5.2 | 5.0 |
| total | 380.1 | 430.4 | 428.8 | 306.4 |

| Long expressions | A | B | C | D |
| --- | ---: | ---: | ---: | ---: |
| the parse, with the sink for B and C | 85.5 | 153.8 | 153.2 | 48.7 |
| the reader's index and state | — | 59.9 | 60.2 | — |
| the rest of `check_input` | 253.4 | 253.6 | 254.5 | 225.8 |
| the expressions' walk | 81.4 | 241.4 | 236.2 | 82.1 |
| `check_graph_run` | 154.2 | 154.7 | 155.3 | 154.1 |
| total | 574.5 | 863.5 | 859.4 | 510.7 |

| Small functions | A | B | C | D |
| --- | ---: | ---: | ---: | ---: |
| the parse, with the sink for B and C | 81.0 | 126.3 | 126.4 | 45.9 |
| the reader's index and state | — | 58.9 | 59.0 | — |
| the rest of `check_input` | 300.5 | 300.9 | 301.6 | 269.2 |
| the expressions' walk | 107.5 | 280.5 | 270.7 | 108.7 |
| `check_graph_run` | 119.5 | 118.3 | 118.4 | 119.5 |
| total | 608.5 | 885.0 | 876.1 | 543.2 |

With `--to-ir` on SQLite, the IR took 234.5, 235.4, 235.3 and 233.9 ticks a
token in A, B, C and D.

### Counters

Per token, one process each (`pipeline`'s are the five SQLite processes'
medians):

| Event | Corpus | A | B | C | D |
| --- | --- | ---: | ---: | ---: | ---: |
| ops retired | SQLite | 2,080.6 | 2,887.6 | 2,868.1 | 1,644.8 |
| slots without ops from the frontend | SQLite | 1,658.3 | 2,188.2 | 2,120.4 | 1,365.7 |
| slots the backend stalled | SQLite | 2,745.9 | 4,596.9 | 4,593.7 | 2,542.8 |
| branches | SQLite | 456.88 | 650.90 | 646.15 | 356.68 |
| branch mispredictions | SQLite | 5.24 | 6.41 | 6.31 | 4.38 |
| taken branches | SQLite | 263.29 | 322.70 | 319.85 | 197.17 |
| branches | libc | 345.71 | 403.81 | 403.49 | 241.64 |
| branch mispredictions | libc | 2.13 | 2.46 | 2.42 | 1.63 |
| taken branches | libc | 189.71 | 214.00 | 213.82 | 124.88 |
| demand fills from L2 | SQLite | 4.43 | 5.73 | 5.74 | 5.27 |
| demand fills from the CCX | SQLite | 0.25 | 0.28 | 0.29 | 0.28 |
| demand fills from DRAM | SQLite | 1.83 | 3.06 | 3.10 | 1.98 |
| `stli_other` | SQLite | 8.31 | 12.96 | 12.90 | 7.98 |
| slots the power cap took | SQLite | 11.69 | 19.26 | 22.45 | 12.78 |
| `fp_sch_rsrc_stall` | SQLite | 0.57 | 0.58 | 0.60 | 10.77 |

Those processes' cycles a token: branches 887.8, 1,299.1, 1,297.6 and 760.6
(SQLite) and 514.7, 586.3, 584.7 and 392.5 (libc); stalls 889.5, 1,295.5,
1,300.6 and 761.7; memory 887.8, 1,284.2, 1,292.6 and 760.6.

### The sink's options

On SQLite, one process each: the interleave's scalar twin decoding C's windows,
886.7, 1,284.1 (+44.8%), 1,292.7 (+45.8%) and 760.0 (−14.3%) cycles a token;
48-byte payloads, 891.6, 1,291.4 (+44.8%), 1,296.7 (+45.4%) and 765.6
(−14.1%), the hot records 4.2 bytes a token instead of 2.2 and 0.874 fragments
an expression instead of 0.896.

### Memory

Per token, from each process's first pass (the same in every process):

| Storage | SQLite | libc | Long expressions | Small functions |
| --- | ---: | ---: | ---: | ---: |
| the tree and the postorder (every path) | 17.0 | 17.0 | 17.0 | 17.0 |
| the sink's syntax records, kinds and expressions | 74.8 | 73.2 | 73.0 | 75.5 |
| the sink's hot records, used | 2.2 | 0.1 | 1.0 | 1.9 |
| the identities of the positions used | 1.9 | 0.1 | 3.2 | 1.7 |
| the reader's index | 25.0 | 25.0 | 25.0 | 25.0 |
| the walk's state, B | 103.3 | 67.6 | 64.0 | 117.1 |
| the walk's state, C | 93.3 | 57.6 | 54.0 | 107.1 |
| the sink's arena, all of it | 390.0 | 390.2 | 390.0 | 390.0 |
| events of the cursor | 1.918 | 0.112 | 3.148 | 1.858 |

The index's temporary storage peaked at 9,185,631 bytes (SQLite), 456,235
(libc), 9,102,730 (long expressions) and 9,868,664 (small functions); the
deepest nesting of pending frames was 2,568, 2,786, 1,175 and 11.

### The default paths, main against the head

`-fsyntax-only` of the pinned SQLite, 21 runs per tree and round after a
warm-up, CPU 2 (`time-runs`; status 0 in every run):

| Round | main | head |
| --- | ---: | ---: |
| `ab.sh` 1 | 147.590 ms | 147.438 ms |
| `ab.sh` 2 | 147.707 ms | 147.427 ms |
| `ab2.sh` 1 | 147.341 ms | 147.397 ms |
| `ab2.sh` 2 | 147.293 ms | 147.902 ms |
| `ab2.sh` 3 | 146.999 ms | 147.366 ms |
| median of the rounds | 147.341 ms | 147.427 ms (+0.06%) |

The head's peak resident set was 0.8 MB higher (599,2xx KB against 598,4xx)
with 19 fewer minor faults (1,432 against 1,451) in every round. The removal
changes no code these paths run but the dispatch, which no longer asks the
fragments' unit for the command, so this is the executable's layout: on the
owner's laptop the same two trees went the other way, the head 4.2 MB lower
with 14 more faults.

## Limitations

- Only the scalar recognizer had the sink: B and C are the scalar parse with a
  second output. A vector parser emitting fragments wasn't built; it would
  still have to build the tree the checker reads (the decision record's "Why
  the tree stayed"), so it would add to D's work rather than replace it.
- B and C's walk includes the reader's own checks (its visit ledger, owners and
  kinds), which a production reader might drop; the operand check against the
  tree, `test-fragments`' own, was off. The decision doesn't rest on the walk:
  with a walk that cost nothing, B and C would still take 392.8 and 391.7 ticks
  a token on libc against A's 380.1.
- The counter sets and the sink's options ran one process each; their cycles
  agree with the pipeline processes' medians within 1.4%.
- The generated corpora are synthetic, made to bracket the real ones: one
  expression of thousands of operators per function, and thousands of small
  functions.
- `-c` refuses the pinned SQLite on main and on the head, so the default paths'
  A/B times `-fsyntax-only` only. `ab.sh`'s two rounds timed the refusal too
  (main 159.907 ms, the head 159.547 and 160.715), which this record doesn't
  count.
- The lock's queue interleaved these runs with other sessions' and CI jobs'.
  Each run had the machine alone, and a process's passes rotate the paths, so
  the paths' comparison within a process sees one state of the machine.

## Files

- `README.md`: this.
- `scripts/`: `run.sh`, `rerun-sqlite-identity.sh`, `run2.sh`, `ab.sh` and
  `ab2.sh`, as they ran.
- `tools/`: `generate.c` (`cc -O2 -o generate generate.c`, then `generate long
  107` and `generate small 107`) and `summarize.c`.
- `inputs/`: `sqlite3.sha256`, `generated.sha256`, `libc.txt` and
  `libc.sha256`.
- `manifests/`: `tree-7808e811.sha256`, `tree-47276329.sha256`,
  `main-e04462c1.sha256` and `head-measured.sha256`.
- `logs-7808e811/`, `logs-47276329/` and `logs-ab/`: every step's log and the
  progress files; `logs-local/`: the laptop's build, the repository's units
  (`repository-units.txt`), their identity (`identity-repository.log`) and
  their first errors (`repository-first-errors.tsv`).

Lock-wait lines of the shared lock's script (`exclusive.sh: waiting for the
9700X, held by: ...`, the owner's command and its `title:`, `link:` and `pull
request:` lines) and the laptop's core queue (`cores: ...`), which name other
sessions' work, were removed from the logs; nothing else was edited.
