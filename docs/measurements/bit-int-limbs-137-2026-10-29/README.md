# #137's `_BitInt` past 128 bits and complex values of aggregate parts: what they cost, 2026-10-29

Two stacked pull requests of buster14a/buster#137 change the lowering (`c_check_program_lower.c`):

- [#857](https://github.com/buster14a/buster/pull/857), `claude/137-bit-int-limbs`: `_BitInt`s past 128 bits, as
  frame objects of 64-bit limbs (closes buster14a/buster#807). Measured at its head, `b01e8186`;
- [#858](https://github.com/buster14a/buster/pull/858), `claude/137-complex-float128`, on #857: `_Complex __float128`
  and the complex `_BitInt`s past 128 bits. Measured at its head, `44fc285a`, which merges `b01e8186`.

Their base is [#837](https://github.com/buster14a/buster/pull/837)'s head, `c76f556f` (`__float128`), which has
merged into main since. Main `0dd6fbc3` is under all three. This record measures what the two cost a unit that uses
none of what they add, the frozen `sqlite3.c`:

| `sqlite3.c` | #837 `c76f556f` | #857 `b01e8186` | #858 `44fc285a` |
| --- | ---: | ---: | ---: |
| `-c`, user instructions (`time-runs`) | 1,315,564,275 | +1,456,383 (+0.111%) | −86,651 (−0.007%) |
| `-c`, wall (`time-runs`) | 127.876 ms | −0.04% | −0.05% |
| `-c`, user cycles (`time-runs`) | 602.49 M | +0.04% | −0.18% |
| `-fsyntax-only`, user instructions (`time-runs`) | 1,011,156,891 | +1,804 | +202 |
| `-fsyntax-only`, wall | 101.817 ms | −0.15% | −0.14% |
| `-fsyntax-only`, user cycles | 463.93 M | −0.20% | −0.30% |
| `benchmark-lowering-source`, referenced definitions | 23.593 ms | +0.36% | −0.54% |
| `benchmark-lowering-source`'s process, user instructions (`perf stat`) | 13,769,726,263 | +64,004,105 (+0.465%) | −3,808,410 (−0.028%) |
| `benchmark-lowering-source`'s process, user cycles (`perf stat`) | 6,263,040,757 | +0.441% | −0.367% |

Every executable writes the same `-c` object, byte for byte (`final/m137h.out`). `perf stat`'s counts of `-c`
(3 runs each, `final/m137h-stat-c-*.csv`) are 1,315,564,217, 1,317,019,393 (+1,455,176) and 1,315,477,484 (−86,733);
of `-fsyntax-only` (`final/m137h-stat-s-*.csv`), 1,011,156,690, 1,011,157,880 and 1,011,156,885.

Where the rows come from (on the 9700X's CPU 2, every process under the host's lock alone):

- `scripts/measure2.sh`, run by `scripts/queue-m137h.sh`: `ab --rounds 5 --cpu 2 --lock exclusive.sh` over the three
  trees, in an order that rotates by round, each round a `time-runs --runs 21` of `-c` and of `-fsyntax-only`
  (`final/m137h-driver.log`). The wall, cycles and `time-runs` instructions rows are the medians of the five rounds'
  medians (`scripts/summarize-ab.py`). Then three `perf stat -e instructions:u` runs of `-c` and of `-fsyntax-only`
  per tree. Then five rounds of `benchmark-lowering-source` the same way (`final/m137h-lowering.log`): the median of
  the rounds' `referenced_ns` (`scripts/summarize-lowering.py`), the time of everything `-c` does after checking
  (lowering, Tier 0, branch sizing, encoding, the static data and the object's bytes) for the definitions that `-c`
  lowers, the median of 21 passes.
- `scripts/lowstat.sh`: `perf stat -e instructions:u,cycles:u,branch-misses:u` of `benchmark-lowering-source`'s whole
  process, three runs per tree (`final/ls4.out`, `final/ls4-*.csv` and `.txt`; `scripts/summarize-stat.py`). The
  process lowers the unit 44 times: each way's warm-up and 21 passes, of the referenced definitions and of all of them.

Every `time-runs` reports 0 failed processes, every `ab` 0 failed runs, every benchmark run `failures=0`, and the
scripts, which run under `set -e`, reached their `done`. `final/summary.out` holds what the summaries print.

Round by round, against #837's median in the same round:

| | #857 | #858 |
| --- | --- | --- |
| `-c`, wall | +0.12%, +0.05%, −0.13%, −0.23%, −0.16% (above in 2 of 5) | −0.06%, −0.03%, +0.08%, +0.04%, −0.11% (2 of 5) |
| `-fsyntax-only`, wall | +0.12%, −0.15%, −0.33%, −0.09%, −0.34% (1 of 5) | −0.10%, −0.20%, −0.20%, +0.35%, −0.03% (1 of 5) |
| lowering benchmark | +1.00%, +0.07%, +0.32%, +0.31%, +0.80% (5 of 5) | −0.30%, −0.44%, −0.68%, −0.61%, −0.21% (0 of 5) |

The rounds' medians spread over 127.671 to 127.969 ms for #857's `-c`, against 127.811 to 128.116 ms for #837's and
127.729 to 128.172 ms for #858's; the lowering benchmark's over 23.660 to 23.791 ms for #857, 23.536 to 23.662 ms for
#837 and 23.422 to 23.557 ms for #858.

`-c`'s wall time moves by less than its rounds do. `-fsyntax-only`, whose instructions are #837's to within 2,000,
is 0.15% faster at #857 and at #858, in 4 of 5 rounds: the same code, placed elsewhere. The lowering benchmark is
slower at #857 in every round, by 0.36%, about 0.085 ms, as its instructions and cycles are: its process runs 1.45
million more instructions a lowering (64.0 million over 44), which is `-c`'s 1.46 million. They aren't the work #857
adds: #858's head holds all of #857's code and more, and its lowering is 0.54% faster than #837's, faster in every
round, with 0.09 million fewer instructions a lowering.

## Where the instructions are

`scripts/attr3.sh` profiled `benchmark-lowering-source`'s process by function: `perf record -e instructions:u`, 10
runs a tree, each at another period from 900,001 to 1,350,011 instructions, so that the runs' samples fall at other
places in the same instructions, each under the lock alone on CPU 2, the trees' order rotating by run
(`final/at3.out`). The host takes at most 40,000 samples a second and the process runs about 11G instructions a
second, so no run is throttled: each run's periods sum to `perf stat`'s count to within 0.09%. A function's
instructions are its periods (`perf report -F period`, `final/at3-*.report`). The table gives each function's mean over
a tree's 10 runs, in millions of instructions a process (44 lowerings), and each difference with its standard error
from the runs' spread (`scripts/attribution.py`, `final/attribution.out`). It is `scripts/fill_attribution.py`'s: the
8 functions with the largest differences.

| Function | #837 | #857 − #837 | #858 − #857 | #858 − #837 |
| --- | ---: | ---: | ---: | ---: |
| `check_lower_prepare` | 1,265.7 | +72.7 ± 1.6 | −72.0 ± 0.9 | +0.7 ± 1.6 |
| `check_lower_drain` | 2,425.2 | +24.0 ± 31.4 | −34.4 ± 29.9 | −10.4 ± 17.3 |
| `check_lower_part` | 850.8 | −27.8 ± 12.6 | +24.1 ± 14.4 | −3.7 ± 11.4 |
| `check_data_plan_object` | 90.3 | +2.0 ± 9.9 | −24.6 ± 7.1 | −22.6 ± 8.1 |
| `check_data_plan_scalar` | 60.7 | +0.6 ± 11.2 | +20.8 ± 8.5 | +21.4 ± 8.6 |
| `check_lower_emit` | 273.1 | −19.8 ± 7.2 | −10.1 ± 6.9 | −29.9 ± 6.3 |
| `check_lower_control` | 337.3 | −17.4 ± 14.0 | +19.3 ± 15.4 | +1.9 ± 10.4 |
| `check_lower_expression` | 864.5 | +8.6 ± 11.7 | +14.8 ± 12.5 | +23.3 ± 10.3 |
| All functions | 13,763.8 | +64.3 | −67.7 | −3.3 |

`check_lower_prepare` sizes the lowering's storage from the unit's nodes before it lowers them: 28.8 million
instructions a lowering at #837. At #857 it runs 1.65 million more a lowering (±0.04 million), more than the process's
whole difference; the other functions' differences sum to −0.19 million a lowering. At #858, whose
`check_lower_prepare` holds #857's code and more, it runs #837's count, to within 0.04 million a lowering. So the
1.46 million instructions #857 adds to `-c` are in how clang compiled that function in #857's build, not in work it
does for this unit. In the source, the two differ there in the call of the room pass, `check_lower_limb_room`, which
finds nothing to count in this unit: #857 passes it an out-pointer for its count of locals, and #858 has it return its
four counts in a structure.

`scripts/attr2.sh` ran first, 5 runs a tree at one period (1,000,003; `final/at2.out`, `final/at2-*.report`). A
deterministic process sampled at one period gives the same samples every run, so its runs agree to within a few
samples and their spread says nothing of the error: by function its differences were off by up to about 40 million
instructions a process (Tier 0's `tier0_generate`, which neither pull request changes, came out 35.8 million lower
at #857). It is kept (`final/attribution-at2.out`), but the table is `attr3.sh`'s.

## Trees and identities

| Name | Commit | What it is |
| --- | --- | --- |
| `qf2` | [`c76f556f`](https://github.com/buster14a/buster/tree/c76f556f758ba2d1bbcfb4827067592f733c8e2b) | #837's head, main `0dd6fbc3` merged; merged into main since |
| `lb3` | [`b01e8186`](https://github.com/buster14a/buster/tree/b01e81863b65159dc4650503d1b3cc298aeabd20) | #857's head, `c76f556f` merged |
| `cq3` | [`44fc285a`](https://github.com/buster14a/buster/tree/44fc285a6063d1edffef08ae4ca678ddfd727bb8) | #858's head, `b01e8186` merged |

Each tree on the 9700X was `git archive` of its commit, with a `COMMIT` file naming it. `identity/source-*.sha256` holds
the SHA-256 of every file of each tree on the 9700X but `build/`: 741 files each, of which 739 match `git archive` of
the commit above (`identity/archive-*.sha256`, made on the 7940HS) and the other two are the `COMMIT` file and the
build's log (`identity/manifests.out`). Each tree was built with `BUSTER_DEBUG_INFO=0 ./build.sh` under the lock:
`cq3`'s and `lb3`'s by `scripts/measure2.sh` in this run (`final/m137h.out`'s first lines), `qf2`'s by the same script
in an earlier run of the same day (`m137g`), before this run started. `identity/hostinfo.out` holds the SHA-256 of the
three executables and of the input, the executables' times (12:54, 13:59 and 14:01 UTC, before the A/B's first run),
each tree's build line, and the host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9, CPU 2's governor
and EPP `performance`, and its SMT sibling, CPU 10, offline (`scripts/hostinfo.sh`, under the lock).

The input is the preprocessor oracle's frozen `sqlite3.c`
(`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`, SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`), with `-DSQLITE_OMIT_LOAD_EXTENSION
-DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I` its directory.

## Logs

While `exclusive.sh` waited for the lock, it wrote messages into the logs on the host that name other sessions' and
CI's runs. `scripts/keep_own_lines.py` kept only the lines this record's tools print in `final/m137h.out`,
`final/m137h-driver.log` (691 of its 712 lines), `final/m137h-lowering.log` (46 of 68), and the benchmark's outputs
under `perf stat` and `perf record` (`final/ls4-*.txt`, `final/at2-*.txt` and `final/at3-*.txt`). `final/ls4.out`,
`final/at2.out` and `final/at3.out` are the scripts' own lines, whole, and `identity/hostinfo.out` keeps the 17 lines of
its 21 that `scripts/hostinfo.sh` prints. Nothing else was changed. The `perf record`
data files were deleted after their reports were written; the reports (`final/at2-*.report`, `final/at3-*.report`)
are kept.

## Limitations

- One input, which uses none of what the branches add: this measures what the additions cost the code that doesn't
  use them, not how fast they lower what they add.
- One placement of each build: neither the A/B nor the lowering benchmark was compared over placements (#509's
  method), and there is no A/A control. #858's head, which holds #857's code, is the comparison that stands in for
  one.
- The profile counts each function's instructions, not its time, and doesn't say which of `check_lower_prepare`'s
  instructions #857's build adds.
- The publication heads are the measured ones; main has moved since (`586c2ae2` when this was written), and neither
  pull request has merged it again.
