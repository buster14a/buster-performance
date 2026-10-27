# Evidence provenance and component notices

Original analysis, collection/decoding tools and validation driver follow the performance repository's existing Apache-2.0 WITH LLVM-exception terms. Third-party source, binaries, headers and factual extracts retain their own terms; they are not relabeled as original project material.

## Buster

The two compiler executables and `source-92c025e7.tar.zst` correspond to Buster commit `92c025e71856d13eb34247477c5294d2cead139e`. The archive retains its complete source license and attribution records. Accessible copies of `LICENSE`, `LICENSING.md`, `THIRD_PARTY_NOTICES.md` and `LICENSES/` are additionally provided under `licenses/buster/`. Identified MIT, Apache-only and other portions keep those component terms.

Binary identities, bootstrap versions and build logs are in `hardware/`. No new compiler modifications are included in this investigation. The exact source archive and both native binaries are part of the release evidence archive.

## SQLite and frozen input headers

`reproduction/frozen-corpus.tar.zst` contains the measured SQLite 3.53.2 source, its headers and the frozen system/header/predefine environment. The top-level source SHA-256 is `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. The SQLite sources carry the upstream public-domain blessing. The retained SQLite objects are generated from that input; the independent smoke driver is original.

The frozen Clang resource headers retain LLVM's notices and Apache-2.0 WITH LLVM-exception terms; `licenses/LLVM-headers.txt` supplies the full LLVM license text. GNU C Library headers retain their GNU notices and LGPL terms. Linux UAPI headers retain their per-file notices, GPL-2.0 terms where specified, and the Linux syscall exception. The corresponding LGPL/GPL texts and Linux syscall note are under `licenses/`. Other per-file header notices remain intact. Header files are supplied as source inputs, not claimed as project-authored headers.

## GNU C Library binaries and corresponding source

The retained target and local `libc.so.6` copies both come from package version `2.44+r50+g1848099f063e-1`, respectively the Arch x86_64 and CachyOS x86_64_v4 builds. They are distinct binaries, used to resolve the actual recorded libc instructions.

`runtime-sources/glibc-1848099f063e-source.tar.gz` supplies the complete upstream GNU C Library source at **`1848099f063e99d4ffecbd7667766d54862398b9`**, including its own license/copyright files and build system. It was retrieved from the [GNU libc Git mirror](https://github.com/bminor/glibc/tree/1848099f063e99d4ffecbd7667766d54862398b9). Upstream package recipes name the equivalent [sourceware mirror](https://forge.sourceware.org/glibc/glibc-mirror).

The matching distribution recipes and auxiliary inputs are also included:

- `runtime-sources/glibc-arch-packaging.tar.gz`: [Arch's versioned package-source snapshot](https://gitlab.archlinux.org/archlinux/packaging/packages/glibc/-/tree/2.44+r50+g1848099f063e-1). Its `PKGBUILD` SHA-256 is **`89fd80f7106a61cd5642ba8345f012b0880563a14b3ee944705d9304c684ed97`**, matching the target's retained `.BUILDINFO`.
- `runtime-sources/cachyos-packaging-snapshot.tar.gz`: [CachyOS package sources at `b1b3cd29bef2f698f82d81c6a1fbbb0eeced9c71`](https://github.com/CachyOS/CachyOS-PKGBUILDS/tree/b1b3cd29bef2f698f82d81c6a1fbbb0eeced9c71/toolchain/glibc). The relevant `toolchain/glibc/PKGBUILD` SHA-256 is **`8fcc8f3117e2a99a884c161b52ae04d27ebf64d59a6f89bec7f3037b655139f4`**, matching the local `.BUILDINFO`. Its included patch/auxiliary files and notices remain intact.
- Both `.BUILDINFO` files and byte-identical copies of the matching recipes are supplied next to those archives.

GNU libc remains under its upstream component licenses, principally LGPL-2.1-or-later for the library, with additional per-file notices and GPL terms for relevant tools. `licenses/glibc-COPYING.LIB` is retained verbatim. The complete corresponding library source and packaging inputs are offered in the same release archive as the binaries. No library source or binary is modified here.

## uops.info and AMD/Linux information

`uops-selected.csv` is a selected factual extract from the official [uops.info XML dataset](https://uops.info/xml.html), dataset date 2026-03-29. The XML source identity is recorded in `hardware/uops-dataset.sha256`; the full XML and any external extraction/code-generation scripts are not bundled. `method/uops-extract.c` is the original extraction tool used for this record. Measured, documented and port-derived values remain separate; attribution stays with uops.info and the underlying documented sources.

AMD's public IBS documentation and Linux's exposed event/metric definitions informed the analysis. No AMD uProf package was installed, no uProf EULA was accepted and no uProf binary or proprietary data is redistributed.

## Publication-only processing

`method/publication-audit.c` checks the staged copy for current secret environment values and removes incidental UUID/serial metadata. The audit records list the two modified configuration files and four UUID occurrences. No binary capture or measurement record is rewritten. The budget explorer copies the already verified report visualization into downloadable HTML and preserves its original numerical assumptions.
