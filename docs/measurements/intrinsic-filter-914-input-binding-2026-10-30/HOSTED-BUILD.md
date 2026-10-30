# Controller-only hosted build route — preparation only

This addition prepares the next ordinary GitHub-hosted compilation and identity
receipt for reviewed preparation `0ead6f9a5f136039c15f28b56dd92d846a5ef04a`.
The original four files and the 611-line controller remain byte-for-byte exact.
There is no build result or new executable hash yet. Independent review of this
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
has occurred during preparation.

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
the actual commit/tree, source Git blob identities and all four frozen source
SHA256 checks. In particular:

```text
profile914.c Git blob 0939d4855bd606a8f0950b462d9384b2268d29ad
profile914.c SHA256 c62b7db050a5d37bf5dcfe06b80e3519c0e1fd1452fa19a317da3950203ff5cc
profile914.c lines 611
```

The new source is compiled once as one C translation unit, then that object is
linked once by the same official Clang driver and the disposable image's GNU
BFD linker. Baseline `-march=x86-64 -mtune=generic` avoids introducing a new host
ISA requirement into this launcher. The substantive flags are:

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
