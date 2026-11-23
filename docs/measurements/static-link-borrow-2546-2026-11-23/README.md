# A static hello world's link in a fresh process: borrowed bytes and a vector link_check (#2546)

Measurements for [buster#2546](https://github.com/buster14a/buster/issues/2546) on the Ryzen 7 9700X (`benchpress`), for the
pull request that borrows a loaded runtime's atoms' bytes in the driver's links and checks a link's records eight to a
vector in `link_check`.

## Who, where, what

- **Who.** Claude (Anthropic, `claude-opus-5-5`) in David's directed session
  [session_01EgbxngRuxdNCqGR6QeyPwi](https://claude.ai/code/session_01EgbxngRuxdNCqGR6QeyPwi), working the claim
  [#2546 (comment)](https://github.com/buster14a/buster/issues/2546#issuecomment-7087783227).
- **When.** 2026-11-23, 00:20 to 01:45 UTC.
- **Where.** The 9700X, every run under `~/buster-fast-bench/exclusive.sh` (owner `claude-2546`), pinned to CPU 2
  (`taskset -c 2`). Each run's log starts and ends with `/proc/loadavg` and the busiest processes.
- **Builds.** Release builds by `./build.sh --config Release` with the 9700X's toolchain ([`env.txt`](env.txt) has
  their sha256 and commits):
  - `base`: buster main `4704727a1`.
  - `fix1`: `base` with [`fix1-tree.diff`](fix1-tree.diff), the borrowing step's production code (the branch's first
    commit, `7cf49a42` there, without its test changes).
  - `fix2`: the branch's first two commits (`f7d6335d7` here, the same trees as `7cf49a42` and `79c40eeb`): the
    borrowing and the vector `link_check`.
- **Disk.** `/home` on the 9700X was full during the session (64 KB to 2 GB free, other sessions' files), so the trees
  were built in `/tmp` (tmpfs), and the snapshots of the measurement that compares all three (`m3`) are on tmpfs too
  (`XDG_CACHE_HOME=/tmp/2546-claude/caches/cache-NAME`): `fix2`'s snapshot couldn't be written on `/home` (`m2/run.log`,
  whose `fix2` re-imported the runtime every run, 7.7 ms). The first measurement (`m1`, base and fix1) had its snapshots
  on btrfs in `~/buster-fast-bench/2546-claude/caches`, as `~/.cache` is.
- **What.** `compiler -static hello.c -o hello` ([`m1/hello.c`](raw/m1/hello.c): `stdio.h` and a `printf`), each a fresh
  process, interleaved base, fix1, fix2 in each round, after one build each that writes its snapshot
  ([`m1/measure.sh`](raw/m1/measure.sh)): each round runs each binary once under `perf stat` (task-clock, user and kernel
  cycles, user instructions, page faults) and once with `--time-stages`. [`m1/summarize.sh`](raw/m1/summarize.sh) takes
  the medians. Every build's executable has the same sha256 (`d7cc819f…`, in each `run.log`).

## Results

`m3`: 31 rounds, snapshots on tmpfs ([`raw/m3/run.log`](raw/m3/run.log), [`raw/m3/results`](raw/m3/results)). Medians:

| | base | fix1 (borrow) | fix2 (borrow, vector link_check) |
| --- | ---: | ---: | ---: |
| the whole process, ms (task-clock) | 2.72 | 2.67 | 2.59 |
| user cycles, M | 8.53 | 8.28 | 8.06 |
| kernel cycles, M | 5.75 | 5.48 | 5.35 |
| user instructions, M | 14.18 | 13.79 | 12.52 |
| page faults | 657 | 700 | 702 |
| `runtime`, ms | 0.052 | 0.051 | 0.051 |
| `executable`, ms | 0.421 | 0.341 | 0.302 |
| `executable`'s faults | 102 | 86 | 86 |
| `executable`'s KB added to the peak | 6,408 | 4,300 | 4,300 |
| `write`, ms | 0.212 | 0.202 | 0.201 |
| `write`'s faults | 24 | 86 | 87 |
| **the link (runtime + executable + write), ms** | **0.685** | **0.595** | **0.555** |

`m1`: 21 rounds, base and fix1, snapshots on btrfs ([`raw/m1/run1.log`](raw/m1/run1.log)): the link 0.692 and
0.603 ms, `executable` 0.421 and 0.340 ms, the process 2.65 and 2.61 ms; the same shape.

- **Borrowing** takes 0.08 ms from `executable`: no 0.74 MB copy of the members' bytes, and one huge page fewer
  (2.1 MB less added to the peak). The write stages the chunks that hold borrowed bytes into its scratch, whose fresh
  base pages are 62 more faults there; `write` is no slower for them.
- **The vector `link_check`** takes 0.04 ms more, and 1.3 M user instructions.
- **Left**: the link is 0.555 ms against `benchmark-link`'s warm 0.29 ms. In `fix2`'s profile (below) the link's user
  time is `executable_write` (3.6% of the process), `bind_join` (3.2%: the columns' copies), `runtime_piece_hash`
  (3.1%), `link_check` (2.7%) and `bind_merge` (1.2%); its kernel time is clearing fresh pages (`clear_page_erms`,
  7.1% of the whole process, the link's two huge pages among them), the snapshot's 63 fault-arounds
  (`filemap_map_pages`, `next_uptodate_folio`) and the staging buffer's faults.

## Profiles

[`raw/m1/profile.sh`](raw/m1/profile.sh): `perf record -F 49999` over 200 fresh builds of each binary, a flat profile
by symbol (`cyc-*.txt`), and `perf record -e page-faults -c 1 -d` over 20, by the faulting code's symbol
(`pf-*.txt`): [`raw/m1/cyc-base.txt`](raw/m1/cyc-base.txt), [`raw/m1/cyc-fix1.txt`](raw/m1/cyc-fix1.txt),
[`raw/m3/cyc-fix2.txt`](raw/m3/cyc-fix2.txt), and the faults' beside them. The profiles are of the whole process, the
link about a quarter of it.

## Benchmark-link

See [`benchmark-link.md`](benchmark-link.md).

## Files

- [`env.txt`](env.txt): the executables' sha256, the trees' commits and the kernel.
- [`fix1-tree.diff`](fix1-tree.diff): fix1's tree's change on base.
- `raw/m1`, `raw/m3`: the measurements (`results/NAME.ROUND.perf` and `.ts`), the scripts, the profiles and logs;
  `raw/m2/run.log`, the run whose fix2 had no snapshot; `raw/build-*.log`, the three builds.
