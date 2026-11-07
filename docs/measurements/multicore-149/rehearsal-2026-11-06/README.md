# Multicore campaign rehearsal, 2026-11-06

This is **diagnostic and compiler-qualification evidence**, not a passing #149
scaling campaign. No uninstrumented 1–8-lane timing curves are claimed. The
compiler used here predates the proposed per-lane CPU-pinning interface; the
separate pinning change and a compiler containing it still need review and
qualification before the campaign.

## Identities and setup

- Compiler: Buster `d9442df0dde83b9701b6ff7487f8916641736a84`, a commit on
  `main`. The built executable's SHA-256 is
  `5801873aed7a52d9f5b598a0664fa232349813a5ca778fb690ca7279eede19ae`.
  The clean source state, toolchain, build output, frozen-input verification,
  oracle, corpus and command inventory identities are in the native archive.
- Campaign tool head before the fix: `32dbd4ce088ced111be3f1e167817d82aea6008d`.
  The preparer fix was subsequently published as `72e01d573f4709611008257217a76271643b5af4`.
- The compiler and tools were built on Benchpress, an AMD Ryzen 7 9700X, with
  the verified Clang 23.1.4 distribution and `BUSTER_HOST_ARCH=znver5`,
  `BUSTER_DEBUG_INFO=0`. The vector feature check passed. The archive's
  `host-context-after.txt` is a later observation and is not a per-run governor
  or temperature receipt.
- The corpus archive, manifests and files were verified by the compiler's
  pinned `fetch-corpus.sh` into a task-owned directory; c-testsuite was checked
  out at the pinned commit. No corpus source or compiler executable is
  distributed here.

The archived command logs replace other sessions' lock-holder details with a
generic wait marker; unmodified originals remain on Benchpress. The test output,
exit statuses, manifests and trace data are otherwise retained.

## Correctness qualification and lock granularity

The exact compiler revision's hosted correctness and fuzz jobs passed in
[run 42131306512](https://github.com/buster14a/buster/actions/runs/42131306512);
that run skipped its native job. This rehearsal independently ran all 125
named sections of that revision's `tools/ci/correctness.tests` on Benchpress.
All completed successfully, including `tests/driver/multicore.c`.

The first two cost-balanced `parallel` shards each held a single shared-lock
lease across the shard's sections: 31 passed in 56.7 seconds and 32 passed in
31.8 seconds. The third shard was interrupted after the lock-granularity issue
was raised; its partial log is retained and is **not** counted as a pass. The
remaining 62 sections were rerun individually, each as one separately locked
`parallel` invocation, and all 62 passed. Some named sections contain setup and
multiple shell commands within the same inventory test. Compiler, oracle,
inventory and cost-file hashes verified afterward. This establishes correctness
for this d944 executable only, not for a later pinning implementation.

[`native-qualification.tar.gz`](native-qualification.tar.gz) contains the two
completed shard logs, interrupted third-shard log, 62 individual logs and exit
statuses, input hashes, setup/build logs and scripts. The shell scripts preserve
the exact qualification commands. Absolute paths describe this host's original
workspace and must be adapted for a new run.

## Real-driver argument fix

The preparer at `32dbd4ce` put Clang's `--no-default-config` in each Buster
case. The first real SQLite one-lane reference exited 1 with `unknown argument:
--no-default-config`; its command, stderr and status are retained. This is a
failed prerequisite, not a timing sample.

The fix removes that Clang-only flag. Plain and ASan/UBSan preparer self-tests
both passed 23 checks against the verified frozen corpus. Using the fixed
manifests, the qualified d944 driver successfully compiled all expected
one-lane objects: one SQLite, 512 generated synthetic and 1,309 selected musl
objects. Exit statuses and object hash inventories are retained. This verifies
that those concrete driver commands execute and emit the expected files; it
does not show equality across lanes or measure performance. The one- and
multi-file compiles were each a separate shared-lock invocation.

[`driver-smoke.tar.gz`](driver-smoke.tar.gz) contains the fixed case manifests,
source and binary hashes, self-test output, generated-input receipt, compiler
commands, exit statuses, diagnostics and object hash lists, as well as the
original rejected reference. Object files and external source are omitted. The
case manifests include original absolute input paths and can be reproduced only
with the pinned inputs at adapted paths. The
[hosted smoke workflow](https://github.com/buster14a/buster-performance/actions/runs/42225532773)
passed at `72e01d5`, including a separate real-driver check on one source from
each case; the hosted fixture and sanitizer checks are not hardware evidence.

## Separate futex diagnostic

After removing the rejected option from a **copy** of the SQLite arguments, a
one-lane reference and an eight-lane process traced with `strace -ff -ttt -T -e
trace=futex` each exited zero. Their objects matched byte-for-byte (SHA-256
`7d8de3f92b7034bac528962e561bd6a85d9db030a9a04231aff111d62ae3b892`).
Each command had its own lock lease; the compiler process inherited CPUs 0–7
and its individual lanes were not pinned. Eight per-TID traces were retained.
Seven worker traces include a successful futex call lasting about 152.8 ms; the
trace also has unfinished calls at process exit. These are syscall durations
**under strace perturbation**, not an uninstrumented waiting distribution,
MWAITX residence measurement, CPU-frequency result, or speedup.

[`futex-diagnostic.tar.gz`](futex-diagnostic.tar.gz) contains the filtered argv,
commands, statuses, raw per-TID traces, object digests and the small summary
script. It does not include objects. The original case manifest is unchanged.

---
Agent session: 01a1b0e0-a314-7252-9c29-d958f2e64d73 (Codex session ID; agent thread 01a1b0e1-da73-7731-9bcf-4312e3561034; no private session URL is exposed)
Model: OpenAI / GPT-6
