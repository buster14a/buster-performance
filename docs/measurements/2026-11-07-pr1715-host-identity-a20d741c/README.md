# PR #1715: whole-object host-path identity on the 9700X

Focused validation of [buster#1715](https://github.com/buster14a/buster/pull/1715)
at exact compiler commit
[`a20d741c37f176655aa120cafb085ae69421058a`](https://github.com/buster14a/buster/commit/a20d741c37f176655aa120cafb085ae69421058a),
performed on 2026-11-07 UTC. The default and explicit scalar host paths produced
byte-identical complete objects for the PR's reproducibility fixture, with
rematerialization disabled and enabled. All four linked programs matched the
independent Clang `-O0` oracle (`15043711cabfbad`).

This independently reproduces `check_test_driver_tier1_reproducible` using its
exact source and compilation options. It is **not** a run of the full registered
`test-checker-driver` group, validation of later commits or main, sanitizer
acceptance, required ready-state CI, or performance acceptance. No runtime or
compiler-throughput speedup is claimed. Incidental build durations in the build
receipt are not performance comparisons.

## Host, build and path evidence

- Host: `benchpress`, AMD Ryzen 7 9700X, Linux `6.18.50-2-lts`.
- Compiler/oracle: system Clang **23.1.1**, not the repository's hosted-CI pinned
  Clang 23.1.4. This fixture checks execution and object identity, not complete
  diagnostic equivalence. GDB: 18.1.
- Buster: Release, `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`, eight build jobs.
  `compile_commands.json` confirmed `-march=znver5`; the header probe printed
  `host-vector=1`.
- Each build, validation run and debugger run separately acquired the shared
  `~/buster-fast-bench/exclusive.sh` lock. The validation is not a timing run and
  was not pinned to a single CPU. There was one complete four-case validation
  and one additional default-path debugger compile.

The header probe alone does not demonstrate which path the tested compiler ran.
The separate debugger run did: [the retained trace](receipts/trace.log) stops in
`tier1_burs_classify_vector`, called from `tier1_select_plan_checked`,
`check_tier1_compile` and `check_program_emit_tier1`. It then resumes to normal
exit. No compiler source was instrumented or modified for this check.

## Results and identities

Each case reported 12 requested, admitted and compiled Tier 1 functions, zero
fallbacks, zero unsupported functions and zero internal/resource failures. Both
whole-object comparisons passed. All four objects have SHA-256:

```text
e505c0da30aaee531dfd3b5902c14b118b97fbe4ce3a00b12dffa815c1941280
```

The [identity receipt](receipts/identity.log) contains the four reports, execution
checks, object hashes and final `identity-validation=PASS`. The individual
compile reports and zero exit-status receipts are retained beside it.
The [source manifest](source-files.sha256) covers all 1,317 regular files in the
deterministic `git archive` snapshot. After the build, all 1,317 files on the
host matched it; [the integrity receipt](receipts/source-check-summary.log)
records status 0. The source tree has no tracked symlinks.

[identities.txt](identities.txt) records the source tree/archive, tested binary,
oracle and fixture identities. Binaries and object files are deliberately
omitted. [SHA256SUMS](SHA256SUMS) verifies every other file in this evidence
directory. [PROVENANCE.md](PROVENANCE.md) records source notices and the limited
receipt sanitization.

## Reproduction

Use an approved 9700X checkout and the same toolchain when comparing these
recorded identities. The reproduction helpers were executed as archived; their
paths expect a working directory containing `source/` and the four helper files.
Choose a fresh task-owned directory on `benchpress`, outside either Git checkout:

```sh
# BUSTER_CHECKOUT is a clone containing the exact source commit.
# RECORD is this evidence directory in a separate buster-performance checkout.
# RUN is a fresh task-owned working directory on benchpress.
mkdir -p "$RUN/source"
git -C "$BUSTER_CHECKOUT" archive a20d741c37f176655aa120cafb085ae69421058a |
    tar -xf - -C "$RUN/source"
cp "$RECORD"/helpers/* "$RUN/"
cp "$RECORD/source-files.sha256" "$RUN/"
cd "$RUN/source"
EXCLUSIVE_OWNER=pr1715-identity-review \
EXCLUSIVE_TITLE='PR 1715 identity reproduction' \
EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1715 \
    ~/buster-fast-bench/exclusive.sh \
    env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --jobs 8
sha256sum -c ../source-files.sha256
cd "$RUN"
EXCLUSIVE_OWNER=pr1715-identity-review \
EXCLUSIVE_TITLE='PR 1715 identity reproduction' \
EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1715 \
    ~/buster-fast-bench/exclusive.sh bash identity-run.sh
EXCLUSIVE_OWNER=pr1715-identity-review \
EXCLUSIVE_TITLE='PR 1715 vector-path trace' \
EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1715 \
    ~/buster-fast-bench/exclusive.sh gdb -batch -x identity-trace.gdb --args \
    source/build/compiler --tier1 --tier1-report --tier1-refusals --verify \
    -march=x86-64 -c -o identity-trace.o tier1-reproducible.c
```

If `cores` is available on that host, also follow the source checkout's queue
rules. It was absent from the validation host's `PATH`. Hold the machine lock
per run as above. The debugger command intentionally stops once, records its
stack and resumes; verify the log contains the breakpoint hit and normal exit.
The helper's header probe reports the configured host capability, while that
trace supplies independent evidence of actual vector-selector execution.

---
Agent session: 01a1b81e-6ae2-7022-84e9-95739850f990, task
`/root/identity_validation` (OpenAI Codex session ID; no private session URL is
exposed).
Model: OpenAI / GPT-6 (exact runtime variant not exposed).
