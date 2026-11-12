# Semantic windows: falsifying experiment (buster#672)

The falsifying experiment of [the semantic architecture research comment on #672](https://github.com/buster14a/buster/issues/672#issuecomment-6749355847)
(its §5). It asks whether a compile's cost per token depends on how much of the unit
is live, which is the premise of function-major windows (about 2,000 tokens each).

**Verdict: not falsified.** At eight workers, the marginal user cycles per token
inflate 1.08× over one worker while the unit is one 2,000-token cluster. The
inflation then grows with the unit (1.26×, 1.66×, 2.23×, 1.80×). The curve is far
from flat: the eight-worker marginal cost per token rises 1.34× from the smallest
step to the largest, and 1.96× from the 1→4 step. On one worker, marginal DRAM bytes per
token rise 6.7–8.6×. Two parts of the prediction come out weaker than it said:
the one-worker user cycles per token stay flat up to 125K tokens, and at eight
workers the DRAM bytes per token rise only 1.2–2.1×.

## Method

- **Source:** buster `ac34a0ce34bfa5b52dca6c5d37409d98e5091b40` (main), `./build.sh` Release
  (`-march=native`), built under the lock on the 9700X; `src/build/compiler` SHA-256 in [env.txt](env.txt).
- **Units:** [`scripts/gen-cluster.c`](scripts/gen-cluster.c) writes N copies of one self-contained
  cluster of 1,955 parser tokens. Each copy has 3 types, 2 enums, file-scope data and 17 external
  functions that call each other, with loops, a switch, a state machine, recursion, a 4×4 matrix product, and
  string and bit work. Each copy's identifiers are renamed `_K`. There is no `#include` and no macro.
  N = 0 (`int empty_unit;`, the process's fixed cost), 1, 4, 16, 64, 350. The token counts are the
  compiler's own (`time-process tokens`): 3, 1,955, 7,820, 31,280, 125,120 and 684,250. The largest
  is about sqlite3.c's 716,157. The units are not stored here: `gen-cluster N` regenerates them, and
  their SHA-256 values in [env.txt](env.txt) match.
- **Compile:** `compiler --predefines predefines-znver5.h -march=znver5 -fwrapv -funsigned-char -c --lanes 1 -o OUT uN.c`,
  a fresh process each time ([`worker.sh`](scripts/worker.sh)).
- **One worker:** LOOPS compiles in a row pinned to CPU 2. **Eight workers:** LOOPS compiles on each
  of CPUs 0–7 (one per physical core), all at once ([`fan.sh`](scripts/fan.sh)). LOOPS is 200
  for N ≤ 1, then 100, 40, 12 and 4.
- **Counters:** every batch runs twice. The first run is under `perf stat` (inherited, per task) with
  `task-clock,cycles:u,cycles:k,instructions:u,instructions:k,page-faults`. The second is under
  `perf stat -a` with `amd_umc` CAS read and write commands, activates and the memory clock. DRAM
  bytes are (read + write CAS) × 64, minus each round's 2 s idle rate over the batch's wall time
  ([`round.sh`](scripts/round.sh)).
- **Rounds:** five rounds, each in one hold of the 9700X's lock (`exclusive.sh`), with the size order
  rotated per round and 30 s between holds ([`campaign.sh`](scripts/campaign.sh)). Each round's
  `holder.txt` is the owner file's line at the start of its hold, and every round wrote its `.done`.
  The campaign exited 0 ([campaign.log](campaign.log), with the lock's wait messages about other
  sessions removed). [`stages.sh`](scripts/stages.sh) ran one `--time-stages` compile per size
  (three, the last kept) in a first hold. It left no holder receipt, but campaign.sh runs it through
  `exclusive.sh`.
- **Reduction:** [`reduce.c`](scripts/reduce.c) takes the per-compile medians of the five rounds and
  the marginal cost per token between consecutive sizes. `reduce raw UNITS` reproduces
  [tables.md](tables.md) byte for byte.

## Results

Medians of five rounds, per compile. 1w is one worker and 8w is eight.

| copies | tokens | user Mcycles 1w | 8w | 8w/1w | kernel Mcycles 1w | 8w | user Minstr | DRAM MB 1w | 8w |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 3 | 0.653 | 0.918 | 1.41 | 1.807 | 2.463 | 0.640 | 1.15 | 1.91 |
| 1 | 1,955 | 3.023 | 3.480 | 1.15 | 3.131 | 3.862 | 5.543 | 1.81 | 4.58 |
| 4 | 7,820 | 7.188 | 8.747 | 1.22 | 3.927 | 7.110 | 18.945 | 3.36 | 11.04 |
| 16 | 31,280 | 23.443 | 35.723 | 1.52 | 10.497 | 17.148 | 72.606 | 47.95 | 48.61 |
| 64 | 125,120 | 90.736 | 185.831 | 2.05 | 31.292 | 55.201 | 287.701 | 258.93 | 238.40 |
| 350 | 684,250 | 635.997 | 1168.241 | 1.84 | 92.293 | 280.975 | 1576.331 | 1535.47 | 1537.08 |

Marginal cost per token between consecutive sizes:

| step | user cycles/token 1w | 8w | 8w/1w | kernel cycles/token 1w | 8w | user instr/token | DRAM bytes/token 1w | 8w |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 0→1 | 1214.0 | 1312.5 | **1.08** | 678.0 | 717.0 | 2511.6 | 338 | 1368 |
| 1→4 | 710.3 | 898.1 | 1.26 | 135.7 | 553.8 | 2285.1 | 266 | 1102 |
| 4→16 | 692.9 | 1149.9 | 1.66 | 280.1 | 427.9 | 2287.3 | 1901 | 1602 |
| 16→64 | 717.1 | 1599.6 | **2.23** | 221.6 | 405.5 | 2292.1 | 2248 | 2023 |
| 64→350 | 975.2 | 1757.0 | 1.80 | 109.1 | 403.8 | 2304.7 | 2283 | 2323 |

Throughput across workers (8w MB/s ÷ 1w MB/s, from batch wall times) falls from 6.0× at one copy to
5.0×, 4.6×, 4.2× and 4.0× at 350 copies. The full tables are in [tables.md](tables.md).

Across the five rounds, the user cycles per compile agree within 1%, except for round 4's 350-copy
runs, which were about 8% higher on both one and eight workers.

## Against the prediction

The prediction (§5): "the eight-worker inflation of user cycles (1.97× today) stays under 1.15×
while the unit fits L2 and returns as it grows, and marginal DRAM bytes per token rise at least
3×. A curve flat within 15% falsifies the design."

- **Inflation under 1.15× while the unit fits L2:** yes. At 0→1 it is 1.08× at the margin and 1.15×
  for the whole compile. A 2K-token unit's peak working set is about 0.7 MB at roughly 340–380 bytes
  per token (350 copies peak at 258 MB of RSS, 377 bytes per token).
- **It returns as the unit grows:** yes. 1.26× at 8K tokens, 1.66× at 31K and 2.23× at 125K. At
  684K it is 1.80×, about #672's 1.97× for sqlite3.c.
- **Marginal DRAM bytes per token rise at least 3×:** yes on one worker, from 266–338 to 1,901–2,283
  (6.7–8.6×). At eight workers they rise only from 1,102–1,368 to 1,602–2,323 (1.2–2.1×). With eight
  processes, each small unit's DRAM traffic is already high. That is mostly per-process setup and
  fresh pages (the empty unit moves 1.9 MB at 8w against 1.15 MB at 1w) in a shared 32 MB L3. A
  window that reuses one arena inside a process has neither, so this experiment probably overstates
  a window's eight-worker traffic.
- **Not flat:** the eight-worker marginal cost per token rises 1.34× from 0→1 to 64→350 and 1.96×
  from 1→4. On one worker, 1→4, 4→16 and 16→64 stay within 4% (693–717 cycles per token). Only
  64→350 rises, by 37%.

Instructions per token stay at 2,285–2,305 from 1→4 on, so none of the cycle changes come from extra
work. They are the memory side alone.

## What it means for the design

- The windowed design's gain is mainly a **multicore** gain. On one core, a unit up to about 125K
  tokens already costs the same per token as a 2K-token one, in user cycles. Only the largest unit
  costs more (+37% user cycles per token at the margin). The one-core hypothesis of 1.2–1.35× is
  therefore plausible only for sqlite-sized units, and through kernel and stall cycles.
- At eight workers, per-token user cycles at the margin go from 898 (1→4) to 1,757 (64→350).
  Windows of 2K–8K tokens would remove up to about half of the eight-worker user cycles per token in
  large units, if a window really behaves like a small unit. That is the ~2× the comment estimated.
- The eight-worker inflation is a DRAM-bandwidth effect. At 350 copies, eight workers move about
  1.54 GB per compile × 32 compiles in 1.12 s, about 44 GB/s. That matches #672's 45.9 GB/s
  ceiling.

## Limitations

- The cluster is synthetic: 4.05 source bytes per token against sqlite3.c's 13.3. DRAM bytes per
  *source byte* are therefore not comparable with #672's 165–269; use per-token figures. The 350-copy
  unit moves 2,244 bytes per token, against about 3,560 for sqlite3.c in #672's UMC run.
- Every copy is the same code, so caches and branch predictors may favour repeats more than real
  code does. Instructions per token are constant, so the compiler does no less work per copy.
- A small unit compiled in a fresh process is a proxy for a window. It includes the process's setup
  and fresh pages, which a window reusing one arena would avoid, and it omits the spine and the
  environment lookups a window would add.
- CPU 2 runs the performance governor and EPP. CPUs 0, 1 and 3–7 run powersave with
  balance_performance ([env.txt](env.txt)). Cycle counts are mostly frequency-independent, but
  memory stalls in cycles are not.
- No `tools/microarch` run: the counters are perf stat's, per task and system-wide, as described
  above.

## Files

- [`scripts/`](scripts/): the generator, the run scripts and the reducer, in the versions that ran
  (`reduce.c` gained its UNITS argument for this record, and its output is unchanged).
- [`raw/rN/`](raw/): every round's perf stat CSVs (`uN.wW.core.csv`, `uN.wW.umc.csv`), batch wall
  times in microseconds (`.us`), loops, the idle UMC measurement, `holder.txt` and `.done`.
- [`raw/stages/`](raw/stages/): one `--time-stages` report per size.
- [env.txt](env.txt): kernel, CPU, governors, THP, tools, source commit and SHA-256 of the
  compiler, units and scripts.
