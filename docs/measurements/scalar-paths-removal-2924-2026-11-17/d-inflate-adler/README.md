# Adler-32 remainders in compressed debug sections

The compiler validates each zlib stream with Adler-32. Its existing vector loop consumes groups of 64 bytes, followed by a byte loop. These results cover the tail in phase D. [Issue #3454](https://github.com/buster14a/buster/issues/3454) · [Compiler source](https://github.com/buster14a/buster/blob/b42a31642f30d791cd59f2386a97334b74cceb9c/src/buster/compiler/inflate.c#L539)

GNU objcopy compressed the debug sections of 1,371 freshly compiled objects. The unmodified compiler decompressed every compressed section through its production zlib reader. The resulting bytes, sizes and checksums matched system zlib. The 4,759 compressed sections contained all 64 remainders. A total of 4,692 reached the scalar tail.

| Corpus | Objects | Compressed sections | Decompressed bytes | Distinct remainders |
| --- | ---: | ---: | ---: | ---: |
| lua | 34 | 191 | 821,392 | 58 |
| sqlite | 1 | 6 | 4,447,387 | 5 |
| musl | 1,336 | 4,562 | 2,373,205 | 64 |

Four bounded loads and reductions were compared with the compiled production function. The left-aligned load adjusts the weights for the live bytes. The right-aligned load keeps the full-block weights. The window implementation reuses bytes inside the input for lengths of at least 64 and uses a bounded expand-load for shorter ones. The fold implementation adds a modulo reduction using the identity 65,536 ≡ 15 (mod 65,521) to the left-aligned load.

Each table cell shows how many of the 63 positive tail lengths below one block reached parity. Three locked Release runs on the 9700X each rotated five independent translation units, with nine samples per function and size. All 146 measured lengths and their three placements are in the archive.

| Variant | Start of readable page | End of readable page | Offset 17 |
| --- | ---: | ---: | ---: |
| Left aligned | 54/63 | 0/63 | 54/63 |
| Right aligned | 0/63 | 56/63 | 17/63 |
| Final window | 43/63 | 0/63 | 43/63 |
| Fold | 59/63 | 0/63 | 59/63 |

A masked load with inactive lanes across a protected page remained expensive on the 9700X. Each native seed passed 43,680 independent RFC comparisons, including all-ones runs and the 4,096-block boundary. ASan and UBSan passed another 43,680 comparisons in the local build. Each variant misses at least one short length. [Section-level checksums, timings, sources and reproduction commands](adler-tail.tar.xz)
