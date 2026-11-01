# Profile-guided layout of the compiler's hot code (buster#880)

On the Ryzen 7 9700X (`benchpress`), 2026-10-31. Every build, train, timed and `perf` process took the host's lock
alone (`~/buster-fast-bench/exclusive.sh`, `EXCLUSIVE_OWNER=devin-880`), one lock per run; timed processes were pinned
to CPU 2. The source is buster `14210fb2` (origin/main of 2026-10-31), the inputs the frozen corpus
`/var/lib/buster-9700x/corpora/preprocessor-391e729af658` (`sqlite3.c`, musl 1.2.5's units, the clang/23 headers) and
c-testsuite's single-exec programs. clang 23.1.1, wild 0.10.0, ld.lld 23.1.1, perf 7.2.9-1, kernel 6.18.50-2-lts.

## Builds

`scripts/build-variant.sh` compiles `build.sh`'s sources with `print-compile-flags` (no `-g`, `-march=native` =
znver5, `-fwrapv -funsigned-char -fno-strict-aliasing -O3`) plus per-variant flags, and links with `-no-pie` as
`build.sh` does (`scripts/compile-one.sh`, `scripts/link-variant.sh`). Every variant's `-c` of `sqlite3.c` and of the
139 musl units is **byte-identical to base's** (`logs/objects-sha256.txt`).

| Build | Extra flags | Linker | `.text` bytes |
| --- | --- | --- | ---: |
| `base` | — | wild | 29,694,072 |
| `pgo` | `-fprofile-use=work/pgo.profdata` | wild | 25,867,351 |
| `pgo-split` | `-fprofile-use` + `-fsplit-machine-functions` | wild | 25,887,501 |
| `fsec` | `-ffunction-sections` | ld.lld | 29,580,609 |
| `order` | `-ffunction-sections` + `-Wl,--symbol-ordering-file=logs/ordering.txt` | ld.lld | 29,573,521 |

The PGO profile (`logs/pgo.profdata.zst`, sha256 in `logs/hashes.txt`) was trained by `scripts/train.sh`: the
instrumented build (`-fprofile-instr-generate`) ran `sqlite3.c` as `-E -P`, `-fsyntax-only` and `-c`, `-fsyntax-only`
on all 1,591 musl units, `-c` on 320 of them, and `-c` on c-testsuite's 220 single-exec programs, 23 `.profraw`
files merged. The `order` file lists 178 symbols, hottest first, from `scripts/profile-order.sh`'s `perf record -e
cycles:u -F 997` of 12 `sqlite3.c` compiles, one `-fsyntax-only`, and 240 musl `-fsyntax-only` units
(`logs/report.txt`); `#pragma clang section` keeps the checker's `.text.buster_checker` whole under
`-ffunction-sections`, and the ordering file ranks it. wild and mold take no symbol ordering file, so `fsec` and
`order` are lld's; `fsec` is `order`'s control.

Placements are `scripts/make-placements.sh`'s, `build.sh`'s `shifts` mechanism: `.text.buster_shift_padding` of
0/256/512/768 bytes before `main.c`'s object.

## Whole-compile times

`build/compiler time-runs --runs 11 --warmups 1 --copies 2` over the 20 placements from fresh copies, two lists,
pinned to CPU 2 (`scripts/time-runs.sh`, `logs/results-time-runs.txt`): list 1 `-c sqlite3.c`, list 2 `-c` of 139
musl units in one process. 88 runs per build and list, no failed processes.

| Build | sqlite3.c wall | sqlite3.c user cycles | musl wall | musl user cycles |
| --- | ---: | ---: | ---: | ---: |
| `pgo` | −2.44% | −2.89% | −2.86% | −3.59% |
| `pgo-split` | −2.42% | −2.84% | −2.86% | −3.53% |
| `fsec` | +0.03% | +0.03% | +0.18% | +0.23% |
| `order` | +0.04% | +0.02% | +0.02% | +0.04% |

Ranges over placements and copies: `pgo` −1.80% to −3.55% (sqlite), −2.16% to −3.85% (musl); the two no-profile
variants' ranges straddle zero. Placement spread within a build ≤0.91%, copies within ≤0.90%.

## Frontend counters

`scripts/counters.py`: one `perf stat -e cycles:u,instructions:u,EVENT:u` per event/workload, two placements (0,
512) × two runs each, CPU 2 under the lock, `sqlite3.c` as `-E -P`, `-fsyntax-only`, `-c` (`logs/counters.jsonl`,
540 records, none failed). Medians; `/1ki` = per 1,000 instructions, `/c` = per cycle.

| `sqlite3.c -c` | base | pgo | pgo-split | fsec | order |
| --- | ---: | ---: | ---: | ---: | ---: |
| frontend-starved slots/cycle (of 8) | 1.885 | 1.837 | 1.815 | 1.908 | 1.857 |
| backend-stalled slots/cycle | 3.390 | 3.506 | 3.510 | 3.375 | 3.417 |
| op-cache misses /1ki | 28.0 | 24.4 | 24.4 | 28.2 | 27.8 |
| op-cache miss ratio | 10.01% | 9.18% | 9.25% | 10.07% | 9.93% |
| L1I misses to L2 /1ki | 4.60 | 4.72 | 4.64 | 4.53 | 4.62 |
| L2 BTB corrections /1ki | 1.740 | 1.769 | 1.651 | 1.787 | 1.635 |
| decoder-sourced ops /1ki | 66.6 | 92.0 | 92.6 | 66.6 | 64.9 |
| branch mispredictions (M) | 3.425 | 3.361 | 3.356 | 3.429 | 3.407 |
| cycles (M) | 596.7 | 580.3 | 578.7 | 598.2 | 596.2 |
| instructions (M) | 1330.8 | 1254.3 | 1254.3 | 1330.2 | 1330.2 |

| `sqlite3.c -fsyntax-only` | base | pgo | pgo-split | fsec | order |
| --- | ---: | ---: | ---: | ---: | ---: |
| frontend-starved slots/cycle | 1.787 | 1.720 | 1.730 | 1.788 | 1.753 |
| op-cache miss ratio | 9.21% | 8.42% | 8.43% | 9.23% | 9.21% |
| cycles (M) | 468.6 | 453.1 | 451.9 | 467.8 | 468.2 |
| instructions (M) | 1031.3 | 958.2 | 958.2 | 1030.9 | 1030.9 |

| `sqlite3.c -E -P` | base | pgo | pgo-split | fsec | order |
| --- | ---: | ---: | ---: | ---: | ---: |
| frontend-starved slots/cycle | 1.626 | 1.554 | 1.611 | 1.639 | 1.633 |
| op-cache miss ratio | 9.32% | 7.94% | 7.98% | 9.38% | 8.85% |
| cycles (M) | 63.0 | 63.1 | 63.3 | 63.4 | 63.3 |
| instructions (M) | 199.7 | 197.4 | 197.4 | 199.6 | 199.6 |

## What the profile changes

`-fprofile-use` shrinks the giant hot functions, not just their order: `check_input_run` 57.4→47.4 KB,
`check_program` 48.7→27.9 KB, `check_input_resolve_range` 29.5→11.3 KB, `tier0_generate` 45.8→30.5 KB
(→19.1 KB with `-fsplit-machine-functions`), `check_lower_prepare` 16.9→11.2 KB; `check_lower_drain` grows
19.0→30.0 KB (callees inlined). `.text` is 29.7→25.9 MB. The compiler retires 5.8–7.1% fewer instructions for the
same output — that, more than the residual starvation rate, is where the cycles come from: miss *counts* fall
~13% (`-c`: 28.0→24.4 per 1,000 instructions) while frontend-starved slots per cycle fall only ~2.5–4.4%, and
`de_src_op_disp.x86_decoder` *rises* per instruction, consistent with a smaller hot footprint paying the decoder
more often per op-cache access. Function order without a profile (`fsec`, `order`) changes none of it; the
linker difference itself (lld against wild) is inside the noise.

## Decision

Instrumented PGO recovers part of the frontend gap on this source: −2.4 to −3.6% whole-compile time over
placements and copies, op-cache miss ratio 10.0→9.2% (`-c`) and 9.3→7.9% (`-E`), frontend-starved dispatch
slots −2.5 to −4.4% per cycle, mispredictions −1.9% (`-c`), all objects byte-identical. `-fsplit-machine-functions`
and profile-free symbol ordering add nothing measurable. Whether to adopt it — a checked-in profile, a training
corpus, a build step — is the owner's call per #880; the profile (`pgo.profdata.zst`, its recipe in
`scripts/train.sh`) reproduces these builds.
