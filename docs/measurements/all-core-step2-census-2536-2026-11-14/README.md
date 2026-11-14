# The candidates of a selection after the windows (buster#2536, step 2.1, 2026-11-14)

Step 2 of the all-core design chains a window's bodies from the graph's run to their code. Its finding: the lowering
numbers the selected symbols densely, and the selection walks every body's references, so a window that lowers before
every body's references are known needs a provisional numbering over candidates, the exact selection in the epilogue,
and a remap in the merge. This record is that numbering's census: how tight and how cheap candidates found before the
windows can be.

The executable is buster `abfe45e846e9e511947192a3a1e0296fc9cf510a` (`raw/commit.txt`), on main `c471f32f`: a Release
build under the 9700X's lock (`raw/9700x/build.log`, with its SHA-256). Its `--selection-census` reports, beside each
unit's exact references, three supersets:

- **the walk**: `check_program_references` from every expression root of a body (a node no node takes as an operand),
  its automatic objects' plans and its cleanups, rather than from the controls it reaches;
- **the scan**: one pass over the graph's VALUE nodes, every object of static storage that a body's tokens name;
- **the pruned scan**: the scan less the nodes under the operands the walk leaves out (sizeof's and `_Alignof`'s, a
  constant condition's of `&&`, `||` and `?:`, a computed call's callee) and less the constant `if`s' arms and
  conditions that the control writer leaves out (its `dropped_ranges`).

For each: the bodies whose candidates' references differ from their own, those whose candidates miss one (none, for a
superset), the selection over them against the exact one, by how many bodies and symbols more it keeps, and its TSC
ticks against the references pass's (`check_program`'s per-body `check_program_references` and its sort).

**In short.** All three are supersets on every corpus. The walk and the scan keep 756 more bodies than `main.c`'s exact
selection (1,398), from the constant `if`s of its commands' `else if` chain; the pruned scan keeps no extra body on any
corpus, only symbols: 10 on `sqlite3.c`, 156 on `main.c`. So a provisional numbering differs from the exact one in the
large units, and the remap, not a recompilation, is the normal path. On `sqlite3.c` the pruned scan costs 1.55 ms
(0.44 times the references pass's 3.52 ms; 1.3% of a 122.7 ms compile), the walk 5.29 ms (1.50 times).

## What was run

`scripts/run.sh`, as a user unit on the host: the build, then one hold of the lock a corpus for `scripts/census.sh`
(every unit's `--selection-census -c --lanes 1` on CPU 2), then one hold a file for `scripts/repeat.sh` (`sqlite3.c` and
`main.c` by the census and by a plain `-c`, alternating, 7 runs each, the plain ones counted by `perf stat` with
`msr/tsc/`). The corpora are step 1's: `sqlite3.c`, Lua's 34 sources, c-testsuite's 220 programs, `main.c` (the
census commit's) and musl's 1,336 units. Each unit's line is in `raw/9700x/NAME.txt`; `scripts/tally.sh` sums them.

## The census

| corpus | units | bodies | exact: bodies, symbols | walk: units off, extra bodies, symbols | scan: the same | pruned scan: the same |
| --- | ---: | ---: | --- | --- | --- | --- |
| `sqlite3.c` | 1 | 2,674 | 2,668, 6,951 | 1, 0, 2 | 1, 0, 13 | 1, 0, 10 |
| `main.c` | 1 | 8,621 | 1,398, 49,589 | 1, 756, 4,335 | 1, 756, 4,983 | 1, 0, 156 |
| Lua | 34 | 1,097 | 1,097, 4,769 | 0, 0, 0 | 16, 0, 73 | 0, 0, 0 |
| c-testsuite | 220 | 449 | 430, 2,116 | 8, 0, 58 | 9, 0, 60 | 4, 0, 34 |
| musl | 1,336 | 18,584 | 2,756, 8,754 | 60, 108, 121 | 139, 190, 329 | 12, 0, 54 |

"Units off": units whose selection over the candidates isn't the exact one. No body of any corpus has a reference its
candidates miss, by any of the three. The symbols counted are the program's and its data's.

- **The constant `if`s decide the tightness.** `main.c`'s `main_command` is an `else if` chain whose conditions start
  with `BUSTER_IN_UNIT(...)`, a constant 0 in the driver's unit (`main.c` alone) for a command another unit holds; the
  walk and the scan keep those arms' calls and their call trees (the debug build below names ten:
  `run_assembler_command`, `run_tier1_select_benchmark` and eight more `run_` functions). musl's are `FORCE_EVAL`'s and
  `a_or_l`'s `if (sizeof(x) == sizeof(float))` and kin.
- **Then the constant `?:`s.** Less the `if`s' arms alone, musl still kept 82 bodies in 59 units: `isnan`, `signbit`
  and `a_ctz_l` choose a width by a constant `?:` whose other arm calls `__FLOAT_BITS`, `__DOUBLE_BITS` or
  `a_ctz_32` (`raw/local-arms-only/`, an intermediate build in a cloud container; its `arms` column is that variant).
- **What stays is symbols:** operands no node takes once the checker has folded the node that did, a string literal
  under `sizeof` or a function in `_Generic`'s other association. A walk of the debug build printed each extra
  reference (`raw/local-debug/NAME.extra`: body, name, token kind, whether the body has a dropped arm; kind 5 is a
  string literal), from `scripts/local-walk-debug.patch`, an earlier form of the walk census with debug prints, in a
  cloud container.

## The cost

| file | references pass | walk | scan | pruned scan | the plain compile |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 3.52 ms | 5.29 ms (1.50) | 1.22 ms (0.35) | 1.55 ms (0.44) | 122.7 ms |
| `main.c` | 7.48 ms | 13.61 ms (1.82) | 3.50 ms (0.47) | 4.37 ms (0.58) | 695.6 ms |

Medians of 7 runs (`raw/9700x/NAME.repeat.txt`, `NAME.plain.N.csv`), TSC ticks at 3.7925 GHz (`msr/tsc/` over the
task clock of the plain runs). The plain compile is its task clock. The walk finds its roots in the tokens' node chains,
which costs about what the walk does. The pruned scan's ticks don't count the finding of the constant `if`s, whose
ranges it takes from the writer; a pass before the windows must find them itself. The objects by the census and by the
plain compile are the same bytes (`raw/9700x/NAME.same.txt`).

## Files

`raw/9700x/`: the census's lines, the repeats, the plain runs' counts, the holds' log and the build's. `raw/local-*`:
the cloud container's runs above. `scripts/`: every script as run (`local-census.sh` the cloud's). `SHA256SUMS`: every
file's hash.
