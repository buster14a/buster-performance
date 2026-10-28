# Exact PR #678 scalar controls

These controls distinguish PR defects from interactions with retained local
performance changes. No tracked source was changed in either control, and
no PR, push, issue comment or remote operation was made. Every build and
test runs through a separate local `cores -n 2` grant.

## Frozen identities

- Old PR: `8af0904bfa103398af64f292d560cfbdc6fdc22d`, branch
  `codex/perf-pr678-control`, checkout `../pr678-control`.
- Latest examined PR: `ed1e848e1a57cda5ba410afabb320edecc1a65dc`, detached
  checkout `../pr678-latest-control`.
- Both use `BUSTER_HOST_ARCH=x86-64 BUSTER_DEBUG_INFO=0 ./build.sh` and the
  project's ordinary release flags. All 41 units build successfully,
  old in 75.1 s and latest in 73.1 s. These are build receipts, not a
  controlled build-performance comparison.
- Commit/tree/archive digests, executable hashes and relevant source hashes
  are recorded in the identity files; the latest executable is
  `3cbef3ef67da7346bdd7a6a53a4c37645efb70675f79b3a230c586dd59572ad7`.

The original project-generated complex fixture and its existing oracle
harness were preserved from the combined branch's retained failure at
`/tmp/buster-check-program-O1Ouwv`. `complex-tested.c` removes only the
oracle's first-line `tested` name macro, so it exposes `tested` for Buster.
`complex-oracle.c` retains that macro for the independently compiled Clang
definition. The preserved lane sources came from
`/tmp/buster-check-lanes-w27kK3`. No external implementation was imported.

## Targeted attribution

Both control compilers use the same original sources. Clang compiles the
oracle/harness with `-O0 -fwrapv -fno-strict-aliasing`, links the control
object with `-lm`, and the harness compares 23 inputs on three repetitions.

| Reproduction | Old exact PR | Latest exact PR |
| --- | --- | --- |
| complex widths object/link | success | success |
| complex runtime oracle | fails at n=-3, ours -1801116121 vs 1216948153 | passes |
| retained lane program 3 | rejects casts to union types at 211:25 | compiles |
| retained lane squeeze | rejects casts to union types at 60:25 | compiles |

The old exact PR reproduces the combined b71 failures exactly, so these
failures predate the retained performance changes. The latest PR restores
`check_lower_complex_conversion` dispatch rather than treating it as a
host-ISA kernel. No obsolete old full suite was run.

## Latest exact control suites

Each command ran once, with the same flags as the combined branch:

```
./build/compiler test-checker --seed 678 --clang clang
./build/compiler test-checker-driver --clang clang --executable ./build/compiler
./build/compiler test-check-lanes --executable ./build/compiler
```

- Checker: 467,693 checks, **599 failures**. This is not a passing suite.
- Driver: 21,648 checks, zero failures.
- Lanes: 2,631 checks, zero failures.

The first 24 checker failures exhaust its diagnostic print cap. All printed
failures are the new host-based walk-accounting assertion: on a scalar host
the portable sparse resolver still skips tokens, while expression walking
uses the scalar kernel. For example the requested batched path visits
13 resolve / 18 expression tokens against the scalar path's 19 / 18.
Expecting both counts to equal is incorrect for this algorithm selection.

`latest/make_source_adapter.c` is an original C generator for a focused,
self-contained source-family classifier. It copies the project's main and
checker-test sources, retaining their notices, changes foreign entry-point
linkage only for standalone linking, counts the known walk predicate, and
prints every other failure without the 24-line cap. Its copies are outside
the pristine checkout. The focused adapter omits the full action/graph,
backend and generated native-program suite; it is not a repeated full
checker run. Reanalysis receipts are in `latest/source-families.log` and
`latest/source-overload-family.log`.

The first focused source (`source_families-first.c`, executable
`source-families`) finds 577 failures, all in that walk predicate and zero
unexpected failures. The updated `source_families.c` adds the omitted
overload-source group and a family-name filter; running only that group
with `source-families-filtered overload-sources` finds the remaining 22,
again all walk predicates. Thus all 599 pristine-control failures are
accounted for without repeating the broad suite. Both binaries and the
source revisions are retained with digests. This is distinct from the
integration owner's two additional retained-specific assertions.

The minimal expected correction is to test the selected algorithms
separately: strict sparse resolve skipping on both hosts; strict expression
skipping for the native kernel and equal expression visits for the scalar
kernel. Production semantics should not change to satisfy a work counter.
The exact proposed predicate is:

```
input[1].resolve_visits < input[0].resolve_visits &&
(BUSTER_HOST_VECTOR ? input[1].expression_visits < input[0].expression_visits :
                      input[1].expression_visits == input[0].expression_visits)
```

The parent and integration owner have the classifier for any separate
retained-specific failure. No expectation correction was applied here.
