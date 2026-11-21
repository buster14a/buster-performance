# Deferring ordinary primary-file preprocessing under live conditionals

These two experimental compilers preserve normal conditional evaluation and inclusion order. Both disqualify their scheduling strategy on the frozen SQLite translation unit. Ordinary preprocessing took more time in every same-binary pair even though the compiler refined fewer identifiers. Buster [#3211](https://github.com/buster14a/buster/issues/3211) tracks preparing fewer raw rows. Buster [#2850](https://github.com/buster14a/buster/issues/2850) requires whole-compile throughput of 1 GB/s.

## Source and comparison

Both signed patches apply independently to Buster `875c08e9dd85c4c67bbe24a00e54bbe33f0890b5`. Each pilot prepares a large primary file into its translation unit's private arenas and uses the production lexer, includer, conditional evaluator, and macro expansion code. Headers use their ordinary cache records. Setting `BUSTER_TEST_ACTIVE_REFINEMENT=1` enables the treatment. Setting it to `0` runs the ordinary cached preparation in the same binary. Each timing series also includes a separate untouched parent binary. The fixed preparation and thread-private arena cost belongs to the treatment.

- The [identifier experiment](source/pilot2.patch), commit `d134661f16c44c367abd96eada05d016fc9a283c`, records a 64-bit identifier mask per 64 raw tokens during normal pass A. Real directive lines and their nearby 64-token words are interned before building the directive table. The preprocessor interns ordinary rows in each subsequently entered span.
- The [block experiment](source/blocks512.patch), commit `29c378b4e90c524b4a0f95a6d442d559002d2ccb`, defers normal passes A/B/C together for complete 512-token blocks outside directive lines. Logical start-of-line and hash bits preserve directives spanning several blocks. Each pending block saves its preceding physical token end and shares the source backslash map. Entering an ordinary span runs normal refinement there.
- Both run one complete lexer scan of the source through its ordinary window strategy, including its boundary overlap and lexical diagnostics, and emit all raw token rows. Neither consumes a presupplied skip trace.

## Work reached

Counts below are for the actual primary file. SQLite used `SQLITE_OMIT_LOAD_EXTENSION`, `SQLITE_THREADSAFE=0`, `SQLITE_ENABLE_MEMSYS5`, and `SQLITE_ENABLE_RTREE`. The feature input adds FTS5, FTS3, SESSION, PREUPDATE_HOOK, GEOPOLY, and DBSTAT_VTAB on the same source.

| Primary | Source bytes | Raw rows both write | Raw identifiers | Identifiers skipped by mask | Identifiers skipped by block | Rows whose A/B/C passes block skips |
|---|---:|---:|---:|---:|---:|---:|
| SQLite | 9,507,037 | 1,166,437 | 454,224 | 135,502 | 92,060 | 243,200 |
| SQLite with six more features | 9,507,037 | 1,166,437 | 454,224 | 43,555 | 16,820 | 43,008 |
| SQLite shell | 1,182,638 | 189,906 | 70,408 | 14,589 | 10,487 | 27,136 |
| All-active control | 339,829 | 66,510 | 19,005 | 0 | 0 | 0 |

On frozen SQLite the identifier mask occupied 145,808 initialized bytes. The reservation uses the worst-case raw-token capacity. The block table and backslash map together occupied 36,816 initialized bytes. The compiler already used a transient backslash map in ordinary preparation, and the experimental block version retains it until preprocessing finishes. Counters were enabled in dedicated correctness runs and disabled throughout timing.

## Locked 9700X results

Six rounds rotate three arms, then mirror the order. Each of 144 stage/PMU samples is an ordinary `-c`, pinned to CPU 2 with `BUSTER_HUGE_PAGES=1`, under the machine-wide lease. Another 144 child wall samples use the default page policy and one untimed warmup per arm. The primary output object SHA-256 agrees across all arms and rounds for each corpus. The two candidate batches were collected separately. The listed timings are per-arm medians. Paired percentages are the median of six within-round on/off changes. Individual values and the actual command line, flags, PMU counts, stage times, faults and child timings are in the raw archives.

| Candidate | Input | Preprocess off → on, ms | Paired change | Ordinary wall off → on, ms | Paired change |
|---|---|---:|---:|---:|---:|
| Identifier | SQLite | 9.700 → 10.678 | +11.66% | 121.754 → 123.484 | +1.37% |
| Identifier | SQLite + six | 10.171 → 11.262 | +11.17% | 167.147 → 168.630 | +0.99% |
| Identifier | Shell | 3.916 → 4.075 | +4.03% | 34.852 → 35.242 | +1.25% |
| Identifier | All-active | 0.886 → 0.857 | −2.10% | 8.253 → 8.331 | +0.66% |
| Block | SQLite | 9.357 → 9.767 | +4.50% | 121.679 → 122.449 | +0.63% |
| Block | SQLite + six | 9.998 → 10.491 | +7.08% | 167.142 → 168.166 | +0.66% |
| Block | Shell | 3.833 → 4.043 | +5.56% | 34.895 → 35.195 | +0.81% |
| Block | All-active | 0.821 → 0.825 | −0.98% | 8.233 → 8.293 | +0.55% |

Frozen SQLite ordinary raw-source throughput is 78.08 → 76.99 MB/s for the mask and 78.13 → 77.64 MB/s for blocks. The separate parent compiler delivered 78.24 and 78.58 MB/s respectively. At 1 GB/s these 9,507,037 bytes would need 9.507 ms. The same-binary mask saves 0.15% retired user instructions in complete compilation, and blocks save 0.22%. The mask's initial refinement substage fell from 1.775 to 0.558 ms, while directive construction rose from 0.364 to 1.212 ms and the main loop from 4.380 to 5.521 ms. The total preprocessing measure includes these transfers. Source reading, lexing, macro work, and materialization all remain charged.

## Correctness and replay

Both patches passed identical status, marker-bearing preprocessed stdout, complete stderr including diagnostic locations, and successful complete object hashes on the nine detailed inputs. They cover frozen SQLite, its feature variant, its shell, the all-active control, both sides of include-driven conditionals, malformed skipped structure, a deliberately rejected input, and a macro argument crossing conditional directives. Each input was exercised with ordinary `-E`, `-E -C`, `-E -CC`, warning syntax, and object modes. The frozen parent refuses `-C/-CC` before executing the preprocessor. In a private application of the identifier patch to the separate [#2925](https://github.com/buster14a/buster/pull/2925) publication head `616174e3e0833af48af542be833b5ba0fc8889bb`, the real comment-preserving modes also agree, including markers, comments and diagnostics. That branch deliberately prepares comment-bearing files as whole files with the scalar lexer, so the comment-preserving modes use the existing eager preparation.

The extracted [study scripts](scripts) record exact corpus flags, fixtures, command ordering, native lease, builds, checks, and analysis. [Identifier PMU and child wall data](native/pilot2.tar.xz), [block PMU and child wall data](native/blocks512.tar.xz), and [real comment-mode parity](native/comments.tar.xz) contain per-invocation records. Successful preprocessed streams and ELF objects are retained by their paired SHA-256. [Identifier summaries](native/pilot2-stats.txt) and [block summaries](native/blocks512-stats.txt) show the full process including parse, user/kernel cycles and faults. Full compiler binaries and generated corpora are reproducible from the pinned revisions, patches, build receipts, immutable benchmark corpus and fixture generator.
