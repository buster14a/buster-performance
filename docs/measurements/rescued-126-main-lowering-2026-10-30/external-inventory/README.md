<!-- SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception -->
<!-- Copyright (c) 2026 David Gonzalez Martin. -->
# External header and notice inventory

This is a read-only audit of the **discarded qualification attempt**
`ba2d8a33d8cb537891c4efb25a6f7b3f9161aab1`, not final compiler qualification or
timing. Final measured source is `20e01cebc77a0142260f3e0a6b3e9c66228ef3bf`.
The final 378 absolute external header identities match this audited inventory
byte for byte; `../hardware/curation.json` records the completed comparison.

The original host record is
`/home/david/buster-fast-bench/codex-rescue-126/ba2d8a33d8cb537891c4efb25a6f7b3f9161aab1/evidence/`:
`main.d`, `main-inputs.txt`, `main-inputs.sha256`, `host-toolchain.txt`. The
937-entry dependency list contains 559 relative Buster source paths, 152 staged
Clang resource headers and 226 host `/usr/include` headers. All 378 absolute
external file hashes were rechecked on the host and still matched; the status
receipt is `attempt-external-recheck.txt`. Source/header/notice reads did not
run builds, probes, tests, measurements or alter the host.

| Incorporated external input | Count | Observed ownership / notices |
| --- | --- | --- |
| Staged Clang 23 resource headers | 152 | 148 explicit Apache-2.0 WITH LLVM-exception SPDX prefixes; four MIT-style per-file notices listed below. Exact official toolchain `LICENSE.TXT` retained. |
| glibc headers | 183 | Package `glibc 2.44+r50+g1848099f063e-1`: 152 GNU C Library LGPL-2.1-or-later boilerplates, one BSD-style `sys/ttydefaults.h` notice, 30 small/generated/wrapper headers without an explicit prefix notice. |
| Linux UAPI headers | 43 | Package `linux-api-headers 7.2-1`: 32 `GPL-2.0 WITH Linux-syscall-note` and two `GPL-2.0+ WITH Linux-syscall-note` prefixes; nine wrapper/generated headers without an explicit prefix notice. |

The four MIT-style Clang headers are `avx512vlvp2intersectintrin.h`,
`avx512vp2intersectintrin.h`, `avxvnniintrin.h` and `keylockerintrin.h`. Their
complete actual leading permission/disclaimer blocks are retained individually
under `../licenses/Clang-*-notice.txt`. They must not be relabeled by the common
LLVM SPDX prefix on the other headers. The complete `sys/ttydefaults.h` leading
BSD-style notice is `../licenses/glibc-sys-ttydefaults-notice.txt`.

`package-owners.tsv` records `pacman -Qo` ownership/version for every system
header; `header-packages.txt` preserves the relevant package metadata fields as
reported, including the package URL without correction. A package's broad
license field is not a per-file portion map. `header-notice-index.tsv` records
the individual observed prefixes/permission notices. No absence of a prefix
is treated as a new first-party grant.

The original external header digests are `input-identities.sha256`.
`license-text-origins.tsv` identifies exact host paths and hashes for full
GPL/LGPL texts from `/usr/share/licenses/spdx`, the Linux syscall exception from
`/usr/share/licenses/linux-lts/Linux-syscall-note`, and the staged official
Clang `LICENSE.TXT`. `license-text-packages.txt` identifies the independent
license-text provider packages (`licenses 20240728-1`, `linux-lts 6.18.55-1`).
The installed kernel package providing an exception text is **not** the source
version of the `linux-api-headers 7.2-1` headers.

## Snapshot disposition

This mechanical audit identifies every external file's package/toolchain and
retains all observed explicit component texts. It does not independently prove
the precise per-file inheritance for the 39 unmarked system wrappers/generated
headers, nor a complete upstream-source/portion map for the combined
preprocessed source. The chosen disposition is **PRIVATE on the measurement
host** for `main.preprocessed.c.gz`; do not upload it. The publication contains
only its final digests/size/retained location and input/package/notice inventories,
not the snapshot itself. The final input comparison has succeeded, so the
retained package/header notice inventory applies to the exact measured inputs.
