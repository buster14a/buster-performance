# The 9700X placements move .text's code again (2026-11-14)

The record of [buster#2728](https://github.com/buster14a/buster/issues/2728), fixed by
[buster#2733](https://github.com/buster14a/buster/pull/2733) (branch `claude/dazzling-albattani-nwbrr2-placements`,
`f7455375`). Found while measuring #2559's step 5 (buster#2715; its record is
`release-in-parts-renewed-2559-2026-11-14`, which shares this workspace and harness).

**The finding.** `./build.sh shifts … main.c 0 1088 2112 3136`, the 9700X job's four placements (#509, #1050), moved
none of `.text`'s code. Each unit's `.text.buster_checker` section is page-aligned (#502); it is emitted in every unit,
empty where the unit has none of the checker's code. Since every unit compiles with `-ffunction-sections`, that
section came before the unit's functions in `.text`, so each unit's code started on a page. With the start's code order
(#1444), the shift's padding went into `.text.buster_start`, before the page-aligned `.text`. A comparison over the four
placements therefore measured one layout four times (or two, a page apart), and base-against-itself floors were tight.

**The fix.**
- The start order's linker script puts every unit's `.text.buster_checker` together, between `.text.buster_start` and
  `.text`, each still page-aligned.
- Where the shift source has start-ordered functions (`main.c`), the padding object gains
  `.text.buster_shift_padding_text`, whose symbol leads `start-order.symbols`, so that lld puts it first in `.text`.
- A shifted link's post-link step checks that `main_unit_backend` moved by the shift's multiple of 64, give or take
  whole pages.

## 1. Where the code was (`raw/9700x/addresses.txt`)

`nm` of each placement's executable, built on the 9700X as its job builds them (CI's staged Clang/LLD 23.1.4,
`BUSTER_HOST_ARCH=znver5`, `BUSTER_DEBUG_INFO=0`, `scripts/9700x/build.sh … shifts`):

| Build | `run_c_environment_benchmark` at shifts 0 / 1088 / 2112 / 3136 |
| --- | --- |
| main `ca1ede6a` (`base`) | `0x1091350` / `0x1091350` / `0x1091350` / `0x1091350` |
| main `98186d5` (`m2`) | `0x10901f0` / `0x10901f0` / `0x10911f0` / `0x10911f0` (a page, when the start padding crosses one) |
| #2733 `f7455375` (`p`) | `0x15e55a0` / `0x15e59e0` / `0x15e6de0` / `0x15e71e0` |
| #2733 + #2715 (`ph`) | `0x17f33d0` / `0x17f3810` / `0x17f3c10` / `0x17f4010` |

On main, `readelf -SW` shows `.text.buster_start` at `0xd16c80` (`0xbf71d` bytes) and `.text` at `0xdd7000`, aligned to
4096. A shift source with no start-ordered function doesn't help: `build.sh shifts DIR main_unit_x86.c 0 16 32 48`
(`base-x86pad`) put the padding at `0xf1a3a8`, right before `x86_encoder_initialize_address32`, which starts on a page
(main_unit_x86's checker section), at `0xf1b000` in all four.

Locally (a 4-CPU cloud container, Ubuntu's clang 23.1.6 and CI's 23.1.4, Release, `BUSTER_DEBUG_INFO=0`), #2733's
shifts of 0, 64, 1088, 2112 and 3136 moved `main_unit_backend`, `run_c_environment_benchmark` and
`run_unwind_benchmark` by 0, 64, 1088, 2112 and 3136 + 4096 bytes. A shift's remainder below 64 bytes moves nothing past
the first function aligned to 64: the C library's string functions, first in `.text`, and `aligned(64)` functions in
`main.c`, `ir_optimize.c` and others.

## 2. What a place within a line costs (`raw/9700x/results/bench/*.base-envpad.txt`)

`scripts/9700x/envpad.sh` builds main with a dead `used` function of 16, 32 or 48 bytes right before
`run_c_environment_benchmark` and before `run_unwind_benchmark`, which moves each within its 64-byte line and nothing else
(`base-envpad`, against `base-flat`, main's executable four times). `time-runs`, 11 runs, user cycles:

| Benchmark | 0 | 16 | 32 | 48 | Over the four, against main |
| --- | ---: | ---: | ---: | ---: | --- |
| `benchmark-environments` | 251.91 M | 252.70 M | 253.43 M | 255.46 M | +0.61% (−0.09% to +1.72%) |
| `benchmark-unwind` | | | | | +1.26% (−1.90% to +4.79%), floor −2.21% to +2.74% |

The 9700X job's placements, multiples of 64, can't sample this, before or after #2733.

## 3. The layout change against main (`raw/9700x/results/ab-2733.txt`)

#2733's executable moves the checker's sections out of `.text` and the other units' code off its pages. Against main
`98186d5` (`m2`), with #2733 at `f7455375` (`p`), both built as the 9700X job builds them:
`scripts/9700x/bench.sh`, `time-runs` of main, #2733 and main again, each at the four placements (main's moving by
whole pages at most), after a warm-up, pinned as the job pins each step; the verdict is `analyze.sh`'s.

| Benchmark | Runs | #2733 against main, user cycles | Over the placements | Main against itself | Verdict |
| --- | ---: | ---: | ---: | ---: | --- |
| `benchmark-assembler` | 44 | −0.37% | −0.92% to +0.16% | −0.48% to +0.76% | inside |
| `benchmark-environments` | 44 | −0.10% | −0.62% to +0.26% | −0.16% to +0.30% | inside |
| `benchmark-unwind --functions 64` | 44 | +1.48% | −1.82% to +2.50% | −1.76% to +2.37% | inside |
| `benchmark-checker-source` (`sqlite3.c`) | 4 | +0.05% | −1.83% to +0.85% | −1.12% to +0.61% | inside |
| `benchmark-checker-source` (musl's `regcomp.c`) | 4 | −2.26% | −5.63% to +0.76% | −4.90% to −0.35% | inside |
| `-c sqlite3.c` | 44 | +0.22% | −0.12% to +0.62% | −0.18% to +0.37% | inside |
| `benchmark-files --flat` (libc) | 4 | +0.01% | −0.22% to +0.74% | −0.32% to +0.18% | inside |
| `benchmark-lexer src` | 4 | −0.68% | −3.59% to +2.16% | −1.66% to +1.83% | inside |
| `benchmark-backend` | 12 | −0.05% | −1.12% to +0.90% | −0.97% to +0.91% | inside |
| `benchmark-ir-source` | 4 | −0.28% | −0.79% to +0.25% | −0.29% to +0.16% | inside |
| `benchmark-parser` (`main.c`; wall, no user cycles) | 4 | +0.02%, −0.58%, +0.38%, +0.41% | | −0.23% to +0.12% | inside |

Every one is inside its floor. The 9700X job's own steps measure the rest once #2733's placements move `.text`.

## Files

- `scripts/9700x/`: the harness (`build.sh`, `bench.sh`, `analyze.sh`, `envpad.sh`, `build-pad.sh`, `queue.sh`,
  `lock.sh`, `env.sh`), as run from `~/buster-fast-bench/2559-step5b-claude`.
- `raw/9700x/addresses.txt`: the placements' addresses and `.text` sections.
- `raw/9700x/results/`: the A/B reports and the queue's log.
