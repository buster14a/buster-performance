# #777's "Done when" at main, beside #763's build, buster#777, 2026-11-06

This record re-checks [buster#777](https://github.com/buster14a/buster/issues/777)'s "Done when" at buster's main
on the Ryzen 7 9700X, with #763's merge built from its own commit and run beside main in the same `time-runs`.
It also finds where main's one-lane commands spend the time they take beyond #763's.

#777's "Done when":
- a command of a few large units (`sqlite3.c shell.c`, with `-c` and linked) is no slower than its units' processes
  run at once;
- the commands of #763's record (Lua's, synth's and musl's units) are no slower than with #763, with their peak
  memory;
- every object and executable is the same bytes at 1, 2, 3 and 8 lanes, and each object is its unit's alone
  (`test-check-units`).

The 2026-11-03 comparison compared main with the figures in #763's record (`units-152-2026-10-29`). This record runs
#763's executable instead: on the same host it now measures 1 to 12% above its record's figures (Results below), so
those figures no longer stand for it.

## Sources and trees

| tree | commit | `build/compiler` SHA-256 |
| --- | --- | --- |
| `tmain`: main | `ec5f0f6be04660d5b36ec688ba3d8ed3511ee85b` | `51fa8ef2c145ba232daf21fbe69257a10feaacb5e87e7be7aeae0bdd2dd92c59` |
| `t763`: #763's merge | `3ba1621fed10a30952a55d8a0a1803731ef32797` | `5f65b9f36ffcfd2bae3fef7d0b921b54b0afb99b5df9fd8c957f102bc064923b` |
| `thead`: keep every page | `47a0581abff9655cdbf523fc3b8f2146e1e9abc0` | `ae2f56c5747aef6b0187094181c2b3476ce6d65c05d09e01a395137e25ad6902` |
| `texp`: main and `EXP_DISCARD_MODE` | `ec5f0f6b` and `scripts/experiment-discard-modes.diff` | `67ba25383b4b0206107e99030b1a3415cf406f19a72c6625f84d45c3e20fb324` |
| `tfinal`: whole huge pages | `559ca5f6b337b00836adbc9500eb4f55d6fe47d7` | `3113b09e56d2dbace3670bab518a117122698bc0a72eb027f38bca32e1be8921` |
| `tfinal3`: the peak's huge page freed too | `53b33df2fdecbffe8c11b0c99a188939f1aa2b83` | `50fae4633e6df388919a8faa6716e4d785a90d38bd0beb714887f56354f1c9e0` |
| `tlast`: the PR's head | `36e5550d0fc70da02ee0a93a1eca338acdfb1cd4` | `d6fd2f11e5eb29cc1b0ac3adf0447275e930a362efb159049840de2718af4612` |

Each tree is `git archive` of its commit, sent to the host by `tar`. `receipts/manifest-*.txt` is each tree's
`sha256sum` on the host, without `build/` and the `COMMIT` file that names the commit. `receipts/manifests-checked.txt`
records that every hash matches `git archive` of the commit (1,263 files, #763's 750), and `texp`'s that of `ec5f0f6b`
with the experiment's diff applied. Every tree was built with `BUSTER_DEBUG_INFO=0` and the default
`BUSTER_HOST_ARCH=native` (`scripts/common.sh`'s `build`), each build under the host's lock (`logs/build*.log`).

Main moved to `f4272a46` (#1455, a checker diagnostics change) while this ran. That commit doesn't change
`c_checker_units.c`, `c_check_program_emit.c`, `lane.c` or `docs/translation-units.md`.

## Host and inputs

- **Host:** AMD Ryzen 7 9700X (`benchpress`), Linux 6.18.50-2-lts, clang 23.1.1, GCC 16.2.1 (`cc`), mold 3.0.0,
  perf 7.2.9.
- **Governors:** CPU 2 runs the `performance` governor and EPP; CPUs 0, 1 and 3 to 7 run `powersave` with
  `balance_performance`. Transparent huge pages are `always`, defrag `madvise` (`logs/measure-tmain.log`'s receipts).
- **Inputs:** the inputs of #763's record and of `units-control-777-2026-11-02`, at the same paths on the host:
  - SQLite 3.53.4's `sqlite3.c` (SHA-256 `b1dd5d74…db28189`) and `shell.c` (`8011ed01…11c85179`);
  - Lua 5.4.8's `src`, its 33 `.c` files but `luac.c`;
  - synth's 512 units of 200 functions (`test-check-units --generate`);
  - musl 1.2.5's 1,006 units that #763's record compiled. `scripts/musl-units-763.txt` lists them, taken from that
    record's `round2/makefiles/musl.mk`.

## Method

Every build, test and measurement held the host's lock (`exclusive.sh`) for itself. The lock was busy: every log has
`exclusive.sh`'s waiting messages, which name other jobs, and they are kept as they are.

- **`scripts/measure.sh tmain t763 lua synth musl sqlite`** (`logs/measure-tmain.log`). Every process runs on CPUs 0
  to 7. Each corpus is one `time-runs` with a warm-up, in an order that rotates by run.
  - Lua's link (21 runs) and synth's link (7 runs): by 8 lanes and by one, by each tree.
  - musl's 1,006 units with `-c` (7 runs): by 8 lanes and by one, by each tree.
  - The few large units, in two rounds of 31 runs, seven lists:
    1. main's one command with `-c`;
    2. main's two processes at once with `-c`;
    3. main's one command, linked;
    4. main's two processes, then mold's link (`cc -fuse-ld=mold`);
    5. the same with `cc`'s link;
    6. #763's one command with `-c`;
    7. #763's one command, linked.

    Each child's exit status is checked, and every output is removed before each run and required after it.
    Afterwards each list's objects are compared with main's objects of each unit alone, and each executable runs
    `select 6 * 7;`.
- **`scripts/final.sh`** (`logs/final-tmain.log`) runs three scripts, each holding the lock once:
  - **`profile.sh`:** `perf stat` on CPU 2 of a tiny unit's `-c` (11 runs) and of Lua's link by one lane (5 runs),
    then `perf record -e instructions:u` of that link, for each tree. `logs/profile-tmain/*/report.txt` has the
    top symbols.
  - **`attribute.sh`:** for each corpus, on CPU 2, the units with `-c` by one command on one lane against the same
    units compiled one process each, one after another, by each tree (`time-runs`, 11 runs for Lua and 5 for the
    others). In the same hold, each unit's `--time-stages` as a process of its own, three times by each tree. A
    command of several units reports its units' run as one stage, `lanes`. `stages.sum` has each stage's mean over
    the three repetitions of its sum over the units. Afterwards every object of each one command is compared with
    its process's.
  - **`peaks.sh`:** synth's link by 8 lanes by main, by main without the board (`BUSTER_TEST_NO_UNITS_BOARD=1`, the
    test hook that stands for the board's allocation failing) and by #763, and one synth unit's `-c` by each tree
    (7 runs, CPUs 0 to 7).
- **`scripts/tests.sh tmain`** (`logs/tests-tmain.log`): main's `test-check-units` on CPUs 0 to 7.
- **`scripts/quiet.sh tmain t763`** (`logs/quiet-tmain.log`): synth's link by 8 lanes and by one and Lua's by one,
  with `-w`, which skips main's common warnings (#1049's pass, `quiet`), by each tree (7 runs, CPUs 0 to 7).
- **`scripts/stalls.sh tmain t763`** (`logs/stalls-tmain.log`): synth's units with `-w` by one lane, and as processes,
  by each tree on CPU 2: `perf stat`'s cycles, instructions, page faults, L1 dTLB misses by page size and cache misses
  (`-r 3`; the processes' counts, `-r 1` over 512 short processes with the events multiplexed, are not used), main's
  one lane again without the board, and `perf record` of user cycles.
- **The fix's runs:**
  - `scripts/ab.sh HEAD tmain t763 synth lua musl sqlite`: a head against main with #763 beside them. Each corpus by 8
    lanes and by one, with the corpora's run counts above. The few large units by one command (`-c` and linked)
    against its processes at once (with mold's link), in two rounds of 31 runs. Executables and objects are compared
    with main's.
  - `scripts/modes.sh texp synth lua musl` (`logs/modes-texp.log`): an experiment's build of main
    (`scripts/experiment-discard-modes.diff`, not a commit) whose `EXP_DISCARD_MODE` picks `check_program`'s discard
    for every unit: 0, main's; 1, none; 2, whole huge pages to the last boundary at or below the peak.
  - `scripts/tests.sh HEAD`: the head's `test-check-units`.
  - `scripts/chain*.sh` ran these one after another, each waiting for the one before.

A first `profile.sh` took the lock once for each step, and waited about ten minutes for each. It was stopped after
its first steps, and `final.sh` replaced it. `logs/profile-first-attempt.log` has what that run printed.

## Results

### Main against #763 (`logs/measure-tmain.log`)

Medians; `wait4` peaks in MiB (KiB / 1,024).

**A few large units** (31 runs a round):

| ms (peak MiB) | round 1 | round 2 |
| --- | ---: | ---: |
| main's one command, `-c` | 138.545 (358.7) | 138.242 (358.9) |
| main's two processes at once, `-c` | 138.788 (338.3) | 138.360 (338.3) |
| main's one command, linked | 142.862 (362.7) | 142.928 (362.8) |
| main's two processes, then mold's link | 146.553 (338.3) | 146.400 (338.3) |
| main's two processes, then `cc`'s link | 155.773 (338.3) | 155.630 (338.4) |
| #763's one command, `-c` | 134.812 (484.2) | 134.983 (484.2) |
| #763's one command, linked | 140.788 (492.4) | 140.638 (492.3) |

Every run exited 0 (217 a round). Every list's objects are main's objects of each unit alone, and every executable
printed 42. The one command is 0.17% and 0.09% faster than its processes with `-c`, and 2.5% and 2.4% faster linked
than with mold's link. #763's one command is faster than main's because each unit's compile is cheaper there (1,722 million
instructions against 2,094 million); the board is what brings main's one command to its processes' time.

**#763's commands** (21 runs for Lua, 7 for synth and musl):

| ms (peak MiB) | main | #763 | main against #763 |
| --- | ---: | ---: | ---: |
| Lua, linked, 8 lanes | 33.196 (207.0) | 34.608 (213.4) | -4.1% |
| synth, linked, 8 lanes | 484.091 (547.1) | 545.635 (529.6) | -11.3% |
| musl, `-c`, 8 lanes | 148.474 (238.6) | 235.814 (248.6) | -37.0% |
| Lua, 1 lane | 98.735 (61.0) | 80.453 (74.1) | +22.7% |
| synth, 1 lane | 1,780.794 (318.2) | 1,632.746 (326.9) | +9.1% |
| musl, 1 lane | 689.095 (142.2) | 645.093 (153.9) | +6.8% |

#763's record has 30.9, 532.7 and 232.7 ms by 8 lanes and 76.1, 1,546.6 and 625.5 by one: #763's executable now
measures 1.3 to 12.0% above them on the same host.

### Where main's one lane goes (`logs/final-tmain.log`)

**Lua's profile** (`profile.sh`): Lua's link by one lane retires 1,234 million user instructions at main against 907
million at #763; a tiny unit's `-c`, 0.81 million against 12.58 million. `logs/profile-tmain/*/report.txt` has the top
symbols: `check_input_run` takes 13.7% of main's instructions against 1.9% of #763's, and `check_driver_common_warnings`
and `check_graph_run` are among main's.

**The units as one command and as processes** (`attribute.sh`, `-c`, one lane, CPU 2):

| ms | one command, main | processes, main | one command, #763 | processes, #763 |
| --- | ---: | ---: | ---: | ---: |
| Lua (33 units) | 95.092 | 168.909 | 76.924 | 188.651 |
| synth (512) | 1,766.080 | 2,956.870 | 1,609.274 | 3,598.153 |
| musl (1,006) | 685.101 | 1,578.742 | 638.277 | 2,586.887 |

Each one command's objects are its processes' bytes, at both trees. Without the start's cost, the processes' compiles
retire more instructions at main than at #763 by about as much as the one commands do:

| billion instructions more at main | one command | processes, less the start |
| --- | ---: | ---: |
| Lua | 0.33 | 0.36 |
| synth | 1.94 | 1.87 |
| musl | 1.27 | 1.99 |

The processes' stage sums (`stages.sum`), in ms, main against #763:

| stage | Lua | synth | musl |
| --- | ---: | ---: | ---: |
| `check-input` (#1489) | +12.14 | +31.43 | +30.85 |
| `check-program` (#1049's common warnings, #1340) | +10.89 | +69.10 | +54.18 |
| `tier0` | +1.07 | +28.76 | +4.87 |
| `setup` | -6.56 | -121.51 | -164.95 |
| `backend-setup` | -23.64 | -365.80 | -607.04 |

**Without the common warnings** (`quiet.sh`, `-w`, which skips them as `quiet`; 7 runs, CPUs 0 to 7):

| ms (peak MiB) | main | #763 |
| --- | ---: | ---: |
| synth, 8 lanes | 472.506 (554.6) | 542.407 (529.3) |
| synth, 1 lane | 1,744.185 (322.5) | 1,635.216 (326.9) |
| Lua, 1 lane | 90.568 (62.9) | 80.605 (74.1) |

By one lane with `-w`, synth retires 1.2% more instructions at main than at #763 (29.08 against 28.73 billion) but
takes 6.2% more user cycles and 16% more minor faults (703,802 against 607,238). `stalls.sh` counts them on CPU 2
(`perf stat -r 3`): 8.08 billion cycles against 7.63, 699,649 page faults against 603,136, and 19.1 million L1 dTLB
misses against 16.2 million; main without the board measures as main. Main's top symbols by user cycles include
`__memset_avx512_unaligned_erms` (1.9%), which #763's don't.

**The cause** (reproduced on the session's cloud VM, a Xeon with transparent huge pages `madvise`, outside this
record's timings): `check_program` gives the scratch arena's pages past its columns back to the kernel
(`arena_discard`, #628). In a command of several units the scratch is the lane's, kept from one unit to the next, so
each unit's parse and reader fault those pages in again. A build of main that skips that discard took 124,956 faults
for 128 synth units by one lane with `-w`, against main's 174,373 and #763's 134,971, with the same objects and a
peak 168 KiB higher.

**Synth's peak by 8 lanes** (`peaks.sh`, 7 runs): 551.1 MiB by main, 548.6 MiB without the board, 528.4 MiB by #763.
One synth unit's `-c` peaks at 61.8 MiB by main and 73.2 MiB by #763. With `-w` main's peak by 8 lanes is 554.6 MiB.

**Tests** (`logs/tests-tmain.log`): main's `test-check-units` passed 2,390 checks with 0 failures; 319 of its large
unit's parts were taken by lanes without units.

### The fix's first form: keep every page (`logs/ab-thead.log`)

Head `47a0581a` (`thead`, `1c18a8b1` and the report's count): a lane with a unit left to take kept all of its
scratch's pages. Medians in ms, peaks in MiB:

| | head | main | #763 |
| --- | ---: | ---: | ---: |
| synth, 8 lanes | 474.028 (549.5) | 491.501 (550.4) | 553.310 (527.1) |
| synth, 1 lane | 1,718.597 (318.7) | 1,800.339 (320.6) | 1,632.924 (326.9) |
| Lua, 8 lanes | 33.836 (220.0) | 33.614 (210.1) | 35.292 (212.8) |
| Lua, 1 lane | 99.053 (66.5) | 100.235 (63.2) | 81.295 (74.1) |
| musl, 8 lanes | 145.281 (254.0) | 147.399 (240.1) | 233.642 (248.6) |
| musl, 1 lane | 683.275 (155.6) | 691.066 (144.6) | 640.628 (154.1) |

By one lane synth took 574,617 faults against main's 704,540. The few large units ran as main's (`-c`: 137.230 and
136.563 ms against 137.830 and 137.854, the processes 137.881 and 138.265; linked: 142.106 and 142.263 against
141.943 and 142.365, mold's 145.589 and 145.400): neither unit has a unit left to take when it reaches the checker.
Every object and executable is main's. But Lua's and musl's peaks rose by up to 14 MiB, above #763's.

### Which pages to give back (`logs/modes-texp.log`)

Medians in ms, peaks in MiB; minor faults for synth:

| | 0: main's | 1: none | 2: whole huge pages, to below the peak |
| --- | ---: | ---: | ---: |
| synth, 8 lanes | 481.691 (547.8), 627,932 faults | 469.570 (554.0), 504,596 | 475.061 (550.6), 504,660 |
| synth, 1 lane | 1,775.910 (318.2), 704,509 faults | 1,713.412 (318.7), 574,559 | 1,727.360 (318.8), 575,070 |
| Lua, 8 lanes | 30.395 (208.1) | 29.414 (219.0) | 29.281 (215.6) |
| Lua, 1 lane | 95.290 (60.9) | 94.892 (66.6) | 95.289 (62.6) |
| musl, 8 lanes | 148.086 (239.1) | 144.815 (251.5) | 145.899 (240.7) |
| musl, 1 lane | 690.126 (142.4) | 682.282 (153.3) | 687.436 (142.3) |

Mode 2 removes every fault mode 1 does: the faults were the split huge page's at the scratch's peak, which main's
discard frees part of. It keeps that huge page, up to 2 MB a lane, which Lua's 8 lanes show (+7.5 MiB). The final
form frees it whole instead, through the huge page that holds the peak: no push wrote past the peak, and nothing is
split. Every executable and object is the same across the modes.

### The fix: whole huge pages, the peak's kept (`logs/final-chain.log`)

Head `559ca5f6` (`tfinal`): a lane with a unit left to take gives its scratch's pages back to the last huge page
boundary at or below the peak, and keeps the huge page that holds it. Medians in ms, peaks in MiB:

| | head | main | #763 |
| --- | ---: | ---: | ---: |
| synth, 8 lanes | 481.053 (556.2) | 491.851 (551.4) | 548.073 (529.6) |
| synth, 1 lane | 1,725.141 (320.8) | 1,803.326 (320.6) | 1,634.871 (326.8) |
| Lua, 8 lanes | 34.214 (217.7) | 33.838 (209.3) | 35.855 (211.9) |
| Lua, 1 lane | 99.107 (64.9) | 99.682 (63.3) | 81.315 (74.0) |
| musl, 8 lanes | 146.086 (242.2) | 147.072 (240.4) | 232.329 (248.2) |
| musl, 1 lane | 688.513 (144.7) | 691.701 (144.6) | 641.244 (154.0) |

- **Synth:** by one lane it took 575,099 faults against main's 704,539, and 4.3% less time by one lane, 2.2% less by 8.
- **Lua and musl** run as main's. Lua's 8 lanes ranged from 33.1 to 59.0 ms (main's 32.9 to 50.0), and the modes
  experiment put mode 2 at 29.281 ms against mode 0's 30.395.
- **Peaks:** by 8 lanes 1.7 (musl), 4.8 (synth) and 8.4 MiB (Lua) above main's, from the huge page each lane keeps.
- **The few large units** (two rounds of 31 runs):
  - with `-c`, 136.585 and 136.862 ms against main's 137.935 and 137.739 and the processes' 137.722 and 137.401;
  - linked, 142.234 and 142.014 ms against main's 142.238 and 142.608 and mold's 145.290 and 145.305.
- **Outputs:** every object and executable is main's.
- **Tests:** the head's `test-check-units` passed 2,391 checks with 0 failures (`logs/tests-tfinal/`).

### Freeing the peak's huge page whole, measured and not taken (`logs/final3-chain.log`)

Head `53b33df2` (`tfinal3`): the same, but through the huge page that holds the peak, as far as the arena committed.

| | head | main | #763 |
| --- | ---: | ---: | ---: |
| synth, 8 lanes | 511.880 (549.5) | 490.566 (551.8) | 549.791 (530.5) |
| synth, 1 lane | 1,758.109 (318.8) | 1,782.177 (320.6) | 1,636.225 (326.8) |
| Lua, 8 lanes | 34.421 (201.4) | 33.731 (209.7) | 35.661 (213.1) |
| Lua, 1 lane | 100.065 (60.5) | 99.366 (63.3) | 81.104 (74.1) |
| musl, 8 lanes | 148.266 (238.4) | 147.021 (240.3) | 233.602 (250.2) |
| musl, 1 lane | 689.977 (144.5) | 691.276 (144.7) | 647.275 (154.1) |

Its peaks are main's or below, but every unit takes a fresh huge page, which the kernel clears, and synth's link by
8 lanes took 4.3% longer than main's, with 912 ms of system time against 793. By one lane it took 1.4% less, where
`559ca5f6` took 4.3% less. So `36e5550d` returns to `559ca5f6`'s rule.

### The PR's head (`logs/last-chain.log`)

Head `36e5550d` (`tlast`): `559ca5f6`'s rule again, with `53b33df2`'s comments and report wording. Its code differs
from `559ca5f6`'s in comments, the `--shared-parts` report's text and `test-check-units`' strings.

| | head | main | #763 |
| --- | ---: | ---: | ---: |
| synth, 8 lanes | 481.672 (551.7) | 486.177 (549.0) | 554.339 (528.7) |
| synth, 1 lane | 1,723.516 (321.0) | 1,781.000 (320.6) | 1,629.966 (326.9) |
| Lua, 8 lanes | 33.814 (217.4) | 33.357 (209.2) | 35.634 (213.5) |
| Lua, 1 lane | 98.622 (64.8) | 99.280 (63.2) | 81.324 (74.1) |

By one lane synth took 575,101 faults against main's 704,539, and 3.2% less time; by 8 lanes 0.9% less. Lua's link
took 0.7% less by one lane and 1.4% more by 8 lanes, whose runs ranged from 32.8 to 34.6 ms (main's 32.5 to 36.1).
Every executable is main's. The head's `test-check-units` passed 2,397 checks with 0 failures (`logs/tests-tlast/`).

## Against "Done when"

- **The few large units:** the one command matches its processes with `-c` and is faster linked, at main and with the
  change, which leaves them as main runs them.
- **#763's commands by 8 lanes** are faster than #763's: Lua's by 4 to 5%, synth's by 11 to 13%, musl's by 37%.
- **By one lane** they are slower than #763's, by each unit's compile: `check-input` (#1489) and `check-program`, the
  common warnings (#1340). The change takes synth's one-lane link from 9.3% to 5.7% above #763's in the PR head's run.
- **Peaks:** by 8 lanes the change's kept huge pages add 1.7 (musl), 2.7 to 4.8 (synth) and 8.2 to 8.4 MiB (Lua) to
  main's. With them Lua's peak is 3.9 to 5.8 MiB above #763's. Synth's was already about 20 MiB above #763's at main,
  and the record doesn't find why.
- **Outputs:** every object and executable is main's at 1 and 8 lanes, and `test-check-units` passes at main and at
  each head.

## Limitations

- One host, one session's runs, between other jobs' holds of the lock. Medians of 21 or 31 runs for the short
  commands and of 5 or 7 for the long ones.
- The governors above: CPUs 0 to 7 run under `powersave` but CPU 2.
- The stage sums come from cold processes, which read and lex each header again and start their own tables. A
  stage's growth between the trees is comparable; its absolute time is not the one command's.
- Without the start's cost, the processes' instructions are their counts less the units' count times a tiny unit's
  `-c` count (0.81 million at main, 12.58 million at #763). A unit with headers starts the same way, but this
  doesn't separate the start exactly.
- Main's own medians move between runs by about 1% (synth by one lane: 1,775.9 to 1,803.3 ms across this record's
  runs), so each head is compared with main inside one `time-runs`, and the forms with each other through the modes
  experiment, which runs them inside one.
- The PR's head was measured on synth and Lua alone; its rule's code is `559ca5f6`'s, measured on every corpus.
- The discard was found to cause the faults on the session's cloud VM, where #1165's hypervisor policy turns huge
  pages off, so every freed page comes back as a base page. On the 9700X the modes experiment showed which part does:
  with whole huge pages given back, synth's faults are those of no discard at all, so they were the split huge page's.
- A first attempt of `profile.sh`, which took the lock for each step, was stopped after its first steps
  (`logs/profile-first-attempt.log`, `scripts/profile-first-attempt.sh`). A first `chain6.sh` waited for the keep-all
  head's tests, which then didn't run; the keep-all head's own tests aren't in this record.
