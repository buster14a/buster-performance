# Reproducing the active-source experiments

Use an unmodified checkout of Buster revision `0e1d5b825801135bf50e79da9d546bc95209ab30` for the eager control. Every patch in [revisions.tsv](../source/revisions.tsv) is the complete change against that revision. Apply one patch per independent checkout with `git apply`. The recorded native host is a Ryzen 7 9700X, running the project’s pinned Clang 23.1.4 on Linux. Use that target's exclusive hardware lease and CPU 2 for comparable measurement.

With `study` set to this evidence packet’s absolute directory and `frozen` set to the SQLite corpus directory, run from each checkout root. The SQLite amalgamation must have SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.

```bash
clang -O3 -gline-tables-only -fno-omit-frame-pointer -std=gnu17 \
  -fwrapv -funsigned-char -march=native -Isrc -Isrc/buster/compiler \
  "$study/reproduce/fresh.c" -o /tmp/buster-fresh-pp
args=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
      -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$frozen" "$frozen/sqlite3.c")
PP_PRINT=/tmp/buster-fresh.i /tmp/buster-fresh-pp "${args[@]}"
sha256sum /tmp/buster-fresh.i
taskset -c 2 /tmp/buster-fresh-pp "${args[@]}"
```

The first stdout field is elapsed nanoseconds during initialization, source loading and preprocessing. The remaining fields are final token count, input token count, intern table count, macro-history count and history-run count. Each observation starts a new process with empty compiler tables. File pages may remain in the OS cache. Omit `PP_PRINT` for timing. Set `PP_RECORD_HISTORY=1` to request materialized macro history, or `PP_STAGE_TIMING=1` to enable the preprocessor's internal instrumentation. The ordinary stage measurement leaves both variables unset.

To reproduce the normalized binary oracle, build [rows.c](rows.c) in place of `fresh.c` and set `PP_ROWS=/tmp/variant.rows`. Run the two native binaries from the same corpus path so that absolute file ranges have identical layout. [origin-diff.py](origin-diff.py) explains differences by output row and field. For a printed compiler transcript, use the built ordinary compiler’s `-E -P` mode. [native-oracles.sh](native-oracles.sh) contains the feature, warning, link and runtime comparison, and [native-corpora.sh](native-corpora.sh) controls the remaining ordinary object manifests.

The paired timing and capture scripts use the frozen corpus manifest, machine lock and recorded directory layout of the benchmark host. Their raw output is under `measurements/`. To reannotate the pinned pair, unpack both [profile binaries](../measurements/paired-profile-binaries.tar.gz), register them with `perf buildid-cache -a`, then run `perf report` on the matching [raw profile](../measurements/active-paired-profile.tar.gz).
