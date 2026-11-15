# The selection shared by -c's two selections (buster#2536, step 2.2c.4, part 3, first cuts, 2026-11-15)

Step 2.2c.4's part 3 makes `--windowed-loop` `-c`'s default once 2.2c's gate holds: one worker no slower than the plain
`-c` by more than the pass before the windows. Part 2's record measured the windowed compile at the provisional
selection's cost, more than the pass. This record places that cost and cuts it in two commits; the gate isn't met yet.

**Where the cost was** (`raw/local/profile-before.txt`, round 1's `*.prof.*.txt`). Cycles were sampled by symbol at
200,003 cycles a sample, 8 runs of each mode, the period moved by 2 each run:

- on `sqlite3.c`, past the pass (`check_program_census_scan`), the second selection;
- on `main.c`, the second selection, about 50 M cycles a selection. Two fifths of that was the section bounds
  (buster#1122). The selection read every token for asm labels and wrote every object's bound into an object-sized
  column. Each pass of its fixpoint then read that column back whole.

**The commits.**

1. `76631f86` shares what a selection reads of no reference (`CheckProgramSelectShared`, `check_program_select_shared`):
   - the static objects' root flags and inline rules;
   - each body's eager answer;
   - a block-scope static's roots stay apart, since they count only where emitted code declares it. Its emitted test is
     now asked only of the statics with root attributes.
2. `9a032317` lists the section bounds sparsely (`check_program_select_bounds`), once for both selections:
   - only a linkage name of `__start_` or `__stop_` and an identifier makes a bound;
   - the asm labels come from the attributed tokens' scan;
   - the declared objects are found 16 at a time (a scalar twin reads each one);
   - the fixpoint reads the list.

   Every selection takes it, so the plain `-c` gains too.

The executables are Release builds made under the 9700X's lock (`raw/9700x*/build.*.log`, each with its SHA-256):

- **Round 1 (`raw/9700x-round1/`):** buster `76631f86cf1a475a46ede46bbfe5b330acec37f0` against main
  `1b8231ea72f3813a98b33c994c1ae6e3c9bc7f97`.
- **Round 2 (`raw/9700x/`):** buster `9a03231708618bd2bebf5d3e2248c7761e76bce0` against the same main.

**In short.**

- **Objects:** in both rounds, every object, stderr and exit status by the head is main's on all 1,592 units of the
  corpora and the 1,069 checker fixtures. The windowed compile at W of 1, 2,048 and ∞ is the plain one, and it serves where
  it served.
- **Round 2's time** (medians of 7 alternating runs):
  - **`main.c`'s plain `-c`:** 40.9 M fewer cycles (−1.2%) and 108.7 M fewer instructions (−1.0%).
  - **`main.c`'s windowed `-c`:** 56.7 M cycles over plain, down from main's 96.2 M. That is 0.4% over main's plain `-c`.
  - **`sqlite3.c`:** the plain `-c` is within the spread, and the windowed excess is 12.2 M cycles, down from 15.0 M.
- **The gate:** not met yet.
  - The pass costs about 7 M cycles on `sqlite3.c` and 18.5 M on `main.c` (its 1.46 ms and 3.64 ms at the cores'
    4.9 and 5.1 GHz).
  - The windowed excess is about 5 M and 38 M cycles past it.
  - On `main.c`, round 2's profile puts the rest in the second selection (+624 samples) and in expression evaluation
    (`check_constant_evaluate` +628, `check_action_scalar` +331, `check_init_walk` +159). The program's code doesn't
    call those; the record doesn't place them yet.

## What was run

`scripts/run.sh` ran as a user unit on the host, once a round:

1. both builds;
2. one hold of the lock a corpus for `scripts/units.sh`: each unit by main's `-c`, the head's `-c`, and the head's
   `--windowed-loop -c` at W of 1, 2,048 and ∞;
3. one hold a file for `scripts/repeat.sh`: `sqlite3.c` and `main.c`, 7 rounds of each build's `-c`,
   `--provisional-selection -c` and `--windowed-loop -c`, alternating;
4. one hold for `scripts/prof.sh` on `sqlite3.c`, and in round 2 on `main.c` too: the head's `-c` and
   `--windowed-loop -c`, 8 runs each, sampled by symbol.

Every compile ran on CPU 2 with `--lanes 1`. The corpora are part 1's.

## The objects (round 2)

| corpus | units | head = main | W = 1 | W = 2,048 | W = ∞ | windowed code serves |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 1 | 1 | 1 | 1 | 1 | 1 |
| `main.c` | 1 | 1 | 1 | 1 | 1 | 1 |
| Lua | 34 | 34 | 34 | 34 | 34 | 34 |
| c-testsuite | 220 | 220 | 220 | 220 | 220 | 220 |
| musl | 1,336 | 1,336 | 1,336 | 1,336 | 1,336 | 1,336 |
| checker fixtures | 1,069 | 1,069 | 1,069 | 1,069 | 1,069 | 313 |

Round 1's lines are the same (`raw/9700x-round1/NAME.txt`). The cloud container's comparisons, the scalar twin's among
them, are in `raw/local/comparisons.txt`.

## The compile (round 2)

| file | build | mode | task clock | user cycles | user instructions |
| --- | --- | --- | ---: | ---: | ---: |
| `sqlite3.c` | main | `-c` | 122.93 ms | 598.37 M | 1,363.079 M |
| `sqlite3.c` | main | `--provisional-selection` | 126.08 ms | 613.20 M | 1,379.963 M |
| `sqlite3.c` | main | `--windowed-loop` | 126.89 ms | 614.53 M | 1,380.161 M |
| `sqlite3.c` | head | `-c` | 123.20 ms | 598.55 M | 1,363.219 M |
| `sqlite3.c` | head | `--provisional-selection` | 126.13 ms | 612.01 M | 1,378.974 M |
| `sqlite3.c` | head | `--windowed-loop` | 126.63 ms | 610.95 M | 1,379.172 M |
| `main.c` | main | `-c` | 693.19 ms | 3,515.80 M | 10,690.831 M |
| `main.c` | main | `--provisional-selection` | 713.73 ms | 3,617.18 M | 10,892.545 M |
| `main.c` | main | `--windowed-loop` | 713.09 ms | 3,611.31 M | 10,893.241 M |
| `main.c` | head | `-c` | 685.84 ms | 3,475.67 M | 10,582.176 M |
| `main.c` | head | `--provisional-selection` | 696.85 ms | 3,530.53 M | 10,667.234 M |
| `main.c` | head | `--windowed-loop` | 698.44 ms | 3,530.40 M | 10,667.976 M |

**The windowed compile's cycles minus the plain one's, by round** (millions):

| file | build | rounds 1 to 7 | median |
| --- | --- | --- | ---: |
| `sqlite3.c` | main | 14.4, 20.2, 15.0, 16.6, 15.3, 14.1, 14.0 | 15.0 |
| `sqlite3.c` | head | 14.0, 12.2, 6.7, 16.6, 10.4, 5.7, 15.3 | 12.2 |
| `main.c` | main | 87.1, 81.6, 95.1, 96.2, 99.7, 105.1, 109.7 | 96.2 |
| `main.c` | head | 51.7, 58.2, 75.3, 56.7, 46.9, 44.0, 74.5 | 56.7 |

- **The head's plain `-c` minus main's**, by round: −33.3 to −53.6 M cycles on `main.c`, every round; −1.1 to +12.2 M
  on `sqlite3.c` (median +1.1 M, with 0.14 M more instructions).
- **Round 1:** commit 1 alone ran the windowed `sqlite3.c` in 1.0 M fewer instructions (12.9 M cycles over plain at the
  median, against 13.3 M). On `main.c` it moved little: the bounds were most of the selection there.
- **Objects:** the last rounds' objects are the same by both builds and all three modes (`raw/9700x/*.same.txt`).

## Files

- `raw/9700x/`: round 2's unit lines, repeats, profiles' per-symbol sums, holds' log and builds.
- `raw/9700x-round1/`: round 1's.
- `raw/local/`: the profile before part 3, the cloud container's comparisons, round 1's windowed lines, and the two bounds
  sources.
- `scripts/`: every script as run.
- `SHA256SUMS`: every file's hash.

## Round 3: the rest, by instructions (added at the hand-off, buster#2866)

**What was run.** After the merge, `main.c` was profiled by `instructions:u` on the head build (`9a032317`, whose code
main `28e4e41e` has). `scripts/iprof.sh` is `prof.sh` with a period of 400009 + 2i, 8 runs of each mode, and its sums are
in `raw/9700x-round3/`.

**The checker's functions don't grow.** The cycle samples above made `check_constant_evaluate`, `check_action_scalar`
and `check_init_walk` grow. Those run before `check_program`, the same in both modes, and by instructions their
differences cancel: the cycle samples' alignment, not work. `scripts/callers.sh` (one run each with DWARF call graphs)
gave no callers, and its shares even went the other way.

**What the windowed compile adds.** About 81 M instructions a run, about 50 M of them the selection's:

| symbol | extra samples |
| --- | ---: |
| `check_program_select_shared` (the second selection) | +512, ≈ 26 M instructions |
| `check_program_census_scan` (the pass) | +302 |
| `c_bindings_sort` | +273 |
| `c_lowering_prepare` | +224 |
| `memmove` | +163 |

**Where the selection's cost is.** It has no single hot spot left. By line, it is spread over:

- the definitions' order and declared-object lookups;
- the label owners;
- the data's references;
- the edges.

The next cut, a cheaper exact selection, is buster#2866's decision.
