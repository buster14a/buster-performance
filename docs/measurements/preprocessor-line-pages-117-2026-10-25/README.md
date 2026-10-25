# Line ends counted by page (#117), 2026-10-25

The 9700X's measurements behind Buster's PR [#439](https://github.com/buster14a/buster/pull/439). In that PR, a file
prepared a window at a time (`pp_prepare_windows`) has its line ends counted while each window is in the caches, into
the count before each 4 KB page (`pp_count_page_lines`, `PPFileData.line_pages`). `pp_line_of` counts from the page's
start, or from its cursor on the same page, rather than from its cursor through bytes read long before. Cited by
`docs/c-preprocessor.md` ("The main loop against #117's budget").

## Sources and inputs

| Tree | Buster commit | Files | Source manifest's SHA-256 |
| --- | --- | ---: | --- |
| `main-4f4a0bf` | `4f4a0bfa815f1bdbf2330f4e708cf8bc2e9934fa` (main under the PR) | 608 | `45908e8c126f92ad1f4055c13e912aa3a748b4c16cf329f28068d77cfcf2d6cc` |
| `cand-a1f8ddf` | `a1f8ddf1b2c1e9ffb57a2d7f27ecd50e7b011bbd` (the PR's code; its later commit changes docs) | 608 | `b8ec772a669e1228a79d23c8599b6559eeca79d9dfac01b76e047e7a5b273849` |

Each `source-*.sha256` lists the SHA-256 of every file of `git archive` of the commit. Both trees were sent to the host
by `git archive`, and the host's files, apart from `build/`, match the manifests. Buster's `./build.sh` built each one
there (`logs/build15-main-4f4a0bf.txt` and `logs/build17-cand-a1f8ddf.txt`). The `build/compiler` SHA-256s:

- `main-4f4a0bf`: `9db55dd76668cfade0ac8409c920a8e1e4b3ae4a6f84ab907fea1780e5b60277`;
- `cand-a1f8ddf`: `57bc144f317e2aa9c99390b1603b8ea2e68c1c2e1dbb966392af101470176b42`.

The inputs are the 2026-10-23 acceptance's:

- the frozen `sqlite3.c` 3.53.2, from the bundle `preprocessor-corpora-astra-01a158dd`
  (`sqlite3.c`: `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`), compiled with the bundle's pinned
  headers: `-target x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc` and its three `-isystem` directories;
- `main.c` of the frozen tree `635434f2`, with the system's headers, as the 9700X job's smoke command preprocesses it.

Both are in `scripts/args.sh`. `SOURCE_DATE_EPOCH=1792454400`; `CPATH`, `C_INCLUDE_PATH` and `CPLUS_INCLUDE_PATH` are
unset.

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, with the `performance` governor and energy preference.
`scripts/queue17.sh` ran everything below in order (main's tree had been built by an earlier queue, whose other runs
were stopped before they measured anything). Every run took the shared lock on its own, through
`~/buster-fast-bench/exclusive.sh` with `EXCLUSIVE_OWNER=claude-117` (`scripts/locked.sh`), pinned to CPU 2. The lock's
waiting messages, which name other sessions' runs, are removed from the logs; nothing else in them is changed.

## The main loop

`benchmark-preprocessor --only vectorized` (21 passes after a warm-up, medians) ran on the two trees by turns, four
rounds on `sqlite3.c` and three on `main.c`. Both record the history, as the benchmark does by default. A range is
the rounds' medians (`logs/ab17-*.txt`).

| `sqlite3.c` | Whole run | Directive tables | Main loop/setup | Instructions/input token |
| --- | ---: | ---: | ---: | ---: |
| `main-4f4a0bf` | 10.702-10.730 ms | 0.296-0.299 ms | 5.889-5.926 ms | 118.16 |
| `cand-a1f8ddf` | 10.183-10.296 ms | 0.347-0.368 ms | 5.380-5.405 ms | 118.02 |

| `main.c` (frozen at `635434f2`) | Whole run | Directive tables | Main loop/setup | Instructions/input token |
| --- | ---: | ---: | ---: | ---: |
| `main-4f4a0bf` | 34.463-34.616 ms | 0.278-0.287 ms | 25.630-25.736 ms | 321.64 |
| `cand-a1f8ddf` | 34.232-35.162 ms | 0.307-0.314 ms | 25.317-26.174 ms | 321.99 |

On `main.c`, which has far fewer `__LINE__`s than `sqlite3.c`, the candidate's main loop took 25.457 and 25.317 ms in
its first two rounds, against main's 25.630 to 25.736 ms, and 26.174 ms in its third
(`logs/ab17-main-cand-a1f8ddf-3.txt`): three rounds don't separate the trees there.

## Whole drivers

`time-runs` ran under `ab` (Buster's `docs/profiling.md`, "Whole drivers"): three rounds with the trees' order rotating
by round, and in each round 21 processes of each command after a warm-up. Each process is timed from `fork` to
`wait4`, with its startup, page faults and teardown included. A range is the rounds' medians, and the spread is the
fastest and slowest single process over all rounds (`logs/drivers17-sqlite.txt`).

| `sqlite3.c` | Tree | Wall time | Spread | Peak resident set | Minor faults |
| --- | --- | ---: | ---: | ---: | ---: |
| `-E -o /dev/null` | `main-4f4a0bf` | 19.862-19.935 ms | 19.382-20.453 ms | 57,752-57,828 KB | 803 |
| | `cand-a1f8ddf` | **19.376-19.472 ms** | 18.578-19.904 ms | 57,644-57,712 KB | 802 |
| `parse -fsyntax-only` | `main-4f4a0bf` | 18.855-18.978 ms | 18.498-19.474 ms | 140,208-140,244 KB | 919-920 |
| | `cand-a1f8ddf` | **18.100-18.377 ms** | 17.886-18.984 ms | 140,148-140,204 KB | 919 |

## Limitations

The data are medians of rounds from one machine, taken by turns while CI jobs and other sessions shared the machine
between runs. Different builds of the same code differ by up to about 1% from code placement alone (Buster's
`docs/profiling.md`, "Builds in turn"). Only `sqlite3.c` was timed as whole processes.
