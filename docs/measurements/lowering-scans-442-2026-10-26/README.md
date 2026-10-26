# The `-c` path after checking: #418's cost, attributed and removed (#442), 2026-10-26

Buster issue [#442](https://github.com/buster14a/buster/issues/442) asked where
[#418](https://github.com/buster14a/buster/pull/418)'s remaining cost on the work `-c` does after checking went, and
for it to be removed or explained. This record compares main just before #418's merge, the merge, main when the work
started and the change that #442's work made, on the same harness, then attributes the cost by stage, by profile and by
ablation. It is cited by Buster's `docs/c-lowering.md` ("Whole-unit passes after checking").

**This is not 9700X evidence.** The session that made it ran in a cloud container on an Intel Xeon, without the
9700X, its shared lock or hardware counters (`manifests/host.txt`, `manifests/host-second.txt`). Its times are this
host's, and its smaller differences are within what this host's noise and the builds' code placement move
(below, "Limitations"). The large ones repeat on two hosts, in every round. The 9700X record #442 asks for is still to
be made; `scripts/` makes it there (below, "Reproducing").

Three comparisons, kept apart:

- **#418 against main** (`pr` against `main`): what #418's merge costs on the same work.
- **#442 against main** (`new` against `main`, and against `head`): what this work's change costs or saves.
- **Selective against `--lower-all` within one tree** is `benchmark-lowering-source`'s question, not this record's.
  Nor is the whole compiler's time: every number here is the post-checking path alone, checking outside the time.

## Sources and trees

| Tree | Buster commit | What it is |
| --- | --- | --- |
| `main` | `3bfb4a72a51f4a7872090905d52f92b95b3e1375` | main just before #418's merge (the merge's first parent; #442's `4f4a0bfa` and 21 commits after it) |
| `pr` | `54703dcf6607ecc1c7267869e46e59ab225ab393` | #418's merge |
| `head` | `7e3782ada38379f972f244a5f6b89ed0b2d4ed4a` | main when #442's work started |
| `scans` | `dd8b22b2f2437ebf602f45fa93ef0daebcf8e547` | #442's first commit on `head`: the whole-unit scans and the ABI rows |
| `new` | `cb935a7aa1406db7e23457b557ae27cba4b91514` | #442's change: `scans` and the made names' table for dotted asm labels alone |
| `pr_emit` | `pr` with `main`'s `c_check_program_emit.c` | ablation: #418's naming undone |
| `pr_select` | `pr` without #418's body-to-block-static edges (`scripts/ablate_edges.py`) | ablation: the selection's new edges undone |

Each tree is `git archive` of its commit with `scripts/emit_ab.c` added as `src/buster/compiler/emit_ab.c` and
registered by `scripts/register.py` (`scripts/build-trees.sh` makes them all). This host has no AMD `mwaitx`, which
`main`'s and `pr`'s `lane.c` used unguarded (main has guarded it with `__MWAITX__` since), so those two trees' `lane.c`
has the shim `build-trees.sh` adds with `SHIM=1`; `lane_wait` isn't on the measured path. `manifests/source-*.sha256`
lists every file of each tree so made, and `manifests/trees.txt` each manifest's SHA-256 and each executable's. Each
tree was built with `BUSTER_DEBUG_INFO=0 ./build.sh` (clang 23.1.5); `headg` and `newg`, for the profiles, are `head`
and `scans` built with debug info.

The input is c-testsuite's `tests/single-exec/*.c` at commit `5c7275656d751de0e68b2d340a95b5681858ed07`
(`manifests/c-testsuite.sha256`): 220 programs, all of which every tree lowers. 216 lower to the same counts and object
sizes in every tree; 00150, 00182, 00208 and 00216 don't (`logs/floor-differing-files.txt`), by design: #418 names
the local symbols it makes as clang does (`.compoundliteral`, `function.name`, where main wrote `.Lbuster_compound_N`),
and 00208's unreferenced block-scope static is lowered, as clang emits it. Beside them, `scripts/synthetic.py` makes
eight units of 200 and 2,000 definitions that stress the made names: block-scope statics, the same with an asm label
taking every made name first, file-scope compound literals, and plain functions and globals.

## The harness

`scripts/emit_ab.c` is buster-performance's `lowering-emit-418-2026-10-25` harness with each run split by stage.
Each file is checked as the driver checks it, outside the time. Then each of `--passes` (101) passes times the driver's
selection (`check_program_select`), the emission (`check_program_emit`: lowering, Tier 0, branch sizing, encoding and
the link's code), the static data's publication (`check_data_publish`) and the object (`link_check`,
`object_prepare`, `object_map_symbols`, `object_build`), with the arenas put back after each run, and every run must
lower its warm-up's counts and object bytes. The stages are read from the TSC (calibrated against
`CLOCK_MONOTONIC_RAW`), the whole from `CLOCK_MONOTONIC_RAW`. It prints each file's median and minimum per stage, then
their sums.

`scripts/rounds.sh` runs the trees in rounds whose order rotates, each run pinned to CPU 2 (`taskset -c 2`), the host
otherwise idle. This host's speed shifts by up to half for stretches of a run (a file's runs sit at about 7.7 or about
11.5 µs, `logs/rounds-four-trees-dd8b22b`), which decides a round's per-file medians more than the trees do. So the
results below are each file's **floor**, its least per-run minimum over every round (`scripts/floor.py`), summed:
the trees in the host's fast state. The medians, paired rounds and per-file quantiles are in `logs/analysis-*.txt` and
`logs/distribution-*.txt` (`scripts/analyze.py`, `scripts/distribution.py`); they agree in direction, with more noise.

## Results

c-testsuite, the sum of the 220 programs' floors, on the first host (`logs/rounds-four-trees`, 6 rounds of 101
passes) and on the second (`logs/rounds-four-trees-second-host`, 6 rounds, after the session's container moved):

| Subset | Stage | `main` (ns) | `pr` | `head` | `new` | `new`, second host |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| all 220 | total | 4,310,181 | +4.9% | +4.9% | **−25.5%** | **−24.8%** |
| | selection | 740,140 | +7.4% | +5.4% | −54.7% | −53.6% |
| | emission | 3,332,593 | +4.5% | +5.0% | −20.2% | −19.7% |
| | publication | 53,991 | +1.3% | +2.9% | −3.1% | |
| | object | 125,311 | +1.3% | +5.0% | +1.9% | |
| same output, 216 | total | 3,977,392 | +4.5% | +4.1% | −25.2% | −24.7% |
| output differs, 4 | total | 332,789 | +9.4% | +14.2% | −28.8% | −26.0% |
| under 300 tokens, 154 | total | 907,551 | +4.3% | +6.4% | +4.0% | +1.7% |
| 300 to 3,000 tokens, 20 | total | 558,688 | +4.4% | +1.8% | −36.5% | −37.0% |
| 3,000 tokens or more, 46 | total | 2,843,942 | +5.2% | +5.0% | −32.7% | −31.1% |

(The second host's `pr` against `main` was +4.6% overall and +1.5% under 300 tokens; `logs/floor-four-trees-second-host.txt`.)
Per file, `new` against `main` (the medians over rounds of each run's minimum): p10 −45.1%, p25 −28.3%, p50 +1.9%,
p75 +4.2%, p90 +6.0%; `pr` against `main`: p10 −0.4%, p50 +2.8%, p90 +6.2% (`logs/distribution-four-trees.txt`).
Every paired round of `new` against `main` is faster, by 23 to 28% on the first host and 20 to 27% on the second
(the sums of each run's per-file minima).

The synthetic units (`logs/floor-synthetic.txt`, 4 rounds), against `main`:

| Unit | `pr` | `head` | `scans` | `new` |
| --- | ---: | ---: | ---: | ---: |
| statics, 200 / 2,000 | +2.8% / +4.4% | +19.6% / +10.9% | +10.9% / +5.1% | +3.6% / +2.8% |
| collisions, 200 / 2,000 | +15.8% / +8.0% | +13.4% / +13.2% | +5.4% / +6.0% | +3.7% / +5.0% |
| literals, 200 / 2,000 | +4.5% / +5.8% | +11.4% / +11.0% | +9.6% / +1.9% | −1.0% / +1.8% |
| plain, 200 / 2,000 | −0.1% / +1.7% | +8.5% / +9.2% | −0.1% / +0.2% | +2.1% / +0.2% |

Each synthetic unit but the plain ones writes other names than `main`'s (longer ones: `function.name`, `.N`), so
the same work is the plain units'.

## Where the time went

**Whole-unit passes.** A profile of `head` (`profiles/`, `scripts/sampler.c`, an `LD_PRELOAD`ed sampler on a 100 µs
`CLOCK_MONOTONIC` timer, as this host has no PMU and valgrind decodes no AVX-512) on 00200 (23,430 tokens, 2 functions)
puts most of the path's time in passes over every token of the unit, most of them its headers', none of them
#418's (`profiles/headg-00200.lines.txt`):

- the selection's loop over every token for declarations (`c_check_program_select.c:109-112`) and its numbering of
  the needed objects over every object (`325-339`): 14% of the process's samples;
- the emission's three loops over every token (`c_check_program_emit.c:217-231`, `292-295`): 11%;
- the lowering's loop over every token (`c_check_program_lower.c:4443-4450`);
- `abi_initialize`'s `memset` of 13 bytes per type of the type table's **room**, which the checker sizes at four
  times the unit's tokens, though the unit has far fewer types: 7.4% (`profiles/headg-00200.functions.txt`).

A unit's cost in these grows with its tokens, which is why the per-file excess of `pr` grows with them too (+4.3%
under 300 tokens, +5.2% from 3,000).

**#418's own cost**, by ablation on the second host (`logs/floor-ablation.txt`, 6 rounds of `main`, `pr`,
`pr_emit`, `pr_select`):

| Stage | `pr` | `pr_emit` | `pr_select` |
| --- | ---: | ---: | ---: |
| total | +3.9% | +2.4% | +6.0% |
| selection | +5.8% | +6.9% | +7.6% |
| emission | +3.1% | +1.2% | +5.4% |

- The selection's excess is not its new edges: `pr_select`, without them, is no faster. #418 made
  `check_program_select` `check_program_select_mode`, and the per-token loop's code changed with it; its excess
  grows with the tokens, as that loop's time does. `scans` removes that loop.
- About two thirds of the emission's excess is `c_check_program_emit.c`'s (`pr_emit` takes it back): on the units
  that make no name, the code of the per-token loops around #418's naming, which `scans` removes; on those that make
  one, the made names' table (the synthetic units). The rest, about 1%, isn't attributable at this host's
  resolution.
- Generated-name work itself is small where few names are made (00150: +127 ns of 11,785), and per symbol where
  many are: `pr`'s emission takes 287 µs more than `main`'s on `collisions-2000`, about 50 ns for each of its 6,001
symbols, whose 2,000 made names each collide with an asm label. `new`
  puts only the given names that could be a made name, asm labels with a `.`, in the table (every made name has one,
  and no identifier does), which takes `statics-200` from +10.9% to +3.6% and `literals-200` from +9.6% to −1.0%
  against `main`.

**What remains** on the smallest units (+1.7 to +4.0% against `main` under 300 tokens, where `head` is +5.4 to +6.4%):
those units have few tokens to skip, and a profile of `scans` on them (`profiles/newg-small-units.*`) puts the path's fixed cost in the
ABI table's classification of the 64 builtin types on every lowering (`abi_finish_passing`, `abi_result`), Tier 0 and
validation. The builtin rows are the same for every unit of a configuration; caching them needs process-wide state,
which `main.c`'s units may not split (the call-graph check), so it is left for a change of its own.

## What #442 changed

- `check_program_declaring` gives the tokens that declare (and, for the lowering, that start an initializer), 16 at
  a time with masked loads and a register compress (`vpcompressd` to memory is 8 µops on Zen 5), with an exact scalar
  twin; the selection, the emission and the lowering visit it rather than every token, the lowering in reverse as
  before.
- `check_program_needed_count` and `check_program_needed_number` count and number the selection's needed objects
  64 at a time, with scalar twins.
- `abi_initialize_types` sizes the lowering's ABI table by its type table's types, not its room: the lowering makes
  no type. `abi_initialize` keeps the room for tables that grow.
- #418's separate pass over the symbols for whether a unit makes a name rides the existing one.
- Only dotted asm labels go in the made names' table (`new`).

Every c-testsuite object, by both paths, and every synthetic unit's is byte for byte `head`'s (`logs/tests.txt`).

## Correctness

`logs/tests.txt`: the 440 c-testsuite objects and 16 synthetic ones identical to `head`'s; `test-checker` (its six
failures, generated executables against this host's clang, are `head`'s too), with the kernels' twins checked at
`PROT_NONE` pages; `test-calling-convention`, with the table of the types alone against the whole one;
`test-c-testsuite --cross-check` (220 of 220); `test-checker-driver`, `test-check-debug --cross-check`,
`test-lowering --clang`, `test-checker-asm`, `test-tier0`; and the `--symbols-minimum 348` gate's command on musl
1.2.5's release (not the 9700X's frozen copy): 354 compared, none different, as `head`.

## Limitations

- Not the 9700X: an Intel Xeon @ 2.10 GHz in a cloud VM, without the shared lock, hardware counters or perf. Zen 5's
  costs differ (its `vpcompressd`, its clock), and code placement moves a build by about 2% on the 9700X
  (Buster's `docs/profiling.md`); here differences under about 3% are not resolved.
- The floor compares the trees in the host's fast state; the medians are in `logs/` too.
- The container moved hosts during the work (the kernel changed, `manifests/host-second.txt`): each comparison is
  within one host's rounds.
- c-testsuite's units are small; the synthetic ones stress the names, not a real large unit. `main.c`'s measurement
  is still #129's.

## Reproducing

On the 9700X, from a Buster checkout and this repository's checkout:

```sh
scripts/build-trees.sh ~/buster ~/buster-fast-bench/442-trees      # SHIM unset: the 9700X has mwaitx
git init -q --template= cts && git -C cts fetch -q --depth 1 https://github.com/c-testsuite/c-testsuite 5c7275656d751de0e68b2d340a95b5681858ed07 && git -C cts checkout -q FETCH_HEAD
EXCLUSIVE_OWNER=... EXCLUSIVE_TITLE=... EXCLUSIVE_LINK=... LOCK=~/buster-fast-bench/exclusive.sh \
    TREES=~/buster-fast-bench/442-trees CTS=$PWD/cts PASSES=101 scripts/rounds.sh logs-9700x 6 main pr head new
scripts/floor.py logs-9700x main pr head new
```

`LOCK` takes the shared lock for each run alone. `scripts/synthetic.py DIR 2000` makes the synthetic units, which
`FILES` gives `rounds.sh` instead of c-testsuite.
