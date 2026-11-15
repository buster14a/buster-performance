# Tier 1: a handler a goto enters takes the dispatch's registers (buster#2782, buster#2592)

Evidence for [buster14a/buster#2788](https://github.com/buster14a/buster/pull/2788). It does
[#2782](https://github.com/buster14a/buster/issues/2782), the last part of
[#2592](https://github.com/buster14a/buster/issues/2592) (`luaV_execute`'s moves through `r11`). The design and its
reasoning are in buster's `docs/tier1-allocation.md`, "A handler a goto enters (#2782, #2592)".

- **base:** main `6415e30051962f3632d1c33384a0dd326e8919f0`.
- **head:** `5f78e51482e02b6bf842e347453d9ef653adf262`. The pull request's `e5eb440f` adds only docs.
- **main with #2773:** [buster14a/buster#2773](https://github.com/buster14a/buster/pull/2773)'s head
  `bc298522db73d7d96243c62dac9674c2443a3317`, which has main `6415e30` merged in. #2592's measure needs it:
  `OP_TFORCALL`'s rotation through `r11` shows only with its allocation.
- **that and head:** #2773's head with this change's code (`5f78e51`'s diff) applied.

## 1. Callgrind (cloud container)

Method: #1189's `gap.c` (`GAP_INSTRUCTIONS=1`) and #1217's inputs, as in the #2592 and #2734 records.

- **Builds.** Each compiler is an `x86-64` Release build (valgrind runs only the scalar host).
- **Lua.** Lua 5.4.8 by `--tier1 -fno-asynchronous-unwind-tables`, with its string-hash seed fixed
  (`-Dluai_makeseed(L)=0x2592u`). Its five scripts are checked against clang -O0's output.
- **speedtest1.** speedtest1 as one unit by `--tier1`, with `--size 5` mix1, checked by its `--verify` hash.

The scripts are `scripts/buildlua.sh`, `luacount.sh`, `st.sh`, `conv.sh`, `moves.sh` and `funcs.sh`. The measured
head compiler (`m6v2` in the file names) is an earlier build of the same code as `5f78e51`: both give the same `lvm.o`
and the same speedtest1 object, byte for byte.

| | main | head | main with #2773 | that and head |
| --- | ---: | ---: | ---: | ---: |
| `luaV_execute`'s instructions | 2,214,904,013 | 2,214,442,029 | 2,195,666,534 | 2,195,270,547 |
| its register moves | 318,636,857 | 318,174,873 | 313,405,754 | 313,009,767 |
| of them through `r11` | 1,480,040 | 1,480,040 | 132,002 | 4 |
| Lua's five scripts | 4,751,559,853 | 4,745,481,537 | 4,727,741,874 | 4,728,791,228 |
| speedtest1 | 2,610,833,670 | 2,610,119,925 | 2,590,337,129 | 2,589,573,221 |

`counts/` holds the files behind these numbers:

- `callgrind-summary.txt`: each configuration's totals and checks (`main6` is main, `m6v2` head, `c2base` main with
  #2773, `c2v2` that and head).
- `*/instructions.txt`, `check.txt` and `speedtest1.txt`: the per-script counts, the output checks, speedtest1's count
  and hash.
- `moves.txt`: `luaV_execute`'s moves, and those through `r11` by address.
- `functions-*.txt`: each function's change over 10 K, against main and against main with #2773.

**What the numbers say:**

- **`r11`.** On main the 1.48 M are `OP_GETTABUP`'s fetch (two moves of 0.74 M), which #2773 removes. With #2773
  the 132,002 are `OP_TFORLOOP`'s jump back into `OP_TFORCALL`, rotating `pc`, `i` and `trap`. With this change they
  are gone. The 4 left are one swap's two moves through `r11`, run twice: `OP_CLOSE` puts `luaF_close`'s constant
  arguments 0 and 1 in each other's registers. That kind of swap before a call is
  [#2823](https://github.com/buster14a/buster/issues/2823): 5.80 M of Lua's moves through `r11` at 283 sites, almost
  all outside `luaV_execute`.
- **Lua's totals** move by `luaH_getshortstr`: −5.40 M on main, +1.71 M with #2773. Its code is the same in every
  build. Its chains follow the addresses Lua hashes pointer keys by, which move with the binary. Apart from it, no
  Lua function runs more than 10 K more; `luaV_execute` runs −0.46 M and −0.40 M, `luaS_newlstr` −0.09 M and
  −0.11 M.
- **speedtest1** runs 0.71 M and 0.76 M fewer: `resolveP2Values` −0.43 M, `cellSizePtrTableLeaf` −0.14 M,
  `sqlite3_str_vappendf` −0.10 M and −0.15 M. No function runs more than 10 K more.

**Dropped: the convention for the block's other values too** (`m6full`, `c2full` in `callgrind-summary.txt`). Giving
the dispatch's registers to every value live into the handler, not only its phis, spilled `trap` around
`OP_TFORCALL`'s call. Lua ran 4,749.7 M on main (head: 4,745.5 M) and 4,731.7 M with #2773 (that and head: 4,728.8 M).

## 2. Tests

- `tests/x86-64/`: the x86-64 (scalar host) build of `5f78e51`, by `scripts/tests.sh`. `commands.txt` lists each
  command with its status; each command's output is in the file named by the first 8 hex digits of the command's
  `md5sum`. All 29 commands passed, the four `tests/driver/tier1_*.c` drivers among them.
- `tests/native/`: the native (AVX-512) Release build of `e5eb440f` (same code), `test-tier1-allocation`, `-cfg`,
  `-select`, `-emit`, `-pipeline --cross-check`, `test-ir-optimize` and `test-ssa-source --typed --tier1
  --generate 48`. All passed.

## 3. Run time on the 9700X

Main `6415e30` against head `5f78e51`, without #2773. With #2773 the change also removes `OP_TFORCALL`'s 132,002
moves through `r11`, which Zen 5 eliminates at rename: too few to time.

Method: #2553's, as in the #2592 and #2734 records.

- **Compilers.** Both are `BUSTER_HOST_ARCH=znver5` Release builds (`9700x/build.log`).
- **Objects and links.** Each compiler builds Lua's 33 objects and speedtest1's unit once. Lua is linked in 33 orders
  (order 0 the usual one, the others seeded `shuf`s), speedtest1 after pads of 0 to 3,696 bytes.
- **Checks.** All 82 executables passed first: each Lua script's output against clang -O0's, and speedtest1's
  verification hash (`9700x/checks.txt`).
- **Timing.** One untimed round of each program, then 5 timed rounds of Lua and 7 of speedtest1. Each round is one hold
  of the shared lock, as other sessions queued for it. Each run is `perf stat` pinned to CPU 2, in #2553's order
  (revisions rotated, Williams design).
- **Analysis.** `scripts/analyze.c` produced `9700x/analysis.txt`. Every run's counts are in `9700x/runs/runs.txt`
  (1,762 runs, none failed); `9700x/runs/busy.txt` has the busiest processes at each hold's start and end.

The scripts are `scripts/compilers.sh`, `objects.sh`, `link.sh`, `links.sh`, `checks-lua.sh`, `checks-st.sh`,
`round.sh`, `time2.sh` and `chain.sh` (run detached by `systemd-run --user`).

| Program | Metric | head / base, mean over layouts | 95% interval | head slower at |
| --- | --- | ---: | ---: | ---: |
| Lua's five scripts, 33 orders | user cycles | −0.09% | −0.32% to +0.15% | 16 of 33 |
| | task-clock | −0.10% | −0.33% to +0.13% | 16 of 33 |
| | user instructions | +0.00% | −0.01% to +0.02% | 19 of 33 |
| speedtest1, 8 shifts | user cycles | −0.17% | −0.52% to +0.19% | 3 of 8 |
| | task-clock | −0.10% | −0.45% to +0.24% | 3 of 8 |
| | user instructions | −0.03% | | 0 of 8 |

- **Flat, as expected.** On main the change removes about 0.46 M register moves from `luaV_execute` and 0.71 M
  instructions from speedtest1 (2,558.31 M → 2,557.59 M here, as by callgrind).
- **Lua by script.** `closures` −0.68% (−1.32% to −0.03%) and `tables` +0.48% (+0.09% to +0.87%), `calls`,
  `strings` and `arithmetic` within ±0.25%. By link order a script's change ranges up to 7% (`closures`, −7.37% to
  +1.79%). Lua's instructions vary with the link order by ±0.1% (`luaH_getshortstr`'s hash chains, §1), so they don't show the 0.46 M.

**Static reports** (`--tier1-report`, `9700x/reports-*.txt`):

| Object | Edge moves, base → head | Spill stores, base → head | Spill loads, base → head |
| --- | ---: | ---: | ---: |
| Lua's objects | 2,258 → 2,246 | 553 → 553 | 596 → 596 |
| `lvm.o` | 850 → 840 | 266 → 266 | 308 → 308 |
| speedtest1 | 34,685 → 34,639 | 12,618 → 12,624 | 13,947 → 13,952 |

## 4. Compile time on the 9700X

`scripts/compile.sh` runs head's `measure-compile` with base as `--reference`, the two compilers' processes interleaved,
pinned to CPU 2, with one hold of the lock per input (`9700x/compile/`):

| `--tier1 --lanes 1 -c`, medians | base | head | head / base |
| --- | ---: | ---: | ---: |
| `sqlite3.c`, 21 runs: wall | 611.780 ms | 612.062 ms | +0.05% |
| user cycles | 3,287.8 M | 3,288.4 M | +0.02% |
| user instructions | 8,077.1 M | 8,082.9 M | +0.07% |
| `lvm.c`, 41 runs: wall | 29.490 ms | 29.475 ms | −0.05% |
| user cycles | 129.1 M | 129.0 M | −0.08% |
| user instructions | 370.3 M | 370.8 M | +0.14% |

- **Instructions.** `sqlite3.c` runs 5.8 M more, not traced by stage. The change adds the dispatch search to the
  sibling loop, the phis' convention to `tier1_cfg_phi_exits` and wider family checks to the sink.
- **Peak memory.** It rises by about 1.9 MB at both inputs (306,220 → 308,192 KiB; 96,712 → 98,672 KiB), with 3 to 4
  more minor faults. The rise is constant, not traced; head's binary has 24 KB more text and 44 KB more `.bss`.
