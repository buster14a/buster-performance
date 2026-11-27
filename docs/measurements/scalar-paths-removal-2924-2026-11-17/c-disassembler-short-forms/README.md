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
