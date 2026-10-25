# Foreign DWARF through `link-foreign` (#395), 2026-10-25

The 9700X's validation and measurements of
[buster14a/buster#395](https://github.com/buster14a/buster/issues/395)'s parts 2
and 3: several `debug.c` units through `executable_write`, and other compilers'
DWARF kept by `link-foreign` (`foreign_debug.c`, with zlib-compressed sections
decompressed by `inflate.c`). The driver's contract ("Debug information") and
the linker design ("Foreign executables, as built" and "SIMD: what pays") cite
this record.

| Tree | Commit | What it is |
| --- | --- | --- |
| `tree395` | `a29db0f` | the branch with main merged (after #405), before the work measured here |
| `tree395m` | `e2555ea` | the decoder's fast loop and vector Adler-32, and the first vector relocation pass (four gathers per batch) |
| `tree395t` | `ba28405` | the relocation pass on a table of each object's symbols (one gather per batch) |

Each tree is its commit's `git archive`; `source-*.sha256` is the SHA-256 of
each of its 567 files, which match the archives of those commits byte for
byte. The `build/compiler` SHA-256s are in `step-e2555ea/compiler.sha256` and
`final-ba28405/compiler.sha256` (each with `tree395`'s).

Host (`host.txt`): AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, GCC
16.2.1, lld 23.1.1, mold 3.0.0, CPU 2 at the performance governor, outputs on
the work directory's btrfs. Each step took the shared lock on its own, through
`~/buster-fast-bench/exclusive.sh` with `EXCLUSIVE_OWNER=claude-linker-80` and
`EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/395`. The lock's
waiting messages, which name other runs, are removed from the logs; nothing
else in them is changed. `step-e2555ea/phase395m.sh` and
`final-ba28405/phase395t.sh` ran the steps.

## Inputs and method

SQLite 3.53.4's shell (`sqlite3.c` and `shell.c`) compiled by GCC 16 at `-O2 -g`,
whose GNU as compresses the debug sections with zlib by default, and again with
`-g -gz=none` (`step-e2555ea/phase395m.sh` compiles them). `measure395.sh` links
each as a PIE with GCC's driver's line (`Scrt1.o`, `crti.o`, `crtbeginS.o`, the
two objects, `-lm`, libgcc, libc, `crtendS.o`, `crtn.o`), 21 interleaved runs of
each tree's `link-foreign --time` by the vector path, the exact path
(`--scalar`) and `-S` (no DWARF), pinned to CPU 2, and reports the medians of
the whole link, the conversion and its `debug` phase (the DWARF's build: the
contributions copied or decompressed, and the relocations applied). Then lld
(`--threads=1` pinned to CPU 2, and `--threads=8`) and mold (`--thread-count=1`
pinned, and 8) link the same line with GCC's driver's options, 11 runs each,
wall time from spawn to exit. Every output runs.

## Results

Medians in milliseconds (`final-ba28405/measure.log`; `old` is `tree395`, `new`
`tree395t`):

| Inputs | Tree, path | Link | Convert | `debug` |
| --- | --- | ---: | ---: | ---: |
| zlib-compressed | old, vector | 12.03 | 10.10 | 9.68 |
| | old, exact | 13.15 | 10.56 | 9.61 |
| | new, vector | **9.20** | 7.29 | **6.84** |
| | new, exact | 10.74 | 8.16 | 7.23 |
| | new, `-S` | 1.76 | 0.41 | |
| uncompressed | old, vector | 3.96 | 1.95 | 1.51 |
| | old, exact | 5.12 | 2.43 | 1.47 |
| | new, vector | **3.38** | 1.40 | **0.96** |
| | new, exact | 4.97 | 2.32 | 1.40 |

| Inputs | lld, 1 thread | lld, 8 | mold, 1 | mold, 8 |
| --- | ---: | ---: | ---: | ---: |
| zlib-compressed | 29.27 | 14.98 | 25.81 | 16.42 |
| uncompressed | 18.23 | 11.77 | 14.67 | 13.06 |

- The decoder: from compressed sections, the `debug` phase takes 6.84 ms
  against 9.68 before, most of it decompressing about 5 MB of DWARF (from
  uncompressed sections the phase takes 0.96 ms). `step-e2555ea/measure.log`
  isolates it: 9.70 to 7.27 ms with the old relocation pass's twin beside it.
- The relocations: on uncompressed sections, where they are most of the phase,
  the vector path takes 0.96 ms against the exact path's 1.40 (both with the
  new decoder). With four gathers per batch (`step-e2555ea`) it took 1.30
  against 1.41.
- The whole link: on one lane, 9.20 ms with compressed DWARF, against lld's
  29.27 on one thread and 14.98 on eight and mold's 25.81 and 16.42.

## Validation

`final-ba28405/`: the build; `check-call-graph`; `test-inflate`;
`test-debug --cross-check` (GDB and perf on one unit and on two, for GNU ld's
output and the native writer's); `test-executable`;
`test-streaming --cross-check`; `test-foreign --cross-check` (the foreign
DWARF section's 809 checks, the relocation kernels' twins among them, and lld,
`llvm-dwarfdump --verify` and gdb); and `test-foreign-corpus` with SQLite, Lua
and this repository's compiler, every kind against lld and mold: 843 checks, 0
failures. Every test log reports 0 failures, and the call graph has no cycle
outside its three allowed ones.

## Limitations

One input program (SQLite's shell, two objects, so at most a few streams per
lane), one machine and one session; the lld and mold times are single fresh
processes per run, with their own setup. The `debug` phase is `link-foreign`'s
own report. String merging, which lld does, is not done, so the outputs'
`.debug_str` and `.debug_line_str` are larger than lld's.
