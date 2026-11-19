# Driver dependency formatting on hosted AVX-512

On Buster `6427879e1143026a12fb0388a20bdea1fe4b2bc5`, the normal compiler entered `dependency_prepare`, queried `dependency_rule` for the size, then called its public write path. The trace shows a sizing pass, a second sizing pass inside that write, and an output pass. On `4b0d802d613c3d404dfc338c03957ebd4abdfab9` the driver issues the same validating query, allocates the measured size and emits the immutable rule into the private buffer. The public serializer still checks capacity before writing to a caller's buffer. [Buster issue #3034](https://github.com/buster14a/buster/issues/3034)

## Compiler work at the normal CLI entry point

| Input and options | Complete passes, base → head | Escaped-name input bytes visited, base → head | Emitted Make bytes on each revision |
| --- | ---: | ---: | ---: |
| `tools/performance/main.c`, `-M -MP` | 3 → 2 | 27,240 → 18,160 | 9,371 |
| `examples/assembler/compiler-corpus.c`, `-c -MD -MP` | 3 → 2 | 135 → 90 | 48 |
| 512 generated headers, `-M -MP` | 3 → 2 | 43,038 → 28,692 | 15,885 |
| Same generated translation unit, `-c -MMD -MP` | 3 → 2 | 43,038 → 28,692 | 15,885 |

The reported counts come from separate instrumented builds on the same hosted VM. The real translation unit supplied 97 file records including the source. The stress test supplied 513. Both stress invocations emitted SHA-256 `153aa8f07ee02d30d68d4b328bbf9149bcd4def009fa2a622585d3296031a818`. Every measured command exited with status 0. Compiler work here means bytes examined by the Make escaping classifier and complete rule traversals. Clean builds also compared the emitted object bytes. The runs collected no compiler throughput or instruction timing.

## Correctness and environment

The clean baseline and candidate ran consecutively on a GitHub-hosted Ubuntu 26.04 VM reporting AMD EPYC 9V74. Buster's vector probe passed. Both used staged Clang 23.1.4 (`7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`), CMake 4.4.3, Ninja 1.13.2 and the same Clang resource directory. Both were Release vector builds with `BUSTER_SANITIZER=none`, `BUSTER_SANITIZER_OPTIMIZATION=3`, `BUSTER_DEBUG_INFO=0`, `BUSTER_LINKER=auto`. The printed compile flags matched byte for byte with SHA-256 `d5a902986d56adaa6813f7f4a369c9458a8e6b274188dfbcbe0402ba30483aff`. [Same-run base/head verification](https://github.com/buster14a/buster-performance/actions/runs/44604331494/job/135843850483)

- Per revision, 28 short rules matched Clang's exact bytes and exit status across `-M`, `-MM`, `-MD`, `-MMD`, `-MP`, repeated `-MT`/`-MQ`, `-MF -`, standard input, user/system headers and escaped filenames and targets. Four rejection cases returned 1, preserved the prior depfile, and produced a diagnostic. The clean revisions agreed on rule bytes, captured stdout and exit status, and every compared Buster object. A plain compile also matched the object from `-c -MD`.
- Four more cases cover each mode with `h\ #$.h` as the literal header name. On this host both Buster revisions escaped the literal backslash and Clang wrote a forward slash. Each compiler's complete expected bytes are asserted separately. Target backslashes in `-MQ` matched Clang directly.
- Both raw 512-header Buster depfiles matched the complete independently constructed byte string. The Clang long-line comparison accounted for its physical Make line continuations.
- On each revision, the unchanged `tests/driver/dependency_rule.c --oracle` passed all 27,204 checks, including short-buffer behavior. The unchanged `test-checker-driver` part 7/8 passed 68,927 checks and part 6/8 passed 14,326. The latter includes 1,006 CC compatibility checks. Both ran the compiler in process and used the Clang server. [Head driver partitions and base/head public tests](https://github.com/buster14a/buster-performance/actions/runs/44604331494/job/135843850483) · [Base driver partitions](https://github.com/buster14a/buster-performance/actions/runs/44605334582/job/135850063628)

The initial pre-change trace established the three-pass path before implementation. It used Buster's default resource directory and found 96 real file records. The table uses the later paired run with an explicitly shared Clang resource directory. The `.log` files contain the result lines from the hosted jobs, including per-pass counters. [Initial trace](https://github.com/buster14a/buster-performance/actions/runs/44601107932/job/135832435014)

## Reproduce

Use a Linux/x86-64 AVX-512 VM with the features checked by Buster's `tools/ci/vector-probe.c`. The recorded runs used GitHub-hosted Ubuntu 26.04. Run from a disposable Buster checkout with both revisions available. The scripts build into the checkout and create temporary test data. Set `harness` to the directory containing this record in a separate buster-performance checkout.

```sh
base=6427879e1143026a12fb0388a20bdea1fe4b2bc5
head=4b0d802d613c3d404dfc338c03957ebd4abdfab9
harness=/path/to/buster-performance/docs/measurements/dependency-rule-preflight-3034-2026-11-19
out=$(mktemp -d)
git checkout --detach "$base"
bash "$harness/qualify.sh" "$harness" "$out/verification" "$base" "$head"
git checkout --detach "$base"
bash "$harness/base-driver.sh" "$out/base-driver"
```

`count.patch` gives each temporary formatting sink two counters. The classifier charges the number of valid input bytes in each chunk just before it calls `dependency_special`. The second counter charges only quoted names. A trace row is printed at the end of each successful `dependency_emit` call. Length checks, output copies and the comparison used to omit the root source are outside these byte counts. A header emitted again as an `-MP` rule is counted again.

`sample.sh` invokes the normal compiler. It uses the project's performance-tools translation unit for dependency discovery, the assembler example for an ordinary object compile, and a deterministic C file that includes 512 headers. It constructs the complete expected many-header rule independently. Clang wraps long physical lines, so only that comparison removes continuations. Both Buster revisions are compared as raw files.

`verify.sh` compares short depfiles directly with Clang. The literal-backslash header has separate, fixed byte strings for Buster and Clang. The script also checks compiler exit status, preservation of an existing depfile on rejection, and the object from the same source compiled with and without dependency output.


---
Agent session: 6aff4f23-cc40-8191-8c59-82f7037f705f (OpenAI Codex session ID; no private session URL exposed)
Model: OpenAI / GPT-6 (Codex)
