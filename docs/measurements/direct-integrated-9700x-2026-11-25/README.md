# Combined direct compiler on the Ryzen 7 9700X

Five Release builds compiled the same inputs on benchpress, pinned to CPU 2. The integration combines Buster PRs #3589, #3590 and #3591 and includes the macro-rebinding and expression-context fixes. All five builds used the same source directory and Clang 23.1.4 with the native host target. The five changed compiler files match the sources measured on the host. [Compiler revision](https://github.com/buster14a/buster/commit/3f1303c1bb5803b9db676f0bf79d22e77695ed3c) · [Five revisions and executable hashes](raw/builds.tsv) · [Source checksums](raw/compiler-sources.sha256)

## Compile times

Median wall time in milliseconds for a fresh process, including startup and object output. Each cell covers 60 measured runs after ten warm-ups. The five builds each occupied every position twelve times. The timer started after acquisition of the shared benchpress lock. SQLite was measured once with a fresh output per run and again with an existing file overwritten each time. [All samples](raw/times.tsv) · [Medians to four decimals](raw/medians.tsv)

| Workload | Main | #3589 | #3590 | #3591 | Combined |
|---|---:|---:|---:|---:|---:|
| SQLite, fresh output | 17.952 | 17.393 | 17.606 | 17.777 | 17.127 |
| SQLite, overwrite | 18.023 | 17.337 | 17.668 | 17.803 | 17.026 |
| Six musl iconv tables | 2.466 | 2.469 | 1.282 | 1.214 | 1.197 |
| 4,000 inline functions | 8.901 | 10.531 | 1.636 | 1.667 | 1.643 |
| 4,000 switch cases | 2.696 | 2.698 | 1.122 | 2.721 | 1.141 |
| 2,000 functions with 25 locals each | 52.160 | 52.222 | 52.057 | 4.771 | 4.579 |
| 32,768 unsigned 32-bit constants widened to 64 bits | 1.922 | 1.913 | 1.795 | 1.453 | 1.543 |

The combined compiler spent 4.6% less time than main on fresh SQLite output and 5.5% less when overwriting. It took 6.2% longer than #3591 alone on the widened unsigned array and 1.7% longer than #3590 alone on the large switch. The 50,000-local file used the full compiler on main, #3589 and #3590. Every build's object returned the expected value for all 2,000 functions. Objects matched byte for byte between all builds using the same path on each workload. [Path selection and object hashes](raw/objects.tsv)

## Macro and integration checks

The macro-redefinition program expects a call after a cast alias changes from `(void)` to a function. On #3589 and the initial three-way integration, the direct compiler dropped the call and the executable returned 1. The final integration checks the alias at invocation. In comma and conditional expressions the void result is preserved, keeping both examples on the direct path. All five macro cases returned zero on the direct path with the final integration. The probe sources are in `inputs/`. The label `all` in the probe results identifies the initial integration and `checked` identifies the measured, corrected integration. [Reproducer](inputs/macro-redefinition.c) · [Five macro probes across builds](raw/macro-results.tsv)

The final integration passed 16 of 16 direct self-tests. Across 6,161 local compile comparisons, exit status, output, diagnostics, object bytes and direct-path selection matched main, including all 4,162 successful compiles. All 220 pinned c-testsuite programs linked and ran with their expected output. The semantic probe exercised a wide enum, a stack local and a function pointer into a transitive inline chain. [Semantic probe](inputs/semantics.c)

## Reproduction

Use a fresh working directory on benchpress. Build the five revisions from `raw/builds.tsv` in turn in the same Buster checkout with `./build.sh --config Release --jobs 6`. Copy each resulting `build/compiler` into the working directory's `bin/` under its timer label. Build under the shared lock with the requested cores. Fetch the frozen corpus with the Buster checkout's `tools/ci/fetch-corpus.sh`. The prior measurement supplies the input generator for the inline chain, locals and musl tables, and the per-process timer. [Pinned generator and timer](https://github.com/buster14a/buster-performance/tree/d23854cf9a6e33bf484fab1917dfe73a6b77384f/docs/measurements/direct-benchpress-9700x-2026-11-25/scripts)

Set `RECORD` to this record, `PRIOR` to the pinned scripts directory and `BUSTER` to the compiler checkout. Export `EXCLUSIVE_OWNER`, `EXCLUSIVE_TITLE` and `EXCLUSIVE_LINK` for the shared lock in your session. Run the following in the working directory after building the five compilers.

```sh
bash "$BUSTER/tools/ci/fetch-corpus.sh" "$PWD/corpus"
bash "$PRIOR/generate-inputs.sh" "$PWD/inputs"
cp "$RECORD"/inputs/*.c inputs/
cc -O2 "$PRIOR/time-one.c" -o bin/time-one
cc -std=c17 -O2 "$RECORD/scripts/generate-tables.c" -o bin/generate-tables
bin/generate-tables switch > inputs/switch.c
bin/generate-tables unsigned > inputs/unsigned.c
(cd inputs && sha256sum -c "$RECORD/raw/inputs.sha256")
bash "$RECORD/scripts/run.sh" "$PWD"
```

The runner verifies object hashes and executes the semantic, switch, unsigned and local-symbol probes before timing. It writes `times.tsv`, `objects.tsv` and `logs/scheduling.log` in the working directory. For each workload and build take the median of `wall_ms` over rounds 0 through 59. [Run ordering, flags and inputs](scripts/run.sh) · [Per-process verification and timing](scripts/sample.sh)
