# Retained licenses and provenance

This repository contains the `docs/measurements/` subtree of
[`buster14a/buster` at `791145817483f12514dd479655f1601684a5fd1f`](https://github.com/buster14a/buster/tree/791145817483f12514dd479655f1601684a5fd1f).
It retains existing copyright, attribution, modification and license notices.
The migration adds no new license grant over third-party portions.

The source's complete, unmodified records are retained in
[`provenance/buster/LICENSING.md`](provenance/buster/LICENSING.md) and
[`provenance/buster/THIRD_PARTY_NOTICES.md`](provenance/buster/THIRD_PARTY_NOTICES.md).
Paths in those historical records are relative to the frozen Buster source root;
entries outside `docs/measurements/` describe source components used by harnesses,
not additional files imported into this repository. Their relative links can be
resolved through the frozen source link above. All source license texts are
retained byte for byte under [`LICENSES/`](LICENSES/), and the existing project
default text is retained as [`LICENSE`](LICENSE).

Original measurement reports, fixtures and harnesses follow their existing
Apache-2.0 WITH LLVM-exception terms except for identified component-specific
portions. In particular, the Clang-generated
`docs/measurements/parser-c-testsuite-2026-10-23/predefines.h` retains the LLVM
terms in [`LICENSES/LLVM.txt`](LICENSES/LLVM.txt). Other existing embedded notices
and the full source portion inventory continue to apply. Imported patches and
harnesses that include source components use those components under their
retained terms; this archive does not relabel them as wholly original material.

The new `docs/measurements/window-residual-451-2026-10-28/` record retains
its frozen source/evidence identities and component notices. Its original
curator and work-count/readers use the project default terms; OpenSSL is an
external digest library. Generated main/preprocessor copies retain Buster
e7f89091's terms, and Clang 23.1.4 macro snapshots retain the LLVM terms.
The directory's `PROVENANCE.md` identifies exact source/generator/tool inputs
and distinguishes those snapshots from original helper code. External SQL,
system headers and toolchain packages remain runtime dependencies; omitted
large binaries/outputs retain their digests and explicit private dispositions.
