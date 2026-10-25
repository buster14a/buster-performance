# Deferred lanes for PR #432's review, 2026-10-25

The 9700X's measurements for Buster PR [#432](https://github.com/buster14a/buster/pull/432)'s review (issue
[#113](https://github.com/buster14a/buster/issues/113)). The review found that each lane of the deferred reader copied
the top level's reader before it knew whether it would read a body, so `--deferred 8` on a unit of one body made eight
copies. Its fix, `9a5f8500`, runs no more lanes than bodies, and a lane copies the reader when it takes its first part.
These runs compare it with the PR's head before the fix, and with the fix's cap alone (the copy made before the
partition, as before). Cited by Buster's `docs/c-deferred-bodies.md` ("Measurements").

## Sources and inputs

| Tree | Buster commit | Files | Source manifest's SHA-256 |
| --- | --- | ---: | --- |
| `final` | `e6042e6c`, the code of the PR's head under review (`b542a55d`, whose later commits change documentation only): every lane copies the reader before the partition | 457 | `507613af63b4f7625a4916ba50652c1f8c4655e782866b45f9664cf25dadf0e6` ([the earlier record's manifest](../deferred-bodies-113-2026-10-25/source-e6042e6c.sha256)) |
| `lazy` | `9a5f8500`: no more lanes than bodies, and a lane copies the reader at its first part | 457 | `6c6bcbfd2c8a78f3397ff5f6fd4da484ae3ca0dd4f32cfe1295bb217676ecdc7` |
| `cap` | `9a5f8500` with `scripts/cap.patch`: the copy made before the partition again, the cap kept | 457 | `30aa2e3180e4eeec4e1e195e08bf48cfeedf922652262ae816914f52fdd1fd3c` |

Each manifest lists the SHA-256 of `build.sh` and of every file under `src/` of the tree (what the build reads), and
the host's trees, apart from `build/`, match them. `final`'s build is the one the earlier record measured; `lazy` and
`cap` were built for these runs by Buster's `./build.sh` with `BUSTER_DEBUG_INFO=0` and `LC_NUMERIC=C`.

The inputs are six of c-testsuite's single-exec programs at commit `5c7275656d751de0e68b2d340a95b5681858ed07`
(`inputs.sha256`), chosen for their bodies, and the frozen `sqlite3.c` of the earlier record. Every file is read with
the frozen corpus's pinned predefines and headers, as in the earlier record. `SOURCE_DATE_EPOCH=1792454400`; `CPATH`
and `C_INCLUDE_PATH` are unset.

| Unit | Tokens | Bodies |
| --- | ---: | ---: |
| `00001.c` | 9 | 1 |
| `00169.c` | 3,054 | 1 |
| `00213.c` | 460 | 5 |
| `00200.c` | 23,466 | 2 |
| `00182.c` | 7,497 | 11 |
| `00204.c` | 7,653 | 108 |
| `sqlite3.c` | 706,237 | 2,608 |

Host: AMD Ryzen 7 9700X, clang 23.1.1. Every run took the shared lock on its own through
`~/buster-fast-bench/exclusive.sh`. The command is

```sh
./build/compiler benchmark-checker-deferred --passes 21 --lanes 8 --cpus 2,0,1,3,4,5,6,7 [the options] FILE...
```

with the six small units in one process, in the order `00001.c 00169.c 00213.c 00182.c 00204.c 00200.c`;
`--passes 9` for `sqlite3.c`, and `--passes 41` for `00182.c` alone. Each pass parses the unit and checks it by source order's `check_input` and by the deferred reader on one lane
and on eight, in turns that rotate; a figure is the median of the passes, in nanoseconds per token. The command
prints `copies=`, the lanes that copied the reader, for `lazy` and `cap`.

- `logs/log5.txt` (`scripts/queue5.sh`): `final` and `lazy`, five rounds on the six units and three on `sqlite3.c`,
  in alternating order, 20 s apart.
- `logs/log6.txt` (`scripts/queue6.sh`): the three trees, six rounds on the six units, in an order that rotates.
- `logs/log7.txt` (`scripts/queue7.sh`): the three trees, six rounds on `00182.c` alone.

The lock's waiting messages, which name other sessions' and CI's runs, are removed from `logs/`; nothing else in them
is changed.

## Results

Eight lanes, in nanoseconds per token: the median over `log6`'s six rounds of each run's median, and each round's
change against `final`'s run of the same round. Copies are the lanes that copied the reader (`final`'s eight, always).

| Unit | `final` | `lazy` | `cap` | `lazy` against `final` | Copies (`lazy`, `cap`) |
| --- | ---: | ---: | ---: | --- | ---: |
| `00001.c` | 14,448.78 | 4,903.61 | 4,865.23 | −62.7 to −66.8% | 1 |
| `00169.c` | 123.95 | 89.42 | 89.66 | −27.0 to −28.5% | 1 |
| `00213.c` | 424.84 | 364.69 | 362.35 | −13.7 to −22.7% | 5 |
| `00200.c` | 92.22 | 78.25 | 82.77 | −7.8 to −19.1% | 2 |
| `00182.c` | 106.25 | 109.56 | 111.78 | −2.0 to +5.8% | 8 |
| `00204.c` | 106.25 | 105.26 | 106.81 | −2.8 to +3.7% | 8 |

For comparison, one lane (`final`'s, which the fix doesn't change: one lane copies the reader either way) took
5,191.94, 91.78, 225.27, 73.47, 90.01 and 95.38 ns/token, and source order 408.00, 61.23, 65.24, 58.48, 68.73 and
69.82. `log5`'s five rounds of `final` and `lazy` agree with `log6`'s (`lazy` against `final` on eight lanes: −64.7 to
−67.0%, −26.8 to −27.8%, −12.7 to −17.8%, −6.0 to −20.9%, −1.3 to +6.4% and −5.8 to −0.3%).

`00182.c` alone (`log7`, `--passes 41`), eight lanes: `final` 105.35 to 107.35, `lazy` 105.18 to 106.94, `cap` 105.46
to 110.89; `lazy` against `final` −1.8 to +0.6% by round, and `cap` against `final` −1.2 to +5.3%.

`sqlite3.c` (`log5`, three rounds), eight lanes: `final` 107.50 to 107.78, `lazy` 107.80 to 108.11 (+0.0 to +0.5% by
round); one lane: `final` 122.04 to 123.21, `lazy` 122.17 to 122.30.

So:

- **One body:** eight lanes now cost what one lane does, since one lane runs: `00001.c` 66% less, `00169.c` 28% less.
- **A few small bodies:** fewer lanes copy the reader, and the reading costs 8 to 23% less. Eight lanes still cost more
  than one where the bodies are small (`00213.c`'s 365 against 225 ns/token): a lane's copy and wake-up outweigh the
  little each body gives it.
- **Every lane busy:** `00182.c`'s eight lanes were 2 to 6% slower in the fixed trees within the six units' process,
  all of it in the lanes' span (22.4 ns/token in `final`, 26.1 in `lazy` and 27.6 in `cap`, with the bodies' walks and
  checks the same), and not alone in its own process, where `lazy` is −1.8 to +0.6% against `final`. In the six units'
  process it follows units on which the fix leaves lanes idle that `final` runs. `00204.c` and `sqlite3.c` don't change.
- **Where the copy is made:** `lazy` and `cap` don't differ beyond the rounds' spread on any unit, and alone on
  `00182.c` `cap` is the slower. The fix keeps the copy at a lane's first part, which also spares a lane that wakes after
  every part is taken.

## Limitations

The units are small: a run of `00001.c` takes about 45 µs, so a lane's wake-up on the host's `powersave` CPUs (0, 1
and 3 to 7) weighs on every figure, and the order of the units in a process changes the state the lanes start in. The
reader alone is timed (`check_input`'s work), not the checked graph after it. The PR's head after these runs
(`d3477bce`) also scans each body's type changes for a completion of a tag the top level made, which these runs don't
measure.
