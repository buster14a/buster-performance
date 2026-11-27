# Diagnostic source snippets and column maps

The baseline reads a printable prefix, formats one exceptional character, then classifies the remaining bytes again. The replacement validates UTF-8 and identifies characters requiring formatting in masked blocks of 64 bytes. The output cursor visits those characters in source order. A split UTF-8 lead is included in the next block. Both output paths share the diagnostic buffer's growth logic. [Baseline](https://github.com/buster14a/buster/tree/2e4400b66b351a989625acbcb80ba079cbb31310) · [Measured compiler](https://github.com/buster14a/buster/tree/8a4a96e27f99ce88594ba06d1d43d5bf50d82cce) · [Issue #3439](https://github.com/buster14a/buster/issues/3439)

The preprocessor suite reached 9,106 source snippets and 239,932 input bytes. Six characters required Unicode rendering. The purpose-built warning inputs reached tabs, controls, malformed bytes and printable or escaped multibyte characters. Another 2,600 complete warning diagnostics moved the caret past such bytes. They matched Clang exactly across 1,250,920 bytes of output. The separate warning fixtures that put arbitrary bytes in the message also produced identical baseline and candidate output. Clang escapes some control bytes in the warning message itself differently from both compiler builds.

## Native size gate

Each input ends at a protected page. Lengths cover 0–128 and the five positions centered on each power of two from 256 through 4,096. The longest production input is 4,096 bytes. Each process takes 11 alternating samples per implementation and reports the middle one. The table reports the median of the 154 per-size candidate/baseline cycle ratios, with three locked, CPU-2-pinned native Release measurements per size. Every one of the 6,160 combinations was faster. The least favorable ratio was 0.869.

| Input | Buffered | Direct | Arena growth | Stream on exhaustion |
| --- | ---: | ---: | ---: | ---: |
| Printable ASCII | 0.729 | 0.773 | 0.600 | 0.699 |
| Tabs | 0.047 | 0.094 | 0.051 | 0.093 |
| ASCII controls | 0.065 | 0.092 | 0.065 | 0.092 |
| Legal UTF-8 | 0.154 | 0.184 | 0.158 | 0.181 |
| Malformed UTF-8 | 0.111 | 0.145 | 0.112 | 0.143 |
| Mixed | 0.111 | 0.145 | 0.112 | 0.144 |
| Sparse tabs | 0.467 | 0.518 | 0.422 | 0.506 |
| Sparse controls | 0.433 | 0.465 | 0.396 | 0.470 |
| Sparse malformed bytes | 0.406 | 0.471 | 0.428 | 0.449 |
| Sparse UTF-8 | 0.398 | 0.465 | 0.380 | 0.447 |

The memory oracle also repeated all lengths and shapes through 32 byte phases in four output modes with ASan and UBSan (197,120 comparisons). A second protected-tail sweep checked 5,373,952 inputs, including all two-byte strings, all code points encoded into one through four bytes, and three-byte strings starting at 0xC0–0xFF. Width, source columns, text and the output terminator agreed. Thirteen independent mutations failed. The checked-in suite has 3,960 generated spelling, placement and buffer cases. The full preprocessor suite passed with 419 fixtures and 4,795 Clang child invocations on the 9700X.

## Whole commands

The first two columns summarize five rounds of five runs for two production builds and a duplicate baseline. The same-path experiment rotates four binary copies through the same filename for 16 balanced repeats, comparing the sum of the two candidate medians with the sum of the two baseline medians. The last experiment selects an implementation in the same binary when a source snippet is first requested. Lua, musl and SQLite emit no diagnostics in these invocations. Numbers are changes in user cycles.

| Input | Three-build change | Baseline control | Same-path change | Same-image change |
| --- | ---: | ---: | ---: | ---: |
| one | +6.633% | +0.773% | -3.268% | +0.000% |
| ordinary | +0.885% | +0.260% | -1.717% | -5.372% |
| mixed | -6.250% | +0.877% | -9.084% | -11.813% |
| wide | -59.880% | -0.433% | -60.341% | -60.800% |
| lua | +0.432% | +0.267% | pending | +0.155% |
| sqlite | +0.064% | +0.033% | pending | -0.075% |
| musl | -0.323% | +0.020% | pending | -0.091% |

Running one copy of each production build for seven rounds of eight runs favors the candidate on all seven inputs, including the three quiet controls. The first three-build diagnostic run assigned two entries to the baseline executable. Reversing that choice assigns two entries to the candidate. The single-warning result changes sign with the duplicated executable. The four-copy same-path measurements balance both implementations, as does the direct A/B comparison below. The reverse control was also run for the 512 ordinary warnings. Each entry reports the median ratio of paired user cycles from the seven rounds.

| Input | Equal-frequency A/B | Two candidate entries |
| --- | ---: | ---: |
| one | -0.415% | -2.392% |
| ordinary | -2.051% | -4.286% |
| mixed | -9.539% |  |
| wide | -59.872% |  |
| lua | -0.015% |  |
| sqlite | -0.147% |  |
| musl | -0.425% |  |

## Reproduction

Extract the archive, then run `python3 reproduce/prepare.py /path/to/buster unit`. Compile `unit/base.c unit/head.c unit/width.c reproduce/gate.c` with `-Iunit -O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing` and the pinned Clang 23 toolchain. Run the executable with `time MODE` under `exclusive.sh taskset -c 2` for three passes per mode (0–3 in table order), or `check MODE` for the guarded oracle. Replace the gate source with `reproduce/exhaustive.c` and add `-fsanitize=address,undefined` for the exhaustive oracle. The synthetic allocator in this harness permits bounded growth or deliberate allocation failure. The compiler suite independently exercises its actual arena and stream implementation. The archive includes fixture generation, census rows, timings, correctness and mutation receipts. [Download measurements](snippet-columns.tar.xz)
