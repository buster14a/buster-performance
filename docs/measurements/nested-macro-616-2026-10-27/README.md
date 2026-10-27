# Nested function-like macro arguments: #616

Source issue: [buster14a/buster#616](https://github.com/buster14a/buster/issues/616).
Implementation: [PR #639](https://github.com/buster14a/buster/pull/639).
Baseline: `92c025e71856d13eb34247477c5294d2cead139e` (main, including #595).
Candidate: `baa2f55cfa655d757ba67d6e20c5acb8c2168b8f`.
The implementation borrows nested raw-argument slices and indexes delimiters once.
The pre-existing expansion limits are unchanged.

## 9700X results

Fresh-process `compiler -E -P case.c -o /dev/null`, five accepted samples
after one warm-up per label. Wall entries are median (minimum–maximum), in
milliseconds. Instructions and each process's peak RSS are medians too;
RSS was identical across all accepted samples of each label.

| Depth | Baseline wall, ms | Candidate wall, ms | Baseline user instructions | Candidate user instructions | Baseline peak RSS, KiB | Candidate peak RSS, KiB |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1,000 | 6.606 (6.523–6.633) | 1.194 (1.112–1.336) | 193,411,569 | 2,968,505 | 33,188 | 16,472 |
| 2,000 | 23.174 (22.874–23.489) | 1.449 (1.410–1.601) | 769,803,450 | 5,153,087 | 80,356 | 18,628 |
| 4,000 | 88.420 (88.230–88.526) | 1.721 (1.557–1.788) | 3,071,588,419 | 9,523,402 | 258,616 | 20,840 |

At 4,000, median wall time is 51.38 times lower, user instructions are
99.69% lower and peak RSS is 91.94% lower. The candidate's instruction
counts grow by about 2.185 million per additional 1,000 levels. Together
with the linear raw-token budget regressions, this establishes the scaling
repair for these identity nests. Cycles and every observation are retained
in `summary.tsv` and `9700x/scale-queued.tsv`.

The representative frozen SQLite command has eleven accepted samples per
variant after warm-up:

| Metric | Baseline | Candidate | Change |
| --- | ---: | ---: | ---: |
| Median wall, ms (range) | 15.809 (15.408–16.070) | 15.719 (15.272–16.213) | −0.57% |
| User instructions | 248,673,972 | 249,191,802 | +0.21% |
| User cycles | 69,634,457 | 69,850,685 | +0.31% |
| Peak RSS, KiB | 55,992 | 55,984 | −8 KiB |

The wall ranges overlap. The instruction overhead is observable; no SQLite
timing improvement is claimed. This compares one build placement per variant,
with address randomization disabled, and does not establish a small timing
regression floor or corpus-wide performance. All 60 observations exit 0 with
nonzero, unmultiplexed counters. Observed row order exactly matches the
requested rotating scale rounds and alternating SQLite rounds; each label's
first actual observation is its submitted round 1 warm-up.

Recalculate the table with:

```sh
clang -O2 -Wall -Wextra -Werror summarize.c -o summarize
./summarize 9700x/scale-queued.tsv 9700x/sqlite-queued.tsv
```

The initial sequential-submission campaign was stopped after one warm-up of
each baseline command; its two `sequential-warmup-*.tsv` files are excluded.
The accepted campaign uses the queued driver below and contains a complete,
fresh warm-up and measured set for every label.

## Reproduction and provenance

`generate.c` is copied byte-for-byte from
[`7d256668`'s audit generator](https://github.com/buster14a/buster-performance/blob/7d25666880d5bbdce838bab7e0f79a31d70d4c78/docs/measurements/performance-audit-2026-10-27/generate.c).
The synthetic sources are original Buster fixtures; no external compiler source
or corpus is incorporated. `input-sha256.txt` identifies depths 1,000, 2,000,
4,000 and 8,000. Generate them with `./generate macro_nested N > nested-N.c`.

`procbench.c` comes from this repository at
`32fdc4db4da6807cca13904a9022f1fc0147e992`, path
`docs/measurements/link-foreign-team-501-2026-10-26/procbench.c`. Its only local
change sets `exclude_kernel` and `exclude_hv` for counters, so the reported
instructions and cycles are user-space counts, as in the discovery record.
Its existing Apache-2.0 WITH LLVM-exception notice is retained.

`campaign.c` is new C orchestration, compiled with `clang -O2 -Wall -Wextra
-Werror campaign.c -o campaign-queued`. The measurement tools are compiled
locally with Clang 23.1.4; the measured compilers are built natively with
Clang 23.1.1. From a directory containing `base/` and
`head/` release builds, the generated inputs, `procbench` and `campaign-queued`, run
`taskset -c 0 ./campaign-queued scale` and `taskset -c 0 ./campaign-queued sqlite`
**outside** the host lock. Each
fresh-process sample invokes `~/buster-fast-bench/exclusive.sh` separately.
The controller is pinned to CPU 0 with `taskset -c 0`; it submits the
short independent commands in advance, each still taking its own lock, and
waits for all children. A two-second submission gap after round 1 puts the
first group in the lock queue first. The recorded row order retains actual execution
order, which a contended kernel lock can change. All measured children use CPU 2 and request `ADDR_NO_RANDOMIZE`; base/head paths have
equal lengths. Every command list and observation is retained. For each label,
its first actual execution is discarded as warm-up; the remaining five scale
or eleven SQLite observations are summarized. Submission rounds rotate the
scale labels and alternate SQLite variants; the row order records execution
rather than assuming the lock preserves submission order. Wall time spans release of the child
through `wait4`; RSS is `wait4`'s peak resident KiB for that process. Hardware
counters start on exec and inherit to descendants. A `*` marks multiplexing;
failed/missing counters must not be treated as zero work.

SQLite uses the existing frozen corpus at
`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`, with its frozen
Clang/glibc include paths, `-march=znver5 -std=gnu17 -E -P -o /dev/null`.
Its source SHA-256 is
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.
The corpus stays external; its existing provenance and licenses apply.

## Local validation

The laptop is a Ryzen 9 7940HS, Clang 23.1.4. These are correctness checks,
not target-host performance evidence. The release build uses the repository's
unmodified `BUSTER_DEBUG_INFO=0 ./build.sh`, within a four-core grant.

`local/focused_tests.c` includes the original repository's frontend unit and
calls the three new test functions directly. `local/lexer_home.c` supplies
the lexer entry points; unused sections are discarded at link time. Build:

```sh
clang -O0 -march=native -I SOURCE/src -fwrapv -funsigned-char \
  -fno-strict-aliasing -Wall -Werror -ffunction-sections -fdata-sections \
  -Wl,--gc-sections local/focused_tests.c local/lexer_home.c -pthread -lm -o focused
./focused
```

The sanitizer run adds `-fsanitize=address,undefined -fno-sanitize-recover=all`
and uses `ASAN_OPTIONS=detect_leaks=0`. Both pass. Coverage includes:

- depths 1, 42, 43, 63, 64, 65, 1,000, 2,000, 4,000 and 8,000, repeated
  with different output tokens, under a `3*N + 4096` raw-token budget;
- scalar/vector kernels, both with recorded history and without history;
- real raw-token and capture-token exhaustion, plus allocation failure;
- independent delimiter pairing on unbalanced streams at protected tails;
- 13 semantic fixtures checked with Clang, flags/locations, printers,
  expansion history and deferred replay.

The no-slices mutant changes the initial condition of
`pp_collect_argument_slice` to `false && ...`. The same focused tests fail
the storage-budget regressions, including all four modes at depth 63 and
larger. Its exit status is 1. This confirms that output equality alone would
not hide a return to repeated copying.

`test-preprocessor --clang --jobs 1 -I src
src/buster/compiler/c_preprocessor.c` passes: 470,468 output tokens, scalar
and vector equality, Clang spelling/location checks, and deferred history.
The complete `test-preprocessor --clang --fuzz 3000 --seed 616` suite also
passes: 3,000 C17 and 3,000 C23 cases, all compared with Clang, zero kernel
differences, zero Clang differences and zero unverified cases. The first run
without the optional pragma adapter left C17 case 2251 unverified and exited
1; the retained full rerun uses the repository's adapter built against the
matching installed Clang 23.1.4, and exits 0. These logs include intentional
negative comparison fixtures, whose printed diagnostic is not a run failure.
The local generated assembly is retained for the new index; the vector path
uses a masked 64-byte kind load and delimiter masks, with ordered scalar
pairing over the hits and no gathers/scatters.

## Native correctness

Both unmodified release builds pass on the Ryzen 7 9700X with Clang 23.1.1.
The candidate's full suite passes there too: 377 fixtures plus 3,000 C17 and
3,000 C23 generated cases, all compared with Clang, with zero differences,
zero unverified cases and no case without a result. It uses the matching
23.1.1 pragma adapter. Its new storage, delimiter, allocation and semantic
regressions all pass.

The frozen SQLite oracle reports `identical` for all 706,237 output tokens.
`9700x/` retains the build logs, full native test log, oracle report, adapter
identity and environment. CPU 2 uses the performance governor and EPP; its
SMT sibling CPU 10 is offline. Perf access is enabled (`perf_event_paranoid=-1`).

## Scope

Synthetic identity nests establish the scaling repair. They do not establish
how often this shape occurs in a corpus or a corpus-wide speedup. The scalar
delimiter classifier is exact; pairing retains the same ordered stack work
in both modes. This record is not a claim about every compiler stage or every
possible deep macro workload.
