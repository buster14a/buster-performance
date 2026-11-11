# main.c's `-c` cycles after #2112, Buster #2270

Compiler issue: [#2270](https://github.com/buster14a/buster/issues/2270), the follow-up of
[#2112](https://github.com/buster14a/buster/pull/2112) (#1979), whose record is
[`asm-label-merge-1979-2026-11-11`](https://github.com/buster14a/buster-performance/pull/398): `-c` of the compiler's
own `main.c` took about 0.6% more user cycles with the same instructions at six placements of the checker's unit, and
its peak resident set read about 1.5 MB higher.

Frozen sources, as there: base `d43c37e51` (main), head `fa777691b` (the PR before its merge of main). Both built with
`BUSTER_DEBUG_INFO=0 ./build.sh` (Release, native, parallel native generation), giving the same executables as #398's
(`host.txt`: SHA-256 `cf708ca3…` and `cbb57ede…`).

## Host and method

The Ryzen 7 9700X (`benchpress`), CPU 2 (`taskset -c 2`), THP `always`, Linux 6.18.50, clang 23.1.1, perf 7.2.9
(`host.txt`). Input: `-c -march=native -I head/src -fwrapv -funsigned-char head/src/buster/compiler/main.c -o /dev/null`
for every build. Every build and every measured process ran under `exclusive.sh`, the lock taken per build or per batch
of a few rounds (each hold under a minute), never around the series (`scripts/campaign.sh`, `scripts/campaign2.sh`).

1. **Counters** (`scripts/pstat.sh`, `c1-pstat.tsv`, `pstat-summary.tsv`): `perf stat` of base and head, nine rounds,
   four event groups each, one process per group, order alternating. Groups 1 to 3 have six hardware events and were
   multiplexed (83% of the run, scaled by perf); group 4 has five and ran whole.
2. **Stages** (`scripts/stages.sh`, `stages/`, `stages-summary.tsv`): `--time-stages`, twelve runs each.
3. **Profile** (`scripts/record.sh`, `record/`, `record-diff.txt`): `perf record -e cycles:u -c 200003`, three runs
   each, cycles by function, `NAME.buster_split` aliases folded into `NAME`.
4. **Arena shifts** (`scripts/arena-shift.patch`, `scripts/rebuild-s.sh`, `scripts/shiftrun.sh`, `shift1.tsv`,
   `shift-summary.txt`): an experiment-only patch to `lane.c`'s `arena_reserve_policy`. `BUSTER_ARENA_SHIFT=SEED`
   (1 or more) starts every arena of 1 GiB or more a pseudo-random multiple of 64 bytes below 4 KiB past its base, a
   different one per reservation and seed (its pushes start past it; its pages and huge-page layout are unchanged). Seed
   0 is the unpatched layout. Base and head with the patch (`base-s`, `head-s`) give the same object bytes as the
   unpatched builds at seeds 0, 1, 2 and 5 (`verify-s.out`). The first version, which shifted every arena, failed with
   "out of memory": some smaller arenas are pushed to their exact capacity (`verify-s-first-patch.out`). Eight seeds
   (0 to 7), six rounds, five hardware events, no multiplexing.
5. **Placements of the checker's own code** (`scripts/build-o.sh`, `scripts/offstat.sh`): #398's `./build.sh shifts`
   pads `main_unit_checker.c`'s `.text`, which doesn't move `.text.buster_checker`, the page-aligned section that holds
   the checker's own code (`c_check_program*.c`, `c_checker_driver.c`, `c_check_input.c`, …; `main.c`, #1233), and
   that code is what #2112 changed. So base and head were each built at eight offsets of that section
   (`BUSTER_BUILD_DEFINES=-DBUSTER_CHECKER_OFFSET=N`, N = 0, 16, 32, 48, 1040, 2080, 3120, 4032, docs/profiling.md's
   recipe; a full single-compile build per offset; at N = 0 every function is at the default build's address). Timed
   two ways:
   - `compiler ab --rounds 3` of `time-runs --runs 2 --copies 2` over the sixteen executables, offsets as placements
     (`ab-offsets.log`);
   - `perf stat`, six rounds, five hardware events, no multiplexing (`off.tsv`, `offsets-perf-summary.txt`).

`function-moves.txt` counts how far each function moved from base to head.

## Results

### The counters, one placement (the default builds)

Medians of nine processes per event (36 for user cycles), head against base (`pstat-summary.tsv`, ranges there):

| event | base | head | head vs base |
| --- | ---: | ---: | ---: |
| user cycles | 3,311.7M | 3,326.8M | +0.46% |
| instruction cache misses (`ic_tag_hit_miss.instruction_cache_miss`) | 203.0M | 214.5M | **+5.65%**, ranges disjoint |
| dispatch slots empty, front end (`de_no_dispatch_per_slot.no_ops_from_frontend`) | 4,981M | 5,241M | **+5.21%**, ranges disjoint |
| dispatch slots stalled, back end | 10,812M | 10,728M | −0.78% |
| L2 requests, no prefetch | 162.7M | 165.6M | +1.84% (the extra instruction fetches) |
| L1 ITLB misses, L2 TLB hits | 5.40M | 5.59M | +3.6% |
| L1d load misses | 98.7M | 99.8M | +1.1% (multiplexed) |
| L1 DTLB misses | 3.38M | 3.41M | +1.0% (multiplexed) |
| store-to-load misses (`ls_bad_status2.stli_other`) | 46.9M | 47.0M | +0.1% |
| demand fills from beyond L1d | 45.49M | 45.54M | +0.1% |
| kernel cycles | 317.9M | 318.1M | +0.05% |
| page faults | 19,051 | 19,051 | 0 |

The extra cycles are the front end's: about 260M more empty dispatch slots (about 32M cycles at Zen 5's eight slots,
1%) with 11.5M more instruction cache misses, partly offset by fewer back-end stalls. Data-side counters move by about
1% or less, and page faults not at all.

`--time-stages` (twelve runs each, `stages-summary.tsv`): total +3.3 ms (+0.51%), spread over the checker's stages
with both signs: check-input +1.16 ms, check-program +1.14, check-declarations +1.01, lower.prepare +0.82, select
+0.53; check-expressions −0.47, preprocess −0.58 (its lexer −0.26). The profile (`record-diff.txt`) agrees: the
difference is spread over dozens of the checker's functions, each a few million cycles up or down
(`check_init_walk` +8M, `pp_spelling` +8M, `check_literal_number_plain` +6M, `check_program` +5M against
`check_action_scalar` −10M, `tokenize_c_raw_no_separators` −6M, …), no one new piece of work. Code moved: 3,690 of
the 9,717 functions with unique names start at another offset in their cache line in the head
(`function-moves.txt`).

### Arena shifts: data layout doesn't change the sign

Eight arena layouts, head against base, medians of six processes each (`shift-summary.txt`):

| seed | user cycles | instruction cache misses | front-end empty slots |
| ---: | ---: | ---: | ---: |
| 0 (unshifted) | +0.63% | +8.92% | +2.09% |
| 1 | +0.33% | +8.77% | +2.44% |
| 2 | +0.10% | +8.89% | +2.48% |
| 3 | +0.43% | +9.31% | +2.53% |
| 4 | +0.31% | +9.24% | +2.55% |
| 5 | +0.31% | +8.75% | +2.85% |
| 6 | +0.23% | +9.47% | +3.19% |
| 7 | +0.43% | +8.63% | +2.40% |

The head stays slower at every arena layout, with the same instruction cache misses: the gap isn't the arenas' data
layout (`CheckProgram`'s new fields or the new pass's allocations moving arena offsets). Store-to-load misses move
both ways by up to 3% with the seed; base's spread over seeds is 4.7% there.

### Placements of the checker's own code: the sign flips

`perf stat`, six processes per executable (`offsets-perf-summary.txt`), head against base at each offset:

| offset | user cycles | instruction cache misses | front-end empty slots |
| ---: | ---: | ---: | ---: |
| 0 | +0.82% | +6.85% | +8.12% |
| 16 | +0.65% | +1.08% | −0.16% |
| 32 | +0.50% | −1.69% | −2.66% |
| 48 | +0.79% | +2.89% | +0.85% |
| 1040 | −0.11% | +2.22% | −1.10% |
| 2080 | −0.50% | +2.86% | −1.38% |
| 3120 | −0.26% | +3.71% | −1.63% |
| 4032 | +0.38% | +6.34% | +5.68% |

Over the eight offsets: user cycles −0.50% to +0.82% (median +0.44%); base's own offsets spread its cycles by 0.61%,
its instruction cache misses by 7.1% and its front-end empty slots by 4.5%, the head's by 1.13%, 6.0% and 8.0%.
Instructions: head +0.01% at every offset (these single-compile builds).

`time-runs` under `ab` (`ab-offsets.log`), user cycles, head against base, each placement's median of four processes:

| offset | round 1 | round 2 | round 3 |
| ---: | ---: | ---: | ---: |
| 0 | +0.16% | +0.62% | −0.06% |
| 16 | +0.19% | +0.12% | +0.05% |
| 32 | −0.13% | +0.14% | −0.49% |
| 48 | +0.17% | +0.06% | −0.12% |
| 1040 | +1.47% | +0.76% | +1.54% |
| 2080 | −0.36% | +0.38% | −0.01% |
| 3120 | −0.16% | +0.00% | −1.05% |
| 4032 | +0.38% | +0.30% | +0.58% |
| over the offsets | **+0.09%** | **+0.33%** | **+0.10%** |

`ab`'s wall time over the offsets: +0.02%, +0.37%, −0.03%. Base's offsets spread its user cycles 0.94% to 1.42% per
round, the head's 0.54% to 1.33%.

The two methods disagree at single offsets (1040: +1.5% under `time-runs`, whose copies of each executable get their
own physical pages, against −0.1% under `perf stat` of the one file), as docs/profiling.md's floors say the physical
pages of the code move a build by up to 0.3 to 0.6%.

### Resident set

No difference. #398's own logs show the wait4 peak bimodal in both builds: about 1,175.7 MB (19,335 to 19,340 minor
faults) or about 1,177.3 MB (19,211 to 19,219 faults, about 120 fewer: one more 2 MB huge page in place of base
pages). Base took the high mode in 13 of 45 and 29 of 108 of #398's runs, the head in 7 of 45 and 30 of 108; here
(`ab-offsets.log`) both in exactly 29 of 96. #398's "head about 1.5 MB higher" compared one median from each mode.
`perf stat`'s page faults are 19,051 for both (medians), and `--time-stages`' peak added by each stage is the same
within 0.25 MB (check-program 114,844 KB against 115,096 KB, emit-setup 2,600 against 2,448, every other stage within
64 KB).

## Reading

The 0.4 to 0.6% of user cycles at the default builds' placement is the front end: 5 to 6% more instruction cache
misses and 5% more empty dispatch slots, with the same instructions, the same data-side misses and the same page
faults. It is a layout artefact of the checker's own code, which #2112 changed and #398's `shifts` didn't move: across
eight offsets of `.text.buster_checker` the head's difference ranges from −0.50% to +0.82% (`perf stat`, negative at three
offsets) and −1.05% to +1.54% (`time-runs`, negative at none to five offsets per round), against each build's own spread
over the offsets of 0.6 to 1.4%; at offset 0 (the default builds' layout) `perf stat` reads +0.82%. Moving the arenas' data (eight layouts) doesn't change it, so the suspects about arena
offsets (`CheckProgram`'s larger struct, the new pass's allocations) aren't the cause.

What is left over the offsets is +0.09%, +0.33% and +0.10% (`time-runs`, three rounds) and a median of +0.44%
(`perf stat`, six processes per offset, mean +0.28%): smaller than either build's spread over the offsets and, under
`time-runs`, about the 0.2% that docs/profiling.md says three rounds resolve. It isn't distinguishable from zero here,
nor shown to be zero. A small real front-end cost from the checker's larger code
(`check_program` and the selection have new branches; the new pass is in the same section) can't be excluded at that
size; no source change is indicated by these counters. The resident-set difference isn't one.
