# Hard-constraint diagnostic review follow-up

Source PR: [Buster #561](https://github.com/buster14a/buster/pull/561).
Review: [2026-10-27 third review](https://github.com/buster14a/buster/pull/561#pullrequestreview-5670795369).
Source head: `1efe62365f2569a0e11cc4244628f4aeb800dd63`.
Parent: `e61532592cab11718ade1f99b4e805794f95ad4a`.

This review found no blocking issue and suggested checking the hard-constraint
diagnostic itself in the `ICE stays hard with -w` fixture. The update changes
only `c_check_x86_diagnostic_test.c`. Its reader can collect all error messages
as well as range diagnostics. The three nonconstant-immediate fixtures now
each require exactly one error, the expected complete message, error severity,
and the expected line/column. This includes the dead-code and `sizeof` cases
as well as `-w`, adding nine assertions while retaining 50 source fixtures.

Clang's expected message is `argument to '__builtin_ia32_cmpb128_mask' must be
a constant integer`. Buster currently uses `incompatible operand or conversion
types`; its full wording and existing source location are pinned independently.
No production diagnostic wording changes in this commit.

## Local checks and a controlled unrelated failure

The optimized local build passes with warnings as errors. The complete checker
executes 259,577 checks: all x86 fixtures and the nine added assertions pass.
The four failures are the same known Clang 23.1.4 `fpclassify` executable-oracle
disagreements recorded in the preceding reviews. `logs/local-checker.log`
retains the complete output.

`negative-oracle.c` wraps `/usr/bin/clang`, delegating every invocation except
the quiet nonconstant-immediate fixture. For that one case it emits a single
error at the same expected line/column and returns the same exit status, but
substitutes `injected unrelated diagnostic`. The existing status and range-count
assertions still pass. The new hard-message assertion fails, producing exactly
one additional failure (five total including the four known local failures).
`logs/local-negative-control.log` identifies that precise assertion. This is
an intentional negative control, not a successful qualification run.

From this directory, reproduce it locally with:

```sh
cc -std=c17 -O2 -Wall -Wextra -Werror negative-oracle.c -o negative-oracle
CORES_TITLE='Buster 487 hard-message negative control' \
CORES_LINK=https://github.com/buster14a/buster/pull/561 \
cores -n 2 -- env -u CPATH -u C_INCLUDE_PATH \
/absolute/path/to/build/compiler test-checker --seed 133 \
--clang "$PWD/negative-oracle"
```

The wrapper pins `/usr/bin/clang`; the recorded local version is 23.1.4. A
different host can have a different baseline failure count. The intended
negative-control failure must name `x86 ICE stays hard with -w, Clang` and the
injected message.

Local compiler SHA-256:
`fd1d23f840ea5b449536f3338ebb1ac35dc3f1dac0107a3980de9872a8c014b9`.

## Approved-host identities

The separate Ryzen 7 9700X optimized build passes all 41 source files with
Clang 23.1.1 and warnings as errors. `head-source.sha256` and
`logs/source-check.log` verify all 487 tracked compiler/build files against
the exact source commit. `source.patch` is the zero-context test-only delta
against the parent, applied with `git apply --unidiff-zero`.

The exact-head `test-checker --seed 133` run passes **259,577 checks with zero
failures**, including all 50 x86 fixtures and the nine new assertions.
`logs/checker.log` retains the complete output. The four local Clang-version
disagreements do not occur on this host's Clang 23.1.1.

9700X compiler SHA-256:
`d8315599725af6fad75b153eef9f7461e53623fb2843a14f9d9aaf39d758af84`.

Every build and checker invocation on that host takes the existing shared
lock separately. The checker command is:

```sh
EXCLUSIVE_OWNER=codex-487 EXCLUSIVE_TITLE='Buster 487 hard-message checker' \
EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/561 \
/home/david/buster-fast-bench/exclusive.sh taskset -c 2,3 \
env -u CPATH -u C_INCLUDE_PATH ./build/compiler test-checker --seed 133
```

The [previous `-w` record](../review-quiet/README.md) retains its own driver
suite and 18 command-line controls at parent `e6153259`. Production sources
remain unchanged. The cost screen in [the implementation record](../review-latest/README.md)
stays tied to `a7a4adf4` and its specific binary; these tests-only follow-ups
make no new timing claim. Required GitHub CI remains a separate qualification.
