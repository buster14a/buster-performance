# Memory value numbering #2826: correctness evidence

Recorded on 2026-11-26 for [buster issue #2826](https://github.com/buster14a/buster/issues/2826) and [PR #3622](https://github.com/buster14a/buster/pull/3622).
This directory preserves correctness checks for the clear-analysis and rollback rewrite. **It contains no timing evidence and makes no speedup claim.** The 9700X/benchpress was neither accessed nor queued. Memory value numbering remains opt-in; the issue's speedtest1/Lua runtime and default-policy acceptance is still outstanding.

## Source and binary identities

| Role | Revision | Tree |
| --- | --- | --- |
| Baseline main | [`8e4d32879e17b7d9548cad54257a2f8461328366`](https://github.com/buster14a/buster/commit/8e4d32879e17b7d9548cad54257a2f8461328366) | `8bf0a22e6067a7698ca6257d3e6cbe40f49b108a` |
| PR head | [`e5cff9f6490fb0763fdf9f6f84d8fcd6c8daa54e`](https://github.com/buster14a/buster/commit/e5cff9f6490fb0763fdf9f6f84d8fcd6c8daa54e) | `f580b2f93402e96ff94f567c006463842d0ea7b4` |
| Patched artifact's merge revision | [`fd74b08c706c470673124f4526dbd9729f2dbf54`](https://github.com/buster14a/buster/commit/fd74b08c706c470673124f4526dbd9729f2dbf54) | `f580b2f93402e96ff94f567c006463842d0ea7b4` |

The PR head and artifact merge have exactly the same source tree. The local source harness was tested against that same tree before the final commit identity was recorded; its source files are unchanged.

The baseline production artifact came from [Actions run 45779319802](https://github.com/buster14a/buster/actions/runs/45779319802), and the patched production artifact from [run 45786727439](https://github.com/buster14a/buster/actions/runs/45786727439). Both identify the repository as `1421805693`, their row as `vector none O3`, and their toolchain identity as `eda0bc02300979a219273d969c9830eb0090c72d1fa357b24bc308ade5050259`.

The original product summaries are retained in `identity/`; `compiler-sha256.txt` records the verified executable hashes. The executables themselves are not included. The pinned compiler is Clang 23.1.4, LLVM revision `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`.

## What the checks establish

The patch adds 594 checks without changing the old random stream, frozen memory digest inputs, or digest constants:

- 64 generated programs vary the dominator-arm length (1, 2, 17, or 65 blocks), chain/diamond topology, and writes to general memory or private slots: stores, calls, fences, lifetime markers, and stores to both kinds of memory.
- `memory-scope-nested.ir` checks nested subtree rollback, overlapping-family stores, calls, lifetime markers, epochs, restoration of the outer parent's values, and an `undef` store. Exactly 13 loads forward.
- `memory-scope-irreducible.ir` has two entries to a bounded cycle. General-memory dirtiness must propagate C → B → A over successive sweeps, while private-slot values remain available. Exactly 5 loads forward.
- Every case runs with memory VN alone and with DCE. Checks compare exact forwarding counts and independently interpreted returns, statuses, and effects.

The standalone scope dispatcher adds one arena-setup check, so it reports 595 checks. Its source and fixtures are supplied by the PR checkout. `ir_harness.c` includes the actual production modules and existing test code; it contains no alternate memory optimizer.

| Retained log | Result |
| --- | --- |
| `logs/ordinary-optimize.log` | 338,528 checks, 0 failures |
| `logs/ordinary-parse.log` | 12,226 checks, 52 functions, 0 failures |
| `logs/sanitized-optimize.log` | 338,528 checks, 0 failures |
| `logs/sanitized-parse.log` | 12,226 checks, 52 functions, 0 failures |
| `logs/baseline-scopes.log` | Old optimizer source with the new tests: 595 checks, 0 failures |
| `logs/production-optimize.log` | Patched production artifact: 338,528 checks, 0 failures |

Ordinary and sanitizer harness builds completed with no diagnostics. The ordinary binary was first built before the optional seed/scope command dispatch was added; the default optimizer and parser commands in its retained logs behave identically with the final harness. The sanitizer and baseline-source builds used the final dispatch shown here.

An initial leak-enabled run terminated with LeakSanitizer's fatal diagnostic stating that it does not work under ptrace in this sandbox. That failed log was overwritten before this record was assembled and is not retained. The successful sanitizer runs disabled **only leak detection** with `ASAN_OPTIONS=detect_leaks=0`; address, undefined-behavior, and bounds instrumentation stayed enabled. No leak-checking result is claimed.

## Hosted CI and corpus comparisons

The patched [hosted CI run](https://github.com/buster14a/buster/actions/runs/45786727439) completed successfully. The production optimizer test reports 338,528 checks against 337,934 on the baseline; all 594 added checks pass, with the existing frozen digests unchanged.

Complete `test-ir-source --passes` output is byte-identical between the baseline and patched production compilers on the following frozen inputs. Every pass row, including `memory` and `tier1-memory`, agrees; there are no failures, refusals, or unprepared functions.

| Corpus | Functions | Memory effects | Tier 1 memory effects |
| --- | ---: | ---: | ---: |
| c-testsuite, 220 files | 430 | 100 | 105 |
| SQLite | 2,602 | 3,662 | 3,737 |
| musl | 2,775 | 3,325 | 3,326 |
| Total | 5,807 | 7,087 | 7,168 |

The `--tier1 --tier1-passes=+memory` SQLite object is also byte-identical: 2,324,048 bytes, SHA-256 `0baa358ed1f6ff3abb26dfce7be2a4e96164587ac9272b0bd1605e185f77e2af`. The entire `--tier1-report` agrees, including 3,252 forwarded loads, spills, and edge moves. All 1,349 functions requesting Tier 1 use it, with no fallback.

The [corpus and campaign record](corpus-campaigns/README.md) retains the commands, corpus identities, complete pass reports, object hashes and allocation reports, and external-generator receipts. Every campaign uses seeds 2826–2835 and compares Buster Tier 0, Tier 1 with memory VN, Clang `-O0`, and Clang `-O2`.

| Generator campaign | Passed | Failed / no verdict |
| --- | ---: | ---: |
| YARPGen, original defaults | 8 | 2 link-range failures |
| YARPGen, maximum 3 array dimensions | 10 | 0 |
| Csmith, original defaults | 8 | 2 execution timeouts in all four modes |
| Csmith, uniform depth/function/block-size bounds | 9 | 1 execution timeout in all four modes |

The nine passing bounded Csmith cases compiled 228 Tier 1 functions with 158 forwarded loads and zero fallbacks or errors. The bounded YARPGen cases compiled 50 Tier 1 functions with zero fallbacks, but forwarded zero loads; they establish enabled-pass compatibility for those inputs. Original failures and all timeouts are retained and are not counted as passes. No completed comparison produced an output mismatch. Csmith's source-size bounds do not guarantee completion within the 60-second execution limit.

## Rebuild and replay the focused harness

Use an AVX-512-capable Linux/x86-64 host satisfying `host_isa.h`. Prepare a Buster checkout at the PR head and a separate baseline checkout at the revision above. Run the following Bash commands from the PR checkout's root. Set the first two paths to your local checkouts; the replay output directory is disposable.

```bash
set -euo pipefail
BUSTER_2826_EVIDENCE=/absolute/path/to/this/evidence/directory
BUSTER_2826_BASE=/absolute/path/to/baseline/buster
BUSTER_2826_REPLAY="$PWD/build/2826-correctness-replay"
mkdir -p "$BUSTER_2826_REPLAY"
test "$(git rev-parse HEAD^{tree})" = f580b2f93402e96ff94f567c006463842d0ea7b4
test "$(git -C "$BUSTER_2826_BASE" rev-parse HEAD)" = 8e4d32879e17b7d9548cad54257a2f8461328366
BUSTER_2826_STAGE="$(bash tools/ci/session-toolchain.sh stage)"
BUSTER_2826_CLANG="$(PATH="$BUSTER_2826_STAGE:$PATH" command -v clang)"
"$BUSTER_2826_CLANG" --version
BUSTER_2826_FLAGS=(
    -march=x86-64-v4 -maes -mgfni -mvaes
    -mavx512vbmi -mavx512vbmi2 -mavx512vpopcntdq
    -mavx512bitalg -mavx512vnni
    -fwrapv -funsigned-char -fno-strict-aliasing
    -Wall -Werror -Wno-unused-function -Wno-unused-variable
    -Wno-unused-const-variable -fno-stack-protector
    -Isrc/buster/compiler -Isrc -ffunction-sections -fdata-sections
)

"$BUSTER_2826_CLANG" -O0 "${BUSTER_2826_FLAGS[@]}" \
    "$BUSTER_2826_EVIDENCE/ir_harness.c" \
    -Wl,--gc-sections -pthread -lm \
    -o "$BUSTER_2826_REPLAY/ir-harness" \
    > "$BUSTER_2826_REPLAY/ordinary-build.log" 2>&1
"$BUSTER_2826_REPLAY/ir-harness" test-ir-optimize \
    > "$BUSTER_2826_REPLAY/ordinary-optimize.log" 2>&1
"$BUSTER_2826_REPLAY/ir-harness" test-ir-parse \
    > "$BUSTER_2826_REPLAY/ordinary-parse.log" 2>&1
```

Run the sanitizer build with the same include paths, ISA flags, and aliasing semantics:

```bash
"$BUSTER_2826_CLANG" -O1 -g1 "${BUSTER_2826_FLAGS[@]}" \
    -fsanitize=address,undefined,bounds -fno-sanitize-recover=all \
    -fno-omit-frame-pointer "$BUSTER_2826_EVIDENCE/ir_harness.c" \
    -Wl,--gc-sections -pthread -lm \
    -o "$BUSTER_2826_REPLAY/ir-harness-asan" \
    > "$BUSTER_2826_REPLAY/sanitized-build.log" 2>&1
ASAN_OPTIONS=detect_leaks=0 UBSAN_OPTIONS=halt_on_error=1 \
    "$BUSTER_2826_REPLAY/ir-harness-asan" test-ir-optimize \
    > "$BUSTER_2826_REPLAY/sanitized-optimize.log" 2>&1
ASAN_OPTIONS=detect_leaks=0 UBSAN_OPTIONS=halt_on_error=1 \
    "$BUSTER_2826_REPLAY/ir-harness-asan" test-ir-parse \
    > "$BUSTER_2826_REPLAY/sanitized-parse.log" 2>&1
```

The following build includes the baseline `ir_optimize.c` and its baseline memory optimizer, while keeping the new tests and unchanged support modules from the PR checkout:

```bash
"$BUSTER_2826_CLANG" -O0 "${BUSTER_2826_FLAGS[@]}" \
    "-DBUSTER_VALIDATION_OPTIMIZER=\"$BUSTER_2826_BASE/src/buster/compiler/ir_optimize.c\"" \
    "$BUSTER_2826_EVIDENCE/ir_harness.c" \
    -Wl,--gc-sections -pthread -lm \
    -o "$BUSTER_2826_REPLAY/ir-harness-baseline" \
    > "$BUSTER_2826_REPLAY/baseline-build.log" 2>&1
"$BUSTER_2826_REPLAY/ir-harness-baseline" test-memory-scopes \
    > "$BUSTER_2826_REPLAY/baseline-scopes.log" 2>&1
```

For the production check, extract the patched product from its recorded CI run, verify `identity/summary` and the executable hash above, then run from the PR checkout:

```bash
BUSTER_2826_PRODUCT=/absolute/path/to/extracted/patched-product
"$BUSTER_2826_PRODUCT/bin/compiler" test-ir-optimize \
    > "$BUSTER_2826_REPLAY/production-optimize.log" 2>&1
```

## Deliberate mutation checks

Each patch changes only the named behavior in an isolated copy of the memory optimizer. All five compiled successfully and were rejected with exit status 1 by the **new scope checks alone**. No tracked source was edited for these runs.

| Patch | Deliberate defect | Checks | Failures |
| --- | --- | ---: | ---: |
| `class_counts.patch` | Do not undo class-counter increments | 595 | 58 |
| `family_counts.patch` | Do not undo family-counter increments | 595 | 26 |
| `no_log.patch` | Disable journaling for every descendant frame | 527 | 58 |
| `fixed_point.patch` | Stop clear analysis after its first sweep | 595 | 4 |
| `initial_barriers.patch` | Ignore dirty blocks in the initial barrier summaries | 595 | 4 |

The no-log mutant fails verification in some cases, so their later comparisons are skipped and its check count is lower. The two clear-analysis mutants specifically make the irreducible fixture forward 6 and 7 loads instead of 5, respectively, and change interpreted returns or effects. The test therefore detects incorrect program behavior as well as wrong optimization counts.

The patches use paths relative to the temporary directory containing the two optimizer files. Replay serially with the variables and compiler flags above:

```bash
for BUSTER_2826_MUTANT in class_counts family_counts no_log fixed_point initial_barriers; do
    BUSTER_2826_MUTDIR="$BUSTER_2826_REPLAY/$BUSTER_2826_MUTANT"
    mkdir -p "$BUSTER_2826_MUTDIR"
    cp src/buster/compiler/ir_optimize.c src/buster/compiler/ir_optimize_memory.c \
        "$BUSTER_2826_MUTDIR/"
    patch --batch --directory="$BUSTER_2826_MUTDIR" -p1 \
        < "$BUSTER_2826_EVIDENCE/mutations/$BUSTER_2826_MUTANT.patch"
    "$BUSTER_2826_CLANG" -O0 "${BUSTER_2826_FLAGS[@]}" \
        "-DBUSTER_VALIDATION_OPTIMIZER=\"$BUSTER_2826_MUTDIR/ir_optimize.c\"" \
        "$BUSTER_2826_EVIDENCE/ir_harness.c" \
        -Wl,--gc-sections -pthread -lm -o "$BUSTER_2826_MUTDIR/ir-harness" \
        > "$BUSTER_2826_MUTDIR/build.log" 2>&1
    if "$BUSTER_2826_MUTDIR/ir-harness" test-memory-scopes \
        > "$BUSTER_2826_MUTDIR/scopes.log" 2>&1; then
        printf 'ERROR: mutant %s survived\n' "$BUSTER_2826_MUTANT" >&2
        exit 1
    else
        BUSTER_2826_STATUS=$?
        test "$BUSTER_2826_STATUS" -eq 1
    fi
    tail -1 "$BUSTER_2826_MUTDIR/scopes.log"
done
```

## Assembly context and limits

`assembly-summary.txt` retains only symbol sizes, prologue stack adjustments, and the commands needed to reproduce those observations from the identified binaries. Each emitted memory-pass copy grows from 25,762 to 27,482 bytes; the first copy's stack subtraction changes from 424 to 392 bytes, with the same six saved-register pushes. These observations do not establish a runtime improvement.

No binaries, full disassemblies, generated corpora, new shell/Python tools, or hardware performance measurements are included. A future performance decision still needs the issue's approved-host and placement-noise controls.

---
Agent session: 6b07ee68-c48c-83ed-b6be-667326b63061 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6 Astra Pro
