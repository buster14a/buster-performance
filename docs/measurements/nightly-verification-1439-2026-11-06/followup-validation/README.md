<!-- SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception -->

# Corrective changes and hosted validation

This record follows the frozen [November 6 production-cycle audit](../README.md)
for [buster #1439](https://github.com/buster14a/buster/issues/1439). These are
GitHub-hosted correctness results for corrective pull requests. They are not a
new enabled nightly cycle or native benchmark measurements.

## Historical worker windows: #1510

[Buster PR #1510](https://github.com/buster14a/buster/pull/1510), head
`b4762e960b4ef2dd4760393b5bb0cbd5e708dfda`, addresses
[#1504](https://github.com/buster14a/buster/issues/1504). Its coordinator reads
each immutable target's declared admission hours, considers later eligible
states, and preserves early, expired or unknown states in the backlog. It also
uses the selected worker's deadline for snapshot reservation and substitution.
The current 08:00 Madrid cutoff, worker guard, source provenance and lock remain.

| Hosted check | Result and retained log |
| --- | --- |
| [Nightly decisions/glue](https://github.com/buster14a/buster/actions/runs/42195201387/job/127816608785) | Passed. [historical-window-nightly.log](historical-window-nightly.log) |
| [Evidence/cache regressions](https://github.com/buster14a/buster/actions/runs/42195201089/job/127816607815) | Passed; explicitly `hardware=skip (draft)`. [historical-window-evidence.log](historical-window-evidence.log) |
| [Live repository dry run](https://github.com/buster14a/buster/actions/runs/42195201387/job/127817480864) | Passed with `would-dispatch` actions and `done dry run`. [historical-window-dry-run.log](historical-window-dry-run.log) |

Both regression jobs ran `nightly --self-test` with **197 checks and zero
failures**, in optimized and AddressSanitizer/UndefinedBehaviorSanitizer builds,
then the full shell integration fixtures. The fixtures cover immutable window
extraction, unknown metadata, early/late and exact-boundary eligibility, waiting,
snapshot reservation, handoff, duplicate admission protection and both Madrid
clock changes. Independent static review identified a missing in-flight fact in
one new fixture, which was corrected before publication; no production-code
finding remained. The larger hosted compiler matrix is separate from these
focused results.

## Shared-libc input: #1508

[Buster PR #1508](https://github.com/buster14a/buster/pull/1508), head
`7a0a7a8342a3f6d4049f4828b4898eff24e97ade`, addresses
[#1505](https://github.com/buster14a/buster/issues/1505). It retains mapped-libc
preference for dynamic hosts, adds discovery through the linker's existing
runtime directories and authoritative `--libc PATH` selection, validates the
input before sampling, and preserves failure diagnostics across cleanup. The
five file-operation measurements remain present; candidate code is not executed.

The hosted jobs tested merge `8e25591dbf8951667f51abfaf71bc72827286bf5`, combining
that PR head with base `76cc508699e6ca0580619be36b9cd6c3a9cb7559`.

| Hosted check | Observed linkage and discovery | Result |
| --- | --- | --- |
| [Native shard 4](https://github.com/buster14a/buster/actions/runs/42195150005/job/127817319480) | `static: TRUE`; runtime library directories | **27 checks, 0 failures**; job succeeded |
| [Baseline x86-64 shard 4](https://github.com/buster14a/buster/actions/runs/42195150005/job/127817319637) | `static: FALSE`; `/proc/self/maps` | **27 checks, 0 failures**; job succeeded |

The [receipt manifest](static-libc/manifest.json), [static-host excerpt](static-libc/native-static.log)
and [dynamic-host excerpt](static-libc/x86-64-dynamic.log) retain source identities,
original log line ranges and the successful 32-command shard conclusions. The
corresponding full job metadata is retained alongside them. Omitted excerpt
lines do not establish that an event or diagnostic was absent.

All eight hosted compiler shards passed. The [completion receipt](static-libc/completion.json)
records their final job statuses and the separate draft-only hardware
qualification failure.

The plain baseline rows use the frozen dynamic host runtime, so this PR's
hosted matrix exercises both linkage modes. Native shard 4 selected the scalar
host fallback on its assigned CPU; vector compilation was separately confirmed
in the other native shards. This does not claim execution of the timed vector
benchmark. The fixtures also check explicit-input precedence, missing and
invalid files, path bounds, nonregular inputs, truncated or incompatible ELF
headers, and discovery preference without dependence on the host's mapping.

The guide-size check initially failed because the command-index addition took
`AGENTS.md` from 29,999 to 30,020 bytes. A compact index entry reduced it to
29,995 bytes, preserving both command names and the guide link. The corrected
head passed the guide-size, selector, DCO hook/audit and evidence/cache checks.
The full benchmark's CLI and timing paths remain outside this hosted proof.

## Acceptance boundary

The PRs remain drafts to keep their validation off the 9700X. Neither this record
nor their hosted checks proves the full timed floors command, a successful
comprehensive snapshot, native coverage of every pending main state or sustained
backlog capacity. Those need subsequent enabled cycles after the corrections
land. Old immutable revisions retain their own historical code; a current fix
does not silently rewrite their outcomes.

The existing aggregate qualification check intentionally fails a draft code
change when hardware qualification is withheld. For example, [#1508's aggregate](https://github.com/buster14a/buster/actions/runs/42195150005/job/127821097619)
reported successful hosted test/evidence results and `HARDWARE_REASON: draft`,
then rejected qualification for that reason. This is distinct from a regression
test failure; the hardware job itself was skipped.

The existing coordinator pending-record correction is already merged as
[#1506](https://github.com/buster14a/buster/pull/1506). Its earlier hosted proof is
retained in the parent audit's raw archive.

The logs and focused receipts preserve output from public GitHub Actions jobs,
including checkout identities, source job links and timestamps. No new external
code or benchmark corpus is imported. Hashes for the files in this directory are
in `SHA256SUMS`; the parent manifest continues to describe the frozen
production-cycle package.

---
Agent session: 01a1b01e-f9a7-752f-9ade-46286198507d (OpenAI session ID; no private session URL is exposed)
Model: OpenAI / GPT-6 Astra Pro

Implementation threads: 01a1b021-4d71-738d-87cf-6efc51310061 (historical windows),
01a1b021-8e3c-70e2-b299-8876b85b906e (shared-libc input). Independent review
thread: 01a1b021-bdad-733f-ba54-b4cbc8135073. All use OpenAI / GPT-6 Astra Pro
in the same parent session; no private session URLs are exposed.
