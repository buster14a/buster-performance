# Reported user-mode instruction counts on the 7940HS

`perf stat -e instructions:u` of one `-c` each, pinned to CPU 2, by executables built from each tree with
`BUSTER_DEBUG_INFO=0 ./build.sh` (clang 23.1.4, `-march=native`: znver4). The original account says a tree's count
repeats to within 25 instructions within a session; raw local perf/session receipts are not retained here, so that
repeatability claim cannot be independently checked from this record. sqlite3.c is the frozen corpus's
(SHA-256 `0a409f16…`), with the 9700X job's options;
stb_image is `stb/` at `-march=native`. head3's, head6's and head7's objects are the base's, byte for byte.

| tree | what it is | sqlite3.c | against the session's base | stb_image | against the session's base |
|---|---|---:|---:|---:|---:|
| head | the first head, `effd18f6` | 1,312,623,771 | +542,309 (+0.0413%) | 187,389,118 | +407,557 (+0.2180%) |
| head2 | head, with one pass over a declaration's attributes (`head2.diff`) | 1,312,409,280 | +327,740 (+0.0250%) | 187,296,203 | +314,579 (+0.1682%) |
| control | head2, with the driver's two calls of the check and the always_inline keys' push compiled out (`control.diff`) | 1,312,532,512 | +451,149 (+0.0344%) |  |  |
| head3 | head2, with the filter's search skipped for callers without a key and the plain callers' answers kept (`head3.diff`) | 1,312,409,328 | +327,788 (+0.0250%) | 187,263,640 | +282,016 (+0.1508%) |
| head4 | head3, with `check_program_event_push` and `check_program_attribute_keys` out of line (`head4.diff`) | 1,312,011,631 | −69,932 (−0.0053%) | 187,244,061 | +262,449 (+0.1404%) |
| head5 | head4, with the bitset loop's keys in locals (`head5.diff`) | 1,312,011,636 | −69,927 (−0.0053%) | 187,240,358 | +258,746 (+0.1384%) |
| head6 | head5, with the host's features kept in `CheckProgram` (`head6.diff`): `1a036026`'s sources | 1,312,032,772 | −48,666 (−0.0037%) | 187,201,736 | +220,192 (+0.1178%) |
| head7 | head6, with errors in clang's emission order (`head7.diff`): `5cf49b03`'s sources | 1,312,035,498 | −46,169 (−0.0035%) | 187,200,557 | +218,834 (+0.1170%) |

The original account says each row's difference is against main's count in the same session. The retained pairs of
count and signed delta imply these baselines by subtraction; these are reconstructed denominators, not recovered raw
measurements:

| tree | implied sqlite3.c baseline | implied stb_image baseline |
|---|---:|---:|
| head | 1,312,081,462 | 186,981,561 |
| head2 | 1,312,081,540 | 186,981,624 |
| control | 1,312,081,363 | not recorded |
| head3 | 1,312,081,540 | 186,981,624 |
| head4 | 1,312,081,563 | 186,981,612 |
| head5 | 1,312,081,563 | 186,981,612 |
| head6 | 1,312,081,438 | 186,981,544 |
| head7 | 1,312,081,667 | 186,981,723 |

The implied ranges are therefore 1,312,081,363–1,312,081,667 and 186,981,544–186,981,723. The original prose's
maxima, 1,312,081,588 and 186,981,686, excluded head7's implied bases by 79 and 37 instructions. Its statement of
seven sessions cannot be reconciled to individual rows without the absent session receipts; this correction does
not infer a session count, measured extrema or run mapping. The reported counts, deltas, percentages, patches and
`sizes.txt` remain unchanged. This local attribution is separate from the raw-receipted 9700X comparisons.

The control's reported count runs none of the check's work, yet 451,149 more instructions than its stated main
comparison: the original attribution associates the rest of head2's cost with how clang compiled the passes the
change touched (`check_program` and the static objects' pass, whose sizes `sizes.txt` lists), and head4's `noinline`.
These manual local counts do not uniquely isolate layout or reproduce that attribution without the absent receipts.
Per-symbol samples (`perf record -e instructions:u -c N`) reportedly moved
by millions of instructions between functions whose code didn't change when N went from 10,007 to 9,973, so they
attribute nothing at this size; the builds above are the attribution.
