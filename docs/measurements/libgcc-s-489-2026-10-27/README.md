# libgcc_s.so.1 as needed in the direct path's dynamic links: the 9700X A/B for #489

2026-10-27. Paired measurements of
[buster14a/buster#511](https://github.com/buster14a/buster/pull/511), which
adds `libgcc_s.so.1` to the direct path's dynamic runtimes as GCC's driver
names it, as needed
([buster14a/buster#489](https://github.com/buster14a/buster/issues/489)),
against its merge base. #489's review asked for them, against
[#483's record](../libgcc-483-2026-10-26/README.md), with #483's harness:
the snapshot's size, `runtime_open`, binding and the direct link of
programs that don't import `libgcc_s.so.1`, and the C driver's hello world
with its memory. The same runs also give the cost to dynamic PIEs without TLS
accesses of #515's writer change
([buster14a/buster#521](https://github.com/buster14a/buster/pull/521),
merged into #511's branch). [#515's own record](../tls-relaxation-515-2026-10-27/README.md)
has the relaxation's cost per access.

## Revisions

- base: `e04462c12f1ce25c70e41e8aa4acf48f4d7c4004`, #511's merge base with
  main.
- first head: `e77913290d25356a026abe28ecc466b3094ec3f6`, #489's change
  alone (`e779132/`).
- final head: `8cca727b33f3e70a27786d4ac3c3dcff8281196d`, #511's head:
  #489's change, #521's merge (general- and local-dynamic TLS relaxed in a
  dynamic PIE, #515) and the fix from #511's review that keeps a dynamic
  PIE's calls of `__tls_get_addr` that no access makes (`8cca727/`).

`manifest-*.sha256` list every file of `build.sh`, `src` and `tests` of
`git archive` of each revision. The trees on the 9700X matched them byte for
byte (sorted with `LC_ALL=C`). The base tree was built once, and both pairs
ran that build.

## Host and inputs

AMD Ryzen 7 9700X (`benchpress`), Linux 6.18.50-2-lts, transparent huge
pages `always` (defrag `madvise`), the benchmarks' directories on btrfs.
clang 23.1.1 built each tree (`BUSTER_DEBUG_INFO=0 ./build.sh`, with wild as
the build's linker); `build/compiler`'s sha256:

- base `5da852db1ceb891a475a257abe94bd520f20c416b0d7f7f62b453b24130664a6`;
- first head `dbe5388f3fb30a83b4f2443cdf86b3cd34e117f508338b1cedaeda9e230d7392`;
- final head `6a90c9736f0911f9c7cdc8d42d4cfc382f7fb86daadbf2d9bd2c2b9eea6a4f15`.

GCC 16.2.1's `libgcc_s.so.1` (sha256 `e618cb9c...61c716a`) and `libgcc.a`
(`c70c9134...cde47d`, #483's), glibc 2.44's `libc.so.6` (`02c8c3d0...641524`,
#483's). perf 7.2.9.

## Commands

The harness is in `harness/`. Every build, benchmark and process run held
the shared lock alone (`~/buster-fast-bench/exclusive.sh`), one hold each, so
CI jobs and other sessions ran between them. Each pair ran three rounds in
the order base, head; head, base; base, head.

- `gs-ab.sh` (first pair) synced both trees with `git archive`, built each,
  then ran `gs-bench.sh` and `gs-proc.sh`:
  - `taskset -c 2 ./build/compiler benchmark-snapshot --only dynamic` (and
    `--only shared`) `--directory DIR`;
  - `./build/compiler benchmark-link --only direct --kinds dynamic,shared
    --directory DIR --cache DIR` (it pins its lane to CPU 2);
  - `taskset -c 2 ./build/compiler benchmark-bind --functions 1,2000`;
  - `XDG_CACHE_HOME=DIR taskset -c 2 ./build/compiler time-runs --runs 41
    --warmups 5 --list hello.c -o OUT`: the C driver compiling and linking a
    hello world, whole processes, each tree with its own snapshot cache.
- `gs-control.sh` (first pair, one round: its connection to the host dropped
  after the first, see "Limitations") ran the hello world under
  `perf stat -r 41 -e instructions:u,cycles:u,instructions:k,cycles:k,page-faults`
  and under `time-runs` with transparent huge pages disabled for the process
  and its children (`thp-off.c`: `PR_SET_THP_DISABLE`, then `execvp`).
- `gs2-remote.sh` (final pair), started on the host detached (`setsid
  nohup`), built the final head and ran `gs2-bench.sh`: every command above
  per round, plus `taskset -c 2 ./build/compiler benchmark-executable --only
  dynamic --directory DIR` (links without TLS accesses, written as dynamic
  PIEs) and the two controls.
- `gs-smaps.sh` and `gs-pagemap.sh` stopped the first pair's hello world at
  `exit_group` under gdb and saved its `/proc/PID/smaps` and the present
  pages of its `.bss` (`/proc/PID/pagemap`); `pagemap-regions.py` maps them to
  2 MB regions and the symbols in them, and `smaps-sum.py` sums the mappings.
- `arena-trace.py` is the temporary patch to `lane.c` with which the hello
  world printed each arena's growth past a 2 MB boundary (on a VM, not the
  9700X; it wasn't committed): the base and the first head printed the same.

`strip-lock.py` removed the lock's "waiting" messages from the logs (they
quote other sessions' and CI jobs' commands, titles and links); nothing else
was changed.

## Results, final pair (base `e04462c`, head `8cca727`)

Each figure is a round's median, rounds 1 / 2 / 3.

| | base | head |
|---|---|---|
| dynamic runtime's snapshot | 3,282,344 bytes, 20 probes, 3,387 global names | 3,286,696 bytes, 24 probes, 3,432 global names |
| shared library's runtime's snapshot | 3,280,832 bytes | 3,285,312 bytes |
| `runtime_open`, dynamic | 11.86 / 11.73 / 11.92 us | 12.57 / 12.66 / 12.72 us |
| of it, the probes' `stat`s | 4.63 / 4.60 / 4.60 us | 5.50 / 5.38 / 5.52 us |
| `runtime_open`, shared | 11.20 / 11.32 / 11.25 us | 12.05 / 12.09 / 12.01 us |
| binding one worker, freshly loaded | 4.51 / 4.68 / 4.55 us | 4.51 / 4.67 / 4.72 us |
| `bind_begin`, 1 worker, PIE | 0.31 / 0.30 / 0.31 us | 0.31 / 0.31 / 0.31 us |
| `bind_end`, 1 worker, PIE | 0.32 / 0.33 / 0.33 us, 7,233 instructions | 0.36 / 0.35 / 0.37 us, 9,152 instructions |
| `bind_end`, 1 worker, shared | 0.33 / 0.32 / 0.33 us | 0.35 / 0.36 / 0.36 us |
| `bind_end`, 2,000 workers, PIE | 0.81 / 0.82 / 0.82 us | 0.85 / 0.84 / 0.84 us |
| direct link, 1 worker, PIE | 21.3 / 21.1 / 21.2 us | 22.8 / 22.4 / 22.8* us |
| of it, `runtime_open` | 11.4 / 11.1 / 11.3 us | 12.6 / 12.1 / 12.5* us |
| direct link, 1 worker, shared | 76.7 / 56.4 / 61.4 us | 59.8 / 59.1 / 57.8* us |
| direct link, 2,000 workers, PIE | 140.1 / 139.8 / 140.9 us | 141.9 / 143.0 / 142.4* us |
| direct link, 102,400 workers, PIE | 11,283 / 11,228 / 11,359 us | 11,390 / 11,577 / 11,501* us |
| more resident, direct link, PIE: 1 / 2,000 / 102,400 workers; shared, 1 | 0.67-0.68 / 4.59 / 6.65 MB; 0.36 MB | the same; round 1, which wrote its snapshot: 0.63 / 2.46 / 4.55 MB, as the base's first round of the first pair |
| PIE write without TLS, 1 worker (`benchmark-executable`) | 8.5 / 8.8 / 8.7 us | 8.7 / 8.7 / 8.8 us |
| PIE write without TLS, 2,000 workers | 121.9 / 125.6 / 123.9 us | 122.5 / 123.0 / 124.4 us |
| PIE write without TLS, 180,000 workers | 13,845 / 14,052 / 16,826 us | 13,927 / 14,121 / 14,242 us |
| of it, the count | 1,513 / 1,517 / 1,929 us | 1,496 / 1,505 / 1,510 us |
| C driver, hello world | 2.393 / 2.403 / 2.393 ms | 2.471 / 2.474 / 2.500 ms |
| its peak resident set, minor faults | 31,484-31,496 KB, 569 | 33,544-33,560 KB, 571-572 |
| hello world, user instructions (`perf stat`) | 23,745,648-23,745,726 | 23,753,566-23,753,721 |
| user cycles | 7.70 / 7.70 / 7.71 M | 7.86 / 7.77 / 7.78 M |
| kernel cycles | 5.16 / 5.19 / 5.21 M | 5.75 / 5.58 / 5.55 M |
| hello world, huge pages disabled | 2.722 / 2.718 / 2.718 ms | 2.717 / 2.728 / 2.773 ms |
| its peak resident set, minor faults | 17,596-17,600 KB, 2,463-2,464 | 17,608-17,616 KB, 2,463-2,464 |

What a link that doesn't import `libgcc_s.so.1` pays, constant in its size:

- `runtime_open` 0.8 us more, nearly all of it the four new probes' `stat`s
  (the library in GCC's installation and in the library directories); the
  directory's hash of 4,352 more bytes is within the rounds' spread;
- `bind_end` 0.02 to 0.04 us more (1,919 instructions for one worker), the
  as-needed pass over a third library and the closure's `runtime_needed`;
- nothing in resident memory, and nothing in the write: a dynamic PIE without
  TLS accesses is written as before (the count, which #515's relaxation
  changed, is within the rounds' spread; base's third round at 180,000
  workers was slow in every phase).

The hello world took 0.08 to 0.10 ms more and 2 MB more peak memory with
huge pages. Without them (`thp-off`) its peak resident set is within 20 KB,
and its time within 0.01 ms in two rounds and 0.05 ms more in the third:
see "The hello world's huge page". Its user instructions grew by 7,900
(0.03%), and its user cycles by 0.8% to 2.1%, which the instructions don't
account for: the code moved too, as `.bss` did.

## The hello world's huge page

The extra 2 MB is one transparent huge page of `build/compiler`'s own
`.bss`, which is the same size in every build (`0xe6bed21` bytes). In the
first pair's process at `exit_group` (`layout/*-smaps-hello.txt`), the
anonymous mapping after the executable held 8,192 KB of huge pages in the
base and 10,240 KB in the first head, and every other mapping the same.
`layout/bss-regions.txt` lists the 2 MB regions of `.bss` with pages present
and the symbols in them: the head has one more, at `0x7e00000`.

The head's code is larger, which moves `.bss` up (by 122 KiB in the first
head, 139 KiB in the final one). `unwind.c`'s `unwind_indices`, 72 KB, which
`unwind_initialize` clears whole in every process that writes unwind tables
(the driver's links), lay inside one 2 MB region in the base and straddles
the boundary at `0x7e00000` in both heads (`layout/unwind-indices.txt`), so
its clear faults a second huge page, whose 2 MB the kernel clears: the
kernel cycles above. The arenas grew past the same 2 MB boundaries in both
builds (`arena-trace.py`).

So the cost follows the executable's layout, not the change: any change that
moves `.bss` by as much can add or remove it. Making it independent of the
layout would mean keeping such tables out of `.bss`'s huge pages (on an
arena's base pages, or aligned to a region of their own); that isn't part of
#511.

## Results, first pair (base `e04462c`, head `e779132`)

The same measurements of #489's change alone, rounds 1 / 2 / 3 (the
controls: round 1 only).

| | base | head |
|---|---|---|
| `runtime_open`, dynamic | 11.75 / 11.99 / 11.72 us | 12.65 / 12.69 / 12.76 us |
| `runtime_open`, shared | 11.35 / 11.18 / 11.31 us | 12.10 / 12.05 / 12.12 us |
| `bind_end`, 1 worker, PIE | 0.33 / 0.32 / 0.33 us | 0.38 / 0.38 / 0.38 us |
| direct link, 1 worker, PIE | 21.6 / 21.1 / 21.2 us | 22.9 / 22.3 / 22.1 us |
| direct link, 2,000 workers, PIE | 140.0 / 139.1 / 142.4 us | 144.5 / 142.1 / 144.7 us |
| C driver, hello world | 2.402 / 2.387 / 2.667 ms | 2.489 / 2.492 / 2.499 ms |
| its peak resident set | 31,476-31,492 KB | 33,612-33,624 KB |
| user instructions | 23,745,701 | 23,751,521 |
| hello world, huge pages disabled | 2.721 ms, 17,608 KB | 2.754 ms, 17,816 KB |

The base's third hello world round (2.667 ms) ran slower in every process
(2.435 to 3.015 ms) and is noise.

## Limitations

- The final head's third `benchmark-link` round failed before measuring:
  `benchmark-link: cc didn't build the harness that loads a shared library`
  (`8cca727/head/link-3.log`), and so did a rerun of it
  (`link-3-rerun.log`). A second rerun, about an hour after the round, measured
  (`link-3-rerun2.log`): the figures marked `*`. Between the reruns, `cc`
  built the same source from a shell on the host, and the benchmark with
  `--keep` in another directory built its harness and measured; why the
  harness's build failed twice wasn't found. It is the same in both trees
  (`link_benchmark.c` didn't change).
- The first pair's controls ran one round: the connection that ran
  `gs-control.sh` dropped (`tailscale ssh` exit 255) after it, and the final
  pair, started detached, repeated them three times.
- `gs-smaps.sh` and `gs-pagemap.sh` ran once per build, under gdb, after the
  measurements; their snapshots of memory are the process's at exit.
- `benchmark-snapshot`'s and `benchmark-link`'s programs reserve every
  member's room (`bind_capacity`), as #483's record notes.
