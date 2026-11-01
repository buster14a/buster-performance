# #590: the backend's tables when a function is emitted (buster14a/buster#1027)

This record measures [buster14a/buster#1027](https://github.com/buster14a/buster/pull/1027), the residual scope of
[#590](https://github.com/buster14a/buster/issues/590) after #689. It covers the backend tables a compile builds when a
function is emitted:
- **Derived templates.** The encoder makes its FS and GS templates from each form's own template
  (`x86_template_with_segment`) instead of building them again.
- **Huge pages.** The table a compile builds (`x86_encode`'s, in `main.c`'s units) asks for transparent huge pages over
  the 2 MB pages it fills by at least 750 KB. Each table's written ranges are committed with `MADV_POPULATE_WRITE`.
- **Tier 0.** Tier 0 commits its tables' pages in one call per array.

The PR's `docs/compile-time.md` ("The backend's tables when a function is emitted") has the design summary.

## Revisions and builds

| name | commit | what |
| --- | --- | --- |
| base | `91cfe9e07300c624573454f41dceb11a17609973` | main before the PR |
| head | `8da9e4798dc8ea8103800bc667fde42012a14f49` | the PR after its review, before main was merged in |
| main2 | `b823d1c29a9364e8a0e025d86caa9a6a6a50e0f2` | main merged into the PR at `54b5b541` |
| head2 | `f5179878bc663d08ac2f208ff48c5cf92e61c0a4` | the PR with margins on `main.c`'s units' table alone |
| head3 | `32e0c7543f66cb7039b010c1910a452d8a76a113` | the PR with `x86_encoder_initialized` in `.data` |

- **9700X.** Every build is `BUSTER_DEBUG_INFO=0 ./build.sh` on benchpress, under its lock. That is clang 23.1.1, and
  `build.sh`'s `auto` linker, which is wild 0.10.0 there.
- **Xeon VM.** base and head were built with `BUSTER_LINKER=wild` (wild 0.10.0, the release CI pins by sha256) and
  `BUSTER_DEBUG_INFO=0`, with Ubuntu's clang 23.1.5. The head build there (`compiler.wild3`) was made from
  `8da9e479`'s sources before they were committed.
- **Identities.** Each directory's `host.txt` gives the binaries' and inputs' sha256 and `size` output.
- **Rounds.** The 9700X's three rounds are `9700x/round-1` (base, head), `round-2` (main2, head2) and `round-3`
  (main2, head3). Rounds 2 and 3 share main2's build.

## Machines

- **9700X.** benchpress: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, transparent huge pages `always` (defrag `madvise`).
  - Every build, compile and measurement ran under the shared lock (`~/buster-fast-bench/exclusive.sh`), one run per
    hold, pinned to CPU 2.
  - The reference is tcc 0.9.28rc 2026-01-17 (sha256 `49e2d1af…`, `docs/compile-time.md`'s).
  - `sqlite3.c` is the frozen corpus's (sha256 `0a409f16…`).
- **Xeon VM.** A 4-vCPU Intel Xeon VM at 2.1 GHz with Linux 6.18.44, transparent huge pages `madvise` (as Ubuntu,
  Debian and Fedora ship them).
  - It is noisy: measurements were not pinned, and other work shared the VM.
  - The reference is Ubuntu's tcc 0.9.27.

"THP disabled" is `harness/nothp`: `PR_SET_THP_DISABLE` for the measured process and its children (fork and exec keep
it). It stands in for a kernel set to `never`, and changes no host setting.

## Results

### 9700X (THP `always`)

`hello.c` with `measure-compile --runs 41 --reference /usr/bin/tcc -- -c harness/hello.c`. Each cell lists the
medians of three rounds, which alternate the builds' order; tcc took 0.77 to 0.86 ms throughout. The peak is
`wait4`'s, which includes the parent `measure-compile` process and moves between rounds; `backend-setup`'s own added
peak (`--time-stages`) is compared below.

| build | THP | wall, ms | `backend-setup`, ms | its faults | peak, KiB |
| --- | --- | --- | --- | ---: | ---: |
| base | always | 2.460 2.459 2.455 | 0.589 0.589 0.588 | 12 | 37,380 |
| head | always | 2.501 2.526 2.489 | 0.559 0.560 0.567 | 13 | 39,264 |
| base | disabled | 2.522 2.503 2.512 | 0.830 0.824 0.829 | 1,134 | 19,072 |
| head | disabled | 2.307 2.312 2.310 | 0.627 0.628 0.626 | 1,137 | 18,932 |
| main2 | always | 2.463 2.439 2.465 | 0.585 0.582 0.586 | 11 | 37,216 |
| head2 | always | 2.503 2.739 2.505 | 0.559 0.593 0.559 | 12 | 39,288 |
| main2 | disabled | 2.515 2.494 2.549 | 0.828 0.819 0.836 | 1,133 | 18,908 |
| head2 | disabled | 2.311 2.303 2.294 | 0.629 0.627 0.625 | 1,136 | 19,060 |
| main2 (round 3) | always | 2.414 2.408 2.413 | 0.582 0.583 0.583 | 11 | 38,812 |
| head3 | always | 2.555 2.410 2.329 | 0.529 0.518 0.509 | 11 | 37,260 |
| main2 (round 3) | disabled | 2.472 2.510 2.621 | 0.817 0.831 0.850 | 1,133 | 20,504 |
| head3 | disabled | 2.289 2.293 2.369 | 0.625 0.627 0.645 | 1,135 | 19,028 |

The medians over each pair's three rounds of `--time-stages`' stages (ms, and the peak each added, KiB):

| pair | THP | `backend-setup` | its peak added | the stages' span | setup + preprocess + check-input |
| --- | --- | --- | --- | --- | --- |
| main2 → head2 | always | 0.585 → 0.559 | 6,564 → 8,684 | 2.102 → 2.144 | 1.156 → 1.204 |
| main2 → head3 | always | 0.583 → 0.518 | 6,564 → 6,564 | 2.080 → 2.035 | 1.140 → 1.165 |
| main2 → head2 | disabled | 0.828 → 0.627 | 4,888 → 4,900 | 2.161 → 1.946 | 1.072 → 1.064 |
| main2 → head3 | disabled | 0.831 → 0.627 | 4,888 → 4,896 | 2.153 → 1.944 | 1.065 → 1.061 |

The 220 programs of c-testsuite's subset (`5c7275656d751de0e68b2d340a95b5681858ed07`), each compiled with `-c` three
times by each compiler in turn (`harness/best_of`). Each cell is the mean of each program's best:

| pair | THP | before | after | tcc |
| --- | --- | ---: | ---: | ---: |
| base → head | always | 2.067 ms | 1.955 ms | 0.566 ms |
| base → head | disabled | 2.110 ms | 1.878 ms | 0.515 ms |
| main2 → head2 | always | 2.067 ms | 1.938 ms | 0.568 ms |
| main2 → head2 | disabled | 2.102 ms | 1.849 ms | 0.515 ms |
| main2 → head3 | always | 1.913 ms | 1.809 ms | 0.553 ms |
| main2 → head3 | disabled | 2.078 ms | 1.852 ms | 0.515 ms |

`sqlite3.c` with the record's options in `docs/compile-time.md` (`measure-compile --runs 11`) is unchanged:

| pair | before | after |
| --- | ---: | ---: |
| base → head | 135.65 ms (`backend-setup` 0.802) | 135.04 ms (0.803) |
| main2 → head2 | 135.18 ms (0.790) | 134.64 ms (0.810) |
| main2 → head3 | 135.25 ms (0.795) | 135.39 ms (0.732) |

Objects are the same bytes in every pair: the 220 programs, `hello.c`, and `sqlite3.o` (`objects.txt`,
`sqlite-objects.txt`).

What the 9700X shows:
- **THP disabled.** `backend-setup` falls by 0.2 ms in every pair, and `hello.c`'s stages by 9 to 10%.
- **THP `always`, the host's own setting, through head2.** `backend-setup` fell by only 0.02 to 0.03 ms. Its peak
  grew by 2 MB, and `hello.c`'s other stages took 0.05 to 0.06 ms more.
- **Where the 2 MB came from.** Round 2's `windows.txt` lists the 2 MB windows of `.bss` whose base pages were all
  present at the end of `backend-setup` (`/proc/PID/pagemap`); `windows.*.nm.gz` maps them to symbols.
  - head2 had one window main2 hadn't, `0x3600000`. It held only the 64-bit table's trailing 2 MB margin, the start of
    the APX table (unwritten in a compile), and `x86_encoder_initialized`.
  - That flag is defined right after the storage. The margin had pushed it into a window nothing else a compile
    writes, and an `always` kernel cleared a whole huge page for that one byte.
  - `smaps.txt` agrees: one more anonymous huge page in `.bss` (14,336 KiB against 12,288), and no file-mapped huge
    page among the differences.
- **head3.** It moves the flag to `.data`, as `lane.c`'s `LaneProcess` is.
  - Round 3's windows are main2's six, and `backend-setup`'s peak added is main2's.
  - `backend-setup` falls by 0.065 ms and the stages' span by 0.045 ms (2.2%). c-testsuite is 5.4% faster.
  - The setup, preprocessing and check-input stages differ by at most 0.013 ms.
  - The table `x86_encode` reads is the copy with hidden visibility, `main.c`'s units'. From its address it spans the
    same two 2 MB pages in every build, and no copy of Tier 0's arrays reaches a 2 MB page through its whole-array
    commit that its used part doesn't.

### Xeon VM (THP `madvise`)

`hello.c` with `measure-compile --runs 31` in two rounds that alternate the builds' order; tcc took 3.0 to 3.6 ms.

| build | THP | wall, ms | `backend-setup`, ms | its faults | peak, KiB |
| --- | --- | --- | --- | ---: | ---: |
| base | madvise | 13.785 12.806 | 3.874 3.863 | 1,129 | 31,020 |
| head | madvise | 10.884 10.095 | 2.091 2.168 | 420 | 32,252 |
| base | disabled | 13.589 11.663 | 4.208 3.211 | 1,129 | 22,476 |
| head | disabled | 10.689 10.687 | 2.356 2.529 | 1,132 | 22,416 |

c-testsuite's subset, best of 3 each (`harness/best_of`):

| THP | base | head | tcc |
| --- | ---: | ---: | ---: |
| madvise | 8.839 ms | 8.030 ms | 2.038 ms |
| disabled | 9.067 ms | 7.697 ms | 2.108 ms |

A kernel that counts `MADV_POPULATE_WRITE`'s pages as minor faults shows them in the "disabled" rows, though none is
taken one at a time.

## Harness

| file | what it is |
| --- | --- |
| `harness/measure-9700x.sh` | the base/head round on benchpress (run as `measure.sh`, without its SPDX line) |
| `harness/measure-pair.sh` | rounds 2 and 3 (`measure-pair.sh main2 head2 logs-2`, then `main2 head3 logs-3`) |
| `harness/measure-xeon-vm.sh` | the VM's runs |
| `harness/best_of.c` | the best-of-N tool, as `best_of OUT RUNS COMPILER...` with sources on standard input |
| `harness/nothp.c` | the THP-disabling wrapper |
| `harness/hello.c` | the small file |
| `harness/smaps.gdb`, `harness/smaps.sh` | `smaps` at the end of `backend-setup` (rounds 2 and 3's `smaps.txt`) |
| `harness/windows.gdb`, `harness/windows.sh` | the present pages of each 2 MB window of `.bss` (rounds 2 and 3's `windows.txt`) |

The C files and `measure-9700x.sh` carry SPDX and description comments that the copies that ran did not have.

Each directory keeps the raw outputs:
- `measure-compile`'s reports (`hello-*.txt`, `sqlite-*.txt`);
- `best_of`'s sums (`c-testsuite-*.txt`), with `exclusive.sh`'s waiting lines where the lock was held;
- the builds' logs, `host.txt` and `objects.txt`.

## Limitations

- **One host per policy.** The 9700X runs are on one host with THP `always`. A `madvise` kernel on Zen 5 was not
  measured; that is the hosted runners' setting.
- **The VM's numbers are noisy.**
- **What the timings cover.** `measure-compile`'s wall times include process creation and exit. `best_of` takes each
  program's minimum.
- **Placement under `always`.** Under `always`, where `.bss`'s written objects fall against 2 MB pages decides peak RSS
  and part of the time. The window analysis found head2's extra window and head3 removes it. Other placements move
  with any change to `.bss`, this one's or another's.

## Provenance

The harness is original material under Apache-2.0 WITH LLVM-exception. Clang, tcc, wild, gdb, the frozen corpus's
`sqlite3.c` and c-testsuite ran as external inputs; none is incorporated.
