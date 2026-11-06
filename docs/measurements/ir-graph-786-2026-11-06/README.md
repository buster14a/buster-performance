# The IR verifier's graph check, its type windows and the optimizer's verifications over placements, Buster #786

Compiler branch: `claude/magical-johnson-bs4q9x` of buster14a/buster, its pull request buster14a/buster#1570, for
[the claim on #786](https://github.com/buster14a/buster/issues/786#issuecomment-6692072182): the rest of #786's "Done
when" after #861 and #994. Before this work, on the 9700X, main ran `benchmark-ir`'s 262,144-instruction CFG row 9% over
#774's base and `benchmark-ir-optimize`'s phi-diamond, loop and jump-chain 5% to 10% over it, and the verifier's time
varied by up to 8% over the code's placements. This record holds the measurements of the change that answers it:

- **head1**: the verifier's graph phase checks 16 instructions' operand columns at a time (`ir_dominance_batch`), and
  only the lanes it can't decide (a forward use, a phi's or a call's operands, a failing lane) go to the exact
  per-instruction check (`ir_check_operands`), which is also the scalar twin; phis and switches are found 64
  operations at a time. Before, every operand was copied into ten batch arrays by a scalar loop.
- **head2**: head1, the rows check's operand types of a function of more than 128 instructions read by byte permutes
  of the 128 types that end with the batch and of the function's first 64, a load for the rest
  (`ir_operand_types`), and `ir_optimize_prepare` building the CFG and the use lists without verifying the function
  again (`ir_cfg_validated`, `ir_uses_validated`): it checked the shape and rows three times and the graph twice in
  each preparation.
- **head3**: head2, and `ir_optimize`'s AUTO path verifying with the vector twin at every size: its size bound
  (#860) picks the passes' twin alone.

## Sources and host

- **old:** `9bb5060ebe347de5c7a0a92ba325a7b14a567788`, #774's base, #786's reference;
- **main:** `ec5f0f6be04660d5b36ec688ba3d8ed3511ee85b`, the branch's base;
- **head1, head2, head3:** main with `head1.patch`, `head2.patch` and `head3.patch` applied (`receipts/patches.sha256`).
  head3's patch is the branch's source at its first push but for one line, `(void)verify_scalar;`, added after the
  runs for the scalar host's build, where `BUSTER_SCALAR_PATH` doesn't read its argument; it compiles to nothing.

Each tree is a worktree of a bare clone of buster14a/buster at that commit (`scripts/setup.sh`, `scripts/head.sh`),
built with `./build.sh shifts DIR main_unit_backend.c 0 640 1344 2048 2752 3456`: six links of the same objects, the
backend's unit (which holds both benchmarks and the code they run) that many bytes later, each a multiple of its
`.text`'s 64-byte alignment. `receipts/executables.sha256` gives every link's SHA-256, `receipts/revisions.txt` each
tree's commit and `receipts/host.txt` the host (AMD Ryzen 7 9700X, clang, perf, CPU 2's governor), captured after the
runs. Every build and every hold below took the host's lock (`exclusive.sh`), and every run was pinned to CPU 2. The
lock's waiting messages are taken out of the logs (`scripts/collect.sh`): its `exclusive.sh: waiting for the 9700X`
lines and the `title:`, `link:` and `pull request:` lines under them.

## The campaigns

Each campaign's outputs are under `logs/`, one file per run (`TREE-SHIFT-ROUND-BENCHMARK.txt`), and its log under
`logs/receipts/`.

- `c2/` (`scripts/bench.sh c2 3 old main head2 head3`): each link of the four trees running `benchmark-ir` and
  `benchmark-ir-optimize` once, three rounds; one hold of the lock per round (about a minute), the placements' order
  turning by round and the trees' by placement and round. This is the qualifying campaign.
- `c1/`: the same with head1 and head2 in place of head2 and head3, its first round only (stopped when head3 replaced
  head2): head1's and head2's attribution.
- `base/`: old and main at the first two placements of a first round, from an earlier `bench.sh` that took the lock
  once per placement, stopped for want of the lock's time; superseded by `c1/` and `c2/`, kept as it ran.
- `p2/` (`scripts/perf.sh`): `perf stat` of `benchmark-ir --instructions 32 --only vector|cfg|scalar` and
  `benchmark-ir-optimize --only scalar`, old, main and head3 at the six placements, one hold.
- `s1/` (`scripts/source.sh`): `benchmark-ir-source --only verify|verify-scalar|promote` on the frozen `sqlite3.c`
  with the 9700X workflow's options, main and head3, two placements, two rounds, one hold per placement and round. Old
  predates `benchmark-ir-source`.

`scripts/parse.sh` turns a campaign's outputs into rows (tree, placement, round, row, ns); `scripts/table.sh` and
`scripts/summary.sh` summarize them: each row's median over the rounds at each placement, then those placements'
median and spread (the largest over the smallest), and head's ratio to each reference at the same placement, its median
and its range over the placements.

## Old, main and head over placements

`c2/`, ns per IR instruction for `benchmark-ir` and per input instruction for `benchmark-ir-optimize` (21-pass
medians each), three rounds at each of six placements. Old has no AUTO path (#860 came after it).

| Row | Old | Spread | Main | Spread | Head | Spread | Head/old | Head/main |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 32 instructions: scalar verifier | 9.445 | 3.8% | 9.332 | 6.3% | 9.225 | 2.4% | −1.7% [−3.3%, +0.5%] | −0.7% [−5.4%, +0.8%] |
| vector verifier | 5.866 | 5.7% | 5.289 | 7.3% | 1.804 | 2.4% | −68.9% [−70.4%, −68.6%] | −65.7% [−68.0%, −65.1%] |
| uses | 10.853 | 4.1% | 9.842 | 4.1% | 6.634 | 3.8% | −38.3% [−40.6%, −36.8%] | −32.4% [−34.8%, −29.9%] |
| CFG | 1.683 | 9.9% | 1.500 | 16.3% | 1.488 | 2.2% | −11.7% [−19.1%, −10.4%] | −0.8% [−14.6%, +1.1%] |
| 262,144 instructions: scalar verifier | 8.790 | 5.3% | 8.582 | 3.1% | 8.108 | 1.4% | −7.6% [−9.0%, −5.3%] | −5.5% [−6.8%, −5.2%] |
| vector verifier | 5.604 | 7.8% | 5.101 | 4.7% | 1.269 | 1.1% | −77.2% [−78.2%, −76.5%] | −75.1% [−76.1%, −74.9%] |
| uses | 12.529 | 3.1% | 11.680 | 2.8% | 7.726 | 1.0% | −38.3% [−39.4%, −36.9%] | −33.8% [−35.1%, −33.3%] |
| CFG | 1.357 | 25.2% | 1.480 | 0.7% | 1.080 | 1.6% | −20.4% [−35.1%, −19.6%] | −26.9% [−27.6%, −26.1%] |
| small-dag, scalar | 58.746 | 7.3% | 59.487 | 7.3% | 47.681 | 2.1% | −19.0% [−22.1%, −18.1%] | −19.9% [−24.4%, −17.8%] |
| small-dag, vector | 60.293 | 5.9% | 60.197 | 5.4% | 44.785 | 3.8% | −25.7% [−26.8%, −24.6%] | −25.8% [−28.0%, −23.1%] |
| small-dag, auto | – | – | 59.444 | 5.6% | 39.368 | 3.1% | – | −34.1% [−37.0%, −32.1%] |
| large-dag, scalar | 31.739 | 4.6% | 32.368 | 2.3% | 24.331 | 6.4% | −23.2% [−25.7%, −18.9%] | −24.8% [−25.7%, −19.5%] |
| large-dag, vector | 32.924 | 4.5% | 32.867 | 4.4% | 23.288 | 8.4% | −29.5% [−30.4%, −24.5%] | −28.7% [−30.0%, −25.1%] |
| large-dag, auto | – | – | 32.331 | 2.5% | 19.261 | 7.0% | – | −39.7% [−42.7%, −38.0%] |
| phi-diamond, scalar | 150.916 | 4.9% | 168.841 | 5.6% | 133.337 | 1.8% | −11.8% [−13.9%, −8.8%] | −20.5% [−24.9%, −20.1%] |
| phi-diamond, vector | 168.147 | 2.2% | 183.906 | 4.8% | 147.208 | 3.4% | −12.5% [−14.3%, −9.8%] | −20.1% [−22.6%, −19.6%] |
| phi-diamond, auto | – | – | 168.763 | 5.7% | 125.150 | 1.9% | – | −25.4% [−29.6%, −24.9%] |
| loop, scalar | 133.305 | 2.6% | 146.459 | 4.2% | 116.136 | 2.2% | −12.6% [−15.1%, −11.2%] | −21.0% [−24.2%, −19.4%] |
| loop, vector | 159.507 | 2.4% | 171.102 | 3.6% | 138.483 | 2.8% | −12.8% [−14.3%, −10.8%] | −18.7% [−20.9%, −17.7%] |
| loop, auto | – | – | 146.461 | 4.3% | 108.631 | 2.0% | – | −25.7% [−28.7%, −24.3%] |
| jump-chain, scalar | 60.731 | 1.4% | 63.488 | 1.3% | 49.005 | 0.6% | −19.3% [−20.1%, −19.0%] | −22.9% [−23.4%, −22.5%] |
| jump-chain, vector | 138.098 | 3.0% | 148.582 | 1.9% | 132.274 | 4.7% | −4.2% [−9.8%, −3.2%] | −11.1% [−13.7%, −10.6%] |
| jump-chain, auto | – | – | 63.480 | 1.2% | 47.497 | 0.7% | – | −25.2% [−25.8%, −24.9%] |

Head is below old at the median of every row, and at every placement of every row but two of the 32-instruction scalar
verifier's (+0.1% at 2,752 bytes and +0.5% at 3,456): 106 of the 108 pairs. Against head2, head3 changes only the AUTO rows (small-dag −17.0%, large-dag −21.6%, phi-diamond −6.9%, loop
−6.7%, jump-chain −2.3%; the other rows' medians within −1.1% and +0.7% but large-dag's vector, +3.5%, its links'
placement apart).

## What each part did

`c1/`'s round at six placements, head1 (the graph check) and head2 (the type windows and the optimizer's preparation
as well), against old:

| Row | Head1 | Spread | Head1/old | Head2 | Spread | Head2/old |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 32 instructions: vector verifier | 1.789 | 2.3% | −69.6% | 1.799 | 2.8% | −69.5% |
| CFG | 1.481 | 15.8% | −11.9% | 1.484 | 4.4% | −11.6% |
| 262,144 instructions: vector verifier | 1.655 | 22.9% | −70.4% | 1.252 | 0.7% | −77.7% |
| uses | 8.220 | 0.5% | −34.1% | 7.704 | 0.5% | −38.2% |
| CFG | 1.477 | 2.5% | +8.6% | 1.070 | 1.6% | −22.3% |
| small-dag, scalar | 55.075 | 3.9% | −5.9% | 47.061 | 4.1% | −19.2% |
| large-dag, scalar | 27.023 | 3.2% | −14.9% | 24.520 | 0.5% | −23.4% |
| phi-diamond, scalar | 162.055 | 5.1% | +7.3% | 135.240 | 3.9% | −10.3% |
| loop, scalar | 140.537 | 1.5% | +5.5% | 118.561 | 5.2% | −10.6% |
| jump-chain, scalar | 62.082 | 1.6% | +2.3% | 48.501 | 2.9% | −19.8% |

The graph check alone takes the vector verifier from about 5.6 to 1.7 ns per instruction; the type windows take the
large function's CFG row from old's +8.6% to −22.3% and its verifier from 1.655 to 1.252; the optimizer's single
verification per preparation takes its small functions from up to +7.3% over old to 10% to 20% under it.

## Zen 5's counters

`p2/`: user-space `perf stat` of whole processes at the six placements (the events multiplexed, 82% duty; the ratios
below are each run's own, averaged over the placements, the op-cache miss rate with its range over them). A run
includes the benchmark's validation and calibration.

| Run | Tree | IPC | Taken branches per 1,000 instructions | Op-cache misses | Dispatch slots the front end left empty |
| --- | --- | ---: | ---: | ---: | ---: |
| CFG, 32 instructions | old | 6.44 | 69.2 | 5.16% [3.30%, 5.89%] | 0.21% |
| CFG, 32 instructions | main | 5.53 | 68.6 | 4.84% [4.64%, 5.80%] | 2.84% |
| CFG, 32 instructions | head | 5.90 | 74.5 | 6.00% [5.92%, 6.07%] | 0.12% |
| scalar verifier, 32 | old | 6.41 | 109.1 | 9.56% [8.66%, 9.93%] | 21.54% |
| scalar verifier, 32 | main | 6.57 | 96.6 | 2.52% [1.82%, 3.17%] | 9.91% |
| scalar verifier, 32 | head | 6.52 | 93.6 | 8.39% [7.95%, 8.90%] | 15.89% |
| vector verifier, 32 | old | 6.11 | 124.3 | 9.95% [8.60%, 10.51%] | 26.05% |
| vector verifier, 32 | main | 6.39 | 107.5 | 4.37% [2.64%, 6.08%] | 12.38% |
| vector verifier, 32 | head | 6.17 | 76.3 | 7.02% [6.92%, 7.16%] | 0.09% |
| optimizer, scalar | old | 4.87 | 105.4 | 20.00% [19.40%, 21.00%] | 33.87% |
| optimizer, scalar | main | 4.91 | 98.6 | 20.85% [20.69%, 21.11%] | 33.57% |
| optimizer, scalar | head | 5.06 | 96.0 | 21.41% [21.24%, 21.63%] | 31.74% |

In head's vector verifier the front end leaves almost no dispatch slot empty (0.09%, against main's 12.4% and old's
26.1%), it retires 76 taken branches per 1,000 instructions against main's 108 and old's 124, and its op-cache miss rate
stays within 6.92% to 7.16% over the placements (main 2.64% to 6.08%, old 8.60% to 10.51%). The optimizer stays
front-end bound in all three trees (32% to 34% of the slots empty, 20% to 21% op-cache misses): that is its passes'
code, which this change doesn't touch. The scalar twin's front end, whose code this change rearranges, leaves 15.9% of
its slots empty, between old's 21.5% and main's 9.9%, at about main's speed.

## The frozen `sqlite3.c`

`s1/`: `benchmark-ir-source` on the frozen `sqlite3.c` (2,602 functions, 396,755 typed entries, 599,254 lowered IR
instructions) with the 9700X workflow's options, main and head at 0 and 1,344 bytes, two rounds: the mean of the four
runs' 21-pass medians and their range, ns per typed entry, and the instructions per typed entry.

| Variant | Main | Head | Head/main | Instructions per entry, main → head |
| --- | ---: | ---: | ---: | ---: |
| `verify` | 21.14 [20.93, 21.26] | 11.59 [11.54, 11.67] | −45.2% | 330.9 → 180.8 |
| `verify-scalar` | 20.04 [19.79, 20.27] | 19.53 [19.48, 19.58] | −2.5% | 431.6 → 445.1 |
| `promote` (`ssa_ir_promote`, whose result it verifies with dominance) | 142.16 [141.39, 143.23] | 127.22 [126.04, 128.29] | −10.5% | 2,220.7 → 1,943.4 |

On real functions, where phis and calls are common, the vector verifier takes 45% less time and 45% fewer
instructions; its scalar twin is about as before.

## What it shows, and what it doesn't

- `benchmark-ir` and `benchmark-ir-optimize` are at or below old on the 9700X: below at the median of every row, and in
  106 of the 108 pairs of a row's placement (the 32-instruction scalar verifier at two placements, +0.1% and +0.5%).
- The verifier's and the CFG builder's times are alike over these placements: head's spreads are 1.1% to 2.4%,
  against old's 3.8% to 25.2% and main's 0.7% to 16.3%. The vector verifier's hot loops are straight-line vector code
  with few taken branches, whose front end keeps up wherever the code falls. The optimizer's rows spread 0.6% to 8.4%.
- The scalar twin's own speed barely moves at 32 instructions (−1.7% against old, −0.7% against main): its rows
  check is the per-instruction oracle, unchanged. Since head3 the optimizer's AUTO path no longer runs it.

## Limitations

Three rounds per placement, six placements, all moving the backend's code by whole lines; one host. The synthetic
benchmarks' functions are #131's generator's; `s1/` is the one real corpus, against main only. The counters are of
whole processes, multiplexed. The host receipts were captured after the runs.
