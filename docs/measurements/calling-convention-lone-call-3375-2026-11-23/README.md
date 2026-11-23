# The per-call kernel on a lone call (#3375), 2026-11-23

`abi_assign_lanes`, the calling convention's per-call kernel for the calls the
prefix sums can't place, as a call's arguments 16 at a time (one per 32-bit
lane) instead of eight calls at a time (one per 64-bit lane, an argument of
each per step), on the Ryzen 7 9700X (`benchpress`). Release builds with the
host's staged clang 23.1.4 (`BUSTER_DEBUG_INFO=0`), pinned with `taskset -c 2`,
each run under `~/buster-fast-bench/exclusive.sh` (owner `claude-3375`), with
`/proc/loadavg` and the busiest processes before and after each run in its log.

- **old:** main `1b9821afe`, the per-call scalar code (`abi_assign_call`)
  that #3364 deleted, with main's `calling_convention_benchmark.c` copied in
  (its rows `assign-alone`, `simple-alone`, `deferred-alone`).
- **main:** `c78091122`, with #3364's kernel, eight calls at a time.
- **head1, head2:** main with `raw/head1.patch` and `raw/head2.patch`;
  head2 gathers each argument's columns at once and those of a transparent
  union's member again only where there is one (head1 gathered the member
  first, then the columns, three dependent gathers). `raw/commits.txt` has
  each tree's commit and the hash of its diff.
- **headF:** the PR's commit, main with `raw/headF.patch` (`raw/headF.commit`):
  head2 with `abi_test_kernel_rules`' new calls and three redundant terms
  dropped from the kernel's flags (below).

`raw/setup.sh` builds the trees, `raw/ab.sh TAG ROUNDS BUILD...` runs
`benchmark-calling-convention --only assignment` once per build per round in
a rotating order. Each run reports 21 passes' medians; the tables give the
median of the 6 runs (range).

## The PR's commit (`raw/runs-4`: old, main, headF by turns)

| Row | old ns/arg | main ns/arg | headF ns/arg | headF vs old | headF vs main | cycles/arg old / main / headF | instructions/arg old / main / headF | mispredicts/arg old / main / headF |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `assign` | 3.37 (3.35–3.45) | 3.42 (3.42–3.45) | 3.22 (3.21–3.24) | −4.5% | −5.8% | 18.7 / 19.0 / 17.9 | 47.9 / 48.2 / 47.3 | 0.012 / 0.004 / 0.004 |
| `assign-alone` | 14.67 (14.65–14.71) | 16.01 (15.95–16.03) | 13.80 (13.72–13.84) | −5.9% | −13.8% | 81.3 / 88.7 / 76.5 | 186.6 / 154.0 / 130.4 | 0.042 / 0.076 / 0.072 |
| `deferred-alone` | 11.77 (11.75–11.83) | 54.41 (54.34–54.67) | 10.89 (10.87–10.95) | −7.4% | −80.0% | 65.3 / 301.6 / 60.4 | 233.1 / 585.2 / 134.1 | 0.134 / 0.076 / 0.001 |
| `assign-simple` | 2.90 (2.89–2.91) | 2.86 (2.86–2.86) | 2.86 (2.85–2.86) | −1.2% | +0.0% | 16.0 / 15.8 / 15.8 | 39.2 / 43.1 / 43.1 | 0.010 / 0.004 / 0.004 |
| `simple-alone` | 14.18 (14.15–14.21) | 13.36 (13.29–13.39) | 13.32 (13.29–13.37) | −6.0% | −0.3% | 78.5 / 74.1 / 73.9 | 177.6 / 126.0 / 125.8 | 0.030 / 0.067 / 0.066 |

`e2e/cross-check-final.log`: headF's `test-calling-convention --cross-check`
with GCC 16.2.1 and clang 23.1.4, every row with 0 failures.

## The micro rows (`raw/runs-3`: old, main, head2 by turns)

| Row | old ns/arg | main ns/arg | head2 ns/arg | head2 vs old | head2 vs main | cycles/arg old / main / head2 | instructions/arg old / main / head2 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `assign` | 3.38 (3.35–3.38) | 3.42 (3.42–3.44) | 3.22 (3.22–3.25) | −4.6% | −5.8% | 18.7 / 19.0 / 17.9 | 47.9 / 48.2 / 47.3 |
| `assign-alone` | 14.66 (14.65–14.77) | 16.03 (15.94–16.09) | 13.83 (13.81–13.97) | −5.6% | −13.7% | 81.2 / 88.8 / 76.7 | 186.6 / 154.0 / 130.4 |
| `deferred-alone` | 11.77 (11.73–11.87) | 54.39 (54.35–54.66) | 10.87 (10.86–10.91) | −7.6% | −80.0% | 65.2 / 301.5 / 60.3 | 233.1 / 585.2 / 134.4 |
| `assign-simple` | 2.90 (2.88–2.91) | 2.86 (2.85–2.86) | 2.86 (2.86–2.86) | −1.4% | +0.0% | 16.1 / 15.8 / 15.8 | 39.2 / 43.1 / 43.1 |
| `simple-alone` | 14.16 (14.16–14.26) | 13.34 (13.29–13.40) | 13.39 (13.28–13.45) | −5.5% | +0.4% | 78.5 / 73.9 / 74.2 | 177.6 / 126.0 / 125.8 |

`deferred-alone` assigns the 567 calls (7,979 arguments, 14.1 per call) the
prefix sums leave, each alone; `assign-alone` every call alone (5.2% of the
arguments in deferred calls). Mispredicts per argument in `deferred-alone`:
0.134 old, 0.072 main, 0.001 head2. #2958's gate, both single-call rows no
slower than old, holds with 7.6% and 5.6% to spare; `assign-simple` and
`simple-alone` never reach the kernel and match main.

`raw/runs-1` (old, main, head1) and `raw/runs-2` (old, head1, head2) are the
earlier rounds: head1's `deferred-alone` 11.00 (10.98–11.06) against old's
11.75, and head2 1.3% under head1 (10.85 against 11.00).

## End to end (`raw/e2e`, `raw/e2e.sh`)

One `time-runs --runs 21 --build main … --build head …` per compile (head is
head2), pinned to CPU 2, under the lock; `e2e/inputs.sha256` gives the inputs.

| Compile | main median ms | head2 median ms | wall | user cycles | instructions |
| --- | --- | --- | --- | --- | --- |
| `main.c -c` (the one compile with deferred calls: 7) | 628.27 | 627.97 | −0.05% | −0.12% | −81k (−0.001%) |
| sqlite3.c `-c` (none) | 117.00 | 117.06 | +0.05% | +0.12% | — |

`e2e/objects.log`: head2's objects are the same bytes as main's for sqlite3.c
and `main.c`, at Tier 0 and `--tier1`; old's differ at `--tier1` alone, by the
Tier 1 changes merged between `1b9821afe` and `c78091122`.

`e2e/cross-check.log`: head2's `test-calling-convention --cross-check` with
GCC 16.2.1 and clang 23.1.4, every row with 0 failures.

## Mutation rounds (`raw/mut*`, `raw/mut*.sh`, `raw/mutants*.py`)

Each mutant of the kernel built (Develop) and run through
`test-calling-convention`, one lock hold per mutant (`status-N`: `test S`,
S ≠ 0 the tests caught it, or `build S`).

- **Round 1** (`mut`, head2, `mutants.py`, 54 mutants): 43 failed the tests,
  3 didn't build (a variable left unused: 23, 29, 50) and 8 survived:
  - 1 (a high SSE eightbyte after a low one with one vector register left),
    8 (an i0 while LLVM has a general register clang doesn't count),
    32 (the first unnamed argument read as named), 35 (a transparent union's
    alignment raised to 8 for the integer rule): no test reached them;
  - 31: a redundant term (`transparent` beside the union's bytes, which are 0
    outside its lanes), since removed;
  - 27 (`part_bytes >= 16` for a vector on the stack) and 52 (`word`'s
    alignment `== 3` relaxed to `<= 3`): equivalent, as every VECTOR type's
    result in a vector register holds 16 bytes or more and every slot's
    alignment is 3 or more;
  - 53 (GROWN whether or not the lane is a transparent union's): see below.
- **Round 2** (`mut2`, head3 with four calls added to `abi_test_kernel_rules`,
  `mutants2.py`): 1, 8, 32 and 23 rewritten failed; 35, FIRST in a union's
  own slot (29 rewritten) and LOW at 8 bytes (31's neighbour) survived, the
  fixtures not reading flags and the `long *` union taking the late general
  register first.
- **Round 3** (`mut4`, head6 with seven calls and a flags check,
  `mutants3.py`; `mut3` ran on head4, whose base failed on a fixture's
  alignment, written as log2 rather than log2 + 1): 35, FIRST and LOW failed;
  53 and `late_general` without `nv == 0` (50 rewritten) survived.
  `late_general` also needs one general register and neither an aggregate
  nor a PAIR, which no type with a vector eightbyte is: equivalent.
- **53** (`probe-*.log`, `probe2.sh`): a call with a transparent union aligned
  to 16 of `packed {_Atomic {long[0]}}`, which is GROWN, gives its own slot at
  16 by main's rules and by the mutant alike, where clang 23.1.4 passes the
  member as an `i8` in r9 (`getIndirectResult` of the member); filed as
  buster#3400, a discrepancy on main already.
