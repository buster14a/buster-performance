# Release in parts: step 5's gate (2026-11-13)

Step 5 of the design in buster's `docs/stage1-build-design.md`
([buster#2559](https://github.com/buster14a/buster/issues/2559)): the Release configuration built in parts, as Develop
is (buster#2595), with the design's settings for Release (bodies of up to 300 unoptimized instructions read where they
are called, single callers with their callers, by file, `-g` as today). Its gate was the 9700X job's whole measure,
every benchmark over its placements, inside its floor; the design's rule for a failure: "Release stays whole, and the
design is Develop alone."

**Result: the gate fails, so Release stays whole.** As designed, `benchmark-assembler` runs **+9.57%** user cycles over
four placements (+9.04% to +10.02%; the base against itself +0.01%, -0.70% to +0.42%), with 10.5% more instructions;
nine more benchmarks execute 0.7% to 15% more instructions. Five changes to the splitter (section 5) take every
benchmark but two within 0.8% of the whole build's instructions (`benchmark-x86-zen5` sizes its own work and doesn't
count): `benchmark-ir-optimize-passes` (+3.7%) measures inside its floor over the placements, and
`benchmark-assembler` **+4.55%** (+4.08% to +5.45%; floor -0.50% to +0.60%): still outside. The build itself gains what the design said: a
clean build 86.4 to 77.6 s, an edit of `c_check_input.c` 75.1 to 32.5 s (15.0 s without debug information).

- **Sources:** buster `main` at `e22f84ea` (the base) and the branch's patches on it: `patches/step5-as-designed.patch`
  (the head, "as designed"), and the candidates of section 5 (`k1` to `k4`; `step5-improved-splitter.patch` is
  `k5`). The patches also hold the branch's documentation and build-regression changes; none of them was merged.
- **The 9700X** (`benchpress`): Linux 6.18.50-2-lts, the `performance` governor on CPU 2. The executables the A/B
  compares were built as the 9700X job builds its own (`scripts/9700x/env.sh`): CI's staged official Clang and LLD
  23.1.4 first on `PATH`, `BUSTER_HOST_ARCH=znver5`, `BUSTER_DEBUG_INFO=0`, each with `./build.sh shifts` of `main.c`
  at 0, 1088, 2112 and 3136 bytes (`placements/NAME/compiler-SHIFT`; `main.c` is the first unit, so the padding moves
  every unit's `.text` after it). The build timings of section 1 used the host's clang 23.1.1, CMake 4.4.4 and Ninja
  1.13.2 with the build's eight jobs, as #2559's earlier records did. Every build, run and comparison was its own hold
  of the 9700X's lock (`scripts/9700x/lock.sh`; `*.holder*` files have the holder's line), and other sessions' and
  CI's work ran between holds. The queues' own logs, which held other sessions' lock-wait lines, aren't kept.
- **The development container** (`raw/local`): a 4-CPU cloud container (Intel Xeon, Ubuntu's clang 23.1.6), for the
  build regression and the splitter's inlining comparisons; its times are not the 9700X's.

## 1. The build, as designed (the host's clang, eight jobs)

`scripts/9700x/timed.sh`, one build a hold in the trees `tbase` (main) and `thead` (the head), with
`raw/9700x/results/timed.txt` and `raw/9700x/logs/timed-*`. An edit appends (or prepends) an emitted `used` static
function that returns a new string literal.

| Scenario | Release whole (main) | Release in parts (as designed) | Part jobs |
| --- | ---: | ---: | ---: |
| Clean build, `-g` | 86.4, 86.7 s (502, 503 s of CPU) | 77.6, 77.6, 77.6 s (567 s) | 171 |
| Nothing changed | 0.04 s | 0.04 s | 0 |
| `c_check_input.c`, a function appended | 75.1 s | 32.5 s | 47 |
| `c_check_input.c`, one before its first line | | 32.5 s | 47 |
| `differential.c` | | 21.1 s | 4 |
| `c_parser_impl.c` | | 14.6 s | 9 |
| `host_isa.h`'s time alone (42 units' front ends) | | 30.9 s | 0 |
| The edits undone | 75.6 s | 54.4 s | 60 |
| Clean build, `BUSTER_DEBUG_INFO=0` | 69.5 s (377 s) | 63.1 s (466 s) | 171 |
| `c_check_input.c`, a function appended, `BUSTER_DEBUG_INFO=0` | 62.0 s | 15.0 s | 1 |

- With `-g`, DWARF 5 records each source file's MD5 in every part that mentions the file, so an edit of
  `c_check_input.c` recompiles 47 of the checker's 49 parts, as the design measured (35.8 s on its prototype).
  Without debug information the head's units compile with line tables for the plan and `presplit --strip-debug`
  writes the parts without them: the edit recompiles one part.
- **Determinism:** after the edits, the clean rebuild of the same sources has the incremental build's SHA-256
  (`bd88a82a...`), and undoing the edits gives the clean build's (`91ad707b...`).
- **Develop is unchanged:** the head's Develop executable is main's, byte for byte once its debug information (which
  names each tree's path) and build ID are stripped.
- With CI's toolchain and the four placements' links (`raw/9700x/results/builds.txt`), the base built in 54.9 s
  (296 s of CPU) and the head in 50.2 s (370 s); the candidates of section 5 in 48.8 to 49.4 s (359 to 366 s).

## 2. Correctness

- **The outputs** (`scripts/9700x/outputs.sh`, `raw/9700x/results/outputs.txt`): the head's executable writes the
  base's bytes for all 69 outputs: the frozen `sqlite3.c`'s `-c` at the default tier and at Tier 1 and its `-E`, and
  each of the eleven `main.c` units' `-c` at both tiers and `-E`.
- **The build regression** (`raw/local/build-regression-as-designed.log`): the full `build-regression`, with the
  branch's checks for the units in parts, passed on the development container (exit 0).
- **The correctness inventory** on the 9700X (`scripts/9700x/inventory.sh`, `raw/9700x/results/inventory/`): shards 1
  to 3 of 8 passed; shard 4 failed in setup (the script named a corpus directory an earlier session had removed, so
  the SQLite and corpus commands found no inputs), and the rest wasn't run once the gate had failed.

## 3. The benchmarks

`scripts/9700x/list.sh` writes the 69 benchmarks (`raw/9700x/inputs/benchmarks.txt`): every command of the 9700X job's
benchmark steps (`.github/workflows/9700x.yml` at `e22f84ea`) that times the compiler's own code, with the job's inputs
on the host (the frozen corpus, c-testsuite at its pin, the predefines). Left out: what times the machine or other
programs (`measure-x86-zen5`, `measure-mask-spills`, `benchmark-floors`, the linkers' and `clang -E`'s baselines, and
the programs `measure-tier1-programs`, `measure-tier1-rows` and `measure-helpers` time), and the isolated and
after-scalar repeats of the same commands; added: `-c --tier1` of `sqlite3.c` and `-fsyntax-only` of the checker's
unit, the design's second workload. `scripts/9700x/calibrate.sh` timed one run of each (`results/calibrate.txt`).

**The gate's measure** (`scripts/9700x/bench.sh`, `analyze.sh`, `results/bench/`): `time-runs` over the base's, the
candidate's and the base's executables again (the floor), at the four placements, a fresh copy each, after a warm-up,
pinned as the job pins the step; the verdict reads each build's median user cycles against the base's and that
difference's range over the placements, inside the floor when the range holds 0 and the difference is within the
base's own against itself.

| Benchmark | Candidate | Runs | Against the base | Over the placements | Base again (floor) | Verdict |
| --- | --- | ---: | ---: | ---: | ---: | --- |
| `benchmark-assembler` | as designed | 44 | **+9.57%** | +9.04% to +10.02% | +0.01% (-0.70% to +0.42%) | outside |
| `benchmark-backend` | as designed | 12 | +0.06% | -0.53% to +0.52% | +0.04% (-0.65% to +0.88%) | inside |
| `benchmark-assembler` | `k5` | 44 | **+4.55%** | +4.08% to +5.45% | +0.11% (-0.50% to +0.60%) | outside |
| `benchmark-ir-optimize-passes` | `k5` | 12 | +1.97% | -1.01% to +7.40% | +0.52% (-1.11% to +4.18%) | inside |
| `benchmark-tier1-code-certificate` | `k5` | 4 | +0.13% | -0.90% to +0.79% | +0.41% (-0.84% to +0.71%) | inside |

The full A/B of all 69 was started for the head as designed and stopped after `benchmark-assembler` failed it;
`scripts/9700x/plan.sh` sized its holds from the calibration.

**Triage by instructions** (`scripts/9700x/triage.sh`, `results/triage-*.txt`): one process of each benchmark by the
base and by a candidate (placement 0) under `perf stat`, whose user instructions tell a change in the code from one in
its placement. Instruction counts are exact for most benchmarks; `measure`-like ones that size their own work by time
(`benchmark-x86-zen5`) are not. As designed, the benchmarks whose instructions moved by more than 0.5%:

| Benchmark | As designed | `k5` |
| --- | ---: | ---: |
| `benchmark-assembler` | +10.49% | +3.64% |
| `benchmark-environments` | +14.98% | -0.00% |
| `benchmark-lowering` | +3.38% | +0.06% |
| `benchmark-foreign-strings` | +1.94% | -0.19% |
| `benchmark-ir-optimize` | +1.52% | +0.42% |
| `-c --tier1 sqlite3.c` | +1.50% | +0.43% |
| `benchmark-tier1-code-certificate` | +1.38% | +0.79% |
| `benchmark-checker-source` (musl's `regcomp.c`) | +0.81% | +0.26% |
| `benchmark-checker-source` (`sqlite3.c`) | +0.72% | +0.26% |
| `benchmark-gnu` | +0.68% | -0.33% |
| `benchmark-ir-optimize-passes` | -0.16% | +3.72% |
| `benchmark-link --only direct` | +0.03% | +0.53% |
| `benchmark-dominators --cfg` | -3.52% | -1.77% |
| `benchmark-check-debug` | +0.06% | -2.07% |
| `benchmark-backend-source` | -0.04% | -1.70% |

The design's own two workloads moved little either way: `-c sqlite3.c` -0.17% instructions with `k5`, `-fsyntax-only`
of the checker's unit +0.36%.

## 4. Why: what the parts' inliners didn't do

`scripts/9700x/profile.sh` and `calls.sh` (`results/profile/`, `results/calls/`: perf's cycles by symbol, and sampled
call pairs by branch stacks) found the assembler's lost inlining; `scripts/local/inline_diff.sh` lists the
(callee, caller) pairs the whole unit's `-O3` inlines (clang's `-Rpass=inline`) that no part does
(`raw/local/inlining/*/missing.pairs`: `id-main` and `id-frontend` with `k3`, `id-asm` with `k4`, `id-asm5` with a first
`k5` that read `asm_assemble`'s body in the benchmark's part, `id-asm6` with `k5`).

- **A read body costs its owner the last-call bonus.** The head read `asm_assemble`'s small body in the parts of its
  callers (the benchmark, the driver, the tests), so its static callees `asm_layout`, `asm_parse` and `asm_emit` had a
  hidden alias in their own part for those parts to call. The alias is a use: the owner's inliner no longer inlined
  them as the last call to a static function, which the whole unit does whatever their size. In the assembler's unit
  443 of 848 definitions had such an alias.
- **Strings named by a table came as declarations.** A part that read `asm_alias`'s table of mnemonics
  (`static const char* const aliases[][2]`) didn't read the strings the table names, whose only reader was the data
  part (the table's initializer), so `strlen` of each couldn't fold: `asm_instruction` made 46 calls to `strlen`
  where the whole unit's makes 16.
- **A benchmark measures its kernel inlined.** `c_environment_lookup_batch` and `c_lowering_vector` and
  `c_lowering_scalar` are larger than the limit and in other files' parts than the benchmarks that call them, which the
  whole unit inlines them into.
- **What `k5` still loses in the assembler:** `arena_reserve` and `scratch_begin` in a dozen callers,
  `asm_word_registers_vector` into `asm_cache_registers` and that into `asm_parse_source`: inlining decisions that
  depend on the callers and costs the whole unit sees, which a part's inliner reaches differently.

## 5. The candidates

| Candidate | Change to `tools/codegen/presplit.c` (Release's options) | Assembler's instructions |
| --- | --- | ---: |
| head | as designed: `--import 300 --anchor 24 --cohere 150000 --spread 2`, `--strip-debug` without debug information | +10.49% |
| `k1` | `--keep-statics`: no part reads a body that calls a static function only its own part calls and no part may read | +8.54% |
| `k2` | and a static function only called in its own part goes to the parts that read it as a local copy, with no alias | +8.41% |
| `k3` | and a part that reads a constant's initializer reads the constants it names (rule 4 through tables) | +3.94% |
| `k4` | and every static function that is only ever called goes as a local copy to the parts that read it (aliases in the assembler's unit 443 to 46) | +3.64% |
| `k5` | and `--benchmark-bodies`: a benchmark's own file reads the body of every function it calls | +3.64% |

The third change also matters to Develop, whose parts read the same tables (its compile path ran 1% to 2% slower than
Release's); none of these was measured for Develop.

## 6. Files

- `patches/`: the head as designed (`step5-as-designed.patch`) and the candidates (`k1-keep-statics.patch` to
  `k4-copies-everywhere.patch`, `step5-improved-splitter.patch` for `k5`), each against `e22f84ea`.
- `scripts/9700x/`: the harness, run on the 9700X from `~/buster-fast-bench/2559-release-claude` (paths in the scripts
  are that directory's); `raw/9700x/scripts/q*.txt` are the queues in the order they ran, one hold a line
  (`queue.sh`), some stopped part-way when a candidate superseded them.
- `raw/9700x/results/`: `builds.txt` (the A/B's builds), `timed.txt` (section 1), `calibrate.txt`, `bench/` (the
  gate's comparisons), `triage-*.txt`, `outputs*.txt`, `profile/`, `calls/`, `inventory/`, and `queue.txt` (each hold's
  start, end and status). `raw/9700x/logs/`: the builds' logs and Ninja's new lines (`timed-*`), and the calibration's
  outputs.
- `raw/local/`: the inlining comparisons and the build regression's log.
