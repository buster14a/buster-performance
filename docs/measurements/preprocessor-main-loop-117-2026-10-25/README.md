# The preprocessor's main loop against #117's budget, 2026-10-24/25

The 9700X's measurements behind Buster's [#117](https://github.com/buster14a/buster/issues/117) PR of the main
loop's fast paths, cited by `docs/c-preprocessor.md` ("The main loop against #117's budget"). #115 budgets 2 ms for
`sqlite3.c`'s directive tables plus main loop and setup; the 2026-10-23 acceptance
([record](../preprocessor-117-2026-10-23/README.md)) measured 0.301 + 6.846 ms.

## Sources and inputs

| Tree | Buster commit | Files | Source manifest's SHA-256 |
| --- | --- | ---: | --- |
| `main-d0a61b8` | `d0a61b852e365f94e56e56f7e3d51a3b1a29ff6c` (main, with #408) | 563 | `f1c7033558031b99f51d360a24653b6bf3eeabcfea4a88d771cd03adb4c6a354` |
| `cand-59f805c` | `59f805c14d25e94c671edca77ea5595ef15962f8` (the PR's head, main merged in) | 563 | `9ae06d07ae8359451b2cbef254c000f5b4b9bb886c31c3eb443c270964d616d9` |

Each `source-*.sha256` lists the SHA-256 of every file of `git archive` of the commit. Both trees were sent to the
host by `git archive`; the host's files but `build/` match the manifests. Buster's `./build.sh` built each
there (`logs/build-*.txt`). The `build/compiler` SHA-256s: `main-d0a61b8` `60f485527f07953023391b197a31513e9a5d2a91d81ff16606d039876d6f0c24`, `cand-59f805c` `c4bdab726027e7673622b8cdf57f11b1e338db781ab88b66a8516eb56442c41d`.

The earlier rounds (`logs/ab*.txt` but `ab12`, `logs/hc11-*`, `logs/cg11-*`) measured the branch's commits as they
were made, before main was merged in. Their trees are `base-dc8fe2e` (main at `dc8fe2e`) and `cand-<commit>`:
`9aaab89` (with `5dadd97` and `fb7135b` below it), `efe1e73`, `d451fe6` (reverted), `5ec4653` (with `94e9c4e`),
`64e7910` and `7d2b2c8`. Each was sent by `git archive` of that commit.

Inputs, the 2026-10-23 acceptance's frozen ones:

- `sqlite3.c` 3.53.2 from the bundle `preprocessor-corpora-astra-01a158dd` (`MANIFESTS.sha256`:
  `391e729af6587355050881752558e790299cfe638c7dc7803bd028a8535ebcbd`; `sqlite3.c`:
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`), with the bundle's pinned headers:
  `-target x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc` and its three `-isystem` directories (`scripts/args.sh`).
- `main.c` of Buster at `635434f2a4d153c6de1dd2f1149055c4507c6f46` (the acceptance's frozen repository input), with
  the system's headers: `-march=native -std=gnu17 -I <tree>/src -fwrapv -funsigned-char`.
- `SOURCE_DATE_EPOCH=1792454400`; `CPATH`, `C_INCLUDE_PATH` and `CPLUS_INCLUDE_PATH` unset.

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, the `performance` governor and energy preference. Every
build and run took the shared lock on its own, through `~/buster-fast-bench/exclusive.sh` with
`EXCLUSIVE_OWNER=claude-117` (`scripts/locked.sh`), and ran pinned to CPU 2 (`scripts/bench.sh`). The lock's waiting
messages, which name other sessions' runs, are removed from the logs; nothing else in them is changed.

## The A/B: main against the PR

`scripts/queue12.sh`: `benchmark-preprocessor --only vectorized` (21 passes after a warm-up, medians), the two trees by
turns, four rounds on `sqlite3.c` and three on `main.c`; then `--history-cost` twice on the PR's tree.

`logs/ab12-sqlite-*.txt`, `sqlite3.c` (1,242,327 input tokens, 706,237 output tokens):

| Tree | Whole run | Directive tables | Main loop/setup | Instructions/input token |
| --- | ---: | ---: | ---: | ---: |
| `main-d0a61b8` | 11.630-11.700 ms | 0.307-0.310 ms | 6.728-6.798 ms | 134.93 |
| `cand-59f805c` | 10.603-10.654 ms | 0.296-0.298 ms | 5.797-5.827 ms | 118.73 |

`logs/ab12-main-*.txt`, `main.c` (1,890,827 input tokens, 2,282,574 output tokens):

| Tree | Whole run | Directive tables | Main loop/setup | Instructions/input token |
| --- | ---: | ---: | ---: | ---: |
| `main-d0a61b8` | 35.176-35.318 ms | 0.281-0.282 ms | 26.209-26.409 ms | 334.03 |
| `cand-59f805c` | 34.370-34.732 ms | 0.273-0.277 ms | 25.497-25.821 ms | 326.02 |

`logs/hc12-sqlite-cand-*.txt`, `--history-cost` on `cand-59f805c`: main loop/setup 5.854-5.896 ms with history,
5.076-5.160 ms without; 118.73 and 110.45 instructions per input token.

## The commits, step by step

`benchmark-preprocessor --only vectorized sqlite3.c`, each step's tree by turns with the tree before it (`logs/ab*.txt`,
three rounds unless noted), main loop/setup in ms:

| Step | Before | After | Logs |
| --- | ---: | ---: | --- |
| `5dadd97`, `fb7135b`, `9aaab89` against `dc8fe2e` | 6.733-6.801 | 6.129-6.184 | `ab-sqlite-*` |
| `efe1e73`, against `dc8fe2e` | 6.726-6.883 | 6.054-6.145 | `ab4-sqlite-*` |
| `d451fe6`'s line table, against `efe1e73` | directive tables 0.290-0.291, main 6.110-6.197 | 0.650-0.677, 6.166-6.241 | `ab5-sqlite-*` |
| `94e9c4e`, `5ec4653`, against `efe1e73` | 6.086-6.091 | 6.041-6.058 | `ab7-sqlite-*` |
| `64e7910`, against `5ec4653` | 6.043-6.088 | 5.945-6.015 | `ab8-sqlite-*` |
| `7d2b2c8`, against `64e7910` | 5.926-5.948 | 5.809-5.874 | `ab10-sqlite-*` |

`main.c` in the same rounds (`ab*-main-*`) moved within its noise between most steps (it has slow and fast states by
build, 25.6 to 26.7 ms): 26.04-26.27 ms at `dc8fe2e`, 25.57-26.23 at `7d2b2c8`.

## Where the time goes

- `logs/hc11-sqlite-*.txt` and `logs/hc12-*`: `--history-cost`. History recording takes 5.849 ms of main loop/setup
  against 5.068 without it (`7d2b2c8`).
- `logs/cg11-children.txt` and `logs/cg11-faults.txt`: `perf record -F 4999 -e cycles --call-graph dwarf` of the scratch
  probe (`scripts/probe.c`, `scripts/perf.sh`, 12 runs of `sqlite3.c`, `7d2b2c8`), user and kernel, by symbol with
  children and by caller. The kernel's `clear_page_erms` takes 9.9% of the run, 3.96% of it under the output's stores
  (`pp_store_file_tokens`); `pp_line_of` takes 3.06%.
- `logs/probe11-*.txt`: the probe's parts, with and without history.

The invocation census and the per-expansion instruction counts in `docs/c-preprocessor.md` come from the laptop (a
Ryzen 9 7940HS, clang 23.1.3) and are not in this record.

## Limitations

`logs/ab-main-*.txt` are the first `main.c` runs, which failed: the bundle's headers lack `linux/memfd.h`, which
`main.c` includes, so later runs use the system's headers (`scripts/args.sh`). Medians of rounds from one machine, by
turns, in sessions that shared the machine with CI jobs and another session
between runs. `main.c` has build-dependent speed states (Buster's `docs/profiling.md`), so its A/B carries more
noise than `sqlite3.c`'s. The scratch probe is not part of Buster.
