# The candidates' pass before the bodies' controls (buster#2536, step 2.2a, 2026-11-14)

Step 2's census ([`all-core-step2-census-2536-2026-11-14`](../all-core-step2-census-2536-2026-11-14/)) chose the
pruned scan as the candidates of a selection before the windows. It took its constant `if`s from the control writer,
which runs in the bodies' loop that step 2 moves into the windows. Step 2.2a's pass finds them itself, before the loop:
`check_program_constant_arms` scans the ops for the `if` conditions that are constant integer rvalues or statement
expressions, then, in those bodies alone, sets the body's children up and takes the writer's own test. The pruned scan
then runs from the bodies' openings. `--selection-census` reports it as a fourth census, "pass", timed with its finding.

The executable is buster `0d49bae97a683641ad4b47dc86ce27c45c40c7c7` (`raw/commit.txt`), on main `21e0d999`: a Release
build under the 9700X's lock (`raw/9700x/build.log`, with its SHA-256).

**In short.** The pass's candidates are the arms census's on every corpus: the same bodies differ, none misses a
reference, and its selection keeps the same 10 extra symbols on `sqlite3.c`, 156 on `main.c` and no extra body anywhere.
On `sqlite3.c` it costs 1.92 ms, 0.57 times the references pass's 3.35 ms and 1.6% of a 123.3 ms compile (the arms
census, without the finding, 0.44 times). On `main.c` it costs 4.53 ms, 0.61 times.

## What was run

As step 2.1's record ran (`scripts/run.sh`, a user unit on the host): the build, then one hold of the lock a corpus for
`scripts/census.sh`, then one hold a file for `scripts/repeat.sh` (`sqlite3.c` and `main.c` by the census and by a plain
`-c`, alternating, 7 runs each, on CPU 2). The report is now two lines, the counts and the ticks, which the scripts join
into one line a unit. `scripts/tally.sh` sums them.

## The census

| corpus | exact: bodies, symbols | arms census: units off, extra bodies, symbols | pass: the same | units' bodies with a dropped arm |
| --- | --- | --- | --- | ---: |
| `sqlite3.c` | 2,668, 6,951 | 1, 0, 10 | 1, 0, 10 | 9 |
| `main.c` | 1,398, 49,597 | 1, 0, 156 | 1, 0, 156 | 2 |
| Lua (34) | 1,097, 4,769 | 0, 0, 0 | 0, 0, 0 | 0 |
| c-testsuite (220) | 430, 2,116 | 4, 0, 34 | 4, 0, 34 | 19 |
| musl (1,336) | 2,756, 8,754 | 12, 0, 54 | 12, 0, 54 | 261 |

The differing bodies are the same too (39, 132, 8, 6 and 14), and so the arms census's and the pass's lists are. The
pass keeps a constant `switch`'s dead cases, which the writer leaves out; no corpus has one whose dead case names an
extra symbol. buster's test shows that difference on a fixture.

## The cost

| file | references pass | arms census | pass (with its finding) | the plain compile |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 3.35 ms | 1.47 ms (0.44) | 1.92 ms (0.57) | 123.3 ms |
| `main.c` | 7.42 ms | 3.99 ms (0.54) | 4.53 ms (0.61) | 694.0 ms |

Medians of 7 runs (`raw/9700x/NAME.repeat.txt`, `NAME.plain.N.csv`), TSC ticks at 3.7925 GHz (step 2.1's rate, which
`msr/tsc/` over the plain runs' task clock gives again). The pass runs before the bodies' loop, the arms census after it.

- **The finding** costs about 0.45 ms on `sqlite3.c`. It asks 13 of 10,964 `if`s, in 9 bodies; the rest is the scan of
  the ops and each condition's constant kind.
- **The first version** (`raw/first/`, buster `b3c070a0`) sized its buffers by the nodes, 57 bytes a node: 0.66 times on
  `sqlite3.c` and on `main.c`. Sizing them by the `if`s found and by the graph's leaves gave the table's.
- **Small units** pay a few microseconds of fixed cost: 2.7 µs a c-testsuite program against 0.9 µs of references
  pass, 4.8 µs a musl unit against 3.0, which their ratios (3.03 and 1.59) magnify.
- **The objects** by the census and by the plain compile are the same bytes (`raw/9700x/NAME.same.txt`).

## Files

`raw/9700x/`: the census's lines, the repeats, the plain runs' counts, the holds' log and the build's. `raw/first/`: the
first version's run, as run. `scripts/`: every script as run for `raw/9700x/` (the first run's `run.sh` fetched the
bundle without forcing the branch, which the second's does). `SHA256SUMS`: every file's hash.
