# Attested declarations: #2531's leftovers, and the view's extra huge pages (2026-11-14)

The last part of [buster#2531](https://github.com/buster14a/buster/issues/2531), after steps 3 and 4
([the step 3/4 record](../attested-view-memo-2531-2026-11-14/)): four leftovers, claimed in
[the issue](https://github.com/buster14a/buster/issues/2531#issuecomment-6879821891).

- **`-g` skips** ([buster#2764](https://github.com/buster14a/buster/pull/2764), merged): a unit's DWARF describes what
  its definitions reach, as clang's does (`check_debug_value_roots`), so every `-g` object is `--attested=off`'s and
  `-g` no longer turns the skip off.
- **Every field of the reader's state has a class** (#2764): `test-checker --attested` reads `CheckInput`'s and
  `CheckInputReader`'s fields by `__builtin_dump_struct` and fails when one has none.
- **The view's extra huge pages** ([buster#2771](https://github.com/buster14a/buster/pull/2771)): a viewed unit's two
  scratch discards keep what the unit's parse would have kept.
- **The passes' cost on a large unit**: profiled here, filed as
  [buster#2769](https://github.com/buster14a/buster/issues/2769).

`docs/attested-declarations.md` in buster has the design and these results.

- **Sources.** `mainF` is buster main's `c513832` (#2771's base before its rebase onto main); `fixF` is `be7b62b`:
  `mainF` with `7e6b73e` (the fields' classes) and `72bc24d` (`-g`), #2764's commits, and `be7b62b` (the discards),
  whose change is #2771's `1826dea` before that rebase. `m9` is main's `2909b2c` with a measurement-only probe patch
  (`scripts/noview.patch`, then `probe2.patch` to `probe4.patch`, each the previous one and more; never merged), whose
  environment variables pick the probe's way. Every tree was built on the host by the previous record's
  `scripts/build.sh` (Release, the host's native target, `BUSTER_DEBUG_INFO=0`, the CI toolchain).
- **Host:** the Ryzen 7 9700X (`../attested-view-memo-2531-2026-11-14/results/env.txt`). Every step ran in a hold of
  the lock (`exclusive.sh`) from a cloud session, queued as a `systemd-run --user` unit (`scripts/queue*.sh`, each
  line a hold); one lane pinned to CPU 2, eight to CPUs 0 to 15, all with `setarch -R`. Huge pages faulted are
  `thp_fault_alloc`'s difference in `/proc/vmstat` across the command.
- **Workloads:** musl's 1,336 units and the 512 generated units over the host's glibc headers as one `-c` command (the
  design record's inputs, `../file-scope-design-672-2026-11-12/`); for step 4's gates, musl's preprocessed units, a
  process each, and `-c sqlite3.c`.

## Every object and diagnostic (`results/compare14.txt`)

`fixF` with `--attested=on` against `--attested=off`: musl's 1,336 objects (321 warnings) by one lane and by eight,
and the glibc units' 512 by one lane, without `-g` and with it: the same bytes, the same diagnostics. In the cloud VM
(`local/g-checks.txt`): with `-g` by 1 and 4 lanes, with `-Wall -Wextra`, and against `--scalar -g`, the same; and
`local/mut-test.txt`, the failed-units memo test failing on a mutation of its fix, as it should.

## The view's huge pages: where they came from (`results/thp9.txt`, `thp13.txt`, `thp16.txt`)

musl's command, one lane, `m9`'s ways, two rounds each (the counts were the same in both, within 3):

| musl's command, one lane | huge pages | page faults | M kernel cycles |
| --- | ---: | ---: | ---: |
| with the view (main) | 719 | 279,011 | 1,094 |
| the reader's discard sized by the parse alone (`BUSTER_PROBE_KEPT_PARSE`) | 719 | 279,011 | 1,072 |
| the census's arenas in base pages (`BUSTER_PROBE_UNIT_BASE`) | 714 | 279,944 | 1,083 |
| without `check_program`'s scratch discard (`BUSTER_PROBE_NO_PROGRAM_DISCARD`) | 533 | 278,825 | 1,062 |
| without the view (`BUSTER_ATTESTED_NO_VIEW`) | 318 | 288,879 | 1,050 |
| `--attested=off` | 311 | 304,585 | 1,070 |
| `--attested=off` without `check_program`'s discard | 3 | 358,854 | 1,134 |

`perf record` of the kernel's cycles with user call chains (`results/kthp9-m9on.txt`, `kthp15-m9on.txt`;
`scripts/thpattr*.py`) put the huge-page clears under `memset`s, the largest named caller `check_program` (the page faults by mapping, with the view and without it, are
`results/faultmap12-*.txt`, by `scripts/faultmap.py`). A lane gives a unit's
scratch back after the reader (keeping 96 bytes a token) and at `check_program`'s end (in whole huge pages past its
columns), both sized by the view's tokens, where the next unit's parse and reader push in proportion to its whole parse.
Neither discard alone accounts for all of it (the reader's alone changes nothing, `check_program`'s alone 186 of the
401), so #2771 sizes both by the parse.

## The final rounds (`results/stat14-*`, `wall14-*`, `thp14-*`; `scripts/run14.sh`, `scripts/stats14.py`)

One lane, the median of 5 rounds, each round's ways in turn in one hold of the lock:

| one lane | `fixF --attested=off` | `mainF` | `fixF` | `mainF` against `fixF` | `off` against `fixF` |
| --- | ---: | ---: | ---: | ---: | ---: |
| musl: ms (M cycles) | 919.7 (5,042.2) | 731.5 (4,000.7) | 721.7 (3,939.8) | **1.018** (rounds 1.011–1.051) | **1.280** (1.276–1.284) |
| musl: huge pages; page faults; M kernel cycles | 311; 304,550; 1,070.2 | 719; 279,009; 1,069.2 | 222; 278,483; 1,019.3 | | |
| glibc units: ms (M cycles) | 777.9 (4,265.8) | 451.4 (2,457.1) | 443.7 (2,416.0) | **1.016** (1.004–1.019) | **1.764** (1.741–1.767) |
| glibc units: huge pages; page faults; M kernel cycles | 16; 171,100; 497.7 | 192; 138,768; 455.6 | 17; 138,570; 434.2 | | |

The user instructions are the same (musl's 7,178.6 M and 7,178.7 M; the glibc units' 4,895.5 M and 4,895.6 M): the
change is the kernel's clears and the caches' warmth of pages kept. Step 3's gate against `--attested=off`, 1.26 and
1.7, held at 1.266 and 1.737 and holds at 1.280 and 1.764.

**`-g`**, one lane, the median of 5 rounds: `mainF` skips nothing with `-g`, `fixF` skips.

| one lane, `-g` | `mainF` | `fixF` | `mainF` against `fixF` |
| --- | ---: | ---: | ---: |
| musl: ms (M cycles) | 994.9 (5,449.8) | 758.8 (4,119.1) | **1.315** (rounds 1.312–1.342) |
| musl: huge pages; page faults; M user instructions | 311; 301,206; 10,718.7 | 222; 273,997; 7,290.7 | |
| glibc units: ms (M cycles) | 901.1 (4,954.3) | 510.5 (2,786.4) | **1.778** (1.775–1.796) |
| glibc units: huge pages; page faults; M user instructions | 0 to 16; 195,946; 11,703.7 | 17; 161,198; 5,672.3 | |

`-g` now costs musl's command 1.045 times the cycles without it (4,119.1 against 3,939.8 M) and the glibc units' 1.153
(2,786.4 against 2,416.0 M).

**By eight lanes**, the median of 3 rounds:

| eight lanes | `mainF` | `fixF` | `mainF` against `fixF`: cycles; wall |
| --- | ---: | ---: | ---: |
| musl: ms (M cycles) | 183.4 (6,849.3) | 174.3 (6,467.6) | **1.065** (rounds 1.036–1.075); 1.055 (1.024–1.056) |
| musl: huge pages; M kernel cycles | 434 to 450; 2,693.1 | 228 to 235; 2,519.7 | |
| glibc units: ms (M cycles) | 118.7 (4,397.5) | 114.6 (4,239.1) | **1.036** (1.016–1.107); 1.066 (1.036–1.085) |
| glibc units: huge pages; M kernel cycles | 206 to 217; 1,323.2 | 95 to 96; 1,247.6 | |

## Step 4's gates with these changes (`results/stat-ppu-fixF*`, `stat-sqlite4-fixF*`)

`fixF`, the median of 3 rounds, by the previous record's `scripts/run4.sh` (`warm` makes the memo,
`results/memo-fixF.txt`; `ppucompare` compares a process a unit with the memo warm against without it, every object
and diagnostic the same, `results/compare-memo.txt`):

| step 4's gates, `fixF` | without the memo | with it warm | gain (gate) |
| --- | ---: | ---: | ---: |
| a process a musl preprocessed unit, all 1,336: M cycles (page faults) | 8,267.1 (812,502) | 7,314.8 (857,499) | **1.130** (1.08; rounds 1.110–1.133) |
| `-c sqlite3.c`: M cycles (page faults) | 680.8 (6,879) | 665.7 (8,140) | **1.023** (1.02; 1.019–1.024) |

#2726's head measured 1.093 and 1.025 the same way (the previous record's `s4d`).

## The passes on a large unit (`results/sqpasses-m9*.txt`)

`-c sqlite3.c` by `m9`, with the memo warm and without (`scripts/run11.sh`): `perf record` of user cycles puts the
passes (`check_attested_lists`, `reach`, `chain`, `levels`, `ids`, `hashes`, `literals`, `after`, `lane_open`) at
2.3% of the process, `check_attested_lists` the largest at 0.9%, for the 6% of the unit's tokens it skips. Their
vector path (the declaration lists, the key arrays, the ids made lazily) is
[buster#2769](https://github.com/buster14a/buster/issues/2769).

## Files

- `scripts/`: the queues (`queue14.sh` to `queue22.sh`), the steps (`run9.sh` to `run16.sh`; `run11.sh` and the
  final rounds' memo steps call the previous record's `run4.sh`), the probe patches, and the analyses
  (`thpattr*.py`, `faultmap.py`, `stats14.py`).
- `results/`: as named above; `compare14.txt` the objects' comparisons.
- `local/`: the cloud VM's checks.
