# The direct path's macro calls and directives in bulk (`c_direct`, buster#3584)

[buster#3584](https://github.com/buster14a/buster/issues/3584): after #3580 the direct path lexed the text a window
of raw tokens at a time, but read a directive's line and a function-like macro call's arguments a token at a time
(`fast_pp_read_tok`), scanned each macro's body on every call for the parameters to prescan, and substituted a body
a token at a time. This record has the profile and counts that steered the change, each step's readings, and what
was measured and not kept. The change is on buster's branch `claude/relaxed-ramanujan-s6acj8` (main `20f3573e`).

- **Host:** `benchpress` (Ryzen 7 9700X), every run under `~/buster-fast-bench/exclusive.sh`, CPU 2, the object on
  `/dev/shm`. Directory there: `~/buster-fast-bench/3584-direct-s6acj8`.
- **Unit:** the frozen `sqlite3.c` with the corpus's headers and predefines, as `tools/ci/compile-count.sh`
  compiles it.
- **Builds:** the harness around `c_direct_try_compile`
  ([`direct_main.c`](../direct-speed-2850-2026-11-24/scripts/direct_main.c)) built for znver5 with CI's clang
  23.1.4 in a cloud container and shipped (`scripts/mk.sh`); copies with a 16- or 48-byte nop function ahead of the
  lexer's code (`scripts/mkpad.sh`), since code placement moves the preprocess stage by up to ~1.5% between builds
  of the same source; the product built on the 9700X as its job builds it (`scripts/bld.sh`: znver5 Release, no
  debug information).
- **Scripts:** `ab.sh` (the harness's stages and counters, rotated rounds), `ab-product.sh` (the product's `-c`, one
  compile a process), `mc.sh` (the job's `measure-compile --instructions-baseline` step), `prof.sh` (samples by
  function and line), `count_patch.py` (counters in a copy of the sources), `faults.py` (single-line faults against
  `test-direct` and sqlite3.c's object), `equiv/` (every corpus unit's status, diagnostics and object by two
  compilers), `test_main.c` (a runner around `run_c_direct_tests`).

## Result

| 9700X, `sqlite3.c`, CPU 2 | main `20f3573e` | the change | |
| --- | ---: | ---: | ---: |
| the product's `-c`, wall (21 rotated runs) | 16.410 ms | **16.250 ms** | -1.0% |
| user cycles | 81.11 M | **80.43 M** | -0.8% |
| user instructions | 221.07 M | **211.56 M** | -4.3% |
| the harness: lexing and preprocessing (9 rounds, median of 3 placements) | 6.953 ms | **6.756 ms** | -2.8% |
| the harness: parsing and generating code | 8.58 ms | 8.55 ms | |
| `measure-compile`'s instructions (the job's step) | 220,900,743 | **211,376,346** | -4.3% |
| the compile's count (`tools/ci/compile-count.sh`) | 46,559,904 | **44,508,722** | -4.41% |
| the object | `f558aaf503fcb186` | the same | |

`results/ab-product-final.txt`, `ab-harness.txt` (hold 8: main from hold 6, the change as `finA`),
`measure-compile-final.txt`. Main's own count was already 4.3% under `tools/ci/compile-instructions.txt`'s
230,887,792 (earlier merges moved it); the change writes its count there.

Merged with main `3f1bfb5a` (the pull request's head, whose compiler sources are main's and the change's two files),
both built on the 9700X (`results/ab-product-merged.txt`, `measure-compile-merged.txt`):

| | main `3f1bfb5a` | merged | |
| --- | ---: | ---: | ---: |
| the product's `-c`, wall (21 rotated runs) | 16.400 ms | **16.230 ms** | -1.0% |
| user cycles | 81.48 M | **80.38 M** | -1.3% |
| user instructions | 220.55 M | **211.49 M** | -4.1% |
| `measure-compile`'s instructions | 220,380,383 | **211,305,483** | -4.1% |
| the compile's count (against main `09c3b79b`) | 46,313,221 | **44,266,098** | -4.42% |
| the object | `f558aaf503fcb186` | the same | |

Merged with main `7344577f`, after #3610 (#3585) gave the window 16-bit starts (`results/ab-product-merged-7344577f.txt`,
`measure-compile-merged-7344577f.txt`): the product's `-c` 16.400 -> 16.280 ms (-0.7%), user cycles 81.23 -> 80.50 M
(-0.9%), instructions 219.45 -> 209.87 M (-4.4%); `measure-compile` 219,275,145 -> **209,685,270**, the count the change
writes in `tools/ci/compile-instructions.txt`; the compile's count 46,304,069 -> 44,196,524 (-4.55%).

## Where the time was (`results/profile-main`, by function, share of user cycles)

| function | main | after the change's first steps (`s4`) |
| --- | ---: | ---: |
| `fast_pp_try_expand_ex` / `fast_pp_run_calls` | 5.49% | 3.75% |
| `fast_pp_read_tok` | 2.95% | 1.00% |
| `fast_ident_lookup` (out of line) | 1.79% | 1.15% |
| `fast_pp_window_macro` | 1.35% | 2.21% (with the window's argument collection) |
| `fast_pp_handle_define` | 1.19% | 1.01% |
| `fast_pp_window_convert` (new) | | 1.70% |
| `fast_pp_read_line` (new) | | 0.79% |

By line on main, the engine's hottest part was the body scan for parameters to prescan (134,015 iterations a
compile, about 1.4% of the compile), then its substitution loop (about 1.3%); `fast_pp_handle_define`'s hottest line
was the store of each body token, whose fields `fast_pp_read_tok` had written a field at a time.

## Counts a compile (`results/counts.txt`, main)

- 94,010 reader calls: 30,445 for a directive's keyword, an `#if`'s line or a name, 7,938 for a `#define`'s name and
  parameters, 22,153 for its body (16,396 tokens and 5,757 line ends), 4,449 peeks for a call's `(`, 29,025 for a
  call's arguments from the text. 14,028 line windows.
- 13,519 directives: 5,757 `#define` (693 function-like), 1,625 `#if`, 1,675 `#ifdef`, 1,217 `#ifndef`, 2,325
  `#endif`, 363 `#else`, 289 `#include`, 241 `#undef`.
- 12,955 function-like calls, 4,443 of them from the text. Of `fast_pp_window_macro`'s 4,431 function-like names,
  4,409 have their `(` next and their `)` in the same window with no token left to `fast_lex_one` between (28,612
  argument tokens, 10,004 identifiers); 11 have such a token, 5 cross the window's end, 3 have more than 64 tokens.
- 103,710 argument tokens collected (74,685 from expansion frames), 154K substituted tokens, 3,425 prescans.

## The steps (`results/ab-harness.txt`)

| step | what it added | preprocess stage | user cycles |
| --- | --- | ---: | ---: |
| main | | 6.95-6.96 ms | 79.7-80.3 M |
| s3 | `#define` bodies and `#if` lines read in bulk (`fast_pp_read_line` over `fast_pp_window_convert`); a call's arguments from the window in bulk (`fast_pp_window_args`); each macro's prescan list made at `#define` | 6.785-6.795 | 79.3-80.0 M |
| s4 | a `#define`'s parameters read with its body in one bulk read; a line's end without a reader call; a body without `#` and `##` substituted by copies between its parameters' places | 6.73 | 78.2-78.96 M |
| s6 | arguments from the expansion frame on top in bulk (`fast_pp_frame_args`); the macro's index kept in the call | 6.885 (one hold) | 79.3 M |
| s7 | the depths' prefix sum only where a `(` comes before the first `)` | 6.72-6.79 | 78.4-78.7 M |
| finA (merged) | the frame path's bound fixed (below), the tests | 6.75-6.76 | 78.5-78.9 M |

- **What paid:** taking the reader's per-token call, seek and gap scan away from 60 K directive tokens and 29 K
  argument tokens; the prescan list (134 K body-token iterations become a walk of each macro's list of the parameters it names plainly); copies
  for substitution.
- **Measured and not kept:**
  - **The drain's loop over an expansion frame's tokens, eight a step** (`s8`): their kinds and data stored whole,
    a loop over the names and literals. 6.78-6.80 ms against `s7`'s 6.73-6.78: an expansion's frames are short and
    stop at the next macro's name, and the token loop is near its floor (as the 2026-11-25 record found for the
    window emitter).
  - **A `#define`'s body tokens all written again whole** (`fin`), so that no load waits on the first token's
    one-byte flag store: 6.79 ms against 6.756 without (`finA`), +9 K mispredicted branches.
- **Neutral, kept:** arguments from expansion frames in bulk (`s6`/`s7` against `s4`: the same stage time, 0.77 M
  fewer instructions). The prefix sum's six dependent permutes cost more than the branch that skips them (`s6`
  against `s7`).
- A first build of `s6`'s frame path computed the frame's address before testing that the call had one
  (`pp->expand + (expand_depth - 1)` with no frame open): at `-O2` and `-O3` the load came after the test, at `-O1`
  it faulted. The fault round's `-O1` runner found it; fixed before the readings above.

## Checks

- **Objects:** every unit of the 6,201-unit corpus (`../direct-speed-2850-2026-11-24/scripts/equiv`) and musl's
  1,355 units again with `-std=gnu99` (664 of them on the direct path) give the same status, diagnostics and object
  as main: 7,556 units, 1,860 direct (`scripts/equiv/run.sh`, which adds the gnu99 pass).
- **`test-direct`** gains a case list of macro calls and directives (nested and empty calls, variadic ones, `#` and
  `##` operands, a call from an expansion that ends in the text, long arguments, strings past 255 bytes, numbers that
  go on, character literals, comments in arguments), each at every offset of a block between six pairs of
  separators; a call at each place across a window's 2,048-token end; and `__LINE__` after calls and directives over
  lines. Its renderings were made from main's preprocessor and pass there.
- **Faults** (`results/faults.txt`): every single-line fault in the change's code that changes behaviour fails
  `test-direct`; the four that survive are equivalent (the reason beside each).
- ASan and UBSan builds of `test-direct` and of the harness on `sqlite3.c` (the same object); `check-call-graph`
  (no cycle); the unity units' ownership check.
