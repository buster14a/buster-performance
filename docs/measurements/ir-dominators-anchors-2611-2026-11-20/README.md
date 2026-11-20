# Tier 1's CFG anchors read the IR's dominator tree (buster#2611), 2026-11-20

buster#2603 gave each block of Tier 1's machine CFG an anchor and a chosen predecessor from that CFG's dominator
tree, analyzed per function (`tier1_cfg_anchors`'s `dominators_analyze`). The machine CFG is the IR's with at most an
added entry, and the driver's Tier 1 step already holds the IR's tree, current for the planned revision. buster#2611's
change passes that tree to the allocation and reads it shifted by the added entry.

## 9700X: one executable, the analysis on and off

`scripts/run.sh` cloned the pull request's commit `77f7df5` (on main `cc5c1503`), applied `scripts/knob.patch`
(experiment only: `BUSTER_ANCHOR_ANALYZE=1` makes `tier1_cfg_anchors` ignore the given tree and analyze, as main does),
built Release with `BUSTER_DEBUG_INFO=0` under the lock, and ran `scripts/measure.sh` under the lock: the frozen
`sqlite3.c` by `--tier1 --lanes 1 -c` on CPU 2, both settings' objects first (`objects identical`), a warm-up of
each, then 21 rounds in ABBA order with `perf stat -e cycles:u,instructions:u,task-clock`. `9700x/run.log` is the
job's log; the lock's waiting lines, the other session's holder lines, are left out. No other process was busy as the
lock was taken.

| `sqlite3.c`, `--tier1 --lanes 1 -c`, median of 21 | analysis (main's) | IR's tree (this change) | change |
| --- | ---: | ---: | ---: |
| user cycles | 3,295.3 M (3,288.0 to 3,308.6) | 3,283.0 M (3,275.9 to 3,306.8) | -0.37% |
| user instructions | 8,126.5 M | 8,107.1 M | -0.24% |
| task clock | 612.20 ms (611.25 to 615.21) | 609.99 ms (608.89 to 617.00) | -0.36% |

The IR's tree read fewer cycles in 20 of 21 rounds (paired, -0.74% to +0.42%).

## Cloud container

The `--tier1 -c` objects of the frozen `sqlite3.c` and Lua 5.4.8's 34 sources by main `cc5c1503` and by the change
are the same bytes (35 of 35, `cmp`).
