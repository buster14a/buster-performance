# sqlite3.c's compile time against tcc on the 9700X (#518)

Raw evidence for buster's [`docs/compile-time.md`](https://github.com/buster14a/buster/blob/main/docs/compile-time.md)
(buster14a/buster#518, PR #520): the C driver's `-c` of SQLite 3.53.2's
`sqlite3.c`, as whole processes against tcc's, with `--time-stages`' report of
which stages take the time, and perf's counters and profile.

## Identity

- **Job:** [run 40421327819, job 121916266526](https://github.com/buster14a/buster/actions/runs/40421327819/job/121916266526).
- **Step:** "Attribute sqlite3.c's compile time to the compiler's stages, against tcc".
- **Date:** 2026-10-27; the job ran from 00:36:16 UTC, and the step from 00:42:27.
- **Revision:** PR #520's head `1677a3bbd9522f0bd5af22dd0b2ba131243b70d2`,
  which the job merged into main `6b2c92268802e72d76cdcd06e21e80a2bef90e22` as
  `9d39b4910f0d77ca55115f4367fec6f011f65568`.
- **Host:** runner `buster-zen5-9700x` (machine `benchpress`), an AMD Ryzen 7
  9700X, under the host's lock.
- **Compiler:** built by the job with
  `BUSTER_DEBUG_INFO=0 taskset -c 0-7 ./build.sh` (clang 23.1.1, `-O3 -march=native`).
- **Source:** `sqlite/sqlite3.c` of the frozen corpus
  `preprocessor-391e729af658`, sha256
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, checked by
  the step.
- **Reference:** `/usr/bin/tcc`, version 0.9.28rc 2026-01-17 (makepkg@b39cbc70),
  sha256 `49e2d1afd09cdab6593ca127b056ccc35fc5f3a2d0e08dae67f604db2751c082`.

## Commands

The options, for both compilers:

```sh
-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c"
```

These are #136's speedtest1 record's options (`speedtest1-136-2026-10-26`).

Each command was pinned to CPU 2:
- `measure-compile --runs 11 --reference /usr/bin/tcc`. After a warm-up, it
  rotates the default compile, `--time-stages` and tcc for 11 rounds. Each
  round's two objects must be the same bytes.
- `perf stat -r 11 -e task-clock,page-faults,cycles:u,instructions:u,cycles:k,instructions:k,branch-misses:u`
  of each compiler.
- `perf record -q -F 20000` of 5 default compiles, reported by DSO
  (`--percent-limit 0.5`) and by symbol (`--percent-limit 0.4`, the first 80 rows).

## Files

- `step.log` holds the step's lines of the job's log, with their timestamps:
  - its script;
  - every run's wall, user and system time, peak RSS and faults;
  - the medians;
  - the stage table, with each stage's system time, faults and peak RSS added;
  - both `perf stat` blocks;
  - the profiles.
- `job.log` is the job's whole log as GitHub served it: the host's checks,
  the checkout, the build, the tests and the other benchmarks.
- `SHA256SUMS` holds the files' hashes.

## Results

All figures are medians of 11 runs.

- `-c` takes 189.596 ms against tcc's 42.723 ms, 4.44 times as long.
- `--time-stages` costs 0.196 ms.
- `check-input` takes 81.169 ms, 42.9% of the clock's span.
- Peak RSS is 727,784 KB against tcc's 13,308 KB.

The attribution and the ranked bottlenecks are in buster's
`docs/compile-time.md`.

## Limitations

- The caches were warm: every run follows a warm-up.
- The step's script at this revision fell back to the stage report alone when
  perf couldn't count. Here perf counted every event.
- This is evidence for this source, workload, toolchain and machine only.
