# Tier 1's selection walks: run time against Tier 0 and clang (#140, step 6), 2026-10-31

Evidence for [buster#977](https://github.com/buster14a/buster/pull/977), which fixes the three costs step 5 found in
Tier 1's code (`../step5/README.md`, "What still costs"), claimed on
[buster#141](https://github.com/buster14a/buster/issues/141). Before it, the `--tier1` build of speedtest1 ran 11%
slower than Tier 0's; with it, 11.8% faster, and 1.73 times clang -O2's time where it was 2.17 times. By Claude, at
David's request.

- **C's truth values** (`tier1_select_truth`): `a < b` reaches the IR as `zext (icmp lt a, b)`, which `if`, `!`,
  `&&` and `||` compare with zero again (`icmp ne (zext x), 0`). The walk takes such a chain of consecutive, single-use
  links back to the comparison, so that a branch on it is the comparison's `cmp; jcc` and its zero extension the
  comparison's `setcc`, negated for an odd number of `eq` links.
- **Addresses** (`tier1_select_address`): an access's address through the `inttoptr`/`ptrtoint` the typed stream puts
  around every address, nested addresses while one index is left, constant indices and 64-bit additions of
  constants, into one memory operand (a pointer value into one `lea`), while the displacement fits 32 bits.
- **Division by 2^k**: unsigned, a shift or a mask; signed, `TIER1_RULE_DIVIDE_POWER`'s bias sequence (`mov; sar; shr;
  lea; sar`, or `and; sub` for the remainder), rather than `div` and its fixed registers.

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| base | `b651971a` | main, with buster#972 merged |
| head | `54173d58` | `claude/140-selection-walks` (buster#977): base and the walks |
| development | #974's head `6f743ffd` and the walks | the first run, `9700x/dev-a/` |

The 9700X trees were `git archive`s of the commits: `9700x/receipts.txt` has each tree's file hash, its
`build/compiler`'s and the inputs'.

## Commands

On the 9700X, every step one hold of the shared lock, timed runs on CPU 2 (`9700x/`):

- `queue-h.sh BASE HEAD REVISION`: `queue-g.sh BASE HEAD`, then `perf stat` of five speedtest1 builds' runs, then
  `queue-d.sh HEAD REVISION`. `queue-g.sh` is step 5's `queue-c.sh` with base's `--tier1` build added: both trees'
  builds (`BUSTER_DEBUG_INFO=0`); `ab` of `time-runs`, 5 rounds of 21 runs, base against head, of `-c` of the frozen
  `sqlite3.c` and of the direct path's link of speedtest1; head's `-c` with and without `--tier1`; speedtest1 (#136's
  harness: the frozen `sqlite3.c`, SQLite 3.53.2's `test/speedtest1.c`, `test/speedtest.tcl`'s flags and options,
  the database on tmpfs) built seven ways, a `--verify` run of each, 11 rounds of the seven in a rotating order;
  `perf record` of three builds' runs.
- `queue-i.sh BASE HEAD`: `ab` of `time-runs`, 5 rounds of 21 runs, base against head, of `--tier1 -c` of the frozen
  `sqlite3.c`, and each tree's `--tier1-report` of it.
- `queue-d.sh HEAD REVISION`: #142's campaign, Csmith `0cdc710` and YARPGen `1adb290`, seeds 3000 to 3039, 2 programs
  per generator a hold, at both tiers (`--tier0-default`, `--tier1-arg --tier1 --tier1-arg
  -fno-asynchronous-unwind-tables`); `queue-ds.sh` (started by `queue-j.sh` once it is done) the same with
  `--tier1 --scalar`, seeds 3200 to 3219.
- `dev.sh NAME [PREVIOUS]`: the development runs, a copy of the laptop's tree: its build, Tier 1's tests,
  c-testsuite's subset by `--tier1`, speedtest1 by `--tier1` (both paths) checked by `--verify`, and with PREVIOUS 11
  rounds against its `--tier1` build. `dev-a` is #974's head with the walks, against #974's head (`9dff1aad`'s code).
- `head-tests.sh TREE`: Tier 1's tests and c-testsuite's subset by `--tier1` on the head's build (`tests-54173d58/`).
- `summary-g.sh LOGS ST` makes the tables below from the logs, and `receipts-g.sh TREE...` the receipts.

## Correctness

| Check | Result |
| --- | --- |
| Tier 1's tests at the head (`9700x/tests-54173d58/`) | 0 failures: `test-tier1-select` 329,472 checks, `-liveness` 20,433, `-emit` 199,097, `-pipeline --cross-check` 6,463 (clang's 960 among them), `-cfg` 30,338, `-frame-execution` 14,619, `-allocation` 62,797, `-schedule` 609,462, `-model` 22 |
| c-testsuite's 220-program subset, `--tier1`, both paths, at the head | 220 pass; Tier 1 compiles 350 of their 430 functions |
| speedtest1 `--verify`, all seven builds | `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739` |
| #142 on the 9700X at the head, 80 programs, `--tier1` | 66 pass at both tiers; 14 fail in clang -O0's own steps (9 compiles, 2 output limits, 3 runs past 30 s), none in Buster's: case by case step 5's final head's outcomes (`head-54173d58/campaign-cases.tsv`) |
| #142 on the 9700X at the head, 40 programs, `--tier1 --scalar` | 36 pass at both tiers; 4 fail in clang -O0's own steps (3 compiles, 1 run past 30 s), none in Buster's (`head-54173d58/campaign-scalar-cases.tsv`) |
| The compiler's own `main.c`, and the call graph (`9700x/dev-c/`) | `-fsyntax-only`, `-c --verify` and `--tier1 -c` exit 0; `check-call-graph` 0 cycles, 0 split variables |

`dev-c` is the same selection on #974's head (its tree differs from the head's only in #974's files); the hosted CI
ran the whole inventory, the self-compiles among it, at the head.

`test-tier1-select`'s new section (`tier1_select_test_walks`) plans each fixture by both paths, which must pick the
same root pattern and cover the same nodes, and runs its code natively against the test's independent interpreter:
truth chains at both widths, of 0 to 3 links in every parity, by every predicate, of registers and of an immediate,
as values and as branches; four address shapes with and without an addition, as loads, stores and pointers, one of
whose offsets together pass 32 bits; and every power of two of the four divisions at both widths, into three
destinations. The first development run (`9700x/dev-a/`) failed two expectations of the older conversion section, 16
checks, which the walks change on purpose (a comparison's zero extension is now the comparison's `setcc`): `dev-c`
has them updated.

## Run time

speedtest1, medians of 11 rounds (wall, from fork to wait), ranges in brackets:

| Build | ms |
| --- | ---: |
| Tier 0, head | 257.1 (256.7–260.6) |
| Tier 0, base | 257.6 (256.6–258.0) |
| `--tier1`, base | 285.7 (285.1–286.5) |
| `--tier1`, head | 226.9 (226.5–228.6) |
| `--tier1 --scalar`, head | 227.1 (226.7–228.4) |
| clang -O0 | 293.6 (292.2–296.3) |
| clang -O2 | 131.4 (130.9–134.6) |

`perf stat` of one run each: Tier 0 5,694 M instructions and 1,326 M cycles; base's `--tier1` 6,431 M and 1,481 M;
head's `--tier1` 4,589 M and 1,161 M, `--scalar` 4,602 M and 1,159 M; clang -O2 2,010 M and 633 M.

So the build of both tiers runs 11.8% faster than Tier 0's (20.6% faster than base's), 22.7% faster than clang -O0's
and in 1.73 times clang -O2's time. Where: `perf record` (`cycles:u`, a sample per 200,003) of one run each, its
samples by function (`samples-*.txt`), each function classed by whether its instruction sequence differs between the
head's Tier 0 and `--tier1` builds (`classes.sh`; `tier-classes.txt`: 2,161 functions Tier 1's, 592 Tier 0's). The
functions Tier 1 compiles take 3,434 samples as Tier 0's code, 4,277 as base's Tier 1 code and 2,529 as head's: 26%
fewer than Tier 0's code, 41% fewer than base's. The functions both builds leave to Tier 0 take 2,745, 2,652 and
2,717.

Statically (`count.awk` over each executable, both tiers' functions; `mix.txt`), head's `--tier1` executable has
373,820 instructions against base's 484,332 and Tier 0's 404,752, 9,543 `setcc` against 24,565 and 15,648, and 461
divisions against 551 and 551.

The first run (`9700x/dev-a/`, #974's head with the walks, against #974's head's `--tier1` build): 227.4 ms against
284.9 ms, Tier 0 256.5 ms; 4,589 M instructions against 6,431 M.

## Allocation traffic and records

From `--tier1-report` (records of Tier 1's code):

| Program | Build | Tier 1 functions | records | spill stores | reloads | call saves | edge moves |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| speedtest1 | base `--tier1` | 2,207 of 2,709 | 272,439 | 3,439 | 4,111 | 10,355 | 10,508 |
| speedtest1 | head `--tier1` | 2,208 of 2,709 | 162,788 | 3,289 | 3,879 | 10,326 | 10,274 |
| speedtest1 | head `--tier1 --scalar` | 2,208 of 2,709 | 163,618 | 3,282 | 3,874 | 10,329 | 10,231 |
| `sqlite3.c` (`-c`) | base `--tier1` | 2,178 of 2,668 | 266,673 | 3,366 | 4,058 | 10,201 | 10,278 |
| `sqlite3.c` (`-c`) | head `--tier1` | 2,179 of 2,668 | 158,420 | 3,221 | 3,833 | 10,176 | 10,053 |

## Compile time and build time

`time-runs` medians per round, ms (wall), 5 rounds of 21 runs:

| Command | base | head |
| --- | --- | --- |
| `-c sqlite3.c` | 130.58, 130.74, 130.64, 130.57, 130.53 | 130.32, 130.06, 130.28, 130.18, 130.39 |
| speedtest1's direct-path link | 134.67, 134.40, 134.21, 134.33, 134.23 | 133.98, 134.19, 133.85, 133.97, 134.03 |
| `--tier1 -c sqlite3.c` | 386.82, 390.35, 387.85, 387.01, 386.97 | 371.14, 371.18, 371.21, 371.21, 371.09 |

The default path's instructions: 1,349,004,823 at base and 1,349,004,278 at head; selection isn't on it. `--tier1 -c`
runs 5,412.5 M instructions at base and 4,968.4 M at head (−8.2%), 4.1% less time: Tier 1 emits, sizes and encodes
40% fewer records. Both trees build in 40.4 s, the checker's unit the longest.

## What still costs

- A narrow value's zero extension to an integer: its register is zero-extended past its width already (the loads,
  truncations, parameters, results and constants that make narrow values write them so), but `zext` is a `movzx`
  again, 4,146 times in the `--tier1` executable right after the `movzx` load that filled the register (4,026 in Tier
  0's). It could be a copy.
- `&&`, `||` and `?:` results: the lowering keeps them in untyped temporary frame slots (`BUSTER_IR_SLOT_TEMPORARY`,
  of type void), which SSA promotion leaves in memory (`ssa_ir.c` promotes typed slots alone): each is a store and a
  load through the object's address, as `yy_find_shift_action`'s `mov %edx, (%rax)` and `mov (%rax), %eax`.
- A frame object's address is a `lea` into a register (4,053 in the executable) rather than part of the memory
  operands that use it: the frame's layout gives the object's offset only at emission.
- Tier 1's pipeline runs SCCP, dead code and CFG cleanup alone, no loop-invariant motion: `sqlite3StrICmp`'s loop
  computes `sqlite3UpperToLower`'s address twice per character.
- `sqlite3VdbeExec`, the hottest function (811 of head's 5,860 samples), is Tier 0's: Tier 1 refuses its switch.

## Limitations

- The `--tier1` build is both tiers' code: the functions Tier 1 refuses (499 of speedtest1's 2,709, among them
  `sqlite3VdbeExec`, the hottest) are Tier 0's. The run time measures Tier 1's code where it compiles, not a Tier 1
  build.
- Unwind tables and `-g` are off in the `--tier1` builds (the driver refuses them with it); the Tier 0 and clang builds
  have them.
- The development run (`dev-a`) is on #974's head, which buster#977 doesn't contain: it measures the same selection
  on a base that takes 2 more functions.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
