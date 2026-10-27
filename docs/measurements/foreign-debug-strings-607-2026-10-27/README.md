# Foreign DWARF exact-string merging — #607

This campaign evaluates [Buster #607](https://github.com/buster14a/buster/issues/607)
against compiler source `92c025e71856d13eb34247477c5294d2cead139e`.
The experimental source change is retained as `campaign/candidate.patch`, rather
than added to the production compiler. The recorded patch and executable hashes
in `results/drivers.sha256` identify the actual comparison.

## Decision and measured tradeoff

Retain concatenation for the current throughput target. Reusing the existing
producer in this eager pipeline saves substantial space but loses link time
on the larger shared-header inputs and the mostly-unique controls.

For 1,000 shared-header units, string bytes fall by 98.6% and total file bytes
by 77.0% (7,824,192 to 1,801,096). Nevertheless, the matched driver's whole-link
median rises 15.4% without compression and 8.0% for zlib inputs. At 1,000 mostly
unique units, just 2.1% of string bytes disappear while full-link medians rise
48.5% and 23.9%. Peak RSS also increases at that scale. Tiny-case movements do
not establish a reliable speedup; there is no claim that every workload slows.

The table reports the eleven measured process samples per cell, excluding
warm-ups. String byte counts combine the two eligible section kinds; distinct
strings are counted separately within each kind. Full wall/user/system time,
peak RSS, debug relocation counts, stored input-section bytes, output ELF
sizes, writer subphases and isolated producer samples remain in the raw files
and `results/summary.tsv`.

| Input | String bytes before / after | Base link ms | Prototype ms | Change | Peak RSS before / after KiB |
| --- | ---: | ---: | ---: | ---: | ---: |
| duplicate-10-plain | 61,244 / 6,877 | 0.479 | 0.472 | -1.6% | 7,368 / 5,308 |
| duplicate-10-zlib | 61,244 / 6,877 | 0.605 | 0.603 | -0.4% | 7,268 / 5,168 |
| duplicate-100-plain | 610,996 / 14,100 | 1.100 | 1.269 | 15.4% | 10,940 / 10,892 |
| duplicate-100-zlib | 610,996 / 14,100 | 2.247 | 2.381 | 6.0% | 10,180 / 10,144 |
| duplicate-1000-plain | 6,111,198 / 88,103 | 9.498 | 10.962 | 15.4% | 41,996 / 46,100 |
| duplicate-1000-zlib | 6,111,198 / 88,103 | 19.822 | 21.415 | 8.0% | 34,000 / 38,104 |
| dwarf64-10-plain | 61,180 / 6,831 | 0.468 | 0.474 | 1.3% | 7,420 / 5,288 |
| dwarf64-10-zlib | 61,180 / 6,831 | 0.640 | 0.657 | 2.5% | 7,276 / 5,168 |
| unique-10-plain | 60,983 / 59,671 | 0.478 | 0.513 | 7.3% | 7,340 / 7,340 |
| unique-10-zlib | 60,983 / 59,671 | 0.591 | 0.645 | 9.2% | 7,284 / 7,268 |
| unique-100-plain | 616,130 / 602,938 | 1.118 | 1.528 | 36.7% | 10,904 / 12,940 |
| unique-100-zlib | 616,130 / 602,938 | 2.208 | 2.630 | 19.1% | 10,188 / 12,188 |
| unique-1000-plain | 6,254,027 / 6,122,035 | 9.503 | 14.112 | 48.5% | 41,988 / 50,156 |
| unique-1000-zlib | 6,254,027 / 6,122,035 | 20.061 | 24.861 | 23.9% | 33,996 / 44,276 |
| SQLite plain | 100,784 / 100,129 | 1.856 | 2.253 | 21.4% | 25,352 / 25,292 |
| SQLite zlib | 100,784 / 100,129 | 6.777 | 7.167 | 5.8% | 23,704 / 23,740 |

The shared-header 1,000-unit input contains 106,008 complete strings and
3,107 distinct strings summed over the two kinds. The mostly-unique control
contains 104,008 / 98,010; SQLite contains 7,970 / 7,928. SQLite saves only
655 string bytes (656 total file bytes), with roughly 0.4 ms added link time.

On the shared-header 1,000-unit input, the isolated vector producer takes
1.466 ms while the matched full writer falls only 1.527 → 0.410 ms. The
mostly-unique producer takes 2.633 ms while its writer falls 1.566 → 1.485 ms.
These optimistic producer samples omit remapping. They provide no measured
budget for eight-way remapping alone to make this eager reuse worthwhile.
The later issue note's fused copy/hash proposal requires a different producer
interface; that design, including fused vector remapping, remains unmeasured.

This rejects this prototype as a default-throughput change. It does not prove
that pooling cannot help storage-focused uses, different corpora, cold I/O,
another data layout, a cheaper admission rule or a streaming merger. No
production implementation or public option is proposed from this experiment.

## Method

All target builds and measurements run through the shared 9700X exclusive lock.
Timed children inherit CPU 2 affinity. These are warm-page-cache, complete
process invocations on the recorded filesystem, including output close and
cleanup; they do not measure durable `fsync` or cold storage. Every binary
switch has a discarded warm-up. Eleven measured rounds reverse the four
variants' order on alternate rounds; round zero is also discarded.

The variants are the unmodified complete compiler (`buster`), lld with one
thread, and two identically built standalone Buster linker drivers. Both
standalone drivers compile `campaign/driver.c` with the same flags. The
`driver-base`/`driver-merge` pair isolates the experimental algorithm from
the complete compiler's different binary layout and startup. Do not attribute
Buster/lld differences solely to their handling of strings.
Each matched driver has one recorded placement; there is no A/A control or
placement sweep separating code-placement effects within that pair.

Generated programs contain 10, 100 or 1000 independently compiled C units plus
one startup unit. Each unit references 32 nested records with long type/member
names. The duplicate case includes one shared header; the mostly-unique
control gives each unit its own type/member names. All generated functions
execute, and their output must equal the independent integer formula
`N * (N - 1)`. Clang compiles them with `-g -gdwarf-5 -O0 -ffreestanding
-fno-stack-protector`. Objcopy makes admitted zlib-compressed copies of the
same objects. A ten-unit DWARF64 case uses `-gdwarf64` as well.

The real corpus is SQLite 3.53.2 plus its retained original in-memory SQL
consumer (`campaign/check.c`), compiled with `-g -gdwarf-5 -O1` and linked as
a dynamic PIE against the installed runtime. SQLite's source ID is
`2026-06-03 19:12:13 d6e03d8c777cfa2d35e3b60d8ec3e0187f3e9f99d8e2ee9cac695fd6fcdf1a24`.
SQLite sources remain external runtime inputs; their hashes and those of
every generated source/object are retained.

`wait4` supplies each link's user/system time and peak RSS. `CLOCK_MONOTONIC`
covers fork through reap. Buster's `--time` reports writer and conversion
subphases separately. `pool.tsv` also measures the existing exact-string
producer in isolation after input reading/decompression, with scalar and
vector order alternating. These optimistic producer timings omit relocated
offset lookups; the full prototype includes them. Its retained arena count
excludes transient scratch, input bytes and mappings. The probe's own peak
RSS includes loading and independent validation and is not a replacement
for a full-link RSS comparison.

## Prototype and independent validation

All 16 cohorts completed on the locked 9700X: 64 ELF outputs pass
`llvm-dwarfdump --verify`, with equal decoded quoted values and normalized
statistics; all 56 generated-program GDB checks pass. Both real-corpus
compression states pass the SQL consumer under all four variants (its success
status is intentionally 42). All 16 exact/vector/eight-lane comparisons and
the separate raw-offset fixture pass. SQLite's original line tables retain
duplicate-file-name warnings in every variant; the verifier reports no errors.

The experiment admits only complete, alignment-one, one-byte
`SHF_MERGE | SHF_STRINGS` contributions in `.debug_str` and
`.debug_line_str`, without relocatable string contents. Each kind gets its
own stable exact-string pool from the existing scalar/vector producer.
Per-contribution input-offset maps translate **S+A**, including interior
references and negative addends. Symbols targeting merged sections leave
the existing eight-relocation fast path for the exact relocation kernel.
Merging runs on lane zero after decompression and before relocation, with
the existing synchronization. Original concatenation buffers remain live
through the experiment; this is not a streaming or minimum-memory design.

The pool probe compares counts and sizes with an independent `strcmp`/sort
model and checks complete-string boundaries plus interior suffixes. The
full outputs are checked with `llvm-dwarfdump --verify`. All decoded quoted
values from `--debug-info --debug-line` must match across all four linkers;
their deterministic compressed transcripts are retained. DWARF statistics
are compared by sorted key/value lines, excluding the filename and the two
string-section byte counts. Generated programs also undergo GDB checks for
an argument, local field, nested record type, source line and backtrace.
Scalar, vector and eight-lane prototype outputs must be byte-identical.

A separate assembly probe checks six R_X86_64_32/R_X86_64_64 expressions
against local symbols with nonzero values, including suffix references and
negative addends crossing an entry boundary. Its `.debug_info` is deliberately
an opaque relocation fixture, not a valid DWARF unit. The independent ELF
consumer checks each resulting string, and exact/vector/two-lane outputs
must be byte-identical.

The prototype is a decision experiment, not a production admission policy.
It does not qualify empty/out-of-range references, arbitrary alignments,
all COMDAT/tombstone cases, sections beyond the existing DWARF32 capacity,
or suffix merging. No production readiness is inferred from these admitted
cohorts.

## Reproduction and provenance

On the approved host, put the pinned Buster checkout in `base/` and this
directory's retained scripts/sources in `campaign/` under an experiment root.
Build `base/build/compiler` with `BUSTER_DEBUG_INFO=0 ./build.sh` through the
shared lock. Supply the hashed SQLite amalgamation/header and `check.c` in
`SQLITE_607_DIRECTORY` (the scripts preserve the original host path as their
default), then run `bash campaign/queue.sh`. It acquires the same lock and
releases it after bounded batches. An experiment-root `STOP` file stops
between cases. Compile `campaign/summarize.c` and run it from that root to
recreate `summary.tsv` from raw rows and output ELF headers.

All new harnesses, generators and the experimental patch are original project
material under Apache-2.0 WITH LLVM-exception. They include the pinned Buster
sources at build time; identified component notices remain in that checkout.
Clang, binutils, lld, LLVM's DWARF decoder, GDB and SQLite run externally; no
external implementation is imported. The SQL consumer is retained byte for
byte from the frozen first-party corpus at the hash in
`results/real-sources.sha256`.

Initial incomplete attempts (a missing optional timing utility, JSON key
ordering, and treating the SQL consumer's intentional success status 42 as
failure) were excluded. The final campaign uses direct resource reads,
order-independent statistic comparisons and the consumer's expected status.
Only completed cohorts
with matching frozen driver hashes belong to the reported result.
