# Windows of 2,048 tokens as the driver's default (buster#2536, step 1, 2026-11-14)

The owner made step 1's windows ([`all-core-step1-2536-2026-11-14`](../all-core-step1-2536-2026-11-14/)) the driver's
default: buster `0c536ff6b6bf73738be4654f4d1ade30ffcee942` (`head4` here), on main `74d23965`, sets
`--emit-window=2048` unless the command says otherwise. This record checks on the 9700X that the default is the
windows, and that one worker is not slower by them.

**In short.** By default, eight workers compile `sqlite3.c` with the lowering's faults of a window (934 a compile,
against 2,139 by `--emit-window=0`), the emission at 1.19 times its one-worker user cycles (1.32), and 292.96 MB/s
(286.40). One worker: the same user cycles by an interleaved comparison in two holds (medians 597.4 and 596.1 M by
default, 596.7 and 596.7 M by `--emit-window=0`), and the same object.

## What was run

- **The executable:** `head4`, a Release build under the lock (`raw/build-head4.log`, SHA-256 in `raw/commit.txt`).
- **The gauges** (`scripts/default.sh`): step 0's, `gauge-head4-default` with no window option and `gauge-head4-w0`
  with `--emit-window=0`, each two holds of the lock, one after the other. No strays.
- **The comparison at one worker** (`scripts/ab.sh`, run by `scripts/ab-run.sh` twice, one hold each): `sqlite3.c`'s
  `-c --lanes 1` on CPU 2, the default and `--emit-window=0` alternating, 15 runs each, each counted by `perf stat`
  (`raw/ab-N/runs.tsv`: run, way, user cycles, user instructions, kernel cycles).

## The gauges

| `sqlite3.c` | `--emit-window=0` | default |
| --- | ---: | ---: |
| eight workers, MB/s | 286.40 | 292.96 |
| their user cycles | 1,072.4 M | 1,054.1 M |
| their kernel cycles | 275.2 M | 246.1 M |
| `lower`'s faults at eight | 2,139 | 934 |
| the emission, times its one-worker user cycles | 1.32 | 1.19 |
| one worker, MB/s | 74.99 | 74.04 |
| its user cycles | 599.2 M | 615.4 M |

**The one-worker rows of the gauges disagree with each other, and not by the windows.** In `gauge-head4-default`, the
compiles of rounds 0 to 4 took 615 to 621 M user cycles and those of round 5 595 M, with the same executable and options
(`raw/gauge-head4-default/counted/r*.one.rows.tsv`); its first run found the host busy and took base pages. In
`gauge-head4-w0`, round 1 took 616 M and the others 597 to 601 M. The host's state moved between rounds (other
sessions' work between holds, below the strays' threshold), so the gauges' one-worker medians don't compare. The
interleaved comparison does.

## One worker, interleaved

| hold | default, median (min, max) | `--emit-window=0`, median (min, max) |
| --- | --- | --- |
| 1 | 597.4 M (594.5, 604.7) | 596.7 M (593.8, 599.4) |
| 2 | 596.1 M (594.1, 599.8) | 596.7 M (593.8, 600.1) |

User cycles of 15 runs each. Instructions: 1,363.0 M by default against 1,361.2 M (+0.13%). The objects of both ways
are the same bytes (each hold's `runs.tsv` ends with the comparison).

## Files

`raw/gauge-head4-*`: each gauge's tables, logs, rows, strays and the counted runs' reports. `raw/ab-N/`: the comparison's
runs and its hold's log. `raw/substages.txt`: the laps' medians. `scripts/`: every script as run. `SHA256SUMS`: every
file's hash, from the host.
