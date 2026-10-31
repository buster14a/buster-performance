# Checker column locals: correctness and static code generation

2026-10-31. Supports [Buster #889](https://github.com/buster14a/buster/issues/889) and [implementation PR #953](https://github.com/buster14a/buster/pull/953). **This is not 9700X performance acceptance.**

## Identities and limitations

- Baseline: `buster14a/buster` `c1c5ed0267d6cfb9f5caca966f9a902090738d39`.
- Clean candidate: `6836cf34e0d8ee5e453e212ea52f544d608a0533`.
- Development-job source commit: `f5f555840d9f9dd562fdad13144073ce66de19e2`. Its `src` and `docs` contents are identical to the clean candidate; the clean commit removes the branch-only transport files and transport history.
- [Validation run 41194624179](https://github.com/buster14a/buster/actions/runs/41194624179), job `124518191894`, completed successfully at 2026-10-31 11:02:33 UTC. Its event head `8e0df4e7da1bafab5391a71ddf8466199bacd149` is the temporary workflow commit, **not** the compiled source revision. The job SHA-256-verifies and applies the patch before compiling.
- GitHub-hosted `ubuntu-26.04`; the runtime build reports **`host execution: scalar (native)`**. No CPU model was captured. This job therefore does not qualify AVX-512 runtime behavior.
- Clang 23.1.4, LLVM commit `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`, target `x86_64-unknown-linux-gnu`.
- Both code-generation captures explicitly target `znver5`, at `-O3`, with `-fno-strict-aliasing` retained. They were compiled on the hosted runner, not executed as Zen 5 binaries there.
- No 9700X timing, IBS, counter or code-placement result was collected in this record. Native/vector correctness and the issue's hardware acceptance remain outstanding.

The full raw artifact is `issue-889-validation`, artifact ID `13040371352`, linked from the run. Its original retention deadline is **2026-11-07 11:02:26 UTC**; this report preserves selected results/excerpts and their identities, not the full 101 MiB uncompressed artifact. The artifact contains both complete assembly files, compile flags, toolchain, source patch and full test logs. No hosted wall-clock timing is treated as a compiler performance measurement.

## Commands and results

The job obtains Clang through the pinned source's `bash tools/ci/setup-hosted.sh`. For each source revision it runs the following, in that revision's checkout (these arrays preserve the repository's NUL-delimited flags):

```bash
mapfile -d '' -t flags < <(BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags)
clang "${flags[@]}" -S -fverbose-asm src/buster/compiler/main_unit_checker.c -o candidate.s
```

Use `base.s` for the baseline output. The recorded flags are:

```text
-march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -DBUSTER_CLANG_DEFAULT_TARGET=\"x86_64-unknown-linux-gnu\" -O3
```

The candidate runtime build uses `BUSTER_HOST_ARCH=native BUSTER_DEBUG_INFO=0`, the repository's external Clang pragma oracle (`tools/build-preprocessor-pragma-oracle.sh`, exported as `BUSTER_PPF_PRAGMA_ORACLE`), and `./build.sh`.

```text
build.sh: host execution: scalar (native)
build.sh: stage 1 linker: /home/runner/work/_temp/buster-test-tools/wild
build.sh: 41 sources compiled in 119.1 s; the longest: main_unit_checker.c 45.0 s, main_unit_backend.c 39.0 s, main_unit_frontend.c 30.6 s
```

The following candidate commands all exit successfully:

```bash
./build/compiler test-checker --seed 133
./build/compiler test-checker-driver --executable ./build/compiler
./build/compiler test-c-testsuite --cross-check --clang clang --jobs 4 --subset tests/c-testsuite/subset.txt build/c-testsuite
```

c-testsuite is pinned to `5c7275656d751de0e68b2d340a95b5681858ed07`.

```text
test-checker: 710595 checks, 0 failures
checker-driver: 43180 checks, 0 failures
test-c-testsuite: 220 tests: 220 passed, 0 unsupported, 0 failed, 0 not run; the subset's 220: 220 passed
```

The logs explicitly skip native execution of unsupported vector/AVX-512/half-precision cases while still checking compilation/linking. The fortify system-header case reports its pre-2.40 glibc requirement. The new empty-graph scheduler selections also run through the hosted build's scalar fallback: they are not evidence of executing the vector schedulers. This focused job does not replace the PR's complete hosted/native correctness inventory or baseline/candidate corpus byte/diagnostic comparisons.

## Static code-generation observations

The source transformation removes descriptor reloads in the intended loops, but extends live ranges. Both effects must be measured together.

In `check_control_children`, for an **ordinary interior token with an in-body parent and an existing sibling** (neither a label nor a case), the baseline executes eight writer-column-base loads: `last`, `previous`, `next`, a reload of `next`, a reload of `last`, `source_labels`, `stops`, `repeats`. The candidate uses register-held bases for this route, plus three stack reloads for the loop bounds/repeats. This is a static selected-path observation, not a workload-weighted count. The no-sibling and label/case routes differ.

Representative baseline sibling blocks, verbatim from `base.s`:

```asm
.LBB636_3:                              #   in Loop: Header=BB636_2 Depth=1
	movq	24(%r15), %r9
	movq	40(%r15), %r10
	movl	(%r9,%r8,4), %r9d
	movl	%r9d, (%r10,%rdi,4)
	movq	32(%r15), %r10
	movl	$-1, (%r10,%rdi,4)
	cmpq	%rax, %r9
	je	.LBB636_6
# %bb.4:                                #   in Loop: Header=BB636_2 Depth=1
	movq	32(%r15), %r10
	movl	%edi, (%r10,%r9,4)
	jmp	.LBB636_7
.LBB636_6:                              #   in Loop: Header=BB636_2 Depth=1
	movq	16(%r15), %r9
	movl	%edi, (%r9,%r8,4)
.LBB636_7:                              #   in Loop: Header=BB636_2 Depth=1
	movq	24(%r15), %r9
	movl	%edi, (%r9,%r8,4)
```

Corresponding candidate blocks, verbatim from `candidate.s`:

```asm
.LBB636_3:                              #   in Loop: Header=BB636_2 Depth=1
	movl	(%rbp,%r8,4), %r9d
	movl	$4294967295, %r10d              # imm = 0xFFFFFFFF
	movl	%r9d, (%rax,%rdi,4)
	movl	$-1, (%r12,%rdi,4)
	cmpq	%r10, %r9
	je	.LBB636_6
# %bb.4:                                #   in Loop: Header=BB636_2 Depth=1
	movl	%edi, (%r12,%r9,4)
	jmp	.LBB636_7
.LBB636_6:                              #   in Loop: Header=BB636_2 Depth=1
	movq	72(%rsp), %r9                   # 8-byte Reload
	movl	%edi, (%r9,%r8,4)
.LBB636_7:                              #   in Loop: Header=BB636_2 Depth=1
	movl	%edi, (%rbp,%r8,4)
```

The expression walk's child-list loop likewise no longer reloads its `next_child`, `specifier_finishes`, `first_value`, `last_value`, `value_next` and `value_counts` bases through the reader for each applicable child. It acquires these bases before the loop. However, the candidate spills/reloads the current token and last-value state in places where the baseline kept them in registers. Do not translate removed descriptor loads directly into fewer total loads or elapsed-time savings.

### Register-pressure screen

Counts below are **static assembly-text counts over whole emitted functions**, not executed instructions or cycles. Instruction lines match `^\t[a-z][a-z0-9]*\b`; directives/labels are excluded. Reload annotations count both ordinary and folded `N-byte Reload` comments. Static instruction/reload counts include mutually exclusive and cold paths. They are useful warnings, not a ranking of runtime speed.

| Function | Instruction lines base -> candidate | Annotated reload sites base -> candidate | Prologue local reservation, bytes base -> candidate |
| --- | ---: | ---: | ---: |
| `check_input_expressions` | 6314 -> 6288 | 499 -> 562 | 392 -> 568 |
| `check_input_resolve_range` | 6181 -> 6300 | 380 -> 526 | 1096 -> 1288 |
| `check_control_children` | 128 -> 155 | 1 -> 12 | 8 -> 88 |
| `check_program` | 10363 -> 10574 | 1086 -> 1078 | 1176 -> 1208 |
| `check_graph_run` | 7915 -> 8056 | 669 -> 770 | 10456 -> 10472 |

The reservation column excludes saved-register pushes; the baseline control walk reserves its eight local bytes with a dummy `pushq`. Region helpers are inlined and do not have standalone emitted functions in these captures.

**Decision:** retain the implementation as an unqualified draft candidate. The hot-loop reload mechanism changed as intended, but increased live ranges and spills are a real risk. The data here neither establish nor disprove an end-to-end speedup. Do not close #889 or claim that seven percent of total operations/time was recovered from this evidence.

## Next acceptance work

After the clean candidate's complete hosted correctness prerequisites pass, use the shared 9700X lock and the same pinned toolchain/input identities to compare baseline/candidate: native scalar/vector object and diagnostic identity on frozen corpora; `measure-compile` stage attribution; interleaved `time-runs` whole SQLite `-c` over multiple placements/fresh copies; and IBS attribution that distinguishes eliminated descriptor reloads from new stack spills. If the extra live ranges lose on those runs, narrow the snapshot lifetimes/column sets rather than weakening aliasing assumptions. None of that hardware work is claimed by this record.

## Digests

SHA-256 of the original validation artifact members:

```text
617b0b94fd681fc043af1ffa1f886d21c48ca0e8d98667112db05b4075f31e4b  base.s
558a602efd76dd4544bdc9a4379bc82b89c4d58bd04503a1e0dc401b7c40882d  candidate.s
f61e7da904546c45b7b3d46cbb18ba86a949d39d95ed792737da2e8b429d7a5f  source.patch
9a8728516d1b0e8a32ccfa04406e55c0ebb4b446f17afa194a4e1172e2125da7  test-checker.log
462679f575646036c56c7709774107877a8a0a23aec16addb2ceb32f12c95719  test-checker-driver.log
404f1a9a8aea8cca17aa325e3c0f4fcfd707646ee2c15a3d1be4fa8bb8669c96  test-c-testsuite.log
```

The downloaded artifact ZIP has SHA-256 `4dd1d681cee7627aeeae985ea85eea8cb5a64b6137d9497c7da8595419beb10d`. The patch's original zero-context transport has SHA-256 `b507af075a0c136d685fa219c6d1d2f2a4875a2daabb31003d0d644d4eefe9dc`; `source.patch` above is the subsequent normal-context diff and consequently has a different hash.

## Provenance

Original report of this session's validation. Assembly excerpts are Clang 23.1.4 output for the named Buster first-party control walk; Clang and c-testsuite were external tools/inputs, with no implementation imported. This report and the underlying first-party source retain the project default Apache-2.0 WITH LLVM-exception terms. No human DCO sign-off was fabricated; `BUSTER_DCO_SIGN_OFF=davidgmbb` was not set in this session.
