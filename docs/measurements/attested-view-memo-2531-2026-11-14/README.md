# Attested declarations: step 3's view and step 4's memo across processes (2026-11-14)

[buster#2531](https://github.com/buster14a/buster/issues/2531)'s step 3, its third part (a unit that skips is read as
its view, its parse without the skipped declarations' tokens), merged in
[buster#2710](https://github.com/buster14a/buster/pull/2710), and step 4 (`--attested-memo`, a memo kept across
processes, the owner's choice), built in the same pull request. `docs/attested-declarations.md` in buster has the
design and these results.

- **Sources.** Base is buster main's `ca1ede6`; head is the branch's `5523d8d` (the view); `s4` is #2710's head
  `0a121e6` (the view and the memo, with main merged); `probe` and `probe3` are head with `scripts/probe.patch` (TSC
  ticks of the passes, the view, the reader and each unit; measurement only, never merged); `s4b` is the follow-up's
  `ac759b8` (the memo's state faulting in less). Every tree was built on the host by `scripts/build.sh` (Release, the
  host's native target, `BUSTER_DEBUG_INFO=0`, the CI toolchain, whose lld adds no build ID).
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
preprocessed unit's process with the memo warm against without it, `s4` and `s4b`: the same bytes. In the cloud VM
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

| 5 rounds, `s4` | without the memo | with it warm | | gate |
| --- | ---: | ---: | ---: | ---: |
| musl's preprocessed units, a process each: M cycles (user, kernel) | 8,240.6 (4,143.5, 4,097.0) | 8,149.3 (3,486.0, 4,663.3) | **1.011** | 1.08 |
| … page faults | 791,559 | 1,212,826 | | |
| `-c sqlite3.c`: M cycles | 683.4 | 684.2 | **0.999** | 1.02 |

The memo saves 15.8% of the processes' user cycles and loses it to 316 more page faults a process (its table sized at a
quarter full with slack, 128 pages for 3,000 hashes, and its file copied). `sqlite3.c` skips 2,156 of its 6,873
file-scope declarations, 40,639 tokens. `s4b` (half full, loaded a block at a time, the lists' vector path without the
cache) takes 43 more faults a process than without the memo in the cloud VM, where `s4` took 247; its 9700X rounds
follow.

## Limitations

- Other sessions held the lock between ours throughout; each hold was under a few minutes, and a round's trees ran in
  turn within one hold.
- The probe's ticks are wall time on CPU 2; the rounds' figures are `perf stat`'s.
- The memset call graph (`results/callgraph-*`) found no callers in the static executable's frames.
