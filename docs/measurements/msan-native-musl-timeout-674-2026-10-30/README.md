# Native MSan frozen-musl timeout: one bounded source-674 diagnostic

The original hosted native O3 MSan frozen-musl command timed out after 1,800 seconds.
It **did not reproduce in one declared local diagnostic** on exact source 674 with
official Clang 23.1.4 and an explicit znver3/scalar host build. The historical timeout's
cause remains unexplained. This packet adds no source/workflow fix, timeout increase,
retry, full-suite rerun or current-head qualification.

## Keep the four records separate

| Record | Exact Buster source | Observation and scope |
| --- | --- | --- |
| Original hosted native MSan failure | `674ae159503b4b51f2c54865d9cfdd225e9d27a0` | The frozen-musl symbol command timed out at 1,800.0 wall / 1,710.0 CPU seconds; only inventory/selection 613 was printed. No actual-suite sanitizer report. |
| Same-source hosted baseline MSan control | same 674 | The same frozen command completed: 613 files, 496 file/object symbol-table comparisons against minimum 354, zero differences/failures. |
| New bounded local diagnostic | same 674, tree `f820406db7a81824f0cd9a20ce95b2841bfc6616` | All 613 files processed, 574 accepted, 496 generated-object symbol tables compared, 78 named unsupported cases, zero differences/failures. |
| Separate later-main context | `ecdb823f9a852a980f007ff3b3d886c86f1c564b` | [Run 41052106880](https://github.com/buster14a/buster/actions/runs/41052106880) has 18 green jobs on a different source/VM. That source predates and is not descended from ce1/#918. |

The first two byte-exact logs are `raw/job-124021316588.log` and
`raw/job-124021316531-x86-memory.log` from [run 41043235456](https://github.com/buster14a/buster/actions/runs/41043235456).
Their SHA256 values are respectively
`d93bcf533631c25e30e6a9a969911cf5539621d824713a41200f465313a27c3e` and
`e234133df988ed49eb38d79131fd4fd14ad2bb4545b819804165db6928677006`.
The later ecdb context log/JSON retain their own hashes and scope. Neither later success
nor the local diagnostic explains the old failure, attributes a fix to #918, or executes
current main (including the separately discussed 8cc head).

The original native job ran 92 commands: 91 passed and this one timed out. The artifact
retains no failed compiler executable, active-file/phase receipt or stack sample. Buffered
corpus output does not reveal how many files completed before the timeout. CPU consumption
alone cannot distinguish finite progress, a pathological path or a busy loop. The unchanged
corpus producer uses lanes=NULL/board=NULL/active=1, so #918's shared-board handoff repair
cannot be presumed to address this command. Owning-source/drift receipts remain in `raw/`.

## What actually ran locally

All 803 tracked source-file hashes matched exact 674 before and after the run; no source
patch was used. One compiler build used official Clang 23.1.4, release
`7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`, with all 41 units at O3 under MSan origins=2
and explicit `-march=znver3`, selecting scalar host algorithms. The compiler SHA256 is
`d8ae1c8b5eddab82dacc2e2a04279240e7d7151a9e0744ae44769af7b39b3a98`.
The official archive SHA256 is
`efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378`;
full staged-file/symlink identities, license, versions and independent verification receipts
are retained. The local system compiler was not substituted. The fresh approved uninitialized
canary produced a fatal exit 86 and a symbolized expected MSan report, separate from the
actual-suite report directory.

The frozen source command retains all original selection/options: `test-checker-corpus`,
`--clang clang`, `--symbols-minimum 354`, C99/freestanding flags, output target
`x86_64-linux-gnu/-march=znver5`, seven include directories and the original eight musl
source directories. `raw/failed-command-from-674.txt` preserves the hosted stanza;
`raw/controller-v2/run/events.txt` retains the actual local argv. Absolute local corpus
prefixes differ from the VM. No file/case filter or minimum was changed.

The runtime child alone receives `SOURCE_DATE_EPOCH=1792454400`. A fresh task-private cache
retains `BUSTER_ORACLE_CACHE=check`; the run reports 0 cache hits, 626 oracle runs, 0 stale
entries and 496 not kept. No shared cache is cleared. The C controller fixes its declared
environment and applies the unchanged CI fatal MSan policy through thin configure/source/
exec glue. Every command descendant is reaped through **ECHILD before audit**, and final
cleanup proves ECHILD again. The unconditional actual-suite audit is empty and exits 0.
Source, compiler, full toolchain, trusted-input, identity and cache postchecks all exit 0;
before/after identity manifests are byte-equal. Original command and controller final status
are both 0. Full actual status, command, progress and cleanup/event streams are retained.

| Observed local unit | Result |
| --- | ---: |
| Selected and processed files | 613 |
| Accepted by Clang and Buster | 574 |
| Files whose generated-object symbol tables are compared | 496 |
| Required minimum compared files | 354 |
| Named backend-generation unsupported files among accepted inputs | 78 |
| Symbol-table differences / unexplained differences / failures | 0 / 0 / 0 |
| Acceptance / diagnostic / path / resource / preprocessing differences or failures | 0 |
| Scalar / vector nodes reported | 562,069 / 0 |

The raw `symbols compared=496` label counts **files/object-table comparisons, not individual
symbols**. The 78 unsupported cases retain named reasons and are not test failures. This is
one unchanged selected command, not full compiler/sanitizer/fuzzer acceptance or proof that
all selected files generate code.

## Actual controller and lifecycle controls

The actual C controller source SHA256 is
`58fe115d765813b562fc4c7e0d74c4aa76c2e90ead8b4ae548030db4958b1da5`;
its executable identity is
`a2a9dc8407aeb61bddf261195491e9f0aab511ee805ac173070c7f5d92bdd32f`.
The C fixture, nine-line CI glue, exact utility build/outer calls and all eight controls
were independently reviewed before the one corpus invocation. Every control met its
expected lifecycle/status outcome:

| Control | Expected and observed final status | Purpose |
| --- | ---: | --- |
| exit7 | 7 | Preserve an ordinary nonzero command result. |
| escape | 124 | Enforce deadline and reap escaped process-group/session descendants. |
| orphan | 7 | Reap escaped descendants after the command itself exits. |
| signal | 143 | Distinguish signal death from an ordinary numeric exit. |
| exec-failure | 127 | Retain failed-exec stage/errno. |
| normal127 | 127 | Distinguish a successfully launched program that exits 127. |
| postfail7 | 7 | Preserve original failure despite a deliberately failing postcheck. |
| postfail0 | 1 | Prevent success when the command succeeds but its real postcheck fails. |

These are eight passing **expectations**, not eight exit-zero runs. Control directories
retain original/wait status, ECHILD, event-delivery and deliberate postcheck-failure receipts.
Tiny-call exact cores command text is retained, but separate instant grant tickets/affinity
snapshots were not captured; no rerun supplies them. For the actual corpus diagnostic,
`CORES=1`, held ticket 327 and owned-process affinity CPUs 2,10 are retained. The additional
cores snapshot was taken after release and is not presented as a live-grant record.

The earlier Bash controller and C supervisor performed identity/build/proof and two tiny
controls only; neither legacy corpus/run mode was invoked. They remain byte-exact with
`LEGACY-CONTROLLER-SCOPE.txt`. Frozen v2 README/control-plan documents retain their earlier
"prepared only" wording; actual launch/events/status receipts establish what subsequently
executed. No retrospective rewriting converts preparation into a run.

## Timing and environment limits

**59.227802826 seconds is the whole C controller interval**, including prechecks, cleanup
and postchecks. No exact final command-only wall/CPU timer was retained. Command-relative
progress snapshots reach 55.194 seconds, and the command finishes before its 240-second
diagnostic cap. No GDB attempt occurs because the 180-second sample threshold is not reached.
The cap changes no CI timeout. These observations are diagnostic execution facts, not
benchmark evidence or a comparison against hosted command timings.

The local Ryzen 9 7940HS/CachyOS/Linux 7.3.0-5-cachyos/glibc 2.44 machine, system headers,
loader/libraries, paths, fixed locale, private fresh cache and standalone one-core scheduling
differ from the failed EPYC 7763 VM's four-CPU parallel inventory. Explicit znver3/scalar
does not make the environments or binaries identical. Bounded process observation can
also perturb scheduling. `raw/diagnostic/LOCAL-DIFFERENCES.txt` records these boundaries.
The separate ecdb VM uses an EPYC 9V74 and different source; its green run completed later
but its source predates #918, so it supplies no causal repair attribution.

## Files and omissions

`raw/` contains byte-exact source/build/proof/controller/control/command/context receipts,
the 803-file source and toolchain/corpus/cache identity lists, and selected textual original
CI artifact entries. `raw-copy-verification.tsv` maps every copy to its original and SHA256;
`raw-files.sha256` checks those copies. `inspection/` contains only disclosed JSON/argv
renderings, selected first-party host-vector predicates and artifact-member checks.
`PROVENANCE.md`, `CURATION.txt` and `OMISSIONS.md` state origins, transformations and exclusions.
Use `package.sha256` for the included package; producer manifests preserve original paths
and identities, including omitted artifacts, and are not portable package checks.

Compiler/probe/controller/fixture/supervisor binaries, objects, source tar/tree, official
LLVM archive/toolchain payloads, frozen corpus bytes, cache/tmp payloads, mixed macro dumps,
unexecuted initial-review drafts and a superseded Python inspection helper stay local.
Only their relevant identities/manifests remain. No unrelated #883 performance prototype
work, new functional helper, compiler policy/DCO change or source/workflow change is added.
Public #815 followup and ownership release remain with the coordinating owner after publication.
