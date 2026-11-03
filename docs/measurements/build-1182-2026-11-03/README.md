# CMake cutover: locked 9700X build receipts

This record supplies the clean/no-op/edit timing and same-source Release parity
evidence for [Buster #1182](https://github.com/buster14a/buster/issues/1182) and
[PR #1191](https://github.com/buster14a/buster/pull/1191).

## Scope and identities

- Compiler repository: `buster14a/buster`, repository ID `1421805693`.
- Source: `738f297ba6aa55ef18aed2f5b0237bbbf108762a`, tree
  `ada1b7f0a6ef76415d9f76493fc58f2aca5aca2b`.
- Legacy build engine: `build.sh` from
  `96b6cbcd122ffdc45700cf01d6e8adb40a81243c`, retained byte-for-byte as
  `legacy-build-main96.sh`.
- **Both engines build the PR head's sources in the same absolute directory.**
  The legacy observation is not a build of main's compiler sources.
- Source preparation used `git archive` into a fresh private directory.
  `source-paths.argv` is the head's NUL-delimited tracked-file list.
  `source-manifest.after`, taken after restoring the edited source, was checked
  against an independently extracted archive: every tracked-file hash matched.
- The edit appended one newline to the standalone translation unit
  `src/buster/compiler/tier1_model_measure.c`. Both its original and edited
  contents are retained. The original matches the named head; it was restored
  before the legacy build.

## Observations

One observation per operation, in the order below. Times are seconds from
Bash's `time`, at millisecond display resolution. They cover the complete
command, including wrapper/configure/link/bake/publication work where needed;
the shared-lock queue wait is outside the timer.

| Operation | Wall | User CPU | System CPU | Exit | Observed build work |
| --- | ---: | ---: | ---: | ---: | --- |
| Fresh CMake Release | 38.992 | 224.190 | 1.974 | 0 | 42 unit compiles, link, bake/check |
| Unchanged CMake Release | 0.073 | 0.062 | 0.014 | 0 | No Ninja work |
| Standalone-TU edit/rebuild | 1.116 | 0.989 | 0.093 | 0 | One unit compile, link, bake/check |
| Legacy engine, same restored sources | 38.800 | 224.216 | 1.901 | 0 | 42 unit compiles, link, bake/check |

`observations.tsv` transcribes these values from `clean.log`, `noop.log`,
`edit.log` and `legacy.log`. These are **not medians, confidence intervals or
a statistical speedup/regression claim**. The two fresh-build observations do
not establish a throughput difference.

The no-op Ninja journal is byte-identical before/after, as are the retained
compiler/compile-command file-stat snapshots. The edit log has three build
steps: the standalone unit, the link and the post-link step. Its Ninja journal
also records the post-link output's absolute-path alias; that extra row is not
another bake.

## Release artifact parity

The clean CMake executable, the executable after the whitespace-only edit, and
the legacy-built executable have SHA-256:

```text
3d7a5126fa95d8061cc084b38d2ccf12b952776317bd56931e1cc128ae504d8c
```

`parity.result` records `cmp_exit_status 0` for the complete clean-CMake and
legacy executables. The CMake file-stat receipt records 50,695,610 bytes.
This establishes whole-file code/layout/size identity for the measured
production variant, rather than inferring equivalence from a subset of
sections. It is not a parity claim for every other build setting or a new
generated-program benchmark campaign.

The binaries are not vendored here; their digests and comparison result are
retained. Both remain in the private measurement workspace named in the
receipts.

## Host, tools and coordination

`metadata.txt` records Linux on Benchpress's AMD Ryzen 7 9700X, official
Clang 23.1.4, system CMake **4.4.4** and Ninja **1.13.2**, tool paths and the
CMake/Ninja binary hashes. CI used pinned CMake 4.4.3; this is explicitly a
different compatible CMake version. Both engines selected `/usr/bin/wild`;
its version was not captured.

The production variant is Release, `znver5`, debug information off,
sanitizers/fuzz/PGO off, baking on, and automatic linker selection. The
exported effective compile flags are retained as NUL-delimited `flags.argv`.
Commands were pinned to CPUs 0-7, with eight compile jobs (the legacy engine
derives its physical-core budget from the same affinity). This is a
parallel-build observation, not a single-core CPU-2 benchmark.

Each phase was invoked in a **separate** shared-lock hold:

```sh
EXCLUSIVE_OWNER=devin-review-1191 \
EXCLUSIVE_TITLE='PR1191 build timing/parity' \
EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1191 \
~/buster-fast-bench/exclusive.sh bash -c '<corresponding phase body>'
```

The exact bodies are `phase1.sh` through `phase4.sh`; `TIMEFORMAT` and the
timed commands are inside those bodies, after lock acquisition. Source
unpacking also used a separate preparation hold. No holder was preempted and
no lock was held around the series.

## Reproduction

On the approved host, create the private source/receipt paths specified in the
phase bodies. Populate the source with
`git archive 738f297ba6aa55ef18aed2f5b0237bbbf108762a` from Buster. Populate
`receipts/legacy-build-main96.sh` with
`git show 96b6cbcd122ffdc45700cf01d6e8adb40a81243c:build.sh`, and provide the
retained `source-paths.argv`. Execute the four phase bodies in order, each
through its own `exclusive.sh` invocation above. The first requires no
existing `build/`; the fourth replaces only this private snapshot's generated
build outputs. Read the bodies before adapting their fixed paths.

Do not rerun measurements just to reformat this report; the observations and
journals here are frozen receipts.

## Limitations and privacy

- There is no repeated, randomized, cache-controlled timing campaign. Other
  queued work ran between the separate holds. No small clean-build timing
  difference is interpreted.
- The governor snapshot was captured inside phase 2, not phase 1: CPU 2 was
  `performance`, the other selected CPUs `powersave`. No governor or host
  setting was changed.
- The explicit inner `held=1` receipts were added after phase 1 had started,
  so `lock-receipts.log` covers phases 2-4 only. There is no retrospective
  phase-1 lock receipt.
- There is no pre-build full source manifest. The retained manifest is
  post-restoration and matches the named source archive; the recorded edit is
  the sole source modification in the phase bodies. The added legacy script
  and generated build files are not tracked-source manifest entries.
- Outer SSH/lock-wait logs are deliberately excluded: their holder blocks can
  contain other sessions' private links and commands. Inner phase outputs
  were captured independently, not produced by a lossy filter of those logs.
- Correctness/current-main integration and CI qualification are recorded in
  the compiler PR's reviews; these timing observations do not replace them.

## Provenance and licensing

The retained legacy script and translation-unit snapshots are original Buster
material at the revisions above and retain their notices. Original report and
execution-provenance material uses the project default
Apache-2.0 WITH LLVM-exception terms. Clang, CMake, Ninja, wild and system
libraries were external build/runtime tools, not incorporated tool binaries.

Agent: current Devin Desktop review-and-merge session; runtime session ID and
private share URL are not exposed.
Model: Cognition / Fusion (GPT-6.1 Sol High Thinking + SWE-2 High).
