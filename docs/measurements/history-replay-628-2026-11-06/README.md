# The deferred history's replay (buster#628, buster#1574), 2026-11-06

This record holds the 9700X measurements of [buster#1574](https://github.com/buster14a/buster/pull/1574):
- the replay that records a unit's expansion history runs only past the unit's first `[[`
  (`parse_clang_scope_numbers`), where since #1455 it ran for every unit with a macro's number after a comma;
- the replay's output columns are released once compared with the unit's output (`pp_history_record`).

## Sources

| tree | Buster commit | what |
| --- | --- | --- |
| `main` | [`67cd05ca530b9597fbd24e6843791a85f16ed6ad`](https://github.com/buster14a/buster/tree/67cd05ca530b9597fbd24e6843791a85f16ed6ad) | main when the A/B was set up |
| `branch` | [`190428a2e0b6ae0c1c1cbbe81c28ac3560ae67da`](https://github.com/buster14a/buster/tree/190428a2e0b6ae0c1c1cbbe81c28ac3560ae67da) | the change on `67cd05ca` |

#1574 merged at `a875fced`, which adds a test-only and docs commit (`d083a3c2`, #1562's review notes) and a merge of
main. The commit with #1574's last review follow-ups (`f801fea9`, a test and a comment) went into
[buster#1584](https://github.com/buster14a/buster/pull/1584). Neither changes what these runs execute.

`receipts.txt` has the host, kernel, CPU 2's governor and EPP, the transparent huge pages' setting, clang's and perf's
versions, both executables' SHA-256 and the input's. The input is the frozen corpus's `sqlite3.c` (SQLite 3.53.2),
SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with the `compile_time` step's options:

```sh
-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c
```

## Method

The 9700X, through `~/buster-fast-bench/exclusive.sh`, **one grant of the lock per measured compiler process**. The
scripts are in `scripts/`; the outputs in `round3/`.
- `round3.sh` moved the trees to the commits above and built each with `BUSTER_HOST_ARCH=znver5` (`build.sh`), one hold
  of the lock per build (`builds/`).
- `chain3.sh` then ran `ab-grants.sh` twice, 7 rounds each, the order alternating by round:
  - `ab3/`: with the step's options;
  - `ab3w/`: with `-w` too.
- **Each run** is `taskset -c 2 perf stat -x, -e task-clock,cycles:u,instructions:u,cycles:k,instructions:k,page-faults`
  of the compiler with `--time-stages`, under its own grant. For each run the directory keeps:
  - the exact command (`.command`);
  - the lock's owner line as the run saw it (`.owner`);
  - the exit status, perf's output and the stage report;
  - the object's SHA-256 (the object itself is deleted).

  `ab-grants.sh` fails if any run didn't complete, saw another owner, or wrote an object that differs from the first
  one. `summary.txt` has the medians and each round's task clock.
- `objects3/`: each tree's object by default, with `--scalar`, with `--lanes 8` and with `-g`, each compile under its own
  grant, compared with `cmp` (`objects3.log`).

The runs took from 23:12 to 01:40 UTC: the lock was shared with CI jobs and other sessions between grants.

## Results

Every run completed under its own grant. Every object is the same bytes by both trees: in each series, by default,
with `--scalar`, `--lanes 8` and `-g`.

| measure (medians of 7) | main, step's options | change, step's options | main, `-w` | change, `-w` |
| --- | ---: | ---: | ---: | ---: |
| task clock | 139.18 ms | 141.38 ms | 127.46 ms | 121.87 ms |
| user cycles | 672.9 M | 685.1 M | 609.6 M | 583.7 M |
| user instructions | 1,658.5 M | 1,668.9 M | 1,554.0 M | 1,474.3 M |
| kernel cycles | 98.4 M | 97.7 M | 96.4 M | 90.2 M |
| page faults | 6,387 | 6,439 | 6,383 | 5,897 |
| peak RSS (`--time-stages`) | 297,448 KiB | 279,272 KiB | 297,548 KiB | 279,272 KiB |

- **Memory.** Both series' peaks are 18.2 MB lower: `parse` adds 79,660 KiB where it added 97,932.
- **With `-w`**, the change is 5.6 ms faster, in each of the 7 rounds: `parse` takes 7.54 ms where it took 13.55 ms (the
  medians of `--time-stages`), as the replay no longer runs.
- **With the step's options**, it is 2.2 ms slower, in 5 rounds of 7. The unit's one warning is #1339's false
  `-Wempty-body` at `sqlite3.c:74649`, which main's replay of every unit masked and #1547 fixes. With the change it is
  printed, and its history is recorded for it:
  - the replay moves from `parse` (6.0 ms less) to `check-program` (6.3 ms more);
  - rendering the warning's notes at the end adds 1.9 ms to `release` (3.2 to 3.8 ms on the VM, against 0.1 to 0.2
    ms without it).

  So the step's time drops with #1547, apart from this change.

`docs/compile-time.md` in buster ("The expansion history's replay (#628)") has the VM's numbers and the mechanism.
