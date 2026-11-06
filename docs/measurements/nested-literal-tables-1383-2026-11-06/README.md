# Tables of number rows on an Ice Lake server, Buster #1383

Compiler branch: `perplexity/1383-nested-literal-tables` of buster14a/buster, for
[this claim of #1383's direction 2](https://github.com/buster14a/buster/issues/1383#issuecomment-6681389384).

#658's literal-table path (`c_check_literal_table_input.c`) packs a flat file-scope list of numbers into one bytes part.
An array of arrays (`int t[][4] = { { … }, … }`) took the ordinary path instead: an expression node, a `CheckValue`, and
an initializer and data-plan part for every element. The branch adds `check_literal_table_rows`, an AVX-512 grammar for
`{ list }` rows of exactly `M` numbers. It classifies 64 token kinds a block into number, comma, minus and brace masks,
takes brace depth from a prefix XOR of the brace mask (carried across blocks), and checks each row's count with
`popcnt`. Its scalar twin is the oracle. `check_input_literal_table_prepare` accepts `T[N][M]` and `T[][M]` with such rows.
This record measures the branch against main. It is not a 9700X record: the session had no access to `benchpress`,
and its numbers are evidence for this machine only.

## Sources and host

- **main:** `76cc5086`, built as `compiler-main`;
- **head:** `76cc5086` with the branch's commit `02e0278d`, built as `compiler-rows`.

Each was built by `BUSTER_DEBUG_INFO=0 ./build.sh` with clang 23.1.4 first in `PATH`. The host: an Intel Xeon @ 2.90GHz
(Ice Lake server, the complete `host_isa.h` AVX-512 set, so `BUSTER_HOST_VECTOR` is 1), 2 vCPUs, 7 GiB, Ubuntu 26.04.1
LTS, Linux 6.1.155, on a shared virtual machine. `sha256.txt` has both executables' and the four inputs' SHA-256.

## Inputs

`gen.py 48000` (seed 1) writes 48,000 values in four files:

- `rows4.c`: `int table[][4]`, 12,000 rows of random values in [-100000, 100000), one row per line (the issue's 2-D shape);
- `flat.c`: the same values as a flat `int table[]`, eight per line (the path that already existed);
- `bytes16.c`: `const unsigned char table[3000][16]` of `0xhh` bytes (an `xxd -i`-like table in rows);
- `double3.c`: `const double table[][3]` of three-decimal values.

#1383 measured 1,000,000 values. On this VM neither executable can check a file that size, nor 250,000 values: both
stop with `fatal error: can't reserve type table`, as the type table's reservation grows with the token count, and
`checker input capacity exhausted` above about 50,000 values in rows. 48,000 is the largest of the sizes tried at which
all four files compile on both executables.

## Method

- `ab.sh BINARY 11`: 11 runs per input of `BINARY check --time-stages -c INPUT`, pinned to CPU 1 (`taskset -c 1`), each
  through `run.py` for the child's wall time and `ru_maxrss`. It prints the median wall time, the median `check-input`
  stage and the median peak RSS. `ab-main.txt` and `ab-branch.txt` are its outputs.
- `stages-rows4.txt`: each stage's median of 3 quiet `--time-stages` runs of `rows4.c` by each executable.
- `grammar/`: `bench.c` times `check_literal_table_rows` alone (`extract.py` cuts it from the branch into `extract.h`),
  scalar twin and vector, on 48,000 numbers in rows of 1, 4 and 16, best of 50 with warm caches.
- `fuzz/`: `gen.py SEED OUT` writes one random file-scope table of rows. Its element type is one of 12, it has 1 to 32
  columns, a random bound or none, random spellings and trailing commas, and in two thirds of seeds one change:
  - a short or excess row, or an elided row;
  - a row or element designator, a range designator, or an empty row;
  - deeper nesting, an expression, a character constant, a parenthesized value, or an out-of-range value.

  `run.sh 1 2000` compiles each with both executables (`check -c`) and compares exit status, object bytes and
  diagnostics.
- `identity.txt`: `-c` of the 48 `tests/` and `examples/` programs and the 150 smallest `src/buster/compiler/*.c`, both
  executables, compared by exit status, then object bytes or diagnostics.
- `edge/`: 11 hand-written cases compiled by both executables (`results.txt`): more rows than the bound, `_Atomic`,
  typedef rows (one `const short`), zero-width rows, an `extern` declaration before the definition, a tentative
  definition after it, a value out of range, `static` with an address taken, and `sizeof` uses.
- `test-checker-main.txt` and `test-checker-branch.txt`: `test-checker --seed 133` by each executable, each run alone.
  `test-checker-parts.txt` repeats both runs as `--part K/32` and lists each part's checks and failures.

Reproduce from the branch's checkout:

```sh
python3 gen.py 48000
./ab.sh ~/buster/build/compiler 11
cd grammar && python3 extract.py ~/buster && clang -O2 -march=native -o bench bench.c && taskset -c 0 ./bench 4 12000
```

## Results

Medians of 11, main → branch:

| input (48,000 values) | wall | check-input | peak RSS |
| --- | ---: | ---: | ---: |
| `int table[][4]` | 67.18 → 22.11 ms (3.04×) | 18.61 → 11.20 ms | 68.2 → 28.8 MB |
| `const unsigned char table[3000][16]` | 83.65 → 14.66 ms (5.71×) | 44.62 → 6.28 ms | 79.6 → 22.5 MB |
| `const double table[][3]` | 118.97 → 26.17 ms (4.55×) | 69.08 → 14.31 ms | 95.6 → 30.1 MB |
| flat `int table[]` (unchanged path) | 19.67 → 19.47 ms | 9.98 → 9.93 ms | 25.1 → 25.2 MB |

The 2-D `int` table now costs 1.14× the flat list of the same values, which also has fewer tokens (no row braces);
main's cost 3.4×. On main its time was in `check-expressions`, `check-declarations`, `check-program` and
`publish-data`. The branch leaves those with nothing to do for the table (`stages-rows4.txt`).

The grammar alone (`grammar/microbench.txt`), scalar twin → vector:

| rows of | tokens | scalar | vector |
| --- | ---: | ---: | ---: |
| 1 | 216,173 | 3.71 ns/token | 0.50 ns/token (7.4×) |
| 4 | 144,173 | 4.01 ns/token | 0.30 ns/token (13.5×) |
| 16 | 126,173 | 4.37 ns/token | 0.21 ns/token (21.1×) |

Equivalence:

- The four inputs' objects are byte-identical between the executables.
- `identity.txt`: no difference in the 198 files.
- `fuzz/fuzz.txt`: of 2,000 generated tables, 1,960 compile and 40 are refused by both. There is no difference in exit
  status, object bytes or diagnostics.
- `edge/results.txt`: all 11 cases have the same exit status, objects and diagnostics.
- `test-checker --seed 133`: 766,220 checks on the branch against 765,601 on main, 475 failures each. Those are this
  VM's clang-oracle and resource cases. In 32 parts (`test-checker-parts.txt`), 31 parts give identical counts. Part 1,
  which runs the literal-table tests, has 619 more checks on the branch (the rows twin test and 2-D fixtures), with
  the same 40 failures as main and the same printed failure lines.

## Limits

- This is not the 9700X, and the inputs are 48,000 values instead of #1383's 1,000,000, for the reason above.
- Only full braced rows of numbers are measured. Short rows, brace elision, deeper arrays, designators,
  block-scope tables, structs and string pointers keep the ordinary path, and are not measured here.
