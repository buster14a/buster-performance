# Reachable machine intervals for Tier 1 debug events

[PR #3135](https://github.com/buster14a/buster/pull/3135) at `a8ce751149fcc6e7f427d01a329ca4a5ce95276c` was compared with [#3133](https://github.com/buster14a/buster/pull/3133) at `27e6e86d68dabf69e3e48518967323e8b64bc521`.

A Tier 1 source region whose machine interval is empty cannot publish a local value at any record. Omit its start and end from the debug proof's event list. Consecutive reachable intervals still share the boundary for the same local. A different local at that source entry keeps its own event.

SQLite's debug build produced 68,130 regions of which 48,832 had a machine interval. The event count fell from 117,495 to 86,668. The Lua VM went from 5,862 events to 4,716. In eight interleaved Ryzen 9 7940HS pairs the final compiler retired 2.473% fewer instructions compiling the Lua VM with debug info and 0.327% fewer on SQLite at both optimization levels. Cycle results varied across pairs. The SQLite release control had the same instruction count within 0.001%. Ryzen 7 9700X confirmation remains open.

All 1,336 frozen musl debug objects and all 70 Lua and SQLite objects matched the parent byte for byte. Both linked Lua executables and ten script outputs matched. The debugger and LLVM cross-check passed 4,067 assertions, including empty windows between viable windows, a shared endpoint for different locals, and entirely empty machine coverage.

Part of #2542, stacked on #3133.

The [per-process counters](compiler-processes.tsv) include a warm-up and eight alternating pairs. The [paired medians](paired.txt) use the per-pair percentages. The [corpus object hashes](musl-debug-objects.tsv.gz), [application hashes](applications.tsv), and [debugger transcript](debugger.txt) come from the final release build. The [census](counts.tsv) came from a separately instrumented compiler which produced identical SQLite, lvm and lparser objects. The per-function tables put the five census columns after their leading `events` tag.
