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

## The review's test hardening (`c9432ad5`)

[buster#989's review](https://github.com/buster14a/buster/pull/989#pullrequestreview-5725133076) found nothing
blocking and asked for tests that would catch a regression of these changes. `c9432ad5` adds them:

- the index fixtures run natively in every form: loads and stores on indices 0 to 3, which stay in the buffer (for
  the scaled constant 2^31, the indices 2^31 below them, whose index the constant cancels), and the pointer also on
  indices whose additions wrap, at 32 bits before the sign extension and at 64;
- a request takes a node's last record, and one on a full node changes no record and none of the request's fields;
- a test-only field, `Tier1SelectPattern.nops`, which the selector never sets, makes a node's expansion write that
  many no-ops before its records, so that the tests take each node's sequence to its room and past it, through the
  selector's emitter and both of `tier1_emit`'s consumers, a conditional branch's among them.

The evidence is in `9700x/hardening/`, with the trees' receipts (`receipts.txt`: `tree-c9432ad5` is `git archive` of
the commit, the same files hash as locally).

| Check | Result |
| --- | --- |
| Tier 1's tests (`dev-g/`, the tree that became `c9432ad5`, which `diff -r` finds the same) | 0 failures: `test-tier1-select` 336,069 checks (335,263 at `741fd6c1`), `-emit` 210,213 (199,097), the others as at `741fd6c1` |
| c-testsuite's 220-program subset, `--tier1`, both paths | 220 pass |
| speedtest1 `--verify`, Tier 0, `--tier1` and `--tier1 --scalar` | `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739` |
| Outputs against `741fd6c1` (`head-c9432ad5/identity.txt`) | byte-identical: `-c` and `--tier1 -c` of `sqlite3.c`, speedtest1's Tier 0, `--tier1` and `--tier1 --scalar` executables |

`--tier1 -c sqlite3.c`, `time-runs` medians per round, ms (wall), 5 rounds of 21 runs (`queue-l.sh`,
`head-c9432ad5/compile-tier1-ab.log`):

| `741fd6c1` | `c9432ad5` |
| --- | --- |
| 370.30, 370.05, 370.06, 369.96, 370.02 | 369.99, 370.27, 369.87, 370.15, 370.24 |

The head runs 0.4 M more instructions (4,973.3 M against 4,972.9 M, 0.008%), the no-op loop's test once per expansion,
and its cycles fall within the rounds' spread (1,928.2 M to 1,931.1 M against 1,930.9 M to 1,932.1 M).

### Mutants

Each mutant changes one guard by an exact replacement (`mutants-apply.py`), and each copy is built and run against
its test at both heads (`mutants.sh`; `mutants/summary.txt` has each run's failures):

| Mutant | Its test | `741fd6c1` | `c9432ad5` |
| --- | --- | --- | --- |
| `request`: `tier1_select_request` without its room check | `test-tier1-select` | passes | fails: the full node's request |
| `emit`: the selector's emitter takes an overflowed node | `test-tier1-select` | passes | fails: 16 sequences past their room |
| `straight`: the straight-line consumer takes one | `test-tier1-emit` | passes | fails: the record counts and the native runs (1,396 failures) |
| `cfg`: the CFG consumer's other nodes take one | `test-tier1-emit` | passes | fails: the record counts and the native runs (138) |
| `branch`: the CFG consumer's conditional branch takes one | `test-tier1-emit` | passes | passes |
| `fit`: a 64-bit immediate's fit off by one at 2^31 | `test-tier1-select` | fails | fails |

`branch` survives because the room cuts a sequence's last records first: a conditional branch's sequence past its
room can't end in its conditional jump and its jump, and the consumer refuses the record it would take for the
condition (`tier1_emit_cfg_inverse`) with the same error, at the same node, its arenas and result as they were. The
overflow check names the reason.

`fit` makes a 64-bit addition of 2^31 a `lea` with the displacement `(int32_t)2^31`, -2^31. Both heads fail it in the
check that runs planned IR natively (32 failures of `both selected functions execute like original IR`). At
`c9432ad5` the new index runs fail it too (`mutants/fit.txt`): the load of the scaled constant's fixture at scale 1
and i = -2^31 faults in each of three runs as CI runs it (`native child failed (status 139)`), at
`mov 0x8(%rdi,%r8,1),%rax` with r8 = -2^32 under gdb with address randomization on; with randomization off, its
accesses don't fault, and the head fails it with 120 failures against the previous head's 32.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
