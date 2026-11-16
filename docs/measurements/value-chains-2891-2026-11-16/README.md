# An `&&` or `||` value's first operand lowered as branches (buster#2891), 2026-11-16

[buster#2891](https://github.com/buster14a/buster/issues/2891), under
[its claim](https://github.com/buster14a/buster/issues/2891#issuecomment-6928753176),
with the node machine's side agreed with the holder of its files on
[buster#2890](https://github.com/buster14a/buster/issues/2890#issuecomment-6928828932).
It is #2883's follow-up: buster#2889 wrote a condition's `&&` and `||` as
branches, and left a value's `&&` or `||` whose first operand is itself an `&&`
or `||` (`return a && b && c;`, `x = (a && b) || c`) making that operand 0 or 1
at a join of its own and testing it again.

This change pushes the branches task (`check_lower_branch`) for such a first
operand, to the value's own constant label: where false for an `&&`, where true
for an `||`. The value's outermost join stays.

```c
int chain(int a, int b, int c, int d) { return a < b && b < c && c < d; }
```

is 13 instructions where it was 21 (`cmp; jge; cmp; jge; cmp; setl; ...`; the
inner `&&`'s `setl; movzbl; test; setne; movzbl; jmp; xor; test; je` are gone).

**Result.** #2883's joins are left at **0 in `sqlite3.c`, 1 in Lua and 0 in
musl** (from 14, 11 and 18 on main): the one left is `luaV_modf`'s
`luai_nummod`, a conditional whose arm is an `&&`, out of the issue's scope.
The three corpora's objects lose 127, 79 and 158 instructions. A compile of
`sqlite3.c` is **within main's own repeat**. The compiler built by Tier 0 with
the change runs **1.73% fewer instructions** compiling `sqlite3.c`, and its
`.text` is 1.42% smaller: the compiler's own source has many such chains. Its
time falls 1.11% against main, where main's second run reads -0.58%.

## How it was measured

- The 9700X (`benchpress`), CPU 2, every build and run under the host's lock,
  one hold a run (`scripts/lock.sh`; `scripts/queue.sh` with 20 s between two
  holds). Queues `scripts/queue-1.txt` and `scripts/queue-2.txt` (the
  self-build again: `selfbuild2.sh` named #2883's tree, `trees/head2`, in
  queue 1, and failed there; fixed to `trees/head`).
- `main` is buster main `cc1c47d6` (with #2889 and #2887), `head` main with the
  change (`results/head/head.patch`, sha256 `dda6a840`, the pull request's two
  commits), both `./build.sh --config Release` (`scripts/build-label.sh`).
- The corpora are #2850's: the frozen corpus's `sqlite3.c` and musl
  (`preprocessor-391e729af658`), and Lua 5.4.8 (`scripts/corpora.sh`).

## The joins

`scripts/joins.sh` (#2877's): `test %eax,%eax; setne %al; movzbl %al,%eax;
jmp; xor %eax,%eax` or `mov $K,%eax`; `test %eax,%eax; je/jne`.

| | main | head |
| --- | ---: | ---: |
| `sqlite3.c` | 14 | 0 |
| Lua 5.4.8 | 11 | 1 |
| musl | 18 | 0 |

- The 41 values #2891 lists go: returned, assigned and expression statements'.
- Lua's `check_capture`, `if (l_unlikely(a || b || c))`, which #2891 listed as
  a condition of another shape, goes too: the join the pattern counted there
  was the inner `a || b`, a first operand of the value `||` under
  `__builtin_expect`. That value's own join stays (it is normalized by
  `!= 0`, then tested, not a shape this pattern counts).
- Left: `luaV_modf` (`lvm.o`), `if ((m > 0) ? b < 0 : (m < 0 && b != m))`, a
  conditional whose arm is an `&&` (a value).

## The objects and the stream

`scripts/objects.sh`, `scripts/census.sh` (`measure-tier0-entries`):

| | instructions | `.text` bytes | typed entries |
| --- | ---: | ---: | ---: |
| `sqlite3.c` | 303,456 to 303,329 (-127) | 1,085,736 to 1,085,384 | 381,259 to 381,191 |
| Lua 5.4.8 | 83,767 to 83,688 (-79) | 291,958 to 291,766 | 87,935 to 87,889 |
| musl | 179,263 to 179,105 (-158) | 692,788 to 692,368 | 193,159 to 193,061 |

Tier 0's vector path (`scripts/backend.sh`, medians of three) reads the same
cycles an entry: 66.13 and 66.09 (`sqlite3.c`), 86.84 and 86.91 (Lua), 100.97
and 100.95 (musl).

## The compile, `-c sqlite3.c`

`scripts/compare.sh main head 3`: whole processes, three comparisons of 21
runs of base, head and base again in a Williams order, each run its own hold
(`scripts/cloud/medians.py`, medians of the 63 runs of each):

| | wall | user cycles | instructions |
| --- | ---: | ---: | ---: |
| main | 122.266 ms | 592,000,087 | 1,361,792,336 |
| this change | 122.259 ms (-0.01%) | 592,152,176 (+0.03%) | 1,361,768,150 (-24,186) |
| main again | 122.194 ms (-0.06%) | 592,432,841 (+0.07%) | 1,361,792,337 |

Each comparison alone, wall against base: head -0.10%, +0.05%, +0.01%; base
again -0.14%, -0.08%, +0.05%. Within main's own repeat.

## At run time

The compiler built by each build from this change's sources (43 units by
Tier 0, `scripts/selfbuild2.sh`), timed compiling `sqlite3.c` (three
comparisons of 21 runs, `results/head/selfbuilt-*.txt`):

| the compiler built by | its `.text` | wall | user cycles | instructions |
| --- | ---: | ---: | ---: | ---: |
| main | 84,990,462 | 973.6 ms | 5,304,424,578 | 9,618,312,981 |
| head | 83,786,390 (-1.42%) | 962.8 ms (-1.11%) | 5,242,358,351 (-1.17%) | 9,451,484,233 (-1.73%) |
| main again | | 967.9 ms (-0.58%) | 5,272,911,286 (-0.59%) | 9,618,312,536 |

The instructions are exact; the time's gain is about twice main's own repeat
in this run (each comparison alone: head -2.28%, -1.24%, -0.49%; base again
-1.28%, -0.10%, -0.41%).

The self-host qualification (`scripts/qualify.sh`, `tools/ci/selfhost.c`)
passes: 43 units, 14 smoke commands, 5 probes, 10 byte comparisons, 10
executable runs (`results/head/qualify`).

## The node machine

The machine doesn't write branches yet (buster#2890), so C leaves a value
`&&` or `||` whose first operand is branches to the tasks, by the lowering's
rule read from the records (`node_machine_branch_condition`), as it leaves a
conditional whose condition is. Counted in the cloud container (counts, not
timings), `measure-node-machine --shadow --list 3`, main's compiler and the
head's, each on its own tree's `main.c` (`scripts/cloud/shadow-modes2.sh`,
`results/cloud/shadow-counts.txt`):

| plain | `sqlite3.c` | Lua | musl | `main.c` |
| --- | ---: | ---: | ---: | ---: |
| census-taken expressions (unchanged) | 51,338 (98.03%) | 10,829 (93.66%) | 23,037 (86.93%) | 20,441 (72.02%) |
| machine-taken expressions | 48,884 to 48,877 | 10,131 to 10,128 | 20,636 to 20,626 | 16,609 to 16,579 |
| machine-taken evaluated nodes | 89.80% to 89.76% | 86.39% to 86.29% | 82.89% to 82.73% | 61.95% to 62.22% |
| refused by `template` | 2,454 to 2,461 | 697 to 700 | 2,339 to 2,349 | 3,831 to 3,861 |

(`main.c` is each tree's own source, which this change edits, so its column
compares two inputs.)

- **Exit status 0 and no difference** in values, entries or the twin, by the
  head in each of ten modes on each of the four inputs: plain, `--verify`,
  `-g`, `--fused`, `--facts --facts-operators`, `--facts-reads`,
  `--front-types`, `--front-sweeps`, and `--front-tests` with the default
  warnings and with `-Wall -Wextra` (`results/cloud/shadow-head-summary.txt`;
  main's the same, `shadow-main-summary.txt`).
- **At reader time** (`--front-tests`, both sets of warnings): taken there and
  refused by the census 0, differences 0, root kinds that differ 0, on the
  four inputs.
- **The fixture** expects the refusal of `x = (a && b) || (c && u);` and
  `x = !(a || b) && c;`. The fixture's check stops at its first failing line,
  so the machine's mutant below shows the first of the two; main's machine
  takes both (a probe of the two lines: 5 of 5 expressions taken by main's,
  3 of 5 by the head's, the two refused by `template`).

## Correctness

In the cloud container (4 CPUs), the branch on main `cc1c47d6`
(`results/cloud/`):

- **Native:** `test-checker` whole, 842,757 checks, 0 failures; c-testsuite
  against clang by Tier 0 and by Tier 1, 220 of 220 each; the node templates
  on `sqlite3.c`, Lua and c-testsuite, 0 differences.
- **`BUSTER_HOST_ARCH=x86-64`:** `test-checker` 845,502 checks, 0 failures;
  c-testsuite by both tiers 220 of 220; `test-tier0 --cross-check`,
  21,550,459 checks, 0 failed.
- **Both host paths write the same bytes:** the three corpora's 1,371 objects
  by the native and the `x86-64` builds are the same files.
- **The sanitizers** (`x86-64` Release, CI's fatal options): under
  MemorySanitizer, AddressSanitizer and ThreadSanitizer, `test-checker`'s
  part 4 (the fixtures, run against clang) 60,915 checks and part 5 (the
  census and the shadow) 210,269 checks, 0 failures each; `-c sqlite3.c`
  writes the native build's object; `measure-node-machine --shadow --verify`
  on `sqlite3.c` exits 0. No reports.
- **Five mutants** (`scripts/cloud/mutants-build.sh`, `mutant-values.sh`: each
  a copy of the tree with one change, built, `test-checker`'s parts 4 and 5;
  `results/cloud/mutants-failures.txt`), each caught:

  | mutant | failures | caught by |
  | --- | ---: | --- |
  | #2883's rule alone (no value's first operand as branches) | 16 | the shapes' value functions 12 to 15, both lowerings |
  | no first operand as branches, a conditional's nor a value's | 24 | the shapes' functions 8, 9 and 12 to 15 |
  | the value's first operand's branch of the other sense | 6 | both programs against clang, and an older program against clang (`statement-region-selected-and-unevaluated`) |
  | only the values (a conditional's condition a value again) | 8 | the shapes' functions 8 and 9 |
  | the machine takes such a value (#2883's refusal alone) | 4 | the shadow's fixture line and its entries |

## Files

- `scripts/`: the 9700X runners (#2883's, renamed). `scripts/cloud/`: the
  cloud session's runners (the objects, the shadow's modes, the native,
  `x86-64` and sanitizer suites, the mutants, the medians).
- `results/main`, `results/head`: the pair. `results/queue.log`: every queued
  run's start and status. `results/cloud`: the cloud's summaries.
