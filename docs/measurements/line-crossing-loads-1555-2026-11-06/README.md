# Line-crossing loads in the refine pass and the lexer (buster#1555)

This record holds the evidence for [buster#1555](https://github.com/buster14a/buster/issues/1555). That issue takes the
two sites of line-crossing loads that
[buster#873's third comment](https://github.com/buster14a/buster/issues/873#issuecomment-6507873354) placed and no
issue owned:

- the refine pass's plain 32-byte loads at each identifier's start (`refine_hash_batch`, `c_refine.c`);
- the lexer's 64-byte load one byte into each chunk vector (`write_chunk`, `c_lexer.c`).

**The result: no change at either site.** The two candidates that remove or move the loads are no faster:

- The lexer's candidate removes its crossing loads but is 1.3% to 1.7% slower.
- The refine pass's only drop-in alternative, masked loads, crosses all the same.

The doc and comment notes that say so are in buster#1554's branch.

## Sources, host and inputs

- **Buster main:** `ec5f0f6be04660d5b36ec688ba3d8ed3511ee85b`.
- **The lexer candidate:** `scripts/lexer-candidate.diff`, `shift_in_next`: one `vpermt2b` of `raw[j]` and `raw[j + 1]` in place of the unaligned load.
- **The refine experiment:** `scripts/refine-masked-experiment.diff`, the existing masked-load path for every batch.
- **Builds:** `BUSTER_HOST_ARCH=znver5 ./build.sh`, each in a tree of its own under `~/buster-fast-bench/1555-claude/` on benchpress. Their executables (sha256):

  | Executable | sha256 |
  | --- | --- |
  | main | `ebce2be6b3f336f9bb9a4a73e568d3e536c97351d2bae85ba24f3717a6fbd6a2` |
  | the lexer candidate | `ddf81fb958b644119be4c54b71220fdf701f7142ccc0ba7b0db253d6adb07817` |
  | the refine experiment | `71226ac55c83304f787b5471d4450b6e681a1d595369aac737e97a29048e6756` |
  | main with the lexer variants `control` (main's `c_lexer.c`) and `k1` (the candidate) | `5c41feefa3233c316a9933a98f690b5b0f03ecaecef37f206ad9b10ce04e9956` |

- **Host:** AMD Ryzen 7 9700X (benchpress), kernel 6.18.50-2-lts, perf 7.2.9, clang 23.1.1.
- **Running:**
  - every run was under the host's lock (`exclusive.sh`) and pinned to CPU 2;
  - one lock hold per script: the probes, a stage's builds, or a stage's measurements.
- **Input:**
  - the frozen `sqlite3.c` of corpus `preprocessor-391e729af658`, with `tools/microarch/workloads.sh`'s `sq-c` (`-c --lanes 1`) and `sq-syn` (`-fsyntax-only`) command lines;
  - `SOURCE_DATE_EPOCH=1792454400`;
  - for the lexer variants, also the C library corpus (`~/azp-bench/c-tokenizer/corpus/libc`, 8,983 files, 93.8 MB) and main's `src` (857 files, 44.9 MB).

## What a line-crossing load costs on Zen 5 (`logs/probe`)

**The probes:**

- `scripts/split-probe.c` reads each line of a 32 KiB buffer, from L1, at an offset. Its two independent accumulators make the loop not bound by its loads.
- `scripts/split-probe2.c` makes eight independent loads per iteration, so loads bound the loop.

**Method:** each configuration ran three times under `perf stat`, at 20,000 passes. The tables give one representative run's numbers; all three are in the logs.

Not load-bound (`probe.log`), 10.24 million loads:

| Load | `ls_misal_loads.ma64` | Cycles |
| --- | ---: | ---: |
| 32-byte plain, aligned | 308 | 12.56M |
| 32-byte plain at +40 (crosses) | 10.34M | 12.69M |
| 32-byte masked, 8 bytes enabled (inside the line), at +40 | **10.38M** | **16.29M** |
| 32-byte masked, 8 bytes enabled, aligned | 298 | 16.28M |
| 64-byte plain, aligned | 307 | 12.24M–12.83M |
| 64-byte plain at +1 (crosses: the lexer's case) | 11.97M | 17.67M–19.38M |
| 64-byte `vpermt2b` of two aligned lines (the lexer candidate's form) | 318 | 11.19M |

Load-bound (`probe2.log`), 10.08 million loads:

| Load | Aligned | Crossing | More per crossing load |
| --- | ---: | ---: | ---: |
| 32-byte plain | 9.24M cycles | 10.46M–10.52M (+40) | about 0.12 cycles |
| 32-byte masked, 8 bytes enabled | 9.19M–10.32M | 10.47M–10.49M (+40) | the same |
| 64-byte plain | 5.43M–5.44M | 10.47M–10.51M (+1 or +32) | about 0.5 cycles |

**What the probes show:**

- **Masked loads still split.** A masked load whose enabled bytes lie in one line, and whose masked-off bytes cross into the next, is counted as crossing on Zen 5. It costs as much as the plain one when loads bound the loop, and more when they don't.
- **A crossing 32-byte load is nearly free.** It costs about 0.12 cycles at most.
- **A crossing 64-byte load costs about half a cycle.** It halves the load throughput when loads bound the loop.

## Main's line-crossing loads (`logs/counters/stage1.log`, `logs/profiles/profile-main-*`)

**Counts:** `perf stat` of 3 processes per workload:

- `-c`: 12.15 million line-crossing loads per compile (11.87–12.45);
- `-fsyntax-only`: 8.59 million (8.15–9.18).

**Where they are:** `perf record -e ls_misal_loads.ma64:u -c 997` over three `-c` compiles gives these shares of the samples. Samples land a few instructions past their event, so the shares are approximate.

| Function | Run 1 | Run 2 | Run 3 |
| --- | ---: | ---: | ---: |
| `refine_pass_b_64_plain` (the refine pass's stage 1, inlined) | 4.56% | 3.58% | 3.83% |
| `tokenize_c_raw_no_separators` (the lexer, `write_chunk` inlined) | 1.82% | 1.64% | 1.67% |

So the refine pass has about 0.45 to 0.55 million of the crossing loads, and the lexer about 0.2 million. From the probes, those cost at most about 0.07 million and 0.1 million cycles of the 680 million.

## The lexer candidate

**Outputs** (`logs/counters/stage3.log`): main's and the candidate's are the same bytes:

- the `-c` object, `61eb96dd…`;
- the `-E` output, `a984f9ca…`;
- the `-fsyntax-only` and `-c` diagnostics.

**Tests:** `test-lexer` in its three modes passes on the 9700X (`logs/stage2.log`) and locally.

**Whole driver, one placement** (`perf stat`, 10 rounds, the builds' order rotating by round; medians, with ranges):

| `sqlite3.c` | main | the candidate | change |
| --- | ---: | ---: | ---: |
| `-c` cycles | 680.05M (675.34–685.45) | 677.24M (673.06–679.23) | −0.41%, ranges overlap |
| `-c` instructions | 1,636.66M | 1,637.46M | +0.8M |
| `-c` `ls_misal_loads.ma64` | 11.94M (11.71–12.45) | 11.73M (11.45–12.19) | −0.21M, ranges overlap |
| `-fsyntax-only` cycles | 569.93M (565.92–574.25) | 567.66M (563.91–572.26) | −0.40%, ranges overlap |
| `-fsyntax-only` instructions | 1,363.24M | 1,364.02M | +0.8M |

**Where the crossing loads went:** the counter's spread between processes, about 0.7M, is larger than what the lexer had. The candidate's profiles (`logs/profiles/profile-lexer-*`) settle it: `tokenize_c_raw_no_separators` isn't among the top 25 functions in any of the three runs.

**The lexer itself, in one process** (`logs/stage4.log`):

- **Method:** `./build.sh lexer-variant control=…/c_lexer.c k1=…/c_lexer_k1_1555.c`, then `benchmark-lexer`. It checks both variants against `c_tokenize` on every file (0 differ) and times them over 21 interleaved passes.
- **Results**, change against `c_tokenize` (median of the passes' ratios):

  | Corpus | control | `k1` (the candidate) |
  | --- | ---: | ---: |
  | `sqlite3.c` | −0.23% | −1.47% |
  | `sqlite3.c`, `--no-digit-separators` | +1.02% | −0.39% |
  | C library | +0.08% | −1.54% |
  | C library, `--no-digit-separators` | +0.50% | −1.09% |
  | `src` | +0.15% | −1.53% |
  | `src`, `--no-digit-separators` | −0.74% | −2.06% |

- **Per byte:** the candidate runs 3.262 instructions per byte against 3.182, and 0.994 cycles per byte against 0.981 on `sqlite3.c`.

**Against the control, the candidate is 1.3% to 1.7% slower** in every corpus and mode. The permute and its operands add about 5 instructions per 64-byte vector, and they cost more than the split load they remove.

## The refine experiment (`logs/counters/stage5.log`)

**Outputs:** the same `-c` object and diagnostics as main's.

**Counters** (10 rounds, rotating):

| `sqlite3.c` | main | masked loads only | change |
| --- | ---: | ---: | ---: |
| `-c` `ls_misal_loads.ma64` | 12.21M (11.85–12.33) | 12.29M (11.94–12.86) | none |
| `-c` cycles | 680.43M (678.88–682.46) | 678.90M (676.63–682.54) | −0.22%, ranges overlap |
| `-c` instructions | 1,636.66M | 1,635.79M | −0.87M |
| `-fsyntax-only` cycles | 570.88M (567.49–575.36) | 569.76M (564.78–571.29) | −0.20%, ranges overlap |

**Profiles:** in the experiment's profiles (`logs/profiles/profile-refine-*`), `refine_pass_b_64_plain` still has 4.22% to 4.54% of the line-crossing samples.

**Reading:** masked loads don't remove the crossing, as the probe showed. A change of a fifth of a percent at one placement is within the 2% that placements alone move the driver (buster#509).

## Not run

- **The whole drivers over placements** (`scripts/stage6.sh`, buster#509's method with the frontend unit shifted). I cancelled it before it took the lock:
  - the in-process comparison already rejects the lexer candidate;
  - its measured slowdown, about 1.5% of the lexer's 1.7 ms in `sqlite3.c`'s `-c`, is about 0.02% of the driver, below the method's floor;
  - neither candidate removes or adds enough to show there.
- **The C++ corpus and the 7940HS:** neither was run.

## Files

- **`scripts/`:**
  - the probes and their run scripts;
  - `counters.sh` and `profile.sh`;
  - the stage scripts: `stage1.sh` and `stage3.sh` ran in the run root;
  - `chain34.sh`, which queued stages 3 and 4;
  - the two candidates' diffs.
- **`logs/`:**
  - **the stage logs:** `stage2.log` includes a first variant build that failed because the copy wasn't next to `host_isa.h`; `stage4.sh` rebuilt it in place;
  - **the counters:** CSV files, one line per process and event;
  - **the profiles:** the top 25 symbols per run;
  - **the builds' logs.**

  The lock's waiting lines name other sessions' runs as they stood.
