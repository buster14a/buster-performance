# #2924 C12c-3: the checker's schedule keeps its vector path alone

The checker's node schedule loses its scalar twin, `CheckOptions.scalar`: the per-node validator, the regions' scan's
node-at-a-time tail, the discard shortcut's condition, the warning contexts', reports', resource and constant
contexts' node-at-a-time arms, and the flag that `check_graph_node_action`, `check_graph_guarded_node`,
`check_graph_scalar_node`, `check_graph_query_runtime`, `check_graph_overload_call` and `check_transition_statics`
passed on. C12c's area gate ([`../c-checker-gate`](../c-checker-gate)) had the whole core at bit 14; this record has
the census of which of these sites the corpora reach, the core split into four areas (`c_checker.c`'s knobs at bit
29), the split by unit size, and the deletion's run, mutants and local tests.

Every run on the 9700X is under the lock, timings on CPU 2. The gate's executables are C12c's knob builds
(`compiler-areas<mask>`, the mask read from the executable's own name).

## Census (`census/`)

`census.patch` makes `BUSTER_SCALAR_PATH` and `BUSTER_VECTOR_PATH` count each use by file and line on main
`198a76539`; `census.sh` runs `-c --lanes 1` of sqlite3.c, Lua's units, musl's units and buster's `main.c` (the
complete driver) by default, with `-Wall -Wextra` and with `--scalar`, `BUSTER_PATH_CENSUS=FILE` collecting the counts
at exit. `table.py sites.tsv logs` prints `census-table.txt` for this deletion's 21 sites (C12c's `sites.tsv` rows of
`c_checker.c`, the query runtime and the transitions), each cell the scalar arm's count over the other's.

- By default and with the warnings on every count is the vector arm's; with `--scalar` every count is the scalar
  arm's.
- The node loop (`c_checker.c:4206`) runs 323,623, 93,759, 774,130 and 3,256,630 times on the four lists; the scans
  after it (query runtime, warning contexts, reports, constant contexts) once a graph, the resource scan twice.
- Not reached on any list: the validator (`c_checker.c:4087`; production graphs bring their recorded facts, and only
  `--verify` validates them again), the regions' scan and its call (2084, 4219: the regions are an option no default
  takes), the overload call (3159: C has no overload candidates), the query runtime's replay (`c_check_query_runtime.c:840`)
  and the transitions' statics (`c_check_transitions.c:218`, only with `--check-transitions`). `action.scalar =
  scalar` (3126) is an assignment the census doesn't count.

## The split core (`split/`)

`split.sh` takes C12c's knob tree (main `1962b1f73` with `c12c-areas-knob.patch`) and moves bit 14's knobs:
`c_checker.c`'s 12 to bit 29, the initializers' 3 (`c_check_initializer.c`, `c_check_init_history.c`) to bit 30, the
attributes', generic selections' and static selections' 8 (`c_check_attribute.c`, `c_check_generic.c`,
`c_check_select.c`) to bit 31; the rest of the core stays bit 14. One Release build; every timed build is a hard link to
one fresh copy of it, named for its mask (`logs/build.log`, `logs/status.txt`).

**Whole lists:** `ab`, three rounds, around `time-runs` (three runs) of no bit, each bit, the four together and no bit
again, `-c --lanes 1` (`logs/time-*.log`). User cycles against no bit, each round:

| Bits | sqlite3.c | Lua's units | musl's units |
| --- | --- | --- | --- |
| 14, the rest of the core | +3.89%, +3.92%, +3.59% | +2.18%, +1.72%, +1.96% | +1.48%, +1.64%, +1.58% |
| 29, `c_checker.c` | +3.60%, +3.28%, +3.05% | +1.81%, +1.71%, +1.78% | +1.72%, +2.13%, +1.29% |
| 30, the initializers | −0.16%, −0.07%, −0.28% | +0.23%, −0.15%, +0.25% | +0.28%, +0.39%, −0.32% |
| 31, attributes and selections | +11.16%, +11.18%, +11.45% | +1.36%, +1.46%, +1.61% | −0.18%, −0.10%, +0.01% |
| all four | +19.04%, +18.96%, +18.43% | +5.60%, +5.18%, +5.04% | +3.54%, +3.34%, +2.96% |
| no bit again | −0.58%, −0.18%, −0.51% | −0.07%, −0.31%, +0.07% | +0.14%, +0.35%, −0.22% |

**By unit size:** musl's 447 units below 8,000 preprocessed bytes, each a command of its own, one locked `time-runs
--runs 9` of no bit, bit 29, bit 30 and no bit again (C12c-2's `units3.sh` method: hard links of one fresh copy;
`logs/units.tsv`, a line a unit: path, bytes, status, then each build's cycles and instructions). Pooled user cycles
against no bit, and instructions:

| Preprocessed bytes | Units | Bit 29 | Bit 30 | No bit again | Instructions, bit 29 |
| --- | --- | --- | --- | --- | --- |
| below 1,000 | 9 | +0.62% | +0.29% | +0.19% | +2.05% |
| 1,000 to 2,000 | 42 | +0.48% | +0.21% | +0.13% | +0.91% |
| 2,000 to 4,000 | 86 | +0.45% | +0.16% | −0.01% | +1.12% |
| 4,000 to 8,000 | 310 | +0.43% | +0.08% | −0.03% | +0.98% |
| all | 447 | +0.44% | +0.10% | −0.02% | +1.00% |

Bit 29 ran more instructions in every unit, and read above both no-bit runs in 293 of the 447 and below both in 44.
The vector path is the faster at every size measured. This deletion takes bit 29's sites and the two of bit 14's that
pass its flag on (the query runtime's and the transitions', reached by neither default); bits 30 and 31 and the rest of
14 are later pieces.

## The arms no list reaches (`verify/`)

Three of the deleted arms run on none of the census's lists, so bit 29's numbers say nothing of them:

- **The regions' scan's tail** (`check_graph_marked_end`'s node-at-a-time loop when its flag is set): on main the
  regions run only where the schedule isn't scalar (`c_checker.c:4203`, `regions = !BUSTER_SCALAR_PATH(options->scalar)
  && ...`), and the scan is called inside them with that same flag (4219), so no compile took the arm; only tests
  did.
- **The transitions' statics' per-node arm** (`check_transition_statics(..., scalar)`): its one caller outside the tests
  passes `false` (`c_check_transitions.c:1009`), and the transitions too run only where the schedule isn't scalar
  (4190). Tests alone took it.
- **The per-node validator** (`check_graph_validate` before the rename): `--scalar` took it on a graph without its
  recorded facts or with `--verify`. `verify.sh` copies the split's knob tree, moves the validator's knob alone to bit 0
  (unused: `logs/status.txt` has the line), and compares no bit, bit 0 and no bit again with `-c --lanes 1 --verify`:
  the objects, 1,371 of 1,371 the same; then `ab`, three rounds, around `time-runs` (three runs). User cycles against no
  bit, each round:

  | List | Bit 0, the scalar validator | No bit again | Instructions, bit 0 |
  | --- | --- | --- | --- |
  | sqlite3.c | +2.11%, +2.07%, +1.85% | +0.23%, +0.02%, +0.29% | +3.36% |
  | Lua's units | +1.07%, +1.29%, +0.98% | −0.00%, +0.17%, +0.03% | +1.81% |
  | musl's units | +0.88%, +0.98%, +1.09% | −0.15%, +0.23%, +0.19% | +2.15% |

## The deletion (`deletion/`)

`run.sh`: base `827a4d179` (the stream digests, the twins present) against head `2563250a1` (the deletion), both on
main `198a76539`, from a bundle of the branch; Release. The PR's commits, `2ca88b353` (tests) and `498b2f3a7` (the
deletion) on main `eacca00de`, are these with the mutation round's three tests and the digests' byte flips folded into
the tests commit, the tests' locals that named the scalar schedule renamed, and the corpus's two empty options written
`{ 0 }`, rebased: their production code is head's but for those two initializers, and main's new commits touch none of
their files.

**Objects** (`logs/status.txt`): `-c --lanes 1` of sqlite3.c, Lua's units, musl's units and buster's `main.c` (the
complete driver) by base and head, with `-Wall -Wextra` by default, with `--scalar` and with `--tier1`, and with no
warning option: 1,372 objects each, 0 differ. Head's `--scalar` objects, and its objects with no warning option,
against base's warnings-on objects: 1,372 of 1,372 identical. The comparison's control, head's `--tier1` objects
against them, finds 1,293 of 1,372 differ.

**Stderr:** `run.sh` compared it with the lock's wait message in it, which one run had and another hadn't, and removed
the files; `stderr.sh` ran the same commands again, kept them (`logs/stderr/`) and dropped the lines starting
`exclusive.sh: `, but the message's `title:` and `link:` lines stayed (`logs/stderr-status.txt`'s DIFFERs). Without
those too, every mode's base and head are the same bytes: with the warnings on 25, 0, 4,865 and 74 lines on the four
lists (with `--scalar` and `--tier1` the same), with no warning option 0, 0, 1,554 and 0.

**Whole compiles:** `ab`, three rounds, around `time-runs` (three runs of three copies) of base, head and base again
(`logs/time-*.log`). User cycles against base, each round:

| List | Head | Base again | Instructions, head against base |
| --- | --- | --- | --- |
| `-c -Wall -Wextra` sqlite3.c | +0.21%, −0.22%, +0.22% | +0.47%, +0.28%, +0.09% | 0.098 M fewer (of 1,555.02 M) |
| `-c -Wall -Wextra` Lua's units | +0.10%, +0.13%, +0.23% | +0.03%, +0.14%, +0.05% | 0.040 M fewer (of 875.89 M) |
| `-c -Wall -Wextra` musl's units | −0.23%, −0.05%, +0.05% | −0.00%, +0.18%, +0.12% | 1.326 M more (of 8,217.19 M) |
| `-c` sqlite3.c | +0.15%, +0.36%, +0.07% | +0.08%, +0.31%, +0.07% | 0.097 M fewer (of 1,343.10 M) |

The runs' minor faults: within one of base's on every list.

**The start section** (`logs/start-*.txt`): the same 565 functions in base and head. Head's functions outside it that
base hasn't (`logs/functions-*.txt`): `check_graph_validate_consumed` and `check_transition_static`, now called from the
tests' definitions too and no longer inlined (neither ran on the census's lists: the validator runs on a graph
without its recorded facts or with `--verify`, the statics only with `--check-transitions`), and the tests' two definitions; base's that head hasn't: `check_graph_validate_lists`,
now inlined, and `check_graph_validate_vector`, renamed `check_graph_validate`.

## Mutants (`mutation/`)

Nine mutants of the vector code whose twins this deletes (`run.py`'s list), each applied to an archived copy of the
deletion's tree (`82d4a4e4a`), built, and run against `test-checker`'s eight parts and `test-checker-driver`'s eight
(`results.txt`), every test under a timeout.

- **Killed:** the warning contexts' scan dropping each block's last warning (m2, the driver's first and second parts),
  the reports' scan dropping each block's last diagnostic (m3, `test-checker`'s first and fourth and the driver's second
  to eighth), the discard shortcut taking an lvalue too (m6, every `test-checker` part), a leaf with an overload set
  completing as a plain leaf (m7, the first part, by the graph tests), the transitions' statics dropping each block's
  last eligible node (m8, the fifth, by the statics' definition) and the validator's blocks letting an operand equal its
  node (m9, the first, by the validator's definition).
- **Survived:** the regions' scan never reading a block's last mark (m1), the resource scan dropping each block's last
  lane (m4) and the constant contexts' skip test ignoring bit 0, the only bit a mark has (m5): no fixture's region,
  exhausted node or marked block reached them.
- **`rerun.py`** (an archived copy of the branch, `94f2d919d`, with the three definitions the tests commit gained for them:
  `check_test_graph_marked_end`, `check_test_graph_resource_node` and `check_test_graph_constant_contexts`, in
  `test-checker`'s first part; `rerun.txt`): the unmutated tree passes (303,830 checks, 0 failures), and m1, m4 and m5
  each fail it (1 failure).

All nine are killed. `logs.tar.gz` has every run's build and test logs.

## Local tests (cloud container, `local/`: the scripts, their statuses and summaries)

On the PR's head `498b2f3a7` (main `eacca00de`):
- `test-checker`'s eight parts (Develop), 0 failures, with the digests' byte flips: 11,965 flips the stream comparison
  saw, each changing the digest (`flips-parts.txt`). Their control, the digest without the diagnostic operands, fails
  the first part on five sites' flips of those operands (`flips-control.txt`);
- **AddressSanitizer** (vector host): the same eight parts with the byte flips, 0 failures and no sanitizer report.

On `b89e93ca9`, the head before the byte flips (a test-only change):
- **MemorySanitizer and AddressSanitizer** (vector host): `test-checker`'s eight parts and `test-checker-driver`'s
  first and second, 0 failures and no sanitizer report;
- the self-check of `main.c`, and the complete driver's (`-DBUSTER_COMPLETE_DRIVER=1`), `-fsyntax-only -Wall -Werror`;
- the ownership check, on a Release build with CI's toolchain (637 fixture paths, 63 exact shared exceptions);
- `test-checker --seed 133` in one process, not parted: 2,089 cases with a line, 0 without, 0 failures; and parts 1
  and 5 with `--seed 7`: 771 and 71 cases with a line, 146 and 0 without (graphs only that seed draws), 0 failures, so
  no key gave another digest (`order-*.txt`);
- the six blocks of `tools/ci/correctness.tests` the subset below left out: the integer builtins' fourth part (no
  checker word) and the two c-testsuite blocks (`extra-blocks.log`), and the three on the frozen corpora, on a copy of
  the 9700X's corpus (headers, SQLite, musl) with clang 23.1.4 (`corpus-blocks.log`): all pass.

On `091c03048`, the same commits before the tests' locals were renamed (identifiers, five messages and two comments,
in test files alone):
- the 27 blocks of `tools/ci/correctness.tests` that run a checker test and need no corpus, through the `parallel`
  runner with clang 23.1.4 first on `PATH`: all pass (366.0 s); then the two that compile the complete driver's `main.c`
  (`test-checker-corpus` against clang, and `-c --verify` by both paths with the objects compared), one at a time: both
  pass.

The tests commit alone (the twins present), `test-checker`'s eight parts and all eight of `test-checker-driver`'s, 0
failures: on `edcc1b213` (before the rename), `5913f3dc9` (before the byte flips) and the PR's `2ca88b353`.
