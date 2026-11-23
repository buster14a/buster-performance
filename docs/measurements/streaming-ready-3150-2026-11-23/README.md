# The writer lane's ready word, published only when it changes (buster#3150, buster#3350)

buster#3350 makes `stream_flush` publish the writer lane's ready word only when more whole chunks are ready, plus
once for the terminal handoff, instead of after every compiled function. This compares `benchmark-streaming` on main
and on the PR's merged head.

## Method

- Host: benchpress, Ryzen 7 9700X, 2026-11-23, about 08:00–08:40 UTC. Each benchmark ran in its own hold of the host lock
  (`exclusive.sh`), and so did each build.
- Trees: main `1b9821afe448258d08f47f6110922478aa0e4121`; PR head `08ad9dcb633cdfccf175250e7a3fdb853ce17c49` (main
  above merged into the branch). Each was built with `./build.sh --config Release` (the 9700X job's Clang 23.1.4).
- Run: [`run2.sh`](run2.sh), 3 rounds × {main, branch} × {callees, callers}, each
  `taskset -c 2,3 compiler benchmark-streaming --order ORDER --lanes 2 --cpus 2,3` (the defaults: 400 units of 32
  functions, 12800 functions, 29 chunks of 256 KiB, `--runs 11`, medians). [`run2.log`](run2.log) is the whole output,
  with `/proc/loadavg` and the busiest processes before and after each run. `exclusive.sh` listed no other busy
  processes as it took the lock; the busiest processes listed are kernel workers at ≤ 0.3 % CPU.
- [`run1-pre-merge.log`](run1-pre-merge.log) (with [`run1-pre-merge.sh`](run1-pre-merge.sh)) is the previous owner
  session's earlier run, main `4704727a` against the branch before main was merged. It ran 00:30–02:54 UTC beside
  another session's long series and is noisier (one main row is 74 ms). It is kept for completeness, not used below.

## Result

The total ms, the medians of 11 runs, in rounds 1, 2 and 3:

| tree   | order   | at the end            | streamed, 1 lane      | streamed, writer lane |
|--------|---------|-----------------------|-----------------------|-----------------------|
| main   | callees | 47.54 46.31 45.79     | 47.48 46.46 45.85     | 49.35 48.43 47.92     |
| branch | callees | 46.81 46.76 46.63     | 46.87 46.72 46.48     | 46.42 46.19 46.22     |
| main   | callers | 49.41 49.14 49.27     | 49.71 49.41 49.56     | 51.75 51.26 51.64     |
| branch | callers | 49.90 50.05 50.23     | 50.31 50.38 50.42     | 49.93 50.02 49.98     |

The rows that the change doesn't touch (at the end, and streamed on one lane) are the control. They differ between the
two builds by up to about 1 ms, in either direction (main is faster on callers, and mixed on callees). That is the
build-to-build noise.

The comparison that holds is the writer-lane row against the same build's one-lane streamed row:
- On main, the writer lane costs **+1.9 to +2.1 ms** (callees +1.87/+1.97/+2.07; callers +2.04/+1.85/+2.08). Lane 0
  publishes the word after each of 12 800 functions.
- On the branch, it **saves 0.2 to 0.5 ms** (callees −0.45/−0.53/−0.26; callers −0.38/−0.35/−0.44). Lane 0 publishes
  once per newly ready chunk (28 here) plus the terminal handoff.

Against main's writer-lane row directly, the branch is 1.7–2.9 ms (3.5–6 %) faster on callees and 1.2–1.8 ms (2.4–3.5 %)
faster on callers. Some of that difference is the build-to-build noise above.

On the branch, "after streamed" is about 0.06 ms higher (0.42–0.44 → 0.47–0.50 ms), mostly in the headers' column.
That is within the noise of a 0.5 ms phase and wasn't traced further.
