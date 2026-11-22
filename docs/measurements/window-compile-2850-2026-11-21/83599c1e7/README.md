# Carrying native data and complete ELF64 relocations to file publication

This extension of the [native fragment writer](../418ed8b06/README.md) borrows large static atoms directly from the final link and produces `Elf64_Rela` rows when the object builder first classifies their target symbols. Both mechanisms run at the ordinary ELF output boundary. Each works with the existing unit-wide compiler and with the experimental function-local native producer.

## File layout

During ELF symbol classification the fixup target is already known to be a local, global, undefined, or section-relative symbol. The producer records the final file-relative field offset, ABI relocation type and checked signed addend. It keeps just the symbol class and position in the row’s symbol slot. After section and symbol placement that slot becomes the final ELF symbol index. The file writer borrows the relocation array directly. The general linker still supplies the normalized source fixups and determines symbol and section order. [Verified patch against 418ed8b06](early-relocations.patch).

Previously each large file-backed non-text atom was copied to the object image just before a disk write. At `83599c1e7` the scatter writer borrows atoms of at least 4,096 bytes. Smaller atoms share the existing contiguous section buffer. This includes writable data, read-only literals and immutable unwind atoms such as .eh_frame. Virtual zero-fill sections consume no file bytes. [Large-data change](large-data.patch).

| Frozen input | Complete native ELF | Borrowed text bytes | Borrowed relocation bytes | Borrowed non-text atom bytes | Output spans |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite | 2,061,200 | 1,065,651 | 538,632 | 154,106 | 36 |
| Buster | 11,276,208 | 3,290,350 | 952,416 | 5,373,660 | 383 |

These are actual original storage ranges supplied to the independently checked full output. The remaining image consists of ELF and section headers, symbol tables, short atoms, alignment and other metadata. The read-side code continues to support a complete in-memory object when required. [Equality and coverage](frozen-layout.tsv).

## Target build and correctness

The Ryzen 7 9700X Release compiler was built from the verified net patch using Clang 23.1.4. Two on-host comparisons are in progress. One exercises ordinary unit-wide compilation and the other exercises the source-local native path. Both run every fresh process under its own shared host-lock acquisition on CPU 2 and compare its actual ELF, stdout and stderr to an independent ordinary compiler. [Target build and hash](target-reproduction/results/objectrelas), [ordinary benchmark driver](objectstandalone-one.sh) and [source-local benchmark driver](objectrelas-one.sh).

Final candidate qualification compared 1,372 frozen inputs under five warning policies. **6,860/6,860** invocations matched all four observables, including 863 ordinary failures. [Source and policy counts](corpus.tsv).

The directed file suite checks weak and external calls, data-to-function references, x86 TLS models, local section targets, wide positive and negative addends, an actual COMDAT group, custom alignment and a large object containing relocations. All 756 directed compiler cases matched across six source and writer combinations (510 zero and 246 nonzero exits). All 30 publication outcomes matched for existing files, hard links, pipes and failing destinations. [Candidate fixture runner](qa.py), [file comparisons](cases.tsv.xz) and [destination checks](destinations.tsv.xz). GNU readelf decoded both wide signed addends, GOTTPOFF and TPOFF32 TLS references, and a two-member COMDAT section group in the accepted objects. [Decoded ELF examples](decoded-fixtures), [whole-file hashes](fixture-objects.tsv).

Apply the uncompressed net patch to Buster `0e1d5b825801135bf50e79da9d546bc95209ab30`. Applying `early-relocations.patch` and `large-data.patch` in order to the preceding writer produces the same tree. Use `BUSTER_OBJECT_TEXT_STREAM=1` with `BUSTER_OBJECT_EARLY_RELOCATIONS=1`, `BUSTER_OBJECT_DATA_SPANS=1`, or both. No other switch is required for the ordinary compiler mode. `BUSTER_OBJECT_STREAM_AUDIT=1` prints the bytes the writer actually borrows. [Full source patch](all-from-live-base.patch.xz), [tree verification](verified-patches.tsv) and [target host and input identities](target-reproduction/input-and-host.txt).
