# caef native MSan varargs failure and bounded diagnostics

The hosted native O3 MemorySanitizer job failed with a real uninitialized-value
report in `test-builtin-varargs-lower`. One later local focused run did not
reproduce it. This packet preserves both outcomes, the stopped first local
attempt and a separate descriptive IR compile. It identifies no cause or
functional fix and establishes no current CI pass, broader detector qualification,
target-runtime equivalence or performance result.

Every executed composition here is pinned to Buster commit
`caef4ea2cd1f47311842b2c1a4f87e55f14c29ea`, tree
`dfd8d9fb2034f8fefc962277bfae61d8e868c989`, with 810 tracked source files and
no functional source overlay. Other revisions are not relabeled failed merely
because the varargs test source is identical. Placement work is outside this record.

| Phase | Actual outcome | Boundary |
| --- | --- | --- |
| Hosted Intel native O3 MSan | Varargs 922 checks / one failure; child exit 86; overall 94 parallel commands, 93 pass / one fail | Real hosted failure remains failed |
| Local reproduction v1 | One build deliberately stopped at exit 143 after discovering fallback scheduler use; zero focused tests | Unqualified scheduler attempt; not an observed compiler/MSan fixture failure |
| Local reproduction v2 | One official 41-unit build exit 0; one focused run 1,315 checks / zero failures; unconditional audit 0 | Different Ryzen/native executable and execution environment; hosted failure not reproduced locally |
| Qualified IR v2 | One backend-TU compile exit 0, explicit EmeraldRapids target; LLVM text only | Descriptive inspection; no linked image or target execution |

## Hosted failure and collection

The original run is [41087828004](https://github.com/buster14a/buster/actions/runs/41087828004),
job [124183473965](https://github.com/buster14a/buster/actions/runs/41087828004/job/124183473965).
The raw log identifies Intel Xeon Platinum 8573C on Ubuntu 26.04. Its native
driver target is EmeraldRapids; the retained 41-unit compile stream uses
`-march=native`, O3, MSan with origins level 2 and line tables. Artifact
12995398741 has 22 members, listed under `inspection/`. All 21 retained text
members compare exactly to that ZIP; the compiled expected-failure probe and
the ZIP containing it are omitted.

The actual report is
`raw/artifact/_temp/sanitizer-reports/report.74335`, SHA-256
`d91b5bf627a809b31d715dabfa354d7237b9d200d0d8c1f57953b911ea79938c`.
It reports the scalar expected-value use at source line 485, a stored-origin
path through line 484 and an allocation origin in the shape oracle at line 522.
That origin is not itself proof of the corruption point or a padding cause.
Expected detector-probe reports are retained separately from this real report.

The first log download refused terminal escapes and left an empty file; that
file is retained alongside the separately collected byte-exact raw log. An
initial direct JSON-array read of the Clang `-MJ` stream failed on its fragment
format. Those are collection/inspection events, not extra compiler attempts.
The original stream is unchanged; the normalized inspection copy is separate.
This varargs failure is distinct from the historical source-674 musl timeout.

## Local attempt boundaries

V1 placed `cores` inside an `env -i` boundary without `XDG_RUNTIME_DIR`, selecting
the fallback `/tmp` queue rather than the shared scheduler. After detecting it,
the owner stopped the exact build process with TERM; the original session
returned 143. No focused varargs command or test audit ran in v1. The fresh
detector observed fatal symbolized MSan exit 86, but its fallback context is
not described as a qualifying shared-scheduler grant. Original source/tool
checks, unsorted-versus-sorted symlink inspection and the erratum remain visible.

The separately authorized v2 uses genuine shared `cores` outside the clean
environment. Its single build held ticket 682, three physical cores, with
observed affinity CPUs 2–4,10–12. All 41 actual records use official Clang 23.1.4,
O3, MSan/origins 2, line tables and native targeting. The new compiler hash is
`b4641be24f4dc3d5aaba6fc44911ccf71eaf91e924681f8776fb8cd81b6a574e`
(184,825,744 bytes). The build's 267.4-second report is construction information,
not a compiler-throughput sample.

A fresh existing CI probe verified fatal symbolized exit 86. Exactly one
`./build/compiler test-builtin-varargs-lower` command then returned 0 with
1,315 checks / zero failures, under a 60-second inner limit. The existing
sanitizer audit ran unconditionally and returned 0 with no real-suite reports.
Separate fast runtime calls have no invented instantaneous ticket/affinity
snapshot. Fatal runtime policy and exact selected environment remain recorded.

Postchecks verify all 810 source hashes, the new binary and the complete official
toolchain: 9,177 payload files plus two known completion markers, 9,179 regular
files total and four symlinks. No source delta, skip, suppression, second focused
run or replacement success is claimed. Prepared-only scope files remain exact;
actual launch/completion records and final summaries govern what ran.

The local machine is Ryzen 9 7940HS/native on CachyOS/glibc 2.44. It differs from
the failed Intel/EmeraldRapids Ubuntu host and its four-CPU parallel correctness
job. Equal source commit and official Clang release do not make these the same
host, binary or execution. Local 1,315/0 does not repair hosted 922/1. Independent
actual CI/runtime receipt review cleared those recorded scopes; exact package
preservation review is a separate check.

## Descriptive IR inspection

The qualified IR compile uses the actual backend TU
`src/buster/compiler/main_unit_backend.c`, blob
`68842840e569e72896ffdf08dd465057dd1409b3`, with the recorded O3/MSan flags and
explicit `-march=emeraldrapids`. Shared ticket 683 and the owned timeout process's
affinity were observed. Original session 79255 was resumed to exit 0; no queued
command was relaunched and no elapsed/CPU timer is inferred from polling.

The 195,039,427-byte IR has SHA-256
`bf0e52170ce36d9c4edb816bd1742ff5ad7395bb68aa635f1e8664a84b135a2b`.
Its bytes remain external. Seventeen frozen metadata/context files plus a mode
ledger retain exact argv/status/source/tool/scheduler provenance and bounded
first-party IR/source excerpts. Their notes distinguish the Aligned temporary
from High's padding and follow selected caller/callee shadow operations. These
are static observations, not proof of runtime corruption, source UB, a compiler
defect, a JIT ABI defect or a justified sanitizer workaround.

The earlier wrong-driver-TU IR compile and fallback scheduling remain separate
unqualified history. Its 52,464,073-byte IR is omitted with its hash. Optional
`shadow_standin.c` was prepared and statically reviewed only, never compiled or
executed; its source bytes are omitted with identity and scope. The recorded
restriction on further runtime/compilation was honored. No linked EmeraldRapids
image, executable probe or target run followed this IR operation.

## Reading and verification

All 138 included original files compare byte-for-byte to their local owning
paths in `raw-copy-verification.tsv`; `raw-files.sha256` binds those copies.
Run `sha256sum -c package.sha256` from this directory for the portable package
check. Original manifests remain unchanged; [CURATION.md](CURATION.md) names
their required CWDs and intentional omitted payloads. See
[OMISSIONS.md](OMISSIONS.md) and [PROVENANCE.md](PROVENANCE.md) for dispositions
and terms. No compiler, control, archived program, remote operation or campaign
was rerun to prepare this packet. Source fixes and their landing are separate.
