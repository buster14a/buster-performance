# Tier 1: values live across fixed sequences avoid their registers (#2767), 2026-11-14

Evidence for [buster#2767](https://github.com/buster14a/buster/issues/2767) and its pull request (linked from the issue).
By Claude in David's directed session ([the session](https://claude.ai/code/session_01NNmNQw6FpEjMZVV2gCQz4H)).

Lua's integer `//` (`luaV_idiv`, which #2541 inlined into `luaV_execute`) kept its divisor in `rax`, live past the
division, so the division's records saved it in its call-save row, moved it through `r11` and loaded it back. The change
names the CFG consumer's fixed-register sequences (a division's or high multiplication's `rax` and `rdx`, a shift's `rcx`)
in its allocation problem. A value whose phi web lives across one, or holds its divisor, its shift's other operand or its
shift's destination, avoids its registers, taking one only where no other is free. A shift's count in `rcx` is neither
saved nor avoided across its own shift. buster's `docs/tier1-allocation.md`, "Values live across fixed sequences", has
the rule.

## Revisions

| Role | What |
| --- | --- |
| base | #2766's head, `3652581` (`claude/jolly-fermi-8mfkw3`, main `5f3c7d48` merged into it) |
| h1 | the ranges refused the sequences' registers (allowed sets), each range on its own, no readers (not kept) |
| h2 | h1 with readers: a shift's count kept in `rcx`, unsaved (not kept) |
| h3 | ranges avoid the registers (`avoided_registers`), each on its own, with readers |
| h4 | h3, but a hint to an avoided register wins (not kept) |
| h5 | each value's ranges avoid them together (`variants/per-value.diff` against `99ab44a`'s `tier1_cfg.c`) |
| h6 | each phi web's ranges avoid them together: `99ab44a` |
| head2 | `466d44a`: the sequences found by a count per position, and the consumer's one pass; h6's objects |
| h8 = head3 | `42da831`: a hinted class colors with its avoided registers instead of going to the scan |
| h9 = head4 = head | `afe31a2`: a divisor, a shift's other operand and its destination avoid them too, the pull request's code |
| h9b | h9 without the destination (the shift's result) avoiding them (not kept) |

The pull request's later commits (`cf45ad3`, the merge of #2766's `c3c9fb6`, `c85ec32`) change only docs.

## 1. Dynamic instruction counts (callgrind)

**Host.** A cloud container, not the 9700X (`counts/identities.txt`): an Intel Xeon with AVX-512, valgrind 3.22.0,
clang 23.1.6. The compilers were built there by `build.sh`'s Develop configuration.

**Inputs.** #1189's and #1217's, as #2592's record: Lua 5.4.8 and its five scripts (`-Dluai_makeseed(L)=0x2592u`, a fixed
string-hash seed, so a script's count repeats), and the frozen `sqlite3.c` with `speedtest1.c` at SQLite `ccc132c5` as one
unit, with speedtest1's `--size 5` mix.

**Tools.** `scripts/buildlua.sh`, `luacount.sh` and `st.sh` (#2592's, with this record's paths and the seed in
`buildlua.sh`); `moves.sh` sums `luaV_execute`'s moves; `fixed.sh` counts the stores of `rax`, `rdx` or `rcx` into the
stack in the five instructions before each `div`, `idiv`, one-operand `mul` or `imul` and shift by `%cl`, the loads of
them in the three after, and a divisor moved into `r11` right before; `functions.sh` compares two builds by function.
`fixed.sh`'s loads include any stack load after a sequence, spill reloads too: its stores are the saves.

| | base | head |
| --- | ---: | ---: |
| Lua's five scripts, whole processes | 4,774.6 M | 4,752.8 M (−0.46%) |
| `luaV_execute` | 2,225.5 M | 2,215.0 M |
| its register moves | 322.2 M | 318.7 M |
| of them through `r11` | 5.0 M | 1.5 M |
| saves around Lua's sequences (stores) | 7.32 M | 0 |
| speedtest1, whole process | 2,626.71 M | 2,613.07 M (−0.52%) |
| saves around speedtest1's sequences (stores) | 5.83 M | 0.44 M |
| divisors moved through `r11` in speedtest1 | 1.79 M | 0 |

Every Lua script printed clang -O0's output and every speedtest1 gave the hash `1248168 a7fa3957…`
(`counts/*/check.txt`, `verify.txt`).

**By function** (`counts/functions.txt`). On Lua: `luaV_execute` −10.47 M, `luaH_getshortstr` −5.78 M, `mainpositionTV`
−2.42 M, `luaH_free` −1.20 M, `luaH_resize` −0.80 M, `luaH_newkey` −0.80 M; none runs 50 K more. On speedtest1, four
functions run over 50 K more: `sqlite3BtreeIndexMoveto` +0.97 M (a high-pressure loop whose registers reshuffled after a
division that speedtest1 never runs moved its `pRes` out of `rdx`), `resizeResolveLabel` +0.16 M,
`sqlite3WhereCodeOneLoopStart` +0.12 M and `cellSizePtrTableLeaf` +0.05 M.

**What's left.** speedtest1's 0.44 M saves are of parameters whose first range is bound to their incoming register
(`pcache1Fetch`'s `createFlag` in `rdx`, 0.27 M). `luaV_execute`'s moves through `r11` are #2768's: `OP_GETTABUP`'s
fetch, 0.74 M twice (`counts/moves.txt`).

**The forms** (`counts/st-h*`, `counts/lua-h*`), against base:

| Form | speedtest1 | Lua's scripts |
| --- | ---: | ---: |
| h1: refused, per range, no readers | −2.85 M | −6.9 M |
| h2: refused, per range, readers | −5.65 M | −6.9 M |
| h3: avoided, per range | −4.89 M | −6.9 M |
| h4: avoided, a hint first | −3.38 M | 0.0 M |
| h5: avoided, per value | −10.71 M | −10.4 M |
| h6: avoided, per phi web | −11.13 M | −11.2 M |
| h8: h6, hinted classes colored | −11.13 M | −11.2 M |
| h9b: h8 with the operand | −12.85 M | −15.5 M |
| h9: h8 with the operand and result | −13.64 M | −21.8 M |

- h1 spilled `sqlite3BtreeIndexMoveto`'s `pRes` (+3.84 M) from the block of that never-run division: every other
  register was held there, and its slot followed it into the hot loop. h1's `memsys5Free` ran +1.13 M: `iLogsize` left
  `rcx` in its loop, where it is a shift's count; h2's readers make it −1.02 M.
- h3 moved Lua's divisor out of `rax` on the edge into its division's block, and a range in a cold block redirected later
  ranges by their hints. h4 left the divisor in `rax`: its range enters the division's block hinted there.
- h8's objects are h6's for Lua byte for byte; speedtest1 runs 61 instructions fewer.
- h9b against h9: `luaH_getshortstr`'s count dies at its shift, whose destination took the `rcx` it left (+2.89 M), and
  `mainpositionTV`, `luaH_free` and `luaH_resize` likewise.

## 2. Compile cost

**Callgrind** (`scripts/compile-count.sh`, `compile/`): each revision's x86-64 (scalar host) Release build, which valgrind
can run, compiling `sqlite3.c` with speedtest1's flags and Lua's `lvm.c` by `--tier1 -fno-asynchronous-unwind-tables`,
under `ulimit -v` 64 GiB:

| | sqlite3.c | lvm.c |
| --- | ---: | ---: |
| base | 19,273.22 M | 950.64 M |
| head (h6, `99ab44a`) | 19,342.76 M (+0.36%) | 953.54 M (+0.30%) |
| head2 (`466d44a`) | 19,316.49 M (+0.22%) | 952.47 M (+0.19%) |
| head3 (h8, `42da831`) | 19,319.52 M (+0.24%) | 952.52 M (+0.20%) |
| head4 (h9, `afe31a2`) | 19,321.27 M (+0.25%) | 952.57 M (+0.20%) |

head's +69.5 M on `sqlite3.c`, by function (`compile/functions-head.txt`): `tier1_cfg_prepare` +32.4 M (the ranges'
halvings over the sequences), `tier1_emit_cfg_problem` +21.0 M (two passes over every node of every function) and
`tier1_allocate_hinted` +16.8 M. head2 took the first two to +20.0 M and +7.0 M. head3 moved `tier1_allocate_hinted` by
+3.3 M in this count.

**9700X** (`9700x/`, by buster's `measure-compile`, pinned to CPU 2, each input one hold of the shared lock; `sqlite3.c`
by `--tier1 --lanes 1 -c` with 21 runs, `lvm.c` with 41; medians, each against base and the revision before as
references in a Williams order):

| sqlite3.c | wall | user cycles | user instructions |
| --- | ---: | ---: | ---: |
| base | 615.4 – 616.0 ms | 3,308.3 – 3,308.7 M | 8,196.5 M |
| head (`99ab44a`) | 620.3 ms (+0.80%) | 3,335.3 M (+0.82%) | 8,253.5 M (+0.70%) |
| head2 (`466d44a`) | 617.8 ms (+0.39%) | 3,320.0 M (+0.35%) | 8,233.0 M (+0.45%) |
| head3 (`42da831`) | 617.8 ms (+0.35%) | 3,320.6 M (+0.37%) | 8,231.7 M (+0.43%) |
| head4 (`afe31a2`) | 618.7 ms (+0.44%) | 3,325.2 M (+0.50%) | 8,231.6 M (+0.43%) |

Each percentage is against the base median of its own run (`9700x/compile-*/sqlite3.txt`). head3 against head2 in the same
run: 617.8 against 618.1 ms. `lvm.c` takes the same time at every revision (29.4 to 29.6 ms, within each run's spread)
for +0.4% instructions.

## 3. Run time on the 9700X

Base against head4 (`afe31a2`), by #2553's method with #2734's scripts (`9700x/scripts/`):

- Lua's 33 objects are linked in 33 orders (`9700x/orders.txt`), and speedtest1 after 8 pads.
- 5 rounds of Lua and 7 of speedtest1 follow an untimed one, each round one hold of the shared lock, each run `perf stat`
  on CPU 2.
- All 82 executables were checked first (`9700x/checks.txt`): every Lua script printed clang -O0's output and every
  speedtest1 its hash. 1,762 runs, none failed (`9700x/runs/`). `9700x/analysis.txt` has the analysis by #2592's
  `analyze.c`.

| Program | Metric | head / base | 95% interval |
| --- | --- | ---: | ---: |
| Lua's five scripts, 33 link orders | user cycles | −0.36% | −0.79% to +0.08% |
| | task-clock | −0.35% | −0.76% to +0.06% |
| | user instructions | −0.44% | −0.46% to −0.43% |
| Lua's `arithmetic` | user cycles | −1.51% | −1.94% to −1.08% |
| speedtest1, 8 layouts | user cycles | +0.09% | −0.66% to +0.83% |
| | task-clock | +0.04% | −0.60% to +0.68% |
| | user instructions | −0.53% | |

- **Lua.** `arithmetic`, whose loops run `//` and `%`, is faster at 30 of the 33 orders. The other scripts are within
  their intervals of zero, and so is the total.
- **speedtest1.** No layout's difference exceeds its spread: the instructions saved don't show in its time.
- **Static moves** (`--tier1-report`, `9700x/reports-*.txt`): speedtest1's edge moves 35,590 → 36,035, spill stores
  12,634 → 12,660 and loads 13,914 → 13,946, where values move out of the registers their webs avoid. Lua's objects'
  edge moves 2,530 → 2,528.

A first chain against `99ab44a` was stopped in its warm-up round when head4 replaced it
(`9700x/chain-99ab44a-stopped.log`); its compile times are `9700x/compile-99ab44a/`.

## 4. Tests

`counts/mutants.txt`: each rule turned off in a build fails its test (the first run's boundary mutant changed one of a
halving's two lines and never returned; it was rerun with both). `counts/suites-*.txt`: the Tier 1 suites, the SSA and
c-testsuite checks and the Tier 1 drivers on `99ab44a` and on `afe31a2`, all passing.
