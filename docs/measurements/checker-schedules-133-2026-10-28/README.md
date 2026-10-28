# The checker's schedules: level order or postorder (#133)

The measurements behind
[buster14a/buster#133](https://github.com/buster14a/buster/issues/133)'s open
question, "whether level order or a vectorized postorder walk wins: the
benchmark decides, measured on the same tables". They decided it: the vector
path's regions now check in postorder batches, and level order is
`CheckOptions.level_order` (`docs/c-checker.md`, "Level order or postorder").
Measured on October 28, 2026.

- Baseline: `buster14a/buster` main at `321f5976d5af2b4c54fa45a639895739f2b8a8c9`, the branch's merge base.
- `head`: `0f26899e2f5d5535aa5af5473e567b5a42a67d94`, the constraint catalogue, its fixes, the
  comparison builtins and K&R definitions, with level order still the vector path's default and the
  postorder batches its third path (`postorder`).
- `head2`: `fe35a8b5703202bb3d6e42bf0b70b2d787cf10a9`, the postorder batches the default (`vector`)
  and level order the third path (`levels`).
- Host: benchpress, AMD Ryzen 7 9700X, Linux/x86-64, clang 23.1.1. `host.txt` has the
  executables' and inputs' hashes.
- Builds: `BUSTER_DEBUG_INFO=0 ./build.sh` in trees sent as archives.
  `manifest-main.sha256`, `manifest-head.sha256` and `manifest-head2.sha256` are
  `sha256sum` of every file of `git archive` of each commit. The measured `main` and `head2`
  trees are identical to them. The measured `head` tree differs from its commit in
  `AGENTS.md` alone, a copy from before the commit's last edit of it. The build doesn't read
  that file.
- Every build and run held `~/buster-fast-bench/exclusive.sh` on its own, with owner
  `claude-133` and the issue as its link, pinned to CPU 2 (`taskset -c 2`).

## Commands

`queue-1.sh` is round 1: the builds of `main` and `head`, then
`benchmark-checker-source` of the frozen `sqlite3.c` (the preprocessor oracle's corpus,
its pinned predefines and headers), three processes of each build in turn. Then each of
`head`'s paths alone (`--only`), and its two vector orders after 100 ms of scalar work
before each sample (`--after-scalar 100`). Then `time-runs` of `main` and `head` on `-c`
and `-fsyntax-only` of `sqlite3.c`. `queue-2.sh` is round 2, the same for `head2`, its
`time-runs` with all three builds.

`benchmark-checker-source` checks that each path gives the scalar path's typed stream, then
reports for each a median of 21 passes over the 2,608 bodies' 311,601 nodes. The passes
rotate the paths' order. Each path runs on its own type table, warm (`type_interning=warm`):
the vector orders share the vector path's.

## Results

Nanoseconds and cycles a body node, the three processes' medians of each build (main's
from both rounds):

| Build | Path | ns a node | cycles a node | batches | levels |
| --- | --- | --- | --- | --- | --- |
| main | scalar | 45.351 45.874 45.510; 46.233 45.603 45.470 | 249.5 to 255.3 | | |
| main | level order (`vector`) | 34.509 34.466 34.405; 35.003 34.482 34.269 | 189.8 to 194.0 | | |
| head | scalar | 44.596 44.775 44.893 | 243.8 to 246.5 | | |
| head | level order (`vector`) | 33.721 33.559 33.911 | 184.9 to 187.0 | 27,749 | 27,701 |
| head | postorder batches (`postorder`) | 31.628 31.600 31.839 | 173.4 to 175.3 | 32,446 | |
| head2 | scalar | 45.298 44.810 44.080 | 242.9 to 247.8 | | |
| head2 | postorder batches (`vector`) | 32.152 31.714 31.474 | 174.0 to 176.5 | 32,446 | |
| head2 | level order (`levels`) | 33.977 33.496 33.286 | 184.1 to 186.8 | 27,749 | 27,701 |

The vector path ran the scalar action on 168,791 of the nodes in postorder batches
(54.17%) and 168,106 by level (53.95%).

Each path alone, and after 100 ms of scalar work before each sample, one process each:

| Build | Path | Alone | After scalar work |
| --- | --- | --- | --- |
| head | scalar | 44.131 ns, 243.1 cycles | |
| head | level order | 33.114 ns, 183.1 cycles | 33.648 ns, 185.7 cycles |
| head | postorder batches | 32.000 ns, 177.2 cycles | 32.704 ns, 180.2 cycles |
| head2 | scalar | 44.174 ns, 243.4 cycles | |
| head2 | postorder batches | 32.970 ns, 182.6 cycles | 32.579 ns, 180.2 cycles |
| head2 | level order | 35.126 ns, 194.6 cycles | 33.569 ns, 185.4 cycles |

Whole compiles, `time-runs`, 21 runs of each build in a rotating order (round 2,
`logs/time-runs2.log`):

| Command | main | head | head2 |
| --- | --- | --- | --- |
| `-c` | 127.953 ms, 599.51M user cycles, 1,274.48M instructions | 127.391 ms (−0.44%), 595.83M (−0.61%), 1,275.26M | 126.464 ms (−1.16%), 591.31M (−1.37%), 1,269.18M |
| `-fsyntax-only` | 102.413 ms, 464.12M user cycles, 988.89M instructions | 102.379 ms (−0.03%), 464.28M (+0.03%), 989.56M | 101.254 ms (−1.13%), 458.14M (−1.29%), 983.49M |

Round 1's (`logs/time-runs.log`), main against head: `-c` −0.57% wall and −0.55% user
cycles, `-fsyntax-only` −0.22% and −0.15%, with the same instructions as round 2's.

## Limitations

- One code placement per build. Placement has moved `-c` of `sqlite3.c` by up to 0.7% of
  its cycles, and builds doing the same work have differed by up to about 2M instructions
  (#536's measurements), so the whole compiles' differences below 1% are within it. The
  switch's 6.08M fewer instructions a compile are three times that.
- The benchmark's comparison of the two orders runs in one executable, on one table,
  which keeps placement and the table out of it. The builds' differences against main's
  paths (head's scalar and level order 1.6 to 2.8% faster) mix the branch's other
  changes with placement.
- The isolated samples are one process each.

## Logs

`logs/` holds the runs' output. Each file keeps only the lines the compiler's
commands print (`benchmark-checker-source`'s `checker-source-benchmark:`,
`preparation:` and `body_graph:` lines, `time-runs`' run and summary lines, `build.sh`'s
lines). The lock's messages, which name other sessions' runs, are left out.
