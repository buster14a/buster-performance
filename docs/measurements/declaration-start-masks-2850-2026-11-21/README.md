# Declaration boundaries in the checker reader

The ordinary reader expands declaration boundaries from the parser’s roles before the expression window runs. On 716,136 SQLite tokens the original column required 2,864,548 bytes. The candidate retains one 16-byte block per 64 tokens, including the final lookup, for 179,040 bytes. Each block holds the mask of boundaries and the declaration start carried from earlier blocks. A lookup takes the last boundary strictly before its token, falling back to the carried start when that mask is empty. The existing stack still handles nested structure and enum bodies.

The Release source base is `0efe6db191c5314674011b2369c0ce98f405bd84`; the candidate is `30b26f761473fa0de1ecf1c7a7480cd6898a8a39`. All primary measurements use these exact uninstrumented binaries on the Ryzen 7 9700X under its exclusive lease, pinned to CPU 2. Every process had one lane. The three policies are environment default, explicit permission for the system’s huge-page policy (`BUSTER_HUGE_PAGES=1`), and explicit base pages (`BUSTER_HUGE_PAGES=0`). Fixed-policy stage reports confirm `system` and `off`, respectively. [Production candidate](https://github.com/buster14a/buster/commit/30b26f761473fa0de1ecf1c7a7480cd6898a8a39)

## Correctness and attribution

An independently built replay binary runs both complete builders over the same parsed tokens. It warms each builder once and then alternates their order for ten repetitions, fencing individual construction with LFENCE and RDTSC. After every pair, the replay compares every token’s answer and the end sentinel with the parent’s dense table. Each input matched at every position in all ten repetitions.

| Frozen translation unit | Tokens | Dense median TSC ticks | Packed median TSC ticks | Median paired change |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 716,136 | 313,462 | 102,866 | −67.17% |
| Lua lvm.c | 73,465 | 31,806 | 10,982 | −65.81% |
| musl vfprintf.c | 16,184 | 7,068 | 2,356 | −66.75% |

The isolated warm SQLite saving is approximately 0.43 core cycles per preprocessed token at 5.49 GHz, using the measured 3.793 GHz TSC. The ordinary compile also changes the scratch pages that the reader touches. The stage and wall measurements below capture those effects. This change affects a reader that consumes an already parsed tree. Raw lexing, preprocessing and parsing remain part of the complete invocation.

The production branch’s native role oracle compares every position with an independent scalar backward walk. Its exact-multiple and neighboring sizes include 0, 1, 63, 64, 65, 127, 128 and 129 tokens alongside randomly generated nested struct and enum bodies. Both Release binaries passed the applicable checker partition with 71,606 checks and no failures. The corpus replay compared all SQLite, Lua and musl source inputs and Buster’s compiler source under default and `-Wall -Wextra`. Both compilers accepted all eight syntax invocations. Their compiler stdout and warning stderr agreed byte for byte. The eight default and warning sample objects from SQLite, lvm.c, vfprintf.c and Buster’s compiler main agreed byte for byte too. The initial musl warning comparison captured three lines from the benchmarking lease on a different side in each case. The retained rerun sends those lines to their own files and compares the compiler output alone.

## Ordinary frozen SQLite compiles

Each paired percentage is the median over round-level candidate/parent ratios. A round has two measurements from each revision. The stage series ran seven ABBA rounds per fixed page policy. The no-stage PMU series ran seven rounds per policy and reversed the order on alternate rounds. The wall series ran five such rounds using the compiler’s `time-runs` harness, a common executable pathname, and one warm-up ahead of every measured process. The checksummed object is the same for all 56 stage invocations, all 84 PMU invocations and all 60 wall measurements. The PMU duration pseudoevent returned zero on this host. Elapsed time below comes from `time-runs` and from the driver’s stage clock.

| Cost | Default | System huge pages allowed | Base pages |
| --- | ---: | ---: | ---: |
| `time-runs` wall time, parent → candidate | 121.091 → 120.805 ms | 120.741 → 120.691 ms | 145.435 → 143.200 ms |
| Median paired wall change | −0.124% | −0.041% | −1.392% |
| Range of paired wall changes | −0.592% to +1.995% | −6.983% to +0.020% | −2.501% to −0.676% |
| Raw compile user + kernel cycles | −0.228% | −0.214% | −1.192% |
| Raw compile user instructions | −0.090% | −0.090% | −0.090% |
| Check-input stage, parent → candidate | — | 44.890 → 44.754 ms | 56.490 → 55.388 ms |
| Median paired check-input change | — | −0.303% | −1.952% |
| Range of paired check-input changes | — | −0.907% to −0.257% | −4.557% to −1.390% |

Ordinary default compiles retired about 1.21 million fewer user instructions. Their wall measurements overlap. Every base-page wall round was faster, and the PMU series recorded median minor faults of 59,950 versus 59,016.5. Median process high-water RSS with base pages fell from 198,668 to 194,440 KiB in the stage runs. Under the system huge-page policy, both medians were 244,018 KiB. The stage totals and external elapsed time still include the entire raw source through ELF output.

## Selection

A further experimental build calculated the boundary masks inside the checker’s existing token census. Relative to the packed builder in its own pass, that changed the check-input stage by −0.94% with base pages and +0.20% under system huge-page policy. The seven-round ranges crossed zero in both cases. Retired user instructions rose by 0.010% in both configurations. The proposed production commit keeps the compact separate pass. The evidence includes both the fused patch and the same-binary replay patch.

Local Develop checker partitions 1 and 5 passed 304,157 and 210,479 checks. `9700x/summary.tsv` lists the medians and ranges for each cost boundary. The raw timing series, every sample’s object checksum, representative object and corpus diagnostic receipts, compiler build digests, and the commands used are under `9700x/`.
