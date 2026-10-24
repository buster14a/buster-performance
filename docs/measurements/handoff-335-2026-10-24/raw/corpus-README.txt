Frozen preprocessing inputs for buster14a/buster-fast issue #125
Prepared 2026-10-20 by Codex for @davidgmbb.
Session: 01a158dd-f0dc-7ff1-90c0-f9e71eb18725
Root: /home/david/buster-fast-bench/preprocessor-corpora-astra-01a158dd

This is the frozen-input slice only. It does not compare Buster's preprocessor
with Clang, decide documented language differences, or claim completion of #125.
The comparator remains with #124/#193. Nothing here belongs in git.

INPUTS AND ORIGIN

sqlite/: official SQLite 3.53.2 amalgamation, downloaded from
https://www.sqlite.org/2026/sqlite-amalgamation-3530200.zip
The original archive is retained in provenance/. SQLITE_VERSION was checked
in sqlite3.c. The two existing benchmark copies were 3.53.4 and were not used.
Archive SHA-256:
8a310d0a16c7a90cacd4c884e70faa51c902afed2a89f63aaa0126ab83558a32
sqlite3.c SHA-256:
0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d
The manifest covers all four archive files. The preprocessing corpus is the
single 9,507,037-byte sqlite3.c.

libc/: copied without changing the source from
/home/david/azp-bench/c-tokenizer/corpus/libc, the documented Zig 0.14.1 corpus.
No symlinks were present. Full snapshot: 12,023 regular files, 101,262,232 bytes.
The historically measured C/header subset contains 8,983 files, 93,836,361 bytes.
The additional 3,040 files are retained. Their forced-C preprocessing results
are supplemental diagnostics, not a claim that assembly, definitions, templates,
copyright notices or README files are C source.

libc/musl/: Zig 0.14.1-vendored musl 1.2.5, with Zig's patches; not pristine
upstream musl 1.2.5. Zig tag commit:
d03a147ea0a590ca711b3db07106effc559b0fc6
https://github.com/ziglang/zig/tree/0.14.1/lib/libc/musl
The version header and generated x86_64 bits headers were checked against that
tag. The musl subtree contains 2,498 files, 3,041,897 bytes; all 1,591 .c files
were attempted, including files for foreign architectures.

provenance/musl-1.2.5-Makefile is a byte-matching copy of upstream v1.2.5's
Makefile, checked at commit 0784374d561435f7c787a555aeab8ede699ed298 through
https://github.com/ifduyue/musl/blob/0784374d561435f7c787a555aeab8ede699ed298/Makefile
SHA-256: 58c8b95c68d5326c747e26e7b4ff51560d72fc881fa5492d85f8dcf9af17ab9e
The official musl git host timed out; the pinned git mirror supplied this
verification. The Zig files themselves remain the input corpus.

musl-generated/obj/ is a copy-only overlay matching upstream's generated-header
locations. obj/include/bits/alltypes.h and bits/syscall.h come from frozen
libc/include/x86_64-linux-musl/bits/. obj/src/internal/version.h comes from frozen
libc/musl/src/internal/version.h. No headers were regenerated or edited.
Their SHA-256 values, respectively, are:
54aba956a68b48f20910eafaa00261e3344a1675164f7a15cd217fd451468d64
8b04b19d128efbee74a6394b831df3971ad872044eb85ab2686edb219fa620e2
5098e3a8f94aacf5587a6cb22b8b1699919876fc269f6a7e9d3a96521b07f4b6
Do not replace x86_64 alltypes.h with generic-musl's fallback types.

repository/: git archive of main at
1bc8ca0e18452c80841f783f9d139bea39180d43. All 23 .c files were preprocessed;
main.c includes the intrinsic-header-dependent translation unit. The complete
48-file source snapshot is manifested.

CONFIGURATION

Host: benchpress, AMD Ryzen 7 9700X. Compiler: /usr/bin/clang, version 23.1.1.
The version, compiler-binary hash, CPU, kernel and package records are retained
under provenance/. No tool or compiler build/test was run on the local Zen 4.

All Clang passes use the shared lock independently:
EXCLUSIVE_OWNER=astra /home/david/buster-fast-bench/exclusive.sh /usr/bin/clang ...
SOURCE_DATE_EPOCH=1792454400 (2026-10-20 00:00:00 UTC).
No outer lock surrounds the scanner or a series of passes.

Common preprocessing flags:
--no-default-config --target=x86_64-linux-gnu -march=znver5
-E -H -fno-color-diagnostics -fno-caret-diagnostics -ferror-limit=1 -x c

Ordinary corpora use -std=gnu17 -nostdinc with the actual clang -E -v order:
/usr/lib/clang/23/include
/usr/local/include
/usr/include
Each entry is passed with -isystem. Final flags replace all three paths by the
corresponding paths under headers/. The empty local-include directory is kept.
Repository scans additionally pass -I followed by the frozen repository/src.
No -undef or __BUSTER__ definition is supplied. Native Clang identity and feature
tests are used; __BUSTER__ remains a deliberate compiler-side difference.
GNU17 predefined-macro dumps before/after pinning are byte-identical.

Musl uses -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -pipe,
and upstream Makefile include order, with M=ROOT/libc/musl and G=ROOT/musl-generated:
-I M/arch/x86_64
-I M/arch/generic
-I G/obj/src/internal
-I M/src/include
-I M/src/internal
-I G/obj/include
-I M/include
The generated overlay supplies the two target bits headers, so generic-musl is
not added as a competing include directory. CRT inputs add -DCRT; Scrt1.c and
rcrt1.c also add -fPIC; the LDSO input adds -fPIC. Other files use the ordinary
static-object preprocessing configuration. See config/musl-*.txt and *.args.
These passes accept preprocessing, not compilation or validity of foreign ISA
assembly for x86-64. All musl headers already resolve inside the frozen root,
so its completed discovery passes are also its final frozen-input passes.

HEADERS AND PACKAGE PROVENANCE

Clang -H traces from all discovery passes, including rejected inputs, are
retained. The 516,507 trace entries were sorted/uniqued before copying to stay
within the collector's explicit 262,144-path bound. There were 2,104 distinct
traced paths: 778 installed headers copied and 1,326 already-frozen input paths.
Source files were copied without editing, preserving their /usr/... paths.

The 778 copied headers total 7,163,375 bytes:
157 from clang 23.1.1-1
362 from glibc 2.44+r50+g1848099f063e-1
257 from linux-api-headers 7.2-1
1 from libxcrypt 4.5.2-1
1 from util-linux-libs 2.42.4-1
headers/package-owners.txt maps every path to its package and version.
headers/provenance.tsv maps installed paths to their frozen copies.
headers/package-counts.txt gives the package totals.
The headers-bundle manifest hashes those three provenance records as well as
the 778 header files; headers.sha256 covers the header bytes alone.

RESULTS AND REPRODUCTION

config/ contains every argument list and sorted input list. Each scan directory
contains results.tsv (status, bytes and first diagnostic for every input),
commands.txt (actual cwd, environment settings and exact command per input),
logs/INDEX.stderr (full Clang diagnostics), and headers.txt (all -H paths).
Rejections are explicit skips for a later comparison, not token differences.
There were no infrastructure errors or incomplete scans.

Final results:
- SQLite: 1/1 accepted.
- Musl C99: 1,591/1,591 accepted, 1,562,835 source bytes.
- Repository: 23/23 C files accepted, 2,311,105 source bytes.
- Libc C/header subset: 5,129 accepted; 3,854 rejected; 8,983 total.
  Accepted C/header inputs total 19,924,701 bytes.
- All libc regular files forced through -x c: 8,019 accepted; 4,004 rejected.
  The non-C/header supplement alone has 2,890 accepted and 150 rejected.
  The complete 12,023-row result matches the input list, with zero infra errors.

Discovery and pinned libc runs have zero status or input-size changes.
Thirteen first diagnostics change only their installed-header path prefix;
after replacing ROOT/headers/usr/ by /usr/, all 12,023 records match exactly.
SQLite and repository records match without normalization. The final unique
header graph equals discovery after the same path-prefix normalization.
Canonical audit: 2,104 distinct final traced files, zero outside the frozen root.
These are acceptance/diagnostic/header-path checks, not a token-output comparison.

discovery/libc-report.tsv classifies the full regular-file snapshot and its
C/header subset. pinned/ holds the final ordinary-corpus results and comparison
reports. Musl's four partitions live under discovery/musl-* and are already
entirely frozen; provenance/musl-canonical-headers.tsv proves containment.
Final canonical path audits resolve symlinks and .. components, so textual
prefixes alone are not used to claim absence of installed-header dependencies.
Audit counts include duplicate trace entries, not distinct headers.

tools/corpus_scan.c, corpus_manifest.c and corpus_summary.c are fresh C evidence
tools. They use the frozen repository's lane.c arena implementation; the manifest
tool uses installed OpenSSL EVP SHA-256 (openssl 3.6.5-1). Tool source and compiler
provenance are hashed. Build commands are recorded in provenance/tool-builds.txt.
The scanner runs:
corpus_scan ROOT FILE_LIST ARGS_FILE NEW_OUTPUT_DIRECTORY
It acquires the shared lock separately for every child Clang invocation.
Do not wrap the scanner in an outer exclusive.sh lock.

The manifest generator runs:
corpus_manifest manifest INPUT_ROOT NEW_MANIFEST_PATH
Its sibling .stats records regular-file count and total original bytes. Lines
are sorted relative paths with SHA-256, compatible with sha256sum -c when run
from the corresponding root. The manifest does not follow source-tree symlinks.
Manifest roots: libc, libc/musl, sqlite, repository, musl-generated, headers/usr
(headers.sha256), headers (headers-bundle.sha256), plus named evidence folders.
No output bytes, Clang acceptance or header trace count is a performance result.

Tool checks exercised spaces in names, source symlink exclusion, known hashes,
accepted/rejected input classification, duplicate-header copying, unchanged
result comparison and canonical inside/outside paths. The outside-path check
intentionally returned failure. Full logs and fixtures remain under tool-check/.

All underlying source/header licenses remain with their upstream projects.
No third-party implementation was imported into buster-fast, and no license
choice or DCO certification was made on the owner's behalf.
