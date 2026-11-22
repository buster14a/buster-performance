# Carrying native data and complete ELF64 relocations to file publication

This extension of the [native fragment writer](../418ed8b06/README.md) borrows large static atoms directly from the final link and produces `Elf64_Rela` rows when the object builder first classifies their target symbols. Both mechanisms run at the ordinary ELF output boundary. Each works with the existing unit-wide compiler and with the experimental function-local native producer.

## File layout

During ELF symbol classification the fixup target is already known to be a local, global, undefined, or section-relative symbol. The producer records the final section-relative relocation offset, ABI relocation type and checked signed addend. It keeps just the symbol class and position in the row’s symbol slot. After section and symbol placement that slot becomes the final ELF symbol index. The file writer borrows the relocation array directly. The general linker still supplies the normalized source fixups and determines symbol and section order. [Verified patch against 418ed8b06](early-relocations.patch).

Previously each large file-backed non-text atom was copied to the object image just before a disk write. At `83599c1e7` the scatter writer borrows atoms of at least 4,096 bytes. Smaller atoms share the existing contiguous section buffer. This includes writable data, read-only literals and immutable unwind atoms such as .eh_frame. Virtual zero-fill sections consume no file bytes. [Large-data change](large-data.patch).

| Frozen input | Complete native ELF | Borrowed text bytes | Borrowed relocation bytes | Borrowed non-text atom bytes | Output spans |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite | 2,061,200 | 1,065,651 | 538,632 | 154,106 | 36 |
| Buster | 11,276,208 | 3,290,350 | 952,416 | 5,373,660 | 383 |

With source-local encoding active, strace counted one actual positional vectored write for the 36-span SQLite file and two for the 383-span Buster file. Both traced files matched the independent ordinary objects. With the ordinary unit-wide schedule the writer borrows the same byte classes, while independently encoded text atoms may require more spans. The target Buster ordinary audit reported 2,561 spans. [SQLite syscalls](sqlite-verified-data.syscalls) and [Buster syscalls](main-verified-data.syscalls). The remaining image consists of ELF and section headers, symbol tables, short atoms, alignment and other metadata. The file builder still reserves its full logical ELF range. The borrowed spans remove writes into the corresponding image pages, so the byte coverage measures copying at the final boundary. The flat in-memory builder continues to serve callers that require a complete contiguous ELF. [Equality and coverage](frozen-layout.tsv).

## One-core fresh compilation

The same Ryzen 7 9700X Release executable runs with the ordinary unit-wide compiler and separately with the experimental source-local path. In the ordinary experiment `ordinary` uses the existing contiguous output, `text` borrows native text, `data` also borrows static data, and `complete` additionally borrows preclassified ELF relocations. In the source-local experiment `packed` starts from the packed text and compact source fields, `rela` and `data` add the respective single feature, and `complete` adds both. Eight balanced rounds compare file-producing processes on CPU 2, with independent lock acquisitions and a fresh comparison to the ordinary reference object after every invocation. The first three rounds also measure hardware events in matched runs. [Individual observations](target-samples.tsv), [wall and PMU pairs](target-paired.tsv) and [stage census](target-stages.tsv).

| Source schedule | Input | Before → after | Before ms | After ms | Paired Δ ms | Faster pairs |
| --- | --- | --- | ---: | ---: | ---: | ---: |
| Source-local | SQLite | packed → rela | 130.055 | 129.411 | -0.648 | 5/8 |
| Source-local | SQLite | packed → data | 130.055 | 129.709 | -0.915 | 4/8 |
| Source-local | SQLite | packed → complete | 130.055 | 129.498 | -0.990 | 5/8 |
| Source-local | Buster | packed → rela | 654.699 | 654.393 | -0.725 | 5/8 |
| Source-local | Buster | packed → data | 654.699 | 655.405 | -0.435 | 4/8 |
| Source-local | Buster | packed → complete | 654.699 | 655.479 | +0.247 | 4/8 |
| Ordinary | SQLite | ordinary → text | 114.104 | 114.512 | +0.065 | 4/8 |
| Ordinary | SQLite | text → data | 114.512 | 114.297 | -0.140 | 4/8 |
| Ordinary | SQLite | data → complete | 114.297 | 114.696 | +0.317 | 3/8 |
| Ordinary | SQLite | ordinary → complete | 114.104 | 114.696 | +0.081 | 4/8 |
| Ordinary | Buster | ordinary → text | 614.355 | 614.186 | +0.507 | 4/8 |
| Ordinary | Buster | text → data | 614.186 | 612.500 | -0.669 | 7/8 |
| Ordinary | Buster | data → complete | 612.500 | 613.086 | -0.231 | 4/8 |
| Ordinary | Buster | ordinary → complete | 614.355 | 613.086 | -0.861 | 5/8 |

The four-arm experiment completed all 128 wall measurements, 48 separate PMU measurements and 16 stage censuses on the controlled host. With all borrowing features enabled, SQLite’s ordinary process median was **114.696 ms** (82.9 MB/s) and its source-local median was 129.498 ms. The 1 GB/s objective allows 9.507 ms for the complete source. The paired ordinary SQLite sample spans a −26.5 ms through +8.9 ms difference, including an outlier in the first balanced round.

| Complete writer vs schedule baseline | Paired whole wall Δ | Faster wall pairs | Paired user instructions Δ | Paired peak RSS Δ KiB |
| --- | ---: | ---: | ---: | ---: |
| SQLite, ordinary unit-wide | +0.081 ms | 4/8 | -564,507 | +0 |
| Buster, ordinary unit-wide | -0.861 ms | 5/8 | -1,854,438 | -2 |
| SQLite, source-local | -0.990 ms | 5/8 | +1,029,611 | +0 |
| Buster, source-local | +0.247 ms | 4/8 | +1,668,846 | -2 |

One ordinary Buster stage sample reduced ELF construction from 1.301 to 0.973 ms while publication moved from 2.114 to 2.264 ms. The measurements bound file production to a small share of the observed whole-program gap. [Complete raw per-process observations](target-raw.tar.xz).

Final candidate qualification compared 1,372 frozen inputs under five warning policies. **6,860/6,860** invocations matched all four observables, including 863 ordinary failures. [Source and policy counts](corpus.tsv).

The directed file suite checks weak and external calls, data-to-function references, x86 TLS models, local section targets, wide positive and negative addends, an actual COMDAT group, custom alignment and a large object containing relocations. All 756 directed compiler cases matched across six source and writer combinations (510 zero and 246 nonzero exits). All 30 publication outcomes matched for existing files, hard links, pipes and failing destinations. [Candidate fixture runner](qa.py), [file comparisons](cases.tsv.xz) and [destination checks](destinations.tsv.xz). GNU readelf decoded both wide signed addends, GOTTPOFF and TPOFF32 TLS references, and a two-member COMDAT section group in the accepted objects. [Decoded ELF examples](decoded-fixtures), [whole-file hashes](fixture-objects.tsv). The system C driver linked both variants of each fixture with an independent runtime check. All eight executables exited successfully, and each pair also matched in linked executable bytes. [Runtime checks](linked-executables.tsv), [driver](link-roundtrip.py) and [link toolchain](linker-toolchain.txt).

Apply the uncompressed net patch to Buster `0e1d5b825801135bf50e79da9d546bc95209ab30`. Applying `early-relocations.patch` and `large-data.patch` in order to the preceding writer produces the same tree. Use `BUSTER_OBJECT_TEXT_STREAM=1` with `BUSTER_OBJECT_EARLY_RELOCATIONS=1`, `BUSTER_OBJECT_DATA_SPANS=1`, or both. No other switch is required for the ordinary compiler mode. `BUSTER_OBJECT_STREAM_AUDIT=1` prints the bytes the writer actually borrows. [Full source patch](all-from-live-base.patch.xz), [tree verification](verified-patches.tsv) and [complete target traces](target-raw.tar.xz).
