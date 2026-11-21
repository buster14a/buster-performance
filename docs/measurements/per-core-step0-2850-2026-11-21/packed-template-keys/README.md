# Step 0 with a 64-bit checked template key

All four cells of this seven-pass experiment met the 20-cycle target while preserving the scalar twin's coverage, every entry and the branch-miss limit. The five-round, 21-pass qualification is separate.

| Frozen stream | Taken nodes | Matched entries | Cycles/node, repeated | Cycles/node, after scalar | Branch misses/node, repeated / after scalar |
| --- | ---: | ---: | ---: | ---: | ---: |
| sqlite3 | 257,465 | 346,998 | 14.10 | 19.30 | 0.0190 / 0.0200 |
| musl | 115,610 | 154,132 | 19.20 | 19.60 | 0.0480 / 0.0590 |

The template selector packs its 16 fields and operator into eight bytes. Each field has a disjoint bit range. Inputs outside the represented ranges set the refusal bit. The mapping for the store byte distinguishes 0 through 126 and 255, which includes every observed value. Reversible shifts and odd multiplication permute the packed key. The lookup address proves the high bits and the row checks all remaining bits. An empty row encodes a miss. Only table generation and the scalar reference's given inputs are outside the measured interval.

The context pass computes parent-independent rules once per block. Only rules that read an inherited context can need another evaluation. The context column uses a dense code, which the baked table maps back to the original context for verification. The experiment retains the paid scalar replay of structurally distant expressions. Its full root sets agree with the scalar twin on SQLite and musl. The other variants in this series price sparse distant-operand repair, short writes and compressed template flags independently.

Each comparison ran three symmetric rounds on the Ryzen 7 9700X CPU 2 under the hardware lock, with two process positions per mode and seven passes per process. The after-scalar series executes the scalar twin for 200 ms before every timed pass. Each reported cell is the median of the round means. The paired control for the final key change uses the same dense context encoding. These experiments measure the stand-alone sweeps on the frozen node streams. Fact-word production, source parsing and object emission are outside this interval.

The [paired table](paired.tsv) includes every control and range. The [process table](samples.tsv), [native compilation and timing logs](native-receipts.tar.xz), [source hashes](sources.tsv) and [ASan/UBSan runs](packed-key-sanitizers.tar.xz) retain the individual checks. Sanitizer runs covered windows of 64 and 4,096 records and the full unit on both streams. For reproduction, start with the [window-storage and single-row sources](../working-set-and-lookups), run the dynamic-rule and context-column generators, then the packed-key generator. Each comparison script contains the precise build and timing commands.
