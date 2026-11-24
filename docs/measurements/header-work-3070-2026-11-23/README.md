# Where the headers' work goes in a command of many units, with the root image (2026-11-23)

Evidence for the design of [buster#3070](https://github.com/buster14a/buster/issues/3070)'s step 2 (header images on a
lane), read before building it: which stages spend what the issue calls the headers' work, on musl's and Lua's commands
with step 1's root image ([buster#3475](https://github.com/buster14a/buster/pull/3475),
[root-image-3070-2026-11-23](../root-image-3070-2026-11-23)).

- **Source:** buster main `b7d0b5edff73852852f0664c07fab61b00cad378` with the root image's pull request as opened
  (`bin/root2` of the root image's record) on the 9700X; in the container the same pull request rebased on main
  `3723f1f6` (`0b008cf1`), `./build.sh --config Release`.
- **Hosts:** the 9700X under the lock for section 1; a cloud container (Xeon, 4 vCPUs under KVM, no hardware counters)
  for sections 2 and 3, which are counts and wall-time samples, not timings.
- **Workloads:** musl's 1,336 units (the frozen corpus `preprocessor-391e729af658`, the one-core record's selection and
  options) and Lua 5.4.8's 34, each one `-c --lanes 1` command; and musl's units reduced as
  [build-images-2026-11-19](../build-images-2026-11-19)'s `reduce.py` reduces them (each unit's own items and the header
  items its own code reaches by name: 1,158,239 of 5,039,561 tokens, the same counts as that record's).

## In short

- **The preprocessor is 18% of musl's command and 22% of Lua's** on the 9700X, the reader 18% and 21%, the checker's
  later passes 15% and 13%, the kernel 17% and 14%, the parser 6% and 5%, the attested passes 5% and 4% (section 1).
- **Header function definitions are 1,364,185 of the tokens musl's command reads, and its units' own definitions
  296,948** (section 2). [#2531](https://github.com/buster14a/buster/issues/2531) never attests a function definition,
  so each unit's reader reads every `static inline` function of every header it includes: 64% of the 2.14 million
  tokens the reader reads in the command (1.66 million in definitions, 0.48 million outside them that aren't skipped).
- **The reduced units take 1,745 M cycles on the 9700X where the units take 3,160 M** (section 4), and what they don't
  spend is in four places (section 3, container samples): the preprocessor 31%, the
  reader and the passes after it 30%, the parser and the attested passes 16%, memory and the kernel 21%.
- **Without the header function definitions its code doesn't reach, a unit's compile is the reduced unit's** (section
  5, added 2026-11-24): musl's units as preprocessed text take 2,536 M cycles, 1,849 M without those definitions and
  with every diagnostic as it is.
- **With `-w` musl's command takes a sixth fewer samples in the container** (section 3). Its 321 warnings are each in
  a header's function definition; a unit with one preprocesses again for its history (the preprocessor's samples fall
  from 2,211 to 1,614), and the warnings' own passes are 397 more.

## 1. musl's and Lua's commands by stage (9700X, `scripts/profile-musl.sh`, `results/profile-musl-root2`)

`perf record -g -F 10000` (Lua 20000) of each command on CPU 2, `perf report --no-children --sort symbol`
(`musl-flat.txt`, `lua-flat.txt`: the 400 and 300 largest symbols, 94.0% and 95.6% of the samples), each symbol given a
stage by its name (`scripts/stage-table.py`). musl's command in that hold: 2,557.2 M user and 536.7 M kernel cycles,
6,409.9 M user instructions, 177,399 faults (`musl-stat.csv`).

| stage, by the symbols' names | musl | Lua |
| --- | ---: | ---: |
| the preprocessor (`pp_*`, the file cache, the lexer) | 18.3% | 21.6% |
| the reader (`check_input*`) | 18.1% | 21.1% |
| the kernel | 16.5% | 14.5% |
| the checker's other passes (`check_*` not listed apart) | 14.8% | 13.2% |
| the parser (`parse_*`) | 6.0% | 5.3% |
| the attested passes (`check_attested*`) | 4.8% | 4.3% |
| `memset`, `memmove` | 3.8% | 2.1% |
| `check_program*` | 2.3% | 2.6% |
| the lowering (`check_lower*`) | 1.8% | 4.1% |
| the type table | 1.4% | 1.4% |
| Tier 0 | 1.2% | 2.1% |
| the drivers, the arenas, the object, the rest | 4.9% | 3.4% |

## 2. The function definitions the reader reads (container, `measure-attested`)

`build/compiler measure-attested --list 20000` over musl's command lists every function definition with its unit and
its file (`results/container/measure-attested.txt` has the census's counts, `definitions.txt` the definitions by file):

| musl's command | definitions | tokens |
| --- | ---: | ---: |
| every function definition (a root, never attested) | 18,584 | 1,661,133 |
| in a unit's own file | 2,037 | 296,948 |
| in another file: a header, or one of three `.c` files a unit includes | 16,547 | 1,364,185 |
| `include/math.h` | 4,930 | 736,020 |
| `arch/x86_64/syscall_arch.h` | 3,717 | 266,031 |
| `arch/x86_64/atomic_arch.h` | 3,056 | 102,376 |
| `src/internal/syscall.h` | 531 | 95,049 |
| `src/internal/atomic.h` | 1,146 | 59,783 |
| `src/internal/pthread_impl.h` | 364 | 39,676 |
| `src/internal/libm.h` | 1,752 | 33,288 |
| `include/endian.h` | 684 | 17,556 |

The command's attested declarations skip 259,860 of its 297,004 file-scope declarations and 2,895,993 of the 3,378,428
tokens outside definitions (its `--time-stages` line), so the reader reads 482,435 tokens outside definitions and all
1,661,133 inside them.

## 3. What the reduced units don't spend (container, `scripts/sampler.c`, `scripts/stages.py`)

A sampler by `ptrace` stops the compiler every 300 µs and takes its instruction pointer (`sampler.c`; three runs of
each command, the samples inside the executable). A sample in a system call is its stub's and a page fault's is the
faulting instruction's, so `memset` and `madvise` hold kernel time here. The counts are samples, proportional to wall
time in a container: shares, not timings. `results/container/stages.txt`:

| stage | musl's units | with `-w` | the reduced units, `-w` |
| --- | ---: | ---: | ---: |
| the reader | 2,611 | 2,527 | 1,728 |
| the preprocessor | 2,211 | 1,614 | 291 |
| the checker's other passes | 1,692 | 1,295 | 960 |
| `memset`, `memmove` | 1,251 | 1,007 | 609 |
| the parser | 872 | 844 | 399 |
| `madvise` | 775 | 541 | 469 |
| the attested passes | 664 | 643 | 158 |
| the files' calls | 622 | 427 | 350 |
| the type table | 407 | 404 | 258 |
| the lowering | 388 | 355 | 267 |
| all | 13,051 | 10,966 | 6,807 |

Of the 6,244 samples between the units and their reduced forms: the preprocessor 1,920 (31%), the reader with the
checker's other passes, the type table, `check_program` and the lowering 1,989 (32%; 397 of them the warnings' passes
that `-w` turns off), the parser and the attested passes 979 (16%), `memset`, `memmove`, `madvise`, `ioctl` and the
files' calls 1,311 (21%). The reduced units are preprocessed text, so their preprocessor's 291 is the floor of a unit
that has no directive at all.

## 4. The same four commands on the 9700X (`scripts/emul.sh`, `results/emul-root2`, 5 rounds)

Each round a hold of the lock, the four in an order that rotates by round; medians, M cycles:

| musl's 1,336 units, one lane, with the root image | user | kernel | all | user instructions | faults |
| --- | ---: | ---: | ---: | ---: | ---: |
| the units | 2,577.2 | 581.8 | 3,160.2 | 6,410.3 | 177,395 |
| the units, `-w` | 2,221.2 | 478.4 | 2,699.6 | 5,628.8 | 152,091 |
| the reduced units | 1,269.2 | 477.4 | 1,745.1 | 2,592.5 | 105,198 |
| the reduced units, `-w` | 1,122.2 | 448.2 | 1,566.1 | 2,386.2 | 99,794 |

- **The reduced units take 1,745 M cycles where the units take 3,160 M** (1.81 times fewer; with `-w` both, 1,566 M and
  2,700 M). Step 2's gate, set from the first emulation before the root image, is 2,230 M.
- **`-w` alone takes 461 M cycles off musl's command (14.6%)**, 356 M of them user: its 321 warnings, each in a header's
  function definition. The reduced units keep fewer of those definitions, so their `-w` is worth 179 M.

## 5. Without the header function definitions a unit doesn't reach (2026-11-24; `scripts/reduce2.py`, `scripts/emul3.sh`, `results/emul3-pr`)

Section 2's definitions, emulated as section 4's reduced units are: from each unit's `-E` output `reduce2.py` writes
the unit as preprocessed text with every top-level item (`all`); without the header function definitions of internal
linkage or `inline` that the unit's kept items don't reach by their function's name, through the definitions they do
reach (`defs`); and the same with the two definitions whose reading warns (`__bswap64`, `__bswap_64`) kept in every
unit that has them (`kept`), which is what attesting header definitions could skip with every diagnostic as it is. Of
the 1,362,537 tokens in header function definitions, `defs` drops 1,320,457 and `kept` 1,307,017. `red` is section 4's
reduced units.

On the 9700X, the compiler of [buster#3475](https://github.com/buster14a/buster/pull/3475) on main `3723f1f6`, one
lane, 5 rounds (each a hold of the lock, the eight commands in an order that rotates by round), medians, M cycles:

| musl's 1,336 units as preprocessed text | user | kernel | all | user instructions | faults |
| --- | ---: | ---: | ---: | ---: | ---: |
| every item (`all`) | 1,990.2 | 547.2 | 2,535.6 | 4,794.5 | 172,431 |
| without the unreached header definitions (`defs`) | 1,299.8 | 449.1 | 1,748.9 | 2,601.0 | 131,510 |
| the same, the two that warn kept (`kept`) | 1,353.7 | 497.7 | 1,849.1 | 2,711.4 | 143,529 |
| section 4's reduced units (`red`) | 1,276.1 | 472.4 | 1,748.3 | 2,607.8 | 105,215 |
| every item, `-w` | 1,729.5 | 466.5 | 2,194.2 | 4,266.6 | 154,047 |
| without the unreached header definitions, `-w` | 1,161.0 | 418.6 | 1,579.8 | 2,422.8 | 125,992 |
| the two that warn kept, `-w` | 1,170.1 | 419.9 | 1,590.0 | 2,444.6 | 126,845 |
| the reduced units, `-w` | 1,127.4 | 437.7 | 1,566.0 | 2,400.8 | 99,808 |

- **The unreached header function definitions are what the reduced units save after the preprocessor:** without them
  alone the command takes 1,748.9 M cycles, the reduced units' 1,748.3 M. The declarations the reduced units also drop
  are the ones [#2531](https://github.com/buster14a/buster/issues/2531) already skips.
- **With every diagnostic kept it is 686 M cycles of 2,536 M (27%)**: `kept` against `all`. The two definitions that warn
  cost 100 M in the 236 units that have them (`kept` against `defs`), 10 M of it under `-w`.
- **The units' preprocessing is 643 M of the command's 3,178 M** (section 4's units against `all`).
- By the container's samples (`results/container/stages-definitions.txt`, `all` and `kept`): the reader 2,560 to 1,703,
  the checker's later passes 1,702 to 1,117, the parser 871 to 620, the attested passes 515 to 437. The emulation
  doesn't parse the dropped definitions; a skip in the reader's view still would.

## Reproducing

```sh
# On the 9700X, in ~/buster-fast-bench/3070-claude-euler (the root image's record's setup): each takes the lock itself.
./profile-musl.sh $PWD/bin/root2 $PWD/results/profile-musl-root2
./emul.sh 5 $PWD/bin/root2 $PWD/results/emul-root2      # red/c: reduce.py's units, from each unit's -E output
python3 scripts/stage-table.py results/profile-musl-root2/musl-flat.txt results/profile-musl-root2/lua-flat.txt
# In a checkout with the pull request built: the census, and the samples (nm -n --defined-only build/compiler > syms.txt).
build/compiler measure-attested --list 20000 OPTIONS UNITS
cc -O2 -o sampler scripts/sampler.c && ./sampler 300 full.1.txt -- build/compiler -c --lanes 1 OPTIONS UNITS
python3 scripts/stages.py full fullw red
```
