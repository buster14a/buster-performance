# Folded constant storage (#3022, PR #3171) on the Ryzen 7 9700X

The timed check that [buster#3022](https://github.com/buster14a/buster/issues/3022) asks of its fix ("It runs in every
compile: `-c sqlite3.c` against main on the 9700X, with the base again as control"), for
[buster#3171](https://github.com/buster14a/buster/pull/3171) ("Clear superseded payloads when folding scalar
constants"), taken on 2026-11-22. The PR clears the storage a constant's old kind named when the checker folds its
conversion (`c_check_actions.c`), and rewords a comment in `c_check_node_machine.c`; the rest of its diff is tests.

## Commits and executables

| Build | Commit | What it is |
| --- | --- | --- |
| main (`base`) | `2e4eb0036803d6ed60da3445586485c5d4a5286b` | the main the PR head last merged (its second parent; `git merge-base` of the head with it, and with today's `origin/main` `ef3d3769a`, is this commit) |
| head (`head`) | `05c2d6ba58ddb64bb018d222471cd26ac4d7600d` | the PR head, `codex/3022-folded-constant-storage` |

Each built once by `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release` under the lock
(`build-one.sh`), with the 9700X's staged Clang 23.1.4 (`benchpress-clang/efdd1dbd…`), 66 s each:

```text
f00774c0a6e8e1132144192f4f32e7704113dd997c5bfb9c27225722448198d9  bin/base
ee20a5a12c2874ff461332086d2bb6a50c40e5f52bc520b83a1bc5d273914d8d  bin/head
```

## The workload

`-c` of the frozen `sqlite3.c` (SQLite 3.53.2, 9,507,037 bytes, SHA-256 `0a409f16…5e23d`, checked by `setup.sh`) with
the 9700X job's options (`9700x.yml`, "Compare check-expressions with the pull request's base"):

```sh
-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE \
  -I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
```

Pinned to CPU 2, so one lane.

## Object identity (`identity.sh`, `logs/identity.txt`)

Under one hold, each build compiled it on CPU 2: both exited 0, wrote **byte-identical objects** (2,061,192 bytes,
SHA-256 `47fec883d0f16654be6f10bee6d1104b1627f04c23d9b804742537037f0d9d09`) and printed nothing on stdout or stderr. (The
PR body's 2,051,456-byte object and its SHA-256 are of a SQLite 3.54.1 amalgamation, not this frozen 3.53.2 one.)

## Base, head, base again (`ab.sh`, `logs/ab-161910.log`, `logs/ab-summary.txt`)

`ab --rounds 6 --cpu 2 --lock lockwrap.sh` running `time-runs --runs 7 --copies 2` over three builds: main, head and
main again (the same executable, from its own fresh copies: the floor). Each round's `time-runs` process is one hold of
the lock; a hold runs one warm-up a slot and 7 timed processes a copy, so 14 a build a hold and 84 a build over the 6
holds. `analyze.py` takes each build's median per hold, then the per-hold change against main (its median, range and
how many holds fell on each side of zero) and the change of the pooled medians.

| | main | head | head vs main, pooled | head vs main per hold: median [range] | holds head lower / higher | floor (main again) per hold: median [range] | floor holds lower / higher |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Instructions | 1,246,670,940 | 1,246,391,200 | −0.022% (−279,740) | −0.022% [−0.022%, −0.022%] | 6 / 0 | +0.000% [−0.000%, +0.000%] | 3 / 3 |
| User cycles | 544.617 M | 544.237 M | −0.070% | −0.098% [−0.644%, −0.015%] | 6 / 0 | +0.015% [−0.380%, +0.150%] | 3 / 3 |
| Wall time | 113.183 ms | 113.021 ms | −0.144% | −0.154% [−0.542%, +0.008%] | 4 / 2 | −0.087% [−0.246%, +0.349%] | 5 / 1 |

The main and head columns are pooled medians over the 84 processes. Every process of the head ran fewer instructions
than every process of main (head 1,246,388,236 to 1,246,393,193; main 1,246,667,977 to 1,246,721,372). The head is
not slower: its user cycles are lower in all six holds, by a per-hold median of 0.10%, but that is inside the floor's
per-hold spread (−0.38% to +0.15%), so the cycle and wall-time gains are not resolved from noise at this size; the
instruction drop is.

`time-runs`'s own per-hold summaries (`list 1, user cycles` in the log) give slightly different medians from
`analyze.py`'s: of 14 values it takes the upper middle one (`profile_median`, `values[count / 2]`), where `analyze.py`
averages the two middle ones. Its per-hold head-against-main user cycles read +0.01%, −0.00%, −0.63%, −0.29%, +0.13%
and −0.11%, its floor's +0.02%, +0.17%, −0.26%, −0.02%, −0.08% and +0.05%: the same conclusion.

## The machine

Each of the six A/B holds, and the identity hold, first waited for the lock behind another session's per-run holds
(`claude-2925`, `exclusive.sh: waiting` in the log); the builds waited behind `claude-3261` and `claude-2925`.
`exclusive.sh` reported no other busy process at any hold. `logs/held.txt` has the load and the busiest processes
before and after each hold: kernel workers at 0.4% CPU or less.

## Files

`queue.sh` ran `setup.sh` (the clone, the two worktrees, the merge-base check and the corpus's SHA-256), `build-one.sh`
twice, `identity.sh` (which runs `identity-run.sh` under one hold) and `ab.sh` in turn, each build and run its own hold
of the lock. `env.sh` holds the lock's owner, title and link, the commits and the options; `held.sh` and `lockwrap.sh`
take the lock and record the machine inside each hold. `logs/queue.log` is the whole queue's output, including both
builds' logs.
