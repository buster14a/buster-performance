# C9g: the verified optimizer's vector passes deleted (#2924, rule 1)

The owner kept the verified optimizer's scalar passes as its one implementation (#2924's
[7112387760](https://github.com/buster14a/buster/issues/2924#issuecomment-7112387760)). Forced, the vector passes took
1.02 to 1.44 times their ticks on Tier 1's pipeline and #860's AUTO bound never chose them below 8,192 instructions
([`../c-ir-gate-again/`](../c-ir-gate-again/)). #3445 is the vectorized form that would have to win. No new gate was
needed; this run checks the deletion.

The scalar and vector passes are exact twins by design (the same fixed points, the same resolution of jump cycles,
the same identity table and ranks, the same SIMD-fold rule), unlike value numbering's (held for the owner): the old
tests required bit-identical rewritten IR on every fixture, and the scalar results' digest frozen while both paths
agreed holds after the deletion.

## The run

[`run-opt.sh`](run-opt.sh) on the 9700X: Release, every run under the lock, timings on CPU 2. Base `e6028d4b` is the
tests commit (both paths present), head `78e88380` the deletion, both on main `968a085f`
([`logs/commits.txt`](logs/commits.txt)). The branch was then rebased onto main `aeb99a83` (LICM's #3425, SROA's #3487
and promotion's deletions) and gained two commits: a test fixture, and `IrSroaOptions.scalar`'s removal, which selects
nothing once both SROA's twin and the optimizer's are gone. Neither changes production code paths beyond a dead
field. The tests ran in the session's container instead of under the lock (the coordinator's rule for the
crowded lock, 2026-11-23), so [`tests.list`](tests.list) was emptied before that step.

**Objects:** `--tier1`, `--tier1 --tier1-passes=+all` and `--tier1 --tier1-gvn` of sqlite3.c, Lua 5.4.8, musl's units
and buster's `main.c`: 1,372 of 1,372 byte-identical in each mode ([`logs/status.txt`](logs/status.txt)).

**Whole compiles:** `ab --rounds 3 --cpu 2` around `time-runs --runs 3 --copies 3`, base, head and base again; user
cycles against base ([`logs/time.log`](logs/time.log)):

| Compile | Head | Base again |
| --- | --- | --- |
| sqlite3.c, `--tier1` | −0.66% (copies −0.78% to −0.42%) | −0.14% (−0.18% to +0.02%) |
| Lua's units, `--tier1` | −0.39% (−0.55% to −0.09%) | −0.13% (−0.24% to +0.00%) |
| sqlite3.c, `--tier1 --tier1-passes=+all` | −1.17% (−1.25% to −1.02%) | −0.08% (−0.17% to +0.03%) |

Head retires fewer instructions: 2,004.58 M against 2,022.82 M for Lua's units, 18,372 M against 18,768 M for
sqlite3.c under `+all`: the rewrite's pointer jumping and the passes' `scalar` reads are gone from the compile path.

`check-call-graph` and the unity ownership check pass on head ([`logs/`](logs/)).

## Tests and checks (the session's container, AVX-512)

On the PR's head: `test-ir-optimize` (the digest), `test-ir-gvn`, `test-ir-licm`, `test-ir-sroa`, `test-ir-inline`,
`test-ir`, `test-ir-simd`, `test-ir-reduce`, `test-ir-metamorphic --seed 731 --count 6`, `test-tier1-pipeline`,
`test-tier1-wide`, the source tests on c-testsuite's 220-program subset (`test-ir-source --passes`, `test-ir-source`,
`test-ssa-source --typed --tier1`, `test-tier1-cfg-source`), `test-c-testsuite --cross-check` and `--tier1
--check-code-size` (220 of 220; Tier 1 430 of 430 functions), the Release build, `check-call-graph`, and
`-fsyntax-only -Wall -Werror` of `main.c` with and without `-DBUSTER_COMPLETE_DRIVER=1`. ASan, UBSan and MSan builds
ran the IR tests clean before the rebase.

## Mutants

[`mutation/`](mutation/): 11 mutants of the kept scalar passes, each run against `test-ir-optimize`, `test-ir-gvn`,
`test-ir-licm`, `test-tier1-pipeline` and `test-tier1-wide` ([`results.txt`](mutation/results.txt), both rounds):
- 9 killed;
- `i1` (the identities' last candidate of a 64-instruction batch) survived round 1: a fixture now puts an identity at
  every place of a batch, and kills it;
- `t1` (the cycle walk starting one place later) and `d1` (dead-code removal not seeding instruction 0) are
  equivalent: the walk's representative starts at that node, and instruction 0 has no operands in SSA.
