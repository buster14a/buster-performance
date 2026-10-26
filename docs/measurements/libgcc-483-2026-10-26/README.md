# libgcc.a in the direct path's dynamic links: the 9700X A/B for #483's review

2026-10-26. Paired measurements of
[buster14a/buster#483](https://github.com/buster14a/buster/pull/483) (libgcc.a
in a dynamic PIE's and a shared library's runtime, for
[#136](https://github.com/buster14a/buster/issues/136)) against main, as its
review asked: the snapshot's load, the direct path's bind and link times and
resident memory for dynamic PIEs and shared libraries, and the C driver's
whole process.

## Revisions

- main: `ff8936bef4460465c827e8afd4221714d3d1c284`, the branch's merge base once it merged main.
- run 1, the branch: `959a85389a195858edc211181361e474563332d6`: libgcc.a with the room closure
  (`bind_capacity_needed`) and the refusal of morestack.o's unwinder.
- final, the branch: `03c3bd286b9f2997d3958a7ea9e1d982dc3f3736`: also bounds
  `bind_begin`'s room for overrides. Its tree,
  `43011eca181397f876458bf24d54cad33d3ab545`, is that of
  `8bc6ee1c5005eb259498c679dfea1ede21c3bac2`, which the first version of this
  record named: that commit's message was amended before it was pushed.

`manifest-*.sha256` list every file of `build.sh`, `src` and `tests` of
`git archive` of main and of the final branch; the trees measured on the
9700X matched them byte for byte (sorted with `LC_ALL=C`). Run 1's branch
tree was `git archive` of `959a85389a195858edc211181361e474563332d6`, which the final tree replaced.

## Host and inputs

AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, transparent huge pages `always`,
the benchmarks' directories on btrfs. clang 23.1.1 built both trees
(`BUSTER_DEBUG_INFO=0 ./build.sh`); `build/compiler`'s sha256: main
`dd0199f7307daa8fa3af5f8d1b890bd636bf4653e1d80e583295bdfe1e04fcb3`, final
branch `c2e9ecf02efe3de3b4a490ab03cfbafc2dc782f5aeda53ad36ec7457fde888cc`.
GCC 16.2.1's `libgcc.a` (sha256 `c70c9134...cde47d`), glibc 2.44's
`libc.so.6` (`02c8c3d0...641524`) and `libc_nonshared.a`
(`de2e822b...507430`).

## Commands

`lg-ab.sh` (run 1) synced both trees, built each under its own hold of the
shared lock, then ran `libgcc-bench.sh` and `libgcc-proc.sh`; `lg-ab2.sh`
(final) rebuilt the branch alone and ran the two again. Each benchmark and
each process run held the lock alone, main's and the branch's in turn, two
rounds:

- `taskset -c 2 ./build/compiler benchmark-snapshot --only dynamic` (and
  `--only shared`) `--directory DIR`;
- `./build/compiler benchmark-link --only direct --kinds dynamic,shared
  --directory DIR --cache DIR` (it pins its lane to CPU 2);
- `XDG_CACHE_HOME=DIR taskset -c 2 ./build/compiler time-runs --runs 41
  --warmups 5 --list hello.c -o OUT`: the C driver compiling and linking a
  hello world, whole processes.

The logs are `main/run1`, `branch/run1`, `main/final` and `branch/final`
(main's build was the same for both), with main's `build.log` and the final
branch's `build-final.log` (run 1's branch build log was overwritten).

## Results, final

Each figure is a round's median, round 1 / round 2.

| | main | branch |
|---|---|---|
| dynamic runtime's snapshot | 197,828 bytes, 2,685 names, 4 members | 3,281,015 bytes, 3,387 names, 302 members |
| `runtime_open`, dynamic | 9.87 / 9.91 us | 11.76 / 11.73 us |
| `runtime_open`, shared | 9.41 / 9.24 us | 11.16 / 11.28 us |
| direct link, 1 worker, PIE | 19.7 / 19.6 us | 24.7 / 24.4 us |
| of it, open + `bind_begin` | 10.4 / 10.3 us | 15.4 / 15.1 us |
| direct link, 1 worker, shared | 59.2 / 66.3 us | 59.5 / 62.5 us |
| direct link, 2,000 workers, PIE | 139.1 / 138.9 us | 143.9 / 144.3 us |
| direct link, 2,000 workers, shared | 1,042.0 / 1,028.0 us | 1,050.8 / 1,053.2 us |
| direct link, 102,400 workers, PIE | 11,261 / 11,145 us | 11,357 / 11,397 us |
| direct link, 102,400 workers, shared | 26,538 / 26,838 us | 25,326 / 26,760 us |
| more resident, 1 worker, PIE / shared | 0.53 / 0.22 MB | 0.83-0.88 / 0.63 MB |
| C driver, hello world | 2.329 / 2.329 ms | 2.353 / 2.345 ms |
| its peak resident set, minor faults | 31,192-31,200 KB, 560 | 31,768 KB, 574 |

Run 1, before the overrides' bound, had the C driver's hello world at 2.437 /
2.428 ms and 33,840-33,848 KB (main 2.349 / 2.333 ms, 31,196 KB): every link
faulted and cleared a 2 MB huge page, `bind_begin`'s arrays past the 64 KB of
base pages its arena starts with.

What stays is constant in a program's size: `runtime_open` 1.9 us more (the
directory's hash, 3.2 to 4.65 us, and libgcc.a's probe), and `bind_begin`
3 us more (5 us for 102,400 workers), from the mapped snapshot's minor faults
on the crt objects' records at the starts of the columns that now span 302
pieces. The 102,400-worker links' differences are the write's chunks, which
vary as much between rounds.

## Limitations

- `benchmark-snapshot`'s and `benchmark-link`'s generated programs reserve
  every member's room (`bind_capacity`); the C driver reserves the closure's
  (`bind_capacity_needed`). Their "more resident" is a run's first growth,
  page-cache pages of the snapshot's mapping among it.
- The lock's messages ("exclusive.sh: waiting" and their title, link and
  pull request lines, which name other sessions) were removed from the logs;
  nothing else was changed.
- Two rounds of each: a shared library's write varies by up to 7% between
  rounds, more than the change.
