# Foreign section GC on a graph without unwind dependencies

[Buster issue #3037](https://github.com/buster14a/buster/issues/3037). Base `6427879e1143026a12fb0388a20bdea1fe4b2bc5`, head `3962842446411d7e1f66580fc4c4f7fe7c4d5017`. On a six-object link of zlib's two checksum implementations, graph preparation saved 1,404 bytes of scratch and 1,284 bytes of bulk copies per invocation. The adapter's scratch peak fell 45.0%. Each revision used the same inputs on a four-vCPU, GitHub-hosted Ubuntu 26.04 AMD EPYC 9V45 VM. The measurements count linker work. [Paired run](https://github.com/buster14a/buster-performance/actions/runs/44602714259/job/135838114288).

| Input | Graph scratch, B | Graph copies, B | Adapter scratch peak, B | Live atoms / symbols / fixups | Exit |
|---|---:|---:|---:|---:|---:|
| zlib checksums, 17-valued COMDAT first | 1,404 → 0 | 1,284 → 0 | 3,128 → 1,720 | 10 / 12 / 111 | 42 |
| Same link with `-u forced_data` | 1,404 → 0 | 1,284 → 0 | 3,128 → 1,720 | 12 / 14 / 112 | 42 |
| Forced root, 99-valued COMDAT first | 1,404 → 0 | 1,284 → 0 | 3,128 → 1,720 | 12 / 14 / 112 | 43 |
| Additional empty `.eh_frame` object | 1,468 → 0 | 1,342 → 0 | 3,480 → 2,008 | 10 / 12 / 111 | 42 |
| zlib checksums with unwind tables | 2,252 → 2,252 | 1,487 → 1,487 | 7,736 → 7,736 | 13 / 17 / 116 | 42 |
| Shared library with exported data | 212 → 0 | 182 → 0 | 640 → 448 | 2 / 2 / 1 | 73 |
| 4,096 generated functions | 151,628 → 0 | 135,226 → 0 | 352,712 → 201,080 | 2,049 / 2,049 / 2,048 | 42 |

The real no-unwind link had 28 atom and 118 fixup rows including sentinels. Its six columns accounted for 1,172 bytes copied and the CSR cursors for 112. Both revisions retained 10 atoms, 12 symbols and 111 fixups. Forcing the data pointer also retained its otherwise unreachable target. Reversing the two COMDAT objects changed the program's exit from 42 to 43 on both revisions. The shared-library case retained its exported data pointer and the hidden payload reached by its relocation. A separate loader checked the value 73.

The positive unwind input added 16 virtual nodes and 42 extra edges. Both revisions copied 1,299 bytes of columns and 188 bytes of cursors there. The decoded CFI, full executables, relocations, symbols and selection maps agreed across the comparison. A recordless unwind atom with a leftover fixup still reports its original object and section in the private regression fixture.

`build/compiler test-foreign --cross-check` passed on both clean revisions against GNU ld and LLD. The section-GC handoff reported 281 passing checks on base and 283 on head. The independent GC marker reported 36,694 passing checks on each. An earlier smoke established the normal-entry four-object checksum link on main (exit 42). Its GDB-dependent checks failed before the debugger setup was included. The paired run above used GDB 17.1 for both revisions. [Initial smoke](https://github.com/buster14a/buster-performance/actions/runs/44601231290/job/135832877635).

One invocation per case, build, and revision checked deterministic work and byte identities. `receipt.txt` contains the job's measurement output, tool versions, SHA-256 identities and suite results. The ELF copies from base, head and both instrumented builds were compared directly. No CPU timing was used.

## Reproduction

Start on an AVX-512 Linux host with the ISA accepted by Buster's vector row. The recorded run used a single GitHub-hosted Ubuntu 26.04 VM for every comparison. Build Buster with its pinned Clang 23.1.4 toolchain and the vector Release configuration. The cross-check also needs the host C and C++ compilers, binutils and GDB.

From a disposable Buster checkout, with this evidence directory available at `$evidence`, run the following commands.

```sh
git checkout --detach 6427879e1143026a12fb0388a20bdea1fe4b2bc5
git clone https://github.com/madler/zlib.git zlib
git -C zlib checkout --detach 51b7f2abdade71cd9bb0e7a373ef2610ec6f9daf
export PATH="$(bash tools/ci/session-toolchain.sh stage):$PATH"
bash "$evidence/compare.sh"
```

The script fetches the candidate in `head-revision`, builds each revision both clean and with `probe.patch`, and compiles the input objects once. Its normal command is `build/compiler link-foreign --lanes 1 --gc-sections`. For the checksum case the link is static, with an assembly entry point and no CRT objects. The work runs through the import, conversion, collector, and executable writer. The inputs are upstream zlib 1.3.1's `adler32.c` and `crc32.c`, a C caller, the entry point and two objects that define competing COMDAT groups. The caller checks both algorithms' answers for `123456789` and returns a status determined by the winning group. All fixture and compiler changes made by the probe are temporary.

## Reading the counters

The adapter's scratch peak is the largest logical length reached by its scratch arena after entry, less the entry length. It includes allocation alignment and allocations popped before return. Graph scratch is the increase in that arena's length during graph construction. Later allocations can realign after the graph is omitted. These are arena bytes.

The two copy counters sum the length arguments of the six column copies and the separate cursor copy when those calls execute. They exclude zero filling, shallow descriptor assignment, output compaction, and the final writer. Counts include sentinel row zero. On this x86-64 host, for A input atom rows, F fixup rows, and N total graph nodes including the original atoms, column copies total `25*A + 4*F` bytes whenever the synthetic graph is built. Copying cursors costs `4*N` more bytes. When no rewrite is needed, the marker validates and traverses the original columns and receives a null extra-edge list. Its ordinary fixup-to-symbol-to-atom traversal still runs.

The probe emits every mark map, the compact atom and symbol IDs, each object's section and symbol maps, and each compact relocation's offset, target, kind and addend. The script compares these files byte for byte, together with the complete ELF images and readelf's symbol and relocation listings. Each instrumented ELF must also match its clean build. The unwind control additionally compares decoded CFI, and the shared-object control loads the exported pointer and checks its target.

---
Agent session: 6aff4f78-d364-8191-b166-7c2f914d8072 (OpenAI Codex session ID; no private session URL is exposed)
Model: OpenAI / GPT-6 (Codex; exact runtime variant not exposed)
