# The direct path's predefines (`c_direct`, buster#3592, from buster#3586)

Work of 2026-11-27. Two questions:

- what the arena's fixed-capacity tables cost a unit (buster#3586's open lever);
- once that came to nothing on small units, what the predefines cost one, and what cut it (buster#3592's step 2,
  without an image).

The change is [buster#3676](https://github.com/buster14a/buster/pull/3676), on main `7e28b4ed`.

- **Host:** `benchpress` (Ryzen 7 9700X), every run under `~/buster-fast-bench/exclusive.sh`, CPU 2, objects on
  `/dev/shm`. Work tree `~/buster-fast-bench/3586-claude2`.
- **Builds:** `BUSTER_HOST_ARCH=znver5 ./build.sh --config Release` on the host. Each build is main plus the patches
  under `patches/` (`scripts/build-variant.sh`), followed by `test-direct` (273 of 273 on main; the change's own
  tests are in `final.patch`).
- **Units:**
  - `add`: one function, the corpus's pinned predefines (`--predefines`), no headers;
  - `hello`: `stdio.h` and a `printf`;
  - `six`: seven standard headers and a `main`;
  - musl's `src/ctype/wcwidth.c`;
  - the frozen `sqlite3.c`;
  - Lua 5.4.8's 34 units and musl's 1,336 by `-std=c99` (`scripts/builds-ab.sh`).

## The arena's tables (buster#3586): not worth it on small units

`patches/arena-map.patch` reads with `mincore`, after the compile, which 4 KB pages of each arena are resident, by
allocation site (`scripts/map.sh`, `scripts/map1.sh`, `results/map-*.txt`).

- **`sqlite3.c`** (huge pages) touches 11 of its arena's 2 MB regions for 8.2 MB written
  (`map-map-sqlite.txt`, `map-map-sqlite-base.txt` with base pages).
- **Small units** take base pages, so a table's unused tail costs nothing; only each table's partly written last page
  could be saved. `patches/tiny.patch` sized every table to about what `add` needs
  (`BUSTER_DIRECT_TINY=1`).
  - Its map (`map-tiny-add-tiny.txt`) touches 41 arena pages where main's (`map-map-add.txt`) touches 46.
  - `results/ab-tiny-add.txt`, 11 rotated rounds of 100 compiles: 173.7 faults against 169.2, 0.2255 ms against
    0.2214 ms.
  - Most of those pages are the predefines' own data.
- The kernel's cycles of 300 `add` compiles, CPU-wide (`scripts/kprof-small.sh`, `results/kprof-main-add/`), are
  mostly the process's: `execve` 20%, the exit's `exit_mmap` 14%, the loop's `fork` 10%. All page faults are 26%,
  anonymous ones 6%.

## What a small unit pays for its predefines

`scripts/predef-cost.sh` (`results/predef-cost-main.txt`), `add`, 300 compiles a variant:

| | wall | user cycles | user instructions | faults |
| --- | ---: | ---: | ---: | ---: |
| the corpus's 473 predefined lines | 0.229 ms | 402 K | 708 K | 169 |
| an empty `--predefines` file | 0.179 ms | 223 K | 152 K | 150 |
| the product's own predefines | 0.224 ms | 397 K | 688 K | 169 |
| `--version` | 0.113 ms | 110 K | 63 K | 83 |

- **Counted** (`patches/count.patch`, `results/count-add.txt`): 281 directives, 229 of them `#define`s through the
  directive reader with a line-mode window each, and 20 floating literals read by `strtod`. The decimal lines already
  took `fast_pp_decimal_defines`.
- **The sampled profile misleads here.** `results/predef-prof-main/` (`instructions:u` by function) puts about
  117 K instructions in glibc's `strtof`, `strtoull` and `str_to_mpn` and 99 K in `fast_lex_number`. Deferring
  the 20 floats then saved 30 K. glibc's symbols in this static executable are not to be taken by function. Count
  calls, or build the variant.
- **The window a line isn't the cost:** `patches/e1.patch` lexed the predefines' directive lines with `fast_lex_one`.
  It took 2.7% of `add`'s instructions and no wall time (`results/ab-e1-add.txt`).

## The change

- `patches/lazy-float.patch`: a predefined macro's floating literal is read where it is first emitted
  (`results/ab-lazy-*.txt`). On `add`: 741 K to 711 K instructions, 423 K to 395 K user cycles.
- `patches/batch.patch`: the above, plus `fast_pp_simple_defines`, which defines every one-token body in a batch
  (`results/ab-batch-*.txt`). With the corpus's predefines, 409 of 473 lines take it and 65 the reader
  (`results/count-batch-local.txt`, a local count).
- `patches/final.patch`: the pull request's code and tests. Its comments' wording differs from the merged commit's.

Final readings, `results/final-*.txt`, rotated rounds, CPU 2:

| | main | change | |
| --- | ---: | ---: | ---: |
| `add`, 11 rounds of 100 | 0.2192 ms | 0.2033 ms | -7.3% |
| its user cycles | 417 K | 347 K | -16.8% |
| its user instructions | 741 K | 532 K | -28.2% |
| `wcwidth.c` | 0.3333 ms | 0.3146 ms | -5.6% |
| `hello` | 0.5254 ms | 0.5035 ms | -4.2% |
| `six` | 1.4182 ms | 1.3810 ms | -2.6% |
| musl's 1,336 units, `-std=c99`, 5 rounds | 1,183.4 ms | 1,163.0 ms | -1.7% |
| Lua's 34 units, 7 rounds | 116.3 ms | 115.2 ms | -0.9% |
| `sqlite3.c`, 11 rounds of 3, user instructions | 212,048,957 | 212,055,415 | +0.003% |

`sqlite3.c`'s wall read 16.72 against 16.30 ms. The floats-only build read the same against main, with 85 K more
instructions. Neither change does work there worth 0.4 ms, so that is the code's placement, not a gain.

The extra faults of the lazy and batch builds' first readings (+2 to +4) are code-page placement too.
`scripts/faults.sh` (`results/faults-*.txt`) lists every fault of one `add` compile by its code. They differ by single
faults in libc and the driver's start, and the final build reads 167.1 against main's 167.0.

## Checks

- **The corpus** (`equiv/`, adapted from buster-performance `direct-kernel-3586-2026-11-25`, the path by the
  `.comment` section): main and the change give each of the 7,767 runs the same status, diagnostics, object and path.
  2,548 of them are the direct path's (`equiv/main.tsv`, `equiv/final.tsv`).
- **`test-direct`:** 275 of 275 on the change.
  - `one-token macro definitions`: each form, the same again, a different identifier or string again, and the
    reader's lines (two blanks, a comment, a trailing blank, an escaped string, a character constant).
  - `a predefined macro's floating literal`: four values, an unused `F16` literal quiet, a used one left to the full
    pipeline.
- `./build.sh check-call-graph`: no new cycle.
