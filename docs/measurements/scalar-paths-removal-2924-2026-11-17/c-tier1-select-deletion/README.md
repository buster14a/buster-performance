# Tier 1's selection: the twins deleted (#2924, C7, second slice)

Branch `c7b-final`: base main `eb9ebe2d3`, head `dda25f737` (tests, deletion, docs; the later commits add tests only),
rebased onto #2964 as `9cb543aaa`.
The gate is in [`../c-tier1-gate/`](../c-tier1-gate/): the selection's twin took more ticks than its vector path on
every corpus.

## The 9700X, main against head ([`run.sh`](run.sh), [`logs/`](logs/))

Release, every run under the lock, timings on CPU 2.

- **Tests by head:** `test-tier1-select` 1,378,380 checks (plans 5,425, digest `c485097574ea77f5`, the frozen one) and
  `test-tier1-pipeline --cross-check` 6,410 checks, no failures.
- **`benchmark-tier1-select-source` on sqlite3.c** (2,600 functions, 436,519 IR instructions; the bottom-up
  rewrite's definitions hold on every node in both). Head retires 951.7 instructions an IR instruction against
  main's 955.1 (−0.35%). Cycles an IR instruction:
  - first run, three processes each: head 367.0 to 367.9, main 369.1 to 369.9 (−0.6%);
  - [`replay/`](replay/), five more each: head 367.4 to 369.1, main 369.1 to 370.2 (−0.4%);
  - the rebased head (`9cb543aaa`) once on sqlite3.c and once on Lua: `mismatches=0`, so the comparisons' link
    definition holds on both corpora.
- **Objects:** `--tier1 -c` of sqlite3.c, Lua and musl, every compile in one directory: 1,371 of 1,371 identical.
- **Whole compiles** ([`logs/time.log`](logs/time.log)): `ab`, three rounds, around `time-runs` (3 runs, 3 copies)
  of base, head and base again, `--tier1 --lanes 1`. User cycles against base, round by round:

  | Compile | Head | Base again | User instructions, head against base |
  | --- | --- | --- | --- |
  | sqlite3.c | +0.09%, −0.04%, +0.17% | −0.00%, −0.19%, −0.04% | −3.52 M (−0.04%) |
  | Lua's units | +0.25%, −0.04%, +0.15% | +0.20%, −0.02%, −0.03% | −0.57 M (−0.03%) |

  Head retires fewer instructions in both. Head reads 0.09% to 0.21% above base-again on sqlite3.c and −0.02% to
  +0.18% on Lua, inside the 9700X's same-executable wobble (up to 0.4% between copies).

### `benchmark-tier1-select`'s synthetic shapes

The first run read head 6% slower than main on the `wide` shape's selection (40.0 to 40.2 ns an IR instruction
against 37.8 to 38.0) and level on `chain` and `pressure`. Later runs of the same files disagreed, so each of these
ran on the 9700X under the lock:

- **[`wide/`](wide/), [`pad/`](pad/): `compilers/base` itself, 8 minutes later.** It read 62.0 to 63.3 ns on `chain`,
  42.4 to 42.8 on `wide` and 60.1 to 60.5 on `pressure`, whatever the environment pad, and under `perf stat`. Head
  read as before.
- **[`replay/`](replay/): `run.sh`'s order and environment, five rounds.** The original file `compilers/base` stayed
  slow (`wide` 42.4 to 42.7), while three fresh copies of it read fast (`wide` 37.7 to 38.0, `chain` 57.2 to 57.4,
  `pressure` 54.2 to 54.4). The file's rate had changed, not the host. Fresh copies of head: `wide` 40.1 to 40.3,
  `chain` 56.8 to 57.0, `pressure` 54.0 to 54.1.
- **[`shape/`](shape/): an experiment build of each side** (main `8d4025fbf` and the rebased head, never pushed): one
  shape's selection alone, a fixed 40 repetitions, a fresh copy for every run.
  - Instructions are exact. Head retires 0.46% more on `wide` (5,071.9 M against 5,048.6 M) and 0.58% more on `chain`.
  - `wide`: main 38.0, 38.3 and 38.6 ns; head 38.0, 38.9 and 42.2.
  - `chain`: main 57.6 to 58.1; head 57.0 to 58.9.
- **[`stack/`](stack/): `wide` alone with ASLR off (`setarch -R`), 16 environment pads of 16 bytes.** Main read 38.2
  to 38.7 ns and head 38.0 to 38.9.

So `wide` selection is the same on both builds once its address placement is fixed. The 40 and 42 ns readings are
processes in a slower placement: ASLR moves the arenas and the stack, and main's file showed the same 42.6 ns state.
Head retires about 0.5% more instructions on the synthetic shapes, where every function is one long block, and 0.35%
fewer on sqlite3.c's real functions. [`prof/`](prof/) profiles fresh copies by symbol: each hot function's
instructions per cycle are within 6% between the builds.

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

**Round `final`**, the final tree (`48fa59acc`, deletion and every case): all 10 killed (b1, b2b, b3b, b4, s1 to s4, r1
and t1), b4 by `test-tier1-select` and s4 by `test-tier1-emit`.

## Locally (AVX-512 Xeon), after the rebase onto #2964

- `test-tier1-select`, `-emit`, `-masks`, `-wide`, `-cfg`, `-allocation`, `-liveness`, `-model`, `-frame`,
  `-schedule`, `-pipeline` and `test-check-debug` pass.
- All 220 of c-testsuite's single-exec programs give byte-identical objects from main's build and head's, under
  `--tier1`, `--tier1 -g` and `--tier1 --tier1-schedule=post`.
- The complete driver's parse and its `-Wall -Werror` self-check of `main.c` pass.
- The start section holds the same 577 functions in main's Release build and head's; head's new functions are the
  test's digest helpers.
- Sanitizers (vector host, Release; address with UBSan, memory and thread), on `9cb543aaa`: `test-tier1-select`,
  `-emit`, `-masks` and `test-check-debug` pass under each, and each compiles c-testsuite's first 60 programs with
  `--tier1`, `--tier1 -g` and `--tier1 --verify` with no failed exit and no sanitizer report.
