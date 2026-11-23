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
- **What the reduced units don't spend is in four places** (section 3, container samples): the preprocessor 31%, the
  reader and the passes after it 30%, the parser and the attested passes 16%, memory and the kernel 21%.
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

The 9700X's reading of the same four commands (`scripts/emul.sh`: the units, with `-w`, the reduced units with `-w`
and without) is queued behind the lock as this is written; its rounds go in `results/emul-root2`.

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
