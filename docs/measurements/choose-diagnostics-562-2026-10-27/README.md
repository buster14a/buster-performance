# Unselected x86 range diagnostic context (#562)

Original qualification for [Buster #562](https://github.com/buster14a/buster/issues/562)
and [implementation PR #588](https://github.com/buster14a/buster/pull/588).

## Identities and scope

- Baseline: `e61532592cab11718ade1f99b4e805794f95ad4a`, PR #561's deferred range resolver.
- Implementation: `77aea0676c7a6d995ef216d1e8177a49e2e4bdff`.
- Integrated source PR head: `4bc47037fe35c4df3f48008b9a71e9f1a5729249`.
  This merges prerequisite `1efe62365f2569a0e11cc4244628f4aeb800dd63`, which
  changes only the existing hard-diagnostic test assertions. Production sources
  are identical to the implementation head. Commit records are retained here.
- Hardware: Ryzen 7 9700X, Clang 23.1.1, optimized `./build.sh` with
  `BUSTER_DEBUG_INFO=0`; native host ISA, warnings as errors. Every hardware
  build/test/measurement takes `~/buster-fast-bench/exclusive.sh` separately,
  with this issue/PR identified in the shared owner record. Timings use CPU 2.
- Local checks: Ryzen 9 7940HS, Clang 23.1.4, the same build options, the
  shared `cores` queue. Local timings are not used as hardware evidence.
- `source.sha256` identifies the implementation source transferred to the
  hardware host. It was checked there before testing. Binary/input hashes and
  compiler/CPU identity are retained separately.

All probes, generated inputs and generators are original project material.
Clang runs externally as an oracle; no external implementation or fixture is
imported. The frozen SQLite amalgamation is an external runtime input and is
identified by hash, not copied here.

## Correctness

The source suite contains 82 isolated x86 fixtures, 32 added for this issue.
Both production driver schedules compare status, severity, full range message
and line/column. Cases include both selected and unselected choose arms,
nested selections, dead statements, short circuits, compound literals,
`sizeof`/`alignof`/`typeof`, generic control, and pragma/`-w` policy. New scratch
tests cover every allocation cut with exact prefix and metadata preservation.

At the integrated head locally, `test-checker --seed 133` reports 259,836
checks and four pre-existing Clang 23.1.4 fpclassify execution-oracle
disagreements. All x86 fixtures and new storage checks pass. At the
implementation head the corresponding count is 259,827, with the same four
disagreements. Local driver, builtin and deferred suites pass with 21,585,
5,607 and 960 checks respectively. The integrated call graph has 41 units,
23,841 functions, zero unallowed cycles and zero split variables.

On the locked 9700X at implementation head `77aea067`, all four suites pass:

| Command | Checks | Failures |
| --- | ---: | ---: |
| `test-checker --seed 133` | 259,827 | 0 |
| `test-checker-driver --executable ./build/compiler` | 21,585 | 0 |
| `test-check-builtins-x86` | 5,607 | 0 |
| `test-checker-deferred` | 960, 61 fixtures | 0 |

The 65-case standalone context matrix also matches Clang 23.1.1 exactly on
that host. Manual hardware qualification is for the implementation head;
the integrated head's additional prerequisite hard-diagnostic assertions
were rerun locally. Required GitHub CI remains a separate gate.

`choose-probes.c` separately runs 13 expressions in five contexts (65 isolated
files). Clang and the fixed compiler agree in all 65 locally; the baseline
differs in 32. Compile it with `clang -Wall -Werror choose-probes.c -o probes`
and run from a directory containing `work/`: `./probes clang` or
`./probes /absolute/path/to/compiler`. The harness writes only its scratch
source/output/error files beneath `work/`.

The additional exploratory `expanded-choose-probes.c` adds constantness,
object-size and type-classification query contexts. Of 104 local cases, the
baseline differs from Clang in 55 and the fix in seven. All seven remaining
differences already exist on the baseline: four selected-arm range checks in
constantness/object-size queries, and three type-classification query failures
around sizeof expressions. They are outside this change; these logs are
retained explicitly and are not counted as passing qualification.

## Matched cost screen

`generate-context-inputs.c` creates one or 2,000 functions, with a direct call
or an unselected choice and an in-range or out-of-range immediate. The range
warning is ignored in each input so both builds accept the same workload.
This measures source checking, including context construction and consumption;
it does not measure native program quality or justify a performance gain.

The screen uses the implementation and baseline executables above, 11 rounds,
one warmup, three fresh copies per build, rotated order and an identical
baseline-again control. Each build has one code placement, so copy variation
and the A/A control do not isolate every code-placement effect. Peak RSS is
whole-process RSS; the new source-context scratch is bounded at six bytes per
token plus four bytes and is released before returning from source adaptation.

| Input | Baseline wall, ms | Fix wall, ms | Change | Change over copies |
| --- | ---: | ---: | ---: | ---: |
| One unselected range call, ignored | 1.096 | 1.053 | -3.88% | -33.95% to +31.42% |
| 2,000 unselected range calls, ignored | 10.444 | 10.521 | +0.74% | -2.00% to +6.14% |
| 2,000 unselected in-range calls | 10.391 | 10.434 | +0.42% | +0.09% to +1.22% |
| 2,000 direct range calls, ignored | 8.052 | 8.107 | +0.68% | +0.42% to +1.55% |
| Frozen SQLite | 127.533 | 127.774 | +0.19% | -0.18% to +1.09% |

All timed processes exit zero. The tiny input's baseline varies by 51.45%
over copies and its identical-baseline control moves -5.34%; its wall time
does not support a change claim. The range-choice baseline varies by 5.32%,
and its identical-baseline control moves +0.95%, exceeding the fix's +0.74%.
The remaining medians are a narrow cost screen, not a general performance
conclusion. One code placement cannot separate context work from placement.

Across the per-copy medians, range-choice instructions rise from about
136.916 million to 137.350 million (+0.32%), while peak RSS falls from about
92,036 KB to 89,984 KB: eager events no longer need the deferred graph walk.
In-range choice instructions rise from about 135.965 million to 136.592
million (+0.46%) with peak RSS about 90 MB in both. Direct-call instructions
rise about 0.06%, and SQLite's instructions differ by less than 0.001%; their
peak RSS stays about 77 MB and 596 MB respectively. RSS figures include the
whole process and allocator/page granularity, not just context scratch.

Reproduce each locked command from `~/buster-fast-bench/issue-562`, with
baseline and implementation checkouts in `base/` and `source/` and the inputs
under `work/inputs/`:

```sh
EXCLUSIVE_OWNER=codex-562 EXCLUSIVE_TITLE='Buster #562 matched cost screen' \
EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/588 \
~/buster-fast-bench/exclusive.sh taskset -c 2 ./source/build/compiler time-runs \
  --runs 11 --warmups 1 --copies 3 \
  --build baseline ./base/build/compiler \
  --build fix ./source/build/compiler \
  --build baseline-again ./base/build/compiler \
  --list -fsyntax-only work/inputs/small.c \
  --list -fsyntax-only work/inputs/choices.c \
  --list -fsyntax-only work/inputs/valid-choices.c \
  --list -fsyntax-only work/inputs/calls.c \
  --list -fsyntax-only /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
```

Generated workload arguments are `(output, count, immediate, choose)`:
`small.c 1 8 1`, `choices.c 2000 8 1`, `valid-choices.c 2000 7 1`,
and `calls.c 2000 8 0`.
