# Exact-source hosted qualification — PR #3654

This supplement records completed hosted correctness for [PR #3654](https://github.com/buster14a/buster/pull/3654),
following the development evidence published at performance commit
`7ed889b6f5b939a65565585532ba94616086260b`. Its compiler is the newly built hosted
Release product, not the earlier local Debug executable described in that package.

The previous head `1eb198e` passed hosted correctness and self-host qualification;
its separate Build workflow was **superseded and cancelled** when fresh main was
merged. Its frozen supplement remains prior-head evidence. This directory records
the subsequent head and must be assessed by its own run links and source identity.

## Tested source

- PR head: `424417e5c33d0aa9c671ec0e530a75f2c6529cf5`.
- Workflow checkout: synthetic PR merge `fd50d1860b30332987d0add3df40df8ec5e9df24`.
- Both have the same source tree: `44d0938f11936a12161fa7e28bb5fd609f6c1f61`.
- The merge parents are main `74eacd4744a8131ba4c1a5bd8ad87b89ec0f7dbe` and that PR head.

The checkout SHA appears in the job logs. GitHub's Git commit endpoint independently
records the matching tree and parents; `source-and-jobs.json` preserves that response
and the relevant completed job metadata. This qualifies the exact submitted source
tree against the stated base.

## Hosted correctness

[Tests run 45803637857](https://github.com/buster14a/buster/actions/runs/45803637857)
passed, including its four real correctness shards,
[row verdict](https://github.com/buster14a/buster/actions/runs/45803637857/job/139858656689),
and [integration qualification](https://github.com/buster14a/buster/actions/runs/45803637857/job/139858752435).

| Shard | Commands | Passed | Failed | Skipped | Not started | Hosted CPU model | Permanent job link |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- |
| n1, producer | 42 | 41 | 0 | 1 | 0 | AMD EPYC 9V45 96-Core Processor | [139853879871](https://github.com/buster14a/buster/actions/runs/45803637857/job/139853879871) |
| n2 | 38 | 38 | 0 | 0 | 0 | INTEL(R) XEON(R) PLATINUM 8573C | [139853880056](https://github.com/buster14a/buster/actions/runs/45803637857/job/139853880056) |
| n3 | 66 | 66 | 0 | 0 | 0 | AMD EPYC 9V74 80-Core Processor | [139853879823](https://github.com/buster14a/buster/actions/runs/45803637857/job/139853879823) |
| n4 | 22 | 22 | 0 | 0 | 0 | Intel(R) Xeon(R) 6973P-C | [139853879953](https://github.com/buster14a/buster/actions/runs/45803637857/job/139853879953) |
| Total | 168 | 167 | 0 | 1 | 0 | | |

The single skipped row repeats the unity-ownership check that already passed on the
producer's build tree. Its raw skip message is in `ownership-reuse.log` and the
producer's actual successful check is in `build-dependencies.log`.

All four machines reported Ubuntu 26.04.1 on the `ubuntu-26.04` GitHub-hosted image
and four available CPUs. The shared build used `BUSTER_HOST_ARCH=vector`, Release
`-O3`, `BUSTER_SANITIZER=none`, and `BUSTER_DEBUG_INFO=0` (`vector-g0`). Host compiler
and oracle were pinned LLVM/Clang 23.1.4, revision
`7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`, targeting
`x86_64-unknown-linux-gnu`. The producer used `ld.lld` and a static compiler.
`runner-configuration.log` and `host-cpus.log` retain the corresponding raw records.
These are hosted functional checks; the elapsed-time fields remain only in raw logs.

## Runtime and build-dependency results

`runtime-fixtures.log` contains the complete timestamped test group:
**128 checks, 0 failures**, executed on shard n4. It includes selected-root sources, companions and digests;
missing/malformed/duplicate/orphan inventories; live expected-data mutations;
data-only added cases; required named coverage; both preprocessor option-boundary
controls; shared driver references; and the suppress-recovery root, missing-source
and restoration controls.

`build-dependencies.log` contains the complete producer ownership step and its output
through the final restoration check, before product packing. On Buster's actual
Release build graph, unchanged data, input edits, expected-output edits, catalog
metadata edits, an added source/expectation/catalog row, and restored originals each
schedule **0 compile, 0 link and 0 bake commands**. The positive IR runner edit
selects only its BACKEND owner followed by link and bake; that positive plan is
checked without executing it. This is the actual-build counterpart to the earlier
tiny-graph helper controls.

The exact-source [self-host workflow](https://github.com/buster14a/buster/actions/runs/45803637310)
also passed, including the [actual bootstrap/probe job](https://github.com/buster14a/buster/actions/runs/45803637310/job/139853571184)
and its [row verdict](https://github.com/buster14a/buster/actions/runs/45803637310/job/139858485618).
The separate [Build regressions workflow](https://github.com/buster14a/buster/actions/runs/45803637355)
is still in progress at preparation time; no completion is claimed here.

The [9700X job](https://github.com/buster14a/buster/actions/runs/45803637857/job/139858753649)
was skipped. No hardware benchmark or new sanitizer run is claimed by this supplement.
The integration log explicitly records hosted correctness, analyzer and policy
results and the skipped hardware/fuzz/benchmark routes.

## Raw evidence and extraction

- `runtime-fixtures.log`: one complete correctness log group, unchanged from shard n4 job 139853879953.
- `build-dependencies.log`: contiguous ownership/dependency command output from producer job 139853879871, ending immediately before the pack step.
- `ownership-reuse.log`: the complete skipped duplicate-ownership group and its reason.
- `correctness-summaries.log`: each shard's final `parallel:` result line, with job URL headers added to identify its source.
- `runner-configuration.log` and `host-cpus.log`: selected unmodified configuration and CPU lines, grouped beneath added job headers.
- `integration-qualification.log`: contiguous qualification command/output from job 139858752435.
- `source-and-jobs.json`: Git commit response plus selected job metadata from GitHub's API.
- `qualification-jobs.json`: completed correctness, integration, self-host and policy jobs, plus the explicitly skipped 9700X job, with their step conclusions.

Timestamped lines, test output and counts were not rewritten. The supplement omits
checkout/authentication scaffolding, unrelated suite output, binary products and
temporary artifact-download URLs. Permanent run and job links above identify the
full original logs. `SHA256SUMS` covers the supplement's packaged files.

Session: `6b07f058-e5f4-83ed-b42f-8d487dbec053`; model: OpenAI / GPT-6 Astra Pro.
Collected by `/root/checker_audit`, with integration and publication by `/root`.
