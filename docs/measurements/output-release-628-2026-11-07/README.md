# The preprocessor's output before the backend (buster#628), 2026-11-07

This record holds the evidence for buster's pull request from `claude/practical-tesla-2lgodi` that gives the
preprocessor's output back before the backend (`pp_release_output`, `pp_output_ensure`):
- the VM's map of `-c sqlite3.c`'s stages after `rare-marks-628-2026-11-07`'s change, which put the compile's peak at
  the backend's end (`map/`);
- the runs that made regions unreadable before the backend, to find what it reads (`map/unreadable-*.log`);
- the 9700X's per-process A/B of the change against main (`run/`).

## Sources

| tree | commit | what |
| --- | --- | --- |
| `main7` | [`73fcf006`](https://github.com/buster14a/buster/tree/73fcf006db22f7e10acfe315f85e379b77eff875) | main |
| `pr5` | `22c7647fde05dd0151e3fe343323bc2ee8bb5a74` | the change, on `main7` (`patches/pr5`) |
| the map's build | [`6b4e178f`](https://github.com/buster14a/buster/tree/6b4e178f897c218ed9efc066cdfb8705aabbce08) with `map/instrumentation.patch` | main, instrumented |

`pr5` reached the host as a git bundle. The pull request's commit is `pr5`'s with the measured numbers in
`docs/compile-time.md`; its source files are `pr5`'s.

`map/instrumentation.patch` logs every arena push of 32 KiB or more with its callers (`lane.c`), prints the resident and
high-water memory at each stage's mark and, at a chosen one (`BUSTER_PEAK_FULL`), every push with pages still resident,
each page counted once for the latest push over it (`peak_dump`). It also has the two experiments below: `BUSTER_POISON`
makes the preprocessor's output (`pp`) or the parser's column arenas (`parse`, or one by its index) unreadable before
the selection, with a handler that prints the faulting access's backtrace; `BUSTER_RELEASE_PP` releases the output there.
`map/compiler.sha256` is the instrumented executable's.

`run/receipts16.txt` has the 9700X's host, kernel, CPU 2's governor and EPP, the transparent huge pages' setting,
clang's and perf's versions, both executables' SHA-256 and the input's: the frozen corpus's `sqlite3.c`, SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with the `compile_time` step's options.

## The map (VM)

`-c sqlite3.c` with the step's options, `BUSTER_HUGE_PAGES=1` and `--time-stages`, pinned to one CPU (`taskset -c 0`) as
the 9700X's runs are. Unpinned, the VM's four CPUs gave four lanes, whose arenas added 28.7 MB at the backend's `lanes`
stage (`map/stages-rss-4-lanes.txt`, `map/time-stages-4-lanes.txt`). With one lane (`map/stages-rss-1-lane.txt`), the
resident memory at the stages' ends:

| stage's end | resident (KiB) |
| --- | ---: |
| `parse` | 116,500 |
| the reader | 240,196 |
| `check-input`, after the reader's release | 227,252 |
| `check-expressions` | 235,276 |
| `check-declarations` | 237,452 |
| `static-data` | 237,516 |
| `check-program` | 233,552 |
| `lower` | 249,840 |
| `emit-setup`, the peak | 251,888 |

`map/peak-pushes.txt` is the dump at that peak, and `map/peak-pushes-attributed.txt` groups it by mapping and caller
(`map/attribute.py`). Of 210,424 KiB in 267 pushes:

| first caller | KiB |
| --- | ---: |
| `check_graph_initialize` (the checker's graph) | 34,252 |
| `check_driver_unit` (`check_program`'s, inlined) | 30,860 |
| `check_graph_run` | 29,584 |
| `check_input_run` (the reader's output) | 24,632 |
| `parse_columns` (the parser's token and tree columns) | 15,984 |
| `check_program_emit_timed` | 12,816 |
| `pp_tokens_reserve` (the preprocessor's output) | 12,544 |

## What the backend reads (VM)

Each region was made unreadable after the checker's program and warnings, before the selection
(`map/unreadable-*.log`, each with its faulting access's callers):

| unreadable | default options | `-g` | `-Wall -Wextra` |
| --- | --- | --- | --- |
| the preprocessor's output | completes | `pp_expansion_location` from `check_debug_lines` | completes |
| the parser's arenas | `check_program_select_mode` (the tree's parents) | the same | the same |
| the parser's token columns | `check_lower_prepare` | the same | the same |

So nothing reads the output in the backend but `-g`'s line table, and the diagnostics, which none of these compiles
gave. Released there (`BUSTER_RELEASE_PP`), the VM's peak was 251,868 KiB without and 240,200 KiB with it, the object
the same bytes.

## The 9700X's A/B

`chain16.sh`: each tree built with `BUSTER_HOST_ARCH=znver5` under one hold of the lock (`run/builds/`), then
`ab-grants.sh`, with one grant of the lock per measured compiler process, `taskset -c 2 perf stat` of each compile with
`--time-stages`, the order alternating by round: 9 rounds with the step's options (`run/ab16/`) and 5 with `-w`
(`run/ab16w/`). Then both trees compiled in six modes (the step's options, `-Wall -Wextra`, `--scalar -Wall -Wextra`,
`--lanes 8`, `--lanes 8 --deferred-bodies` and `-g`) and compared their objects and diagnostics, leaving out
`exclusive.sh`'s notices (`run/objects16/`, `run/objects16.log`). Every run completed under its own grant, and every
object and diagnostic is the same bytes. Medians:

| measure | main | the change |
| --- | ---: | ---: |
| peak RSS, the step's options | 248,644 KiB | 239,824 KiB |
| task clock | 120.46 ms | 120.49 ms |
| user cycles | 581.98 M | 581.99 M |
| kernel cycles | 84.97 M | 84.97 M |
| page faults | 6,656 | 6,655 |
| peak RSS, `-w` | 248,640 KiB | 239,816 KiB |
| task clock, `-w` | 105.19 ms | 105.10 ms |
| kernel cycles, `-w` | 84.15 M | 84.26 M |

The peak falls 8,820 KiB, to the reader's end. The kernel's cycles and the user cycles are the same. The task clock's
medians differ by 0.03 ms: the change is slower in 6 of the 9 rounds, by 0.03 to 0.73 ms, and faster in 3, by 0.05 to
0.28 ms (its mean is 0.21 ms more); with `-w` it is faster in 3 of the 5, and its median 0.09 ms less. The release gives
the output's pages back earlier than the exit would, and the backend faults in nothing it wouldn't have. A first chain on `fc0d9749`, which
refused an undefined reference of a link of several units, was stopped while it built; it measured nothing.
