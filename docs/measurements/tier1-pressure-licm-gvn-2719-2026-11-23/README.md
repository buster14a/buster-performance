# Tier 1: LICM and value numbering under a pressure policy (buster#2719, 2026-11-23)

The evidence for [buster#2719](https://github.com/buster14a/buster/issues/2719): why `--tier1-passes=+licm` and `+gvn`
cost Lua and speedtest1 so much, the policies tried, and what the chosen ones (`+hoist` and `+numbering`) gain and cost.
By Claude Code in David's directed session ([private session](https://claude.ai/code/session_01NNmNQsDDuWyFJqf6FxmgSs),
model `claude-opus-5-5`), from the claim in issuecomment 7104188054.

## Trees and hosts

| Role | Value |
| --- | --- |
| base | buster `061effd6c49f492e58e4047622519e6c8a28c6ed` (main) |
| experiment | base plus `scripts/experiment.patch`: switches read from the environment (`LICM_POLICY`, `GVN_POLICY`, `GVN_AFTER`, `LICM_TRACE`); never committed. Its last state; the policy bits' meanings below |
| head | base plus `scripts/head.patch` (sha256 `67939772…`): the clean implementation, `hoist` on by default while measured |
| head2 | base plus `scripts/head2.patch` (sha256 `84ecbede…`): head with the loop analysis shared with the preparation's dominator tree, and the docs |
| cloud | Claude Code container, 4 CPUs with AVX-512, Ubuntu clang 23.1.6, CI's staged clang 23.1.4 for the toolchain and the kernels' harness, valgrind 3.22 |
| 9700X | `benchpress`, each run under `~/buster-fast-bench/exclusive.sh`, pinned to CPU 2, Release builds by the 9700X job's clang 23.1.4 |

The pull request's commit makes `hoist` opt-in; its `+hoist` objects are byte-identical to head's default ones on
`sqlite3.c` and its default objects to base's.

Inputs: the 9700X corpus's `sqlite3.c` (sha256 `0a409f16…e23d`), SQLite's `speedtest1.c`, Lua 5.4.8 and the five
scripts of `tier1-reciprocal-141-2026-11-01/9700x/lua` (the 9700X's `3309-claude` inputs); in the cloud the same files
copied from there. `kernels/`: #2743's 25 loops (`kernels.c`, `kernels.h`, from `tier1-array-loops-2743-2026-11-14`),
five loops with invariant arithmetic (`extra.c`: a 2-D row sum, an affine map, a window sum, a transpose, a hash mix)
and `drive.c`, built by clang -O2, which calls each 200 times on fixed arrays and prints a digest.

## Instructions by callgrind (cloud)

`scripts/count.sh COMPILER LABEL OPTIONS...` builds Lua (with `luai_makeseed` fixed, so that counts repeat) and
speedtest1 (`measure-tier1-programs`' unity file and flags, `--size 5 --testset mix1`) by `--tier1` with the options,
and counts each run's instructions; `scripts/kcount.sh` the kernels' by function; `scripts/table.py` and
`scripts/ktable.py` print the tables. The raw lines are in `local/`.

On base, against `--tier1` (`local/counts-main.txt`):

| | Lua's five scripts | speedtest1 |
| --- | ---: | ---: |
| `+licm` | +74.66% | +11.85% |
| `+gvn` | +15.81% | +6.61% |

`calls.lua` alone ran 4.2 times its instructions under `+licm`, all in `luaV_execute`. `LICM_TRACE` printed each move
of `lvm.c` (`local/lvm-trace.txt`): 15,845 moves out of `luaV_execute`'s three nested loops of about 1,350 blocks, each
with calls, 12,331 of them constants and 1,977 pointer casts.

### LICM's policy bits (`LICM_POLICY`)

1 constants and addresses never move; 2 free values move only as operands of a moving costly value; 4 no truth value
moves; 8 a loop with a call moves nothing; 16 only from blocks that dominate every latch; 32 a budget of 12 (5 with a
call) less the values live through the loop. Free values: `exp1` took constants, addresses, the casts and constant
arithmetic, a cast free only of free operands; `exp5` every cast (`zext` and `sext` too) free; `exp8` (the patch's) the
casts of no bits alone (`inttoptr`, `ptrtoint`, `bitcast`, `copy`, `trunc`), `zext` and `sext` costly.

| Build, policy | Lua | speedtest1 | kernels |
| --- | ---: | ---: | ---: |
| base, `+licm` | +74.66% | +11.85% | −4.00% |
| exp1, 1 | +60.88% | +2.70% | |
| exp1, 2 | +61.00% | +3.42% | |
| exp1, 8 | +0.04% | +0.06% | |
| exp1, 14 | −0.00% | −0.19% | |
| exp3, 22, 38, 54 | +60.8% | +2.2% to +2.3% | |
| exp5, 6 | +0.10% | +0.07% | −10.54% |
| exp5, 46 | −0.00% | +0.01% | |
| exp8, 6 | +0.10% | +0.94% | −10.89% |
| exp8, 38 | −0.01% | +0.38% | −10.89% |
| exp8, 54 | −0.03% | +0.39% | −10.89% |
| exp8, 10 | −0.00% | −0.17% | −10.89% |
| exp8, 14 | −0.00% | −0.21% | −10.89% |
| exp8, 42 | −0.00% | −0.18% | −10.89% |
| exp8, 46 (the policy) | −0.00% | −0.21% | −10.89% |

exp3's rows kept every cast of an outside value movable outside the budget, which is why they stayed high.

### Value numbering's policy bits (`GVN_POLICY`, `GVN_AFTER`)

1 a constant or address merged within its block alone; 2 every value within its block alone; 4 never a constant or
address; 8 never a free value (those and `address`, the casts, `zext`, `sext`); 16 never across a call on the dominator
tree's path; 32 never into a block outside a loop the value's block is in (`exp7` had a bug that left it off: its rows
equal 8's and 24's; `exp9` fixed it); 64 a truth value within its block alone. `GVN_AFTER` runs the solver on the
promoted function after the switches of constants, before LICM.

| Build, policy | Lua | speedtest1 | kernels |
| --- | ---: | ---: | ---: |
| base, `+gvn` | +15.81% | +6.61% | +4.01% |
| exp2, 1 | +7.50% | +2.91% | |
| exp2, 2 | +4.80% | +0.76% | |
| exp4, 4 | +7.34% | +2.97% | |
| exp4, 8 | −0.08% | +0.15% | ±0 |
| exp4, 4 after | +10.76% | +8.22% | |
| exp4, 8 after | −0.60% | +1.21% | −4.79% |
| exp4, 10 after | −0.17% | −0.16% | |
| exp6, 24 after | −0.65% | +0.37% | −4.79% |
| exp6, 26 after | −0.17% | −0.16% | |
| exp9, 40 after | −0.57% | +1.25% | −2.19% |
| exp10, 88 after | −0.66% | −0.20% | −4.79% |
| exp10, 72 after (the policy) | −0.65% | −0.24% | −4.79% |

### The clean implementation (head, `local/counts-v1.txt`, `local/kv1.txt`)

Against base's `--tier1`: `hoist` (head's default) Lua −0.00%, speedtest1 −0.21%, kernels −10.89%; `-hoist` exactly
base; `+numbering` with `hoist` Lua −0.64%, speedtest1 −0.45%, kernels −12.53%. Every build's Lua scripts printed the
same output, speedtest1's test lines were the same, and every kernel build gave the digest `834781506787`.

Compile time in the cloud (`scripts/ctime.sh`-like loops, medians of 7, `--tier1 --lanes 1 -c sqlite3.c`): experiment
`LICM_POLICY=46 +licm` +13% and `GVN_AFTER=1 GVN_POLICY=72 +gvn` +42% before the clean implementation skipped
functions without a loop and returned unchanged functions unwritten; head: `hoist` +3.0%, `+numbering` +16.5%.

## The 9700X

`9700x/build.log` (head), `9700x/programs.log` and `9700x/compile.log` (head), `9700x/kernels.log` (head),
`9700x/perf-*.txt` (head), `9700x/build2.log` and `9700x/compile2.log` (head2). `scripts/9700x-*.sh` ran them; each
part under the lock on its own (`9700x-lock.sh`). The kernels' first run failed on `time-runs`' missing `--list` and
was run again; `run.sh` was replaced while `programs` ran, so its log ends in a shell syntax error after the results
(the measurement had finished; its after-run load lines are missing).

### Run time: `measure-tier1-programs --runs 11` (head, `hoist` on by default)

User cycles and instructions of each variant over `--tier1` (with `hoist`):

| Variant | speedtest1 cycles | speedtest1 instructions | Lua cycles | Lua instructions |
| --- | ---: | ---: | ---: | ---: |
| `-hoist` (base's pipeline) | 0.9968 | 1.0022 | 0.9909 | 0.9998 |
| `+numbering` | 0.9970 | 0.9975 | 0.9950 | 0.9932 |
| `+licm` | 1.1059 | 1.1236 | 1.7252 | 1.7385 |

Lua by script, `-hoist` against `hoist`, user cycles: calls 0.977, tables 1.022, strings 0.971, arithmetic 1.002,
closures 0.986, at instruction counts within 0.07% of each other: code placement. Code size (the run's
`tier1-code-size` lines): `hoist` adds 64 bytes to `sqlite3.c`'s Tier 1 functions and 30 to Lua's, within clang
-O0's bound.

### The kernels: `time-runs --runs 11` (head)

| Build | user cycles, M | instructions, M |
| --- | ---: | ---: |
| clang -O2 | 14.355 | 38.481 |
| `-hoist` | 26.496 | 118.653 |
| `hoist` | 24.863 | 105.754 |
| `hoist`, `+numbering` | 24.072 | 103.814 |

### Compile time: `measure-compile --runs 11`, `-c --tier1 --lanes 1 sqlite3.c`

| Tree | `-hoist` | `hoist` | `+numbering` |
| --- | ---: | ---: | ---: |
| head, user cycles, M | 3,392.0 | 3,513.2 (+3.57%) | 3,948.5 (+16.4%) |
| head2, user cycles, M | 3,395.0 | 3,509.0 (+3.36%) | 3,945.5 (+16.2%) |
| head2, wall, ms | 632.2 | 652.5 | 731.6 |

`perf record -e cycles:u` of one compile each way (head, `9700x/perf-*.txt`, the top 45 and 60 symbols): with
`hoist`, `ir_check_rows` +34 M cycles, `dominators_analyze` +28 M, `ir_optimize_check_reachable` +9 M and
`ir_uses_batch` +9 M: the preparation of every function with a loop. head2 shares the loop analysis with the
preparation's dominator tree, which took 4 M cycles of it.

## Conclusion

The policies remove the regressions: `+hoist` changes speedtest1's and Lua's cycles by less than code placement does
(and speedtest1's instructions by −0.22%), and `+numbering` too. The loop kernels gain 6.2% of their cycles by
`hoist` and 9.2% with `+numbering`. #2719's bar for a default is a gain on speedtest1 and Lua, which neither reaches,
for 3.4% and 16.2% of `sqlite3.c`'s compile, so both stay opt-in.
