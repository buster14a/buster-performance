# The x86 builtins' bit manipulations as IR intrinsics, through Tier 1 (buster#141), 2026-11-03

Evidence for [buster#1256](https://github.com/buster14a/buster/pull/1256), which makes the IR's `mulhu` an
`intrinsic` opcode, its operation in `c`: `mulhu`, and the x86 builtins' scalar BMI2 `pdep`, `pext` and `bzhi` and
BMI1 `bextr` of `unsigned int` and `unsigned long`. The typed stream's rows of those builtins lower to it, and Tier 1
selects each as its one VEX instruction. Before it, a function with one of those builtins stopped at the lowering to
the IR, and `--tier1` left it to Tier 0.

It covers, on the 9700X, its head against its main:

- the tests the change touches, by the head;
- a kernel of the builtins (`kernel.c`) by clang -O2, by each tree's Tier 0 and by each tree's `--tier1`;
- `--tier1 -c` of the frozen `sqlite3.c`, which has none of the builtins, and the instructions the change cost it;
- `benchmark-ir`, the IR verifier, whose vector path checks the intrinsic's rule;
- the compiler's own `main.c` by `--tier1 -march=native`.

## Revisions

| Tree | Revision | What it is |
| --- | --- | --- |
| `main-48ac6d71` | `48ac6d71` | main at buster#1256's first commit |
| `head-b37f0d25` | `b37f0d25` | buster#1256's first commit: the intrinsics |
| `var-defer` | `b37f0d25` with `variant/ir_defer.c` | the intrinsic's rule deferred to the verifier's scalar path |
| `var-inline` | `b37f0d25` with `variant/ir_inline.c` | `ir_constant_fits` always inlined |
| `var-fix` | `b37f0d25` with `variant-inline/fix.patch` | `ir_constant_fits` always inlined, and one test for the intrinsics in selection's chain: buster#1256's `94add8c0` |

The two revisions are `git archive`s of those commits. Each variant is a copy of `head-b37f0d25`'s tree with the
named file in place of `src/buster/compiler/ir.c`, or with the patch applied (`variant-fix/patch.txt`).

buster#1256 has since merged main `2fef25b0` (`738eead4`) and added two commits that these runs don't measure:
`86f26c81`, which keeps the BMI test's records out of the baseline's selection manifest (a test alone); and
`10b27280`, which lets #939's code certificate take Tier 1's compare-exchange (`--verify` alone).

## Method

Everything ran on the Ryzen 7 9700X (benchpress), reached over the tailnet from the cloud session: Linux
6.18.50-2-lts, clang 23.1.1, perf 7.2.9.

- Each build and each measurement held `~/buster-fast-bench/exclusive.sh` once (owner `claude-141-intrinsics`). Every
  timed process was pinned to CPU 2, and the tests to CPUs 2 to 5. Lock-wait lines are removed from the logs.
- `queue.sh` runs, in order:
  - both builds, `BUSTER_DEBUG_INFO=0 ./build.sh` (`build.sh`, `logs-build/`);
  - the tests by the head (`tests.sh`, `tests/`);
  - the kernel (`kernel.sh`, `kernel/`);
  - `perf stat` of `--tier1 -c` of the frozen `sqlite3.c`, and whether the two `sqlite3.o` are identical (`bisect.sh`,
    `bisect/`);
  - `benchmark-ir` (`verifier.sh`, `verifier/`);
  - `main.c` by `--tier1 --tier1-report --tier1-refusals -march=native` (`selfhost/`).
- `variant.sh`, `variant-inline.sh` and `variant-fix.sh` build a variant each and run `perf stat` of the same
  `sqlite3.c` compile by main, the head and the variant, 11 runs a hold, 3 rounds in a rotating order. Each compares
  the three `sqlite3.o` and lists which builds have `ir_constant_fits` and `ir_simd_value_valid` out of line.
  `variant-inline.sh`'s last loop quoted its trees wrongly, so its `inlining.txt` pairs two trees on one line;
  `variant-inline/inlining-trees.txt` is the same `nm` count taken afterwards for each tree.
- `attribute.sh`, `attribute-fix.sh` and `attribute-slow.sh` sample the compiles' instructions by symbol (below).
- `common.sh` has the paths, the options and the lock's metadata.
- The input is the frozen `sqlite3.c` 3.53.2 of earlier records, SHA-256
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with
  `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`.

## Tests (`tests/head-b37f0d25/`)

By the head on the 9700X, every one exit 0 and no failure:

| Command | Result |
| --- | --- |
| `test-ir` | 7,801 checks |
| `test-ir-parse` | 6,071 checks, 18 functions |
| `test-ir-interpreter` | 959 checks |
| `test-ir-simd` | 245,666 checks; 8 of the front end's scalar BMI rows decode to intrinsics |
| `test-tier1-select` | 591,558 checks |
| `test-tier1-wide` | 46,175 checks |
| `test-ir-lowering` | 758,534 checks |
| `test-ir-source --simd … bmi-builtins.c` | 3 files, 11 functions, `left_out=0 failed=0` |
| `test-tier1-cfg-source --simd … bmi-builtins.c` | 11 allocated and certified by both paths, 0 failed |

`test-tier1-select`'s new test runs each intrinsic of both widths natively here, on both paths.

## The kernel (`kernel/`)

`kernel.c` encodes random 32-bit coordinates as 64-bit Morton codes by `pdep`, decodes them by `pext`, and walks a
code's bit fields by `bextr` and `bzhi`, 20 million times. It prints a hash of every result. `perf stat` of each
program ran 11 runs a hold, 3 rounds in a rotating order; the table gives the means.

| Program | Instructions | Cycles | Task clock |
| --- | ---: | ---: | ---: |
| clang -O2 (`k-clang-O2`) | 1,537.61 M | 353.84 M | 63.87 ms |
| main, Tier 0 | 6,375.11 M | 810.84 M | 146.30 ms |
| main, `--tier1` | 6,055.11 M | 890.58 M | 160.69 ms |
| head, Tier 0 | 6,375.11 M | 810.82 M | 146.28 ms |
| head, `--tier1` | 4,107.61 M | 710.24 M | 128.16 ms |

- Every program prints the same output (`kernel/outputs.txt`).
- Main's `--tier1` compiles `main` by Tier 1 and leaves the four functions with the builtins to Tier 0, refused at the
  lowering to the IR (`kernel/build-main-48ac6d71-tier1.txt`). The head's compiles all five by Tier 1.
- The head's `--tier1` takes 20.2% fewer cycles than main's, and 12.4% fewer than either Tier 0. It is still 2.0
  times clang -O2's cycles.
- Main's mix of tiers takes more cycles than its Tier 0 alone: its Tier 1 `main` calls the four Tier 0 functions.
- The head's code (`kernel/disassembly-k-head-b37f0d25-tier1.txt`):
  - `morton_encode` is two `pdep`s, of the masks in registers, and an `or`;
  - `fields`' loop computes `bextr` and `bzhi` in registers.
  - clang -O2 inlines all four functions into `main`; Tier 1 doesn't inline.
- Every program's three rounds' cycles are within 0.15 M of each other.

## `sqlite3.c` by `--tier1 -c` (`bisect/`)

| Tree | Instructions (3 holds) | Cycles (mean) |
| --- | ---: | ---: |
| main `48ac6d71` | 5,860.641 M, every hold | 2,407.74 M |
| head `b37f0d25` | 5,906.297 M, every hold | 2,406.13 M |

The two trees write the same `sqlite3.o` (`bisect/cmp.txt`). The head takes 45.66 M more instructions (+0.78%) at the
same cycles.

## Where the instructions went (`variant/`, `variant-inline/`, `variant-fix/`, `attribute*/`)

Each variant set ran with main and the head again:

| Tree | Instructions | Cycles (range of 3 holds) | `ir_constant_fits` out of line |
| --- | ---: | ---: | ---: |
| main `48ac6d71` | 5,860.641 M | 2,406.39 to 2,408.11 M | 0 copies |
| head `b37f0d25` | 5,906.297 M | 2,405.47 to 2,408.98 M | 3 copies |
| `var-defer` | 5,905.514 M | 2,407.69 to 2,409.45 M | 3 copies |
| `var-inline` | 5,878.831 M | 2,400.70 to 2,404.38 M | 0 copies |
| `var-fix` | 5,878.987 M | 2,394.76 to 2,395.89 M | 0 copies |

- Each tree's instructions are the same in every hold, across all three sets, to within 2,000.
- All five trees write the same `sqlite3.o` (each set's `cmp.txt`).
- Deferring the intrinsic's rule to the verifier's scalar path saves 0.78 M: the rule's vector checks aren't the cost.
- The verifier's per-instruction oracle (`ir_check_instruction`, inlined into `ir_check_rows`) is what every constant
  takes. The intrinsic's rule, a case in its switch, grew it past clang's inliner budget. `ir_constant_fits` and
  `ir_simd_value_valid` became out-of-line calls, three copies each, where main has none. `attribute/` first showed
  it: 359 samples in `ir_constant_fits`, which main has none of.
- With `ir_constant_fits` always inlined, the head gives 27.47 M back. One test for the intrinsics in selection's chain
  of candidates, rather than two, changes nothing measurable: `var-fix` reads 0.16 M more than `var-inline`.
- `var-fix` is buster#1256's `94add8c0`. It takes 18.35 M more instructions than main (+0.31%), at 0.47% fewer cycles
  than main and the head in its set.

ATTRIBUTION

## The IR verifier (`verifier/`)

`benchmark-ir --only vector` and `--only scalar`, 21-pass medians in ns per instruction, three rounds in a rotating
order. Each cell is a small function's (32 instructions) and a large one's (262,144):

| Tree, path | Round 1 | Round 2 | Round 3 |
| --- | --- | --- | --- |
| main, vector | 5.047 / 5.165 | 4.933 / 5.137 | 5.056 / 5.115 |
| head, vector | 4.984 / 5.031 | 5.258 / 5.072 | 4.971 / 4.969 |
| main, scalar | 9.076 / 8.245 | 9.052 / 8.181 | 8.999 / 8.323 |
| head, scalar | 9.309 / 8.687 | 8.746 / 8.239 | 8.869 / 8.238 |

The head's vector path is within the rounds' spread of main's, on the small function and the large one. These
synthetic functions have no constants, so the out-of-line `ir_constant_fits` above doesn't show here.

## The compiler's own `main.c` (`selfhost/`)

By `--tier1 -march=native` on this host, of its 1,119 functions:

| Tree | By Tier 1 | Stopped at the lowering to the IR | Naked |
| --- | ---: | ---: | ---: |
| main `48ac6d71` | 1,003 | 115 | 1 |
| head `b37f0d25` | 1,006 | 112 | 1 |

The three the head takes are `_pdep_u64`, `_pext_u64` and `_bzhi_u64`. The 112 that still stop are vectors of
elements other than 32-bit integers and the x86 builtins' rows of vectors.

## Limitations

- The kernel is one program the change is for. `sqlite3.c` has none of the builtins, so it measures only what the
  change costs code without them.
- Cycles and wall time swing by about 0.5% between builds that differ in code placement alone; instruction counts are
  deterministic to a few thousand. `var-fix`'s 0.47% fewer cycles is within that swing.
- The variants were measured on `b37f0d25`'s tree, not on buster#1256's head after its merge of main.
