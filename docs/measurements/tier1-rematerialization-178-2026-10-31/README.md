# Tier 1 rematerialization in linear scan (#178), 2026-10-31

Evidence for [buster#178](https://github.com/buster14a/buster/issues/178): Tier 1's CFG consumer recomputing
constants, symbols' addresses (from rip, or from their GOT slots) and frame objects' addresses, through the copies the
C driver's typed streams put around addresses, and leaving out the definitions nothing reads. The issue's "Done when"
asks for three things, each below: spill stores, reloads and frame sizes against linear scan without
rematerialization on the corpora's functions; run time against the same on speedtest1 and the corpora's programs on
the 9700X; and #142's campaigns finding no mismatch. By Claude, at David's request.

## Revisions

| Role | Commit | Tree manifest | `build/compiler` |
| --- | --- | --- | --- |
| head | `4851f99dca45ccb20ca1ce195df1abeaa00fec3b` (`claude/sleepy-darwin-4eej9j`) | `bfefecdb7ff601cb...` | `602f470292badb09...` |
| main | `a28f29f` (buster's main when the branch began), which recomputed constants alone | `b58ab3a1ca40eff0...` | `058eb75262c16965...` |

Each 9700X tree came from `git archive` of its commit; the manifest is the SHA-256 of the tree's sorted file hashes
(`build/` left out), the same as computed locally from `git archive` of the commits (`receipts-9700x.txt`). Both builds
used `BUSTER_DEBUG_INFO=0`. The head's later commits change documentation and a test's variable name.

"none" below is the head's build with `--tier1-no-rematerialize`, which compiles Tier 1's functions spilling what they
would recompute: linear scan without rematerialization, the issue's comparison.

## Host

AMD Ryzen 7 9700X, Linux 6.18.50, clang 23.1.1, perf 7.2.9, CPU 2 at governor and EPP `performance`; Csmith 2.4.0
(`0cdc710`) and YARPGen 2.0 (`1adb290`). Every build, test and run took the shared lock (`~/buster-fast-bench/exclusive.sh`)
for one step each, and every timed run and every corpus compile was pinned to CPU 2 (`taskset -c 2`). Inputs:
`sqlite3.c` (SHA-256 `0a409f16...`, SQLite 3.53.2) and musl 1.2.5 from the frozen preprocessing corpora,
`speedtest1-unity.c` (`eadb487f...`: `sqlite3.c`, then `test/speedtest1.c`, `b5eaf4bb...`), and c-testsuite at
`5c72756`.

## Commands

The scripts are in `9700x/`, as run, from `~/buster-fast-bench/claude-178-remat`:

- `run.sh TREE`: the build; `test-tier1-select`, `-liveness`, `-emit`, `-pipeline --cross-check`, `-cfg`,
  `-frame-execution`, `-allocation`, `test-c-testsuite --tier1` on the subset and `test-checker-driver --executable`
  (head only); `corpus-counts.sh` by the vector path and by `--scalar`; and speedtest1 built by Tier 0 and by `--tier1`
  by both paths, with and without rematerialization (`9700x/logs-*`, `9700x/st-*`). Run for the head, then for main
  with `SKIP_TESTS=1 NO_REMAT=0`.
- `corpus-counts.sh COMPILER CORPORA CTS SUBSET [--scalar]`: `--tier1 --tier1-report -c` of c-testsuite's subset, the
  frozen `sqlite3.c` (the CI's options for it) and musl's units (the CI's options; a directory at a time, since two
  directories have units of one name, whose objects `-c` can't both write), with and without rematerialization, each
  corpus's units' reports summed.
- `times.sh ROUNDS BUILD...`: each build's `--verify` hash, then ROUNDS rounds of speedtest1's mix (`--shrink-memory
  --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1`) over the builds in an order that
  rotates by round, each run one hold of the lock, then perf's user instructions and cycles of one run each
  (`9700x/times-20261031T231415/`).
- `cts-times.sh TREE ROUNDS`: c-testsuite's subset built with and without rematerialization; the programs whose
  executables differ timed in ROUNDS rounds, alternating which mode runs first (`9700x/cts-tree-4851f99d/`).
- `diff.sh TREE REVISION FIRST LAST`: #142's Csmith and YARPGen campaigns at both tiers, Tier 1 by `--tier1` (which
  rematerializes), 2 programs per generator a chunk, each chunk one hold (`9700x/diff-tree-4851f99d/`: each chunk's log
  and each campaign's summary and failing cases' signatures; the generated programs and executables are left out).

## Results

### Tests (head, vector path)

Every Tier 1 test passed on the 9700X: selection 8,940 operand cases, liveness 20,433 checks, fragment emission 199,097,
pipeline 6,463 (1,920 native results, 960 clang's, 28 functions through the CFG consumer), CFG allocation 30,338,
frame execution 14,619, allocation 62,797; c-testsuite's 220 by `--tier1` (350 of the 430 functions by Tier 1); and
`test-checker-driver` 43,614 checks, its new Tier 1 fixture among them (`9700x/logs-tree-4851f99d/`).

### Spills and frames (`--tier1 -c`, vector path)

| Corpus | Build | Records | Stores | Reloads | Slots | Frame bytes | Recomputed | Left out |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| c-testsuite's subset (350 functions by Tier 1) | none | 9,598 | 22 | 22 | 12 | 16,812 | 0 | 0 |
| | main | 9,598 | 22 | 22 | | | 0 | |
| | head | 9,565 | 0 | 0 | 0 | 16,716 | 22 | 11 |
| `sqlite3.c` (2,153) | none | 158,823 | 3,583 | 4,246 | 1,318 | 185,290 | 0 | 0 |
| | main | 158,682 | 3,410 | 4,042 | | | 203 | |
| | head | 157,491 | 2,367 | 2,681 | 918 | 182,706 | 1,564 | 140 |
| musl (2,023) | none | 95,677 | 2,127 | 2,590 | 784 | 235,720 | 0 | 0 |
| | main | 95,593 | 2,021 | 2,451 | | | 136 | |
| | head | 94,862 | 1,375 | 1,567 | 527 | 233,992 | 1,020 | 85 |
| speedtest1 (2,210) | none | 164,081 | 3,620 | 4,245 | 1,324 | 192,218 | 0 | 0 |
| | main | 163,925 | 3,432 | 4,028 | | | 216 | |
| | head | 162,719 | 2,377 | 2,674 | 921 | 189,618 | 1,570 | 143 |

Main's report has neither slots nor frames, nor the definitions left out. Against none, the head takes 34% to 35% of
the large corpora's stores, 37% to 40% of their reloads and 30% to 33% of their spill slots, and every spill of
c-testsuite's; frames shrink by 0.6% to 1.4%. The scalar path's counts (`logs-tree-4851f99d/counts-scalar.txt`) are
within 1% of these, and equal a local build's of the same tree.

### speedtest1's run time

Medians of 11 runs, pinned to CPU 2, every build the same `--verify` hash (`1248168 a7fa3957...`):

| Build | Median | Range | Instructions | Cycles |
| --- | ---: | --- | ---: | ---: |
| Tier 0 | 256.42 ms | 255.65–256.86 | 5,694,164,281 | 1,331,768,226 |
| Tier 1, main | 228.05 ms | 227.73–229.70 | 4,589,308,925 | 1,169,064,650 |
| Tier 1, none | 227.75 ms | 227.16–229.06 | 4,588,344,987 | 1,167,727,016 |
| Tier 1, head | 228.44 ms | 227.34–229.63 | 4,581,048,596 | 1,168,948,588 |
| Tier 1, head, scalar path | 227.90 ms | 227.49–228.84 | 4,594,566,727 | 1,164,553,399 |
| Tier 1, none, scalar path | 228.79 ms | 228.18–229.35 | 4,600,721,236 | 1,166,130,991 |

The head runs as none does, within the runs' ranges: 7.3 million fewer instructions (0.16%) in the same cycles. The
spills it removes aren't on speedtest1's hot paths; its hottest function, `sqlite3VdbeExec`, is Tier 0's (its switch).

### c-testsuite's programs

Of the subset's 220 programs, one's executable differs with rematerialization and without: `00216`, the one with
spills (c-testsuite's 22 stores and reloads above). Its run time is 287 us both ways, the median of 11 runs each,
alternating which goes first (`9700x/cts-times.out`, `9700x/cts-tree-4851f99d/`): process startup. The first run of the
script (`9700x/cts-times-first.out`) built without `-lm`, so `00174`, which calls `sin`, failed to link both ways and
counted as differing; the script as recorded links `-lm`, as `test-c-testsuite` does.

### #142's campaigns

40 programs per generator, seeds 17800 to 17839, each built by clang `-O0` and `-O2` and by both tiers, Tier 1's with
rematerialization (`9700x/diff-tree-4851f99d/summary.txt`, by `9700x/diff-summary.sh`: each case's signature and each
build's run status and output hash):

| Outcome | Csmith | YARPGen |
| --- | ---: | ---: |
| all four builds ran and printed the same | 33 | 28 |
| clang `-O0`'s link failed (its arrays overflow `R_X86_64_PC32`): no build compared | 0 | 12 |
| every build, clang `-O2`'s and both tiers' among them, ran past the 30 s limit | 5 | 0 |
| clang `-O0`'s warnings passed the harness's 1 MB capture: Tier 0 and Tier 1 ran and agree | 2 | 0 |

No case's builds disagreed: of the 63 cases Tier 1's build ran to completion, every one printed what each other build
that completed printed. The 19 failures are all clang's own steps, as the 14 of #140's step 5 were.

## Addendum: the PR's head, after main's merge (`ca6f9096`)

buster#999's head `ca6f90962304e6b7377ebfed5406f166ff417c25` merges main `ec945e6` into the
branch and stops a definition left out from owning its register. Its tree manifest is `bc2682be0872efc6...`, the same as
`git archive`'s locally, and its `build/compiler` `ee05f466f262f3f4...` (`receipts-9700x-ca6f9096.txt`). Main's #989
puts constants added to an index into the displacement, and #991 makes a canonical narrow value's zero extension a
copy, so there are fewer constants to recompute and fewer spills without rematerialization too. The same commands
(`9700x/run-tree-ca6f9096.out`, `9700x/logs-tree-ca6f9096/`, `9700x/st-tree-ca6f9096/`):

- Tests: every Tier 1 suite above, c-testsuite's 220 by `--tier1`, and `test-checker-driver` 47,983 checks, 0 failures.
- Spills and frames, vector path:

| Corpus | Build | Records | Stores | Reloads | Slots | Frame bytes | Recomputed | Left out |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| c-testsuite's subset | none | 9,175 | 22 | 22 | 12 | 16,568 | 0 | 0 |
| | head | 9,142 | 0 | 0 | 0 | 16,472 | 22 | 11 |
| `sqlite3.c` | none | 147,419 | 3,296 | 3,902 | 1,092 | 173,698 | 0 | 0 |
| | head | 146,544 | 2,473 | 2,804 | 856 | 172,354 | 1,097 | 76 |
| musl | none | 89,252 | 2,052 | 2,456 | 649 | 228,432 | 0 | 0 |
| | head | 88,606 | 1,447 | 1,614 | 469 | 227,264 | 841 | 52 |
| speedtest1 | none | 152,517 | 3,338 | 3,909 | 1,103 | 180,530 | 0 | 0 |
| | head | 151,611 | 2,486 | 2,802 | 861 | 179,154 | 1,106 | 78 |

- speedtest1, 5 rounds (`9700x/times-20261101T000709/`), the same `--verify` hash: Tier 0 256.91 ms (256.67–257.41), Tier 1
  without rematerialization 221.88 ms (221.12–223.79), with it 222.26 ms (221.84–222.44); 4,411,361,541 and
  4,406,250,735 user instructions, 1,127,823,560 and 1,131,337,781 cycles: alike again.

## Limits

- The counts are static: each spill store or reload is a record of the code, not an execution of one.
- speedtest1 is the only program timed at length; c-testsuite's programs run for well under a millisecond, mostly
  process startup.
- The campaigns' failures were all clang's own steps; a case whose clang `-O0` link failed ran no Buster build, so its
  program tested nothing here.
- The Zen 5 model has measured no copy's latency, so its costs suppressed no recipe here; the comparison stays in place
  for when #181 measures them.
