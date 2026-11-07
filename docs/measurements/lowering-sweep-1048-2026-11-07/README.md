# The statement sweep over evaluated nodes (#1048), 2026-11-07

Buster issue [#1048](https://github.com/buster14a/buster/issues/1048) asks for the C lowering's `lower` stage to come
down toward Tier 0's time. It blames the tasks' push, pop and dispatch for each node. This record measures a design that
removes them for most nodes: a two-pass sweep over each statement's evaluated nodes. The sweep is exact but slower than
the tasks. A variant that walks the nodes without the lowering rules shows why: the rules themselves cost about as much
as the tasks' whole loop. Buster's `docs/c-lowering.md` ("The statement sweep over evaluated nodes") cites this record.

Every timing here is from the approved Ryzen 7 9700X (`benchpress`), under the shared lock, each run pinned to CPU 2.
The correctness checks and the operation counts were made on the session's Ryzen 9 7940HS (Zen 4), off-host.

## Sources

`manifests/identities.txt` has the revisions, the executable's and the input's SHA-256, the toolchain and the host.

- The base is Buster's main at `87ef05501cf011c5bbf1f5fe112d66f97b9674cf`.
- The sweep is commit `83f2cad3827ee757fa15ff2fad087dfd9731e69d` on buster14a/buster's branch
  `opencode/1048-lowering` (`c_check_program_sweep.c`, `c_check_program_sweep_test.c` and their wiring). The branch's
  next commit removes it, so it survives only in that history.
- The measured tree is the base with `patches/measured.patch` applied. It is the sweep's commit plus two run-time
  toggles, each marked `TEMPORARY`, which let one build run all three variants:
  - `BUSTER_NO_SWEEP_EXPERIMENT` turns the sweep off. The tasks then lower everything, as on main.
  - `BUSTER_SWEEP_SKELETON` (the "walk") runs the sweep's first pass with each node's rules replaced by its op, its
    type's class and its first two operands marked. It discards the result, so the tasks then lower every statement.
- Build: `BUSTER_DEBUG_INFO=0 BUSTER_HOST_ARCH=znver5 ./build.sh` (clang 23.1.1), under the lock.
- Input: SQLite 3.53.4's amalgamation, `sqlite3.c`, with `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0
  -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I<its directory>`.

## What the sweep does

For each expression statement, branch, plain return and scalar local's one-value initializer, on the vector path:

1. **First pass, from the root down.** It finds each evaluated node by a bitset of distances below the root. The node
   writes its own entries, then its conversion's, into a slot. It gives each operand its context, its conversion's
   target and its ancestors' calls. A node the sweep can't take is a task node: `&&`, `||`, `?:`, an update, a
   bit-field's access, an aggregate's, a builtin, and others.
2. **Second pass, from the lowest node up.** It copies the slots in node order. It drains each task node's expression
   task in its place, and puts each call's row where the tasks' preorder would.

The tasks' loop remains the exact rules and is the scalar path's lowering. `test-lowering-sweep` compares the two
lowerings function by function (7940HS):

| input | functions | the same | evaluated nodes | swept |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 2,670 | all | 267,012 | 79.75% |
| Lua 5.4.8's 34 units (`-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX`) | 1,104 | all | 67,573 | 72.79% |
| c-testsuite's subset of 220 (at `5c727565`) | 430 | all | 8,657 | 84.82% |

The default compile's object of `sqlite3.c` was byte-identical to `--scalar`'s. `test-checker` passed, with 804,087
checks, including the sweep's fixtures.

## Runs

**`scripts/rounds.sh`** (`9700x/rounds.txt`): one lock hold, seven rounds. Each round runs `-c --time-stages` of
`sqlite3.c` once for each variant (tasks, sweep, walk), in that order. Medians of the seven, in ms, with ranges in
brackets:

| row | tasks | sweep | walk |
| --- | ---: | ---: | ---: |
| `lower` | 10.611 [10.468 to 10.775] | 12.185 [12.132 to 12.330] | 12.157 [12.038 to 12.550] |
| `lower.statements` | 6.943 [6.846 to 7.032] | 8.516 [8.452 to 8.600] | 8.460 [8.294 to 8.796] |
| Tier 0 | 5.216 | 5.225 | 5.231 |

Every sweep round was above every tasks round.

**`test-lowering-sweep --passes 25`** (`9700x/harness.txt`): three runs, each in its own lock hold. Each pass times a
warm whole lowering of the selected program by the tasks and with the sweep, alternating which goes first.

| run | tasks | sweep | sweep / tasks |
| --- | ---: | ---: | ---: |
| 1 | 8.866 ms | 10.168 ms | 1.147 |
| 2 | 8.984 ms | 10.329 ms | 1.150 |
| 3 | 8.970 ms | 10.317 ms | 1.150 |

## What the walk shows

- **The walk alone costs about 1.5 ms.** The walk variant's statements row is 8.460 ms against the tasks' 6.943. That
  is the cost of a walk over every statement's operand tree, with its marks, slots and clears. It even warms the
  caches for the tasks that run after it.
- **The rules cost as much as the tasks' whole loop.** The sweep's row (8.516 ms) is the walk's cost plus the rules for
  80% of the nodes, the second pass and the tasks for the other 20%. That sum is 7.0 ms, about the tasks' entire
  6.94 ms, push, pop and dispatch included.
- **Operation counts agree (7940HS, IBS op sampling).** Both designs dispatch about 400 to 450 macro-ops per evaluated
  node. The compile's user instructions were 1,323.6 M with the sweep and 1,322.2 M without it.

## What the tuning changed

On the 7940HS, these took the sweep / tasks ratio of `test-lowering-sweep --passes 20` from 1.30 to between 1.11 and
1.18, never below 1:

- The states are found by a bitset rather than by 64-byte vector loads. Those loads waited for the byte stores before
  them to retire.
- Each slot's kinds and classes are written and read as whole words.
- The writer's columns are no longer copied once per statement.
- A statement with no calls and no task nodes copies its slots alone in the second pass.
- Every common op's case is in the first pass, rather than in an out-of-line function that had taken 45% of the nodes.

## Limitations

- These are one input and one host's timings, from a single build with run-time toggles.
- The walk discards its result and then lets the tasks run, so it measures the walk's cost with the caches it warms.
- The 7940HS operation counts are off-host, and show only the shape of the work.
