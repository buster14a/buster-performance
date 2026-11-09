# Instrumented wait diagnostic preparation on Benchpress

This is preparation for a separate, perturbed wait diagnostic. It is **not** a
measurement of the benchmark workloads, a scaling curve, or acceptance. The
instrumented executable is distinct from the qualified uninstrumented timing
compiler; the latter remains the executable for performance curves.

A fresh isolated checkout of merged Buster commit
`2dc50258e8b33393474b64032a5cbe9f17c63def`, tree
`1829aa50f677d713bcb250966746575d526989ef`, passed the reviewed fail-closed
applicator. The instrumentation patch SHA-256 was
`a3c1b07813bea6ed47d50d1f5d84f2d927ce69eb55aa560d8751aba47cdda80d`;
the resulting `git diff --binary` SHA-256 was
`199e7888f51df9f46995ea751198a00f92ba306acd3272b016068ed66a245414`.
Only `src/buster/compiler/lane.c` and `lane_test.c` were changed; no hidden
index flags were found. The patch and applicator used from performance revision
`0404e7cf` were verified byte-identical to revision `7ebd7ac`.

Under separate fair host-lock grants, the patched compiler was built and then
its `test-lanes --rounds 10` was run on CPUs 0–7; each command had its own
240-second timeout and 15-second kill grace. Both returned exit status 0.
The build used Clang 23.1.4 (compiler SHA-256
`c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67`),
`BUSTER_HOST_ARCH=znver5`, `BUSTER_DEBUG_INFO=0`, Release, and
`-DBUSTER_LANE_WAIT_DIAGNOSTIC=1`. The instrumented compiler SHA-256 was
`098eebdffc96491035b3508d56df6546aba5c97209b3f556088f9b1b73d049e3`;
the uninstrumented control remained
`51b54dd02986a28f294c0d5b2539e93739acb8962851127316da7953d4f8b09b`.
Before/after identity records agree for the commit, tree, patch, applied diff,
changed source files and both executable hashes. The lane test reported zero
wrong in its wait diagnostic, including actual futex wake/EAGAIN, timer, lane
identity, accounting and MWAITX where supported.

The archive retains the raw applied diff, build and test logs, separate own
lock-owner receipts in those logs, compiler configuration, toolchain identities,
and before/after identities. The patch-applicator command also ran through the
shared lock, but its log did not capture a positive lock-owner receipt; its
successful exit and patch identities are retained without claiming such a
receipt. The wrapper completion statuses above were observed from the command
invocations. No lock-release timestamp or exact hold duration was captured.

`receipts.tar.gz` contains `SHA256SUMS` for its sanitized files. Home-directory
paths and other sessions' lock-holder details in wait messages were replaced
with placeholders; consequently hashes embedded in original records describe
original files, not sanitized path-bearing copies. Original unredacted files and
both executables remain on the host. Neither executable is included in the
archive.

Before interpreting any wait observations, run a separately coordinated,
bounded pinned smoke, validate the lane/CPU and wait records and launcher
status, and compare diagnostic objects against the exact qualified
uninstrumented control. Capture input, source, patch, executable and lock
identities for each run. The 1–10 ms histogram bucket cannot distinguish
intervals over 1.5 ms exactly. The full campaign and observations were held for
#1455's hardware qualification and coordinator admission when this preparation
was recorded.
