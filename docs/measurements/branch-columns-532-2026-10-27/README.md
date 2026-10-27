# Tier 0's branch columns checked alone in `-c`: the 9700X cost for #532

2026-10-27. This record measures
[buster14a/buster#532](https://github.com/buster14a/buster/issues/532). The C
driver's emission ran `branch_sizing_validate` on every Tier 0 function before
sizing its branches. That check ends with `x86_validate` of every record. The
branch `claude/github-issue-532-b73ab5` checks only the branch columns there
(`branch_sizing_validate_branches`, an AVX-512 path with a scalar twin), and
keeps `x86_validate` for `--verify`.

## Revisions

| Build | Source |
| --- | --- |
| `main` | [`ad408cf2ec956860833db81e4333c5faa78390fe`](https://github.com/buster14a/buster/tree/ad408cf2ec956860833db81e4333c5faa78390fe), the branch's merge-base |
| `head` | [`717975542f86c9d593a10be09e0909f9f5ff44c2`](https://github.com/buster14a/buster/tree/717975542f86c9d593a10be09e0909f9f5ff44c2), the branch's change |
| `switch` | `head` merged with [#520](https://github.com/buster14a/buster/pull/520)'s head `ea673e4b7539d36816f3fb00ad89e13463766d18` (its stage clock and `measure-compile`), plus [`campaign/switch-532.diff`](campaign/switch-532.diff) |

The switch build is a measurement build, never committed to the branch. Its
diff reads `BUSTER_532_CHECK` once per emission:

- `full` runs `branch_sizing_validate` on each function, which is main's check;
- `scalar` runs the columns' scalar twin, `branch_sizing_validate_branches_scalar`;
- anything else, or nothing, runs the columns' vector path, which is the branch's default.

One executable then does each mode's work at the same addresses, so a
difference between modes isn't a difference of code placement.

## Host and builds

The host is `benchpress`, an AMD Ryzen 7 9700X running Linux
6.18.50-2-lts, clang 23.1.1 and wild as the build's linker. Each tree was
built with `BUSTER_DEBUG_INFO=0 ./build.sh`, the 9700X job's build, in a lock
hold of its own. Every measured process ran pinned to CPU 2 (`taskset -c 2`),
so `-c` used one lane.

## Input

The frozen corpus's `sqlite3.c` (SQLite 3.53.2) has sha256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. It was
compiled with the options of #136's speedtest1 record, as #520's step compiles
it ([`campaign/common.sh`](campaign/common.sh)):

```sh
-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c
```

## Commands

[`campaign/queue.sh`](campaign/queue.sh) ran the steps in order, each under
`~/buster-fast-bench/exclusive.sh` (the host's lock) for itself. Every process
exited with status 0 ([`logs/queue.log`](logs/queue.log) and each step's log):

1. **Builds** of `main`, `head` and `switch`.
2. **Drive** ([`campaign/drive.sh`](campaign/drive.sh)): each executable's
   object of `sqlite3.c`. That is `main` and `head` by default, with
   `--scalar` and with `--verify`, and `switch` in each mode.
3. **main against head** ([`campaign/measure-a.sh`](campaign/measure-a.sh)):
   8 rounds in alternating order. Each executable ran one discarded warm-up
   compile, then `perf stat -r 3` of task-clock, `cycles:u`,
   `instructions:u`, `cycles:k` and `instructions:k`
   ([`perf/a-ROUND-BUILD.txt`](perf)).
4. **Stages** ([`campaign/measure-b.sh`](campaign/measure-b.sh)): `switch`'s
   `measure-compile --runs 11` in each mode, in sequence (full, vector, then
   scalar). This gives medians of the default compile and of #520's
   `--time-stages` report ([`logs/measure-b.log`](logs/measure-b.log)).
5. **Modes on one executable**
   ([`campaign/measure-c.sh`](campaign/measure-c.sh)): 8 rounds of
   `switch`'s three modes, the order rotated by round. Each mode ran a
   discarded warm-up, then `perf stat -r 3` with the same events
   ([`perf/c-ROUND-MODE.txt`](perf)).

[`campaign/perfsum.py`](campaign/perfsum.py) summarizes steps 3 and 5:

```sh
python3 campaign/perfsum.py perf/a main,head
python3 campaign/perfsum.py perf/c full,vector,scalar
python3 campaign/perfsum.py perf/c scalar,vector
```

It prints each counter's median over the rounds of each build's run means. It
also prints the median of the paired per-round differences against the first
build, with the range of the per-round relative differences.

## Results

### Objects

All nine objects are the same bytes, sha256
`0c48ff92978c3125b1822a1552eb48d2742ea09d80176488d8dc5320c4afe91f`. That is
`main` and `head` by default, with `--scalar` and with `--verify`, and
`switch` in each mode ([`logs/drive.log`](logs/drive.log)).

### main against head

Medians of 8 rounds; the difference is the median of the paired per-round
differences, and the range is the per-round relative differences':

| counter | main | head | head − main | range |
| --- | ---: | ---: | ---: | ---: |
| wall (ms) | 190.722 | 184.811 | −5.892 (−3.09%) | −3.56% to −2.61% |
| task-clock (ms) | 190.385 | 184.480 | −6.000 (−3.15%) | −3.54% to −2.60% |
| `cycles:u` | 901,544,006 | 868,422,323 | −33,148,381 (−3.68%) | −4.09% to −3.22% |
| `instructions:u` | 2,227,227,217 | 2,094,196,859 | −133,030,359 (−5.97%) | −5.97% to −5.97% |
| `cycles:k` | 154,654,272 | 155,197,871 | +407,383 (+0.26%) | −1.75% to +1.09% |
| `instructions:k` | 37,868,385 | 37,829,894 | −113,500 (−0.30%) | −0.42% to +0.46% |

### Stages

#520's `--time-stages` on `switch`: each stage's median of 11 runs in ms, and
its range. The stages before the backend didn't move; these are the
backend's, the span and the default compile's wall time:

| stage | full (main's check) | vector (head's) | scalar |
| --- | ---: | ---: | ---: |
| lower | 25.529 (25.295 to 25.715) | 25.513 (25.359 to 25.807) | 25.700 (25.568 to 26.319) |
| tier0 | 5.311 (5.292 to 5.351) | 5.216 (5.191 to 5.355) | 5.212 (5.196 to 5.233) |
| emit-setup | 2.412 (2.353 to 2.482) | 2.431 (2.356 to 2.512) | 2.409 (2.369 to 2.479) |
| **branch-sizing** | **5.620 (5.606 to 5.632)** | **0.517 (0.511 to 0.535)** | **0.533 (0.525 to 0.540)** |
| encode | 0.389 (0.385 to 0.398) | 0.389 (0.387 to 0.399) | 0.388 (0.385 to 0.395) |
| unwind | 0.164 (0.163 to 0.165) | 0.164 (0.161 to 0.165) | 0.164 (0.162 to 0.165) |
| code-atoms | 0.513 (0.490 to 0.534) | 0.514 (0.482 to 0.586) | 0.496 (0.480 to 0.535) |
| span | 189.979 (189.116 to 190.258) | 184.672 (183.900 to 185.574) | 185.268 (184.264 to 185.562) |
| default compile's wall | 190.730 (189.983 to 191.245) | 185.216 (184.171 to 186.199) | 185.729 (184.750 to 186.453) |

The branch-sizing stage holds the check and `size_branches`. With main's check
it took 14.4 times the encoder's time. With the columns' vector check it takes
1.33 times the encoder's time.

### Modes on one executable

`switch`, 8 rounds; differences against `full` (main's check) are the medians
of the paired per-round differences, with the per-round relative range:

| counter | full | vector | scalar | vector − full | scalar − full |
| --- | ---: | ---: | ---: | ---: | ---: |
| wall (ms) | 190.434 | 185.332 | 185.573 | −5.011 (−2.63%; −3.51% to −2.55%) | −4.782 (−2.51%; −2.84% to −2.16%) |
| task-clock (ms) | 190.065 | 184.980 | 185.250 | −5.075 (−2.67%; −3.21% to −2.58%) | −4.855 (−2.56%; −3.01% to −2.16%) |
| `cycles:u` | 899,572,826 | 871,556,432 | 873,082,260 | −29,654,405 (−3.30%; −3.87% to −3.02%) | −26,690,855 (−2.97%; −3.48% to −2.53%) |
| `instructions:u` | 2,227,268,549 | 2,094,229,655 | 2,094,627,914 | −133,038,894 (−5.97%) | −132,640,634 (−5.96%) |

The vector path against its scalar twin, paired:
- 398,261 fewer `instructions:u` in every round;
- 2.29 M fewer `cycles:u` (−0.26%, every round −0.82% to −0.01%);
- 0.36 ms less wall time (−1.19% to +0.09%).

The modes on one executable differ by 5.0 ms. main against head differs by
5.9 ms, which also moves code between two builds.

## Limitations

- Only `sqlite3.c`, on one lane, on CPU 2. Whole processes include the page
  faults and kernel time of the compile; their kernel counters didn't change
  outside their noise.
- The stage report's modes ran one after another in one hold, not
  interleaved. Separate runs of one executable drift by about 0.4% of the
  whole compile. The branch-sizing stage's change is 5.1 ms, and its ranges
  don't overlap.
- The stage clock is #520's, which wasn't merged when this was measured. Its
  laps charge the check and `size_branches` to one stage, so the check's own
  share of the 0.517 ms isn't separated here.
- `exclusive.sh` printed lines while waiting for the host's lock. They name
  other sessions' commands, so those lines were removed from the logs; nothing
  else was changed.
