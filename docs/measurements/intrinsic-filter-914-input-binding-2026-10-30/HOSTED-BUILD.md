# Controller-only hosted build route — preparation only

This addition prepares a new ordinary GitHub-hosted build after the prospective
target-tool pin correction. The full original protocol was reviewed at
`0ead6f9a5f136039c15f28b56dd92d846a5ef04a`; its original 611-line source and
first build at `66149e3b47205b16f70ad2f5899baaa8c4c5e0d3` remain historical.
The current 613-line source changes only three recording-host hash constants
and comments; offline-analysis identities remain separately documented.
No build result or executable hash exists for this corrected source. Review of this
exact workflow/recipe commit must precede root's go-ahead and any push that
would trigger it. This is an internal scoped build gate, not another request
for user permission.

## Why this isolated route

The current performance repository has no existing hosted controller build.
Buster's `9700x.yml` includes project correctness, sanitizers, benchmarks and
native hardware work, so dispatching it would exceed this purpose. The new
`.github/workflows/914-controller-hosted.yml` instead has exactly one
Ubuntu 26.04 GitHub-hosted job, triggered only by a normal push to the reviewed
`codex/prepare-914-controller-build` branch. It has no PR trigger, dispatch,
schedule, matrix or self-hosted job, and its sole permission is `contents: read`.
It also refuses a non-GitHub-hosted runner or another repository/ref/event.

**Do not push this branch yet.** Root will authorize that ordinary hosted build
after independent exact-workflow review. No push, CI execution, artifact upload,
physical-host staging, lock/core allocation, controller execution or measurement
has occurred for this corrected preparation. Original run 41105728145 completed
only the earlier controller build, with inert ELF SHA256
`a6b580585e2c77c7b2fe66281a25072359a95cca5a829a1bd1a62bd0f810430d`;
that artifact was never executed and does not bind the corrected source.

## Approved tool and action identities

The LLVM acquisition and license facts are a minimal adaptation of Buster
`tools/ci/setup-hosted.sh` at reviewed source
`caef4ea2cd1f47311842b2c1a4f87e55f14c29ea` (blob
`01420cdcf08c6a8e54e3e5a285e52d3b01f55a3c`). Action pins come from that source's
`.github/workflows/9700x.yml`. No download ID, version or checksum was invented:

| Item | Exact identity |
| --- | --- |
| Official compiler | LLVM 23.1.4 Linux X64 release |
| Archive URL | `https://github.com/llvm/llvm-project/releases/download/llvmorg-23.1.4/LLVM-23.1.4-Linux-X64.tar.zst` |
| Archive SHA256 | `efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378` |
| License URL | `https://raw.githubusercontent.com/llvm/llvm-project/7a941dfb2877a0b8cf30323fefa85ad019e0b0f5/llvm/LICENSE.TXT` |
| License SHA256 | `8d85c1057d742e597985c7d4e6320b015a9139385cff4cbae06ffc0ebe89afee` |
| Checkout | `actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10` (v6.0.3) |
| Artifact upload | `actions/upload-artifact@ea165f8d65b6e75b540449e92b4886f43607fa02` (v4.6.2) |

Only clang/clang-23 and its resource headers/runtimes are extracted, with the
approved `zstd -d --long=30` archive handling. Disposable-runner packages are
limited to GCC/binutils/libc development files/zstd and the approved compiler's
libstdc++, zstd, XML and zlib runtime/development dependencies.
There is no Buster checkout/build, oracle, perf installation or invocation,
sanitizer/fuzzer setup, alternative-linker download or sysctl/host setting
change. Package versions, actual tool bytes and compiler/linker runtimes are
recorded rather than mislabeled immutable package-version pins.

The new recipe and this documentation are first-party CI/build glue under the
existing Apache-2.0 WITH LLVM-exception terms, adapting those same-project setup
commands and retaining their notices. LLVM remains an external verified build
tool. Its verified license and the project license are retained in the artifact;
no external compiler implementation or runtime ELF is imported into Git.

## Exact source and build binding

Checkout names the actual triggering `github.sha`, persists no credentials and
uses sparse checkout for the controller directory and workflow. The job records
the actual commit/tree, source Git blob identities and all four corrected
source/protocol SHA256 checks. The original protocol review commit and this
additive binding correction's parent are recorded separately from the actual
triggering/source commit. In particular:

```text
profile914.c Git blob beaa45b167b0413da525271c426167e43156fc5f
profile914.c SHA256 5f7e12028829fbed3bd5ac92fdb80e0d003376a25f69ae1a08b41de008c1ea17
profile914.c lines 613
```

The new source is compiled once as one C translation unit, then that object is
linked once by the same official Clang driver and the disposable image's GNU
BFD linker. Controller source flags remain `-march=x86-64 -mtune=generic`.
The original final ELF nevertheless declared x86-64-v3;
the corrected artifact needs a fresh actual ELF/runtime/host compatibility
review rather than a baseline-only deployment claim. The flags are:

```text
--no-default-config -std=c17 -O2 -Wall -Wextra -Werror
-march=x86-64 -mtune=generic
```

Clang's [documented `--no-default-config`](https://clang.llvm.org/docs/ClangCommandLineReference.html#cmdoption-clang-no-default-config)
disables implicit driver configuration. Each compiler process receives only
HOME (the actual disposable runner home), PATH=/usr/bin:/bin, LC_ALL=C and
LANG=C. No environment dump, credential, token, preload or session configuration
is put into the receipts or compiler environment.

Dependency-only preprocessing of this same source discovers all actual header
paths before compilation. Their hashes are frozen first. Actual `-MD` paths
must match afterward and every source/header must still hash identically.
Unsupported makefile/path spelling fails instead of being silently reparsed.
Both actual compile and link argv are retained as NUL-delimited arrays and
shell-rendered text; Clang's unmodified `-MJ` command fragment and `-###` internal
driver commands, genuine statuses, stdout/stderr and UTC boundaries are saved.
No second project, helper test, benchmark or compiled program is built or run.

The recipe records before/after official compiler, linker, system-tool and
compiler/linker runtime hashes. Candidate startup/libc/libgcc inputs are bound
before linking; the actual GNU link trace must use only that set plus the
already hashed controller object. The object remains unchanged afterward.
The link map, package/cache records and all checks are retained. LLVM archive,
recipe and the original four files are rechecked after the build too.

## Inert artifact and runtime boundary

The output object and ELF are immediately changed to mode 0644. **The controller
is never executed**, not even `--help` or an error-path mode. The recipe never
runs `ldd` or a dynamic loader on the new controller. Its headers, dynamic
entries, notes and symbol-version requirements are read by `readelf` only.
It requires no RPATH/RUNPATH and exactly `libc.so.6` as the dynamic dependency;
unexpected dynamic shape fails closed. Actual interpreter/libc/loader paths,
hashes and ELF/version metadata are captured. Loader metadata queries apply
only to the already approved external compiler and ordinary system linker.

`controller.sha256` binds the copied exact C source, object and new inert ELF.
The final whole-directory `SHA256SUMS` includes success/failure status and final
UTC records. It excludes only itself. A compiler or metadata failure is not
hidden: the step fails and the always-upload action preserves any genuine
partial receipts. No successful result is manufactured from missing files.

The artifact is named `controller914-<actual-trigger-SHA>-<actual-run-attempt>`.
Its GitHub run/job/artifact IDs, archive digest, actual compiler/runtime hashes
and actual controller ELF hash are **unknown until the real authorized job**.
No placeholder is evidence. The job's explicit success marker says only:

```text
CONTROLLER_COMPILATION_COMPLETE; CONTROLLER_NOT_EXECUTED;
NO_STAGING_OR_MEASUREMENT_ACCEPTANCE
```

Root's later independent artifact review must authenticate actual run/event/
checkout, exact source bytes and all statuses/tool/input/binary hashes before
using the artifact. Any host ABI compatibility check is static first: inspect
the captured symbol-version requirements against the intended host's actual
runtime; do not silently stage a different build or copy a foreign runtime over
the host. Staging, executable-mode restoration, private frozen inputs, grants,
per-arm locks and all controller/profile/offline-reader execution still need
the coordinating root's separate later go-ahead after that artifact review.

The original PLAN's bounded pair and all existing source/provenance/ordinary
hosted gates remain. This controller build supplies no Buster correctness,
measurement, old-workload binding or #893/#914 acceptance. All historical raw
packets, manifests, seven assets/tag and results remain untouched.
