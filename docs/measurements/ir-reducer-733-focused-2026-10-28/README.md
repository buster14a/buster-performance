# Structural IR reducer: focused correctness and moved replay receipts

Companion evidence for [Buster #733](https://github.com/buster14a/buster/issues/733)
and draft [PR #753](https://github.com/buster14a/buster/pull/753).
This record archives completed local checks; publication runs no new compiler
test, replay, build or benchmark.

## Frozen adapter qualification

Both sanitizer adapters use the frozen source
[`e175decaf684ff1812673faf424424b7cbafe659`](https://github.com/buster14a/buster/commit/e175decaf684ff1812673faf424424b7cbafe659),
tree `4d80f373e0878405798657b474788fbb8adbb3b0`.
The complete qualification `src/` copy compares byte-identical to that
commit's `git archive` source. The full source archive SHA-256 is
`850032cfb211e2b3c2dcafc5a82421b43a1325009c8c65bef9efdc172bac7c44`.

| Completed command | Result | Exit |
| --- | --- | ---: |
| Native ASan/UBSan adapter build | Passed, warnings treated as errors | 0 |
| Baseline x86-64 ASan/UBSan adapter build | Passed, warnings treated as errors | 0 |
| Native `--seed 733 --count 64` | **197 checks / 0 failures**, leak detection enabled | 0 |
| Baseline `--seed 733 --count 64` | **197 checks / 0 failures**, leak detection enabled | 0 |

The retained [wrapper](adapter/reduce-tests.c) calls the real reducer/test
modules through the recovered [unity prefix](adapter/oracle-prefix.h).
It exercises built-in compiler predicates and driver publication/replay
controls. `generated=64` is the seeded-case count, distinct from 197 total
assertions. The logs retain expected negative-command usage and refusal
messages as well as the final passing count; those expected messages are not
removed or relabeled.

Original queued core-scheduled control attempts were cancelled with exit 143
before the final short bounded invocations. They are not passing runs. The
final recorded controls use `timeout 25s`, `ASAN_OPTIONS=detect_leaks=1`, and
`UBSAN_OPTIONS=halt_on_error=1`. See [commands.txt](commands.txt) for the exact
build, cancelled-attempt, final-run and replay commands.

## Moved replay

The native adapter first reduces the original volatile-memory fixture from
**2 blocks / 14 instructions to 1 block / 7 instructions**. Its complete
output folder is then renamed, and the saved recipe is invoked from the new
location with the same matching executable. That second run retains **1 block /
7 instructions**, reproducing the same classified failure **3 / 7 / 0**.

| Phase | Candidate work | Predicate checks | Failure | Status |
| --- | ---: | ---: | --- | ---: |
| Initial reduction | 66 | 7 | kind 3, pass 7, detail 0 | 0 |
| Recipe after moving the folder | 17 | 1 | kind 3, pass 7, detail 0 | 0 |

[moved-replay.log](logs/moved-replay.log), the canonical original/reduced IR,
both `result.json` records and the saved recipes are retained under
[bundle-moved/](bundle-moved/). Each JSON records `replayed: true`. This is the
original completed observation, not a new replay performed during publication.

## Separate integration syntax result

The whole-main syntax invocation passed with exit 0 through the core queue,
but read the mutable `work/733-resume/src` checkout rather than the frozen
adapter snapshot. Its checkout reflog records the clean main merge
[`01c1d533df991b9d138cb3654f9a308e9d0e4889`](https://github.com/buster14a/buster/commit/01c1d533df991b9d138cb3654f9a308e9d0e4889)
at `2026-10-28 23:09:33 +0100`; the syntax log records its core grant at
`23:12:01 +0100`. The author reports no intervening source edits, and the
checkout remains clean at that head. The command and retained
[reflog/log witness](identity/syntax-source-witness.txt) support attributing
this syntax result to that moving integration checkout. Its source was not
separately hashed at invocation. It is not a syntax result for frozen
`e175deca`, nor runtime qualification of the integration.

## Identities, scope and next action

- Executed native adapter SHA-256:
  `d92304d1a180ded3c30598c9d806fc9c3416f7ade1a5057be639c856809c7a85`.
- Executed baseline adapter SHA-256:
  `7acf8e54947bbfe33d18191c406b6330c316fbd9577d235f63c687cff17e15d6`.
- Original [source.sha256](identity/source.sha256) and
  [artifacts.sha256](identity/artifacts.sha256) are retained byte-for-byte.
- Installed local tool/host metadata captured for publication reports Clang
  23.1.4 on an AMD Ryzen 9 7940HS, Linux/x86-64. The original build commands
  name `clang`; the publication-time compiler hash is retained separately.
- The large executables and complete compiler source tree are omitted. Use
  the exact source commit and retained adapter bytes for reproduction.
- Raw build/syntax logs contain core scheduler lines only. Their hashes are
  retained; unrelated queue metadata is not republished. Run logs remove
  only any `cores:` lines, retaining every compiler result line.

These focused `e175deca` runtime results do not qualify PR #753's later
`01c1d533` integration. The author/reviewer next action is exact integration
CI and review of the bounded built-in reducer and replay/publication contract.
Full-build, native-hardware, performance, merge-ready and full issue-completion
claims are outside this record. External-process predicates and the optional
#731 adapter remain separate work. See [PROVENANCE.md](PROVENANCE.md).
