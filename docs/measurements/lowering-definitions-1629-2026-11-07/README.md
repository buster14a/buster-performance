# The `-c` path after checking: the definitions' selection and a small unit's rest (#1629), 2026-11-07

Buster issue [#1629](https://github.com/buster14a/buster/issues/1629) took what
[#442](https://github.com/buster14a/buster/issues/442)'s last record
([lowering-fixed-cost-442-2026-11-06](../lowering-fixed-cost-442-2026-11-06/README.md)) left on the `-c` path after
checking: the smallest units (under 300 tokens), about 240 ns a file over main before #418, and the synthetic units of
2,000 definitions, whose selection took about twice main before #418's. This record measures the changes made for it,
on the same harness and inputs, and the ones tried and not kept. It is cited by Buster's `docs/c-lowering.md` ("The
definitions' selection and a small unit's rest").

Every number here is from the approved Ryzen 7 9700X (`benchpress`), under the shared lock, each run pinned to CPU 2,
but the correctness section's, which are the Xeon VM's (off-host). As in #442's records, every table but the last
section's times the path after checking alone, checking outside the time.

## Sources and trees

| Tree | Source | What it is |
| --- | --- | --- |
| `main418` | `3bfb4a72a51f4a7872090905d52f92b95b3e1375` | main just before #418's merge: #442's tree and executable, reused |
| `main` | `53854a7c2e5f9b2d48d73c967329597650943a42` | main on 2026-11-07, the branch's base |
| `c1` | `main` with `patches/c1.patch` | the selection's two indexes, the library loop and the emission's clears |
| `c2` | `main` with `patches/c2.patch` | `c1`, and the runtime names' lookups by their home buckets without a branch (not kept) |
| `c3` | `main` with `patches/c3.patch` | `c2`, the object writer's classes without atoms and the helpers' key table made on demand |
| `c4` | `main` with `patches/c4.patch` | `c3`, and the runtime names' home buckets prefetched before the lookups (not kept) |
| `c5` | `main` with `patches/c5.patch` | `c4` without `c2`'s lookups |
| `c6` | `main` with `patches/c6.patch` | `c1` and the object writer's classes without atoms: **the branch as proposed** |

Each patch is `git diff 53854a7c` of the tree's state on buster14a/buster's branch `claude/confident-hypatia-i2myfn`
before it was rebased: `c1.patch` its first three commits, `c6.patch` its four code commits. Rebased onto main at
`32f473bb` for its pull request, the same four commits are `efdac1b3`, `6be49869`, `4540092c` and `9db4b5dd` (the next
changes documentation alone). `c2` to `c5`'s commits were not kept, so their patches are their source. Each tree is `git archive` of `main` with its patch
applied and #442's stage-split harness added and registered (`scripts/build-trees.sh`, `scripts/emit_ab_now.c`,
`scripts/register_now.py`, as in #442's record), built with `BUSTER_DEBUG_INFO=0 ./build.sh` (clang 23.1.1), each build
in a lock hold of its own (`9700x/builds/`). `manifests/source-*.sha256` lists every file of each tree as built,
`manifests/trees.txt` each manifest's SHA-256 and each executable's, `manifests/host.txt` the host.

`c1`'s first build (`scripts/setup.sh`, `9700x/setup.log`) failed: its first patch had lost the library loop's use of
its new function to a hunk filter, and `-Werror` refused the unused function. `scripts/build12.sh` built `c1` and `c2`
again from patches made from the commits (`9700x/build12.log`); every number below is from those builds.

Inputs: c-testsuite's `tests/single-exec/*.c` at `5c7275656d751de0e68b2d340a95b5681858ed07`
(`manifests/c-testsuite.sha256`), 220 programs, and #442's synthetic units (`scripts/synthetic.py`, 200 and 2,000
definitions: block-scope statics, the same with asm labels taking every made name first, file-scope compound literals,
and plain functions and globals; `manifests/synthetic.sha256`).

## Runs

Three sets of rounds (`scripts/rounds.sh`, `rounds2.sh`, `rounds3.sh`). Each round takes the lock once and runs every
tree of its set, in an order that rotates by round, each run pinned to CPU 2 with 101 passes: c-testsuite's 220
programs, then the synthetic units (`benchmark-emit-ab`), then the units' path (`-c --lanes 1` of the 220 programs,
twice per tree).

| Set | Trees | Rounds | Logs |
| --- | --- | --- | --- |
| 1 | `main418`, `main`, `c1`, `c2`, `c3` | 4 (`c2` ran in rounds 2 to 4: its build came after round 1) | `9700x/logs/rounds-*`, `units/` |
| 2 | `main418`, `main`, `c1`, `c3`, `c4`, `c5` | 4 | `9700x/logs/rounds2-*`, `units2/` |
| 3 | `main418`, `main`, `c1`, `c6` | 4 | `9700x/logs/rounds3-*`, `units3/` |

Every run exited 0 and every timed pass lowered its warm-up's counts and object bytes (`9700x/logs/progress*.log`), but
set 1's round 1 of `c2`, whose executable didn't exist yet (`round-1-c2.err`), which the analyses leave out. Every tree
lowers each of the 220 programs to the same counts and object sizes (`9700x/analysis/floor-set*.txt`), and the units'
path made the same 220 objects, byte for byte, in every tree (`9700x/analysis/units-set*.txt`).

The tables give each file's **floor**, its least per-run minimum over the set's rounds, summed
(`scripts/floor442.py`); the **paired** deltas are each round's sum of per-file minimums against the first tree's in the
same round (`scripts/paired.py`, over the rounds in which every tree ran every file).

## Results

c-testsuite, set 3, the sum of the floors (`9700x/analysis/floor-set3.txt`), against `main418`:

| Subset | `main418` (ns) | `main` | `c1` | `c6` (the branch) |
| --- | ---: | ---: | ---: | ---: |
| all 220 | 1,860,108 | −23.5% | −25.8% | **−25.4%** |
| under 300 tokens, 154 | 475,585 | +5.9% | −0.9% | **+0.1%** |
| 300 to 3,000 tokens, 6 | 77,195 | −26.9% | −28.0% | −27.4% |
| 3,000 tokens or more, 60 | 1,307,328 | −33.9% | −34.8% | −34.5% |

Against `main` (`9700x/analysis/paired-set3-against-main.txt`): `c6` takes −178.9 ns a file under 300 tokens, paired
rounds −3.9 to −6.3% (median −5.21%), and −2.23% in all (−1.6 to −3.1%); every round agrees, in both.

Under 300 tokens, by stage (set 3's floors, against `main418`):

| Stage | `main418` (ns) | `main` | `c6` |
| --- | ---: | ---: | ---: |
| selection | 46,449 | −2.5% | −6.8% |
| emission | 387,123 | +3.6% | −2.8% |
| publication | 5,601 | +27.3% | +26.8% |
| object | 28,411 | +38.5% | +34.9% |

What `c6` keeps there over `main418` is the publication's +1,501 ns and the object's +9,915 ns, the setup that main has
added since #418 (the definitions' named sections, #619, among the object's); its selection and emission are below
`main418`'s.

**The object writer's classes without atoms** (`c6` against `c1`, which differ there alone): under 300 tokens the object
is −2.29% paired against `main` in every round of set 3 (−1.6 to −8.8%), where `c1`'s is +1.11%; in set 2, `c5` (which has
it) is −8.6 ns a file against `c1` there, −2.3 to −3.1% in every round (`scripts/paired.py` of `c1,c5`). `c6`'s emission is 5,196 ns over `c1`'s there (+1.4%), though that change doesn't run in
the emission: code placement, which moves a build by about 2% on the 9700X (#442's record, Buster's `docs/profiling.md`).

**The synthetic units**, set 3 (`9700x/analysis/synthetic-set3.txt`), the floor's total against `main418`:

| Unit | `main` | `c6` | `c6`'s selection (ns), `main418` and `main` |
| --- | ---: | ---: | --- |
| statics, 200 / 2,000 | +5.5% / +13.3% | +3.9% / **+4.2%** | 108,123; 113,423 and 256,481 |
| collisions, 200 / 2,000 | +6.9% / +17.2% | +6.6% / **+8.0%** | 163,206; 167,624 and 361,829 |
| literals, 200 / 2,000 | −14.8% / −7.3% | −14.8% / **−15.9%** | 93,495; 107,482 and 189,626 |
| plain, 200 / 2,000 | +2.3% / +6.8% | +1.4% / **+0.5%** | 92,774; 107,462 and 183,184 |

(The selection's column is the 2,000-definition unit's.) The selection of 2,000 definitions is now below `main418`'s on
every unit, from about twice it. What keeps those units over `main418` is the publication, about +25% (statics 87,294 ns
against 69,961), and the object, +14 to +16% (112,231 against 98,415), per-definition work main has added since #418 and
the same in `main`; and the collisions' emission, +6.4% (1,696,913 against 1,595,122), as in `main` (+5.5%).

## Tried and not kept

- **The runtime names' lookups by their home buckets** (`c2`): about 185 names are looked up in every unit's
  identifiers, each in a bucket line of its own, mostly a miss. A branch-free lookup of the home bucket alone, which
  decides most of them, was meant to let their loads overlap. It cost +141 ns a file under 300 tokens against `c1`
  (set 1's floors, 3,200.8 against 3,059.8 ns a file; paired against `main418` +2.47% where `c1` is −0.52%): the
  loop's count of the names found, through which each lookup writes its result, then waited on every lookup's load, where
  the branchy lookup's predicted absence lets the next lookups' loads start at once.
- **The home buckets prefetched before the lookups** (`c4` against `c3`, and `c5`): no gain in the emission (set 2,
  under 300 tokens: `c4` +28 ns a file against `c3`; `c5`'s emission +0.7% against `c1`'s). The harness's passes find
  those lines warm; a single compile's would be cold, which this record doesn't measure.
- **The helpers' key table made on demand** (`c3`, `c5`): it saves a 3 KB clear on the stack of every unit without
  builtins, which didn't show in any run.

## The whole compiler: the units' path

Each round also ran `-c --lanes 1` of all 220 programs at once, pinned to CPU 2: the whole compiler, preprocessing and
checking included, through the units' lanes (each run's wall time, `9700x/analysis/units-set3.txt`):

| Tree | Runs | Median (ms) | Against `main`, paired |
| --- | ---: | ---: | --- |
| `main` | 8 | 72.300 | |
| `c1` | 8 | 72.156 | −0.01% (−0.66 to +0.67%), 4 of 8 faster |
| `c6` | 8 | 72.407 | +0.19% (−0.73 to +0.94%), 3 of 8 faster |

No change shows there: the path after checking saves about 35 µs of the 220 programs' 72 ms, under the runs' spread.

## Correctness

On the Xeon VM, at `c6`'s source and again after the rebase onto `32f473bb` (against that main): every c-testsuite
program's and synthetic unit's object by `-c`, `-c -g`, `-c --scalar` and `-c -funsigned-char` (912 objects,
`scripts/objects.sh`), and `main.c`'s by `-c`, byte for byte main's; `test-checker` (803,612 checks), `test-check-lanes`, `test-check-units`, `test-tier0 --cross-check`,
`test-check-debug --cross-check`, `test-emission-metadata`, `test-calling-convention`, `test-baked-tables`,
`test-refinement`, `test-object-writer`, `test-link` and `test-c-testsuite --cross-check` (220 of 220). On the 9700X,
the PR's CI.

## Limitations

- The harness times the path after checking without lanes, its passes warm; the driver's `-c` of one file runs it with
  lanes, once per process, cold.
- `main418`'s harness prepares a file as before #1057, not otherwise differing in what it times (#442's record).
- Code placement moves a build by about 2%: set 3's `c6` against `c1` is +1.0% under 300 tokens, though they differ
  only in code that runs in the object stage, where `c6` is the lower.

## Reproducing

On the 9700X, in a directory with a bare clone of Buster (`buster.git`), the c-testsuite checkout (`cts`), the synthetic
units (`synthetic`), #442's `main418` tree (`trees/main418`) and this directory's `scripts/` and `patches/`:
`scripts/setup.sh`, `scripts/build12.sh`, then `scripts/rounds.sh 4`, `scripts/rounds2.sh 4` and `scripts/rounds3.sh 4`,
each taking the shared lock for each build and each round alone, and `scripts/manifests.sh`. The analyses:
`scripts/floor442.py ROUNDS --identical TREES TREES`, `scripts/paired.py ROUNDS TREES`, `scripts/synthetic_floor.py
ROUNDS TREES` and `scripts/units_analyze.py RUNS TREES`.
