# The files' token columns given back after the run (buster#628, buster#1647), 2026-11-07

This record holds the 9700X measurements of buster#1647. The change gives back the preprocessor file cache's token
columns once a unit's run is over (`pp_release_file_columns`): 11.5 MB of `sqlite3.c`'s, which stayed to the backend.
It also gives `-Wempty-body`'s indentation check the place of a lone macro invocation from the file's bytes
(`pp_output_invocation_place`). That check was what made `sqlite3.c`'s compile replay the whole unit for its expansion
history. buster's `docs/compile-time.md` ("The files' token columns, and `-Wempty-body`'s replay") has the reasoning.

## Sources

| tree | Buster commit | what |
| --- | --- | --- |
| `main3` | [`4d6562be1681b01929c8eb7afb7e6185acecc8e9`](https://github.com/buster14a/buster/tree/4d6562be1681b01929c8eb7afb7e6185acecc8e9) | main, the change's parent |
| `cols` | [`fb2b4af1b93a2122add77ebb434916e21ba4ae6a`](https://github.com/buster14a/buster/tree/fb2b4af1b93a2122add77ebb434916e21ba4ae6a) | buster#1647's commit |

Both were fetched from GitHub into the host's clone (`run/fetch7.log`). `receipts.txt` has the host, kernel, CPU 2's
governor and EPP, the transparent huge pages' setting, clang's and perf's versions, both executables' SHA-256 and the
input's. The input is the frozen corpus's `sqlite3.c` (SQLite 3.53.2), SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with the `compile_time` step's options:

```sh
-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c
```

## Method

The 9700X, through `~/buster-fast-bench/exclusive.sh`, **one grant of the lock per measured compiler process**. The
scripts are in `scripts/`; the outputs in `run/`.
- `chain7.sh` checked both trees' commits and built each with `BUSTER_HOST_ARCH=znver5` (`build.sh`), each build under
  one hold of the lock (`run/builds/`).
- It ran `ab-grants.sh` for 7 rounds with the step's options (`run/ab7/`), and for 5 with `-w` added (`run/ab7w/`), the
  order alternating by round.
- **Each run** is `taskset -c 2 perf stat -x, -e task-clock,cycles:u,instructions:u,cycles:k,instructions:k,page-faults`
  of the compiler with `--time-stages`, under its own grant. For each run the directory keeps:
  - the exact command (`.command`);
  - the lock's owner line as the run saw it (`.owner`);
  - the exit status, perf's output and the stage report;
  - the object's SHA-256.

  `ab-grants.sh` fails if any run didn't complete, saw another owner, or wrote an object that differs from the first
  one.
- It compiled each tree's object under one grant each (`run/objects7/`), in six modes:
  - by default;
  - with `-Wall -Wextra`;
  - with `--scalar -Wall -Wextra`;
  - with `--lanes 8`;
  - with the deferred reader on 8 lanes (`--lanes 8 --deferred-bodies`);
  - with `-g`.

  It compared them with `cmp` (`run/objects7.log`). Each `.err` starts with `exclusive.sh`'s notice of whoever held the
  lock while the compile waited, which differs between the trees. With those notices left out, the two trees'
  diagnostics are the same lines in every mode: none, or `-Wall -Wextra`'s 25 with or without `--scalar`.
- It wrote the receipts.

## Results

Every run completed under its own grant, and every object is the same bytes by both trees, in all six modes.

**The step's options**, medians of 7:

| measure | main `4d6562be` | buster#1647 |
| --- | ---: | ---: |
| task clock | 131.06 ms | 124.95 ms |
| user cycles | 632.17 M | 605.21 M |
| user instructions | 1,403.55 M | 1,323.82 M |
| kernel cycles | 93.81 M | 86.72 M |
| page faults | 6,265 | 5,845 |
| peak RSS (`--time-stages`) | 272,556 KiB | 258,172 KiB |
| `check-program` (`--time-stages`) | 31.22 ms | 25.18 ms |

**With `-w`**, medians of 5:

| measure | main `4d6562be` | buster#1647 |
| --- | ---: | ---: |
| task clock | 109.22 ms | 108.96 ms |
| user instructions | 1,186.48 M | 1,186.49 M |
| kernel cycles | 89.27 M | 86.27 M |
| page faults | 5,776 | 5,841 |
| peak RSS (`--time-stages`) | 272,560 KiB | 258,172 KiB |

- **The time.** With the step's options the change is faster in each of the 7 rounds, by 4.77 to 6.44 ms. Its 80 M
  fewer user instructions are the history's replay, which `-Wempty-body` no longer asks for. With `-w`, which never
  replayed, the change is 0.05 to 0.42 ms faster in each of the 5 rounds, within the noise, and the kernel's cycles are
  3% fewer.
- **The memory.** The peak is 14.4 MB lower with and without `-w`.

`--time-stages`' system and user milliseconds come from `getrusage`, which samples them by the scheduler's tick. Its
system time is too coarse for these differences, so the table gives perf's kernel cycles instead.
