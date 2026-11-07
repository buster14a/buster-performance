# The reader's sparse output in base pages (buster#628, buster#1584), 2026-11-07

This record holds the 9700X measurements of a change that buster#1584 carried and then reverted: the reader's sparse
columns' directories and pool (`check_sparse_reserve_wide`) and the graph's leaf rows (`leaf_payloads`) in an arena of
base pages, which the C driver reserved for each unit (`check_driver_unit`), instead of the huge pages of its arena.
On the VM it took 6 MB off each of `-c sqlite3.c`'s three peaks. On the 9700X it took 2.6 MB off the peak and added
0.8 ms to the compile, so it isn't in. buster's `docs/compile-time.md` ("Partly used huge pages, and three changes not
taken") has the reasoning.

## Sources

| tree | Buster commit | what |
| --- | --- | --- |
| `main2` | [`faef1f98d2f8a59fea2d1a091813cb3b9191d2e3`](https://github.com/buster14a/buster/tree/faef1f98d2f8a59fea2d1a091813cb3b9191d2e3) | main when the change was made |
| `sparse` | `dd32e723dd401448bb0afc33751d3d1b10f462a3` | the change on `faef1f98`, sent to the host as a bundle |

`dd32e723`'s code is buster#1584's first commit's,
[`b6708929`](https://github.com/buster14a/buster/commit/b6708929e841e023688087044f98a02ca6fcd552), on the base that
#1584 later moved to (`02e739a1`). Its docs differ.

`receipts.txt` has the host, kernel, CPU 2's governor and EPP, the transparent huge pages' setting, clang's and perf's
versions, both executables' SHA-256 and the input's. The input is the frozen corpus's `sqlite3.c` (SQLite 3.53.2),
SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with the `compile_time` step's options:

```sh
-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c
```

## Method

The 9700X, through `~/buster-fast-bench/exclusive.sh`, **one grant of the lock per measured compiler process**. The
scripts are in `scripts/`; the outputs in `run/`.
- `chain5.sh` built `main2` with `BUSTER_HOST_ARCH=znver5` (`build.sh`, one hold of the lock). Its fetch of the bundle
  failed, since the clone lacked `faef1f98` (`run/chain5.log`). It was stopped before it built the change or measured
  anything.
- After the clone fetched main and checked the bundle's commit out, `chain6.sh` did the rest:
  - it checked both trees' commits;
  - it built `sparse` under one hold;
  - it ran `ab-grants.sh` for 7 rounds, the order alternating by round (`ab6/`);
  - it compiled each tree's objects under one grant each (`objects6/`): by default, with `--scalar`, `--lanes 8`, the
    deferred reader on 8 lanes (`--lanes 8 --deferred-bodies`) and `-g`, compared with `cmp` (`objects6.log`);
  - it wrote the receipts.
- **Each run** is `taskset -c 2 perf stat -x, -e task-clock,cycles:u,instructions:u,cycles:k,instructions:k,page-faults`
  of the compiler with `--time-stages`, under its own grant. For each run the directory keeps:
  - the exact command (`.command`);
  - the lock's owner line as the run saw it (`.owner`);
  - the exit status, perf's output and the stage report;
  - the object's SHA-256.

  `ab-grants.sh` fails if any run didn't complete, saw another owner, or wrote an object that differs from the first
  one.

## Results

Every run completed under its own grant. Every object is the same bytes by both trees: by default, with `--scalar`,
`--lanes 8`, the deferred reader's 8 lanes and `-g`.

| measure (medians of 7) | main `faef1f98` | sparse output in base pages |
| --- | ---: | ---: |
| task clock | 136.31 ms | 137.11 ms |
| user cycles | 661.2 M | 665.6 M |
| user instructions | 1,627.7 M | 1,627.7 M |
| kernel cycles | 94.0 M | 94.9 M |
| page faults | 6,264 | 7,786 |
| peak RSS (`--time-stages`) | 290,936 KiB | 288,328 KiB |
| `check-input` (`--time-stages`) | 57.35 ms | 58.29 ms |
| `check-input`'s faults | 3,378 | 4,858 |

- **The time.** The change is slower in each of the 7 rounds, by 0.35 to 1.42 ms, with the same instructions. The extra
  cycles go with its 1,522 more faults, of base pages for what touched a few huge pages.
- **The memory.** `check-input` adds 2.1 MB less, and the whole peak is 2.6 MB lower. On the VM, with huge pages from
  `BUSTER_HUGE_PAGES=1` (its transparent huge pages are `madvise`), every peak was 6.0 MB lower. The 9700X's are
  `always`.
