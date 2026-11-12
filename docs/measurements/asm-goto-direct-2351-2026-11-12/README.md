# asm goto branching straight to its labels — #2351 gap 1, 2026-11-12

Source: buster's branch `e3c/2351-asm-goto-direct` (#2351's gap 1). An asm goto body
without outputs, whose call row nothing follows, jumps from its template straight
to its labels in Tier 0 (`tier0_asm_direct`), as clang's `callbr` does. Before, the
body set an exit number in eax and the statement's code compared it and branched
to each label (#1839's item 2, [asm-goto-body-1839-2026-11-11](../asm-goto-body-1839-2026-11-11/README.md)).

## Run

On `benchpress` (Ryzen 7 9700X), under the shared host lock
(`~/buster-fast-bench/exclusive.sh`), each run pinned with `taskset -c 2`, wall
time from `date +%s%N` (`run.sh`):
- base `e943360f` (main) and head (base plus commit `66850e13` of the branch),
  both built on benchpress by `./build.sh` (Release, native);
- the kernel `goto.c`, B5b's from #1839's measurement, compiled by each build at
  its default (Tier 0): 200 million iterations of `sign` (a sign test branching to
  two labels, no outputs: the direct form) and `hit` (a compare with an output
  reaching a label: its dispatch stays);
- 7 rounds, base and head alternately (`times.tsv`). Both print 1699999997 in
  every run.

`status` has the head tree's suites from the same run: `test-checker-asm`,
`test-checker --program-asm`, `test-tier0 --cross-check`, `test-tier0-inline`,
`test-object-writer --cross-check`, `test-link`, `test-check-lanes`,
`test-check-units` and `test-checker`, all 0 failures.

## Result

| build | median | min | max |
|---|---|---|---|
| base (exit number and dispatch) | 526.9 ms | 524.2 ms | 529.2 ms |
| head (direct branches) | 475.7 ms | 473.7 ms | 477.1 ms |

Head is **9.7% faster** (median). The whole difference is `sign`'s: `hit` keeps its
dispatch. `sign-base.s` and `sign-head.s` are each build's `sign`: 25 instructions
with a `push rbx` for the exit's temporary, against 11 with the template's `je`
and `js` going to the labels' code.
