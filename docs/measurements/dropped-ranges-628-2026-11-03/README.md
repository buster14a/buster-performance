# The dropped ranges' room past the scratch's discard (buster#628), 2026-11-03

Main's `-c` of the frozen `sqlite3.c` peaked 4 MB higher at `703ae9f5` than at `b70deb47`. This record holds the
bisect of that rise (on the laptop) and the 9700X measurement of the change that puts back its larger part: Buster's
branch `claude/628-dropped-ranges` pushes `check_program`'s dropped ranges (#1154, #1108) past the scratch's discard.

## Sources

| tree | Buster commit | what |
| --- | --- | --- |
| `main-9a74fc37` | [`9a74fc374d3380ffda351e1248f6a7e861caece7`](https://github.com/buster14a/buster/tree/9a74fc374d3380ffda351e1248f6a7e861caece7) | main when the change was made |
| `head-d0ba7a5f` | [`d0ba7a5f1f5ec1d336a6fc5ae34b20c79dded895`](https://github.com/buster14a/buster/tree/d0ba7a5f1f5ec1d336a6fc5ae34b20c79dded895) | the change on `9a74fc37` |

The bisect's builds (`bisect/peaks.txt`) are `git archive`s of main's merges `b70deb47`, `b4b0b89f` (#1154),
`754475d4` (#1173, #1177), `492b8249` and `703ae9f5`, and `703ae9f5` with the change's code, each built by its own
`./build.sh` with `BUSTER_DEBUG_INFO=0` on the laptop (Ryzen 9 7940HS).

`receipts.txt` has the 9700X's host, CPU, CPU 2's governor and EPP, clang's and perf's versions, both executables'
SHA-256 and the input's: the frozen corpus's `sqlite3.c`, SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with the `compile_time` step's options:

```sh
-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c
```

## Method

- **The bisect:** each build's `--time-stages` peak (`peak-rss-kb`) and each stage's peak growth, two runs pinned to one
  CPU, and `size(1)` of the executables.
- **The 9700X**, CPU 2 under the host's lock, one hold per script (`scripts/`, run by `round6.sh`): each tree's
  `./build.sh`; `objects.sh`, `-c` by each tree by default, `--scalar`, `--lanes 8` and `-g`, compared with `cmp`, and
  the default's `--time-stages`; `ab.sh`, 8 rounds, the order alternating, of a warm-up and `perf stat -r 3` of each,
  then `measure-compile --runs 11` by each with the other as its reference. `round6/summary.txt` keeps the scripts' own
  lines; the host lock's messages are left out.

## Results

**The bisect** (`bisect/peaks.txt`): the peak is 296.5 MB at `b70deb47`, 300.3 MB after #1154, 301.4 MB after #1177,
and so to `703ae9f5`.
- After #1154, `lower` (+1,884 KiB) and `emit-setup` (+2,048 KiB) grow the peak past the checker's, where they grew it
  none before. #1154 pushes a column of the ranges the writer leaves out, a token's room of 8 bytes each (5.7 MB on
  `sqlite3.c`), on the scratch before `check_program`'s discard (`arena_discard`), which gives the pages past the pass's
  columns back to the kernel: the parse's and the reader's, which touched more of the scratch first. The column moved
  the discard 5.7 MB up, and the writer fills only a prefix of it.
- #1177 grows the text by 428 KB, and each stage's growth a little: the code its profile-guided changes trade.
- `703ae9f5` with the column pushed past the discard: 297.2 MB, with the same object.

**The 9700X** (`round6/`), `main-9a74fc37` (A) against `head-d0ba7a5f` (B), medians:

| measure | main | the change |
| --- | ---: | ---: |
| task clock | 111.620 ms | 111.700 ms |
| user cycles | 531.21 M | 531.53 M |
| user instructions | 1,204.84 M | 1,204.51 M |
| kernel cycles | 87.26 M | 87.62 M |
| page faults | 4,970 | 4,973 |
| peak RSS (`measure-compile`'s `wait4`) | 295,084 KiB | 291,288 KiB |

Every object is the same bytes, by all four variants. The rounds are within 0.4 ms of each other either way. B's
stages grow the peak none past `check-program`, where A's `lower` and `emit-setup` grow it 3.6 MB.

## Limitations

- One build of each tree, one placement. The change claims the peak alone; the times are flat.
- The bisect's peaks are the laptop's, whose huge pages' alignment differs from the 9700X's: 4.1 MB there, 3.8 MB here.
