# Ignored x87 return review correction

Implementation: [Buster PR #1331](https://github.com/buster14a/buster/pull/1331),
head `cc5b243986ffea6f4565d2b55ad0c989c03cf903`.
[Review finding](https://github.com/buster14a/buster/pull/1331#discussion_r4484403562).
Commit `790bc55e` gates ignored scalar x87 result capture on `result_size == 0`
independently of argument records; `cc5b2439` makes the regression restore the
complete x87 state after its negative control.

The production typed native adapter executes a real registered C function
returning `long double` from a by-value two-word struct argument, 17 times with
an ignored result. The regression checks TOP and the stack-fault bit after every
call, then checks a consumed scalar result and an aggregate x87 result with
memory canaries. Full FNSAVE/FRSTOR state includes register tags and values, so
a broken bridge's leaked values cannot contaminate the later tests. This is a
native test fixture, not support for interpreting inline assembly.

## Results

| Configuration | Native-boundary result |
| --- | --- |
| Original `3f275045` adapter plus the final regression only | 52 checks, exactly 1 failure: x87 TOP/stack-fault balance; command exits 1 |
| Fixed head, normal Release on the 9700X | 52 checks, 0 failures |
| Fixed head, ASan/UBSan/bounds with leaks on the 9700X | 52 checks, 0 failures |

The fixed normal and sanitizer runs also pass typed interpretation (865 checks),
IR interpretation (963), Link materialization (33), lowering (761,111), the
aggregate/variadic source fixture, linked units with undefined-byte checking,
and main-source syntax. Both audits report all nine PR commits signed, none
missing, and no trailer findings. All four build/test stages in
`logs/review-fixed.status` succeed. No sanitizer report appears in the logs;
`logs/sanitizer-report-audit.txt` records the scan.

All local invocations use benchpress's shared exclusive lock, per build or test
run. Normal flags: `BUSTER_DEBUG_INFO=0`, native host, Release. The sanitizer
build adds `BUSTER_SANITIZER=address BUSTER_SANITIZER_OPTIMIZATION=1`, with
`ASAN_OPTIONS=detect_leaks=1:halt_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`. Clang is 23.1.1; baseline and
fixed executable hashes are retained in `logs/`.

[Current-head CI](https://github.com/buster14a/buster/actions/runs/42088827471/attempts/3)
passes all eight hosted correctness shards, the selected 9700X qualification and
its final gate. [Both self-host configurations](https://github.com/buster14a/buster/actions/runs/42088827435)
and measurement policy pass too. Two Ubuntu-package installation delays were
retried, then one remaining delay retried again, preserving already successful
shards. These are infrastructure retries, not passing credit for unexecuted tests.
`normal-ci-excerpt.txt` additionally retains the original successful hosted
native-boundary result and exact job link at this head. As in the parent record,
PR policy skips full native vector correctness; the selected hardware steps and
local focused suites are separate evidence.

## Reproduction and provenance

The baseline is `3f2750451ed333940551ffe840e54993b4f5589a` with only
`reproduction/review-x87-regression.patch` applied with `git apply --unidiff-zero`. The regression file's SHA-256
is `7f8aee5c0d3d363ebf15812f0fd8c4f9cf87ff43ed1a1eec4c79db83e3572241`;
`review-baseline-source-sha256.txt` also identifies the unchanged adapter.
`review-baseline-verdict.txt` verifies the one expected failure without granting
it positive acceptance credit. The fixed runs use both files from `cc5b2439`.

`reproduction/` contains the actual baseline build/test commands and the fixed
run's executed script/inventory, with this task's absolute paths. Supply
corresponding checkout and audit paths to reproduce. The parent record's older
corpus and generator campaigns retain their original revisions and outcomes.
Original project fixture, report and command glue: Apache-2.0 WITH LLVM-exception;
no third-party implementation or executable is redistributed. No performance
claim is made.
