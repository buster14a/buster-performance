# Charging the ordinary integer-literal consumer

The source base for all three patches is `6e9c51b9d238734468dccc03ab1b6c715449804e`. The [preceding measurements](README.md) found 17,850 SQLite source digits the ordinary checker could consume directly, but the producer cost more than the consumer saved. These two experiments measured the remaining work in the original checker. All timings used the locked Ryzen 7 9700X, pinned to one CPU, in independent fresh processes. Each table reports the median paired change across six rotated rounds.

## Compacting fallback lanes

The original checker runs its source-range and digit vectors in groups of sixteen literal rows, even if only some lanes need the fallback. The experimental reader copies eligible original ordinals, places and lengths with masked compress stores. It runs the fallback on the resulting dense groups and scatters accepted values to their original ordinal. Non-decimal, out-of-range and malformed cases continue through the original paths. `compact-only` disables the PP digit writer, `read` accepts source values with the original group layout, and `compact` combines the writer and dense fallback. [Complete source patch](patches/pp-source-decimal-compact.patch)

| Source | All checker literal rows | Original groups | Groups with compaction alone | Groups with compaction and source digits |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 45,288 | 3,121 | 2,926 | 1,816 |
| Lua lvm.c | 3,812 | 262 | 262 | 254 |
| musl vfprintf.c | 781 | 54 | 40 | 27 |
| Buster main.c | 336,319 | 22,080 | 21,790 | 19,081 |

SQLite `read` to `compact` saved 0.028% of total user instructions in every pair. Check-input time moved −0.313% (−0.769% to +0.205%) and external compile wall moved +0.026% (−0.701% to +0.359%). Compaction alone cost 0.004% instructions. From the same binary with both patches disabled, the combined writer and reader cost 0.051% instructions in every pair and 0.375% wall (−0.210% to +0.995%). Against the untouched binary the wall change was +0.583% (+0.304% to +0.966%). Eliminating 1,305 groups did not pay for publishing source digits and packing the remaining ordinals. [All six arms, four sources and 144 cells](raw/digit-compact-final.txt) · [Raw records and build receipts](raw/fallback-groups.tar.xz)

## Eight decimal spellings from original source

The second candidate keeps the original checker’s range-checked, grammar-selected spelling addresses and lengths. Each unrolled half of a sixteen-literal group uses eight independent 64-bit lanes. Masked aligned gathers read only words containing a live spelling byte. Shifts concatenate the eight-byte prefixes, byte arithmetic tests decimal digits and leading zeros, and multiply-adds reduce accepted strings of one to nine digits. Excluded lanes and preprocessor-supplied integers retain their original classification. This candidate publishes no extra PP column. [Ordinary checker source patch](patches/pp-eight.patch)

The full scalar value twin passed on 1,372 frozen inputs under `-Wall -Wextra`, and both warning policies produced identical objects and diagnostics on the five representative inputs. Each of the two experiments changed the complete SQLite ELF when the checker value at source index 41693 was perturbed. A linked source fixture changed exit code from 0 to 254. A guarded independent test ran the exact eight-lane function in 120,000 batches with 479,936 active lanes, exercising every mask, length 1–9, both protected mapping edges, inactive invalid pointers, embedded non-digits and leading zeroes. [Guarded test source](scripts/pp-eight-guard-main.c) · [Scalar, warning, ELF and fault receipts](raw/decimal-eight.tar.xz)

In the replay binary each ordinary checker chunk runs its final digit pass eighteen times over exactly the same source addresses and masks. Paired mode interleaves the two readers and discards the first two passes. Both readers see the same eight repetitions of every group. The table divides summed fenced TSC intervals by the number of ordinary grammar literal rows, including fallback or excluded rows, and includes timing overhead per chunk. The external PMU columns in the raw score instead compare two fresh compilations which each execute eighteen copies of just one reader. TSC ticks and whole-process core cycles are separate measurements. [Replay source](patches/pp-eight-replay.patch) · [Paired score and external PMU controls](raw/digits8-replay-final.txt)

| Source | Active chunks | Old → new TSC ticks per checker literal | Paired change | Ordinary fresh compile user instructions | Ordinary fresh compile wall |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite | 617 | 5.030 → 3.750 | −25.436% | −0.041% | −0.066% (−0.953% to +0.252%) |
| Lua lvm.c | 53 | 4.946 → 3.908 | −21.089% | −0.028% | +0.048% (−0.463% to +0.681%) |
| musl vfprintf.c | 11 | 5.218 → 4.084 | −21.737% | −0.031% | −0.376% (−2.164% to +0.910%) |
| Buster main.c | 2,173 | 4.324 → 3.138 | −27.360% | −0.037% | −0.306% (−0.582% to +0.415%) |

The isolated reader improved in all 24 paired comparisons. On SQLite the two eighteen-pass modes differ by a median 482,719 retired user instructions per repetition. The fresh process cycle difference per repetition spanned −395,663 to +180,731 user and kernel cycles. The ordinary candidate saves 0.029% SQLite user instructions versus an independently built untouched compiler. Its complete check-input time and external wall crossed zero on each of the four sources. These data support a cheaper hot digit operation but do not establish a fresh compile throughput improvement or the 35-cycle front target. Both patches remain experiments. [Untouched and same-binary ordinary measurements, all 72 cells](raw/digits8-final.txt)

The raw archives contain the exact source patches, Release compiler hashes, correctness logs and rotated counter and wall samples. The six-arm compaction series used 144 fresh measurement cells. The eight-lane series used 72 ordinary cells and 72 additional eighteen-pass processes. Each ordinary cell included a fresh stage/PMU invocation with fixed huge pages and two externally timed normal-page compiles after a warmup. Replay compiles verified every resulting ELF against its untouched source. [Compaction driver](scripts/pp-source-compact-time.sh) · [Ordinary eight-lane driver](scripts/pp-eight-time.sh) · [Replay driver](scripts/pp-eight-replay.sh) · [Replay scoring](scripts/pp-eight-score.py)
