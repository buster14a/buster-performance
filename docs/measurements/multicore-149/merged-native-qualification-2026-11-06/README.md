# Exact-merged native correctness qualification, 2026-11-06

This is the native correctness record for the [#149 campaign](../README.md), not a performance result. It tests merged Buster commit [`2dc50258e8b33393474b64032a5cbe9f17c63def`](https://github.com/buster14a/buster/commit/2dc50258e8b33393474b64032a5cbe9f17c63def), including #1528's explicit lane-CPU option, on the shared Ryzen 7 9700X. The corresponding main-push hosted sanitizer/fuzz run [42256447354](https://github.com/buster14a/buster/actions/runs/42256447354) was still in progress when this record was prepared. No complete campaign or speedup is claimed here.

## Result and limits

- All **126 named commands** in this exact commit's `tools/ci/correctness.tests` completed with exit 0 and a `parallel` summary of one passed, zero failed, zero skipped and zero not started. The separate source-parse smoke passed. The multicore acceptance fixture reported **64 cohorts and requested/observed teams 1–8: PASS**. The runner's section-level summary does not mean every internal optional oracle or case ran.
- The host lacks the relevant native RTM, XOP, AVX512-FP16 or AVX512-BF16 features for the indicated cases; those native executions were skipped after compile/link. The corpus comparison skipped two headers which Clang rejected when used directly. GAS CET rows were skipped in the target-forms comparison. The absent-tool and Clang 23.1.5 builtin-name skip messages are deliberate fake-tool/release self-tests, not the configured Clang. The complete retained [skip audit](native-receipts.tar.gz) contains the individual messages.
- Compiler, oracle, predefines and inventory hashes verified before and after the suite, and the compiler checkout's commit and clean status matched before and after. A final audit rechecked the official Clang tree and binary, the corpus manifests and their listed files, and the clean c-testsuite checkout at `5c7275656d751de0e68b2d340a95b5681858ed07`.
- The first **two attempts at the final audit wrapper failed with exit 127** before any audit, because the operator passed its label as the executable. Their logs are preserved as `verify-attempt1/` and `verify-attempt2/`; the corrected audit passed. These are audit-controller failures, not compiler test results.

## Identity and execution

- Compiler source: clean exact commit `2dc50258e8b33393474b64032a5cbe9f17c63def`; Release build with `BUSTER_HOST_ARCH=znver5` and `BUSTER_DEBUG_INFO=0`. Executable SHA-256: `51b54dd02986a28f294c0d5b2539e93739acb8962851127316da7953d4f8b09b`.
- Build toolchain: official Clang 23.1.4, executable SHA-256 `c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67`. The official Clang tree manifest was checked before and after. The external pragma oracle was rebuilt from this exact source and hashed with the inputs.
- Host: AMD Ryzen 7 9700X, Linux `6.18.50-2-lts`, native vector feature gate passed. Inputs were the verified frozen `preprocessor-391e729af658` corpus and the pinned c-testsuite; the Clang oracle cache ran in `check` mode. The setup records the exact configuration and external-input verification.
- The exact inventory was split at its `==` headings without modifying any section. One heading at a time was run by the compiler's `parallel --github --jobs 8 --timeout 480` under `taskset -c 0-7`, with a separate `exclusive.sh` acquisition for each heading. This serializes sections rather than reproducing CI's inter-section concurrency; it preserves each section's own commands and eight-CPU scheduling budget. Each section log includes this session's lock-owner line, command output and final runner summary. Build, oracle, input preparation, source parse and final toolchain check also had separate lock grants.
- This is local native qualification of the recorded compiler executable and stated inventory, with the internal exceptions above. It is not the PR hardware benchmark job, a sanitizer/fuzz result, an exact main-push CI result, or evidence of lane placement or speedup. The main-push hosted run must complete successfully before the final campaign.

## Evidence

[`native-receipts.tar.gz`](native-receipts.tar.gz) contains the scripts, exact split inventory, 126 section logs and status files, setup and identity checks, audit failures and successful retry, skip audit, source identities and an internal `SHA256SUMS`. After extraction, run `sha256sum -c SHA256SUMS` inside the extracted directory. The archive SHA-256 is `a4e82b437553125a5af0f3a4526fbdd495fcf5579cd1030fed4ff1db6da31ef6`.

Before packaging, the operator replaced the host-specific `/home/david/` prefix with the literal `$BENCH_HOME/` in text and replaced each shared-lock wait block with a single notice, removing unrelated sessions' holder commands, titles and links. The lock acquisition lines for this task, test outputs, statuses and checksums remain. The published files are therefore sanitized copies, not byte-identical raw host transcripts; absolute paths in the recorded manifests require substitution with the actual host home before reuse. The internal manifest hashes the sanitized package. Raw host copies remain in this task's isolated Benchpress directory.

---
Agent session: 01a1b0e0-a314-7252-9c29-d958f2e64d73 (Codex session ID; no private session URL is exposed); implementation subagent thread 01a1b0f5-7302-7403-93c1-fce19866c97a.
Model: OpenAI / GPT-6 (exact variant not exposed).
