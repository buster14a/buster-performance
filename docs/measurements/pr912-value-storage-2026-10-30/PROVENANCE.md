# PR #912 qualification provenance

This record follows up [Buster #879](https://github.com/buster14a/buster/issues/879)
and [PR #912](https://github.com/buster14a/buster/pull/912). It changes no
production compiler source and supplies no retroactive human DCO certification.

## Compiler and inputs

- Baseline: Buster `e693d878309ed3c3be05f2f550574d59217deceb`.
- Candidate: Buster `ce7cb0948097b86b8839f8d9f8de315355aeb6f6`, its direct child;
  tree `6c444961a3145a0e02e0bd14120bd975c109db3f`.
- `git archive --format=tar` SHA-256: baseline
  `0fade078c6ee3a965b1bd9379d6bec7bf3e212fe842396712d8c14230ae8f811`;
  candidate `328a6993ab1e70acc6c61e3044e47165a509f8912338b5fc469b35d401b39014`.
- External runtime corpus: the host's frozen
  `/var/lib/buster-9700x/corpora/preprocessor-391e729af658`, verified against
  its header and SQLite file manifests before object comparisons. The overall
  manifest SHA-256 is
  `391e729af6587355050881752558e790299cfe638c7dc7803bd028a8535ebcbd`;
  the SQLite manifest is
  `9179b7ad7db7366d12a214b562e478ac703e7ec0376f38f4516756bcf7ee0047`.
  No SQLite implementation or system header is copied into this record.
- The frozen Clang macro snapshot is an external runtime input, SHA-256
  `a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33`.
  It retains the LLVM terms in its source corpus; it is not copied here.

## Toolchain

The compiler is the unmodified official LLVM/Clang 23.1.4 Linux X64 release,
LLVM commit `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`. Its archive SHA-256 is
`efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378`.
The existing private session cache was reused read-only, after checking both
completion markers, executable identity and its retained LLVM license:

- `clang` SHA-256:
  `c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67`.
- `LICENSE.TXT` SHA-256:
  `8d85c1057d742e597985c7d4e6320b015a9139385cff4cbae06ffc0ebe89afee`.

The compiler, linker, objdump and perf are external tools, not incorporated
implementations. Their identities and the expanded build flags are retained in
the results. No toolchain package or LLVM header is imported into this record.

## Qualification helpers

The C placement generator, counter validator, rejected-input fixture, shell
orchestration and AWK timing acceptance gate are original qualification material
under Apache-2.0 WITH LLVM-exception. `time-runs` and `measure-compile` are the
unchanged C tools in the pinned Buster sources. Private source patches only
insert assembler padding; they are not proposed compiler changes.

The ELF readers/proofs were supplied by the concurrent PR #917 qualification
work in David's Codex session, under the same project terms. The exact shared
artifacts incorporated here are:

- `elf_proof.py`: SHA-256
  `3688b585de9991a0bb40303bc4dbddd6ed9c1a65af538b0ae5cf01c66c224a31`.
- `check_linked.shared.py`: SHA-256
  `94a586047b63e9cac0dfa73deff8a05277e7ce1902e29d82e1a70322f5e26937`.

`check_linked.py` changes only the permitted shifts and required hot-function
names for this older source pair. The exact shared input is retained alongside
it. The initial proof versions and their honest PLT32 refusal are also retained;
no unsupported proof was treated as a pass. The reviewed extension checks
local section-symbol PLT32 relocation translation and actual signed-32-bit
linked S+A-P values. No external ELF implementation was imported.

This performance repository has no applicable standing human certification
covering new commits. Publication of this original evidence is unsigned; the
compiler repository's repository-specific standing certification is not extended
to this repository or to the original unsigned PR #912 contribution.
