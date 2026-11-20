<!-- buster#2546's body as the session read it on 2026-11-20 at 13:04 UTC (issue last updated 13:03:51 UTC), kept so that the record's README can cite the issue's 9700X figures. Its numbers come from ../whole-build-672-2026-11-12. -->

Found while measuring what every command pays for #672's whole builds ([the record](https://github.com/buster14a/buster-performance/tree/c8aeb9c568ffb7398d80da593774de638485b4d8/docs/measurements/whole-build-672-2026-11-12), sections 3 and 5). A dynamic hello world from source is 1.57 ms on the 9700X and its link 0.11 ms of that; a static one is 2.35 ms and its link 0.98 ms, so it would build 1.7 times faster with a free link. The same link in a process that has done it before takes 0.29 ms, which is the figure the linker's design and its benchmarks know.

## What it costs

The 9700X at main `4c8c3c9c`, CPU 2, under the lock. `compiler hello.c -o hello` and `compiler -static hello.c -o hello-static` (`hello.c` includes `stdio.h` and calls `printf`; the static executable is 740,168 bytes), 31 runs of each as whole processes and 11 with `--time-stages` (`tables/fixed.tsv`, `tables/clocks/clocks-1/ts-hello-dyn.tsv`, `ts-hello-static.tsv`); and `benchmark-link --only direct --kinds dynamic,static --cpus 2`, twice (`raw/linkbench/`), whose smallest program is that shape (1 worker in 4 units: 741,600 bytes written, 12,058 fixups), linked again and again in one process:

| | dynamic | static | static, warm in one process (`benchmark-link`) |
| --- | ---: | ---: | ---: |
| the whole process, ms | 1.572 | 2.350 | |
| user, kernel cycles, M | 4.09, 3.43 | 6.97, 4.81 | |
| user instructions, M | 8.64 | 15.23 | |
| page faults | 627 | 744 | |
| peak resident, MB | 25.6 | 33.7 | |
| `runtime` (the snapshot's open), ms | 0.061 | 0.113 | 0.025 (`open`) |
| `executable` (the binding, `link_check`), ms | 0.010 | 0.620 | 0.136 (`begin`, `end`) |
| `write`, ms | 0.041 | 0.244 | 0.134 |
| the link, ms | 0.112 | 0.977 | 0.294 |

- **`executable` is 0.62 ms where the same binding warm is 0.14**, and where `docs/object-writer-and-linker.md` ("The runtime snapshot") has 221 µs for a binding against a runtime loaded afresh in a harness. In a fresh process the stage takes 103 page faults and the resident set grows 6.5 MB in it (the stage clock's own columns, `raw/clocks-1/*-ts-hello-static-*.err`), for a program that keeps 0.74 MB of the runtime; `benchmark-link` reports 25 to 48 faults and 3.1 to 3.2 MB more resident a warm link. The clock doesn't say whose pages they are: the 8.7 MB snapshot's mapping, faulted in around each first touch, or the binding's own arenas.
- **The static link's 0.78 ms over the dynamic one** are 1.38 M kernel cycles (0.25 ms: 117 more faults) and 2.88 M user cycles for 6.6 M more instructions, 2.3 instructions a cycle.
- **The first static link of a compiler pays 3.8 ms more**, once, to import the libraries and write the snapshot (`tables/cold.tsv`). That is not this.

## Direction

For whoever owns the snapshot and the binding (`snapshot.c`, `bind.c`, the design's "The runtime snapshot"): the design's measurements of loading and binding are of one process that does them repeatedly, cold only in that its L3 was evicted (449 µs for a load, a binding and a release); a compile is a process that does them once. What to measure there, none of it measured here:

- **whose the 103 faults and 6.5 MB are**, by the stage's counters in a fresh process (page faults by address, or `perf` over `--time-stages`' `executable`);
- **if the snapshot's**: the pieces' records are read in place and never written, so that part of the file can be a read-only mapping, which `MAP_POPULATE` fills from the page cache without the copies the design measured for the writable private one (750 µs), or one `madvise(MADV_POPULATE_READ)` over what a link is about to read; and what a hello world's binding reads of the 447 pieces it joins, against where those bytes are in the file;
- **if the arenas'**: what the binding of a small program commits before it knows the program's size.

`benchmark-link` and `benchmark-snapshot` link warm; a whole-process line (the record's `fixed` list is one) is what would show a change.

Done when `-static hello.c` in a fresh process links in about what `benchmark-link` reports for that shape, and the record's `fixed` list on the 9700X shows it.

Discovery and reporting only; not claimed. Part of #672.

---
Agent session: [private session](https://claude.ai/code/session_01EgbxnfFPBGjgSsBZ6qE3Fy)
Model: Anthropic / claude-fable-5-2
