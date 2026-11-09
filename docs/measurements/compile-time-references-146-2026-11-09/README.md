# sqlite3.c's compile time against tcc, clang -O0 and gcc -O0 on the 9700X (#146)

Raw evidence for buster's [`docs/compile-time.md`](https://github.com/buster14a/buster/blob/main/docs/compile-time.md),
section "Against tcc, clang -O0 and gcc -O0, per token (#146)"
([buster14a/buster#146](https://github.com/buster14a/buster/issues/146)): the C driver's `-c` of SQLite 3.53.2's
`sqlite3.c`, as whole processes interleaved with tcc's, clang's and gcc's, with `--time-stages`' report of which
stages take the time and their cycles per preprocessed token.

## Identity

- **Date:** 2026-11-09, by an agent session (Claude Code) under `~/buster-fast-bench/exclusive.sh`, the lock held
  per run (the build, then the measurement).
- **Revision:** buster `85680a8410773e39b3324c7272cebdd63f1a83a0`, branch `measure/146-compile-references`
  (main `cb608c1f` and the branch's two commits: `measure-compile`'s several references and the token count).
- **Host:** `benchpress`, AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, governor `performance`, boost on,
  `perf_event_paranoid` -1.
- **Compiler:** built with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh` (clang 23.1.1), `build.sh` here.
- **Source:** `sqlite/sqlite3.c` of the frozen corpus `preprocessor-391e729af658`, sha256
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, checked by the script.
- **References** (`provenance.txt` has their hashes):
  - `/usr/bin/tcc`: tcc 0.9.28rc 2026-01-17 (makepkg@b39cbc70), sha256 `49e2d1af...`, the CI step's pin;
  - `/usr/bin/clang` (`clang-23`): Arch's clang 23.1.1-1, sha256 `939a8825...`;
  - `/usr/bin/gcc`: Arch's gcc 16.2.1+r23+gd564253eb6c8-1 (`gcc (GCC) 16.2.1 20260810`), with its `cc1` and GNU
    as 2.47, whose hashes are recorded too.

## Commands

`measure.sh` here, pinned to CPU 2:

```sh
measure-compile --runs 21 --warmups 2 --reference /usr/bin/tcc --reference /usr/bin/clang --reference-option -O0 \
    --reference /usr/bin/gcc --reference-option -O0 \
    -- -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c"
```

The options are the 9700X job's compile-time step's (#518), the same for every compiler: buster's default
configuration, and the system's glibc headers for each. After two warm-ups in order, 21 rounds rotate the default
compile, `--time-stages`, tcc, clang and gcc in a Williams design's order. Each process's wall time runs from its
release to `wait4`; its user cycles and instructions are perf counters inherited by its children (gcc's `cc1` and
`as`), and `wait4`'s rusage covers those children too.

## Files

- `measure-compile.txt`: the whole output: every run, the medians, the per-token table and the stage table.
- `provenance.txt`: revision, host, every executable's version and sha256, the options.
- `build.sh`, `measure.sh`: the scripts that ran on benchpress.
- `SHA256SUMS`.
