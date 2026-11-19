# A build's places beyond one compile: header images, a unit's fixed cost, the process (2026-11-19)

Evidence for the design issue [buster#ISSUE](https://github.com/buster14a/buster/issues/ISSUE): what a build of
many units pays outside the per-token pipeline that
[buster#2850](https://github.com/buster14a/buster/issues/2850) budgets, and the first test of a design that takes
those costs out. It is research: nothing here changes the compiler. The one compiler change, the census's hooks, is an
experiment patch kept in `scripts/patch/` and never meant for a pull request.

- **Source:** buster main `6427879e1143026a12fb0388a20bdea1fe4b2bc5` (the merge of #3027). Built `./build.sh --config
  Release` in the cloud container and, under the lock, on the 9700X (`tree/` in
  `~/buster-fast-bench/build-images-claude`, 83.5 s).
- **Hosts:**
  - The cloud container (Xeon at 2.1 GHz, 4 vCPUs under KVM, transparent huge pages `madvise`, no PMU): the
    censuses, the emulation's exactness, and preliminary timings. Its process and page-fault costs are several times
    the 9700X's; its timings only rank.
  - The 9700X (Linux 6.18.50, two holds of the lock, compiles on CPU 2, four lanes on CPUs 2 to 5, eight on 0 to 7,
    `perf stat` user and kernel cycles): every figure below quoted in cycles. `host-before.txt` and `host-after.txt`
    in each job list what else ran.
- **Workloads:**
  - musl: the frozen corpus (`tools/ci/fetch-corpus.sh`, `preprocessor-391e729af658`) with the one-core record's
    selection and options (`scripts/census/musl-units.sh`, `musl-opts.sh`): 1,336 units, 1,464,170 bytes of source,
    5,039,561 tokens by `reduce.py`'s count.
  - Lua 5.4.8 (`https://www.lua.org/ftp/lua-5.4.8.tar.gz`, SHA-256
    `4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae`): its 34 `src/*.c` with its Makefile's Linux
    options less readline, `-std=gnu99 -O2 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX`, over each host's own glibc headers.
  - buster's own ten `main_unit_*.c` at the same commit (the censuses only).
- **Not committed:** the corpora, the `-E` outputs, the reduced units (they are third-party text: `reduce.py` makes
  them again) and the census's raw lines (38 MB for musl: the patched compiler makes them again).

## In short

- **Where a musl unit's cycles go as a build tool runs it, a process a unit** (9700X, user and kernel): 6.72 M cycles
  a unit. The process is 3.90 M of them (58%), the headers' work 1.31 M (19%), the unit's own start and end in a
  command 0.38 M (6%), and its own code with the header declarations it reaches 1.13 M (17%). The first three are
  outside [#2850](https://github.com/buster14a/buster/issues/2850)'s budget, which counts cycles a token of one
  compile: its 73 cycles a token on musl's tokens, with today's process and start, would make this build 1.47 times
  faster.
- **The headers' work repeats.** 93% of musl's preprocessed tokens and 62% of Lua's come from headers. Each distinct
  text of a file processed once would leave 11% of musl's tokens and 44% of Lua's (`files.py`). By exact keys, a
  segment of a header's processing whose key (the file, its start, every macro name it looked up and the definition
  it had) an earlier unit of the build already had: 95.5% of musl's header segments and 91.9% of their tokens, 93.5%
  and 82.8% of Lua's, counting the keys whose outputs or effects the census couldn't show equal as misses. A key is
  51 names on musl (median 12) and 15 on Lua (median 5): 2.4 and 2.9 header tokens a name.
- **An emulation of units fed from header images is exact and halves the work.** `reduce.py` keeps each unit's own
  top-level items and the header items its own code reaches by name, transitively: 23% of musl's tokens. On the
  9700X every `.text`, `.data` and `.rodata` of the 1,336 objects (4,008 sections) and of Lua's 34 (102) is the same
  bytes as the originals'. musl's command on one lane takes 2,027 M cycles where the originals take 3,770 M (1.86
  times; user instructions 2.42 times); Lua's 260.8 M where they take 427.5 M (1.64 times).
- **A unit's fixed cost and the process.** 1,336 empty units in one command take 513 M cycles, 384 K a unit (147 K
  user, 237 K kernel, 50 faults a unit). A unit as its own process costs 3.90 M cycles more than in the command. A
  static process that only exits takes 18 to 19 µs to spawn and wait for; a client that connects to a Unix socket,
  sends its arguments with its three standard descriptors and its working directory, and waits for a status byte,
  27 µs; `/usr/bin/true` 94 µs; the compiler's `-c` of an empty file 322 µs.
- **The images' own work is small on Zen 5.** For 37 header segments a unit, 51 names a key, 22 macros set a segment,
  256 own names and 600 token rows: validating the keys 3.0 K TSC ticks a unit by scalar loads (gathers 3.6 K; they
  win only at 160 names a key, 1.12 against 1.29 ticks a name), setting the macros 1.5 K (scatters the same), copying
  the rows 0.2 K by 64-byte moves. On four lanes each lane takes 1.00 to 1.15 times what one lane takes.

## 1. The headers' share, by text (`segments.py`, `files.py`)

Each unit's `-E` output with its line markers, split into the unit's own tokens and its top-level inclusions'
(segments), or into each file's own tokens in each inclusion (files), keyed by the file's path and the hash of its
tokens' text. `results/cloud/text-census-{musl,lua,self}.txt`.

| | units | own tokens | header tokens | file inclusions | distinct (file, text) | their tokens | each distinct text once |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| musl | 1,336 | 342,572 | 4,697,046 | 15,712 | 437 | 233,815 | 11.4% of the tokens, 8.74 times fewer |
| Lua | 34 | 225,153 | 364,453 | 1,740 | 111 | 31,583 | 43.5%, 2.30 times fewer |
| buster's ten units | 10 | 0 | 32,678,050 | 4,987 | 1,402 | 12,254,028 | 37.5%, 2.67 times fewer |

By top-level inclusion (a header with everything it includes) the texts repeat much less: musl's 2,976 inclusions
have 514 distinct texts holding 21.4% of the header tokens, because a header's text leaves out whatever an earlier
inclusion already included. That is the granularity [#111](https://github.com/buster14a/buster/issues/111)'s
transcripts had (`header-replay-2026-10-23`).

## 2. The headers' share, by exact keys (`scripts/patch/image-census.patch`, `images.py`)

The patch (experiment only) adds hooks to `c_preprocessor_impl.c`: every lookup of a macro name
(`pp_is_macro`) and every macro set (`pp_set_macro`) is attributed to the current **segment**: a file's processing
from its entry, or from its return from a nested inclusion, to its exit or its next nested inclusion. A segment's
line holds the unit, its depth, the file's device and inode, the segment's start token, its output's count and
hash, the macros it set, and each name it looked up before setting it with the hash of the definition it had (0 for
none). With `BUSTER_PP_IMAGE_CENSUS_FILE` set, `-c --lanes 1` of a command writes them. A key is (file, start, the
sorted observed names with their definitions).

| | header segments | distinct keys | segments whose key repeats | their tokens | conservative: segments, tokens | names a key: mean, median, p90 | macros set a segment |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| musl | 49,857 | 1,889 | 96.2% | 95.3% | 95.5%, 91.9% | 50.9, 12, 160 | 21.8 |
| Lua | 10,302 | 461 | 95.5% | 87.6% | 93.5%, 82.8% | 15.2, 5, 38 | 5.7 |
| buster's ten units | 29,788 | 3,870 | 87.0% | 71.5% | 85.5%, 64.0% | 84.6, 6, 204 | 9.6 |

- **The check.** Every use of a key must give the same output and the same macros set. All 1,889 of musl's keys give
  the same token count each time. The first run hashed the output's values and found 519 keys whose uses differ:
  the values of tokens other than names are places, which differ by unit; hashed by kinds, flags and names' ids
  (the second run), every key's output agrees. 7 keys (musl), 5 (Lua) and 41 (buster) still show two hashes of the
  macros they set, each split between two variants, in `stdio.h`, `fcntl.h`, `wctype.h` and one other: the census
  hashes a definition by its file view's bytes, which an inclusion's private view can change, and that wasn't
  chased. The conservative column counts every use of those keys as a miss.
- **No segment expanded a unit-dependent builtin** (`__COUNTER__`, `__INCLUDE_LEVEL__`, `__BASE_FILE__`, `__DATE__`,
  `__TIME__`, `__TIMESTAMP__`) on any of the three.
- **The token counts are the output stream's**, a segment's from its start to its end: they add to 6.52 M on musl
  where `-E` has 5.04 M, so the census's token shares are shares of its own count. The segment shares don't depend on
  it.
- **What a unit validates:** 1,911 names on average on musl (median 1,666), 4,599 on Lua. Applying what the segments
  set: 812 macros a musl unit (1,084,812 in all).

## 3. The emulation: units fed as images would feed them (`reduce.py`)

`reduce.py` reads a unit's `-E` output, splits it into top-level items (a declaration to its `;`, a function to the
brace that closes its body), and keeps the unit's own items, every header item that is an external definition, and
the header items that declare a name a kept item names (ordinary names, tags and enumerators), until nothing new is
reached. It then writes the kept items as a preprocessed unit named as the original. Its reach is approximate and
wider than [#2531](https://github.com/buster14a/buster/issues/2531)'s (8.0% of header items kept, where #2531 reaches
4%: an inline assembly operand's name or a parameter's can match an own local's). It keeps 23.0% of musl's tokens
(1,158,239 of 5,039,561) and 78.7% of Lua's, whose own headers are most of what its units name.

**Exact:** on the 9700X (`objects.txt`), all 4,008 of musl's `.text`, `.data` and `.rodata` sections and Lua's 102
are the originals' bytes; in the container, every musl `.text`. The first version of the script dropped the
external definitions of a `.c` file that a unit includes (`libc_calloc.c` includes `calloc.c`), and a record type
with an attribute's parentheses was taken for a function: both found by the objects' comparison and fixed.

**On the 9700X** (`results/9700x/job1-*/table.txt`, medians of five rounds; a process a unit, one round; M cycles):

| musl, 1,336 units | user | kernel | all | a unit | user instructions | faults |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| a process a unit, one after another | 4,940.3 | 4,038.5 | 8,978.8 | 6.72 M | 11,371.4 M | 745,152 |
| one command, one lane | 2,793.9 | 976.3 | 3,770.2 | 2.82 M | 6,809.9 M | 275,603 |
| the reduced units, one command, one lane | 1,307.5 | 719.6 | 2,027.1 | 1.52 M | 2,817.2 M | 151,912 |
| the reduced units, a process a unit | 1,944.6 | 2,936.7 | 4,881.3 | 3.65 M | 3,006.7 M | 503,473 |
| 1,336 empty units, one command | 196.2 | 316.9 | 513.1 | 384 K | 523.3 M | 67,133 |
| one command, four lanes | 3,177.8 | 1,621.4 | 4,799.2 | 3.59 M | 6,940.2 M | 282,264 |
| the reduced units, four lanes | 1,439.6 | 1,106.9 | 2,546.5 | 1.91 M | 2,823.7 M | 150,649 |
| one command, eight lanes (job 2) | | | 6,141.0 | 4.60 M | | |
| the reduced units, eight lanes (job 2) | | | 3,126.3 | 2.34 M | | |

| Lua, 34 units | all, one lane | four lanes |
| --- | ---: | ---: |
| one command | 427.5 | 657.5 |
| the reduced units | 260.8 | 426.6 |

- A unit's cycles on lanes rise 1.27 times at four and 1.63 times at eight; the kernel's 2.43 times at eight (job
  2's medians, 983.1 M on one lane to 2,392.5 M): the discards' TLB flushes of
  [#1213](https://github.com/buster14a/buster/issues/1213).
- `perf stat -x`'s `duration_time` reads 0 on this host, so the second job has no wall times; the cycles are what
  this record compares.

## 4. Where the reduced units still spend (container, `stages.sh`)

`--time-stages` summed over the units, each compiled as its own process (so `setup` is the process's), in ms:

| stage | originals | reduced | empty units |
| --- | ---: | ---: | ---: |
| check-input | 2,103.6 | 865.9 | 126.7 |
| preprocess | 2,016.8 | 980.6 | 855.9 |
| setup | 1,149.4 | 1,276.9 | 1,206.1 |
| check-program | 543.8 | 128.4 | 62.8 |
| parse | 466.7 | 249.3 | 117.5 |
| lower | 277.4 | 255.3 | 97.6 |
| check-expressions | 181.6 | 121.5 | 19.9 |
| total | 7,568.0 | 4,605.6 | 3,038.3 |

The headers' work is in `check-input`, `preprocess`, `check-program` and `parse`. An empty unit's `preprocess` is
the predefines' (856 ms over 1,336 processes). What the reduced units add over the empty ones is mostly
`check-input` (739 ms): their own code and the reached declarations.

## 5. The images' kernels (`scripts/kernels/image_kernels.c`)

A unit's image work alone, 20,000 units a lane, each lane with its own macro definitions (65,536 names, an eighth of
them macros) and every lane reading the same 4,096 images; TSC ticks a unit. Parameters from the census: 37 header
segments a unit (49,857 / 1,336), 22 macros set a segment, 256 own names, 600 token rows of reached declarations.
The reach's figure includes making its random names (about 3 ticks a name), so it bounds the test from above.

| on the 9700X, ticks a unit | names a key: 12 | 51 | 160 |
| --- | ---: | ---: | ---: |
| validate, scalar loads | 819 | 3,035 | 7,646 |
| validate, gathers | 900 | 3,579 | 6,621 |
| set the macros, scalar stores; scatters | 1,523; 1,455 | 1,555; 1,549 | 1,546; 1,493 |
| reach over 256 names, scalar; vector | 1,356; 1,508 | 1,356; 1,509 | 1,353; 1,508 |
| copy 600 rows, a dword at a time; 64 bytes | 1,723; 205 | 1,717; 181 | 1,720; 212 |

Four lanes on CPUs 2 to 5 give each lane 1.00 to 1.15 times these (`kernels.txt`; the most: the copy at 51 names,
1.15, and validation by scalar loads at 12, 1.14). The container's figures are in
`results/cloud/kernels.txt`.

## 6. The process's floor (`scripts/spawn/`)

`spawnbench N PROGRAM` spawns and waits for a program N times on CPU 2 (a build tool's one job). `tiny` is a static
program that only exits; `client` connects to `server` (on CPU 3) over a Unix socket, sends its arguments with
descriptors 0, 1, 2 and an `O_PATH` descriptor of its working directory (`SCM_RIGHTS`), and exits with the status
byte the server answers.

| on the 9700X | µs a spawn |
| --- | ---: |
| `tiny` | 17.9; 18.2, 19.2, 19.1 |
| `client`, the round trip included | 27.2, 26.6, 27.6 |
| `/usr/bin/true` (dynamic) | 94.4 |
| the compiler's `-c` of an empty file | 321.6 |

## Reproducing

```sh
export CORPUS=/path/to/preprocessor-391e729af658 COMPILER=/path/to/buster/build/compiler
scripts/census/musl-units.sh | xargs -P 4 -I{} scripts/census/pp-one.sh {} OUT
python3 -I scripts/census/files.py OUT/*.i; python3 -I scripts/census/segments.py OUT/*.i
python3 -I scripts/census/reduce.py RED OUT/*.i      # then name RED's files as the originals (measure.sh does)
# the census: apply scripts/patch/image-census.patch to the same commit, build Release, then
BUSTER_PP_IMAGE_CENSUS_FILE=census.tsv $PATCHED -c --lanes 1 "${opts[@]}" $(scripts/census/musl-units.sh)
python3 -I scripts/census/images.py census.tsv
# the 9700X jobs: scripts/9700x/measure.sh and measure2.sh, each under exclusive.sh; tables by reduce_perf.py,
# the figures above by scripts/numbers.py (results/numbers.txt)
```
