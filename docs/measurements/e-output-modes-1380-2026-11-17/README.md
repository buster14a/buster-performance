# `-E`'s output modes `-C`, `-CC`, `-dD`, `-dI` and `-dN` (buster#1380), 2026-11-17

[buster#1380](https://github.com/buster14a/buster/issues/1380), under
[its claim](https://github.com/buster14a/buster/issues/1380#issuecomment-6943250747).
The branch is `claude/gallant-mccarthy-83mog5`. It has two commits on main
`d1cf1fe82`: `2bd4bb92b` adds the modes, and `e10f26eea` lets the vector
printer print `-dD`'s and `-dI`'s directives.

- `-C` keeps the files' comments as tokens, as clang's lexer does.
- `-CC` also keeps the comments in macros' replacement lists and arguments.
- `-dD` prints each `#define` and `#undef` where it runs.
- `-dI` prints each include before what it includes.
- `-dN` is accepted and reported as unused, as clang's driver reports it.

## How it was measured

- The 9700X (`benchpress`), CPU 2. Every build and run held the host's lock
  (`exclusive.sh`), one hold per `time-runs`, `benchmark-preprocessor` or build.
- **Trees:** `base` is buster main `d1cf1fe82`. `head` is `2bd4bb92b` in
  round 1 and `e10f26eea` in round 2. Both are Release builds with CI's Clang
  23.1.4 (`results/builds.txt`).
- **Input:** the frozen `sqlite3.c` of
  `/var/lib/buster-9700x/corpora/preprocessor-391e729af658`, with its pinned
  predefines and headers, as the 9700X job's printer benchmark gives them
  (`scripts/measure.sh`'s `S`). Also this compiler's own `main.c` unit,
  `-DBUSTER_COMPLETE_DRIVER=1`, as the job's preprocessor benchmark gives it
  (`M`).
- **Scripts:**
  - round 1: `scripts/builds.sh`, then `scripts/measure.sh`;
  - round 2: `scripts/run2.sh` rebuilt `head`, then ran `scripts/measure2.sh`.
- **`time-runs`:** whole processes with stdout to `/dev/null` and objects to
  `/dev/shm`. Main against head is 3 fresh copies of each build in a Williams
  order (base, head, base again). Each mode's cost is head alone.
- **`benchmark-preprocessor`:** preprocessing's phases without printing (21
  passes, medians), plain and with `-E -C` and `-E -CC`.
- **Context:** `results/round*/context.txt` has the load and the busiest
  processes before and after each hold.
  - As round 2's `phases` took the lock, `exclusive.sh` listed a `perf` process
    0 s old on CPU 1. It was another session's, after its own hold.
  - Round 2's `modes-sqlite` waited for that session's hold.

## Main against head (round 2, the branch's final head)

Wall time medians over 45 runs (`-E`) or 27 (`-c`). The instruction counts
are exact.

| `sqlite3.c` | base | head | base again | instructions, base to head |
| --- | ---: | ---: | ---: | ---: |
| `-E -P` | 11.450 ms | 11.435 ms (-0.13%) | 11.424 ms (-0.23%) | 152,251,535 to 152,182,749 (-0.05%) |
| `-E` | 13.878 ms | 13.878 ms (+0.00%) | 13.858 ms (-0.15%) | 196,578,029 to 196,743,904 (+0.08%) |
| `-c` | 120.586 ms | 120.220 ms (-0.30%) | 120.255 ms (-0.27%) | 1,349,327,544 to 1,349,628,799 (+0.02%) |

The times are within main's own repeat.

- **`-E`'s +165,875 instructions** come from the vector printer's
  token-by-token loop. That loop handles a chunk that holds an unknown token or
  a line its batches don't place. It now also tests whether a `-dD` or `-dI`
  directive comes before the token.
- **`-c`'s +301,255** come from the preprocessor's new tests: whether `-C`
  drops comments from arguments, and whether `-dD` and `-dI` record anything.

Round 1 (`2bd4bb92b`, which still printed `-dD` and `-dI` by the scalar
printer) read the same: `-E -P` -0.22% (base again -0.12%), `-E` -0.02%
(-0.23%), `-c` -0.12% (+0.12%).

## What each mode costs (head)

| `sqlite3.c` | wall | instructions | output bytes |
| --- | ---: | ---: | ---: |
| `-E -P` | 11.542 ms | 152,182,723 | 2,344,022 |
| `-E -P -C` | 28.800 ms | 441,874,748 | 5,758,441 |
| `-E -P -CC` | 39.429 ms | 743,399,101 | 6,083,008 |
| `-E` | 13.945 ms | 196,743,879 | 2,624,363 |
| `-E -C` | 34.714 ms | 604,582,365 | 5,918,354 |
| `-E -dD -dI` | 15.404 ms (round 1, scalar printer: 26.525) | 232,343,108 | 2,923,572 |

| `main.c` | wall |
| --- | ---: |
| `-E -P` | 76.574 ms |
| `-E -P -C` | 145.825 ms |
| `-E -P -CC` | 233.331 ms |
| `-E` | 85.610 ms |
| `-E -C` | 164.551 ms |
| `-E -dD -dI` | 106.116 ms (round 1: 197.366) |

`-C`'s preprocessing alone, on `sqlite3.c` (`benchmark-preprocessor`, the
vectorized kernels):

| phase | `-E` | `-E -C` | `-E -CC` |
| --- | ---: | ---: | ---: |
| read | 0.676 ms | 0.688 ms | 0.685 ms |
| lex | 2.392 ms | 15.697 ms | 15.734 ms |
| refine | 1.521 ms | 4.612 ms | 4.617 ms |
| directives | 0.309 ms | 0.245 ms | 0.246 ms |
| main loop | 5.444 ms | 6.935 ms | 5.945 ms |
| printing (`-P`) | 1.700 ms | 2.139 ms | 13.500 ms |

- **`-C`'s cost is the scalar lexer.** Only the scalar lexer has
  `C_TOKENIZER_KEEP_COMMENTS`, as only it has `C_TOKENIZER_NO_DOLLARS`. It takes
  15.7 ms where the vectorized lexer takes 2.4 ms without comments. Refinement
  reads the comments' bytes as tokens' now (4.6 ms against 1.5). The main loop
  collects `-C`'s arguments a token at a time to drop their comments (6.9 ms
  against 5.4).
- **`-CC`'s printing is the scalar printer's,** 13.5 ms against the vector
  printer's 2.1. The scalar printer turns a replacement list's `//` comment into
  a block comment, and starts a line after any other.
- **`-dD` and `-dI`** cost 1.5 ms more than `-E` on `sqlite3.c` (20 ms on
  `main.c`), now that the vector printer prints them: their 300 KB of lines,
  through stdio.
