# What a compile does outside the bodies' path, ranked, and the file scope read once per command: the measurements behind buster#2531's design (2026-11-12)

These are the measurements that [buster#2531](https://github.com/buster14a/buster/issues/2531)'s design
(`docs/attested-declarations.md` in buster) rests on, taken for
[buster#672](https://github.com/buster14a/buster/issues/672)'s one-core target beside
[buster#2524](https://github.com/buster14a/buster/issues/2524)'s, whose record is
[`one-core-design-672-2026-11-12`](../one-core-design-672-2026-11-12/README.md). That design takes the function
bodies' path from the parser's tree to the typed stream. This record measures everything else a compile does (the
file scope's declarations, a unit's fixed costs, the preprocessor, the parser, the emission), ranks it by what the
compile would cost without each part, and then measures what the first-ranked part's design would do: an emulation of
its rule on the real units, whose compiles are timed and whose objects are compared, and a prototype of the passes it
adds. Nothing here measures the design itself: it isn't built.

- **Source:** buster `ecaf57b5a27a1f9a4c12c59362599cce51ab2fa0` (main on 12 November), a clean clone built on the host
  by `./build.sh` (Release, `-O3 -march=native`, debug information), `raw/build-src.log`. The executable's SHA-256 is
  `299006aaa05c75107af1dec93865ab63c15e982487b12a23fd0c71b67c1beb35`.
- **A second tree with a measurement patch,** `scripts/probe.patch`, for the counters read in the process (section 2)
  and the asm index's switch (section 5): `raw/build-src-probe.log` (`b9192b9d…`, the counters alone) and
  `raw/build-src-probe-2.log` (`4f68cdfd…`, with the switch). Without its environment variables the patched build
  runs as the clean one (`raw/probe/stat-clean-*.csv` beside `stat-patched-*.csv`). No timing but section 2's, 5's and
  the stage tables of sections 6 and 8 comes from it.
- **Host:** the Ryzen 7 9700X (`benchpress`), Linux 6.18.50, clang 23.1.1, perf 7.2.9. `env.txt` has the kernel, the
  CPUs, the governors, transparent huge pages, the tools' versions and every script's hash.
- **Every run** was one hold of the machine's lock (`scripts/lock.sh`, through `scripts/queue.sh`, whose logs are
  `raw/queue-*.log`), pinned to CPU 2, whose SMT sibling is offline and whose governor is `performance`. Each script
  writes the lock's own line for its hold first (`raw/*/holder.txt`).
- **Workloads:**
  - **musl:** the frozen corpus's musl (`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`), the first source
    of each base name, 1,336 units, as one command on one lane (`-c --lanes 1`), with the first record's options. It
    is 5,039,639 preprocessed tokens.
  - **`sqlite3.c`:** `-c` of the frozen corpus's `sqlite3.c` with the 9700X job's `compile_time` options: 716,136
    tokens.
  - **Generated glibc units** (section 8): 512 small units over the host's glibc headers, `scripts/tools/gen_units.py`.
- **`scripts/tables.sh`** makes every file of `tables/` again from `raw/`.

## 1. The command and its variants

`scripts/prep.sh` makes the inputs: each musl unit preprocessed (`-E -P`), each without its function bodies
(`scripts/tools/units.py`, by the first record's `spine.py` rule: a file-scope `{` after a `)` to its `}` becomes `;`),
1,336 empty units and 1,336 units of one declaration, and `sqlite3.c` preprocessed and without bodies. `scripts/musl.sh`
then runs the command and its variants, 5 rounds, each round every variant once in turn under `perf stat`.
`tables/medians.txt` (`scripts/tools/stat_medians.py`), medians:

| variant | user cycles | kernel cycles | CPU ms | page faults |
| --- | ---: | ---: | ---: | ---: |
| `-c` of the sources | 4,457 M | 1,098 M | 1,003.1 (996.2 to 1,039.0) | 343,028 |
| `-fsyntax-only` of the sources | 3,542 M | 976 M | 816.1 | 337,526 |
| `-c` of the preprocessed units | 3,705 M | 913 M | 838.7 | 255,700 |
| `-c` of the units without bodies | 2,005 M | 688 M | 488.8 | 194,241 |
| `-fsyntax-only` of the units without bodies | 1,861 M | 580 M | 442.3 | 192,852 |
| `-c` of 1,336 units of one declaration | 226 M | 351 M | 104.5 | 75,825 |
| `-c` of 1,336 empty units | 196 M | 321 M | 95.1 | 64,454 |
| `-E` of each source, 1,336 processes | 1,724 M | 2,236 M | 720.4 | 435,426 |

The times are the task clock's (CPU time): the command's wall time also has the objects' writes' waits on the file
system, which vary from 9 to 163 ms of the `object-write` stage between variants in one directory
(`tables/musl-stages.tsv`), so no figure here is a wall time.

**A first pass is kept as `raw/musl-pass1`.** Its units without bodies failed in 255 units: a body cut to `;` leaves
musl's `weak_alias()` naming a function the unit no longer defines, an error. `scripts/prep2.sh` cuts the alias
attribute from those units' text (287 of them in 192 units), and `raw/musl` is the pass after it; the other variants'
medians of the two passes agree within 0.5%.

## 2. Counters by stage, read in the process

A many-unit command reports its units' stages as one (`lanes`). `scripts/probe.patch` gives the patched tree
`BUSTER_PROBE`: every lap of the stage clock reads five hardware counters with `rdpmc` (user cycles and instructions,
kernel cycles and instructions, demand fills from DRAM) and charges them to its stage, and the units of a one-lane
command share one clock, whose marks are laps (no `getrusage`, no `/proc` read). The time between two units is the
`lanes-start` row. `scripts/probe.sh` runs it on the command's variants (3 runs each) and on `sqlite3.c` (5 runs).
`tables/musl-stages.tsv` and `tables/sqlite-stages.tsv` (`scripts/tools/probe_table.py`), medians, in millions of
cycles:

| stage | musl: user | kernel | without bodies: user | kernel | empty units: user | kernel | `sqlite3.c`: user | kernel | without bodies: user | kernel |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| setup | 33.1 | 53.2 | 17.1 | 11.3 | 11.4 | 11.0 | 0.2 | 0.9 | 0.2 | 0.9 |
| between two units | 26.8 | 256.6 | 16.8 | 151.2 | 12.7 | 134.6 | | | | |
| preprocess | 705.1 | 187.1 | 185.4 | 117.7 | 116.4 | 73.1 | 42.2 | 11.1 | 2.6 | 3.4 |
| parse | 261.3 | 60.0 | 137.1 | 63.1 | 11.5 | 9.2 | 22.5 | 17.3 | 4.5 | 4.6 |
| type-table | 25.4 | 39.1 | 19.4 | 35.2 | 3.7 | 3.9 | 0.0 | 0.2 | 0.0 | 0.2 |
| check-input | 2,061.2 | 219.4 | 1,476.6 | 131.2 | 13.5 | 10.0 | 217.8 | 37.5 | 53.4 | 11.1 |
| check-expressions | 145.0 | 8.7 | 16.0 | 7.9 | 1.2 | 0.0 | 57.5 | 6.2 | 0.9 | 0.7 |
| check-declarations | 52.9 | 2.3 | 28.4 | 2.3 | 1.6 | 0.0 | 10.5 | 0.5 | 1.1 | 0.1 |
| static-data | 21.2 | 0.1 | 16.1 | 0.1 | 0.5 | 0.0 | 2.4 | 0.5 | 0.8 | 0.1 |
| check-program | 439.0 | 88.1 | 58.9 | 12.5 | 6.6 | 1.9 | 128.8 | 3.6 | 7.7 | 4.3 |
| select | 28.6 | 25.8 | 13.1 | 28.5 | 2.2 | 4.9 | 4.8 | 1.4 | 0.7 | 0.2 |
| lower | 593.2 | 9.5 | 28.7 | 0.1 | 7.4 | 0.1 | 60.6 | 2.4 | 0.7 | 0.1 |
| tier0 | 40.6 | 0.4 | | | | | 29.9 | 0.6 | | |
| the rest of the emission and the object | 90.5 | 87.8 | 29.9 | 97.8 | 14.5 | 60.1 | 22.3 | 3.6 | 0.5 | 1.6 |
| release | 2.5 | 22.5 | 1.7 | 18.0 | 1.1 | 9.7 | 0.0 | 0.5 | 0.8 | 0.8 |
| sum | 4,526 | 1,061 | 2,045 | 677 | 204 | 319 | 599.7 | 86.3 | 73.9 | 27.9 |

- The sums are within 4% of `perf stat`'s (4,457 M and 1,098 M for musl): the counters' own reads are in them, and
  the process's start and exit are outside the clock.
- **musl's `check-input` is 2,061 M user cycles, 46% of the command's, and 1,477 M of them are the file scope's** (the
  units without bodies): 407 user cycles a file-scope token (3,630,633 of them), where the parse of the same tokens
  takes 38.
- **`lower` is 593 M on musl, and 520 M of it is `lower.prepare`** (94.6 of the stage's 108.4 ms), which the units
  without bodies don't pay (5.0 ms): section 5.
- **The kernel's cycles are 19% of musl's command**, a quarter of them between two units.

`scripts/profile.sh` profiles the same variants by function (`uarch symbols` of buster's `tools/microarch`, built
from the clean tree), and the kernel's cycles with call chains (`raw/profile/`). `tables/musl-families.tsv` and
`tables/sqlite-families.tsv` (`scripts/tools/families.py`) group the functions by a name's prefix. In musl's units
without bodies, of 2,057 M sampled user cycles: the reader's declaration steps (`check_input_declarator_step`,
`check_input_declaration`, `check_input_specifiers` and their kin) 784 M, the parser 158 M, the reader's unit-wide
passes and setup 146 M, its walk in source order 94 M, the preprocessor 88 M, the expressions' walk 86 M, the type
table 82 M, the lexer 70 M, `memset` 52 M.

## 3. The ranking

`scripts/tools/rank.py` (`tables/ranking.tsv`): each lever's cycles of both modes from section 2's stages, and the
compile without them. A lever is a part of the work outside buster#2524's scope:

| lever | how it is measured | musl: M cycles | share | without it | `sqlite3.c`: M cycles | share | without it |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| reading the file scope's declarations | the checker's stages (`type-table` to `select`) on the units without bodies, less the empty units' | 1,795.9 | 32.1% | 1.474 times | 81.2 | 11.8% | 1.134 times |
| the kernel: pages and system calls | every kernel cycle | 1,060.5 | 19.0% | 1.234 | 86.3 | 12.6% | 1.144 |
| the preprocessor and the lexer | the `preprocess` stage | 892.2 | 16.0% | 1.190 | 53.3 | 7.8% | 1.084 |
| the asm matcher's index | the patched build's two ways (section 5) | 556.4 | 10.0% | 1.111 | 0 | | |
| a unit's own start and end | the empty units' whole compile (`sqlite3.c`: an empty unit's process) | 522.7 | 9.4% | 1.103 | 1.8 | 0.3% | 1.003 |
| the parser and the tree's columns | the `parse` stage | 321.3 | 5.8% | 1.061 | 39.7 | 5.8% | 1.061 |
| the emission, Tier 0 to the object | the stages from `tier0` to `object-write` but `lower` | 219.2 | 3.9% | 1.041 | 56.4 | 8.2% | 1.090 |
| *for reference, buster#2524's: the bodies between the parser and Tier 0* | *`check-input` to `lower` on the units, less the same without bodies, less the asm index* | *1,318.3* | *23.6%* | *1.309* | *452.7* | *66.0%* | *2.941* |

The compile is 5,586.8 M cycles for musl and 686.0 M for `sqlite3.c` (the stages' sums). The rows overlap: the
kernel's cycles are in every other row, and a unit's fixed work is in the kernel's and the preprocessor's, so the
shares don't add up. The file scope's reading is first on musl by a wide margin and second on `sqlite3.c`, within a
point of the kernel's.

## 4. The kernel, and a unit's fixed costs

`tables/kernel.txt`: the kernel's cycles by what entered it (`perf record -g` of `cycles:k`, inclusive shares), and
the system calls (`scripts/syscalls.sh`: `strace -c`, the counts alone). For musl's command, of the kernel's 1,098 M
cycles: page faults 47.3%, `madvise` 35.0%, `newfstatat` 4.9%, `openat` 2.8%, `pwrite64` 2.7%. It makes 28,599
`madvise` calls (21 a unit; 17 a unit for empty units), 15,110 `newfstatat`, 3,382 `openat`, 158 `mprotect`, 79 `mmap`
and 4 `munmap`, and takes 343,028 page faults, 257 a unit: a megabyte of pages a unit, given back and faulted in again
by the next.

`scripts/fixed.sh` (`tables/medians.txt`, `fixed`): an empty unit as a process is 0.34 ms, 0.49 M user and 1.35 M
kernel cycles and 286 faults (200 runs). N empty units as one command: 0.41 ms for 1, 1.6 for 16, 18.8 for 256, 97.4
for 1,336 and 296.1 for 4,096: linear, 72 µs, 149,000 user and 246,000 kernel cycles and 53 faults for each unit past
the first.

## 5. The asm matcher's index

Section 2's `lower.prepare` and the profile's `x86_match_initialize` (130 M user cycles), `x86_match_bucket` (97 M) and
libc's `strcmp` (99 M) pointed at `check_asm_matches` (`c_check_program_asm.c`), which makes the index the asm
templates' instructions are matched against once per lowering of a unit with asm statements: 537 of musl's units
(`raw/asm/units-with-asm.txt`), most of them through `syscall_arch.h`'s inline functions. `scripts/probe.patch` adds a
switch, `BUSTER_PROBE_ASM_CACHE`, that makes it once a process. `scripts/asm.sh`, 5 rounds each way in turn
(`tables/medians.txt`, `asm`; `tables/asm-stages.tsv`):

| | user cycles | kernel cycles | CPU ms |
| --- | ---: | ---: | ---: |
| once a unit with asm statements, as main | 4,533 M | 1,165 M | 1,029.4 |
| once a process | 4,046 M | 1,095 M | 928.7 |

All 1,336 objects are the same bytes both ways. This is outside the design; buster has an issue for it.

## 6. The same declarations, read again and again

`scripts/tools/units.py` on the preprocessed units (`tables/census.txt`, `raw/prep/musl-declarations.tsv`,
`tables/musl-repeats.tsv` by `scripts/tools/repeats.py`): musl's command reads 297,004 file-scope declarations, and
with their bodies cut they are 5,156 distinct texts.

| kind | declarations read | distinct texts | tokens read | tokens in the distinct texts | times over |
| --- | ---: | ---: | ---: | ---: | ---: |
| prototypes and function-pointer objects | 233,215 | 2,079 | 2,643,136 | 26,841 | 98.5 |
| function definitions (their headers) | 18,584 | 2,107 | 236,766 | 25,395 | 9.3 |
| objects with an initializer | 1,072 | 370 | 212,871 | 203,962 | 1.0 |
| typedefs with a record or enum body | 5,795 | 117 | 181,598 | 3,517 | 51.6 |
| typedefs | 28,092 | 137 | 122,977 | 614 | 200.3 |
| record and enum definitions | 4,226 | 209 | 119,101 | 5,405 | 22.0 |
| … with declarators | 1,282 | 24 | 72,059 | 1,189 | 60.6 |
| objects without an initializer | 3,707 | 90 | 20,974 | 525 | 40.0 |
| typedefs of function types | 262 | 14 | 3,405 | 219 | 15.5 |
| tag declarations | 769 | 9 | 2,307 | 27 | 85.4 |
| all | 297,004 | 5,156 | 3,615,194 | 267,694 | 13.5 |

By the lexical census, 1,424,367 of musl's tokens are in function bodies, 536,945 in file-scope braces and 3,078,249
in the rest of file scope (the first record's 28.3%, 10.7% and 61.1%).

## 7. The design's rule, emulated on the units

`scripts/tools/attest.py` emulates the design's rule on the preprocessed text, for the units in the command's order
with one memo: a semantic hash for every file-scope declaration (its tokens, the hash of the latest declaration of
every name its reading looks up or declares, the pragmas before it); the declarations that are eligible (no body, no
initializer, no `static`, an object only with `extern`, no alias, ifunc or asm label, no tag first declared in a
parameter list); the memo's hits (an earlier unit read a declaration of the same hash); the reach (from the function
definitions and every declaration that isn't an eligible hit, to every earlier declaration of a name a reached one
spells and every later declaration of a name it declares); and the skipped declarations, eligible hits out of reach.
It writes each unit twice: with the skipped declarations blanked, and with each of their tokens kept as a `;` at the
token's own place, an empty declaration a token. Its rules of C's declaration syntax are its own, from the text; the
design takes the same facts from the parser.

`tables/emulation.txt`, for musl's command (`raw/live2/attest-musl.tsv`):

| | tokens | share | declarations |
| --- | ---: | ---: | ---: |
| skipped | 2,954,264 | 58.6% of all, 87.4% of those outside function definitions | 263,177 of 297,006 |
| hits the unit's code reaches | 155,045 | 3.1% | 11,082 |
| misses: read, and added to the memo | 41,388 | 0.8% | 2,826 |
| not eligible | 227,733 | 4.5% | 1,337 |
| function definitions | 1,661,144 | 33.0% | 18,584 |

The memo ends with 2,826 hashes. Of the ineligible tokens 212,270 are `static` objects and functions' declarations,
10,240 initializers and 5,166 aliases. By kind, the skipped are 2,522,984 of the prototypes' 2,643,136 tokens, 268,814
of the typedefs' 307,980 and 133,421 of the record and enum definitions' 191,160. With a warm memo (every eligible
declaration a hit, as in a second command): 265,754 declarations, 2,989,377 tokens.

**Objects and diagnostics** (`scripts/live.sh`, `scripts/live2.sh`; both sets compiled through one path, so that
nothing in an object or a diagnostic names its set):

| units | objects | diagnostics |
| --- | --- | --- |
| musl, skipped declarations blanked | 1,227 the same bytes, 109 different | the same bytes (111,442 bytes, 321 warnings) |
| musl, a `;` a skipped token | **1,336 the same bytes** | the same bytes |
| musl, a warm memo, a `;` a skipped token | **1,336 the same bytes** | the same bytes |
| `sqlite3.c`, a warm memo, a `;` a skipped token | **the same bytes** | the same (none) |

The 109 that differ with the blanked units differ in a string literal's symbol alone
(`raw/live/objdiff/`, `scripts/objdiff.sh`): the compiler names it by the literal's token index
(`.Lbuster_string_N`), which blanking tokens changes and the design, which leaves every token in place, doesn't.

**The time** (`scripts/semi.sh`, 5 rounds in turn, `tables/medians.txt`, `semi`; stages in
`tables/musl-emulation-stages.tsv`):

| musl's preprocessed units, `-c`, one command | user cycles | kernel cycles | CPU ms |
| --- | ---: | ---: | ---: |
| as they are | 3,650 M | 842 M | 810.7 |
| a `;` a skipped token: more than the design leaves | 2,462 M | 798 M | 587.7 |
| the skipped tokens gone: less than the design leaves | 2,204 M | 769 M | 537.8 |

The design leaves a skipped declaration's tokens in the unit, lexed and parsed as they were, and reads nothing of
it; the placeholder units also read an empty declaration at each skipped token, and the blanked units also drop the
tokens' lexing and parse. By stage, in user cycles: `check-input` is 1,930 M as they are, 897 M with the placeholders
and 761 M with the tokens gone; the parse 241 M, 210 M and 146 M.

With a memo kept across processes (`raw/live2`): musl's units as 1,336 processes take 1,566.9 ms as they are and
1,232.7 with a warm memo's skipped tokens gone; `sqlite3.c`, 115.3 and 107.4 ms (46,014 tokens skipped, 2,579 of 7,298
declarations).

## 8. A second header style: generated units over glibc's headers

`scripts/tools/gen_units.py` writes 512 small units, each including 8 of 30 common headers of the host's glibc and
defining two functions that call a few of what they declare; `scripts/glibc.sh` preprocesses them and runs section 7
on them: 5,371,375 tokens, 298,334 file-scope declarations, of which the emulation skips 272,276 (4,737,766 tokens,
88.2% of all), with 1,661 hashes in the memo at the end; 54,675 tokens are ineligible for an asm label, 38,378 as
objects without `extern` and 16,145 for a tag first declared in a parameter list. All 512 objects are the same bytes with a `;` a skipped token, and no unit has a
diagnostic either way. `-c` of the sources as one command takes 779.8 ms (3,848 M user and 472 M kernel cycles, 52% of
them `check-input`'s, `tables/glibc-stages.tsv`); the preprocessed units 582.1 ms, with placeholders 246.5 and with the
skipped tokens gone 161.1.

**A first run is kept as `raw/glibc-first`.** The emulation's list of type keywords held `_Float128`, which glibc
declares by typedef for a compiler without the keyword, as clang is: the typedef then declared nothing by the
emulation's rules, was skipped, and the one unit whose code reaches a later use of it failed (`unknown type name
'_Float128'`; 511 objects the same, one missing). The list was corrected and the run repeated. It is the failure the
design's own check is for: a declaration that declares a name the lists don't have.

## 9. A prototype of the design's passes

`scripts/tools/chain_dump.py` writes the command's units as the columns the passes would read (each token's kind and
name, every spelling interned to one id over the command), and `scripts/tools/chain.c` runs the passes over them, a
unit at a time with one memo: **S**, each declaration's lists (the names it declares, looks up, mentions as tags and
spells, and whether it is eligible) by a scan of its tokens with a stack of contexts; **A**, each declaration's own
hash, two tokens an AES round; **B**, the chain in source order, with the memo's probes; **C**, the reach, two cursors
a name; **D**, the skipped tokens' marks and the memo's additions. It is **not the compiler's code**: it reads no C
beyond the dump's kinds and spelling classes, and its scan stands for a pass that would read the parser's roles.
`--check` compares its lists with the emulation's, declaration by declaration, and its skips must be the emulation's.
`scripts/chain3.sh`, 3 runs of 21 repetitions of the whole command (`tables/prototype.txt`):

| | musl, 1,336 units | `sqlite3.c`, one unit | `sqlite3.c`, a warm memo |
| --- | ---: | ---: | ---: |
| declarations whose lists differ from the emulation's | 0 of 297,006 | 0 of 7,298 | |
| declarations and tokens skipped | 263,177 and 2,954,264, the emulation's | none | 2,579 and 46,014, the emulation's |
| user cycles a run, with its own scan | 112.2 M | 12.9 M | 17.3 M |
| cycles and instructions a token | 22.3 and 117 | 18.1 and 36 | 24.1 and 45 |
| … the scan, the own hashes, the chain, the reach, the marks | 15.6, 1.9, 2.7, 1.1, 1.0 | 11.7, 3.0, 3.2, 0.0, 0.1 | 11.9, 3.1, 3.1, 5.8, 0.2 |
| cycles a token with the lists given | 6.8 | 6.2 | |

112 M cycles is 2.0% of musl's command. Two earlier versions are kept for what they found (`raw/chain`, `raw/chain2`;
their sources weren't kept, the scripts that ran them are): the first one's reach walked every declarer of a name from
each declaration that spells it, 2 cycles a token on musl's small units and 337 on `sqlite3.c`, whose 2,674 bodies
spell the same names; the second still walked every later declarer from each declaration, 98 cycles a token on
`sqlite3.c` with a warm memo. The third keeps two cursors a name and passes each declarer once.

## 10. The estimate

`scripts/tools/gains.py` (`tables/gains.txt`) is the design's estimate of its gain, not a measurement of it: from
section 7's and 8's measured compiles, with the parse and the lexing that the blanked units dropped put back.

| | musl's command | the generated glibc units |
| --- | ---: | ---: |
| `-c` of the sources, cycles of both modes | 5,555 M | 4,320 M |
| conservative: the placeholders' saving at 85% of the emulation's coverage, less the prototype's passes as measured | 1.20 times | 1.51 |
| expected: the blanked units' saving, less the parse and lexing put back, 20 cycles a skipped token and 12 a token for the passes | 1.29 | 1.80 |
| optimistic: … less the lexing alone and the passes without their scan | 1.35 | 2.06 |
| the bound: the file scope's reading free | 1.47 | |

## Limits

- **One host, one day, one revision.** Each table is `ecaf57b5`'s on the 9700X; a table's runs are interleaved or
  repeated, but tables taken in different holds are not an A/B of anything.
- **The emulation is not the design.** It reads text with its own rules for C's declarations, assumes that an eligible
  declaration read without a diagnostic, and removes or replaces tokens where the design would leave them and skip
  their reading. Its objects' identity says that these declarations don't matter to these units' objects and
  diagnostics; it doesn't say that the reader's state after a skip is what every later pass expects, which the
  design's shadow step is for.
- **The two brackets are not the design's time.** The placeholder units read an empty declaration a skipped token
  and lex and parse `;` where the design lexes and parses the declaration's own tokens; the blanked units lex and
  parse nothing there.
- **The prototype is not the compiler's code** (section 9): its lists come from its own scan of kinds and spelling
  classes, its hashes are 64 bits, and it runs 21 repetitions of a command over warm data.
- **musl's preprocessed units stand for its sources** in sections 7 and 9: the same tokens, without the
  preprocessor's work.
- **The generated units are generated**: their headers are real, their code is 15 lines each.
- **The counters read in the process** add their own reads to each stage (2% in all), and the patched build's laps of
  a function's passes (`lower` to `code-atoms`) are per function.
- **The profile's families are names' prefixes**, and 4% of the samples have no symbol.
- **One run was outside the lock:** the reducer `uarch` was compiled (about a second of clang) without it, by mistake.
  No measurement ran beside it.
- No run here used more than one lane or more than one process at a time.

## Files

- `env.txt`: the host and the identities, with the scripts' hashes as they ran. Written after them: the reducers
  `rank.py`, `gains.py`, `repeats.py` and `tables.sh`, and `probe_table.py`'s reading of gzipped reports. The host
  applied `probe.patch` in two parts, the counters first and the asm switch later (`env.txt`'s `probe-asm-only.patch`
  is that second part, which `probe.patch` here includes). `raw/COMMIT`, `raw/build-*.log`: the trees and their
  builds; `raw/queue-*.log`: each hold's start and end.
- `scripts/`: `lock.sh` (the hold), `queue.sh` (holds in turn), `build.sh`, `env.sh`, `common.sh` (the corpus and
  the options), one script a measurement, `probe.patch` (the measurement patch) and `tables.sh`; `scripts/tools/` the
  reducers, the emulation (`attest.py`), the prototype (`chain.c`, `chain_dump.py`) and the generator. `spine.py` is
  the first record's, copied.
- `raw/`: every run's output as written, by measurement; a text file over 32 KB (a report with its units'
  diagnostics) is gzipped.
- `tables/`: the reductions, each made from `raw/` by `scripts/tables.sh`, and `gains.txt`, the estimate.
