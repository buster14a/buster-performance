# The rare columns' pages by the unit's size, and the lanes' claims, 2026-10-29

The 9700X's measurements for Buster's issue [#847](https://github.com/buster14a/buster/issues/847) and its PR
[#869](https://github.com/buster14a/buster/pull/869). #764's fix ([#791](https://github.com/buster14a/buster/pull/791),
record
[deferred-rare-columns-764](https://github.com/buster14a/buster-performance/tree/cc514098c9ad2ad809cb1b8ef82f3c365991375a/docs/measurements/deferred-rare-columns-764-2026-10-29))
gives `check_input_run`'s arena of rare columns base pages throughout wherever the deferred reader's rule gives the
bodies more than one lane, so that the lanes no longer race to clear its huge pages; by the rule it read fourteen units
whose lanes didn't race 1.7 to 8.6% slower than main. #847's change keeps the huge pages in a unit below
`BUSTER_CHECK_DEFERRED_BASE_PAGE_TOKENS` (48,640 tokens), where the lanes claim each 2 MB region of the token columns
before their first write into it (the first to claim it faults it in, and the others wait), and #791's base pages in a
larger one, with one pair of the lane rule's constants for every unit. Cited by Buster's `docs/c-deferred-bodies.md`
("The rare columns' pages by the unit's size (#847)").

In short:

- **Where base pages cost** (campaign E1, every page fault recorded with its address, #791's head against the same code
  in huge pages): on four units below 48,000 tokens, 33 to 66% more faults, most of them the calling thread's, in the
  top level's walk, the merge's pass and the phases after it, a fault per 4 KB where huge pages took one per 2 MB, and
  15 to 26% more of the data TLB's second-level misses; on `h16x154.c` (137,449 tokens) 87% more faults, but huge pages
  cost the process 34% more of the kernel's cycles.
- **A first write into a region** (`tools/thp_probe.c`): on the 9700X's kernel (6.18) a store, a load then a store, and
  a locked `or` each give a fresh 2 MB region a huge page in 58 to 87 µs; a store where a load had mapped the huge zero
  page gives it one in 61 to 62 µs.
- **The first version faulted every region in before the lanes** (`b2e2169e`, campaign B6, stopped after two rounds): 64
  to 74 µs a reading on six units of 42,993 to 48,135 tokens, two of the three regions it gave a page there being ones
  no lane writes (the region diagnostic, `diag847`); the claims (`f3ac8f15`) read those units 3.4 to 8.5% faster
  (campaign B7).
- **By each tree's rule** (campaign B7, A2's 43 units, five rounds, `f3ac8f15`): the change reads every unit within 1.0%
  of the faster of main as #791's branch has it (`d11a91d2`) and #791's head (`d312b0a8`), 0.4% faster by the median;
  against main alone 1.2% faster by the median (20.0% faster to 0.9% slower), against the head 1.4% faster (9.3% faster
  to 1.0% slower). With the claims at every size, ten units of 53,105 tokens or more read more than 2% slower; with base
  pages at every size, thirteen of 48,135 or fewer: a threshold above 48,135 and no more than 53,105 leaves none.
- **The walks' spread** (B7, eight lanes with every lane, five rounds): the claims' a median of 0.81 ns/token and at
  most 7.40 (`00213.c`, 460 tokens: 3.4 µs), base pages' 1.67 and 7.98.
- **No two lanes clear one region** (campaign E2, every page fault with its time and its instruction): with the claims
  at every size, no region took a store fault from two threads within 100 µs on six units; main's took them at 3 to 7
  regions of each of the four units whose lanes race; the claims' processes took 9 to 28% fewer kernel cycles there.
- **Source order** (campaign SOI847): the same user instructions as #791's head's to 0.009%.
- **Main's own change** (campaign M7): `d11a91d2` reads c-testsuite's programs up to 13.8% slower than `bc11fddb`, and
  `sqlite3.c` 3.8% (5.2% in source order), with no part of #791 or #847 in either; B6, which compared against
  `bc11fddb`, showed that difference, and B7 compares against `d11a91d2`.
- **The lane rule** (campaign A7, the change's grid on 2, 3, 4 and 8 lanes with every lane, cold): A4's 1,024 tokens and
  a quarter of the top level's forgo 37.2 points against each unit's best lane count, #764's 1,280 and a third 51.7;
  less on the units below the threshold in each round, and on the large ones in four of five. So one pair, A4's, for
  every unit (`b179fad3`); by its rule (campaign B8, the twelve large units, whose lanes it changes, and four smaller
  ones), every unit within 1.6% of the faster of main and the head, 0.1% faster by the median.

## Sources and inputs

| Tree | Buster source | Files under `src` | Source manifest's SHA-256 |
| --- | --- | ---: | --- |
| `main-bc11fddb` | main `bc11fddb`, before #791 (#764's campaigns' main): B6, M7 | 555 | `68e3b0298f73a2887d758602dd35903e7a3251f14a08269a608cfb870267247b` |
| `main-d11a91d2` | main `d11a91d2`, which #791's branch merged (`57ba0901`): B7, E2, SOI847, M7 | 570 | `0cbb771123ec734006cd568c81625df2835ba3a715cdaf8ac85423a90985840f` |
| `pr791-d312b0a8` | #791's head `d312b0a8` (its sources are `57ba0901`'s): B7, SOI847 | 570 | `5248feb5234c7056f882483a55cb10388d01027171b46b4837c5ea809c3815f2` |
| `head-95fc3668` | #791's head at #764's B5, `95fc3668`: E1 | 555 | `ef92376af8f489738310061fad5e0f691287dcdecfaece2502eb11cb060b124c` |
| `headhuge-95fc3668` | `95fc3668` with the arena in huge pages at every reading (`scripts/make-headhuge.sh`): E1 | 555 | `09869507eaefa8f0de31a03e4dde4f7a62100b759aa5c8c9ae7022ecf1e5e4c2` |
| `new-7a454554` | `7a454554`, not pushed: the size policy, whose reader dropped `base_page_tokens` when it reset its state (its tests failed: `logs/tests-new-7a454554.txt`) | 570 | `aaf0d7ea8311d4a98b6473b7e591eb2511061f67a54bd8a70d2ddda9b43b5da1` |
| `new-b2e2169e` | `b2e2169e`: the size policy, with every region faulted in before more than one lane: B6, B7 | 570 | `b7ffcba0f9abb3e05b1bfead43da5c72179fef2a3e8e4e5d24a367caa5acb681` |
| `new-f3ac8f15` | `f3ac8f15`: the lanes' claims instead of the fault-in: B7, E2, SOI847, A7, B8 | 570 | `d667a11f202468b4b9143d9fd2c641d3c8d3e3b513eac2705a32bdcab8164317` |
| `new-b179fad3` | `b179fad3`: one pair of the lane rule's constants for every unit: B8 | 570 | `efca1c1024a53f10caad77ea318ac434d4a13bcf0b72c0d0e695aecc072d7a73` |
| `diag847` | `b2e2169e` with the region diagnostic (`patches/diag847-from-b2e2169e.diff`), not committed | 570 | `8b05f555b0051f108de9d138cc0ba233c753eb60859b588aae51c75f58f0b07f` |

`trees.txt` has each tree's commit (`diag847`'s line has its note in the commit's place); `source-TREE.sha256` the
SHA-256 of `build.sh` and of every file under `src`, whose own SHA-256 is the manifest's (`scripts/manifests847.sh`).
Each tree was built as the 9700X job builds it, `env BUSTER_DEBUG_INFO=0 ./build.sh`, a lock hold each
(`scripts/build.sh`, `logs/builds.txt`, every build's exit status and its binary's SHA-256; `binaries.sha256`).
`7a454554` was amended into `b2e2169e` and pushed to no branch: its diff from `b2e2169e` is the line
`check_input_deferred` keeps (`base_page_tokens` across the state's reset).

The inputs are record A2's 43 units (`inputs.sha256`, the same files and SHA-256 as #764's record): four of
c-testsuite's single-exec programs at `5c7275656d751de0e68b2d340a95b5681858ed07`, the frozen `sqlite3.c` and 38
synthetic units from A2's generator (`gen2.c`), read with the frozen corpus's pinned predefines and headers
(`scripts/env.sh`); `SOURCE_DATE_EPOCH=1792454400`; `CPATH` and `C_INCLUDE_PATH` unset. Each run is record A2's command,

```sh
./build/compiler benchmark-checker-deferred --passes 24 --lanes 8 --cpus 2,0,1,3,4,5,6,7 [--every-lane] [--base-page-tokens N] [the options] FILE
```

with `--passes 12` for `sqlite3.c`, in a process of its own (`scripts/runs847.sh`): source order, one lane, then 8 lanes
by the rule (or with `--every-lane` every lane the bodies can take), each reading in its passes in the six orders of the
three. `--base-page-tokens 4294967295` (`-huge` after a tree's name in the logs) makes no unit large, so that the rare
columns are huge pages at every size (in `b2e2169e` faulted in, in `f3ac8f15` claimed, where more than one lane reads);
`--base-page-tokens 1` (`-base`) makes every unit large, so that they are base pages wherever more than one lane reads,
#791's policy. A campaign's jobs (`scripts/*.jobs`: a unit's runs) run in rounds, a round's jobs in an order that
starts 7 jobs further on each round and a job's runs in an order that starts one run further on, 7 to 11 jobs a lock
hold, 30 s apart (`scripts/queue847.sh`, `scripts/batch847.sh`). Every run's heading, output and exit status are in its
campaign's log; all are 0.

Host (`host.txt`): AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, GCC 16.2.1, perf 7.2.9-1; transparent huge
pages `always` (defrag `madvise`, the huge zero page in use); CPU 2 has the performance governor, CPUs 0, 1 and 3 to 7
powersave.

The scripts ran as chains (`scripts/master*.sh`, `logs/chain.txt`): `master7.sh` built `headhuge` and ran E1;
`master8.sh` built `new-7a454554`, whose tests failed, and then (run again) `new-b2e2169e`, its tests and B6, stopped
after its second round; `master9.sh`, which was to run the diagnostic after B6, was stopped before it ran; `master10.sh`
built `new-f3ac8f15` and was stopped before its tests, when B6's comparisons against `bc11fddb` showed the newer main's
difference; `master11.sh` built `main-d11a91d2` and `pr791-d312b0a8`, ran `new-f3ac8f15`'s tests, B7 and the diagnostic;
`master12.sh` E2 and SOI847; `master13.sh` M7 and A7; `master14.sh` the corpus tests; `master15.sh` built
`new-b179fad3`, ran its tests and B8. The lock's waiting messages went to files of their own, which name other sessions'
work and aren't published; the builds' and tests' logs had them removed (`analysis/strip_lock.py`).

## Campaign E1: where base pages cost a multi-lane reading

`scripts/e1.sh`: five units, `head-95fc3668` (base pages where the rule plans more than one lane) and
`headhuge-95fc3668` (huge pages at every reading), by the rule on up to 8 lanes, 6 passes, a lock hold a unit: a process
under `perf stat` (task-clock, page faults, the L1 and L2 data TLB's misses, user and kernel cycles, user instructions;
`reports/e1/stat-*.csv`), then one whose every page fault was recorded with its address
(`perf record -e page-faults -c 1 -d`; `reports/e1/faults-*.txt.gz` are `perf script -F pid,tid,ip,sym,addr`'s, every
kernel address replaced by `ffffffff80000000` by `analysis/mask_kernel_faults.py`). `tables/E1.txt`
(`analysis/e1sum.py`) has each unit's counters and its faults by thread (the calling thread, the lanes) and by function,
base pages' less huge pages'.

- `h16x10.c`, `d2x1f384s288.c`, `b16x19.c` and `l16x19f192.c` (17,641 to 44,041 tokens): base pages took 33 to 66% more
  faults, most of them the calling thread's: in the top level's walk (`check_input_expression_classes`,
  `check_input_declaration`, `check_input_tag_identity`), the merge's pass (`check_deferred_pass_items`,
  `check_deferred_entries64`) and the phases after it, a fault per 4 KB of what they read or write where the huge pages
  took one per 2 MB; and 15 to 26% more of the data TLB's second-level misses.
- `h16x154.c` (137,449 tokens): base pages took 87% more faults, but huge pages took 34% more of the kernel's cycles:
  the top level's walk clears a huge page for each 2 MB region its few entries fall in, and the lanes race for the rest.

## The first write into a region (`tools/thp_probe.c`)

**Historical executable identity limit:** The helper source is retained in
[`tools/thp_probe.c`](tools/thp_probe.c), and its build/run commands and text output
are in [`logs/thp_probe.txt`](logs/thp_probe.txt). The executed helper binary and
its hash were not retained in this record. The compiler source manifests and
`binaries.sha256` identify Buster builds only; they do not identify the helper
executable behind these historical timings. That exact executable cannot be
verified from the archive.

`thp_probe` maps 64 MB with `MADV_HUGEPAGE` and touches each 2 MB region first in one of four ways, then stores into
another 4 KB page of each: a store, a load and then a store (`*byte = *byte` through a volatile pointer, the claim's), a
locked `or` of 0 (a read-modify-write, which faults as a write), and a load alone (`logs/thp_probe.txt`, two runs on CPU
2, a lock hold each). Every way that writes gives every region a huge page (AnonHugePages 65,536 kB) in 57.7 to 87.3 µs
a region; a load maps the huge zero page (0 kB) in 0.4 µs, and a store after it gives the region a huge page in 61.4 to
62.2 µs: this kernel allocates a huge page on a write fault on the huge zero page rather than split it into base pages.
On the session's mini PC (Linux 7.3) the same.

## Campaign B6: the fault-in (stopped)

`scripts/b6.sh`: `new-b2e2169e` by the rule as it is, huge and base, `main-bc11fddb` by its rule, and the tree on 8
lanes with every lane, huge and base; A2's 43 units, stopped after 714 runs (two rounds and 198 runs of the third;
`logs/B6.txt`, `tables/B6.md` by `analysis/b6sum.py`). Its comparisons against main are against `bc11fddb`, which
#791's branch no longer contains (M7, below): of the eight units it read more than 2% slower than `bc11fddb`, three are
c-testsuite's programs (7.6 to 14.6%) whose readings `d11a91d2` slows on its own. Its fault-in's own time is in each
reading's `fault` field: 64 to 74 µs on the six units of 42,993 to 48,135 tokens on more than one lane (1.5 ns/token),
16.5 to 20.5 µs on seven of 25,129 to 40,937, and about 1 µs below.

### The region diagnostic (`diag847`)

`scripts/diag847.sh`, one lock hold: `diag847` on ten units by the rule, no unit large, 6 passes, with the fault-in and
without it (`BUSTER_847_NOFAULT`), each reading's regions' states printed (`BUSTER_847_REGIONS`): each region's first
page's entry in `/proc/self/pagemap` before the fault-in and after the lanes, `o` mapped and exclusive (a page of its
own), `z` mapped and shared (the zero page), `-` not mapped (`logs/diag847.txt`). Every reading of a unit gave the same
states:

| Unit | Tokens | Lanes | Before the fault-in | After the lanes, without it | After the lanes, with it |
| --- | ---: | ---: | --- | --- | --- |
| `00204.c` | 7,653 | 2 | `zz` | `zz` | `oo` |
| `h16x10.c` | 17,641 | 3 | `zo` | `zo` | `oo` |
| `h16x19.c` | 25,129 | 5 | `zzo` | `zoo` | `ooo` |
| `l16x19f192.c` | 34,125 | 5 | `zzo` | `zoo` | `ooo` |
| `l16x10f384.c` | 37,089 | 3 | `zzo` | `zoo` | `ooo` |
| `l8x38f384.c` | 42,993 | 5 | `zz-o` | `zo-o` | `oooo` |
| `d2x1f384s288.c` | 44,041 | 2 | `zz-o` | `zo-o` | `oooo` |
| `l16x19f384.c` | 44,109 | 5 | `zz-o` | `zo-o` | `oooo` |
| `d2x1f480s240.c` | 46,537 | 4 | `zz-o` | `zo-o` | `oooo` |
| `x16x19.c` | 48,135 | 2 | `zz-o` | `zo-o` | `oooo` |

The lanes write one region of those the top level's walk leaves without a page of its own, on the units of 25,129 tokens
and more, and none on `00204.c` and `h16x10.c`; the fault-in gave each such region a page.

## Campaign B7: by each tree's rule

`scripts/b7.sh`: A2's 43 units, five rounds, 7 jobs a lock hold; each job `new-f3ac8f15` by the rule as it is, huge and
base, `new-b2e2169e`, `main-d11a91d2` and `pr791-d312b0a8` by their rules, and `new-f3ac8f15` on 8 lanes with every
lane, huge and base (`logs/B7.txt`, 1,720 runs). `tables/B7.md` (`analysis/b7sum.py`) has each unit's medians over the
rounds (ns/token) and lanes, the changes, the claimed regions and the every-lane walks' spread, the summaries, source
order's changes and the threshold's fit.

- As it is, against the faster of main and the head: 0.4% faster by the median, from 4.9% faster (`h16x38.c`) to 1.0%
  slower (`00182.c`, which all three read on one lane in huge pages); none more than 1% slower. Against main: 1.2%
  faster by the median, from 20.0% faster (`h16x154.c`; `h16x77.c` 17.5%, `b16x77.c` 17.4%, `l16x77f384.c` 15.8%,
  `sqlite3.c` 5.1%) to 0.9% slower. Against the head: 1.4% faster, from 9.3% faster (`h16x10.c`, three lanes in huge
  pages where the head reads two in base pages) to 1.0% slower.
- The fourteen units #764's B5 read 1.7 to 8.6% slower than main: from 3.4% faster than main to 0.3% slower.
- Against the fault-in: from 8.5% faster (`h64x10.c`; `d2x1f384s288.c` 8.0%, `l16x19f384.c` 6.5%, `l8x38f384.c` 4.9%,
  `d2x1f480s240.c` 4.3%, `x16x19.c` 3.4%) to 1.6% slower, the median 0.05% faster.
- Huge (the claims at every size) against the faster of main and the head: ten units more than 2% slower, all of 53,105
  tokens or more, up to 12.4% (`h16x154.c`); base pages at every size: thirteen, all of 48,135 or fewer, up to 9.0%
  (`00204.c`, which they read on one lane). Each unit huge below a threshold T and base from T on leaves no unit more
  than 2% slower for 48,135 < T ≤ 53,105, and one at least for any other T; 48,640 (from B5) leaves the worst 1.4%
  slower.
- The eight-lane walks with every lane spread over the rounds by a median of 0.81 ns/token in huge pages with the claims
  (at most 7.40, `00213.c`, 460 tokens on five lanes: 3.4 µs) and 1.67 in base pages (at most 7.98, `b16x5.c`); #764's
  A5 had main's at up to 37.79.
- Source order (each process's first reading of its unit): the tree 0.6% faster than the head by the median (3.9% faster
  to 1.9% slower).

## Campaign E2: the claims' faults

`scripts/e2.sh`: six units, `new-f3ac8f15` with no unit large (the claims at every size), `main-d11a91d2` and
`new-f3ac8f15` as it is, by the rule on up to 8 lanes, 6 passes, a lock hold a unit: a process under `perf stat` and one
whose every page fault was recorded with its time and address (`perf record -T -e page-faults -c 1 -d`; `reports/e2/`,
kernel addresses masked). `scripts/disasm_ips.sh` read the instruction at every faulting address of the binaries' code
(`reports/e2/ops.txt`); `analysis/e2ops.py` takes a fault as a store when its instruction writes memory (its last
operand, a read-modify-write too, but compares and tests) and counts, for each run, the 2 MB regions at which more than
one thread took a store fault within 100 µs of the region's first, each at one 4 KB page there (a huge page's first
write; a thread that faults several pages of a region in that time is writing base pages). `tables/E2.md`
(`analysis/e2sum.py`) has the counters, `tables/E2-stores.md` the stores.

| Unit | Kernel Mcycles: claims, main | Regions two threads stored into at once: claims, main (threads past the first) |
| --- | --- | --- |
| `b16x77.c` | 99.6, 131.4 | 0, 4 (15) |
| `h16x77.c` | 120.5, 139.8 | 0, 5 (29) |
| `l16x38f384.c` | 100.4, 110.3 | 0, 3 (5) |
| `h16x154.c` | 199.6, 276.8 | 0, 7 (38) |
| `h16x10.c` | 34.4, 34.6 | 0, 0 |
| `l16x19f192.c` | 54.0, 54.5 | 0, 0 |

The claims' lanes' other faults in a region another thread faulted are loads (`movzbl (%rcx,%r12,1),%edx` in
`check_input_declaration`, a read of a byte column), which map the huge zero page and clear nothing; the claim's own
store is `mov %al,(%r10)` after its load. As it is, the four larger units' arenas are base pages, where each lane faults
its own 4 KB pages: `tables/E2-stores.md` counts their regions too, which are no race.

## Campaign SOI847: source order

`scripts/soi847.sh`, one lock hold: `benchmark-checker-deferred --lanes 1` (every reading on one lane, the same pages in
the three trees) under `perf stat` (user instructions and cycles), on four units, three processes of each tree in turn
(`logs/SOI847.txt`, `tables/SOI847.md` by `analysis/soisum.py`). Against #791's head, the tree's processes run the same
user instructions to 0.009% (from 0.009% fewer to 0.007% more, the claims' load and branch at each write among them),
their cycles 1.4% fewer to 0.6% more, and source order's reading 1.5% faster to 2.4% slower (`d16x19f384s288.c`, which
B7's 25 processes of each tree read within 0.1%).

## Campaign M7: main against main

`scripts/m7.sh`: `main-d11a91d2` and `main-bc11fddb`, each by its rule, on seven of the eight units B6 read more than 2%
slower than `bc11fddb` and three others (`00182.c`, `h16x1.c` and `sqlite3.c`; the script's comment says two), five
rounds, one lock hold a round (`logs/M7.txt`, `tables/M7.md` by `analysis/m7sum.py`). `d11a91d2` reads `00204.c` 13.8%
slower than `bc11fddb`, `00213.c` 11.9%, `00200.c` 7.8%, `sqlite3.c` 3.8% (5.2% on one lane, and in source order), and
the synthetic units from 1.0% faster to 2.4% slower. The two mains' merges between them are #754 (the sparse warnings
and the constants' values), #735, #752 and #756 (K&R definitions), #759 (SSE builtins), #800, #826, #790, #747, #729 and
#831; this record doesn't attribute the difference.

## Campaign A7: the lane rule's grid

`scripts/a7.sh`: `new-f3ac8f15` as it is, on 2, 3, 4 and 8 lanes with every lane (each process also reads the unit on
one lane), A2's 43 units, five rounds, 11 jobs a lock hold, a process a reading's lanes (cold; `logs/A7.txt`, 860 runs).
`analysis/grid3.py --full-precision` makes the grid (`tables/A7-grid.tsv`: each unit's change on each lane count against
the same processes' one lane, over the rounds; `tables/A7-grid-small.tsv` and `-large.tsv` the units below 48,640 tokens
and from it on), and `analysis/rule3.py`, #764's, fits the rule's constants on it: for each pair, each unit's lanes by
the rule, the gains it forgoes against each unit's best lane count summed in percentage points (5 to 7 lanes
interpolated between 4 and 8), and the worst unit's change on its lanes against one lane (`tables/fitA7.txt`,
`fitA7-small.txt`, `fitA7-large.txt`; `fitA7-rule.txt` each unit at both pairs; `fitA7-rounds.txt` each round apart).

| Units | 1,024 tokens and a quarter: forgone, worst, within a point | 1,280 and a third | Rounds the first does better |
| --- | --- | --- | --- |
| all 43 | 37.2, +0.9%, 28 | 51.7, +0.9%, 28 | 5 of 5 |
| the 31 below 48,640 tokens | 25.8, +0.9%, 20 | 38.4, +0.9%, 19 | 5 of 5 |
| the 12 from it on | 11.4, +0.0%, 8 | 13.3, +0.0%, 9 | 4 of 5 |

1,024 and a quarter are also the best pair of `rule3.py`'s grid for all 43 units and for the 31 below the threshold; on
the 12 large ones, pairs that give them more lanes still (128 and none of the top level's) forgo less, 5.2 points. The
change takes 1,024 and a quarter for every unit (`b179fad3`): it reads six of the twelve large units on more lanes than
1,280 and a third (`l16x38f192.c` and `l16x38f384.c` on 8 rather than 7, `d16x19f384s192.c` 8 rather than 6,
`d16x19f384s288.c` 6 rather than 5, `x16x38.c` 4 rather than 3, `x16x77.c` 7 rather than 5).

## Campaign B8: the final tree by its rule

`scripts/b8.sh`: `new-b179fad3`, `new-f3ac8f15`, `main-d11a91d2` and `pr791-d312b0a8`, each by its rule, on the twelve
units of 48,640 tokens or more and four smaller ones (`00204.c`, `h16x10.c`, `l16x19f192.c`, `d2x1f384s288.c`), five
rounds, 8 jobs a lock hold (`logs/B8.txt`, 320 runs; `tables/B8.md` by `analysis/b8sum.py`). The final tree reads the
sixteen from 1.7% faster than the faster of main and the head (`d2x1f384s288.c`) to 1.6% slower (`l16x38f384.c`), 0.1%
faster by the median; none more than 2% slower, four more than 1% (`l16x77f384.c` 1.0%, `h16x154.c` 1.1%,
`d16x19f384s192.c` 1.5%, `l16x38f384.c` 1.6%). Against `f3ac8f15`'s two pairs: from 1.8% faster (`x16x38.c`, four lanes
rather than three) to 2.2% slower (`d16x19f384s192.c`, eight rather than six), 0.3% slower by the median, where the
units whose lanes it leaves as they were differ by 1.5% faster to 1.7% slower between the two builds.

## Tests

- `test-checker-deferred` on the 9700X, a lock hold each (`logs/tests-new-*.txt`): `b2e2169e`, `f3ac8f15` and
  `b179fad3`, 135 fixtures, 3,034 checks (405 with the IDs in another order), 1,356 merged, 0 failures; `7a454554` 171
  failures, the fixtures with every unit large (its reader dropped `base_page_tokens` at its state's reset), fixed in
  `b2e2169e`.
- `test-checker-corpus --deferred 8` on `f3ac8f15` (`scripts/corpus.sh`, a lock hold each): c-testsuite's single-exec
  programs at `5c7275656d751de0e68b2d340a95b5681858ed07` with `--id-order 153` (220 accepted by clang and by the
  checker, 449 bodies, 0 differences), and the frozen `sqlite3.c` with `--symbols` (2,608 bodies, 0 differences, its
  symbols clang's but the one documented inlined function; `logs/checker-sqlite-new-f3ac8f15.tsv`).
- On the session's mini PC (`logs/local-tests.txt`): `test-checker` 511,750 checks, `test-checker-driver --executable`
  39,073 and `test-checker-deferred` 3,034 on `f3ac8f15`, and `test-checker-deferred` on `b179fad3`, 0 failures.
- The mutation checks, each mutant a copy of the commit's sources with one change undone, built at `-O1` on the mini PC,
  where `test-checker-deferred` must fail (`scripts/mutants847.sh`, `scripts/mutants847c.sh`, `logs/mutants-*.txt`). Of
  `b2e2169e`: no fault-in, 729 failures; base pages at every size, 729; one pair of constants, 1,192; the size knob
  ignored, 171. Of `f3ac8f15`: a claim that does nothing, 9; claims not given to the lanes' readers, 9; claims at every
  size, 108; base pages at every size, 729; one pair of constants, 1,192; the size knob ignored, 171.

## Limitations

- The benchmark reuses the caller's arenas from one reading to the next, so that its passes find the pages of the
  merge's stream, which the merge's lanes write into the caller's scratch, faulted in. In a process's one reading those
  pages are fresh huge pages, which lanes that meet in a region would each clear; nothing here measures that.
- The threshold and the claims' costs are the 9700X's, with transparent huge pages `always` (defrag `madvise`) on Linux
  6.18; a kernel that splits the huge zero page on a write would give a region that a load mapped base pages.
- The mutation checks and the local tests ran on the mini PC (AMD Ryzen 9 7940HS, Zen 4 with AVX-512), not on the 9700X.
- B6 was stopped after two rounds and compares against a main #791's branch no longer contains; its fault-in times are
  the tree's own.
- E2's store count reads each fault's instruction from the binary; a fault's own error code (read or write) isn't
  recorded by the page-fault event.
- The synthetic units are A2's, of one statement shape.
