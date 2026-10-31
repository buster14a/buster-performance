# #977's review follow-ups, measured (#141), 2026-10-31

Evidence for [buster#989](https://github.com/buster14a/buster/pull/989), which fixes the two non-blocking
follow-ups of [#977's review](https://github.com/buster14a/buster/pull/977#pullrequestreview-5724811713), claimed on
[buster#141](https://github.com/buster14a/buster/issues/141). By Claude, at David's request.

- **A node's room:** every record a rule's expansion writes goes through `tier1_select_append`, which checks it
  against `BUSTER_TIER1_SELECT_RECORDS_PER_NODE`. A sequence longer than the room writes nothing past it and marks the
  node's records overflowed, which the selector's emitter and both of `tier1_emit`'s consumers refuse as an invalid
  function.
- **Constants in an index:** `tier1_select_index` takes a 64-bit addition of a constant (on either side) or a
  subtraction of one out of an address's index, into the displacement, scaled. A 32-bit index's addition before its
  sign extension stays.

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| base | `bad4a76a` | main, with buster#977 merged |
| head | `741fd6c1` | `claude/141-review-followups` (buster#989): base and the follow-ups |

The 9700X trees were `git archive`s of the commits (`9700x/receipts.txt`).

## Commands

On the 9700X, every step one hold of the shared lock, timed runs on CPU 2 (`9700x/`): `queue-k.sh BASE HEAD
REVISION` runs `queue-g-k.sh` and `queue-i-k.sh` (step 6's `queue-g.sh` and `queue-i.sh` under this run's lock title:
both builds, compile times, speedtest1 built seven ways with 11 rounds, `--tier1 -c` of `sqlite3.c`), then `perf
stat` of four speedtest1 builds, then `queue-d-k.sh` (step 6's campaign script on seeds 3400 to 3419). `dev-e/` is
the development run of the head's tree (`../9700x/dev.sh e`): Tier 1's tests, c-testsuite's subset by `--tier1` and
speedtest1's `--verify`.

## Correctness

| Check | Result |
| --- | --- |
| Tier 1's tests (`dev-e/`) | 0 failures: `test-tier1-select` 335,263 checks (329,472 before the new tests), `-liveness` 20,433, `-emit` 199,097, `-pipeline --cross-check` 6,463, `-cfg` 30,338, `-frame-execution` 14,619, `-allocation` 62,797, `-schedule` 609,462, `-model` 22 |
| c-testsuite's 220-program subset, `--tier1`, both paths | 220 pass |
| speedtest1 `--verify`, all seven builds | `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739` |
| #142 on the 9700X at the head, 40 programs, `--tier1` | 29 pass at both tiers; 11 fail in clang -O0's own steps (7 compiles, 1 output limit, 3 runs past 30 s), none in Buster's (`head-741fd6c1/campaign-cases.tsv`) |

## Run time and compile time

speedtest1, medians of 11 rounds (wall), ranges in brackets:

| Build | ms |
| --- | ---: |
| Tier 0, head | 257.1 (256.2–262.7) |
| Tier 0, base | 256.2 (255.7–257.0) |
| `--tier1`, base | 227.6 (227.2–228.9) |
| `--tier1`, head | 227.3 (226.8–228.0) |
| `--tier1 --scalar`, head | 229.0 (227.9–229.7) |
| clang -O0 | 292.5 (291.8–293.5) |
| clang -O2 | 131.6 (131.3–132.6) |

`perf stat` of one run each: base's `--tier1` 4,589.3 M instructions and 1,160 M cycles, head's 4,588.9 M and 1,157 M;
Tier 0 5,694 M and 1,331 M. Tier 1's records of speedtest1: 163,907 against 163,925, of `sqlite3.c` 159,539 against
159,557: few of their indices are 64-bit additions of a constant, so the run time is unchanged, as expected.

`time-runs` medians per round, ms (wall), 5 rounds of 21 runs:

| Command | base | head |
| --- | --- | --- |
| `-c sqlite3.c` | 130.05, 129.90, 129.98, 129.88, 129.88 | 129.72, 129.75, 129.79, 129.91, 129.86 |
| speedtest1's direct-path link | 133.94, 133.76, 134.03, 133.92, 133.94 | 133.92, 133.57, 133.73, 133.85, 133.91 |
| `--tier1 -c sqlite3.c` | 369.92, 369.97, 370.00, 369.77, 369.82 | 370.02, 370.02, 370.23, 370.81, 370.18 |

`--tier1 -c` runs 1.5 M fewer instructions at the head (4,972.9 M against 4,974.4 M) and 0.1% more cycles, within what
a placement moves a compile by on this host; the room's check is a comparison per record.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
