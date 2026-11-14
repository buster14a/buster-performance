# Tier 1: recipes no block reads, settled phi places, and the fixed rules' scratch (buster#2734, buster#2592)

Evidence for [buster14a/buster#2766](https://github.com/buster14a/buster/pull/2766), which finishes
[#2592](https://github.com/buster14a/buster/issues/2592) (`luaV_execute`'s moves through `r11`) and
[#2734](https://github.com/buster14a/buster/issues/2734) (the `OP_CALL` edge into `startfunc`). The design and its
reasoning are in buster's `docs/tier1-allocation.md`, "Recipes no block reads, settled phi places, and the fixed rules'
scratch".

- **base:** main `21e0d999aa6867320f49e24fa3198122acf7b00f`.
- **head:** `2f3ce2891476d4b2fb065761b0ab7ec72be21f61`. Its code is the same as the pull request's later heads
  (`f62f02a6` adds docs; `36525816` merges main's docs and build changes).

## 1. Callgrind (cloud container)

Method: #1189's `gap.c` (`GAP_INSTRUCTIONS=1`) and #1217's inputs.

- **Builds.** Each compiler is an `x86-64` Release build (valgrind runs only the scalar host).
- **Lua.** Lua 5.4.8 by `--tier1 -fno-asynchronous-unwind-tables`, with its string-hash seed fixed
  (`-Dluai_makeseed(L)=0x2592u`, as in the #2592 record). Its five scripts are checked against clang -O0's output.
- **speedtest1.** speedtest1 as one unit by `--tier1`, with `--size 5` mix1, checked by its `--verify` hash.

The scripts are `scripts/buildlua.sh`, `luacount.sh`, `st.sh`, `moves.sh` and `ablate.sh`.

| | base | head |
| --- | ---: | ---: |
| `luaV_execute`'s instructions | 2,311.8 M | 2,225.5 M |
| its register moves | 344.9 M | 322.2 M |
| of them through `r11` | 17.7 M | 5.0 M |
| its frame addresses' `lea`s | 58.3 M | 0.2 M |
| Lua's five scripts | 4,878,403,318 | 4,774,053,975 (−2.14%) |
| speedtest1 | 2,657,735,353 | 2,626,655,777 (−1.17%) |

`counts/` holds the files behind these numbers:

- `callgrind-summary.txt`: each configuration's totals and checks.
- `*/instructions.txt`: the per-script counts.
- `moves-main-head.txt`: the moves through `r11` by address.
- `functions-lua.txt` and `functions-speedtest1.txt`: each function's change over 10 K.

By script, Lua runs `calls` −3.87%, `arithmetic` −3.15%, `closures` −1.96%, `tables` −1.94% and `strings` −0.65%. No Lua
function runs more than 50 K more. In speedtest1, `sqlite3VdbeExec` runs −22.23 M, and the only function over 50 K more is
`resolveP2Values`, +0.31 M.

**Each rule's share.** `head`, `noproof`, `noalt`, `notie` and `noshift` are measured at `4063d76e`, before the division
change. The `no*` builds are one build with temporary environment switches that turn a single rule off; the switches are
not in the pull request. `h7` is the final head.

| Configuration | speedtest1 | Lua's scripts |
| --- | ---: | ---: |
| base | 2,657,735,353 | 4,878.4 M |
| head at `4063d76e` | 2,627,261,009 | 4,778.8 M |
| without the carried ranges' proof | 2,655,276,945 | 4,858.0 M |
| without the phis' settled places | 2,627,154,968 | 4,794.0 M |
| without the address ties | 2,627,318,441 | 4,779.1 M |
| without the shifts in place | 2,629,936,858 | 4,791.4 M |
| final head (`h7`, with the division) | 2,626,655,777 | 4,774.1 M |

**The moves through `r11` left in `luaV_execute`:**

- **3.49 M: a divisor held in `rax`.** The value is live past the division, so the records also save and restore it.
  This is buster#2767.
- **1.48 M: `OP_GETTABUP`'s fetch.** It swaps `pc` and `i` after a reload into the wrong register, as main does.
  This is buster#2768.

## 2. Run time on the 9700X

Method: #2553's, as in the #2592 record.

- **Compilers.** Both are `BUSTER_HOST_ARCH=znver5` Release builds.
- **Objects.** Each builds Lua's 33 objects and speedtest1's unit once.
- **Links.** Lua is linked in 33 orders (order 0 the usual one, the others seeded `shuf`s). speedtest1 is linked after
  pads of 0 to 3,696 bytes.
- **Checks.** All 82 executables passed first: each Lua script's output against clang -O0's, and speedtest1's
  verification hash (`9700x/checks.txt`).
- **Timing.** One untimed round of each program, then 5 timed rounds of Lua and 7 of speedtest1. Each round is one hold of
  the shared lock. Each run is `perf stat` pinned to CPU 2, in #2553's order (revisions rotated, Williams design).
- **Analysis.** `scripts/analyze.c` produced `9700x/analysis.txt`. Every run's counts are in `9700x/runs/runs.txt`
  (1,762 runs, none failed).

The scripts are `scripts/compilers.sh`, `objects.sh`, `link.sh`, `round.sh`, `time2.sh` and `chain.sh` (run detached
by `systemd-run --user`).

| Program | Metric | head / base, mean over layouts | 95% interval | head slower at |
| --- | --- | ---: | ---: | ---: |
| Lua's five scripts, 33 orders | user cycles | −1.40% | −1.75% to −1.04% | 4 of 33 |
| | task-clock | −1.37% | −1.71% to −1.02% | 4 of 33 |
| | user instructions | −2.08% | −2.10% to −2.06% | 0 of 33 |
| speedtest1, 8 shifts | user cycles | −0.60% | −0.92% to −0.27% | 0 of 8 |
| | task-clock | −0.54% | −0.84% to −0.25% | 0 of 8 |
| | user instructions | −1.20% | | 0 of 8 |

By Lua script, cycles change by:

| Script | Cycles | 95% interval |
| --- | ---: | ---: |
| `arithmetic` | −3.07% | −4.05% to −2.09% |
| `calls` | −2.25% | −2.95% to −1.55% |
| `strings` | −1.67% | −2.19% to −1.15% |
| `tables` | −0.60% | −1.23% to +0.03% |
| `closures` | −0.46% | −1.44% to +0.51% |

Unlike #2592's earlier steps, the time follows the instructions here. #2592's sink removed moves that Zen 5 eliminates at
rename. This change removes recomputations, saves and an edge's cycle besides moves.

**Static reports** (`--tier1-report`, `9700x/reports-*.txt`):

| Object | Edge moves, base → head | Spill stores, base → head |
| --- | ---: | ---: |
| Lua's objects | 3,056 → 2,530 | 555 → 552 |
| `lvm.o` | 1,196 → 881 | |
| speedtest1 | 39,235 → 35,590 | 12,645 → 12,634 |

## 3. Compile time on the 9700X

`scripts/compile.sh` runs head's `measure-compile` with base as `--reference`, the two compilers' processes interleaved,
pinned to CPU 2, with one hold of the lock per input (`9700x/compile/`):

| `--tier1 --lanes 1 -c`, medians | base | head | head / base |
| --- | ---: | ---: | ---: |
| `sqlite3.c`, 21 runs: wall | 610.88 ms | 614.58 ms | +0.61% |
| user cycles | 3,279.8 M | 3,301.6 M | +0.66% |
| user instructions | 8,168.7 M | 8,195.5 M | +0.33% |
| `lvm.c`, 41 runs: wall | 29.312 ms | 29.316 ms | +0.01% |
| user cycles | 128.3 M | 129.1 M | +0.61% |
| user instructions | 371.5 M | 372.7 M | +0.33% |

The change is the only difference between the two compilers. The work it adds to every function:

- the carried proof's scan of each range;
- its worklist over the candidates' successors;
- the alternates' column;
- the start hints' check of the alternate.

How the 0.33% more instructions split between that work and its effects on the later stages, whose input it changes,
isn't measured.

**Peak RSS.** It is 4.5 MB higher at both inputs (306,284 → 310,968 KiB for `sqlite3.c`, 96,636 → 101,212 KiB for
`lvm.c`), while minor faults are slightly lower (7,042 → 7,018 and 2,326 → 2,301). A constant across inputs of such
different sizes is not the new columns, which scale with ranges; it isn't traced further here.

## 4. Tests

- **`tests/x86-64/`:** `scripts/tests.sh`'s 29 Tier 1 commands on the head's `x86-64` build, in the cloud container, all
  passing. `commands.txt` lists each command's status, and each command's output is beside it.
- **`tests/native/`:** the native (AVX-512) build's vector-path suites, also all passing.
- **Mutations:** a build with each of the four rules turned off failed its own new test (the carried proof's tally, the
  alternate's trace, the address tie and the shift's scratch check).
