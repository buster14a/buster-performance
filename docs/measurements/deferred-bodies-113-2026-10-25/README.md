# Deferred function bodies on lanes (#113), 2026-10-25

The 9700X's measurements of Buster's deferred reader, `check_input_deferred` (`c_check_deferred.c`), for issue
[#113](https://github.com/buster14a/buster/issues/113): it reads each file-scope function body apart from the top
level, out of order on lanes, and merges the bodies in source order. The issue asks for the cost of the position checks
(each body's file-scope bindings set from the history at its opening, and its table's view of the top level's types),
reported with the parser's numbers. Cited by Buster's `docs/c-deferred-bodies.md` ("Measurements").

## Sources and inputs

| Tree | Buster commit | Files | Source manifest's SHA-256 |
| --- | --- | ---: | --- |
| `old` | `9d047924` (each lane's table index sized for its capacity) | 457 | `20cbe999310f3793325bab9a219efa61557f6be8bb7625c3b482229e797f2d9e` |
| `new` | `ccafeac4` (each lane's index sized for the top level's types and 4,096 more) | 457 | `37047dd9dd46ced97d23b34ea80d84d39f2a89c3df6b09b993797c9fbb56d47b` |
| `final` | `e6042e6c` (and each lane's arenas in base pages, one change record a lane, and a review's fixes) | 457 | `507613af63b4f7625a4916ba50652c1f8c4655e782866b45f9664cf25dadf0e6` |

Each `source-*.sha256` lists the SHA-256 of every file of `git archive` of the commit (the manifest's own SHA-256 is
in the table). All three trees were sent to the host by `tar`, and the host's files, apart from `build/`, match the
manifests. Buster's `./build.sh` built each there with `BUSTER_DEBUG_INFO=0` and `LC_NUMERIC=C`.

The input is the frozen `sqlite3.c` of the 9700X's preprocessor corpus (`/var/lib/buster-9700x/corpora/
preprocessor-391e729af658/sqlite/sqlite3.c`), with that corpus's pinned predefines and headers, as Buster's 9700X job
checks it: `--predefines .../provenance/gnu17-pinned-predefines.txt --clang-features --no-default-config
--target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc` and its three `-isystem` directories.
`SOURCE_DATE_EPOCH=1792454400`; `CPATH` and `C_INCLUDE_PATH` are unset. The unit has 706,237 tokens and 2,608
function bodies.

Host: AMD Ryzen 7 9700X, clang 23.1.1. Every run took the shared lock on its own through
`~/buster-fast-bench/exclusive.sh`. The command is

```sh
./build/compiler benchmark-checker-deferred --passes 9 --lanes 8 --cpus 2,0,1,3,4,5,6,7 [the options above] sqlite3.c
```

which pins itself and lane 0 to CPU 2 (the host's `performance` CPU), where the parse, source order and the top level
run, and its other lanes to CPUs 0, 1 and 3 to 7, one per core, in a team every run reuses. Each pass parses the unit
and checks it by `check_input` and by the deferred reader on one lane and on eight, in turns that rotate; a figure is
the median of 9 passes, in nanoseconds per token of the unit. `scripts/queue.sh` ran three processes of `old` a minute
apart (`logs/first.txt`), `scripts/queue3.sh` three rounds of `old` and `new` in alternating order, 30 s apart
(`logs/paired-index.txt`), and `scripts/queue4.sh` three rounds of `old` and `final` so (`logs/paired-final.txt`).
The lock's waiting messages, which name other sessions' runs, are removed from `logs/`; nothing else in them is
changed.

## Results

A range is over the processes: nine of `old` (three in each log), three of `new` and three of `final`. Every run
merged the unit: 2,608 bodies read apart, 52,764 heads read from the history.

| ns/token of `sqlite3.c` | `old` | `new` | `final` |
| --- | ---: | ---: | ---: |
| the parse (`parse_translation_unit`, the vector path) | 13.37 to 13.58 | 13.47 to 13.56 | 13.47 to 13.53 |
| source order's reader (`check_input`) | 105.00 to 105.84 | 104.90 to 105.26 | 105.13 to 105.50 |
| deferred, one lane: whole | 141.73 to 143.11 | 140.94 to 141.73 | 122.10 to 123.92 |
| top level | 40.75 to 41.38 | 40.79 to 41.12 | 40.80 to 41.15 |
| the history's index | 0.134 to 0.137 | 0.135 to 0.136 | 0.133 to 0.135 |
| bodies' walks | 18.59 to 18.83 | 18.66 to 18.93 | 17.04 to 17.50 |
| position checks | 3.673 to 3.726 | 3.591 to 3.604 | 3.240 to 3.264 |
| the lanes' span | 39.47 to 39.72 | 38.87 to 39.18 | 21.86 to 22.32 |
| merge | 7.52 to 7.79 | 7.47 to 7.89 | 6.81 to 6.89 |
| the phases after it | 53.64 to 54.36 | 53.13 to 53.81 | 52.44 to 52.82 |
| deferred, eight lanes: whole | 135.94 to 136.67 | 132.62 to 133.04 | 107.30 to 108.00 |
| bodies' walks, summed over the lanes | 63.85 to 65.00 | 63.74 to 64.33 | 25.64 to 25.67 |
| position checks, summed | 8.532 to 8.662 | 8.531 to 8.583 | 4.796 to 4.836 |
| the lanes' span | 33.37 to 33.52 | 30.25 to 30.42 | 6.22 to 6.34 |
| merge | 7.71 to 7.85 | 7.79 to 7.82 | 7.10 to 7.20 |

The position checks per body, on one lane: 995 to 1,009 ns (`old`), 972 to 976 (`new`) and 877 to 884 (`final`); on
eight lanes, summed, 2,311 to 2,346, 2,310 to 2,324 and 1,299 to 1,310.

So in `final`, the position checks cost 3.25 ns/token on one lane: 24% of the parse's 13.5 and 3.1% of source order's
105.4. On eight lanes the bodies' walks and checks take 6.3 ns/token of span, and the deferred reader comes to 107.3 to
108.0 against source order's 105.1 to 105.5: its sequential parts (the top level, the merge and the phases after it,
101.4 in all) are what is left. `new`'s index sized for the top level's types barely moves eight lanes' walks; `final`'s
base pages for the lanes' arenas do. A lane's copies are columns with room for the largest body, mostly untouched, and
a huge page is cleared whole the first time any of it is: on the laptop (Zen 4), a profile of the version before the
base pages had the lanes spending about 40% of their time in the kernel's page allocation, clearing them.

## Limitations

One unit, `sqlite3.c`, is measured; the corpora's identity checks are Buster's tests, not these runs. The reader alone
is timed (`check_input`'s work), not the checked graph after it. CPUs other than 2 run the host's `powersave`
governor with `balance_performance`: a lane that waited idle runs slower for a while after it wakes.
