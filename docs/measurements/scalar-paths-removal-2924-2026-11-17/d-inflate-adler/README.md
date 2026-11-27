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

## Keeping the partial load inside accessible pages

Moving the masked load back by the smaller of the initial cache-line offset and the unused lanes keeps the full memory window inside the input’s accessible pages. Only active bytes are read. The second candidate combines that load with the final full-block reduction. The third forms the ordinary and weighted sums with two dot products and combines them for one horizontal reduction.

| Variant | Full 63 lengths at start, wins | At end, wins | At offset 17, wins |
| --- | ---: | ---: | ---: |
| Fold control | 59 | 0 | 58 |
| Safe window | 56 | 56 | 56 |
| Block and tail together | 44 | 44 | 44 |
| Paired sums | 54 | 54 | 54 |

Position no longer changes the safe-window count. The candidate beats the production byte loop on 56 of 63 lengths in each placement. The missed short lengths retain the scalar loop. All three native sanitizer-independent RFC runs and the local ASan/UBSan run passed 43,680 comparisons each. [Implementation and exact size results](cache-line-loads.tar.xz)

## Processing the partial block before the full blocks

Processing the partial prefix first starts the checksum at one, so the prefix’s contribution does not require multiplying a running checksum by the number of bytes. Other candidates process a bounded window in 16- or 32-byte tiles and compute both Adler sums together. Each candidate passed the RFC checksum oracle. Each entry counts short lengths at parity or better out of 63, using the median ratio of three independent 9700X runs.

| Variant | Page start | Page end | Offset 17 |
| --- | ---: | ---: | ---: |
| Rebased 64-byte control | 56 | 56 | 56 |
| 16-byte tiles | 51 | 51 | 50 |
| 32-byte pairs | 52 | 52 | 47 |
| Plain 16-byte tiles | 51 | 3 | 51 |
| Prefix, 64-byte fold | 60 | 60 | 60 |
| Prefix, 16-byte tiles | 59 | 59 | 59 |
| Prefix, 32-byte pairs | 57 | 57 | 57 |
| Prefix, constant modulus | 60 | 60 | 60 |

The 64-byte prefix variants still lose for one, two and three bytes in each placement. [Sources, three sets of timings and independent correctness receipts](prefix-and-word-reductions.tar.xz)

## Four-byte partial groups and paired full blocks

The candidate starts with the partial block. A single dot product accumulates A and the weighted contribution to B in adjacent lanes. For the last one to three bytes, the loaded first, middle and last positions can coincide. A coefficient table gives each real byte its proper weight. Full 64-byte chunks run in pairs with two independent weighted accumulators. Both checksums are reduced modulo 65,521 after at most 4,096 chunks.

| Prototype | Positive short length/placement cells at parity | All initial cells at parity |
| --- | ---: | ---: |
| word_gather | 168/189 | 405/438 |
| word_bounded | 165/189 | 406/438 |
| word_gather_mod | 174/189 | 414/438 |
| word_bounded_mod | 171/189 | 410/438 |
| loop_gather | 189/189 | 428/438 |
| loop_bounded | 186/189 | 425/438 |
| loop_gather_reduce | 186/189 | 426/438 |
| loop_bounded_reduce | 183/189 | 419/438 |
| full_skip | 189/189 | 434/438 |
| full_pair | 186/189 | 435/438 |
| full_odd | 189/189 | 438/438 |
| full_after | 186/189 | 428/438 |

The cleaned production source for the paired-block variant (`full_odd`) produced the same 840 bytes of optimized function text as the timed prototype using the local Release flags. The separately compiled production source met the gate in **6,177/6,177 size/placement comparisons** on the 9700X. Each cell is the median ratio across three processes, each using nine interleaved samples. The input covers every size 0–1,024, all 1,133 distinct lengths from 4,759 real compressed sections, and all 64 remainders at additional block boundaries. The longest input is 2,171,532 bytes. Placements start at a protected-page boundary, end at one, or start at offset 17. The median ratio across equally weighted cells was 0.548. The largest ratio was 0.9995. Those ratios measure the checksum function.

The exact implementations in the complete compiler passed the two gzip-backed suites with 88,823 and 88,103 checks on both sides. The independent sanitizer run detected all nine deliberate changes to byte placement, weights, pair order, carry and modulus. [Complete timing series, baseline controls, implementation, fixtures and test receipts](four-byte-groups-and-block-pairs.tar.xz)
