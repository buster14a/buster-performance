# x87 transfer candidates in both emitters

Compiler base `0a2c3034cf6093cda0f461e519ceb04484739259` and candidate `f53e5a9c2ffac942f027131106938c1c43616c07`. All timed runs used Release on the Ryzen 7 9700X, the shared exclusive lock and CPU 2. The candidate records a private store and its certified sole reload at emission. One bounded byte-vector load supplies both masks. Discovery verifies the store identity, reload form, matching owner, order and uniqueness. An independent x87 stack replay verifies the proposed record sequence before publication.

## Discovery across all window sizes

Compile `tags.c` with pinned Clang, `-O3 -march=native -Wall -Werror`, then run under the lock with `taskset -c 2`. Each row gives layout, window length, stride, old scalar, old gather and candidate median TSC ticks per window. Every run interleaves nine samples. The four layouts cover randomized records and certificates, no marked transfers, dense valid pairs, and repeated or out-of-window owners. The three window strides are 64, 67 and 17. The harness checks the complete candidate mask returned by all three implementations. Construction of the input columns is outside this discovery timer.

| Repeat | Candidate wins vs scalar | Candidate/scalar | Candidate wins vs gather | Candidate/gather |
| --- | ---: | ---: | ---: | ---: |
| 1 | 768/768 | 0.03015–0.92272 | 768/768 | 0.03322–0.83413 |
| 2 | 768/768 | 0.03078–0.92563 | 768/768 | 0.03384–0.79006 |
| 3 | 768/768 | 0.03032–0.97307 | 768/768 | 0.03394–0.78078 |

## Cost of generating the certificates

`adapter.py` instruments the full production Tier 0 and Tier 1 transfer adapters, including scratch, proofs, boundary formation, scan and rewrite. From the base, build modes `scalar` and `gather` in distinct clean checkouts. From the candidate, build mode `candidate`. Compile `adapter-fixture.c` on one lane with each build at both tiers. Rotate the three builds over five passes. Both output objects matched across all three builds. Measurements here include 260 functions per tier.

| Tier | Scalar ticks | Gather ticks | Candidate ticks | Candidate/scalar |
| --- | ---: | ---: | ---: | ---: |
| Tier 0 | 7,171,322 | 7,207,954 | 6,901,256 | 0.9623 |
| Tier 1 | 9,575,962 | 9,606,932 | 8,767,360 | 0.9156 |

Totals sum the median per function. Grouping those medians by emitted record count, the candidate beat scalar in every observed group (113 Tier 0 and 81 Tier 1). It beat gather in every group except the 91-record Tier 0 group, which took 2.8% more ticks. Record counts here describe entire functions. The independent discovery sweep above measures each actual window size from 1 through 64.

## Correctness and independent checks

- `test-tier1-wide` passed 36,477 checks, including 7,700 interpreter and 4,824 native runs. `test-tier0 --cross-check` passed 21,779,895 checks including the independent compiler runs.
- The independent replay and guarded-window fixtures passed 2,305 focused checks. Eight deliberate mutations to the load address, tail mask, reload tag, repeated consumption, store certificate, owner offset, read set and boundary mask all failed the fixtures. The last mutation restores the defect caught by musl before this revision. The focused mutation run used one test binary with a runtime mutation selector. `mutate-replay.py` applies the equivalent individual changes for reproduction in disposable compiler worktrees.
- The original compiler and exact candidate produced equal object bytes, stdout and stderr for all 1,336 musl units, 34 Lua units, sqlite3.c and the 512-function `long-double.c` workload in both tiers. [Output lengths and SHA-256](results/outputs.tsv)

## Whole-driver cycles

`ab` ran `time-runs --runs 5` on one lane, rotating the order of the candidate and two separate byte-identical baseline executables. Each cell is the median of six round ratios over three orderings, or nine rounds for the long-double input. Each pair is candidate/base followed by control/base. The control and base have identical loadable sections to the baseline used for the output comparisons. [Baseline section audit](results/elf-sections.txt)

| Workload | Tier 0 | Tier 1 |
| --- | ---: | ---: |
| 512 long-double functions | −0.75% / −0.09% | −0.43% / +0.05% |
| Lua 5.4.8 | +0.02% / +0.01% | −0.01% / +0.08% |
| musl | +0.12% / +0.07% | −0.10% / −0.06% |
| SQLite | +0.59% / +0.49% | +0.05% / +0.03% |

Tier 0 musl took 0.10–0.16% more cycles than the first baseline in all six balanced rounds. SQLite Tier 0 was also above its first baseline in all six rounds. The median differences from the second baseline are small. The earlier fixed-order measurements also showed a Tier 0 SQLite increase. The whole-driver no-regression gate remains under investigation.

`qbalanced` and `qcorpora` contain the exact benchmark commands and frozen input paths on the shared host. `proof-driver` ran under the encompassing lock for the output comparisons. In these scripts `base` is the output-comparison base, `fresh` and `fresh-control` are timing baselines, and `correct-head` is the exact candidate executable. `results/` contains the timing tables with command-line and lock chatter removed, all per-function adapter samples, official suite results, the focused mutation log and object digests. Run `python3 report.py` to regenerate the numeric summaries.
