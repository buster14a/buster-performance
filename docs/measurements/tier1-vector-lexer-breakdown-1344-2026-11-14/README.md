# Tier 1 on the compiler's own vector lexer: every instruction of `c_tokenize`, by cause (buster#1344)

14 November 2026, buster main `ca2bd994a39e0590c3c761ffbb9f80ad66407ef8`. This is the breakdown
[buster14a/buster#1344](https://github.com/buster14a/buster/issues/1344) asks for, on current main rather than the
4 November binary, and counted exactly rather than sampled.

## Result

`c_lexer_benchmark.c` built as `measure-tier1-rows --lexer` builds it (`-march=native`), `c_tokenize` on a 9,076-byte C
file that needs no scalar lexer (`mid200.c`), one call, every executed instruction counted:

| Build | instructions | per byte | against clang |
| --- | ---: | ---: | ---: |
| clang -O2 | 27,785 | 3.06 | 1 |
| `--tier1` | 274,120 | 30.20 | 9.87× |

Where Tier 1's go (`results/mid200-tier1.summary.txt`, `results/mid200-tier1.runs.txt`):

| Cause | instructions | share | per byte |
| --- | ---: | ---: | ---: |
| Immediate stores to the stack | 170,752 | 62.3% | 18.81 |
| ... byte splats (`_mm512_set1_epi8`): 8 zeroing quadword stores, 64 byte stores, then 1 load | 104,616 | 38.2% | 11.53 |
| ... zero vectors (`_mm512_setzero_si512`, the `maskz` forms): quadword stores of 0, twice, then 1 load | 24,870 | 9.1% | 2.74 |
| ... quadword and doubleword splats and general constants, then 1 load | 35,344 | 12.9% | 3.89 |
| ... not followed by a vector load | 5,922 | 2.2% | 0.65 |
| The 64-byte loads of those vectors | 6,815 | 2.5% | 0.75 |
| Everything else | 96,553 | 35.2% | 10.64 |

The runs are 6,815 in 142 chunks: **48 vectors are rebuilt on the stack per 64-byte chunk**, each read back by a load
that no store can forward to (the load is wider than every store it reads). Calls, returns, pushes and pops are 0.19%
of the instructions; the by-value vector ABI is not what this loop pays for after #1282's inlining.

The same shape in three lines of C (`v1.c`, by the same compiler):

| Function | Tier 1 instructions | immediate stores | clang -O2 instructions |
| --- | ---: | ---: | ---: |
| `_mm512_add_epi8(x, _mm512_set1_epi8(7))` | 87 | 72 | 2 |
| `_mm512_maskz_compress_epi8(k, x)` | 35 | 16 | 3 |
| `_mm512_add_epi32(x, _mm512_set1_epi32(1))` | 39 | 24 | 4 |

The cause is in the lowering, not in constant selection: clang's headers write these as vector compound literals
(`(__m512i)(__v64qi){ __w, __w, ... }`), and a vector initializer list is lowered as an object in memory (zero it, store
each element, load the vector), which no later pass turns back into a value.

Two more things this run found:

- **The Tier 1 build of the lexer crashes on real source files** (`c_lexer.c`, `c_parser.c`, `lane.c`,
  `tests/driver/tier1_truth.c`): SIGSEGV in `peek_char`, called by `c_tokenize_scalar_range`, called by `tokenize_c`,
  that is, whenever the vector lexer hands a range to the scalar one. Tier 0's and clang's builds pass. So
  `measure-tier1-rows --lexer` fails on this host at this commit.
- A one-chunk file (`small.c`, 29 bytes) costs 17,491 instructions by Tier 1 against 1,958 by clang: 9,687 of them
  are immediate stores outside the chunk's path (10,821 immediate stores in all).

Wall time in this virtual machine, `benchmark-lexer`'s medians on a 46,679-byte file of the same lines (not a 9700X
timing, and no counters here): `c_tokenize` 0.883 ms by Tier 1, 0.015 ms by clang -O2 (59×); Tier 1's vector lexer is
2.1× slower than Tier 1's scalar lexer (0.424 ms).

## Method

No performance counters exist in the session's virtual machine, and valgrind has no AVX-512. `stephist.c` counts
instead: it runs the program under ptrace to a breakpoint at the function's entry, then single-steps until the function
returns, adding one to the count of each address executed (about 30,000 instructions a second here). The counts are
exact and repeat. `annotate.py` joins them with `objdump -d` and classifies each instruction by its operands;
`runs.py` groups consecutive immediate stores to the stack by shape and by what follows them.

clang's 3.06 instructions per byte here agrees with the 3.004 the issue records for clang -O3 on the 9700X with
counters, over the whole source tree.

```sh
BUSTER_TOOLCHAIN=path ./build.sh                       # Develop; this machine's clang 23.1.6, not CI's 23.1.4
./build/compiler measure-tier1-rows --clang "$(command -v clang)" --lexer src/buster/compiler/c_lexer.c \
    --rounds 100 --passes 5 --runs 1 --warmups 0 --directory DIR --keep    # the builds; fails at the lexer's run
for i in $(seq 1 1000); do printf 'int main%d(void) { return %d + x[%d] * 3; }\n' $i $i $i; done > mid.c
head -200 mid.c > mid200.c
clang -std=c17 -O2 -Wall -Wextra -Werror stephist.c -o stephist
entry=$(nm DIR/lexer-tier1 | grep ' t c_tokenize$' | cut -d' ' -f1)
taskset -c 1 ./stephist --entry $entry --calls 1 --output mid200-tier1.hist -- DIR/lexer-tier1 mid200.c
python3 annotate.py DIR/lexer-tier1 mid200-tier1.hist            # by function and class
python3 annotate.py DIR/lexer-tier1 mid200-tier1.hist dump > mid200-tier1.dump
python3 runs.py mid200-tier1.dump
```

## Files

- `host.txt`: the machine, the kernel, clang and the buster revision.
- `stephist.c`, `annotate.py`, `runs.py`: the counter and the two readers.
- `small.c`, `mid200.c`, `v1.c`: the inputs.
- `results/*.hist`: `OFFSET COUNT` per executed address; `results/*.summary.txt`: by function and class;
  `results/mid200-*.dump.gz`: every executed instruction with its count and class; `results/mid200-tier1.runs.txt`: the
  immediate-store runs by shape; `results/binaries.sha256`: the three lexer programs.

## Limits

- One synthetic input without comments, strings or preprocessor lines, and one call. The classes' shares will move on
  real sources; the constants' count per chunk does not depend on the text.
- An Intel host (`host.txt`), where `-march=native` is not `znver5`. Instruction counts carry over to the extent the
  selected rows do; times do not, and the 9700X's are still to be taken.
- The classifier reads operands only: a stack store of an immediate that is not part of a vector's construction is
  counted with them (5,922 of the 170,752 are followed by something other than a vector load).
