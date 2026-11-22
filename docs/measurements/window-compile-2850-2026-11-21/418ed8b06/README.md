# Streaming native fragments into ordinary ELF objects

SQLite’s 2,665 source-encoded function fragments contain 1,063,662 machine-code bytes and 15,777 relocations. The Buster compiler input has 1,232 such fragments, 1,020,173 bytes and 17,068 relocations. These experiments carry their resolved instruction fields to final link publication, and borrow the machine-code storage when the ordinary compiler writes a Linux x86-64 ELF file. [Per-fragment and output counts](native-output.tsv).

## Controlled whole-compilation measurements

Each row compares fresh processes using the same Release executable on Ryzen 7 9700X CPU 2, one compiler lane, the same input and the normal file-producing `-c` command. Each child held the shared host lock independently. Each of eight balanced rounds measured a real on-disk ELF and compared its bytes, stdout and stderr to a separately built ordinary compiler. A second invocation measured hardware counters in three paired rounds. A third recorded one stage census per arm. The wall delta is the median of the within-round differences. [Wall samples](target-samples.tsv), [paired statistics](target-paired.tsv), [hardware counts](target-pmu.tsv), [stage records](target-stages.tsv) and [host and executable identities](target-reproduction/input-and-host.txt).

| Revision | Input | Same-executable comparison | Before ms | After ms | Paired Δ ms | Faster pairs | Paired Δ user instructions |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |
| 1a552aaf7 | SQLite | legacy → fields | 128.926 | 128.314 | -0.610 | 7/8 | -643,658 |
| 1a552aaf7 | SQLite | fields → both | 128.314 | 129.642 | +0.898 | 0/8 | +954,256 |
| 418ed8b06 | SQLite | legacy → fields | 130.114 | 129.509 | -0.276 | 7/8 | -494,024 |
| 418ed8b06 | SQLite | fields → stream | 129.509 | 129.789 | +0.112 | 4/8 | +1,158,765 |
| 418ed8b06 | SQLite | stream → packed | 129.789 | 129.928 | +0.061 | 3/8 | +1,314,777 |
| 418ed8b06 | SQLite | legacy → packed | 130.114 | 129.928 | -0.204 | 5/8 | +1,979,309 |

In both builds the independent ordinary compiler used revision `0e1d5b825`. The `legacy` timing arm activates the integrated source-local checker and early native encoder with the existing ELF writer. `fields` selects compact relocations, `text` selects per-atom scatter alone, `both` and `stream` select those two together, and `packed` also encodes adjacent native functions in contiguous storage. All 15 source-backend environment switches are identical across each within-build comparison. The compiler identifies its input file in ELF, so the absolute paths on the two machines give different complete-file digests. Every comparison uses the paths of its own host. The local Develop wall samples use a smaller set of source switches and a shared machine. [Local SQLite observations](local-sqlite.tsv) and [local Buster observations](local-main.tsv).

The completed target rows above cover SQLite. Its whole-process packed median is 129.928 ms for a 9,507,037-byte source input (73.2 MB/s). At this revision one packed stage sample spent 0.420 ms building the ELF, 0.407 ms writing it and 104.140 ms in check-input including early function production. Buster’s completed local correctness and Develop controls are included below. [Raw locked SQLite runs](target-raw.tar.xz).

## What each revision carries

- `86f494bcc` records a checked byte offset, relocation kind, local target and signed addend when a function is encoded. It clears the relocation field at that boundary, validates its width and order, and publishes the fields into the final Link columns once the translation unit assigns symbol identities. The 16-byte field replaces a 24-byte temporary reference. The encoder captures the source-local runtime targets before releasing its lowering tables. Wider addends use the ordinary representation. [Native field changes](native-fields.patch).
- `1a552aaf7` describes executable atom bytes to the regular file writer as borrowed spans. Metadata, relocation arrays, non-code sections, group information and symbol layout use the existing builder. Regular files use positional vectored writes, and sequential destinations use vectored writes. The complete image API stays available to callers which consume a flat object in memory. [Scatter writer](scatter-write.patch).
- `418ed8b06` writes adjacent source-owned functions into the same 256 KiB allocation. Function descriptors refer to the original backing and retain its extent. The object writer merges neighboring spans when the backing allocation and the physical and ELF offsets agree, including INT3 alignment bytes. [Packed encoder and writer](packed-text.patch).

| Functional fixture | Borrowed code bytes | Spans before / after packing | Actual positional writes before / after | Complete ELF bytes |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 1,065,651 | 5,165 / 21 | 21 / 1 | 2,061,200 |
| Buster | 3,290,350 | 2,512 / 333 | 10 / 2 | 11,276,208 |

The byte totals include ordinary fallback functions. The actual write counts came from `strace -c`; the stream audit independently counted the descriptors. The complete ELF, header, section table, symbols, relocation tables, notes, frame data, GNU groups and full disassembly all matched the independent ordinary output across 108 recorded component comparisons. The first per-function version caught an incorrect temporary runtime target in three SQLite aggregate assignments. Keeping the function’s referenced runtime indices alive fixed their memmove relocations. [Component hashes](elf-components.tsv), [SQLite syscall trace](sqlite-runs.syscalls) and [Buster syscall trace](main-runs.syscalls).

## Correctness and reproduction

Both the per-atom and packed revisions passed 280 compiler comparisons and 20 destination checks against the ordinary compiler. Each 280-case run contains 180 matching zero exits and 100 matching nonzero exits. The accepted policies cover aligned and named text sections, TLS, weak and external symbols, jump tables, inline assembly, patchable function entry, debug and unwind data. Both compilers reject the explicit PIC and function/data section switches in these invocations. Publication checks cover an existing file, a hard link, a FIFO, `/dev/null` and `/dev/full`. A debugger forced the first positional vectored write to consume only seven of 176 bytes, and strace forced an independent EINTR. Both resulting files matched the ordinary whole-file hash. [Per-atom file cases](1a552aaf7-compiler-files.tsv.xz), [packed file cases](418ed8b06-compiler-files.tsv.xz), [packed destinations](418ed8b06-destinations.tsv), [partial write](partial-write.log), [interrupted write](interrupted-syscall.log) and [object hashes](syscall-object-check.tsv).

Apply the uncompressed net patch to `0e1d5b825801135bf50e79da9d546bc95209ab30` in Buster. The three smaller patches apply in sequence to the `966a95df3` source-checker integration. The aggregate and component patches were applied to clean indices and verified against each candidate’s original Git tree identifier. [Net source patch](all-from-live-base.patch.xz), [source and tree IDs](sources.tsv), [patch verification](patch-verification.tsv) and [functional executable IDs](local-executables.tsv).

```sh
xz -dc all-from-live-base.patch.xz | git apply
./build.sh --config Release --target compiler
python3 compare-writer.py /path/to/ordinary /path/to/candidate /tmp/per-atom
python3 compare-packed-writer.py /path/to/ordinary /path/to/candidate /tmp/packed
python3 compare-corpus.py /path/to/candidate /path/to/ordinary /tmp/results group -- /path/to/input.c
```

The packed candidate matched **6,860/6,860** frozen status, full object, stdout and stderr comparisons, including **863** matching nonzero exits. The five policies are default, `-Wall -Wextra`, `-Wall -Wextra -Werror`, `-w` and `-Weverything`. [Frozen coverage](corpus.tsv).
