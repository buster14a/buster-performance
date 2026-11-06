# Target-feature no-attribute preprocessing controls (#891)

These diagnostic controls follow the [earlier SQLite comparison](../target-feature-891-2026-11-05/README.md) for [buster PR #1313](https://github.com/buster14a/buster/pull/1313). They use the same verified base and head compiler binaries, copied to one executable path in turn. They do not qualify the PR or establish the literal zero instruction delta required by the issue.

On the Ryzen 7 9700X, with CPU 2 pinned, each compiler ran preprocessing on the same input under a separate shared-host lock grant. Each row is one base/head pair, with `perf stat -e instructions:u`; every event ran for 100% of its interval. Each output pair had matching SHA-256 hashes. Raw receipts, hashes, and scripts are in [raw](raw/).

| Input and command | Base instructions | Head instructions | Head minus base |
| --- | ---: | ---: | ---: |
| Empty C source, `-E` | 845,059 | 842,796 | −2,263 |
| 1,000 generated declarations, `-E` | 1,444,532 | 1,442,250 | −2,282 |
| 10,000 generated declarations, `-E` | 6,823,365 | 6,821,088 | −2,277 |
| Previously preprocessed SQLite, `-E -x c` | 95,120,697 | 95,117,925 | −2,772 |

The previous same-path original-SQLite `-E` pair had a **+12,343** head-minus-base difference. The sign and size differ on these other inputs, which is inconsistent with a fixed positive startup offset as the sole explanation, subject to single-pair variation. The inputs, options, and processing paths differ, and each row is a single pair; these observations do not locate the cause, distinguish source changes from binary layout, or establish the whole-compile instruction difference. The preprocessed SQLite control uses the earlier saved `sqlite.i`, not the original source and include expansion, so it is not a direct replacement for the requested SQLite `-c` comparison.

## Identities and method

- Base `441db2428d2bd8d28503037b28c1b3740fe4b25a`, binary SHA-256 `265f2c48fa5923413eb206d87adff2d7c208a05c076d79f90fede01fa293c0dc`; head `5929d0e2e2ab5a179313c082811b59a3ccdd0e0d`, binary SHA-256 `0ac7499a4a607d0a74d43b9c4734089877a2d81f72831dcd14c32c340f460fea`. Both are the exact binaries identified in the earlier report.
- Build: Clang 23.1.1, Release O3, `BUSTER_HOST_ARCH=znver5`, `BUSTER_DEBUG_INFO=0`; `/usr/bin/clang-23` SHA-256 `939a882527432ec23b094c289e7f170bf2d6ec282e74dde75e31b08602fa3eae`.
- Linux `6.18.50-2-lts`, Ryzen 7 9700X, CPU 2 governor `performance`; command and lock protocol appear in [probe.sh](raw/probe.sh) and [probe-sqlitei.sh](raw/probe-sqlitei.sh).
- The generated input is `int probe_N;` for N from zero to one less than the row's declaration count, each followed by a newline. The preprocessed SQLite input SHA-256 is `4128ed06980ed08d97638c123d840ce2569b133404a674f4da59ca61e367b59b`. All inputs and outputs are identified in [identities](raw/identities) and [outputs](raw/outputs).
- For each input the base was measured first and the head second. The scripts copy the selected binary to the same path before each separately locked run and retain output hashes. Copying occurs outside the measured process. No instruction or performance result is generalized beyond these builds and inputs.
