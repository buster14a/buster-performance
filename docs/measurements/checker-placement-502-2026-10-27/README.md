# The checker's time and its code's placement (buster#502)

On the Ryzen 7 9700X (`benchpress`), 2026-10-26 and 27. Every build, link and timed process took the host's lock
alone (`scripts/locked.sh`), pinned to CPU 2. The input is the frozen `sqlite3.c` of
`preprocessor-corpora-astra-01a158dd`, compiled with `-fsyntax-only` (the command line of
`pp-117-templates/args.sh`, in buster-performance's
`docs/measurements/preprocessor-paste-templates-117-2026-10-26/scripts/args.sh`). The lock's messages about other
holders are cut from the logs.

## Trees

| Name | Source |
| --- | --- |
| `main-35f26f6` | buster `35f26f68` |
| `pr473-on-35f26f6` | `35f26f68` merged with buster#473's `cf54e0c2` (tree `3b19329d`) |
| `sec-35f26f6`, `sec-pr473` | those two with `scripts/section.patch` (#502's change to `main.c`, as in buster `dbdff8f6`) |
| `q5/main` | buster `cb5736ff` (#527's merge) |
| `q5/h473` | `cb5736ff` merged with #473's `76390c57` (tree `3d1bd26a`) |
| `q5/s502` | `cb5736ff` merged with #502's `dbdff8f6` (tree `183f079a`) |
| `q5/s502h473` | both (tree `54a2bd27`) |

## The sweep (`logs/sweep`)

`scripts/objects.sh` compiles a tree's units as `build.sh` does, without `-g`, with the checker's unit
(`main_unit_checker.c`) as assembly too. `scripts/link.sh` puts `.skip SHIFT` in `.text` before that unit's code
(and, for #502's trees, `.skip INSIDE` at the start of `.text.buster_checker`), assembles it and links the sources in
order with wild. Instructions are the same at every shift. Queues 1 and 2 used `link.sh`'s first version, which
assembled without `-march=native`: its padding NOPs differ from a direct compile's (`link1.txt`). From queue 3 on it
assembles with `-march=native`, and the assembled code is the direct compile's (`link3.txt`). `perf stat -r 21` of
user cycles, by turns.

- **Main moves 2.2%.** `queue1.sh`: the checker's unit shifted by 0 to 2,048 bytes took 670.1 to 685.1 million user
  cycles (`stat1-main-s*`). With `-falign-functions=64` on the unit, the range was 671.3 to 677.4 million
  (`stat1-align-s*`). #473 rebased on `35f26f6`, at shift 0, took 670.2 and 670.7 million against main's 679.7 and
  680.7 million.
- **What differs.** `queue2.sh` (`counters2-*`): the slow placements had about 3 million more op-cache misses (36.0
  against 32.9 million) and 85 million more front-end stall slots. Mispredictions, TLB misses and
  store-to-load conflicts were the same.
- **Floors.** A byte-identical copy of an executable ran 0.3% faster or slower than the original over three rounds
  (`copy2-*`: 673.0 against 675.0 million, 670.7 against 672.5 million). One executable read 670.4 to 685.6 million in
  different sessions (`counters2-*-align-s1024`, `stat1-align-s1024-*`).
- **The section.** `queue3.sh`: with #502's section, shifting the code before it by 0 to 1,024 bytes left the
  checker's functions at the same addresses (`addresses3.txt`). Each shift's median was 673.2 to 674.8 million
  (0.24%), where 16 bytes moved main from 678.3 to 671.7 million. Shifting the section's contents by 16 and 64 bytes
  moved it by up to 0.3%, and by 4,096 bytes not at all. `-falign-functions=64` added nothing (`stat3-seca-*`).
- `queue4.sh` was stopped after 13 of its 24 runs, in favour of #509's method below. Its partial `stat4-*` files are
  kept.

## By #509's method (`logs/q5`)

`scripts/queue5.sh`: each tree built with `build.sh shifts` at six placements of the checker's unit (0, 688, 1,376,
2,064, 2,752 and 3,440 bytes), then `ab --rounds 3` of `time-runs --runs 3 --copies 3`, with main's executables again
as the floor (`ab.txt`). With the section, the checker's functions don't move with these shifts (`addresses.txt`).

User cycles against main, the median of 54 runs per build in each of the three rounds:

| Build | Round 1 | Round 2 | Round 3 |
| --- | ---: | ---: | ---: |
| main again | −0.01% | −0.01% | +0.08% |
| #473 | −0.15% | −0.15% | +0.31% |
| #502 | −0.14% | −0.01% | −0.03% |
| #502 with #473 | −0.24% | −0.27% | −0.24% |

Every range over placements includes 0. Wall time is in `ab.txt` (main 143.68 to 143.92 ms; #473 −0.09%, −0.19%,
+0.16%; #502 −0.20%, −0.20%, −0.07%; both −0.20%, −0.35%, −0.04%). Main's placements spread 0.71 to 1.14% in user
cycles, and #502's 0.32 to 0.88%, which is what its copies alone spread (0.60 to 1.08%).

## `benchmark-checker-source` (`logs/q6`), for #543's review

`scripts/queue6.sh` runs `benchmark-checker-source` of the frozen `sqlite3.c`, the 9700X job's command line on
`preprocessor-391e729af658`. The builds are main `cb5736ff`, #502's section, and main again as the floor. Each is
run at the six placements of `queue5.sh`, from two fresh copies per round (paths of one length), in three rounds with
the builds' order rotating: 36 processes per build. Each process takes the lock alone, on CPU 2. Address space
randomization stays on, so each process's stack lands at an offset of its own (#445's effect). Each process reports
its body graph's medians over 21 passes, for each path.

Cycles per body node, the median of each build's 36 processes, and against main in each round:

| Path | main | #502 | main again | #502 against main, per round | main again, per round |
| --- | ---: | ---: | ---: | --- | --- |
| scalar | 278.25 | 276.79 (−0.52%) | 279.12 (+0.32%) | −0.51%, −0.78%, −0.38% | +0.03%, +0.37%, +0.59% |
| vector | 303.72 | 301.53 (−0.72%) | 304.28 (+0.18%) | −0.34%, −0.91%, −0.67% | −0.11%, +0.57%, +0.42% |

In ns/node: scalar 50.40 (main), 50.21 (#502) and 50.65 (again); vector 54.90, 54.63 and 55.11. Each build has 4 to 6
processes more than 2% slower than its median, #445's stack offsets. So the section costs the checker stage nothing.
It reads 0.4 to 0.9% faster in each round, a little past the floor's +0.6%.
