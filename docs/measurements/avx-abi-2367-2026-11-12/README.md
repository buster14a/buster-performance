# Clang's AVX calling-convention diagnostics: the cost to ordinary units on the 9700X, Buster #2367

Compiler pull request: [#2494](https://github.com/buster14a/buster/pull/2494), for
[#2367](https://github.com/buster14a/buster/issues/2367). At `-c`, the target-feature pass now also gives clang's
AVX calling-convention diagnostics. The change reaches every unit's `-c` path at three places:
- a scan of the type table for a vector wider than 128 bits (`check_target_feature_abi_unit`);
- in a unit that has one, the selection's emission order (`body_eager`);
- in such a unit, where some function may lack AVX-512F, a test of each body's referenced functions' types.

`main.c` with `-march=native` has wide vectors and target attributes, so it takes the last two. Its functions all
have AVX-512F, so no body is walked for this check. sqlite3.c has no vectors.

## Sources and host

Each tree is a clone of buster14a/buster at its commit, built on the 9700X by `BUSTER_HOST_ARCH=znver5
./build.sh` under the host lock (`scripts/setup.sh`, `scripts/build.sh`, `scripts/all.sh`):

- **base:** `b935fa309c44b49c78ea3acd3e820735acb8b936` (main, #2494's base);
- **head:** `10fdf2d46a83253f984a7cbf7b149253fe45c5a2` (#2494's first head).

`logs/receipt.txt` has the host, the toolchain, both executables' SHA-256 and the inputs' SHA-256.

## Method

`scripts/run.sh` makes one `time-runs --runs 21 --warmups 3` comparison of both builds. The runs go in a
Williams design's order, under one hold of the host lock, pinned to CPU 2. The four lists are `-fsyntax-only` and
`-c -o /dev/null` of SQLite's amalgamation (lists 1 and 2), then the same two of Buster's own `main.c` with
clang's `-march=native` predefines (lists 3 and 4). `logs/run.log` is the whole output.

## Result

| list | wall (median of 21) | user cycles | instructions |
|---|---|---|---|
| `-fsyntax-only` sqlite3.c | 100.374 → 100.694 ms (+0.32%) | 473.909 → 474.237 M (+0.07%) | 1,040,654,223 → 1,040,653,964 (−0.000%) |
| `-c` sqlite3.c | 123.402 → 124.001 ms (+0.49%) | 588.013 → 589.771 M (+0.30%) | 1,324,821,420 → 1,324,779,110 (−0.003%) |
| `-fsyntax-only` main.c | 605.467 → 605.219 ms (−0.04%) | 3035.384 → 3035.120 M (−0.01%) | 9,133,492,551 → 9,133,582,634 (+0.001%) |
| `-c` main.c | 680.455 → 680.392 ms (−0.01%) | 3441.524 → 3440.647 M (−0.03%) | 10,454,965,154 → 10,455,948,831 (+0.009%) |

The two builds do the same work, within single-build placement noise. Instructions differ by at most 0.009%, and
cycles by at most 0.30%.

## Limitations

- Each tree was built once, so code placement isn't controlled.
- Neither input gets a diagnostic. The walk of a unit compiled without AVX-512F that calls wide-vector functions
  isn't measured; that is a rare unit, and clang does the same work there.
