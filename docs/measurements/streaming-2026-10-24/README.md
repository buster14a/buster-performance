# Streaming the output (#88), 2026-10-24

The 9700X's validation and measurements of `streaming.c`, Buster's experiment
on writing an executable while Tier 0 compiles it, in the data-first order,
with the code generator's unwind tables and DWARF, against writing it at the
end and against the direct path (#88, linker plan step 9). The linker design's
"Streaming, as built" and "Incremental output" (#89's decision) cite this
record. Three trees were measured as the experiment grew; the last is the one
the design's numbers come from.

| Directory | Tree | The DWARF |
| --- | --- | --- |
| [units/](units/) | `6033189` | a unit per 256 functions, made and finalized as they compile |
| [dwarf-at-end/](dwarf-at-end/) | `4582bb7` | one unit, made with the tail |
| [no-dwarf/](no-dwarf/) | `462845d` | none |

The trees are #88's branch before its rebase onto main after #380 merged, on
#86's `b3c7bf1`; each directory's `source.sha256` is the SHA-256 of each file of
its `git archive` (units: SHA-256
`6f797d6c94a7c0e35e30e9f3b251f6943112f7bc1b251b221442ae92712970f1`,
dwarf-at-end `16603dc10faf840c1d5df53bb7ec9ccfbcd5a0beacb34472fac2f208547319a0`,
no-dwarf `99491905ae69b2e112d96c76979a8cab0aab622d1354dca1f5416635c35fa615`).
The units tree's `build/compiler` SHA-256:
`f55f67ea2c9bc361b54e5a69bfe734f9371135a49fdfed32a2c7ea45dbab02e2`; the other
trees' binaries were overwritten before their hashes were taken.

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, GDB, perf and
llvm-dwarfdump 23.1.1, output on tmpfs (`/tmp`). Each step took the shared lock
on its own, through `~/buster-fast-bench/exclusive.sh` with
`EXCLUSIVE_OWNER=claude-linker-80` and
`EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/88`, CI first. The
lock's waiting messages, which name other runs, are removed from the logs;
nothing else in them is changed. Each directory's script ran it.

## Validation

- `units/test.log`: `test-streaming --cross-check`, 172 checks, 0 failed: the
  schedules' files byte for byte alike with one build ID; every file, and the
  direct path's on 1 and 3 lanes, running and printing what Tier 0's tests'
  interpreter computes; `readelf -a` without warnings; `llvm-dwarfdump --verify`
  on the DWARF's units; gdb stopping in the program's functions, unwinding to
  `_start` by their FDEs and giving each frame its function's line; perf's
  DWARF call graphs reaching `_start`, with the lines.
- `units/test-debug.log`: `test-debug --cross-check`, the debug unit written
  after others (`DebugOutput.bases`) among its checks, with gdb and perf on both
  GNU ld's and Buster's outputs.

## Measurements

`benchmark-streaming --units 3200 --runs 11 --lanes 8`: 3,200 units of 32
functions (102,400 functions, 13.1 million typed entries, 15.2 million
records), 59.5 MB of code; each variant timed 11 times in an order that rotates
by run, medians. `bench-1-callees.log` (callees first, `taskset -c 2`) gives the
design's table:

| Variant | Whole | Compiling | Link | After |
| --- | ---: | ---: | ---: | ---: |
| At the end | 369.979 | 351.177 | | 18.877 |
| Streamed | 370.047 | 365.067 | | 5.006 |
| Direct path, 1 lane | 390.641 | 349.550 | 20.752 | 20.417 |

`bench-2-callees.log` (CPUs 2 and 3) times the writer lane: 377.048 ms whole,
371.771 compiling, 5.211 after. `bench-8.log` (CPUs 0 to 7) the direct path on
eight lanes: 382.916 ms whole, 20.704 for its Link and 12.124 for its write.
`bench-1-callers.log` compiles callers first: 399.939 ms whole streamed, 5.097
after (at the end: 18.613 after). With `taskset -c 2` alone, the writer lane and
the direct path's eight lanes shared CPU 2: those rows of `bench-1-*.log` measure
that sharing, not the variants.

The earlier trees, the same command: at the end and streamed, the time after
the last function was 14.430 and 2.958 ms without DWARF (`no-dwarf/`), and
20.336 and 9.198 with the DWARF made with the tail (`dwarf-at-end/`).

## Limitations

The program is generated (Tier 0's generator, not a C front end's output), the
DWARF a line per function (6 MB here), not a `-g` build's. Medians of runs from
one machine and one session, each run including its file's open and close;
`benchmark-streaming` overwrites its outputs in place.
