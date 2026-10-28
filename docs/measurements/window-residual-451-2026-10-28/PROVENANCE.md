# Terms and provenance

Original reports, helpers, fixtures and new curation metadata use the project
default Apache-2.0 WITH LLVM-exception. `review/curate451.c` is original C code;
OpenSSL is an external system digest library, not an imported implementation.
Its versions and source/binary identities are in curation-environment.txt.

`harness/generate451.c` is unchanged first-party source from the immutable
[#486 record](https://github.com/buster14a/buster-performance/tree/3b0a4a57b4854bf0c1ae9044b3f4fc2d8594f45b/docs/measurements/window-tables-lines-451-2026-10-26).
Its digest is `06544fd8e1d202c23e7d24988aeb4b157c67e31226e4bc7f48542218bb1a49ae`.
The new make/prepare/dependency/readers/fault injector are original C helpers;
they reuse the exact compiler interfaces as source and independent test oracles.

Generated `main451.c` and `preprocessor451.c` retain the notices and terms of
Buster e7f89091648f68940b595aadd648841c1ffc3ec5. The generator changes only
linkage/include plumbing and work counters, as documented. The compiler's
transitive imported lexer/lane/other components are not relabeled as wholly
first-party: retain the exact source pin's
[licensing](https://github.com/buster14a/buster/blob/e7f89091648f68940b595aadd648841c1ffc3ec5/LICENSING.md)
and [portion inventory](https://github.com/buster14a/buster/blob/e7f89091648f68940b595aadd648841c1ffc3ec5/THIRD_PARTY_NOTICES.md).
No external implementation was added to these helpers. ELF files remain in
the private record and are not incorporated into this Git publication.

The retained `main-native-predefines.h` snapshots derive from external Clang
23.1.4 `-dM -E` outputs, under the LLVM terms retained in
[LICENSES/LLVM.txt](../../../LICENSES/LLVM.txt). Exact flags, local/native tool
identities, source inputs and digests are in the plan/receipts/manifests; these
macro snapshots are not original helper implementation. SQLite, the pinned
system/header pack and the official Clang package remain external runtime
inputs under their original terms. Large preprocessed outputs are private
artifacts represented by exact identities, not newly licensed source imports.

Curation preserves every retained source byte. COLLECTION.tsv maps all 414
frozen payload entries plus their source manifest to a copy or explicit private
disposition. No historical DCO certification or human sign-off is added by this
evidence publication.
