# #3311 call sites (PR #3360 at 1a777a14) on the 9700X

The #3319 kernels (`acc = addv(acc, d)` 100,000,000 times in `main`), on benchpress (Ryzen 7 9700X), each timing run
under `exclusive.sh`, pinned with `taskset -c 2`, 11 rounds of every build in turn (`time.sh`, `run2.sh`).

- base: buster `75751468` (main, with #3319), Release; fix: `1a777a14` (#3360's head then: call-site arguments and
  one-part results as values, and inline candidates with aggregates compiled by the own pipeline), Release.
- clang: benchpress's host clang 23.1.1, `-O0` and `-O2`. All builds print the same value (`kernels-build.log`).
- Medians in ms (`summary.tsv`; raw rounds in `times-*.tsv`).

| struct | clang -O0 | clang -O2 | Tier 0 | `--tier1` base | `--tier1` fix | base ÷ fix |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `{ int x, y, z, w; }` | 420.1 | 109.5 | 448.4 | 134.6 | 109.2 | 1.23× |
| `{ int x, y; }` | 407.8 | 109.2 | 411.1 | 91.2 | 73.1 | 1.25× |
| `{ long x, y; }` | 133.5 | 73.1 | 154.3 | 120.4 | 73.3 | 1.64× |
