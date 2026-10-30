<!-- SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception -->
<!-- Copyright (c) 2026 David Gonzalez Martin. -->
# Rescued #126: main.c selective versus all-definition lowering

On the locked Ryzen 7 9700X, selecting referenced definitions saved a median
**20.883 ms (6.963%)** in the warm lowering/object-in-memory phase of the real
main.c unit. The selected/all phase medians were **278.939 / 299.962 ms**.
The process-median saving interval was **20.765–21.489 ms (6.919–7.150%)**,
with 98.828125% nominal binomial coverage over 11 processes, each using 21
internal passes. This phase excludes checking/preparation, unwind generation,
optional emission verification and file writing; it is not whole compile time.

The measured source is
[`20e01cebc77a0142260f3e0a6b3e9c66228ef3bf`](https://github.com/buster14a/buster/tree/20e01cebc77a0142260f3e0a6b3e9c66228ef3bf)
([PR #913](https://github.com/buster14a/buster/pull/913)). All four standalone
hardware own-main gates and all 11 benchmark processes exited 0. Earlier
`ba2d8a33`/`417a0897` attempts are not final qualification or timing samples.

## Scope and acceptance

The [original cloud claim](https://github.com/buster14a/buster/issues/126#issuecomment-6470476837)
continues [#129's remaining main.c comparison](https://github.com/buster14a/buster/issues/129#issuecomment-6482214491):
lower every emit-capable definition, including header intrinsics for features
the unit's `znver5` target lacks, then report defined/lowered/skipped counts and
saved time on the locked Ryzen 7 9700X. The real section pragmas and file-scope
assembly remain in main.c. [#619](https://github.com/buster14a/buster/issues/619)
must stay accepted. [#418's receipt](https://github.com/buster14a/buster/issues/129#issuecomment-6411420475)
records the earlier symbol/reachability implementation; final regression evidence
must preserve it. Separately owned #113 is outside this rescue's remaining scope.

## Final identities

| Item | Final value |
| --- | --- |
| Buster source commit | `20e01cebc77a0142260f3e0a6b3e9c66228ef3bf`; exact public Git source |
| Reproducible `git archive --format=tar` | 37,396,480 bytes; SHA-256 `47ab326dbcd45043b826f14515c69194c1cfb45873c8bbd405e78bf8939e4355` |
| Tracked-source/input integrity | [source inventory](hardware/source.sha256); checked before/after campaign and final status 0 |
| Exact measured hardware compiler | 39,110,547 bytes; SHA-256 `04560fb216755aa152b91f634c92e79175e492acd313991009c2e0429f7f4a68`; private payload |
| Clang | Official 23.1.4, LLVM commit `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`; executable SHA-256 `c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67` |
| Official toolchain archive | `LLVM-23.1.4-Linux-X64.tar.zst`; pinned SHA-256 `efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378` |
| Linker | Wild 0.10.0; SHA-256 `8446253a800c27c5312e85fc95288ddc1b965a7f2f6b5805255eb8323daf9c51` |
| Complete argv/source inputs | [NUL compile argv](hardware/compile-flags.argv0), [build sources](hardware/build-sources.argv0), [dependency hashes](hardware/main-inputs.sha256) |
| Private preprocessed snapshot | 6,581,074 compressed bytes; SHA-256 `7fdf827765903b13315c62afd3b06a7982192a462ded50563e0d9e5d031281d3`; [uncompressed digest](hardware/main.preprocessed.sha256) |
| Host | Ryzen 7 9700X, microcode `0xb404038`, Linux `6.18.50-2-lts`; CPU 2, sibling offline, performance governor |
| Build/environment | [build log](hardware/build.log), [host/toolchain receipt](hardware/host-toolchain.txt), [exact environment harness](harnesses/hardware-env.sh) |

The requested build uses `-O3`, `BUSTER_HOST_ARCH=znver5`, no debug information,
sanitizers or fuzzing, and `SOURCE_DATE_EPOCH=1792454400`. The final captured argv
and environment, rather than this description, identify the actual build/input.
The compiler, actual objects and mixed preprocessed snapshot remain private;
their hashes, sizes and retention paths are in
[hardware/private-artifacts.tsv](hardware/private-artifacts.tsv). No public
binary release is claimed. The source is reproducible from the public Git SHA;
the local `git archive` hash is not a claim about GitHub-generated archive bytes.
The mixed `main.preprocessed.c.gz` snapshot has an explicit **PRIVATE**
disposition: retain it on the measurement host and publish its digest, input
inventory, package versions and applicable copied notices. Do not upload it.
The final 378 external header identities byte-match the
[mechanical notice audit](external-inventory/README.md); the
[final comparison receipt](hardware/curation.json) records that check.

## Functional qualification

| Gate on the final frozen source | Result / raw evidence |
| --- | --- |
| Standalone hardware main.c checker | Exit 0; [raw log/status](hardware/gate-check.log) |
| Hardware selected / all `--verify -c` | Both exit 0; 35,327,656 / 40,446,704-byte objects; hashes/section/symbol receipts retained |
| Standalone hardware main.c symbols | Compared 1/minimum 1; zero unexplained/unsupported/failures; [raw result](hardware/gate-symbols.log) |
| Local full checker | 539,366 checks, zero failures; [exact local packet](local/README.md) |
| Local selection / intrinsics / call graph | 3,990,695 selection checks, 56 Clang comparisons; 489 intrinsic-code cases/492 checks; zero failures/forbidden cycles |
| Local pinned c-testsuite | 220/220 passed, zero unsupported/failed/not run |
| Local frozen musl symbols | 496 compared/minimum 354; zero unexplained/failures; 78 named refusals explicitly retained |
| Local frozen SQLite symbols | One compared/minimum one; zero unexplained/unsupported/failures |
| Exact-source CI | [Tests/native/protected aggregation](https://github.com/buster14a/buster/actions/runs/41051382107), [storage policy](https://github.com/buster14a/buster/actions/runs/41051382118): success; [job receipts](ci/README.md) |

The benchmark builds object bytes internally but does not write an object.
Actual object and symbol gates are therefore separate. The complete checker and
corpus counts above are local; complete hosted/native correctness is separately
recorded in CI, not invented as another manual hardware rerun. Native execution of AMX,
AVX512-BMM or another absent ISA is **not claimed** by emission, byte-oracle or
ABI transport qualification on a 9700X. Completed historical parser corpus and
mutation evidence remains pinned to its original compiler; this record does not
claim to rerun it or complete #113.

## Counts and warm post-checking result

| Definitions | Defined | Selected/lowered | Selected/skipped | All-mode lowered |
| --- | --- | --- | --- | --- |
| Functions | 15,489 | 10,098 | 5,391 | 15,431 |
| Objects, including retained literals/compound literals | 161,056 | 124,950 | 36,106 | 161,056 |

The 58-function gap in all mode is exactly its inline-only external eligibility
policy: `15,489 - 15,431 = 58`. These bodies are checked but not locally emitted,
under C's inline linkage contract. Every object is included. The
[source-only policy audit](INLINE-POLICY.md) gives the exhaustive condition;
it makes no guesses about the excluded names. Unsupported ISA/header definitions
are not an additional all-mode filter.

| Metric | Median | Process-median interval | Min–max |
| --- | --- | --- | --- |
| Referenced definitions, ms | 278.939083 | 278.829899–279.328303 | 278.515068–280.070506 |
| All emit-capable definitions, ms | 299.961666 | 299.789143–300.546985 | 299.475915–302.228027 |
| Paired saved time, ms | 20.882761 | 20.764750–21.489129 | 20.646016–22.157521 |
| Paired saved percentage, `(all - referenced) / all` | 6.963378% | 6.919437–7.150007% | 6.894049–7.331392% |

There are 11 fresh processes, each with 21 alternating passes after warm-ups.
The central binomial median interval uses ranks 2 and 10 and has 98.828125%
nominal coverage under independent, identically distributed process observations.
Each observation is a process's internal median for a mode. Savings and percentage
are computed within each process, then summarized across processes; the difference
of the two headline medians is not the paired-saving statistic. Internal samples
are not printed, and the interval does not reconstruct their distribution.

Each process checks/prepares main.c and warms both paths outside the interval,
then alternates referenced/all order. Timing includes selection, lowering, Tier 0,
branch sizing/encoding/link code, static-data publication, section/symbol work and
building object bytes in memory, then restoring arena marks. It excludes
preprocessing, checking, prepared program/static-data construction, outer/per-file
arena reservations, warm-up, **unwind generation, optional emitter verification** and
file writing. The pinned benchmark explicitly passes `unwind=false, verify=false`;
see [METHOD.md](METHOD.md) and its source links.
Internal emitter arena allocations/releases remain measured.
These are **warm post-checking savings**, not whole-compilation savings. Any
whole-driver observations must be reported separately with their own commands,
statuses and intervals; none is claimed here.

The in-memory benchmark objects are 34,266,000 / 39,027,752 bytes. The separately
verified CLI objects are 35,327,656 / 40,446,704 bytes and contain unwind sections.
Their byte sizes and acceptance receipts must not be substituted for one another.

The main.c-only command must report one measured file and zero failures. A
multi-file command can succeed while omitting rejected/unsupported inputs; it is
not a substitute. The benchmark checks repeated counts and object size, not
byte identity or instruction arithmetic.

The [raw hardware packet](hardware/README.md) includes all 11 process logs,
statuses and the [exact summary](hardware/postcheck/summary.tsv), reproduced
offline byte for byte. Source, executable and input hashes checked before/after,
and the final integrity status was 0. Every benchmark process took its own host
lock and ran on CPU 2. See [REPRODUCE.md](REPRODUCE.md) for commands, [PROVENANCE.md](PROVENANCE.md)
for artifact/source licensing, and [harnesses/SHA256SUMS](harnesses/SHA256SUMS)
for the copied tools. No synthetic reader-control data is a timing observation.
