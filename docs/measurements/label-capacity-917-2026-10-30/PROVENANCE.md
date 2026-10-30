# Provenance and scope

This is original qualification work for Buster PR #917, item 4 of issue #877.
It does not claim the other sparse scans, attribute representations, #529 or
#628. The compiler contribution is unchanged and its original unsigned
certification remains a separate maintainer gate. No prospective signature on
new evidence can certify that original contribution. The compiler repository's
standing certification is expressly repository-scoped and is not extended to
this separate evidence repository; these new evidence commits are unsigned.

The compared compiler sources are exact public revisions:

- Baseline `434eb27646fa189662e5ada0e61a41f54ba70c4f`, tree
  `f6cb4cd4280fb1bcfd267bfb2835e1d491b3adc2`.
- Candidate `f24e3cd4a1339774318fa8da35910ecb8a89e222`, tree
  `79342e99dd82470a45abf01c240e84791b7ed319`.

The retained source patch contains only the original two first-party
control-input implementation/test files. Complete source archives were made
with `git archive COMMIT | gzip -n`, transferred for execution, and retained on
the measurement host. This report records their hashes and complete source
manifests instead of duplicating the mixed-source compiler archive in Git.
The original compiler's LICENSE, LICENSING.md, THIRD_PARTY_NOTICES.md and
LICENSES remain with each executed source archive and govern their components.

New orchestration is Bash; the negative-control mutator is original C. These
use Apache-2.0 WITH LLVM-exception. The structural proof tools are existing
original project tools copied from the concurrently prepared #883 placement
work, under their retained SPDX and copyright notices. The unmodified starting
ELF reader and linked-image checker are retained in `proof-tools/original/`.
The padding transformer is unchanged, initial SHA-256
`3d89b4e8408dd317d72a72638594882fc14802609e07cc76c0aa9d5d26b076e1`.
This method derives from the already published #502 inside-section approach,
whose original `objects.sh` and `link.sh` are in this repository at commit
`dd92b91a3a98f57b505cc76ea13cbd74d23edffa`. No production compiler sources or
algorithm flags were altered for the timed binaries.

The proof adaptations are deliberately bounded:

- Local STT_SECTION PLT32 targets join the direct four-byte PC-relative target
  class. Existing local-binding/value/size guards and normalized addends/sites
  still apply. Actual wild-linked signed-32-bit `S+A-P` bytes are checked for
  every such hot target, independently of the object proof. The local target
  interpretation is supported by [binutils' discussion](https://sourceware.org/pipermail/binutils/2026-February/148277.html)
  and [LLVM lld's x86-64 implementation](https://github.com/llvm/llvm-project/blob/4753f36c4f469e6932bba9f4bad3d86ba75658a4/lld/ELF/Arch/X86_64.cpp);
  those sources provide behavior facts, not incorporated implementation.
- The exact `.eh_frame`/SHT_X86_64_UNWIND pair is accepted as file-backed
  relocation input without stripping any unwind data, metadata or relocations.
- Globally unambiguous object-owned functions first establish a unique input
  contribution base in each final image. Duplicated local function names must
  then match uniquely at that independently established base plus object offset,
  with the same code-contribution and range checks.
- The pinned remote wild's otherwise empty ET_EXEC NULL row carries SHF_ALLOC
  and the offset-zero PT_LOAD base address. Only that observed case is accepted;
  name/type/offset/size/link/info/alignment/entry-size remain zero. ET_REL keeps
  its all-zero NULL-row requirement. Raw NULL metadata is disclosed in receipts.

The original fail-closed attempts are retained. Positive zero controls and
negative addend, actual-target, ownership and NULL-row controls qualify only
this recorded input family, not arbitrary ELF objects or every linker.
The nine rejection controls ran locally against hash-verified copies of the
remote artifacts and never executed the copied compiler images. Their first
fixture attempt stopped while constructing an ambiguous symbol: it had assumed
equal string-table offsets for equal names. The corrected C mutator compares
bounded string contents. That failed fixture attempt is retained separately;
the final positive and nine rejection controls all pass. Hardware timing and
source-compilation semantic preflight remain executions on the locked 9700X.

`normalize_x87_roundtrip.c` is original first-party work shared by the #914
qualification session, SHA-256
`18a1cb27213ec3ca59b1704378e7418a34a96a50dccf761ba814c7eaefc5576f`.
It accepts one exact ambiguous FADD spelling in one exact named test function
and prints its already established original `dc c0` encoding. Full zero-object
and final-image byte identity are mandatory after normalization; this is not
acceptance based merely on assuming two x87 encodings equivalent.

The `capacity.sh` diagnostic clones add a single print before label-table
allocation. Their compiler binaries are never used for timing, and their
output objects must equal the uninstrumented reference. The diagnostic patch,
source and binary hashes and output are retained.

Official Clang 23.1.4 and its license are verified against the recorded cache
and digests. The frozen SQLite amalgamation, frozen system headers/predefines
and host tools are external qualification inputs. They are not incorporated
into this repository. The complete input manifests are verified before source
compilation, and their provenance remains in the configured corpus store.
