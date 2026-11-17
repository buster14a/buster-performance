# Tier 1: an extension to I64 that its operand's register holds is that operand (#2843), 2026-11-17

Evidence for [buster14a/buster#2843](https://github.com/buster14a/buster/issues/2843) and its pull request
[buster14a/buster#2912](https://github.com/buster14a/buster/pull/2912). By Claude in David's directed session
([the session](https://claude.ai/code/session_01NNmNQse87HRhBpSZtPhkHn)).

Since #2838, `s += p[i] > 0 ? p[i] : 1` (`long s`, `int* p`) extends `p[i]` to `long` in its arm: the comparison reads
the narrow load, the select its extension. The load is sign-stored (its I64 extension requests it), so the extension is
a copy of the load's register; the load stays live past it, so the copy took a register of its own (`movslq
(%rdi,%rcx,4),%rdx; mov %rdx,%r8; mov $0x1,%r9d; test %edx,%edx; cmovg %r8,%r9`). The change
(`tier1_select_extension_forwards`) makes every pattern read the operand's register in place of an extension to I64
that selection takes as its operand's copy, where the operand has other uses, through #2601's column of firsts.
buster's `docs/tier1-selection.md` has the rule.

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| main | `d876a5e0f0252407e467e95dc602b3ad26895f9d` | the pull request's base |
| head | `c33c539954dab1de265c7429414725bf0467b082` | the rule, its tests and docs (the pull request's one commit) |

The cloud container's counts below used a Develop build of head's first version, `7e39ca10`, which differs from
`c33c5399` only by two function headers joined on one line; the container's `sqlite3.c` object by the commit's own
build is the same bytes (`objects/`).

## 1. Code shape (cloud container)

**Method.** `--tier1 -c` by main's and head's compilers (`counts/identities.txt` has their hashes): CI's frozen corpus
(`preprocessor-391e729af658`, `tools/ci/fetch-corpus.sh`) `sqlite3.c` with `test-tier1-cfg-source`'s options in
`tools/ci/correctness.tests` (`-march=znver5 -std=gnu17`, the pinned predefines and headers), and musl's 1,355 files with
that file's musl options. `objdump -d` counts every instruction and every `mov` between two registers;
`scripts/function-counts.py` compares each function's instructions (padding left out).

| | instructions | register-to-register `mov`s | functions shorter / longer |
| --- | ---: | ---: | ---: |
| `sqlite3.c` (1,354 functions) | 374,291 to 372,497 (-0.48%) | 51,018 to 49,498 | 396 / 5 |
| musl (1,773 functions) | 157,081 to 156,527 (-0.35%) | 17,833 to 17,321 | 92 / 0 |

`sqlite3.c`'s `.text`: 1,475,496 to 1,470,072 bytes. The longer functions (`objects/sqlite-functions.txt`):
`resolveExprStep` +12 instructions, `sqlite3SrcListDup` +4, `sqlite3VdbeMemGrow` +2, `renameColumnElistNames` +2,
`dupedExprSize` +1. In `resolveExprStep` the operand that now replaces its extension lives to the extension's last
reader, and the allocator moves a spill of `%r14` around a region (`mov %r14,0x108(%rsp)` and its reloads at four
branches) while dropping two register copies.

## 2. Programs' instructions (callgrind, cloud container)

**Method** (`scripts/counts.sh`, with `buildlua.sh`, `luacount.sh` and `st.sh` from
`tier1-select-compare-2676-2026-11-15`, this record's paths): Lua 5.4.8 (sha256 `4f18ddae…29ae`) by each compiler's
`--tier1 -fno-asynchronous-unwind-tables`, its string-hash seed fixed, running #1189's five scripts
(`tier1-reciprocal-141-2026-11-01/9700x/lua/`), each script's output checked against clang -O0's build; and the frozen
`sqlite3.c` with `speedtest1.c` at SQLite `ccc132c5` (sha256 `b5eaf4bb…9675`) as one unit, #2767's speedtest1 options,
its `--verify` hash checked. Whole-process user instructions under callgrind (`counts/`).

| | main | head |
| --- | ---: | ---: |
| Lua's five scripts | 4,592.17 M | 4,584.98 M (-0.16%) |
| `calls` | 496.57 M | 494.66 M (-0.38%) |
| `tables` | 927.40 M | 926.33 M (-0.12%) |
| `strings` | 996.14 M | 995.81 M (-0.03%) |
| `arithmetic` | 911.83 M | 911.83 M (-0.0003%) |
| `closures` | 1,260.23 M | 1,256.36 M (-0.31%) |
| speedtest1 | 2,529.77 M | 2,506.37 M (-0.93%) |

Every script printed clang -O0's output at both (`counts/lua-*/check.txt`), and speedtest1 its verification hash
`1248168 a7fa3957…` at both (`counts/st-*/verify.txt`).

## 3. The kernels on the 9700X

**Method** (`scripts/setup.sh`, `kernels.sh`, `kernels-build.sh`, `lock.sh`; `run.sh` ran them detached): each tree is
`git archive` of its commit, built by `BUSTER_DEBUG_INFO=0 ./build.sh --config Release` (the 9700X's toolchain), one
hold each (`9700x/setup.log`). `scripts/kernels.c` (#2678's record's `k_one`, `k_both` and `k_logic`, and `k_one` over
`unsigned` and `unsigned short` elements) by main's and head's `--tier1 --tier1-strict -c` and by clang -O2
`-fno-vectorize -fno-slp-vectorize`, each linked with one clang -O2 driver (`scripts/driver.c`: 4,096 elements, 20,000
calls, -1, 5, 0 and 2000 repeating; the unsigned words are their bits, the halves 65535, 5, 0 and 2000). Every kernel
sits at the same address in main's and head's executables (`9700x/kernels/build.txt`: `k_one` at 0x13b0, offset 48 of
its 64-byte line, `k_unsigned` 32, `k_half` 16). 11 rounds, each one hold of the lock, the three builds' order rotated
by round, each run after an untimed one, pinned to CPU 2 under `perf stat -e cycles:u,instructions:u`
(`9700x/kernels/runs.txt`, 165 runs, every status 0). The three builds print the same checksum
(`9700x/kernels/checksums.txt`). `9700x/host-identity.txt`: Linux 6.18.50, governor and EPP `performance`, clang 23.1.1,
perf 7.2.9. No other process used 5% of a CPU in any hold's snapshot (`9700x/busy.txt`), and `exclusive.sh` listed none.

Milliseconds for the 20,000 calls (best/median/worst) and the median user cycles, with their range
(`9700x/kernels/table.txt`):

| kernel | main | head | head / main | clang -O2 | instructions M, main / head / -O2 |
| --- | ---: | ---: | ---: | ---: | ---: |
| `k_one`, `s += p[i] > 0 ? p[i] : 1` | 26.1/26.5/28.9 ms, 145.1 Mcyc (144.9–160.7) | **24.8/24.8/26.4 ms, 137.8 Mcyc (137.7–146.9)** | 0.950 | 15.5 ms, 86.3 Mcyc | 737.9 / 656.0 / 389.9 |
| `k_unsigned`, the same over `unsigned` | 29.7/29.7/30.0 ms, 165.0 (164.9–165.0) | 29.7/29.7/30.1 ms, 165.0 (164.9–165.0) | 1.000 | 14.9 ms, 83.0 | 737.9 / 656.0 / 389.9 |
| `k_half`, `s += p[i] > 300 ? p[i] : 2` over `unsigned short` | 22.4/22.4/27.5 ms, 124.7 (124.7–151.4) | **21.7/21.7/22.0 ms, 120.6 (120.5–120.8)** | 0.967 | 14.9 ms, 82.9 | 737.9 / 656.0 / 389.9 |
| `k_both` (control, the same code) | 24.3/24.3/24.3 ms, 135.2 (135.2–135.2) | 24.3/24.4/29.1 ms, 135.2 (135.2–161.9) | 1.000 | 14.9 ms, 83.0 | 737.9 / 737.9 / 410.4 |
| `k_logic` (control, the same code) | 28.6/28.7/29.0 ms, 159.2 (159.1–159.4) | 28.6/28.6/29.2 ms, 159.2 (159.1–162.4) | 1.000 | 13.7 ms, 76.2 | 901.8 / 901.8 / 451.4 |

- **`k_one`**, the issue's kernel, is 24.8 ms again, #2838's main's 24.7 (`constant-arms-2678-2026-11-15`'s run 2), from
  26.5: 1.68 cycles an element for 1.77, its loop one instruction shorter (`9700x/kernels/h1.s`).
- **`k_half`** gains 3.3% the same way.
- **`k_unsigned`** loses the same instruction, 11% of its instructions, and runs 2.01 cycles an element either way: the
  copy isn't what bounds that loop (`cmp $0x7,%edx; cmova %rdx,%r8` where the others have `test`/`cmp` and `cmovg`).
- The controls, whose code doesn't change, read the same.

## 4. The compile's cost on the 9700X

**Method** (`scripts/compile.sh`): the frozen `sqlite3.c` (sha256 `0a409f16…e23d`, checked) by `--tier1 -c` with
speedtest1's flags: the objects' shapes in one hold (`9700x/compile/shape.txt`); buster's `time-runs --runs 11` of both
in one hold, its Williams order, CPU 2, the object on tmpfs (`9700x/compile/compile-time.txt`); then
`benchmark-tier1-select-source` of `sqlite3.c` by each, head and main alternating, four runs each, a hold each, CPU 2
(`9700x/compile/select-*.txt`).

| `-c sqlite3.c --tier1` | wall (ms) | user cycles (M) | instructions (M) |
| --- | ---: | ---: | ---: |
| main | 627.196 (626.435 to 628.183) | 3,368.29 | 8,339.76 |
| head | 626.723 (626.344 to 628.923), -0.08% | 3,368.53, +0.01% | 8,324.88, -0.18% |

The compile costs the same: the code it emits is 1,896 instructions shorter (`shape.txt`: 381,522 to 379,626, `.text`
1,502,792 to 1,497,176 bytes, register-to-register `mov`s 51,406 to 49,802), and selection does a little more.

Selection alone, cycles per IR instruction over `sqlite3.c`'s 448,167 (the median of four runs, with their range):

| | vector path | scalar path | instructions per IR instruction (vector / scalar) |
| --- | ---: | ---: | ---: |
| main | 372.92 (372.66 to 373.04) | 411.66 (411.28 to 412.13) | 954.94 / 1184.74 |
| head | 373.05 (372.45 to 373.78), +0.04% | 413.65 (412.59 to 414.10), +0.48% | 956.14 / 1187.12 |

The column is now made for every function with an extension to 64 bits or a symbol's address (it was made where one
repeated), and each leaf asks whether it forwards: +0.13% and +0.20% instructions in selection, about 5% of the
compile's cycles.

## Limits

- Section 1's and 2's counts are the cloud container's (an Intel Xeon), not the 9700X's: instructions, not time. The
  programs' run times weren't measured on the 9700X (a pull request's CI skips the hardware job, #2055).
- One driver for the kernels, one placement each (the same address in both builds).
- The 9700X was shared; each run was one hold of the lock.
