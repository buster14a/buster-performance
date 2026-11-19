# C10: the 64-bit encoder's twins deleted (#2924)

Base `204be6e65` is the tests commit, with the twins present and `x86_measure`'s zeroed copy. Head `abed7371d` has
`x86_measure`'s last partial group by masked loads, and deletes `x86_encode_scalar` and `x86_measure_scalar`. Both sit
on main `bc66290c5`.

[`run.sh`](run.sh) ran on the 9700X: Release, every run under the lock, timings on CPU 2.

The gate is [`../c-encoder-gate/`](../c-encoder-gate/). In 64-bit mode the vector encoder wins at every size.
`x86_measure` lost at one instruction a call (105.6 cycles against 88.0) until its tail took masked loads: then 41.9
("`x86_measure` against its scalar twin").

## Objects

`-c` (Tier 0) and `-c --tier1` of sqlite3.c, Lua 5.4.8, musl's units and buster's `main.c`: 1,372 of 1,372 objects
byte-identical in each mode ([`logs/status.txt`](logs/status.txt)).

## Whole compiles

`ab`, three rounds, around `time-runs` of base, head and base again; `--lanes 1` ([`logs/time.log`](logs/time.log)).
The figures are user cycles against base.

| Compile | Head | Base again | Instructions, head against base |
| --- | --- | --- | --- |
| sqlite3.c, `-c` | −0.16%, +0.09%, −0.46% | −0.03%, −0.15%, −0.47% | 0.117 M fewer |
| Lua's units, `-c` | −0.27%, −0.43%, −0.22% | −0.42%, −0.04%, +0.03% | 0.047 M fewer |
| sqlite3.c, `-c --tier1` | +0.14%, +0.14%, +0.18% | +0.01%, −0.06%, +0.06% | 0.052 M fewer |
| Lua's units, `-c --tier1` | −0.07%, +0.07%, +0.09% | −0.22%, −0.11%, +0.08% | 0.023 M fewer |

Head retires fewer instructions in every list. Its cycles are within base again's spread, but sqlite3.c by `--tier1`
reads 0.1 to 0.2 points more in every round.

The executables, function by function ([`symdiff.py`](symdiff.py), sizes by name over every copy):
- `.text.buster_start` is 2,896 bytes smaller in head.
- On the compile's path, `x86_measure` is 43 bytes smaller and `check_program_emit_code_half` 489.
- Gone: `x86_encode_scalar`, `validate_instructions`' copies, and two of `encode_one`'s copies with their split aliases.
- `x86_match` inlines `encode_one` into one of its copies (+1,482 bytes), and `x86_validate` gains a split alias. They
  run in the assembler and under `--verify`, not in these compiles.

## Branch sizing

`benchmark-branch-sizing`, which measures by `x86_measure`, by base, head and base again in each of three rounds
([`logs/`](logs/), `branch-sizing-*`). On the mid-sized functions, `size_branches` takes 0.93 to 0.95 of base's time
in every round:

| Workload | Round 1 | Round 2 | Round 3 |
| --- | ---: | ---: | ---: |
| tier0-250 | 0.949 | 0.950 | 0.948 |
| tier0-mix | 0.934 | 0.942 | 0.929 |
| optimized-250 | 0.960 | 0.954 | 0.953 |

On the largest functions it takes the same time.

## Tests

On head ([`logs/status.txt`](logs/status.txt)), all pass: the encoder's tests and its callers' (branch sizing, x86
semantics, the assembler, target selection, the disassembler, Zen 5's costs, unwind, Tier 0, Tier 1, IR lowering and
SIMD, the builtin lowering and helpers, the C driver's inline assembly), c-testsuite's subset by
`test-tier1-cfg-source` and `test-ssa-source --typed --tier1`, three benchmarks, the call graph's and ownership checks
and the complete driver's checks of `main.c`.

`test-checker-driver` (exit 124, [`logs/t33.log`](logs/t33.log)) is not a result. It ran without the inventory's
`--executable`, `--in-process` and `--part`, started every child through `/proc/self/exe`, and each came back with
status -1, on preprocessor fixtures too, until the run's time limit. The PR's checks run its eight parts as the
inventory has them.

MSan and ASan, on head in the cloud ([`sanitizers.sh`](sanitizers.sh), [`sanitizers.log`](sanitizers.log)): the
encoder's and its callers' tests, and `-c` and `-c --tier1` of c-testsuite's first 30 programs, all clean.

## Mutants

[`mutation/`](mutation/) holds the runner, the mutants and their logs. Each mutant is a build of `test-x86-encoder`
alone ([`enc_main.c`](mutation/enc_main.c), at -O1), which must fail.

**First round** ([`mutation/first/`](mutation/first/)), on the deletion before the entry-errors check: 13 of 14 killed.
The survivor let `x86_encode` take a capacity a byte short of its need. No check gave an entry point less room than it
needs. The tests commit now does, and kills it ([`capacity-rerun.results`](mutation/first/capacity-rerun.results)).

**Final round** ([`final.results`](mutation/final/final.results)): on head, all 14 are killed.
- **`x86_measure`:** the tail's last record, the third quad's mask, the tail's lanes, a full group's total, and the
  base.
- **The encoder:** the one-quad tail's bound, the tail's lanes, the offsets' last lane, the fixup ends' count, the
  group's offset, the capacity check, an 8-bit displacement's range, and the tail's copy.
