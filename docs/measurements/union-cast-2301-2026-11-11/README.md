# GCC's cast to a union, Buster #2301: base vs head

Compiler issue: [#2301](https://github.com/buster14a/buster/issues/2301). Compiler PR: [#2373](https://github.com/buster14a/buster/pull/2373).

- Base: main `e43dfc1027368452a3e6b6c3f32e54faffae587a`.
- Head: `d096318292137750c41284eb02108fbc548fc815` (the PR's first commit).
- Executables' SHA-256 values: `host.txt`.

The head adds the union cast's checker rule, its lowering, its warning walk (one more call per cast node in
`check_input_warning_graph`), its static initializer's redirect (a test per initializer value) and the lowering fast
paths' test of a cast's conversion flags.

## Host and method

The Ryzen 7 9700X (`benchpress`), CPU 2, THP `always`, Linux 6.18.50, clang 23.1.1 (`host.txt`). Each tree was built
with `./build.sh` (Release, native host), one lock hold per build (`setup.sh`; `build-*.log`). `ab.sh` ran
`build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh ../base ../head -- time-runs --runs 11`.
`ab` took the lock per run, alternating the trees in Williams order. Each run timed four lists of 11 fresh processes:

1. `-fsyntax-only` of the frozen `sqlite3.c` (corpus `preprocessor-391e729af658`, gnu17, `-march=znver5`);
2. `-c` of it;
3. `-fsyntax-only` of base's `src/buster/compiler/main.c` (`-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing`);
4. `-c` of it.

Both trees compiled the same inputs. `summ.sh` extracts each run's list medians from `ab.log`.

## Results

The median of the five runs' medians for each tree:

| Workload | Wall, base → head | User cycles | Instructions |
| --- | --- | --- | --- |
| `sqlite3.c -fsyntax-only` | 99.38 → 99.61 ms (+0.23%) | +0.53% | 1,030,623,075 → 1,031,483,774 (+0.08%) |
| `sqlite3.c -c` | 121.96 → 122.21 ms (+0.21%) | +0.17% | 1,312,986,184 → 1,315,103,121 (+0.16%) |
| `main.c -fsyntax-only` | 601.48 → 601.23 ms (−0.04%) | +0.17% | 9,060,710,657 → 9,086,825,744 (+0.29%) |
| `main.c -c` | 676.95 → 677.25 ms (+0.04%) | +0.19% | 10,319,530,654 → 10,346,505,347 (+0.26%) |

The runs' medians on `sqlite3.c -fsyntax-only` were 99.16–99.47 ms (base) and 99.48–99.88 ms (head). The wall-time
differences are within about one run's spread; the instruction counts are deterministic and show the added work:
0.08–0.29%.

## Limitations

One build per tree at one code placement, without `build.sh shifts` or fresh copies (Buster's
`docs/profiling.md`, #509). No perf profile attributes the added instructions.
