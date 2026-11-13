# Tier 1's addition of a load from memory (#2602), 2026-11-13

This is the evidence for [buster#2602](https://github.com/buster14a/buster/issues/2602) and [buster#2615](https://github.com/buster14a/buster/pull/2615). By Claude, in David's directed session ([the session](https://claude.ai/code/session_01Egbxndcswcy5h6cwFvZ4QF)).

**The change.** An `add`, `and`, `or` or `xor` from memory is at most two records. Where the destination is the address's base or index, the expander loads into the destination, then applies the operation with the other operand's register. The grammar and the candidate price these forms at 2, against 3 before. `sub` keeps 3 for its scratch copy, and `imul` keeps 3 with its immediate form's penalty. The `lea` of two registers comes after the memory forms in the grammar, so an addition of a load, which costs 2 both ways, takes `add` from memory.

#2602's first experiment ([its comment](https://github.com/buster14a/buster/issues/2602#issuecomment-6836512802)) priced the memory form at 1 with the scratch copy kept, against an older main. It saved 0.41 M of speedtest1's instructions and was left out. This record measures the change as buster#2615 makes it.

The record follows [`tier1-followups-2600-2601-2026-11-12`](../tier1-followups-2600-2601-2026-11-12/README.md)'s method and scripts. It has five parts:
- counts in a cloud container: records, static counts, and dynamic counts by callgrind;
- run time on the Ryzen 7 9700X;
- compile time on the 9700X;
- speedtest1's run time on the 9700X again, with its files in `/tmp`;
- speedtest1 at four other code placements, which separates its one layout's cycles from the change's.

**Summary.** speedtest1 and Lua run 0.12% and 0.11% fewer instructions on the 9700X (0.12% each by callgrind), all of it `mov`s. Lua's time is 0.9% lower, within its layouts' spread. speedtest1's driver-linked executable runs 0.5% more cycles, but at four other placements the head is 0.16% lower on average, so that's the placement's. Compiling sqlite3.c takes 0.3% fewer cycles, and Tier 1's records fall by 170 on sqlite3.c and 38 on Lua, with no spill or reload changed.

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| base | `df85213e8f52e71f9b24a402891bdd37b1df500b` | buster's main with #2600 and #2601 merged (buster#2605) |
| head | `f63385bb83de95d748590dca14f404306a8f7f08` | buster#2615's first commit: the change, its tests and documentation (its later commits change only documentation) |

## Inputs

The inputs are #1189's, as in the two records before (`9700x/host.txt` and `counts/host-and-identities.txt` have their hashes):
- the frozen `sqlite3.c` (SHA-256 `0a409f16…`);
- SQLite's `test/speedtest1.c` (`b5eaf4bb…`), with #136's flags and options;
- Lua 5.4.8's release (`4f18ddae…`) and the five scripts.

Tier 1 builds use `--tier1 -fno-asynchronous-unwind-tables` at the default target.

## 1. Counts in the container

**Host.** A cloud container: an Intel Xeon with AVX-512 under KVM, clang 23.1.6, valgrind 3.22.0 and GNU objdump 2.42. `counts/host-and-identities.txt` also has the executables', the compilers' and the tools' hashes. Each compiler was built natively there by `./build.sh` (Release).

### Records

`scripts/records.sh` compiled the frozen `sqlite3.c` (#1190's flags) and Lua's 33 sources, each with `-c --tier1-report`, and summed the reports (`counts/records.txt`):

| | base | head |
| --- | ---: | ---: |
| `sqlite3.c`, 2,668 functions, records | 253,380 | 253,210 (−170) |
| Lua, 1,088 functions, records | 54,922 | 54,884 (−38) |
| spill stores and loads, rematerializations, edge moves, spill slots (both) | | unchanged |

### Static

`scripts/static.sh` read the same objects with objdump (`counts/static.txt`):

| | base | head |
| --- | ---: | ---: |
| `sqlite3.c`, `.text` | 991,880 B | 991,432 B (−448 B) |
| `sqlite3.c`, instructions | 273,483 | 273,269 (−214) |
| `sqlite3.c`, `add` from memory | 0 | 394 |
| `sqlite3.c`, `mov` from memory | 46,178 | 45,787 (−391) |
| Lua, `.text` | 208,650 B | 208,564 B (−86 B) |
| Lua, instructions | 62,746 | 62,726 (−20) |
| Lua, `add` from memory | 0 | 68 |

### Dynamic: speedtest1

`scripts/count.sh` built speedtest1 by each compiler and ran it once under callgrind. #1189's [`gap.c`](../tier1-gap-1189-2026-11-03/tools/gap.c) (SHA-256 `81856ce1…`) joined the counts with the disassembly. Both executables gave speedtest1's verification hash natively. `scripts/mnemonics.py` and `scripts/memory_alu.py` sum the rows (`counts/speedtest1*.t*`):

| | base | head |
| --- | ---: | ---: |
| whole process | 3,010.68 M | 3,007.22 M (−0.115%) |
| speedtest1's own code | 2,837.92 M | 2,834.46 M (−0.122%) |
| `mov` | 1,056.54 M | 1,053.08 M (−3.46 M) |
| `lea` | 163.54 M | 163.20 M (−0.34 M) |
| `add` | 159.13 M | 159.46 M (+0.34 M) |
| `add` from memory | 0 (0 rows) | 6.58 M (198 rows) |
| `and`, `or`, `xor`, `sub`, `imul` from memory | 5.75 M | 5.75 M |

The 6.58 M `add`s from memory split three ways:
- 3.46 M replace a load and an `add` whose sum took the other operand's register, which saves the load's `mov`;
- 0.34 M replace a `lea` of the load's register: `mov t, [m]; lea d, [l + t]` becomes `mov d, l; add d, [m]`;
- the other 2.78 M keep two instructions: a load and an `add` become a copy and an `add` from memory, or the load into the destination and the `add`.

### Dynamic: Lua

Lua 5.4.8 seeds its string hashes from `time()` and addresses (`luai_makeseed`, `lstate.c`), so a script's instruction count changes from run to run. The stock base's `closures.lua` ran 1,421.34 M and 1,424.94 M instructions in two runs (`counts/lua-time-seeded.txt`), more than the change. So `scripts/lua-fixed.sh` rebuilt `lstate.c` by each compiler with `-D'luai_makeseed(L)=0x2602u'` and relinked the other 32 objects of `records.sh` (the usual order). It ran each script once under callgrind and checked its output against clang -O0's (all five match). A fixed-seed run repeats: the base's `closures.lua` ran 1,422,244,055 and 1,422,243,826 instructions. `scripts/lua_mnemonics.py` sums the five scripts (`counts/lua-fixed.txt`, `counts/lua-mnemonics.tsv`):

| Lua's own code | base | head | change |
| --- | ---: | ---: | ---: |
| `calls.lua` | 607.67 M | 606.71 M | −0.157% |
| `tables.lua` | 1,063.64 M | 1,063.58 M | −0.006% |
| `strings.lua` | 814.60 M | 814.43 M | −0.021% |
| `arithmetic.lua` | 1,145.27 M | 1,141.78 M | −0.305% |
| `closures.lua` | 1,243.11 M | 1,241.89 M | −0.099% |
| the five | 4,874.29 M | 4,868.39 M | −5.90 M (−0.121%) |

All of the change is `mov`s (−5.90 M). The head executes 8.57 M `add`s from memory; `and`, `sub` and `imul` from memory don't change.

## 2. Run time on the 9700X

`scripts/run2602.sh` (#2600's record's `run2600.sh`, its paths and lock identity changed) built both compilers, at their commits in trees of their own, by `./build.sh` with `BUSTER_DEBUG_INFO=0` at the host's native target (znver5). It then built each one's Lua objects and speedtest1, clang -O0's Lua, and the first layout's two links. It took the lock for every run, and that morning four other sessions' jobs were taking it in turn: each of its holds waited about two minutes, and its 770 holds would have taken more than a day. So `scripts/measure2602.sh` made the rest of the links, the checks and the runs in about 74 holds, each under about 10 s, with the same rounds, layouts, counters and output files:
- one hold per build for its six layouts' links;
- one for every Lua check, and one per build for speedtest1's hash;
- in each round, one per build for its six layouts' five scripts, and one for both builds' speedtest1.

**Host.** `9700x/host.txt`: Linux 6.18.50, clang 23.1.1, perf 7.2.9, CPU 2's governor `performance`, `/home` 77% full. `9700x/compilers.sha256` and `9700x/executables.sha256` have the hashes, `9700x/build-*.log` the builds' logs and `9700x/orders.txt` Lua's six link orders.

**Checks before any timing** (`9700x/run.log`, `checks status 0`): every Lua executable printed clang -O0's output for every script, and both speedtest1 builds gave the verification hash (`9700x/verify-*.txt`).

**Timing.** Eleven rounds, each run pinned to CPU 2 with one `perf stat` of task-clock, user cycles and user instructions (`9700x/runs.txt`). `scripts/analyze.py` produces `9700x/analysis.md`.

| | head / base | interval or range |
| --- | ---: | --- |
| Lua's five scripts, time | 0.9912 | 95% over the layouts: 0.9791 to 1.0033 |
| Lua's five scripts, user cycles | 0.9908 | 0.9779 to 1.0039 |
| Lua's five scripts, user instructions | 0.9989 | 0.9986 to 0.9993 |
| speedtest1, time | 1.0022 | paired rounds: 0.9895 to 1.0194 |
| speedtest1, user cycles | 1.0051 | paired rounds: 0.9957 to 1.0105 |
| speedtest1, user instructions | 0.9988 | paired rounds: 0.9988 |

- **Lua.** It runs 0.11% fewer instructions. Its time and cycles are 0.9% lower, within the layouts' spread: the six layouts' cycle ratios run from 0.9687 to 1.0012. `arithmetic.lua`'s cycles drop 6% (0.9402), and `closures.lua`'s rise 1.5%.
- **speedtest1.** It runs 0.12% fewer instructions but 0.5% more user cycles, higher in 10 of the 11 rounds. Part 5 shows that this comes from the executable's placement.

## 3. Compile time on the 9700X

`scripts/measure2602.sh` timed two compiles by both compilers, as #2600's `compile2600.sh` did, with one hold per round for both builds:
- `--tier1 -c` of the frozen `sqlite3.c`, with speedtest1's flags;
- `--tier1` of Lua's 33 sources into an executable.

It ran 11 rounds after one warm-up pair, the builds' order alternating, on CPU 2 (`9700x/compile-runs.txt`). Both programs' outputs were the same in every round (`9700x/compile.log`). `scripts/compile_analyze.py` produces `9700x/compile-analysis.md`:

| Compile | base | head | head / base, paired median (range) |
| --- | ---: | ---: | ---: |
| sqlite3.c, time | 400.09 ms | 398.89 ms | 0.9979 (0.9942 to 1.0008) |
| sqlite3.c, user cycles | 2,121.9 M | 2,116.7 M | 0.9968 (0.9949 to 0.9992) |
| sqlite3.c, user instructions | 4,709.26 M | 4,707.37 M | 0.9996 |
| Lua, time | 166.35 ms | 165.65 ms | 1.0046 (0.9871 to 1.0399) |
| Lua, user instructions | 1,939.6 M | 1,934.6 M | 0.9974 |

The compile doesn't get slower: sqlite3.c's runs 0.04% fewer instructions and 0.3% fewer cycles, and Lua's 0.26% fewer instructions, its time within its spread.

## 4. speedtest1 with its files in `/tmp`

`scripts/measure2602.sh` then ran the same two speedtest1 executables with the database and SQLite's temporary files in `/tmp` (tmpfs): a warm-up pair and 11 pairs, alternating, one hold per pair, on CPU 2 (`9700x/st-tmp-runs.txt`, `9700x/analysis-st-tmp.md`).

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time (task-clock), ms | 175.26 | 176.51 | 1.0071 | 1.0078 (1.0013 to 1.0102) |
| user cycles, M | 877.76 | 881.95 | 1.0048 | 1.0048 (1.0006 to 1.0116) |
| user instructions, M | 2,960.19 | 2,956.73 | 0.9988 | 0.9988 |

The executables' placement again costs the head 0.5% of cycles, in all 11 pairs.

## 5. speedtest1 at four other placements

speedtest1 is one translation unit, so it has one layout, and a change that moves its code moves every function in it. `scripts/layout2602.sh` checked whether its +0.5% follows the change or the placement. Each compiler's `--tier1` compiled the unity file to an object, and cc linked it after a pad of 0, 528, 1,568 or 2,608 bytes of `.text` (`9700x/layout-pad-0.s` is the empty one). The object's `.text` is 16-byte aligned, so each pad moves the code to another 64-byte phase and page offset. All eight executables gave the verification hash. Then came a warm-up round and seven rounds, each one hold running the eight executables, the builds' order alternating, in `/tmp`, on CPU 2. The runs also counted store-to-load forwards (`ls_stlf`): a folded stack reload might lose the forwarding a `mov` gets. `scripts/layout_analyze.py` produces `9700x/layout-analysis.md` from `9700x/layout-runs.txt`:

| Pad, bytes | user cycles, head / base | paired rounds (range) | store-to-load forwards, head / base |
| ---: | ---: | --- | ---: |
| 0 | 0.9953 | 0.9935 to 0.9973 | 1.0018 |
| 528 | 1.0004 | 0.9962 to 1.0083 | 1.0008 |
| 1,568 | 1.0005 | 0.9964 to 1.0050 | 1.0007 |
| 2,608 | 0.9973 | 0.9915 to 1.0086 | 1.0010 |
| mean | 0.9984 | | 1.0010 |

At these placements the head's cycles are 0.16% lower on average, between −0.47% and +0.05%. Its instructions are 0.12% lower at every one. So the +0.5% at the driver-linked executable's placement is that placement's, not the change's. Store-to-load forwards rise 0.1% (0.35 M), with no cycle cost: speedtest1's folded `add`s read 1.45 M times from the stack and 5.14 M times from other memory (`counts/speedtest1-memory-alu.tsv` and the rows).

## Limitations

- **Lock holds.** `measure2602.sh` and `layout2602.sh` held the lock for a round's runs of one build (at most about 10 s) rather than for each run, because four other sessions' jobs were sharing it (part 2). Within a round, a build's six Lua layouts ran back to back rather than alternating with the other build's.
- **Lock receipts.** The scripts log their own steps and the lock's identity, but not the holder line `exclusive.sh` writes when a run takes the lock. The scripts' stdout (`run.out`, `measure.out`, `layout.out`) isn't included: it holds the lock's waiting lines, which name other sessions' commands and links.
- **Placement.** Part 5's placements are cc's links of one object; the driver links speedtest1 itself. The pads move the code as a whole, not one function against another.
- **Lua's seed.** The container's Lua counts use a fixed seed; the 9700X's runs use the stock Lua, whose seed the rounds and layouts average over.
- **Grammar size.** The tables grow from 960 to 998 states, against `BUSTER_TIER1_BURS_MAX_STATES`' 1,024; the rule count stays 189.
