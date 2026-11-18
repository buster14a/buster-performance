# C9c: the splits', threading's, if-conversion's, truth simplification's and the sink's twins deleted (#2924)

Base `1c08a3f7f` is the tests commit: the twins are still present, and the scatter fix `d8f96b510` is below it. Head
`9be06688f` is the deletion. [`run.sh`](run.sh) ran on the 9700X: Release, every run under the lock, timings on CPU 2.
The gate is [`../c-ir-gate-again/`](../c-ir-gate-again/): in every size bin the twins took 1.44 to 8.59 times as long
for the splits, 1.07 to 1.19 for threading and if-conversion, and 2.10 to 2.57 for the sink.

## Objects

`--tier1` and `--tier1 --tier1-passes=+all` of sqlite3.c, Lua 5.4.8, musl's units and buster's `main.c`: 1,372 of 1,372
objects byte-identical in each mode ([`logs/status.txt`](logs/status.txt)).

## Whole compiles

`ab`, three rounds, around `time-runs` of base, head and base again; `-c --lanes 1`
([`logs/time.log`](logs/time.log)). The figures are user cycles against base.

| Compile | Head | Base again | Instructions, head against base |
| --- | --- | --- | --- |
| sqlite3.c, `--tier1` | +0.16%, +0.11%, +0.10% | +0.07%, +0.11%, +0.03% | 2.82 M fewer (−0.034%) |
| Lua's units, `--tier1` | +0.12%, +0.19%, +0.16% | +0.09%, +0.12%, +0.12% | 0.83 M fewer (−0.039%) |
| sqlite3.c, `--tier1 --tier1-passes=+all` | −0.29%, −0.17%, −0.19% | +0.01%, +0.11%, −0.01% | 3.37 M fewer (−0.020%) |

Every compile already ran these vector scans in base, so the deletion removes only the flag's tests. Head retires
fewer instructions in each list.
- `--tier1`: head reads 0.00 to 0.09 points more cycles than base again.
- `+all`: head reads 0.18 to 0.30 points fewer.

`.text.buster_start` is the same size in both (0x16d15f), and none of the renamed or inlined functions is in
`cmake/BusterStartOrder.txt`. The renames: `ir_wide_split_path` and `ir_vector_split_path` became `ir_wide_split` and
`ir_vector_split`, and `tier1_schedule_ir_sink` is now inlined.

The first run on the commits before the scatter fix (`b66973716` and `a85caccd0`) read the same: objects identical,
and user cycles −0.01%, +0.10% and −0.23% in its last round.

## Tests

On head, all 58 lines of [`logs/status.txt`](logs/status.txt) pass:
- the IR, SSA and Tier 1 tests (`test-ir-optimize` with its frozen digests, `test-tier1-wide`, `test-tier1-pipeline
  --cross-check` and the rest of C9a's list);
- the source tests on c-testsuite's 220-program subset;
- `test-call-graph`, `check-call-graph` and the unity ownership check;
- the complete driver's `-fsyntax-only -Wall -Werror` and `--lanes 1 --verify -c` of `main.c`.

## Mutants

[`mutation/`](mutation/) holds the runner and the mutants. [`run.py`](mutation/run.py) applies each mutant to an
archived copy of the tree, builds it (Develop) and runs `test-ir-optimize` and `test-tier1-wide`.

**First round** ([`first.results`](mutation/first.results)), on the deletion before the fixes: 12 of 19 killed. The
seven survivors were:
- `t2` and `t4`: threading's escapes scan with its optional operands, or its intrinsics' extra operands, dropped. No
  fixture had either case. While writing the check that kills them I found the vector scan skipped a scatter's extra
  values, which its twin walks: `d8f96b510` adds them, and the new check of the escapes against their definition
  fails without that fix.
- `i3`, a barrier batch of 63 rows instead of 64: equivalent, since the batches still cover the range. It is replaced
  by an off-by-one in the row found (`i3-barrier-row`).
- `i5` and `i6`, the narrowing casts' scan, and `r2`, the truth comparisons' scan, at a full batch's last lane: no
  fixture has a cast or a comparison at lane 63. Both scans are now functions of their own (`ir_if_convert_truncations`,
  `ir_truth_candidates`), checked against their definitions at every count.
- `s3`, the sink readers' presence test of an optional operand: dead. An absent operand is `BUSTER_IR_NONE`, and the
  value compared is an instruction's index, so the deletion removes the test. It is replaced by dropping the optional
  operands altogether (`s3-readers-optional`).

**Final round** ([`final.results`](mutation/final.results)), on head `9be06688f`: 20 of 20 killed, with `t6` added for
the scatter fix.
