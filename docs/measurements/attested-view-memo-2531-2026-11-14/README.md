# Attested declarations: step 3's view and step 4's memo across processes (2026-11-14)

[buster#2531](https://github.com/buster14a/buster/issues/2531)'s step 3, its third part (a unit that skips is read as
its view, its parse without the skipped declarations' tokens), merged in
[buster#2710](https://github.com/buster14a/buster/pull/2710), and step 4 (`--attested-memo`, a memo kept across
processes, the owner's choice), built in the same pull request. `docs/attested-declarations.md` in buster has the
design and these results.

- **Sources.** Base is buster main's `ca1ede6`; head is the branch's `5523d8d` (the view); `s4` is #2710's head
  `0a121e6` (the view and the memo, with main merged); `probe` and `probe3` are head with `scripts/probe.patch` (TSC
  ticks of the passes, the view, the reader and each unit; measurement only, never merged). The follow-up,
  [buster#2726](https://github.com/buster14a/buster/pull/2726): `s4b` is `ac759b8` (a one-file memo's table half full,
  loaded a block at a time); `f` is `1c886cc` (and the tree columns over the view's read declarations, the view copied
  by one loop) against `main2`, main's `74d2396` with #2710; `s4c` is `9bee943` (the one-file diagnostics fix, the
  memo an array and a table of indexes); `s4d` is `f27cc9f` (a one-file view only where a third is skipped), #2726's
  head. Every tree was built on the host by `scripts/build.sh` (Release, the host's native target,
  `BUSTER_DEBUG_INFO=0`, the CI toolchain, whose lld adds no build ID).
- **Host:** the Ryzen 7 9700X, `results/env.txt`. Every step ran in a hold of the lock (`exclusive.sh`) from a cloud
  session (`scripts/bp.sh`, the queues `scripts/queue*.sh`, each line a hold); one lane pinned to CPU 2, eight to CPUs
  0 to 15, all with `setarch -R`. A TSC tick is about 1.46 cycles.
- **Workloads:** musl's 1,336 units and the 512 generated units over the host's glibc headers as one `-c` command (the
  design record's inputs, `../file-scope-design-672-2026-11-12/`); `sqlite3.c` with `shell.c`; `-c sqlite3.c`; a small
  unit 50 times a round; and for step 4 musl's preprocessed units, a process each.

## Every object and diagnostic (`results/compare.txt`)

head against `--attested=off` and against `--scalar`, musl's 1,336 objects (321 warnings; 1,867 with `-Wall -Wextra`)
and the glibc units' 512, by one lane and by eight, with `-Wall -Wextra`, and `--attested=verify` with `-g`;
`sqlite3.c` with `shell.c`; head `off` and `on` against base: the same bytes, no contradiction, no unlisted event, no
unit read again. Every unit that skips is read as its view (musl's 1,321, the glibc units' 511). Step 4: each
preprocessed unit's process with the memo warm against without it, `s4` to `s4d`: the same bytes. In the cloud VM
(`local/`): the same comparisons by 1 and 4 lanes, and the test suites.

## Step 3: times (`results/stat-*`, `scripts/stats.py`)

| one lane, the median of 7 | `--attested=off` | main | the view | view against main | against `off` (gate) |
| --- | ---: | ---: | ---: | ---: | ---: |
| musl: ms (M cycles) | 913.9 (5,060.6) | 733.5 (4,061.3) | 721.8 (3,996.6) | 1.016 (rounds 0.975–1.019) | **1.266** (1.26; rounds 1.218–1.272) |
| glibc units: ms (M cycles) | 770.7 (4,269.6) | 467.2 (2,587.9) | 443.6 (2,457.7) | 1.053 (1.051–1.057) | **1.737** (1.7; 1.733–1.747) |
| musl: M user instructions; page faults | 10,285.2; 305,267 | 7,426.0; 289,560 | 7,165.1; 279,689 | | |
| glibc units: M user instructions; page faults | 10,312.6; 171,617 | 5,288.3; 151,024 | 4,900.7; 139,255 | | |

- **Eight lanes** (5 rounds): musl 7,152.0 against 6,906.5 M cycles (1.036), wall 188.4 against 185.5 ms; the glibc
  units 4,784.5 against 4,229.4 M (1.131), wall 128.1 against 116.7 ms.
- **`-c sqlite3.c`**: 684.0 against 684.9 M cycles; **a small unit's process**: 6.3 M each.
- **The kernel** (`results/kprofile-*`, `results/thp.txt`): musl's command takes 24 M more kernel cycles with the view
  than main's, with 10,000 fewer page faults: `clear_page_erms` is 10.4% of them against 7.8%, and the run faults in
  719 huge pages where main's faults in 318 (`/proc/vmstat`'s `thp_fault_alloc`, two runs each).

## What a skipped token still costs (`results/gone-*`, `results/perunit-*`, `scripts/perunit.py`)

| TSC ticks a skipped token | musl | glibc units |
| --- | ---: | ---: |
| the reader: the units as they are with the skip, less the units with the emulation's skipped tokens gone | 22.8 | 4.8 |
| … less the tokens the two sets read differently, at the gone units' cost a read token | 16.9 | 4.3 |
| … a least-squares fit of each unit's reader ticks on its definition, other read and skipped tokens, two rounds | 13.0, 22.8 | 0.6, 0.7 |
| the view's copies | 2.6 | 1.0 |
| the passes | 31.9 | 18.4 |

The compile reads 58,815 of musl's tokens that the gone units lack (6,894 of the glibc units'); a read token outside
a definition costs the reader 450 to 550 ticks by the fit, a body's 150 to 160. At that price musl's residual is about
11.6 ticks, 17 cycles, against the gate's 20; the fit is unsteady on musl. The passes by the census
(`results/census-*`, cycles a token of the units): musl 27.6 (lists 11.4, chain 6.4, reach 5.1 with the runtime names,
literals 3.6), glibc units 24.6.

## Step 4 (`results/stat-ppu-*`, `results/stat-sqlite4-*`, `scripts/run4.sh`)

Each round runs the same build without the memo and with it warm (a process each of musl's preprocessed units, then
`sqlite3.c` twice, all with the memo, `run4.sh warm`), in one hold of the lock; 5 rounds each.

| musl's preprocessed units, a process each: M cycles | without the memo | with it warm | | gate 1.08 |
| --- | ---: | ---: | ---: | --- |
| `s4` (#2710) | 8,240.6 | 8,149.3 | **1.011** | ✗ |
| `s4b` (the table half full) | 8,242.0 | 7,755.3 | **1.063** (rounds 1.054–1.074) | ✗ |
| `s4c` (an array and a table of indexes) | 8,188.7 | 7,487.5 | **1.094** (1.090–1.097) | ✓ |
| `s4d` (#2726's head) | 8,178.6 | 7,463.1 | **1.096** (1.073–1.099) | ✓ |

| `-c sqlite3.c`: M cycles | without the memo | with it warm | | gate 1.02 |
| --- | ---: | ---: | ---: | --- |
| `s4` | 683.4 | 684.2 | **0.999** | ✗ |
| `s4b` | 683.8 | 681.5 | **1.003** (1.001–1.007) | ✗ |
| `s4c` | 680.3 | 676.7 | **1.005** (1.003–1.007) | ✗ |
| `s4d` | 680.7 | 664.3 | **1.025** (1.021–1.026) | ✓ |

| page faults: musl's units' processes; `sqlite3.c` | without the memo | with it | more a process |
| --- | ---: | ---: | ---: |
| `s4` | 791,559; 6,902 | 1,212,826; 12,248 | 316 |
| `s4b` | 795,382; 6,901 | 945,508; 12,113 | 112 |
| `s4c` | 802,651; 6,905 | 905,101; 12,018 | 77 |
| `s4d` | 801,875; 6,905 | 900,983; 8,164 | 74 |

- **Where the faults were** (`results/faults-*`, `results/kppu-*`: `perf record -e page-faults -c 1 -d` over every fourth
  unit, `scripts/run7.sh faultprof`; `results/sq-*`: `sqlite3.c`'s faults and user and kernel cycles by symbol,
  `scripts/run8.sh sqliteprof`). At `s4b`, `check_attested_memo_add` took 8.9% of the units' processes' faults, 63 a
  process: musl's memo holds 3,448 hashes, and a table of 16-byte slots half full with slack took 16,384 of them, 64
  pages. `s4c` keeps a one-file command's hashes in an array read by one `pread` and a table of 32-bit indexes, 22
  pages; its load is 2.6% of the faults. `sqlite3.c`'s view took about 4,000 of its 12,113 faults with the memo
  (`memmove` 21.9%, `check_attested_view` 11.0%): it copied the 94% of the unit it reads to skip 6% of it. `s4d` makes a
  one-file command's view only where it skips a third of the unit's tokens or more; 1,158 of musl's 1,331 units with
  tokens still are (a debug count in the cloud VM).
- **A bug in #2710's step 4, found here:** a one-file command's stream was never the preprocessor's diagnostics, so a
  unit that skipped and failed printed its errors twice. #2726 fixes it, with a test that fails without the fix. No
  run above has a failing unit.
- **Every object and diagnostic** of the units' processes with the memo is without it's, at `s4`, `s4b`, `s4c` and
  `s4d` (`results/compare.txt`); `sqlite3.c`'s too, in the cloud VM.

## #2726's view changes against main (`results/stat-musl-*`, `results/stat-glibc-*` with `main2` and `f`)

| `-c` of the command | musl, 1,336 units | 512 units over glibc's headers |
| --- | ---: | ---: |
| one lane, 5 rounds: main with `--attested=off`; main; `f`, M cycles | 5,084.6; 4,038.2; 4,032.7 | 4,268.7; 2,454.8; 2,454.9 |
| `f` against main | 1.001 (rounds 1.001–1.056) | 1.001 (0.998–1.002) |
| step 3's gate: against `--attested=off` | **1.261** (1.258–1.273) ✓ | **1.739** (1.732–1.749) ✓ |
| eight lanes, 3 rounds: main → `f`, M cycles; wall ms | 6,741.7 → 6,561.1; 179.7 both | 4,155.7 → 4,203.8; 115.3 → 116.4 |

The follow-up's tree columns and one-loop copy change the one-lane totals by under 0.2%. `f`'s objects and diagnostics
with `--attested=on` are its `--attested=off`'s, on musl by one lane and eight and on the glibc units by one
(`results/compare.txt`). The later commits (`s4c`, `s4d`) change only a command of one source file.

## Limitations

- Other sessions held the lock between ours throughout; each hold was under a few minutes, and a round's trees ran in
  turn within one hold.
- The probe's ticks are wall time on CPU 2; the rounds' figures are `perf stat`'s.
- The memset call graph (`results/callgraph-*`) found no callers in the static executable's frames.
