<!-- SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception -->
<!-- Copyright (c) 2026 David Gonzalez Martin. -->
# Exact-source CI receipts

Read-only GitHub API receipts confirm both runs' `head_sha` is
`20e01cebc77a0142260f3e0a6b3e9c66228ef3bf`, status completed, conclusion success:

- [41051382107: Tests and Zen 5 benchmarks](https://github.com/buster14a/buster/actions/runs/41051382107): hosted Ubuntu 26.04 native and x86-64 O3 correctness, native Benchpress correctness/selected benchmarks, and the protected aggregation job succeeded.
- [41051382118: Measurement storage](https://github.com/buster14a/buster/actions/runs/41051382118): storage policy succeeded.

The run JSONs retain selected API identity/status/time fields, and the job JSONs
retain returned job/step summaries. Conditional benchmark steps and the
libFuzzer job were skipped where the workflow does not select them; skipped
sanitizer/fuzz steps are not claimed as new sanitizer/fuzz qualification.
All applicable hosted/native/aggregation/policy jobs passed. CI's complete native
correctness is distinct from the standalone hardware main.c campaign and from
the local full-checker receipts.
