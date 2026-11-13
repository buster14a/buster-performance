# Tier 1 if-conversion of nested, truth and reload regions (#1382), 2026-11-13

[buster14a/buster#1382](https://github.com/buster14a/buster/issues/1382)'s kernels, and sqlite3.c's `--tier1 -c`, on the
9700X (benchpress, CPU 2, governor and EPP `performance`), for
[buster14a/buster#2674](https://github.com/buster14a/buster/pull/2674).

## Revisions

| name | commit | tree | what |
| --- | --- | --- | --- |
| main | `b7a95eedbe16fbd8434654f192f8f7aab76c56e5` | `42aade18` | #2674's base |
| c99e239b ("queued", "head" in `kernels-c99e239b/`) | `c99e239b80e8342b13c3afe6a41d5cb0fd08061d` | `70e4fade` | #2674's first commit. Measured as `d6d8d4bbc023f6fa49ddedae52bd3b463feb3734`, the same tree before its message was amended; that id was never pushed, and the trees' `COMMIT` files and `identities.txt` name it. |
| fab53452 ("fixed") | `fab53452278492056a925cef667e40571953df8e` | `ce19266c` | #2674's second commit: the recurrence guard and the accumulation's select sinking, made after `kernels-c99e239b`'s first round |
| 0904e73a ("lean") | `0904e73af00d51f836fb816bde435b6de7dd4604` | `200657fa` | fab53452 with the round's per-row setup removed, the code byte-identical; measured slower and dropped, never pushed (its patch is in `compile-main-fab53452-0904e73a/`) |

Each tree was `git archive` of its commit, built with `./build.sh` (Release, native: znver5) under the 9700X's lock
(`scripts/build-tree.sh`). Host: `kernels-*/identities.txt` (Linux 6.18.50, clang 23.1.1, perf 7.2.9, the compilers'
and objects' sha256).

## Method

- **Kernels** (`scripts/kernels.c`, `scripts/bench.c`, `scripts/measure.sh`): each kernel compiled by main's and a
  head's `--tier1 --tier1-strict -c`, clang -O2 -fno-vectorize and clang -O0; one clang -O2 driver (another object)
  calls the scalar kernels 50 M times on xorshift64's high bits, and the loops over 2^20 such bytes (0 to 255) 80
  times. Every build's output was checked equal first (`build.log`: "built and checked"). Each round is one hold of
  the lock (`holds.txt`, the holder line each run wrote), running each kernel by the four builds, their order rotated
  by round, each after an untimed warm-up, pinned to CPU 2 under `perf stat -e cycles:u,instructions:u,branch-misses:u`
  (`results.tsv`, with each run's exit status). `busy.txt` has the load and the busiest processes before and after each
  round.
- **Compile** (`scripts/compile.sh`'s successor `scripts/compile3.sh`): the frozen sqlite3.c
  (sha256 `0a409f16…e23d`, checked), `--tier1 -c` with measure-compile's options, by each tree's compiler: `.text`
  size and `cmov`/`jcc` counts of the object (`shape.txt`), then `time-runs --runs 11` of all trees in one hold, in its
  Williams order (`compile-time.txt`). `report-*.txt`: `perf record -c 200003 -e cycles:u` of one compile by main and
  fab53452 (`scripts/profile.sh`), `perf report --sort symbol`'s top 40.
- `exclusive.sh`'s waiting lines (another holder's line, title and link) were removed from the logs; each holder
  line in them was a single line. The files that held nothing else (`lock.log`, `prof-lock.log`) are left out.

## Kernels

`kernels-c99e239b/` ran first (20:13 to 20:31 UTC) and found the running max's regression. `kernels-fab53452/`
(20:47 to 20:56) measured the fix, with main again in the same holds. These are medians in Mcycles, with the five
rounds' range.

### c99e239b (5 rounds; medians in Mcycles, `cycles:u`, with the rounds' range)

| kernel | main | c99e239b | clang -O2 -fno-vectorize | clang -O0 | c99e239b / main | c99e239b / -O2 | instructions M, main / c99e239b / -O2 | branch misses M, main / c99e239b / -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| null (`a ^ b`, the driver loop) | 309.8 (309.0–310.9) | 310.5 (309.9–311.1) | 310.3 | 302.3 | 1.002 | 1.001 | 1400 / 1400 / 1400 | 0.00 / 0.002 / 0.002 |
| `a > b ? a : b` | 304.8 (304.8–304.8) | 304.8 (304.8–304.8) | 300.3 | 1115.7 | 1.000 | 1.015 | 1600 / 1600 / 1450 | 0.00 / 0.002 / 0.002 |
| `x < 0 ? 0 : x > 255 ? 255 : x` | 1148.8 (1132.4–1152.2) | 342.2 (341.0–342.6) | 332.5 | 1172.3 | 0.298 | 1.029 | 1738 / 2100 / 1700 | 25.69 / 0.002 / 0.002 |
| `a < 128 && b < 128` | 1138.5 (1128.0–1145.8) | 344.3 (344.3–344.3) | 335.9 | 1174.4 | 0.302 | 1.025 | 1875 / 1900 / 1750 | 25.00 / 0.002 / 0.002 |
| `(a < b) && (b < c \|\| c == 0)` | 1328.6 (1313.6–1330.6) | 371.3 (371.3–371.3) | 349.9 | 1390.4 | 0.279 | 1.061 | 1841 / 2000 / 1750 | 31.66 / 0.002 / 0.002 |
| `if (a[i] > 128) s += a[i]` | 1287.1 (1263.2–1346.3) | 174.3 (174.3–174.3) | 93.4 | 1532.2 | 0.135 | 1.867 | 642 / 936 / 412 | 41.74 / 0.003 / 0.003 |
| `s += a[i] > 128 ? a[i] : -a[i]` | 1365.7 (1326.4–1376.0) | 203.5 (203.4–204.1) | 150.5 | 1687.8 | 0.149 | 1.351 | 936 / 1188 / 769 | 41.95 / 0.003 / 0.003 |
| `m = a[i] > m ? a[i] : m` | 90.4 (90.4–90.6) | 342.1 (342.1–342.1) | 73.1 | 281.0 | 3.782 | 4.682 | 517 / 853 / 412 | 0.00 / 0.003 / 0.003 |

### fab53452 (5 rounds; medians in Mcycles, `cycles:u`, with the rounds' range)

| kernel | main | fab53452 | clang -O2 -fno-vectorize | clang -O0 | fab53452 / main | fab53452 / -O2 | instructions M, main / fab53452 / -O2 | branch misses M, main / fab53452 / -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| null (`a ^ b`, the driver loop) | 310.7 (310.0–310.8) | 310.2 (309.9–310.8) | 310.6 | 301.8 | 0.999 | 0.999 | 1400 / 1400 / 1400 | 0.00 / 0.002 / 0.002 |
| `a > b ? a : b` | 304.9 (304.8–304.9) | 304.8 (304.8–304.9) | 300.3 | 1098.7 | 1.000 | 1.015 | 1600 / 1600 / 1450 | 0.00 / 0.002 / 0.002 |
| `x < 0 ? 0 : x > 255 ? 255 : x` | 1146.8 (1134.7–1153.6) | 341.3 (339.9–342.9) | 332.5 | 1161.4 | 0.298 | 1.026 | 1738 / 2100 / 1700 | 25.68 / 0.002 / 0.002 |
| `a < 128 && b < 128` | 1131.6 (1128.4–1150.2) | 344.3 (344.3–344.3) | 335.9 | 1173.0 | 0.304 | 1.025 | 1875 / 1900 / 1750 | 25.00 / 0.002 / 0.002 |
| `(a < b) && (b < c \|\| c == 0)` | 1321.8 (1316.4–1338.1) | 371.3 (371.3–371.3) | 349.9 | 1384.9 | 0.281 | 1.061 | 1841 / 2000 / 1750 | 31.62 / 0.002 / 0.002 |
| `if (a[i] > 128) s += a[i]` | 1327.1 (1289.3–1348.0) | 162.1 (162.1–164.8) | 93.3 | 1539.7 | 0.122 | 1.738 | 642 / 1020 / 412 | 41.82 / 0.003 / 0.003 |
| `s += a[i] > 128 ? a[i] : -a[i]` | 1349.5 (1328.7–1378.0) | 203.5 (203.5–203.8) | 150.6 | 1699.1 | 0.151 | 1.351 | 936 / 1188 / 769 | 41.94 / 0.003 / 0.003 |
| `m = a[i] > m ? a[i] : m` | 90.4 (90.4–90.5) | 90.4 (90.4–90.5) | 72.0 | 280.9 | 1.000 | 1.255 | 517 / 517 / 412 | 0.00 / 0.003 / 0.003 |

- The scalar kernels' cycles include the driver loop's (the null row, about 310 Mcycles). Without it, the clamp,
  `&&` and `&&`/`||` kernels' own work at fab53452 is 31, 34 and 61 Mcycles, against clang -O2's 22, 25 and 39.
- **c99e239b's running max is 3.78× main.** Its condition reads the maximum its select carries round the loop, so
  `cmp; setg; test; cmovne` (`k_head.s`) became the loop's carried chain: 342.1 Mcycles / 83.9 M elements = 4.08
  cycles per element. Main's predicted branch is 1.08. clang -O2 (`k_o2.s`) keeps three of its four unrolled
  elements as branches (LLVM's x86 cmov conversion).
- fab53452 keeps that branch (1.000× main) and sinks the conditional sum's select below its add:
  `cmove %r9,%rdx; add %rdx,%rax` with `%r9` zero (`kernels-fab53452/k_head.s`). That takes the sum from 174.3 to
  162.1 Mcycles. The remaining gap to clang -O2 (93) is its 4× unrolling and the `setg; test` round trip before each
  `cmov` ([buster14a/buster#2676](https://github.com/buster14a/buster/issues/2676)).

## Compile

sqlite3.c's `--tier1 -c`, by `time-runs --runs 11`, medians:

| set | build | user cycles (M) | against main | instructions (M) | against main | wall (ms) | `.text` | `cmov` | `jcc` |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `compile-main-c99e239b-fab53452` | main | 2,134.6 | | 4,739.1 | | 422.5 | 991,128 | 422 | 16,503 |
| | c99e239b | 2,158.1 | +1.10% | 4,764.3 | +0.53% | 407.7 | 992,968 | 705 | 16,247 |
| | fab53452 | 2,160.6 | +1.22% | 4,769.1 | +0.63% | 408.9 | 992,856 | 678 | 16,266 |
| `compile-main-fab53452-0904e73a` | main | 2,138.4 | | 4,739.1 | | 423.6 | 991,128 | 422 | 16,503 |
| | fab53452 | 2,163.6 | +1.18% | 4,769.1 | +0.63% | 409.4 | 992,856 | 678 | 16,266 |
| | 0904e73a | 2,168.9 | +1.43% | 4,769.5 | +0.64% | 410.3 | 992,856 | 678 | 16,266 |

- The cost is **about 1.2% more user cycles** for sqlite3.c's Tier 1 compile, with 0.63% more instructions.
- Main's wall times are bimodal (403 to 431 ms) and the heads' are not, so the wall medians' −3% isn't a speedup
  claim. The user cycles are the measure.
- The object's text is 0.17% larger and has 256 more `cmov`s and 237 fewer conditional jumps.
- In fab53452's profile (`compile-main-c99e239b-fab53452/report-fixed.txt`), `ir_if_convert_round` takes 1.09% of
  the samples; it isn't in main's top 40. `ir_cfg_validated` (one per round) goes from 1.08% to 1.30%. The
  annotated samples spread across the round without a hot spot.
- **0904e73a was dropped.** It stored the per-row maps plus one, so that zeroed storage needs no setup loop, and
  sized two arrays by blocks; the code was byte-identical. It came out 0.25% slower than fab53452 (the decode on
  every read). Its patch is `compile-main-fab53452-0904e73a/0904e73a.patch`; it was never pushed.

## Limits

- One host, one kernel driver: these are microbenchmarks of #1382's patterns. Program-level effects (Lua,
  speedtest1, the sqlite shell) are left to the 9700X CI job's Tier 1 program comparison.
- The 9700X was shared. Each round ran in one hold of the lock, and `busy.txt` shows no other busy process in any
  round. Still, main's three sets of medians differ by up to 3% on the mispredicting kernels.
- sqlite3.c came from the frozen corpus's copy on the host (sha256 checked against CI's).
