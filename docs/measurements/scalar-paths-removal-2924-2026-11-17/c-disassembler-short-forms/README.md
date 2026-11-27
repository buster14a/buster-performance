# Fixed short instruction forms in the x86 disassembler

The candidate materializes complete fixed one- and two-byte instructions during initialization using the proposed lane decoder from buster14a/buster@07bfd1a5972461452d81582a5819ee06aeace958. A matching record can be copied directly. FWAIT requires a third byte to distinguish some x87 forms, so the table excludes it. The 65,536 decoded-record slots also add initialization work. [Base work in #3451](https://github.com/buster14a/buster/issues/3451#issuecomment-7222721667)

On the Ryzen 7 9700X, a single-instruction call takes 70.867 ns per instruction with the table. The original scalar route takes 31.693 ns. At four instructions the table takes nearly twice the original scalar time. The per-size replacement gate remains open.

| Instructions per call | Original scalar, ns/insn | Lane decoder, ns/insn | Lane decoder plus short forms, ns/insn |
| ---: | ---: | ---: | ---: |
| 1 | 31.693 | 100.230 | 70.867 |
| 2 | 21.584 | 49.539 | 45.770 |
| 4 | 13.527 | 26.487 | 26.149 |
| 8 | 9.261 | 13.912 | 14.494 |
| 16 | 8.671 | 7.912 | 7.977 |
| 64 | 7.759 | 7.995 | 7.740 |
| 256 | 7.562 | 7.531 | 7.732 |

Each entry is the median across three runs of the 21-pass synthetic compiler stream, pinned to core 2 under the shared lock. Initialization is excluded from decode timing. The initial benchmark headers report their original size metric, which omits the experimental fixed-record array. The raw logs include initialization time and hardware counters.

The differential fixture checks all byte strings of length zero through two and 200,000 generated strings of length three through 64. It checks capacities zero through three for each string, including returned count, consumed bytes, status, and the entire returned decoded records. The two serialized outputs have SHA-256 `b6c895df8d78b3132527d8ff8a5759f323c337e8e987213e9491c38d93b3f72f`. The unrevised FWAIT table produced a different output.

`runfixed` gives the exact shifts in run order, build command and shared-host baseline location. `mini.c` drives the published lane decoder and its benchmark. `short2.patch` is the candidate relative to the revision above. Run the driver inside the shared exclusive lock after placing these files in its working directory. [Measurements](results)

## REX register forms and trailing fields

The REX implementation bakes complete register-direct encodings after a REX prefix. It excludes FWAIT when later bytes can extend the instruction. The trailing-field implementation also bakes byte shuffles for ordinary integer ModRM forms carrying displacement or immediate bytes, plus near call and jump displacements. Unknown forms return to the shared lane decoder. The baked arrays increase table storage. The benchmark’s original printed table-byte counter omits these experimental arrays.

Both candidates reproduced all 1,063,172 original differential outputs. The REX candidate also matched 786,432 combinations of register-direct inputs with varied trailing bytes. The trailing-field candidate matched 2,715,648 targeted cases including truncated inputs, positive and negative displacements, and immediates. Each comparison hashes complete records, offsets, counts, consumption and status. The 9700X ran the project’s 21-pass compiler stream benchmark three times per size and implementation under the exclusive lock.

| Candidate | Instructions per call | Scalar ns/instruction | Existing vector | Candidate |
| --- | ---: | ---: | ---: | ---: |
| rex | 1 | 31.577 | 100.729 | 54.649 |
| rex | 2 | 22.026 | 51.599 | 41.122 |
| rex | 4 | 13.548 | 26.521 | 25.832 |
| rex | 8 | 9.297 | 14.394 | 14.624 |
| rex | 16 | 8.682 | 8.115 | 8.239 |
| rex | 64 | 7.814 | 7.936 | 7.710 |
| rex | 256 | 7.514 | 7.489 | 7.524 |
| recipe | 1 | 31.618 | 97.569 | 27.040 |
| recipe | 2 | 22.194 | 49.505 | 22.218 |
| recipe | 4 | 13.579 | 25.955 | 16.084 |
| recipe | 8 | 9.251 | 13.549 | 12.489 |
| recipe | 16 | 8.607 | 7.830 | 8.507 |
| recipe | 64 | 7.805 | 7.991 | 7.279 |
| recipe | 256 | 7.517 | 7.267 | 6.929 |

The trailing-field variant improved the singleton from 97.569 ns in the existing vector implementation to 27.040 ns, below scalar’s 31.618 ns. It still missed scalar at two, four and eight instructions. [Source, exact samples and differential receipts](register-and-trailing-forms.tar.xz)

## Testing segment overrides on address-size-limited forms

The existing negative test on decoder branch `07bfd1a59` exercised zero instructions and failed its minimum-coverage assertion. Of the 520 catalogue form numbers marked as unable to accept an extra address-size prefix, 116 are unsegmented and none of those 116 passes the decoder's supported-form filter. Each of the three segment-override groups contains 40 supported row numbers. Enumerating encoded form numbers and preserving their segment override exercises 1,323, 1,306 and 1,300 encodings with seeds 1, 919 and 2161. The unmodified decoder passed all three runs. An intentional change accepting the extra prefix failed every one of the first seed’s 1,323 cases. GNU objdump and reassembly agreed on 13,319 catalogue and 10,001 generated instructions. [Test change, coverage census and complete native summaries](segmented-address-test.tar.xz)

## Indexed addresses and SIMD operand extraction

The address-table trial covers ordinary SIB addressing and complete escaped register forms with a mandatory prefix. Its statuses, lengths and full decoded records matched the earlier decoder for 9,498,624 additional indexed-address and escaped cases. The next implementation uses SIMD multishift to extract register numbers, vector source registers and decorations from VEX and EVEX encodings. The register trial handles register-direct operands. The memory trial also handles plain base/index addressing with the catalogue’s displacement scale. Both passed 2,605,824 differential cases derived from vector catalogue instructions, including malformed prefixes and truncation. GNU objdump and reassembly confirmed 13,319 catalogue instructions and 10,001 generated instructions on each variant.

The following counts use three independent medians at calls of 1, 2, 4, 8, 16, 64 and 256 instructions. The existing scalar implementation was measured in each comparison. Units for singleton calls are ns per instruction.

| Candidate | Stream | Sizes at parity or better | Scalar singleton | Candidate singleton |
| --- | --- | ---: | ---: | ---: |
| address | compiler | 7/7 | 31.568 | 12.378 |
| vreg | compiler | 7/7 | 31.749 | 8.875 |
| vreg | vector | 5/7 | 35.588 | 35.987 |
| vmem | compiler | 7/7 | 31.466 | 8.724 |
| vmem | vector | 7/7 | 35.394 | 17.763 |

Three real Lua text sections also decoded completely in both implementations. The initial address trial missed the single-instruction scalar time on the Lua VM. A census of those misses identifies integer shifts, immediate moves, indexed memory without displacement and two-byte opcodes. Complete real-stream results and the coverage counts appear alongside the sources. The original table-byte counter excludes the experimental arrays. [Patches, measurements and independent checks](indexed-addresses-and-vector-operands.tar.xz)

## Packing operand templates and indexing escaped integer forms

The first integer-operand compiler grew from 198,496,800 to 217,424,864 executable bytes. Sharing identical 64-ModRM pages and recording eight-byte templates with shared shuffle controls reduced the image to 202,757,792 bytes. The smaller image decoded and printed all three Lua sections identically and passed the baked-table checks. On the captured sections, MOVZX, conditional branches and SETcc accounted for many remaining visits to the full lane decoder.

Adding unprefixed 0F integer and common SIMD forms to the indexed operand decoder reached parity or faster in all 55 initial stream/size comparisons. The 9700X test alternated binary order over three processes at sizes 1, 2, 3, 4, 8, 16, 32, 64, 128, 256 and 1,024. Times below are ns/instruction. Ratios divide the new decoder by the shipping scalar decoder at the same count. The final escaped candidate includes further tables beyond the smaller image measured above.

| Stream | Scalar singleton | Expanded decoder singleton | Eight-instruction ratio | Largest ratio across 11 sizes |
| --- | ---: | ---: | ---: | ---: |
| compiler | 31.613 | 9.505 | 0.913 | 0.942 |
| vector | 35.438 | 17.675 | 0.515 | 0.536 |
| lvm | 28.070 | 10.950 | 0.832 | 0.832 |
| lcode | 27.491 | 7.900 | 0.805 | 0.913 |
| ltable | 27.030 | 7.309 | 0.672 | 0.765 |

Compared to the complete original lane decoder, all returned instruction bytes, counts, consumed lengths and statuses agreed on 3,342,336 integer cases, 3,342,336 escaped-opcode cases, 2,605,824 vector cases and 9,498,624 indexed-address cases. The native suite passed 113,317 checks. GNU objdump and GNU as agreed on both sets of 13,319 and 10,001 catalogue/generated instructions. The dense small-call gate and final baked-image comparisons are being measured separately. [Source changes, standalone drivers, exact observations and differential receipts](matched-and-escaped-operands.tar.xz)
