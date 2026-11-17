# Scalar paths removed: the baseline host's gate (buster#2924, phase B2)

David decided on 2026-11-17 that buster keeps AVX-512 vector paths alone
([buster#2924](https://github.com/buster14a/buster/issues/2924)). A scalar path goes
once its vector path is at least as fast on the 9700X. For the baseline host's code
(`host_scalar*.h`, the `#else` arms of `#if BUSTER_HOST_VECTOR`, `BUSTER_HOST_ARCH=x86-64`)
the only common measure is the whole driver: the baseline build refuses every
`benchmark-*` command. This record times main's native Release build against its
x86-64 (baseline, scalar) Release build.

## Setup

- buster main `d1cf1fe` (logs/commit.txt), built twice on benchpress under
  `exclusive.sh` with `./build.sh --config Release`: once for the default
  `BUSTER_HOST_ARCH=native` (znver5), once for `BUSTER_HOST_ARCH=x86-64`
  (scripts/build.sh). Their hashes are in logs/compilers.sha256.
- Inputs are from the 9700X job's frozen corpus
  (`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`):
  - list 1: `-c` of `sqlite3.c` (SHA-256 `0a409f16…`) with the 9700X job's
    `compile_time` options;
  - list 2: `-fsyntax-only` of the same file;
  - list 3: `-c` of Lua 5.4.8's 34 sources. The tarball (SHA-256 `4f18ddae…`)
    was downloaded fresh into the task's directory;
  - list 4: `-c` of musl's 1,336 units: the first source of each base name, as
    node-machine-census-2524-2026-11-12's census.sh took them.

  logs/inputs.txt has every input's hash.
- Each command runs on one lane (`--lanes 1`), pinned to CPU 2, writing its
  objects to `/dev/shm`. Commands: `ab --rounds 3 --cpu 2 --lock exclusive.sh`
  around `time-runs --runs 3 --copies 3` with the builds `native`, `x86-64` and
  `native-again`, in a Williams order (scripts/time.sh). That is 9 processes a
  build per round, and 3 rounds.
- A one-round trial ran first (logs/time-trial.log) and gives the same figures.

## Results

Medians over 9 processes in each round. "x86-64 vs native" is that round's
`time-runs` comparison; `native-again` is the floor.

| list | native wall (ms), rounds 1/2/3 | x86-64 wall (ms) | x86-64 vs native, wall | x86-64 vs native, user cycles | native-again vs native, wall |
| --- | --- | --- | --- | --- | --- |
| sqlite3.c `-c` | 122.5 / 122.3 / 122.2 | 400.8 / 400.3 / 401.0 | +227.2% / +227.2% / +228.2% | +257.2% / +256.6% / +258.0% | −0.24% / +0.17% / +0.05% |
| sqlite3.c `-fsyntax-only` | 99.8 / 99.9 / 99.7 | 349.2 / 348.3 / 348.3 | +250.0% / +248.8% / +249.2% | +288.2% / +288.2% / +288.0% | −0.45% / −0.58% / −0.19% |
| Lua, 34 units `-c` | 73.4 / 73.5 / 73.4 | 170.8 / 170.5 / 170.7 | +132.5% / +132.1% / +132.4% | +153.2% / +152.9% / +153.0% | −0.43% / −0.19% / −0.19% |
| musl, 1,336 units `-c` | 669.1 / 668.3 / 668.4 | 1,568.3 / 1,567.7 / 1,569.1 | +134.4% / +134.6% / +134.8% | +166.1% / +166.3% / +166.5% | +0.03% / −0.02% / −0.03% |

**The gate holds.** On every input, the baseline (scalar) build takes 2.3 to 3.5
times the native (vector) build's wall time. Copies and rounds agree within 1%.
Deleting the baseline host's code changes nothing on an AVX-512 host, which never
compiles it. The selectable twins (`--scalar`) and the fallbacks have their own
gates, module by module (#2924's phases C and D).

## Files

- scripts/build.sh and scripts/time.sh: the two steps, as run on benchpress in
  `~/buster-fast-bench/2924-claude`.
- logs/build-native.log and logs/build-x86-64.log: each build's output,
  including its wait for the lock.
- logs/time.log: the 3 rounds, every process's line and the medians.
- logs/time-trial.log: the 1-round trial.
- logs/inputs.txt, logs/compilers.sha256, logs/commit.txt: what was timed.

# B2's pull request: main against the head (b2-main-vs-head/)

Phase B2 removes the scalar host (the `#error` in `host_isa.h`, the scalar headers, every
`BUSTER_HOST_VECTOR` use resolved to the vector side). On an AVX-512 host it should change
nothing, and these two checks say it doesn't.

## Disassembly (disassembly/)

Main `2cb0a6779` (#2939's head, the same `src/` as main `05c5d95d7`) and B2's tree, both
`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release`, built in a cloud
container with the same toolchain, then `objdump -d --no-show-raw-insn` per function
(`split.py`: addresses and symbol offsets masked; `compare.py`; `classify.py` without
objdump's annotations, which name whichever rodata symbol precedes an address and move with
the data's layout).

- 9,797 functions in main's executable, 9,787 in B2's. The 10 missing are command runners
  (`run_x86_zen5_tests`, `run_gnu_tests`, ...) that `main_command` now inlines: its dispatch
  lost the baseline build's benchmark refusal.
- Every other function is the same, instruction for instruction, but 12 (`classified.txt`):
  6 whose only difference is an immediate (`__LINE__` in asserts and tests whose files lost
  comment lines), and 6 test or command functions whose resolved conditions changed
  (`main_command`, `run_c_lexer_tests`, `run_checker_deferred_tests`, `run_node_census`,
  `check_test_transition_limit`, `ir_source_tests_command`). No compile path changed.

## Timing (scripts/, logs/)

Main `05c5d95d7` and the head `4348c3a18` (from a bundle; logs/commits.txt), each built on
benchpress under `exclusive.sh` with `./build.sh --config Release` (native, the 9700X), then
timed as the gate was: `ab --rounds 3 --cpu 2` around `time-runs --runs 3 --copies 3` with
`main`, `head` and `main-again`, one lane, objects to `/dev/shm`, on sqlite3.c (`-c` and
`-fsyntax-only`), Lua 5.4.8's 34 sources and musl's 1,336 units (logs/time.log).

| list | head vs main, wall (rounds 1/2/3) | main-again vs main, wall | head vs main, user cycles | main-again vs main, user cycles |
| --- | --- | --- | --- | --- |
| sqlite3.c `-c` | −0.12% / −0.24% / +0.51% | −0.20% / −0.15% / +0.28% | −0.17% / −0.31% / −0.03% | −0.08% / −0.15% / −0.16% |
| sqlite3.c `-fsyntax-only` | +0.22% / −0.48% / −0.57% | +0.13% / −0.53% / −0.60% | +0.18% / −0.08% / −0.60% | +0.11% / +0.11% / −0.39% |
| Lua, 34 units `-c` | −0.16% / −0.01% / −0.22% | −0.22% / +0.08% / −0.08% | −0.11% / −0.09% / −0.31% | −0.11% / +0.04% / −0.09% |
| musl, 1,336 units `-c` | −0.05% / −0.01% / −0.11% | +0.03% / +0.04% / −0.14% | +0.08% / +0.16% / −0.08% | +0.03% / +0.12% / −0.10% |

Main's medians over the three rounds: 122.2 to 122.8 ms for sqlite3.c `-c`, 99.5 to 100.1 ms
`-fsyntax-only`, 73.3 to 73.4 ms for Lua, 669.0 to 669.6 ms for musl. The head is within main-again's floor
on every list and round: unchanged, as the identical disassembly says.

# Phase C, the x86-64 disassembler's gate (c-disassembler-gate/)

The disassembler's twins by request: `x86_disassemble_scalar` (`x86_disassemble_impl` with
`vectorized` and `compact` false), the `compact` variant (`vectorized` false, `compact` true),
`x86_decode_classify_scalar`, and the scalar formatter and listing that `--scalar` and the
`scalar` variant select. `x86_disassemble` (the `batched` variant) is the production path.

The benchmarked compiler is B2's head (the same build as b2-main-vs-head's `head`,
SHA-256 `454405469884…`, logs/compiler.sha256). `benchmark-x86-disassembler` ran three times
under `exclusive.sh`, pinned to CPU 2 (gate.sh): on its synthetic compiler stream, its
synthetic vector stream (`--vector`), and real code, the benchmarked compiler's own `.text`
(`--file compiler.text`: 31.3 MB, 6,677,043 instructions). Each figure is the median of 21
passes, with the extremes in brackets (logs/*.log).

| stream | phase | scalar | avx512 | batched (x86_disassemble) | compact |
| --- | --- | --- | --- | --- | --- |
| compiler.text | decode, ns/insn | 35.68 | 24.89 | **13.62** | 24.87 |
| compiler.text | classify, ns/byte | 0.294 | 0.021 | **0.021** | 0.294 |
| compiler.text | decode+format, ns/insn | 69.48 | 42.03 | **30.74** | 42.00 |
| compiler.text | decode+listing, ns/insn | 72.66 | 43.03 | **31.72** | 43.03 |
| synthetic compiler | decode | 31.73 | 23.37 | **8.44** | 23.14 |
| synthetic compiler | classify | 0.294 | 0.020 | **0.020** | 0.294 |
| synthetic compiler | decode+format | 61.72 | 41.71 | **26.44** | 41.40 |
| synthetic compiler | decode+listing | 62.34 | 42.80 | **27.55** | 42.53 |
| synthetic vector | decode | 37.90 | 28.55 | **28.74** | 27.91 |
| synthetic vector | classify | 0.293 | 0.020 | **0.020** | 0.292 |
| synthetic vector | decode+format | 80.54 | 50.44 | **50.46** | 49.53 |
| synthetic vector | decode+listing | 81.40 | 51.48 | **51.49** | 50.53 |

**The gate holds against the scalar path.** `x86_disassemble` is 1.6 to 3.8 times faster
than `x86_disassemble_scalar` in every phase on every stream, and the vector classifier is 14
times faster than the scalar one. The scalar variant's formatter and listing
(`x86_disassembly_format_scalar`, `x86_disassembly_listing(..., true)`) ride in its
decode+format and decode+listing rows.

**What the selector's own arms show.** The `vectorized` selector inside the decoder
picks the prefix test (the classifier's mask against `x86_decode_is_prefix`) and the
bucket scan (eight signatures in one compare against one form at a time). `avx512` and
`compact` differ only there: both run unbatched, without the index, with the compact
validation. Their decode rows: equal on `compiler.text` (24.89 against 24.87 ns), `compact`
1.0% faster on the synthetic compiler stream (23.14 against 23.37) and 2.3% faster on the
vector stream (27.91 against 28.55). So the selector's scalar arms were never slower than
its vector arms. The production path's win comes from the batch lanes and the PEXT index:
`batched` against `avx512` is 1.8 times faster on `compiler.text`, 2.8 times on the
synthetic compiler stream, and equal on the vector stream, which is all VEX and EVEX forms
that `batched` decodes one at a time through the same `x86_decode_one`. There, `compact` is
2.9% faster than `batched` in decode and 1.8% in format and listing.
`docs/x86-64-disassembler.md` recorded the same tradeoff when the decoder landed (PR #240:
the vector mix 4.3% slower than the compact scalar control). Deleting the twins keeps the
vector arms in `x86_decode_one`.

# Phase C, the disassembler's pull request (c-disassembler-pr/)

The head (`d2cb4438a`, the PR's tree) against main `0e8342dd7`: the twins go, the tests
take oracles that aren't a second decoder.

## The 9700X (9700x/)

`run.sh` built both sides' Release under `exclusive.sh` (logs/compilers.sha256), then:

- `test-x86-disassembler --objdump --file corpus.text` on both. `corpus.text` is
  `examples/disassembler/corpus.c` at `clang -O3 -march=znver5`, CI's raw corpus, and the
  tools are GNU binutils 2.47. Both passed:
  - the catalogue reassembled, 13,319 instructions;
  - the generated stream, 10,003 for the head and 10,001 for main (the random stream
    differs by the seeds the head's new checks draw);
  - the corpus, 152 of 152.

  The head's own checks report 0 failures (logs/test-objdump-*.log).
- `benchmark-x86-disassembler`: main with `--only batched` (its production path) against
  the head, three alternating processes a stream, pinned to CPU 2. The streams are the
  synthetic compiler stream, the synthetic vector stream, and the gate's `compiler.text`
  (31.3 MB). In each cell, ns per instruction (per byte for classify) for the three
  processes, then the change of the medians and the retired instructions per item:

| stream | phase | main | head | change | instructions |
| --- | --- | --- | --- | --- | --- |
| compiler | decode | 7.840 / 7.651 / 7.681 | 7.564 / 7.479 / 7.621 | −1.5% | 138.0 → 130.5 |
| compiler | decode+format | 26.03 / 25.90 / 25.88 | 23.92 / 23.86 / 24.08 | −7.6% | 394.8 → 365.2 |
| compiler | decode+listing | 27.08 / 27.05 / 26.95 | 24.76 / 24.61 / 24.83 | −8.5% | 434.8 → 404.2 |
| vector | decode | 28.45 / 28.76 / 28.41 | 26.78 / 26.76 / 26.89 | −5.9% | 663.2 → 605.3 |
| vector | decode+format | 50.50 / 50.69 / 50.28 | 46.86 / 46.75 / 47.06 | −7.2% | 978.2 → 898.0 |
| vector | decode+listing | 51.59 / 51.75 / 51.50 | 47.46 / 47.33 / 47.66 | −8.0% | 1018.2 → 937.0 |
| compiler.text | decode | 13.77 / 13.71 / 13.65 | 13.45 / 13.28 / 13.51 | −1.9% | 262.2 → 242.9 |
| compiler.text | decode+format | 31.16 / 31.08 / 30.92 | 28.89 / 28.71 / 28.90 | −7.0% | 548.2 → 507.1 |
| compiler.text | decode+listing | 32.08 / 32.02 / 31.89 | 29.88 / 29.73 / 29.88 | −6.7% | 588.2 → 546.1 |

The decode rows time the same harness work on both sides, one decode call a stream, so
their change is the decoder's own. `x86_decode_one` lost its `vectorized`, `compact` and
`indexed` parameters, and the retired instructions fall with the time. The format, listing
and classify rows also drop main's choice of variant inside the timed loop: one choice a
record for formatting, one a 64-byte chunk for classify. Classify halves (0.020 to 0.009–0.013
ns a byte) for that reason alone; the classifier's code is unchanged.

On the vector stream, the head's decode (26.8 ns) is now below the old `compact` control's
27.9 ns of the gate run (c-disassembler-gate/), the one place where the selector's scalar
arms had been faster.

## Mutation check (mutation/)

`mutants.py` holds 13 mutants of the decoder and formatter, one change each:
- m01: the classifier's nibble table;
- m02: a batch lane's REX.R;
- m03: the index's ambiguous cells;
- m04: the `end == size` mask;
- m05 and m06: the compact checks, once too lax and once too strict;
- m07: the speculative lengths;
- m08: a format-plan token;
- m09: the listing's hex column;
- m10: the batch's resync;
- m11: the FWAIT retry;
- m12: the lanes' disp8 sign;
- m13: the index's PEXT mask.

`run.py` builds each in a copy of the tree (Develop) and runs `test-x86-disassembler`
(the plain run, without `--objdump`), checking that every mutant applies and reverts
cleanly first. The trees:
- `t0`: main `33eeff166` with its twin test;
- `t2`: the first head, the new checks without the index and truncation tests;
- `t2b`: the PR's tree, for t2's survivors (m13b is m13's text there).

| mutant | main's twin test (t0) | first head (t2) | PR's tree (t2b) |
| --- | --- | --- | --- |
| m01 to m02, m05 to m12 | killed | killed | killed |
| m03 index, ambiguous cells | **survived** | survived | killed (the index test) |
| m04 the `end == size` mask | killed | survived | killed (truncation status) |
| m13 index PEXT (m13b in the PR's tree) | killed | killed | killed |

The PR's tree ran all 13 (results.txt, its last block): it kills every one, and main's twin
test kills 12. The first head missed m03 and m04. m04 was coverage the twin comparison had:
truncated keys, which `x86_decode_test_truncations` now covers (each generated instruction
cut short is TRUNCATED). m03 the twins missed too; `x86_decode_test_index` now checks
`x86_decode_index_row` against a scan of the bucket's signatures (31,168 keys in 817 buckets).

`logs/` keeps each run's failing lines.

# Phase C, branch sizing's gate (c-branch-sizing-gate/)

Main `0e8342dd7`'s Release build (the same `compilers/main` as c-disassembler-pr's; SHA-256 in
logs/compiler.sha256), `benchmark-branch-sizing` with every row, three processes, each under
`exclusive.sh` pinned to CPU 2 (gate.sh). Each row sizes a pool of about 262,000 records of
generated functions: clang -O0-like (`tier0-`) and -O2-like (`optimized-`) functions of the
row's record count, sqlite3's -O0 function sizes (`tier0-mix`), and chains of 1,000 links.
Medians of the three processes' medians:

| Row | `size_branches`, ns/record | `size_branches_scalar` | Scalar ÷ vector |
| --- | ---: | ---: | ---: |
| tier0-40 | 1.409 | 15.271 | 10.84 |
| tier0-250 | 0.893 | 15.418 | 17.27 |
| tier0-2000 | 0.765 | 15.349 | 20.06 |
| tier0-10000 | 0.805 | 15.375 | 19.10 |
| tier0-mix | 1.207 | 15.587 | 12.91 |
| optimized-40 | 1.525 | 15.512 | 10.17 |
| optimized-250 | 0.981 | 15.771 | 16.08 |
| optimized-2000 | 0.853 | 15.736 | 18.45 |
| optimized-10000 | 0.906 | 15.804 | 17.44 |
| chain-forward | 2.324 | 15.072 | 6.49 |
| chain-backward | 2.342 | 15.033 | 6.42 |

**The gate holds for the whole path in every row, at every function size.** Most of the
difference is the lengths phase: `x86_measure` against `x86_measure_scalar`, which encodes one
record at a time (36 against 724 cycles per branch on tier0-40).

**Two of the vector path's phase timings lose to the scalar path's.** In cycles per branch, the vector
path against the scalar one (logs/bench-*.log, the `vector` and `scalar` phase lines):

| Row | ranks | write |
| --- | --- | --- |
| tier0-40 | 6.12 against 2.39 | 7.96 against 3.13 |
| optimized-40 | 6.78 against 3.38 | 6.63 against 3.01 |
| tier0-mix | (vector faster) | 4.73 against 3.75 |
| tier0-2000 | (vector faster) | 1.99 against 1.66 |
| tier0-10000 | (vector faster) | 2.63 against 2.61 |
| optimized-2000 | (vector faster) | 1.98 against 1.87 |
| optimized-10000 | (vector faster) | 2.68 against 2.52 |

Ranks is different code on the two paths (`branch_sizing_ranks_vector` against
`branch_sizing_ranks_scalar`). Write is the same function on both, `branch_sizing_write`: the
benchmark times a phase as a run through it less a run that stops before it, so its gap is what
the vector path's earlier phases leave for it, not different code. On 40-record functions the two
gaps add up to about 0.95 of the vector path's 7.94 cycles per record (12%). Deleting the scalar
path keeps the vector phases; the numbers to beat are buster#2946.

# Phase C, branch sizing's pull request (c-branch-sizing-pr/)

The head (`9629a0dcf`, rebased onto main as the PR's commit with the same diff, patch-id
`5bc4039e…`) against main `0e8342dd7`, on the 9700X (9700x/run.sh, each run under the lock),
then a second head, `head2`, adding cmake/BusterStartOrder.txt's change (9700x/run2.sh).

**GNU as**, `test-branch-sizing --cross-check` with binutils 2.47 on both sides: 404 functions,
404 compared, 404 the same, 99,019 long branches (logs/test-cross-*.log). The cloud container's
binutils 2.42 compares none on main too.

**benchmark-branch-sizing**, `--measure size_branches` and `--measure size_encode`, three
alternating processes a side, CPU 2. Medians of the processes' medians, ns per record:

| Row | `size_branches` main | head | change | `size_encode` change |
| --- | ---: | ---: | ---: | ---: |
| tier0-40 | 1.375 | 1.321 | −3.9% | −1.9% |
| optimized-40 | 1.482 | 1.431 | −3.4% | −1.8% |
| tier0-mix | 1.124 | 1.120 | −0.4% | −0.3% |
| tier0-250 | 0.877 | 0.877 | 0.0% | −0.8% |
| tier0-2000 | 0.760 | 0.772 | +1.6% | +0.7% |
| optimized-2000 | 0.847 | 0.856 | +1.1% | −0.1% |
| tier0-10000 | 0.805 | 0.814 | +1.1% | +0.9% |
| optimized-10000 | 0.907 | 0.914 | +0.8% | +0.1% |
| chains | 2.329, 2.347 | 2.343, 2.354 | +0.6%, +0.3% | +0.3%, +0.2% |

Small functions retire 9% fewer instructions (tier0-40: 22.1 to 20.1 per record):
`branch_sizing_run` lost its dead scalar arms, 1,601 to 932 instructions. Functions of 2,000
records and more retire the same instructions (10.37 against 10.40 per record on tier0-2000)
in 1.4% more cycles, every head process above every main one: the phase loops' placement, not
more work.

**Disassembly** (logs/compare.txt, logs/classified.txt; disassembly/split.py and compare.py
from b2-main-vs-head, classify2.py): 9,935 functions in main, 9,936 in the head, 416 differ:
- 343 by symbols or immediates alone;
- 15 by immediates;
- 51 in length: tests, benchmarks, `branch_sizing_run`, `branch_sizing_validate` (it takes the
  vector column check), the emission (`check_program_emit_timed` +7 instructions,
  `check_program_emit_code_half` −3: the `--scalar` arms of the column check go), and a few
  functions inlining changed around (`check_mangle_name`, `asm_assemble`).
- The checker unit's `branch_sizing_run` is inlined into `size_branches` now, which the start
  order didn't name: it landed in cold `.text` (logs/head-functions.txt, section 12), where main
  had `branch_sizing_run` in `.text.buster_start`. head2 names `size_branches` there instead
  (logs2/head2-branch-sizing.txt: section 10, the address main's `branch_sizing_run` had).

**Whole drivers**, `ab --rounds 3` around `time-runs --runs 3 --copies 3` with main, the head
and main-again, as in b2-main-vs-head (logs/time.log, logs2/time.log). Head against main, the
three rounds, with main-again's in brackets:

| List | head, user cycles | head2, user cycles | head2, wall |
| --- | --- | --- | --- |
| sqlite3.c `-c` | +0.38 / −0.16 / +0.05% (+0.15 / −0.07 / −0.39) | −0.17 / −0.38 / −0.34% (−0.10 / −0.11 / −0.17) | −0.20 / −0.29 / +0.02% (+0.24 / +0.22 / +0.24) |
| sqlite3.c `-fsyntax-only` | +0.16 / +0.23 / −0.17% (−0.11 / −0.20 / −0.53) | −0.34 / +0.04 / −0.12% (−0.01 / +0.10 / +0.25) | −0.05 / −0.02 / −0.61% (−0.07 / −0.36 / −0.01) |
| Lua | −0.38 / −0.11 / +0.07% (+0.02 / +0.18 / +0.06) | +0.07 / −0.44 / −0.12% (−0.05 / −0.40 / +0.62) | −0.24 / −0.40 / −0.06% (−0.30 / −0.48 / +0.48) |
| musl, a process a unit | −0.35 / +0.22 / +0.26% (−0.15 / −0.14 / −0.12) | −0.18 / −0.07 / −0.07% (−0.00 / −0.08 / +0.11) | −0.16 / +0.13 / −0.03% (−0.08 / −0.01 / +0.04) |

The first head's musl user cycles sat above main-again's in two rounds, as a function every
compile runs in cold code would; head2 is within main-again's spread on every list and round.

**Mutation check** (mutation/): seven mutants of the column check, the offsets, the rounds and the
column check's loads, each built in a copy of the head and run with `test-branch-sizing` (the
plain run). Six fail it. b7 (the targets' load unmasked) survives as an equivalent mutant: Clang
folds the load into the masked compare (`vpcmpltud (%rcx,%rsi,4),%zmm0,%k1{%k1}`), whose masked-off
elements don't fault, and the column check compiles to the same instructions
(mutation/head-validate-branches.s, b7-validate-branches.s, built from mutation/wrap.c).
