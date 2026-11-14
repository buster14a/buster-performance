# Issue 1353 memory diagnostics

These are cloud-host resource and correctness checks, not accepted throughput measurements. The approved throughput host remains the locked Ryzen 7 9700X. No compilation-time improvement is claimed from this record.

## Inputs and baseline

Baseline source: `buster14a/buster` commit `b7a95eedbe16fbd8434654f192f8f7aab76c56e5`.

The original `ssa_resource.c` generates the issue's scoped-loop family, sequential GNU statement-expression MAX calls, and nested MAX calls. The three small executable inputs contain explicit result checks; Clang 23.1.4 at `-O0` compiled and executed them successfully. Large inputs contain no `main` and are compile-only checks.

The loop family matches the posted issue generator exactly: its shell line is `echo "for (int i = 0; i < a; i++) s += i * $i;"`. Bash expands `$i` to the outer generation counter, so the generated C multiplies the local `i` by each loop's numeric coefficient. It does not emit `i * i`.

Build:

```sh
BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0 BUSTER_PARALLEL_CODEGEN=0 ./build.sh --config Release --jobs 2
```

The toolchain is the installed official Clang 23.1.4 bundle; complete version and CPU metadata are in `host.txt`. `baseline-build.log` is the untouched build output. No generated executable or object should be committed with this evidence.

## Reproduce inputs

```sh
clang -std=c17 -O2 -Wall -Wextra -Werror ssa_resource.c -o ssa-resource
./ssa-resource generate loops 8000 0 0 > loops-8000.c
./ssa-resource generate max 4000 1 0 > max-4000.c
./ssa-resource generate nested 200 8 0 > nested-200-8.c
./ssa-resource generate loops 32 0 1 > loops-exec.c
./ssa-resource generate max 32 1 1 > max-exec.c
./ssa-resource generate nested 8 4 1 > nested-exec.c
```

The loop series also uses 1,000, 2,000, 4,000 and 16,000 loops. The MAX series uses 1,000 and 2,000 calls as well. The second nested case uses depth 10.

## Resource runner

```sh
./ssa-resource run 2300000 COMPILER -c --tier1 -o output.o loops-8000.c
./ssa-resource run 2300000 COMPILER -c --tier1 --verify -o output.o loops-8000.c
./ssa-resource run 2300000 COMPILER test-ssa-source --lifetimes loops-8000.c
```

The runner forks one command and records its `wait4` peak RSS in KiB, exit status, and whether its RSS or 180-second wall limit killed the process group. It polls the child's `/proc/PID/status` every millisecond and kills the group when reported RSS exceeds the requested guard. A guarded run is incomplete and establishes no successful peak measurement. The guard is a polling bound, so the measured peak can exceed the threshold slightly. The runner is not a hard cgroup memory limit.

Each compiler/input/mode combination was run once. These are single-process resource diagnostics, not repeated performance samples or statistical summaries. The complete commands and selected input identities are in `commands.txt` and `source-sha256.txt`. Large generated inputs and binaries are omitted; the generator, compiler revisions, build flags, and binary hashes identify them.

For publication, the runner's copyright comment points to this repository's `provenance/buster/LICENSING.md`; no executable source tokens were changed after the runs.

Ordinary strict `--tier1 -c` includes the native allocator. `test-ssa-source --lifetimes` on inputs without `main` exercises both promotion paths and verification without native program execution, separating promotion from allocator memory. Large compile-only inputs must not be described as execution tested.

## Separate remaining allocation

Issue 1384 remains open. On the baseline, `tier1_cfg.c` still builds four liveness matrices through `dataflow_create(blocks, dense_count, edges)` and a fifth `passed` matrix. Their size is blocks times the number of cross-block values, rounded to vector rows. A successful promotion memory fix does not by itself prove linear whole-process memory through this allocator.

## Candidate revision and host scope

The first candidate was local implementation commit `34e696ebd6667f285d720a72a4c8e1d733c92b96`, before a later pointer/count caching change. It is reproducible by checking out the published final revision below and applying `git apply -R final-cache-only.patch`; all five implementation files must then match `candidate-source-sha256.txt`. `candidate-34e696ebd-binary-sha256.txt` identifies its executable. The first candidate's measurements are attributed to that snapshot, with separate `final-*` logs and hashes for the published source.

Final implementation: [PR 2666](https://github.com/buster14a/buster/pull/2666), commit [`0e5fbf7651d51126a415228fc61ba11b31fe6883`](https://github.com/buster14a/buster/commit/0e5fbf7651d51126a415228fc61ba11b31fe6883), source tree `2a80adeaf85163fc66f776e494dd359a2cdf5a08`. `final-cache-only.patch` applies the additional pointer/count caching changes to the measured first candidate; `final-source-sha256.txt` records the files built for final revalidation. The final `ssa_bounded.c` hash is `be1949f4a1e3ea9a72e8405579f7a41a7c84b145e423a4e8ac4a823d1a1de638`.

All full compiler binaries in this record use `BUSTER_HOST_ARCH=x86-64`. Their requested vector route selects the scalar host fallback. Actual vector-kernel correctness was checked separately by the parent session's native standalone SSA tests and must not be inferred from these scalar-host RSS results.

## Promotion and verifier memory

Command: `ssa-resource run 2300000 COMPILER test-ssa-source --lifetimes loops-N.c`.

Every completed case checks both requested promotion routes and their independent verifier. None executes a program: these large inputs have no `main`, and the source test prints `run=none`.

| Scoped loops | Baseline peak KiB | Published final peak KiB | Final result |
| ---: | ---: | ---: | --- |
| 1,000 | 114,364 | 21,900 | Success |
| 2,000 | 409,064 | 30,536 | Success |
| 4,000 | 1,579,100 | 47,628 | Success |
| 8,000 | Not run | 80,576 | Success |
| 16,000 | Not run | 147,600 | Success |

Candidate increments follow input size closely. At 4,000 loops, the source-validation process uses about 33 times less peak RSS. Its output retains the same 8,000 phis in each requested route. This is a process measurement for frontend preparation plus promotion and verification; it is not an instrumented peak of one constructor alone.

## Native strict Tier 1 memory: first candidate

Command: `ssa-resource run 2300000 COMPILER -c --tier1 -o output.o INPUT.c`.

| Input | Baseline peak KiB | First candidate peak KiB | First candidate result |
| --- | ---: | ---: | --- |
| Loops 1,000 | 63,864 | 35,632 | Success |
| Loops 2,000 | 187,904 | 76,724 | Success |
| Loops 4,000 | 655,696 | 215,012 | Success |
| Loops 8,000 | RSS guard stopped | 708,200 | Success |
| Loops 16,000 | Not run | RSS guard stopped | Incomplete |
| MAX 1,000 | 181,624 | 34,808 | Success |
| MAX 2,000 | 643,128 | 59,432 | Success |
| MAX 4,000 | RSS guard stopped | 121,896 | Success |
| Nested MAX 200, depth 8 | RSS guard stopped | 550,116 | Success |
| Nested MAX 200, depth 10 | RSS guard stopped | 2,134,552 | Success |

The native loop series still grows quadratically and the 16,000-loop candidate reaches the guard. The SSA isolation above removes the verifier as the cause of this remaining growth; the unchanged allocator matrices described under issue 1384 remain. These results do **not** satisfy a literal claim of linear whole-process RSS through native allocation. Issue 1353 should not be closed on that criterion using this record alone.

The candidate's native objects are byte-identical to the baseline's for every comparable completed pair: loops 1,000/2,000/4,000 and MAX 1,000/2,000.

## Published final revalidation

The final source rebuilt successfully with the same Release flags. `test-ssa` reports 7,804 checks and zero failures; `test-ssa-ir` reports 3,854 checks and zero failures in this scalar-host build. Its five source-only loop cases are the main memory table above.

| Final native compile | Peak KiB | Result |
| --- | ---: | --- |
| Loops 8,000 | 708,328 | Success |
| MAX 4,000 | 122,412 | Success |
| Nested MAX 200, depth 10 | 2,135,120 | Success |

Each of these final objects is byte-identical to the first candidate's. The independent native-host sanitizer, generated-source, CFG and SQLite results, and the unchanged pipeline subprocess-fixture failures, are recorded by the parent session in `VALIDATION.md` and its accompanying logs.

## Execution checks

The baseline, first candidate and published final source all pass:

```sh
COMPILER test-ssa-source --typed --lifetimes --tier1 loops-exec.c max-exec.c nested-exec.c
```

All three programs agree across the typed interpreter, all-memory IR, each promoted IR form, and native strict Tier 1 with default and `--scalar` selection. Each native selection compiles and executes all six emitted functions; the suite reports three native programs passed and no fallback. These bounded cases, rather than the large compile-only cases, provide execution evidence.
