# Tier 1's selection: the twins deleted (#2924, C7, second slice)

Branch `c7b-final`: base main `eb9ebe2d3`, head `dda25f737` (tests, deletion, docs; the later commits add tests only).
The gate is in [`../c-tier1-gate/`](../c-tier1-gate/): the selection's twin took more ticks than its vector path on
every corpus.

## The 9700X, main against head ([`run.sh`](run.sh), [`logs/`](logs/))

Release, every run under the lock, timings on CPU 2.

- **Tests by head:** `test-tier1-select` 1,378,380 checks (plans 5,425, digest `c485097574ea77f5`, the frozen one) and
  `test-tier1-pipeline --cross-check` 6,410 checks, no failures.
- **`benchmark-tier1-select-source` on sqlite3.c, three processes each** (2,600 functions, 436,519 IR instructions;
  the bottom-up rewrite's definitions hold on every node in both): head 367.0 to 367.9 cycles an IR instruction
  against main's 369.1 to 369.9 (−0.6%), and 951.7 instructions against 955.1 (−0.35%).
- **Objects:** `--tier1 -c` of sqlite3.c, Lua and musl, every compile in one directory: 1,371 of 1,371 identical.
- **Whole compiles** ([`logs/time.log`](logs/time.log)): `ab`, three rounds, around `time-runs` (3 runs, 3 copies)
  of base, head and base again, `--tier1 --lanes 1`. User cycles against base, round by round:

  | Compile | Head | Base again | User instructions, head against base |
  | --- | --- | --- | --- |
  | sqlite3.c | +0.09%, −0.04%, +0.17% | −0.00%, −0.19%, −0.04% | −3.52 M (−0.04%) |
  | Lua's units | +0.25%, −0.04%, +0.15% | +0.20%, −0.02%, −0.03% | −0.57 M (−0.03%) |

  Head retires fewer instructions in both. Head reads 0.09% to 0.21% above base-again on sqlite3.c and −0.02% to
  +0.18% on Lua, inside the 9700X's same-executable wobble (up to 0.4% between copies).

### `benchmark-tier1-select`'s synthetic shapes ([`wide/`](wide/), [`pad/`](pad/))

The run's three processes each read head 6% slower than main on the `wide` shape's selection (40.0 to 40.2 ns an IR
instruction against 37.8 to 38.0) and the same on `chain` and `pressure`. Under `perf stat`, main read 5% to 10%
slower than head on every shape instead. So [`pad.sh`](pad.sh) ran both builds under 16 environment pads (the stack
moves 16 bytes a pad):

| Shape, selection | Main, 16 pads | Head, 16 pads |
| --- | --- | --- |
| chain | 62.0 to 63.3 ns | 56.8 to 59.5 (13 of 16 under 57.6) |
| wide | 42.4 to 42.8 | 39.9 to 43.4 (13 of 16 under 40.6) |
| pressure | 60.1 to 60.5 | 53.7 to 58.1 (13 of 16 under 54.2) |

With any pad, main sits in a slow phase that `run.sh`'s environment missed. Head is faster on every shape at every
pad but one (`wide` at pad 2: 43.4 against 42.7). The phase is main's own: a process's rate depends on where its stack lands, as #2959's split stores did. The profiles by
symbol ([`wide/report-*.txt`](wide/)) move work between `tier1_select_plan_checked` and `tier1_select_burs_pattern`
(their sum 50.3% on main, 49.9% on head): the deletion changed what is inlined, not what runs.

## Mutants ([`mutation/`](mutation/))

[`mutants.py`](mutation/mutants.py) breaks the vector code that stays: the BURS label, rules and classifier, the
barrier scan, the known bits, the symbol firsts, the ranges and the storage's scans. [`run.py`](mutation/run.py) runs
`test-tier1-select`, `test-tier1-emit` and `test-tier1-masks` on an archived tree.

**Round `pr`: the tests commit's tree** (`89bd237e9`, twins still in the source):
- **Killed:** b1, s1, s2, s3, r1 and t1.
- **Survived:** b4 and s4, untested cases:
  - b4 classes a truth value's link as one in the low eight lanes only. The plan comes out the same, so the frozen
    digest can't see it;
  - s4 skips each 64 nodes' first in the repeated leaves' scan, and no fixture put a repeated leaf there.
- **b3 is the identity:** the goals are STMT and REG, 0 and 1, so `goal & 1` is `goal`. b3b sends STMT's goal to REG.
- **Never built:** b2, which left `left` unused. b2b keeps it used.
- b2b and b3b, run afterwards on the same tree: killed.

**Round `pr2`**, the same tree with commit `48fa59acc`'s cases:
- `tier1_burs_check_function` checks each integer comparison's class against the link's definition, and a fixture
  puts a link in each of the classifier's 16 lanes;
- #2601's repeated accesses again, padded so the first symbol address sits at node 64.

b4 and s4: killed.

**Round `final`**, the final tree with every case: results in [`mutation/final.results`](mutation/final.results).
