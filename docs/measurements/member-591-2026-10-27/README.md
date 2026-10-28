# Member-lookup indices: completed 9700X qualification

Evidence for Buster #591 / PR #648. The previously queued A/B, scaling, stage and lookup-benchmark campaigns all
completed successfully on October 27, 2026 (`queue.log`). They ran on benchpress, Ryzen 7 9700X, Clang 23.1.1,
under the ordinary shared host lock. Each recorded campaign used CPU 2. This publication retains completed runs;
it does not claim a new measurement of later integrated PRs.

## Identities and reproduction

Whole-compile/stage/scaling comparisons use main `92c025e71856d13eb34247477c5294d2cead139e` versus
`7a0597bf60f611f4a76864bf4130c0502af81ca1`, built with `BUSTER_DEBUG_INFO=0 ./build.sh` (`-O3 -march=native`).
The isolated lookup benchmark uses `3e0070f215632eb01150d8c92b6d549a807500f9`; its only differences from the measured
implementation are the separately linked type-benchmark unit and AGENTS documentation. `source-*-git-tree.txt`
retain every Git blob identity for these source trees. `identities.txt` records compiler/input/object SHA-256 hashes.

The frozen SQLite source is `preprocessor-391e729af658/sqlite/sqlite3.c`, SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. Compile options are
`-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE` and its directory
as an include path. All compared SQLite objects are byte-identical, SHA-256
`0c48ff92978c3125b1822a1552eb48d2742ea09d80176488d8dc5320c4afe91f`.

`ab-sqlite.sh` runs eight alternating rounds of each tree's `-c` and `-fsyntax-only`, with `perf stat -r 3` per
observation. `summarize.py ab1` reports raw medians and within-round differences. `stages.sh` retains 15 alternating
stage reports per tree in `stages1/`. `scaling.sh` measures the original generated sources in `units/`; `gen.py`
reproduces them. `bench-types.sh` runs the isolated lookup/build benchmark twice. Scripts retain their original
working-directory assumptions. No external SQLite code or generated object is incorporated here.

## Whole compile and representation costs

| SQLite measurement | main | indexed lookup |
| --- | ---: | ---: |
| task clock, eight perf-round medians | 147.135 ms | 145.660 ms |
| user cycles | 695,422,993 | 686,175,878.5 |
| user instructions | 1,552,458,575 | 1,534,564,481 |
| check-input, 15 stage-run medians | 64.000 ms | 63.740 ms |
| check-expressions, 15 stage-run medians | 15.799 ms | 15.381 ms |
| lowering, 15 stage-run medians | 15.974 ms | 15.034 ms |
| peak process RSS, 15 stage-run medians | 512,908 KB | 516,968 KB |

The median paired task-clock change is -0.94% (each round -1.26% to -0.55%); paired user cycles -1.20% and
instructions -1.15%. The syntax-only path's paired median is -0.66% task clock (-1.08% to +0.31%), so not every
individual syntax-only observation improves.

**RSS increases by 4,060 KB (0.79%) on this workload.** The lookup table reserves one 64-byte bucket per member
capacity by default, while `CheckStream.member_offsets` reserves eight bytes per graph-node capacity, including
non-member nodes. The sparse fallback and record-modifiability sets also reserve index/frame storage based on table
capacity, though they clear/touch only visited entries. Virtual reservation, actual written pages and peak resident
memory are distinct costs. This PR reduces repeated lookup work; it does not claim a memory reduction or assume
that #617's independently measured savings cover these costs.

## Scaling and the kernels

| Whole `-c`, three perf repetitions per point | main task clock | indexed task clock |
| --- | ---: | ---: |
| 500 records | 15.97 ms | 15.36 ms |
| 8,000 records | 399.45 ms | 211.41 ms |
| one record, 2,500 members | 10.10 ms | 5.29 ms |
| one record, 40,000 members | 1,282.43 ms | 51.39 ms |

The 16-fold member-input growth increases candidate whole-compile time by 9.7 times and baseline time by 127 times.
For many records the same 16-fold growth increases candidate whole time by 13.8 times. Raw intermediate points and
syntax-only measurements remain in `scale1/`; these are complete compilations, not a proof of constant hash-probe
cost under arbitrary collision or anonymous-record depth.

The two isolated lookup runs give 9.907/9.920 ns per access for the masked scan/bucket probe, 18.923/18.938 for its
scalar twin, 36.028/36.029 for the old walk, and 3.251/3.257 ns per member to rebuild every index. The benchmark first
checks agreement; all construction, allocation and later consumer costs remain charged to the whole-compile
measurements above. Construction remains scalar and preserves declaration-order first matches. No unmeasured
claim that batching construction or caching anonymous-child counts must lose is made.

## Structural regression and review footprint screen

The local original `no_scratch_probe.c` uses the actual indexed action helper and the exact pre-#591 helper excerpt
from `92c025e7` (`before_helper.c`, function renamed only by a macro). With 512 unrelated pointer types and zero
remaining thread scratch, both current paths find the member; the old helper reports resource exhaustion.
`no-scratch-result.txt` retains the successful AddressSanitizer/UndefinedBehaviorSanitizer run. Reproduce from the
candidate compiler checkout with:

```sh
clang -O1 -g -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -fsanitize=address,undefined \
  PATH/no_scratch_probe.c -lm -pthread -o probe
./probe
```

The corresponding production-suite regression is independent of the generous wall-clock scaling bound that the
old many-types case can pass.

`cost_inputs.c` generates original no-member and 64-level anonymous-record inputs. `cost_review.c` runs those,
the 40,000-member input and the 8,000-record input on four lanes, holding the host lock separately for every compile
and retaining process RSS/stages. That additional footprint screen is in progress at this publication checkpoint;
it is not needed to reinterpret the retained positive/negative observations above. Its results will be appended
before this record and PR #648 are declared ready.
