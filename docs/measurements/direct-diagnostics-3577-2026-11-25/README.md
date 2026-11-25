# The direct path's diagnostics: sqlite3.c's cost, Buster #3577

Compiler issue: [#3577](https://github.com/buster14a/buster/issues/3577). Compiler PR:
[#3597](https://github.com/buster14a/buster/pull/3597).

The PR makes the default `-c` (the direct path, `c_direct*.c`) give the full pipeline's stderr and exit status on
every C file under `tests/`, c-testsuite and musl: a check for each default warning and error, which leaves the unit
to the full pipeline where its result could differ. This record is what those checks cost sqlite3.c's compile.

Frozen sources:

- Base: main `20f3573eebb641e30cfceed4089a4ac3430259f2` (#3598 merged).
- Head: `363094190114` (`3630941901148881f23219355db662d5aa4abb62`), the PR head after merging main.
- `answers`: the head with main's answers to `__has_builtin`, `__has_attribute`, `__has_feature` and
  `__has_extension` (`patches/answers.patch`), so that it compiles main's token stream: its sqlite3.c object's code
  and data are main's byte for byte (`.strtab` differs by #3595's joined asm labels alone).
- `ablate-*`: `answers` with one family of checks switched off (`ablate.py`, `patches/ablate-*.patch`); each
  compiles sqlite3.c to `answers`' object.
- `pushmarks`: the head with the next step, `7ab735bef`.

## Host and method

The Ryzen 7 9700X (`benchpress`), CPU 2 by `taskset`. Each tree was built with `./build.sh --config Release`
(`builds.sh`, `loop2.sh`), one `exclusive.sh` hold a build. The unit is the 9700X job's sqlite3.c
(`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite`, its sha256 checked by the earlier `measure.sh`),
`-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`.

- Head against base: `measure-compile --runs 41 --reference` (interleaved, one hold), `ab.sh`; the whole output is
  `results/ab-head-363094190.log`.
- Variants against base: `measure-compile --runs 11 --reference`, one hold each (`loop2.sh`);
  `results/variants.txt` and `results/ablations.txt`.
- Where the instructions go: IBS op samples (`ibs_op/cnt_ctl=1,swfilt=1/u -c 500000`, 100 compiles a tree, one
  hold), `ibs.sh`; per-symbol shares in `results/ibs-ops-*.txt`. IBS tags the sampled op itself, without the skid of
  `instructions:u` sampling, which put a quarter of this delta on functions whose code and call counts are unchanged.

## Results

| | wall | user cycles | user instructions |
| --- | --- | --- | --- |
| main | 16.285 ms | 81.1 M | 220.9 M |
| head 363094190 | 17.672 ms (+8.5%) | 88.7 M (+9.4%) | 245.2 M (+11.0%) |
| `answers` (main's tokens) | 17.612 ms | 88.0 M | 245.0 M (+10.9%) |
| `pushmarks` (7ab735bef) | 17.762 ms | 88.6 M | 244.7 M (+10.8%) |

The head's different `__has_*` answers (sqlite's atomic intrinsics, fifteen more headers) cost 0.2 M instructions;
the checks cost the rest. A build's layout moves cycles by about ±0.7 M (`ablations.txt`' main rows and the
variants'), so instructions are the measure below; the added work runs at about 3.3 instructions a cycle.

Each family's cost, `answers` less the variant without it:

| switched off | user instructions | saving |
| --- | --- | --- |
| `-Wunsequenced`'s log (names, operators' positions, modifications) | 240.9 M | 4.1 M |
| binary operators' operand classes and questioned comparisons | 241.8 M | 3.2 M |
| implicit conversions past one to the source's own type | 242.7 M | 2.3 M |
| the identifier push's marks (enumerators, pure library functions) | 243.4 M | 1.6 M |
| conditions and discarded values | 243.7 M | 1.3 M |
| unary operands and operator precedence | 244.6 M | 0.4 M |

These are 12.9 M of the 24.1 M. IBS puts the rest over 20-odd sites of 0.2 to 1 M each: declaration specifiers and
declarators, statements' checks, the `#if` evaluator and `#define`, calls' arguments, static initializers. The
preprocessor's own share of the delta is about 1 M.

Peak RSS (wait4) is 53.2 MB against 36.4 MB: file-backed pages of the executable that the checks and the driver's
feature queries touch. Sampled during a compile on a 4-CPU container, anonymous memory was 8.4 MB against main's
9.3 MB and file-backed 15.5 MB against 13.0 MB.
