# A call of the function's own result passes the hidden pointer on, Buster #2684

Compiler issue: [#2684](https://github.com/buster14a/buster/issues/2684). Compiler PR:
[#2799](https://github.com/buster14a/buster/pull/2799), head `dacea06` (three commits on main
`2ebfe68a856613e300231520af5e7ec5627708b6`: `f71aaa4`, `ee82cbf`, `dacea06`).

A function that returns a struct or union through its hidden pointer now passes that pointer on to a call whose
result is its own: a `return f(...);` and the named result's (#1375) call initializer. Its callee writes the result
where the function's caller wants it, as clang `-O0` passes its `sret` pointer on. Before, the call returned into a
frame object of the function's own, which was then copied there (in 8- or 16-byte pieces up to 256 bytes, by `memmove`
past). Tier 0 and the typed interpreter now copy nothing. Tier 1 still returns such a call into a frame object and
copies it, because its selector takes a call's destination as a frame object's address alone; #2820 is that.

## Trees and binaries

Each tree is a clone of `buster14a/buster` on the 9700X, built by `./build.sh --config Release` (`-march=native`,
znver5 there). Their executables' SHA-256 values are in each results directory's `receipts.txt`.

- **main**: `2ebfe68a`, no changes. The same executable (`31420483…`) in all three runs.
- **head** (`results-f71aaa4/`): main with the PR's first commit. Its `ir_lower` copied a forwarded result where
  parameter 0 points in 8-byte pieces at every size.
- **head2** (`results-ee82cbf/`): with the second commit, whose `ir_lower` calls `memmove` past 256 bytes, as main's
  lowering did. Its IR call's result was `void`, which the interpreters' `memmove` binding refuses (the third commit's
  fix); the code Tier 1 makes of it is the third commit's, but for the call's unread result.
- **head3** (`results/`, the PR's head): main with the three commits. Its tree is `dacea06`'s
  (`git write-tree` = `26a74397…` in both).

## Host and method

The Ryzen 7 9700X (`benchpress`), Linux 6.18.50, CPU 2 with governor and EPP `performance`, clang 23.1.1, perf 7.2.9
(`receipts.txt`). The harness is #1375's (`named-results-1375-2026-11-13`) with this PR's kernels.

**Kernels** (`harness/kforward.c`, `harness/knamed.c`, each linked with `harness/driver.c`, compiled by clang `-O2`):

- `forwardN`: `fwd(x)` is `return mk(x);` of a struct of N longs (3, 8 and 64: 24, 64 and 512 bytes), which `mk`
  builds in place (NRVO, #1375); the loop reads one field of each result. 50 M, 20 M and 5 M calls.
- `namedN`: `named(x)` is `struct Big b = mk(x); b.a[0] += 1; return b;` (8 and 64 longs), 20 M and 5 M calls.

Each kernel is compiled by each tree's compiler (`-c -O0` for Tier 0, `-c -O0 --tier1` for Tier 1) and by clang `-O0`
(`harness/build-kernels.sh`). Every driver prints a checksum; within each run every binary of a kernel prints the same
one, clang's, and every perf exit status is 0 (`kernels.tsv`, columns 7 and 8).

**Lock:** every step took the 9700X's lock for itself alone: each tree's build, each kernel build, each of the 25
measured binaries and each of the 8 compile timings, 37 holds per run. Each hold's first act appended the holder line
to `holds.txt`; all 111 name this work (`claude-2684`). `busy.txt` has the busiest processes at each measurement.

**Measured:** `harness/measure-one.sh` runs a binary once for its checksum, then `perf stat -r 10` of `cycles:u`,
`instructions:u`, `ls_bad_status2.stli_other:u` (loads that couldn't take an older store's data) and `task-clock`,
pinned to CPU 2. Columns: binary, ms, cycles, cycles' ± (perf's spread over the 10 runs), instructions, `stli_other`,
checksum, perf's status.

**Compile time** (`harness/compile-one.sh`): `-c --lanes 1` by main's and the head's compilers, pinned to CPU 2,
`perf stat -r 5`, of the frozen corpus's `sqlite3.c` (SHA-256 `0a409f16…`) and main's own `src/buster/compiler/main.c`,
by both tiers (`compile.tsv`).

**Tests and self-host** (`harness/run3.sh`, one hold each): head3's Develop build, `test-checker
--program-initializers`, `test-ssa-source --typed` and `--typed --tier1` on `tests/interpreter/source.c`, and
`test-tier0 --cross-check` (`results/tests.txt`); then the self-host qualification (`tools/ci/selfhost.c`, as
`selfhost.yml` runs it) of each head's Release compiler (`selfhost-summary.md`): PASS in all three, 43 units, 14 smoke
commands, 5 probes, 10 byte comparisons, 10 executable runs.

## Results (head3, the PR's head)

Millions of user-mode cycles, the mean of 10 runs:

| kernel | main T0 | head T0 | main T1 | head T1 | clang `-O0` |
| --- | ---: | ---: | ---: | ---: | ---: |
| `forward3`, 24 bytes, 50 M calls | 699.9 | **634.3** (−9.4%) | 550.5 | 555.5 | 764.3 |
| `forward8`, 64 bytes, 20 M calls | 860.5 | **466.6** (−45.8%) | 334.3 | 334.0 | 578.3 |
| `forward64`, 512 bytes, 5 M calls | 917.9 | **762.8** (−16.9%) | 417.8 | 442.1 | 755.1 |
| `named8`, 64 bytes, 20 M calls | 880.6 | **509.1** (−42.2%) | 377.1 | 377.9 | 595.5 |
| `named64`, 512 bytes, 5 M calls | 895.7 | **747.9** (−16.5%) | 448.7 | 424.8 | 801.1 |

- **Tier 0:** the copy is gone. Instructions fall by 190 to 500 M (5.25 → 4.75 G for `forward3`), and the loads that
  couldn't forward fall from 112.6 M to 1.4 K (`forward3`), 80.0 M to 38 K (`forward8`), 21.3 M to 24 K
  (`forward64`) and 23.5 M to 2.9 K (`named64`); `named8` keeps 16.1 M of its 81.8 M, its `b.a[0] += 1` reading
  the field `mk` just stored. Every Tier 0 row is now below clang `-O0`'s cycles but `forward64`, 1.01 times.
- **Tier 1:** its code is main's: the same instructions up to 256 bytes, and one more per call at 512 bytes (5.0 M of
  2,245 M and of 2,270 M), where the forwarding slot's copy calls `memmove` as main's call object's copy did. The
  512-byte rows' cycles move within main's own variation across the three runs:

  | Tier 1, M cycles | main, run 1 / 2 / 3 | head (8-byte pieces) | head2 | head3 |
  | --- | --- | ---: | ---: | ---: |
  | `forward64` | 442.4 / 436.3 / 417.8 | 468.7 | 442.2 | 442.1 |
  | `named64` | 437.6 / 426.9 / 448.7 | 478.4 | 440.9 | 424.8 |

  The first head's 8-byte pieces took 2,690 M and 2,715 M instructions, 445 M more than main's `memmove`, and 5.9%
  and 9.3% more cycles than main in that run: that is why the second commit calls `memmove` past 256 bytes.

**Compile time** (head3, `results/compile.tsv`), `-c --lanes 1`, mean of 5:

| input | tier | main ms | head ms | main instructions | head instructions |
| --- | --- | ---: | ---: | ---: | ---: |
| `sqlite3.c` | T0 | 121.37 | 121.04 | 1,349,487,080 | 1,349,480,470 |
| `sqlite3.c` | T1 | 620.03 | 621.38 | 8,206,930,699 | 8,209,203,665 |
| `main.c` | T0 | 1,540.58 | 1,533.36 | 21,269,890,079 | 21,264,210,778 |
| `main.c` | T1 | 2,153.64 | 2,152.34 | 30,371,253,731 | 30,367,462,202 |

Instructions move by 0.03% at most (Tier 1's `sqlite3.c` +2.27 M, 0.028%; `main.c` −5.7 M in Tier 0 and −3.8 M in
Tier 1), and the times by 0.5% at most.
