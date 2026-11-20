# A static hello world's link in a fresh process: whose page faults (buster#2546), 2026-11-20

The evidence for [buster#2546](https://github.com/buster14a/buster/issues/2546) ("a static hello world's link is
0.98 ms of its 2.35 ms build in a fresh process"): who takes the `executable` stage's page faults and resident
growth, what the link reads of the runtime snapshot, what populating pages costs, and a prototype that populates the
binding's fresh pages. The prototype is in [`patches/`](patches/). It is not proposed as a pull request, because it
can't move the issue's number on the 9700X (section 5).

## Who, where, what

- **Who.** Claude (Anthropic, `claude-opus-5-5`) in David's directed session
  [session_01NNmNQvmuGSny2j5d2tWFbo](https://claude.ai/code/session_01NNmNQvmuGSny2j5d2tWFbo), working the claim
  [#2546 (comment)](https://github.com/buster14a/buster/issues/2546#issuecomment-7040238039). The session's agents
  measured (an implementing agent, two reviewers and a fixing agent); another of its agents assembled this record.
- **Where.** A cloud VM: Intel Xeon @ 2.10 GHz (family 6, model 207), 4 vCPUs, 16 GB, Linux 6.18.44-fc-v726,
  transparent huge pages `madvise`, tmpfs huge pages `never`, the cache directory on ext4 ([`env.txt`](env.txt)).
  The VM was shared with other builds; its load average read between 1.5 and 12 at the 12 `uptime` lines of
  [`log/session-log.txt`](log/session-log.txt). All times are medians of fresh processes, most interleaved.
- **No 9700X run was made.** The issue's done-when is measured on the 9700X. There the arenas take huge pages (it
  is not a virtual machine and, under the lock, not busy: `arena_page_policy` in `lane.c`; the issue's 103 faults
  agree with this VM's emulation, 100). The prototype's second commit turns itself off where the arenas take huge
  pages, so the 9700X would bind as main does. In this VM's emulation of that configuration the prototype changed
  nothing (section 5). A run under the shared lock could only have shown that.
- **When.** 2026-11-20, 13:04 to 15:13 UTC.
- **What.** `compiler -static hello.c -o hello` ([`tools/hello.c`](tools/hello.c): `stdio.h` and a `printf`), with
  `--time-stages`, whose `executable` row is the binding and `link_check`, with its minor faults (getrusage) and the
  KB it added to the peak. Faults by address: `perf record -e page-faults -c 1 -d --call-graph dwarf,16384 -m 8192`
  and `perf script --show-mmap-events` (perf 6.8.12). The executables are builds of buster main
  `79f565efe` and of the prototype on it, Develop but for two Release ones ([`env.txt`](env.txt) lists each by
  sha256).
- **Two configurations.** *Base pages*: the VM's default; buster turns huge pages off for the whole process on a
  virtual machine (`arena_page_policy`), and the snapshot is in `~/.cache/buster` on ext4. *The 9700X's,
  emulated*: `BUSTER_HUGE_PAGES=1` (the arenas take huge pages past their first 64 KB, `BUSTER_ARENA_SMALL_BYTES`
  in `lane.c`) and `XDG_CACHE_HOME` on `/dev/shm` (tmpfs, so the snapshot is in base pages). The emulation reads
  100 faults and 6,280 KB where the issue read 103 and 6.5 MB on the 9700X ([`issue-2546.md`](issue-2546.md)).
- **The patches' base** is `875980f247e1ff0f8cf33537ab32efc3d82fca49`
  (`git -C <buster> merge-base HEAD origin/main` of the branch `claude/peaceful-brahmagupta-rk1esk-2546`). The
  measurements ran on builds of `79f565efe`. The 44 commits between them change none of `bind.c`, `lane.c`,
  `link.c`, `runtime.c`, `snapshot.c`, `executable*.c`, `c_checker_driver.c` and `c_check_program_emit.c`.

## 1. Base pages: the stage's 319 faults and 7,464 KB

The stage took 319 faults and added 7,464 KB to the peak, in 1.766 ms (median of 21, `base`, [I55]). A dynamic hello
world's took 3 faults, 68 KB and 0.020 ms ([I55]). By address (`c2546`, whose stage reads the same 319 and 7,464, [I12], [I13]):

| who | faults | KB more resident | evidence |
| --- | ---: | ---: | --- |
| the program's byte arena: the members' bytes the joins copy | 171 | 684 | [`faults/pfb-owners.tsv`](faults/pfb-owners.tsv), [`faults/pfb-stage.txt`](faults/pfb-stage.txt) |
| the link's columns and names (one arena, first faulted by `link_initialize`) | 123 | 492 | same |
| `Bind`'s arrays (first faulted by `bind_begin`) | 20 | 80 | same |
| **the binding's own writes to fresh anonymous pages** | **314** | **1,256** | |
| the runtime snapshot: 2 MB a fault, in 4 KB page-table entries (ext4's large folios) | 3 | 6,144 | same; [`smaps/smaps-diff.txt`](smaps/smaps-diff.txt) |
| the compiler's own image | 2 | 64 | same |
| **all** | **319** | **7,464** | |

- The faults are each window fault's mapping and its first faulting function
  ([`tools/pfowners.py`](tools/pfowners.py) over [`faults/pfb.txt.xz`](faults/pfb.txt.xz)). The window runs from
  the first fault under `bind_end` to the first under the write ([`tools/pfstage.py`](tools/pfstage.py)); it holds
  319 faults, the stage row's count.
- The KB are each mapping's resident growth across `bind_end`, read with gdb at its entry and return in another run
  of `c2546` ([`tools/smaps.gdb`](tools/smaps.gdb), [`smaps/`](smaps/)). The anonymous mappings are matched by size:
  +688 and −4 (the byte arena's 64 KB mapping, replaced as it grew), +492 and +80. The snapshot's mapping stays in
  4 KB entries (`KernelPageSize: 4 kB`, `FilePmdMapped: 0 kB` in `smaps-after.txt`). VmHWM grew from 16,544 to
  24,008 KB, the stage's 7,464.
- In time, over 40 compiles, the binding's and the link's functions took 22,493 user and 7,373 kernel samples
  ([`profiles/cpu-base.txt`](profiles/cpu-base.txt), by first user frame; the count also holds the checker's
  `check_input_bind_checked`, 984 and 931, which is not the stage's). Most user samples: `runtime_piece_hash` 7,275,
  `bind_join` 5,345, `link_check` 4,088 and `link_check_fixups` 1,347, `bind_merge` 1,415. Most kernel samples are
  under `bind_join` (4,245), led by fault handling: `exc_page_fault` 1,069, `memcg1_commit_charge` 528.

## 2. The 9700X's configuration, emulated: 100 faults and 6,280 KB

The stage took 100 faults and 6,280 KB: 1.179 ms (median of 61 interleaved, `base`, [I194]), 1.601 ms in another
series of 21 ([I122]). By address ([`faults/pfh-owners.tsv`](faults/pfh-owners.tsv), one run, [I121]):

| who | faults | evidence |
| --- | ---: | --- |
| the runtime snapshot: a fault-around each, from `runtime_piece_hash`'s first reads | 63 | [`faults/pfh-stage.txt`](faults/pfh-stage.txt), [`faults/pfh-windows.txt`](faults/pfh-windows.txt) |
| the byte arena: 15 base pages, and 1 fault in its huge-page part | 16 | [`faults/pfh-stage.txt`](faults/pfh-stage.txt) |
| the link's columns and names | 13 | [`faults/pfh-owners.tsv`](faults/pfh-owners.tsv) |
| `Bind`'s arrays | 6 | same |
| the compiler's own image | 2 | same |
| **all** | **100** | |

- Each of the 63 snapshot faults is in its own 64 KB window of the address space, and each such window holds pages
  the link reads (64 windows at this mapping's alignment; [`tools/pfwindows.py`](tools/pfwindows.py)). That is the
  kernel's fault-around: one fault maps a 64 KB window. 63 windows are 4,032 KB, one huge page 2,048 KB and
  34 base pages 136 KB: 6,216 KB, close to the 6,280 KB read. The stage's peak column is approximate
  (`peak-rss-precision approximate`, [`log/time-stages-example.txt`](log/time-stages-example.txt)).
- With the snapshot on ext4 the same stage took 36 faults (`main`, [`review/summary.txt`](review/summary.txt),
  `stage/hello-huge-pages`), as ext4 maps the snapshot 2 MB at a time. The issue's 103 faults on the 9700X match
  tmpfs's 100, not that.
- Timed inside the stage (proto2's timers, no knob, 21 rounds, [I119]): `bind_end` 1.188 ms, `link_check` 0.171 ms,
  the stage 1.428 ms. Reading every slice's 64-byte lines before the joins took 0.319 ms by itself and cut the
  joins from 0.978 to 0.813 ms (proto3, `PROTO_R`, 31 rounds, [I129]).

## 3. What the link reads of the snapshot

From a debug print of the slices `runtime_piece_hash` hashes, in a static hello world's link (`dbg`, [I98];
[`slices/slices.txt.xz`](slices/slices.txt.xz), [`slices/slices-summary.txt`](slices/slices-summary.txt)):

| | |
| --- | ---: |
| pieces | 429 |
| slices | 11,206 |
| bytes read | 1,258,066 (1,228.6 KB) |
| distinct 4 KB pages | 704 (2,816 KB) |
| distinct 64 KB windows, at file-offset alignment | 63 (4,032 KB) |
| runs of consecutive pages | 76 ([`micro/ranges.txt`](micro/ranges.txt)) |
| first and last page read | 219 and 1,893 ([I99]), in a file of 8,428,428 bytes ([I65]) |

So a link touches 704 pages to read 1.2 MB, spread over 1,675 pages (6.5 MiB) of the file. A piece has up to 26
slices; summed over the pieces, the last slice holds 696,521 bytes over 255 pages, and each other one 2 to 75,324
bytes ([`slices/slices-summary.txt`](slices/slices-summary.txt)).

## 4. Populating: it pays for fresh anonymous pages, not for the snapshot

Fresh processes, medians ([`micro/medians.txt`](micro/medians.txt), from [`micro/results.txt`](micro/results.txt);
sources [`micro/faults.c`](micro/faults.c), [`micro/pop.c`](micro/pop.c), [`micro/present.c`](micro/present.c)).
getrusage's faults count populated pages too.

| what | n | median | faults |
| --- | ---: | ---: | ---: |
| 1.3 MB of fresh anonymous memory, touched a page at a time | 3 | 561.9 µs (1.7 µs a page) | 328 |
| the same after one `MADV_POPULATE_WRITE` | 3 | 341.8 µs (1.0 µs a page) | 328 |
| `MADV_POPULATE_WRITE` over 1.3 MB already resident: one call; 32 calls | 5 | 25.8 µs; 33.5 µs | 0 |
| **the 704 pages a link reads (pop.c), tmpfs**: read a byte of each | 7 | 205.8 µs | 67 |
| `MADV_POPULATE_READ` of each of the 76 ranges first | 7 | 241.8 µs | 67 |
| one `MADV_POPULATE_READ` from the first range to the last | 7 | 398.1 µs | 108 |
| **the same, ext4**: read; per range; one span | 5 | 22.2; 45.5; 19.4 µs | 7 |
| **the snapshot from 3 MB to its end (faults.c), tmpfs**: read-write mapping, read | 5 | 311.3 µs | 85 |
| read-only mapping, read | 5 | 262.8 µs | 85 |
| read-only, `MAP_POPULATE` of the whole file | 5 | 354.0 µs | 133 |
| read-only, `MADV_POPULATE_READ` of the whole file | 5 | 273.6 µs | 133 |
| read-write, `MADV_POPULATE_READ` of the whole file | 5 | 457.7 µs | 133 |
| **the same, ext4**: read-write read; read-only read; `MAP_POPULATE` | 3 | 46.8; 36.2; 34.6 µs | 8; 8; 9 |

- Populating fresh anonymous pages saves about 0.7 µs a page in this VM.
- Populating the snapshot doesn't pay. On tmpfs, populating the exact ranges took longer than reading them, and the
  whole span or the whole file longer still (`MAP_POPULATE` 354.0 against 262.8 µs read). On ext4, which maps
  2 MB a fault, there is little to save (7 to 9 faults, 19 to 47 µs either way).
- The issue's first direction (a read-only mapping that `MAP_POPULATE` fills) is ruled out by these rows.
- Two snapshot prototypes didn't pay either: prefetching the next member's slices (`PROTO_F`: 1.557 against
  1.428 ms emulated, [I119]) and reading every slice first (`PROTO_R`, section 2). See
  [`prototypes/proto3.diff`](prototypes/proto3.diff).

## 5. The prototype: base pages gain, the 9700X's configuration doesn't

[`patches/`](patches/) holds the branch's two commits (`git format-patch origin/main..HEAD`), on `875980f`. The
first, `bind_populate`, faults in what the static members' joins are about to write, a `MADV_POPULATE_WRITE` call
per arena or column, once the closure knows the members. The second populates only where the process's arenas are
base pages (`arena_base_pages`), and makes the tests take the advice as optional. Their messages have the details.

| `-static hello.c` | main (`base`) | prototype (`fix1`, the first commit) | log |
| --- | ---: | ---: | --- |
| **base pages**: the stage, median of 61 interleaved | 1.373 ms | 1.202 ms | [I191] |
| runtime + executable + write | 2.106 ms | 1.917 ms | [I191] |
| faults taken in the stage (perf, by address) | 319 | 25 | [`faults/pfb-owners.tsv`](faults/pfb-owners.tsv), [`faults/pff-owners.tsv`](faults/pff-owners.tsv) |
| the stage's getrusage faults (they count populated pages) | 319 | 335 | [I191] |
| KB added to the peak | 7,464 | 7,528 | [I191] |
| the whole process's faults (`perf stat`, 3 runs each) | 1,585 | 1,300 | [I192] |
| **emulated 9700X**: the stage, median of 61 interleaved | 1.179 ms | 1.200 ms | [I194] |
| the stage's faults; KB added | 100; 6,280 | 100; 6,280 | [I194] |
| the whole process's faults (`perf stat`, 1 run) | 711 | 691 | [I194] |

- The 25 faults left in base pages are `Bind`'s 20 arrays, 3 of the snapshot and 2 of the compiler's image
  ([`faults/pff-owners.tsv`](faults/pff-owners.tsv)).
- The outputs are byte-identical: the static and dynamic hello worlds ([I160], [I191]), Lua 5.4.8 linked `-static`
  ([I196]), and with the second commit a hello world and a program with 1,458,176 bytes of data in both page
  modes ([F94]). A dynamic hello world's stage is unchanged: 0.030 against 0.031 ms, 3 faults ([I256]).
- **The review's huge-page finding.** The first commit populates upper bounds: the members' rooms (each atom's size
  plus its alignment less one), all their symbols and records. In huge pages that can fault in a fresh 2 MB page that
  nothing writes. A sweep of static hello worlds with 0 to 4,390,912 bytes of data in 16 KB steps, with
  `BUSTER_HUGE_PAGES=1`, the first commit (knob 0) against `bind_populate` not called (knob 44)
  ([`review/sweep/`](review/sweep/), [`review/summary.txt`](review/summary.txt)):
  - 2 of 269 sizes, 0.74%, differ: 1,458,176 and 3,555,328 bytes, 2 MB apart. Each took 26 faults and 8,332 KB
    against 25 and 6,284 KB.
  - Their stage: 1.425 against 1.049 ms (21 runs), 1.305 against 1.133 ms (41), and 1.496 against 1.094 ms for
    the second size (41). The whole process's maxrss: 48,840 and 35,512 KB against 33,456 KB ([R67]).
  - Elsewhere populating gained nothing in huge pages: the plain hello world's stage took 1.341 against 1.491 ms,
    with overlapping quartiles (41 runs).
- **Hence the second commit's gate.** On its knob build ([`review/summary.txt`](review/summary.txt),
  `stage/gate-*`, 21 runs each): the 1,458,176-byte program in huge pages took 25 faults and 6,284 KB gated, as
  without populating, and 26 and 8,332 KB ungated. In base pages the bounds still cost 16 pages that nothing writes
  (336 getrusage faults in the stage against 320). With huge pages the second commit binds as main: 20 faults and
  76 KB for main and for it, 22 and 2,088 KB for the first commit (`stage/blob-huge-pages`, 11 runs; that series'
  counts differ from the knob build's, so compare within a series).
- **Tests.** `test-lanes`, `test-link` and `test-bind` check it. 49 mutants of the first commit each fail one of
  them ([`patches/mutants/campaign.log`](patches/mutants/campaign.log); mutant 44 survived the first round and died
  once the test was stronger, [`patches/mutants/second-round/m2-44.out`](patches/mutants/second-round/m2-44.out)).
  11 mutants of the second each fail `test-bind` or `test-lanes` ([F80]). Under a seccomp filter that refuses
  `MADV_POPULATE_*` ([`patches/mutants/nopopulate.c`](patches/mutants/nopopulate.c)), the first commit's tests failed
  ([F31], [F88]) and the second's pass ([F92]).
- **Why no pull request.** It narrows #2546 for hosts whose arenas take base pages (virtual machines, busy hosts).
  On the 9700X, where the done-when is measured, its gate leaves the binding as main's.

## 6. What is left for the 9700X's done-when

The done-when: `-static hello.c` in a fresh process links in about what `benchmark-link` reports for that shape. On
the 9700X the stage was 0.620 ms fresh against 0.136 ms warm, 103 faults ([`issue-2546.md`](issue-2546.md)). In this
VM the gap is similar: the fresh stage of a Release build of the prototype took 1.276 ms (41 runs, [I251]);
`benchmark-link`'s direct path, warm, took 3.7 µs to begin and 355.7 µs to end the binding of that shape
([`log/bench-link.out`](log/bench-link.out), "1 worker in 4 units ... static executable").

What stays in the 9700X's configuration, from sections 1 to 3:

- **The snapshot's fault-arounds**: 63 of the emulation's 100 faults, from `runtime_piece_hash`'s first reads of
  11,206 slices spread over 704 pages from page 219 to page 1,893.
- **User time.** The issue puts the static link's 0.78 ms over the dynamic one at 2.88 M user cycles and 1.38 M
  kernel cycles on the 9700X ([`issue-2546.md`](issue-2546.md)). In the VM's profile the stage's largest user
  functions are `runtime_piece_hash`, `bind_join` (its copies) and `link_check` (section 1). Warm, the 429 pieces'
  checks alone took 168.81 µs in the VM ([`log/bench-snapshot.out`](log/bench-snapshot.out)).
- **`link_check`**: 0.171 ms of the emulated stage ([I119]), 0.244 to 0.259 ms in base pages ([I118], [I128]). It
  is a scalar loop over every symbol, atom and fixup (`link.c` at the base commit). `benchmark-link`'s figure leaves
  it out: `link_benchmark.c` doesn't call it.

Next steps that could be tried (none is measured on the 9700X):

- **Profile the stage on the 9700X first**, with these tools: `perf record -e cpu-clock` over fresh processes and
  `-e page-faults -d` (`tools/pfowners.py`, `tools/cpuprof.py`). No such profile exists yet.
- **Lay out the pieces a small program binds contiguously in the snapshot.** The link reads 1.2 MB but touches 704
  pages in 76 runs over 6.5 MiB of the file (section 3). Contiguous, it would take fewer fault-arounds and fewer cold
  lines.
- **Make the pieces' checks cheaper**, or check less of what a link reads: `runtime_piece_hash` hashes every byte a
  link reads, and leads the profile.
- **`link_check`'s cost**: vectorize it, or fold its checks into the binding, which `benchmark-link` would then
  measure too.
- **Borrow the members' bytes instead of copying them.** An unreviewed prototype ([`prototypes/protoB.py`](prototypes/protoB.py):
  the atoms' bytes point into the snapshot, and the write stages each chunk, as `link-foreign` does) took the
  emulated stage from 1.601 to 1.321 ms and the write from 0.682 to 0.581 ms (21 runs each, not interleaved,
  [I122]). In base pages: the stage 1.698 to 1.224 ms, the write 0.544 to 0.648 ms ([I88]). Its static hello world
  was byte-identical ([I88]); nothing else was tested.

## Files

`[I<n>]`, `[F<n>]` and `[R<n>]` above are entries of [`log/session-log.txt`](log/session-log.txt): each measuring
command and its output, copied from the session's tool results.

- [`README.md`](README.md); [`env.txt`](env.txt): the VM, the tools, and each executable by sha256 (the binaries
  are not kept); [`issue-2546.md`](issue-2546.md): the issue's body as the session read it.
- [`patches/`](patches/): the two commits. `mutants/`: the mutation switches (`mutate.py`, `mutate2.py`), the first
  commit's campaign (`campaign.sh`, `campaign.log`, `second-round/`), the seccomp filter (`nopopulate.c`,
  `probe.c`) and the second commit's test list (`full.sh`, `full.out`).
- [`tools/`](tools/): the session's scripts (`stages.sh`, `ab.sh`, `ab2.sh`, `abt.sh`, `wall.py`, `pf*.py`,
  `slices.py`, `smaps.gdb`, `smapsdiff.py`, `cpuprof.py`) and two written when the record was assembled
  (`pfowners.py`, `pfwindows.py`).
- [`faults/`](faults/): `perf script` outputs, xz-compressed, of three page-fault records: `pfb` (base pages,
  `c2546`), `pfh` (emulated, `base`), `pff` (base pages, `fix1`); and their summaries (`*-owners.tsv`,
  `*-stage.txt`, `pfh-windows.txt`). The `perf.data` files are not kept.
- [`smaps/`](smaps/): `/proc/PID/smaps` and `status` at `bind_end`'s entry and return, and their difference.
- [`slices/`](slices/): what the link hashes of the snapshot, a line a slice (piece, slice, offset, size), and its
  summary.
- [`profiles/`](profiles/): `cpuprof.py`'s summaries of two `perf record -e cpu-clock -g` runs of 40 compiles each
  (`base`; `fix1`). The 79 and 102 MB `perf script` texts are not kept.
- [`micro/`](micro/): the microbenchmarks, their outputs (`results.txt`) and medians (`medians.py`, `medians.txt`).
- [`prototypes/`](prototypes/): `proto3.diff` (the `PROTO_P`, `PROTO_F`, `PROTO_R` and `PROTO_T` knobs) and
  `protoB.py`.
- [`review/`](review/): the reviewers' and the fixing agent's huge-page runs: `sweep/` (the sweep and its timed
  sizes), `knob/` (the first commit's knob A/B: hello and `big.c` in base pages, hello in huge pages), `stage/`
  (`stage.sh` series: `gate-*` on the second commit's knob build, `hello-*` and `blob-*` for main, the first commit
  `branch` and the second `fixed`; from the scratch directories `st.MTW3`, `st.qAVt`, `st.fwXZ`, `st.XZnr` and
  `st.ec6Q`), and `summarize.py` with its output `summary.txt`.
- [`log/`](log/): `session-log.txt`; `bench-link.out` and `bench-snapshot.out` (`benchmark-link --only direct` and
  `benchmark-snapshot`, Release build of the first commit, in the VM); `time-stages-example.txt`.
