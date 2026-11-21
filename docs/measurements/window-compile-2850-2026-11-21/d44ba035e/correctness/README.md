# Production comparison windows in if and while

Buster commit `d44ba035e84172eaac4ddd4b4b3339bb4fd34b9b` is the first #3226 candidate, stacked on the variable-length window tape at `39cd1b6ce77f2289a56ec0d1de2f5044e1607979`. The candidate's `--node-window` already takes returns and simple assignments. Its additional `--node-window-conditions` option takes eligible integer comparisons and implies the base window. The controls, bounded comparisons, admitted comparisons and native row counts below refer solely to the added condition path.

| Source | Translation units | Controls | Bounded | Admitted | Native rows |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite | 1 | 11,447 | 5,540 | 1,367 | 4,101 |
| Lua | 34 | 1,705 | 753 | 99 | 297 |
| musl | 1,336 | 7,782 | 3,990 | 702 | 2,106 |

SQLite, at 716,136 preprocessor tokens, lost 2,734 more graph nodes under the additional option, from 319,066 to 316,332. The local ordinary, base-window and condition-window compiles produced identical objects. The paths to the input passed to the compiler can change an object's file name and checksum. All three matched within each experiment. Each line of the `corpus/*.jsonl` files contains the corpus-relative path, four counts in the table's order, exit status, and whether the diagnostics/status differed from the base window. The exact-head musl files produced 324 default warnings and 1,869 under `-Wall -Wextra`, with matching full diagnostics. Both Lua runs passed, also with matching diagnostics.

The 104-function linked runtime test checked 45,864 calls against Clang. Qualifying configurations took 96 comparisons and 288 rows, and the debug configuration fell back. All modes compared in `results/exact-runtime.log` produced the same object and program result as the base Buster compilation. The two GNU C language standards, warning/error/suppression policies and driver routes in that script also agreed on the separate warning fixture. `results/exact-boundary.log` records three actual source neighbors whose comparison alternately fits, crosses, and fits the 1,024-token postorder chunk. All three emitted the ordinary native object. `results/exact-options.log` covers sixteen option combinations. Its columns after the options are the common status and the comparison admissions (None means the comparison option was disabled for that configuration).

All 90,000 historical generated sources matched ordinary status and diagnostics. Of these, 73,203 were accepted and 16,797 were rejected. No process terminated by signal. Four of the generated programs that were eligible for counter checks had an admitted condition. All 8,009 historical probes compiled to byte-identical objects. Per-seed source digests and per-probe-suite counts are in `results/generated.log`. The larger explicitly generated runtime corpus above positively exercises each of the six comparison operators many times.

The separate initial tracked/inline sweep in `results/sweep.log` combines the 1,260 tracked C tests on this head with the historical extraction of 13,879 programs. All three warning policies agreed on all 45,417 pairs. One historical enum-cast source exited with SIGSEGV in both modes under `-Weverything`. The default and `-Wall -Wextra` suites had no signals. A fresh exact-head extraction produced 13,921 programs from 559 test source files. All 45,543 pairs of the exact-head sweep also matched, including the same enum-cast signal under the strict warning configuration. Its filename in this extraction is `c_check_enum_cast_driver_test-00167-05691.c`. The two extractions name some identical programs with different sequence numbers. See `results/inline-d44.log` and `results/sweep-d44.log`.

The checker and driver receipts are under `results/`. The two native checker shards covering the node machine and attested inventory passed 210,487 and 85,788 assertions. The operand diagnostic driver passed 1,585 checks, with zero differences across its 26 warning fixtures. A separate Clang MemorySanitizer Release build at -O3 ran the position-independent compiler without baking its static tables. It passed all 210,487 assertions of checker shard 5. Its warning-enabled fixture admitted all six comparisons, retained 18 rows, and emitted a byte-identical native object.

The [target-feature and reachability comparison](https://github.com/buster14a/buster-performance/tree/9ebdeeb99e5932773dca2b19115265c53cf7417a/docs/measurements/window-conditions-targets-2850-2026-11-21) contains the original condition-bearing compiler's separate 756 pairs. The [locked native results](https://github.com/buster14a/buster-performance/tree/4325649598dc005f9ccb86e678e8dad58ed6359e/docs/measurements/window-compile-2850-2026-11-21/d44ba035e) show a throughput regression under the additional option. #3226 stayed in draft while that cost was investigated.

## Reproduce

Build the Buster commit above. The local oracle was Clang 23.1.4. The scripts take a Buster executable, a Buster checkout or a writable scratch directory as indicated. Use absolute paths. The historical generator and extractor come from the buster-performance repository, with the command's argument pointing to its checkout.

```sh
python3 qualify.py /path/to/buster /path/to/buster/build/compiler /path/to/clang /tmp/condition-runtime
python3 boundary.py /path/to/buster/build/compiler /tmp/condition-boundary
python3 options.py /path/to/buster /path/to/buster/build/compiler /tmp/condition-options
python3 generator.py /path/to/buster/build/compiler \
    /path/to/buster-performance/docs/measurements/summary-facts-2850-2026-11-21/fuzz/fuzz.py /tmp/condition-generated

cd /path/to/buster
python3 /path/to/buster-performance/docs/measurements/tests-holes-2850-2026-11-21/sweep/extract.py \
    /tmp/condition-inline src/buster/compiler/*_test.c
python3 /path/to/sweep.py /path/to/buster /path/to/buster/build/compiler /tmp/condition-inline /tmp/condition-sweep
```

`qualify.py` runs the lane options and invokes Clang to compile and link its reference and its native-object drivers. `COND_TEST_SERIAL=1` selects the one-lane part of the matrix. `generator.py` uses two worker processes and `sweep.py` uses two worker threads.

For per-unit corpus counts, pass `corpus-units.py COMPILER OUTPUT_JSONL default|wall`, followed by the frozen corpus's preprocessing options and translation-unit paths. It invokes each unit separately with one lane and compares the complete diagnostics, stdout and status. The historical generator file is Git blob `8a6a3f73f29f1783b36eee3aaad66a8093916ffc`.
