# Tier 1 code certificate: musl's full barrier (#2963), 2026-11-18

[buster#2963](https://github.com/buster14a/buster/issues/2963): `--tier1 --verify` and `--tier1 -g` of musl's
`pthread_barrier_wait.c` failed with `internal compiler error: emission, cause=certificate error=272`. The code
certificate killed the frame's bytes that musl's `a_store` barrier, `lock ; orl $0,(%rsp)`, writes, though an or of zero
leaves them as they were. The row at rsp held a value saved across a call, which the next block's entry (or a reload
after a later call) still claimed.

## Builds

Release, by the 9700X's own toolchain (`./build.sh --config Release`), under the lock:

- **base** `43ad75ec2`: main `8d4025fbf` with #2913's fix (`38a848237`) cherry-picked. Its tree is main `6c7f6b6`'s,
  the merge of #2913.
- **head** `2d2538404`: base with #2963's fix. Its tree is the PR's commit's.

`logs/compilers.sha256` has both executables' hashes.

## What ran

[`run.sh`](run.sh), then [`g.sh`](g.sh), each run under the lock:

1. `--tier1 -c`, `--tier1 -g -c` and `--tier1 --verify -c` of the pinned corpus's (`preprocessor-391e729af658`)
   `sqlite3.c`, Lua 5.4.8 and musl's units, #2924's C7 gate's lists (one lane), by each build. Each compile's standard
   error is in `logs/stderr-*.txt`.
2. musl's `pthread_barrier_wait.c` alone by each, `-g` and `--verify` (`logs/barrier-*.log`).
3. The objects compared, base against head, mode by mode.
4. User-mode instructions retired by `-g` and `--verify` of `sqlite3.c` and Lua on CPU 2, three rounds in turn.

`run.sh` compiled each build's `-g` objects in a directory of its own, and `-g` records the directory, so all 1,370
differed (`logs/objects-compare.txt`). [`g.sh`](g.sh) compiled both in one directory, moved aside after each; that
comparison is the one that counts.

## Results

| | base | head |
| --- | --- | --- |
| `--tier1 -c`: errors, objects | 0, 1,371 | 0, 1,371 |
| `--tier1 -g -c`: errors, objects | 1 (`pthread_barrier_wait.c`), 1,370 | 0, 1,371 |
| `--tier1 --verify -c`: errors, objects | 1 (`pthread_barrier_wait.c`), 1,370 | 0, 1,371 |
| `pthread_barrier_wait.c`, `-g` and `--verify` | error 272 at `pshared_barrier_wait` | exit 0 |

Objects, base against head:

- `--tier1 -c`: 1,371 compared, 0 differ.
- `--tier1 --verify -c`: 1,370 compared, 0 differ.
- `--tier1 -g -c` (`g.sh`, one directory): 1,370 compared, 0 differ.

Head adds the one object base couldn't build. The emitted code is unchanged; the certificate accepts more.

User-mode instructions retired by `sqlite3.c` and Lua together, three rounds each (`logs/instructions-*.txt`):

| | base | head | head − base |
| --- | ---: | ---: | ---: |
| `-g` | 24,144,626,777 | 24,143,754,156 | −872,621 (−0.004%) |
| `--verify` | 18,603,800,894 | 18,603,192,487 | −608,407 (−0.003%) |

Rounds agree within 5,000 instructions. Neither corpus has a barrier. The difference is the compiler's own code
layout around the new test, not certificate work.

`logs/status.txt` and `logs/status-g.txt` are the runs' summaries. Lines that start `exclusive.sh: waiting for the
9700X` name the other sessions the lock waited for.
