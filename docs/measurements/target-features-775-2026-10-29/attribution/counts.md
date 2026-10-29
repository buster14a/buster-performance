# Exact user-mode instruction counts on the 7940HS

`perf stat -e instructions:u` of one `-c` each, pinned to CPU 2, by executables built from each tree with
`BUSTER_DEBUG_INFO=0 ./build.sh` (clang 23.1.4, `-march=native`: znver4). Within a session, a tree's count repeats to
within 25 instructions. sqlite3.c is the frozen corpus's (SHA-256 `0a409f16…`), with the 9700X job's options;
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

Each row's difference is against main's count in the same session: main's runs read 1,312,081,363 to
1,312,081,588 for sqlite3.c and 186,981,544 to 186,981,686 for stb_image over the seven sessions.

The control runs none of the check's work, yet 451,149 more instructions than main: the rest of head2's cost was
in how clang compiled the passes the change touched (`check_program` and the static objects' pass, whose sizes
`sizes.txt` lists), which head4's `noinline` undoes. Per-symbol samples (`perf record -e instructions:u -c N`) moved
by millions of instructions between functions whose code didn't change when N went from 10,007 to 9,973, so they
attribute nothing at this size; the builds above are the attribution.
