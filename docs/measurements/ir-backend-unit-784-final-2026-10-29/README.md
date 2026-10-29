# The IR's source commands in the backend's unit, final head, Buster #784

Compiler branch: `claude/ir-backend-unit-784` of buster14a/buster, its pull request buster14a/buster#845, for
[this claim on #784](https://github.com/buster14a/buster/issues/784#issuecomment-6489490231).

[ir-backend-unit-784-2026-10-29](../ir-backend-unit-784-2026-10-29) measured the branch's first head, `d1c21464`,
against main `d11a91d2`. Since then the branch merged main, shared `x86_semantics.c`'s tables across `main.c`'s units
as it shares the encoder's (main's Tier 0 validation of `X86` rows now reads them), and fixed the 9700X job's
branch-sizing harness (which changes no compiler source). This record measures the final head's compiler against
its merge base, as the first record did.

## Sources and host

Each tree is a `git archive` of its commit, extracted into a fresh directory on the 9700X;
`logs/manifest-*.sha256` lists every file's SHA-256 as the host had it after the runs, which matched `git archive` of
each commit file for file:

- **main:** `e9e542b4ecb8b4c6f7d2ecbf9ed569967fbfe219`, the branch's merge base;
- **head:** `8d8b53c30963adc48ad881cf5a67677b86c72852`, the branch's last commit to the compiler's sources (its next,
  `ea908795`, changes only `.github/workflows/9700x.yml`).

Host (`logs/host.txt`, captured after the runs, from the same session): AMD Ryzen 7 9700X, Linux 6.18.50-2-lts,
clang 23.1.1, perf 7.2.9, CPU 2's governor and energy preference `performance`. Every build, measurement and the
receipts took a separate hold of the host's lock (`exclusive.sh`), and every measurement ran pinned to CPU 2. The lock's
waiting messages are left out of the logs: only the lines the scripts, `build.sh` and the compiler print are kept (an
allowlist of their shapes). Builds: `BUSTER_DEBUG_INFO=0 ./build.sh`; `logs/executables.sha256` gives the executables'
SHA-256.

`-c`'s input: SQLite 3.53.2's `sqlite3.c` from the host's frozen corpora
(`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`), SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with
`-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`, under
`SOURCE_DATE_EPOCH=1792454400`.

## Main against head

`scripts/q784b.sh`: both builds; then three rounds, the trees alternating and the order turning each round, of the
checker's unit compiled alone by the build's flags (`./build.sh print-compile-flags`, `clang -c
src/buster/compiler/main_unit_checker.c`, timed by the shell); then three rounds of `-c` under `perf stat -r 11`, each
round's figure the mean of 11 runs; then the two trees' objects compared.

| Run | Main | Head | Change |
| --- | ---: | ---: | ---: |
| The checker's unit alone, ms, each round | 27,246, 27,248, 27,288 | 26,065, 26,131, 26,072 | −1,176 (−4.3%) |
| The whole build (`logs/build-*.log`), s | 32.7 | 31.6 | −1.1 |
| The backend's unit in the build, s | 28.9 | 29.0 | +0.1 |
| `-c sqlite3.c`: task-clock, ms, the median round | 127.38 | 127.69 | +0.24% |
| user cycles, the median round | 603,510,727 | 604,289,268 | +0.13% |
| user instructions, each round | 1,315,267,110 to 1,315,267,112 | 1,315,096,914 to 1,315,096,931 | −170,196 (−0.013%) |

The changes are the medians'. The two trees wrote the same `sqlite3.o` (`logs/pair-object-cmp.log` is `cmp`'s empty
output). The first record found the encoder templates' new linkage costs nothing measurable over placements; this
record has one placement of each tree.

## Limitations

One placement of each tree, three rounds; the build times are one build of each. The host receipts were captured
after the runs.
