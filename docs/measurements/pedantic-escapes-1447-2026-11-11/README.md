# -pedantic's escape warnings of evaluated literals, Buster #1447 (2026-11-11)

Base-vs-head `-fsyntax-only` timings on the Ryzen 7 9700X (`benchpress`) for the PR that gives an evaluated literal's
`-pedantic` escape warnings (package C8 of #1447, branch `c8/1447-pedantic-escapes`). The change adds a scan of the
literals the reader's fast decoding takes, run only where the command line may give the warning or the unit has a
`#pragma clang diagnostic` (`check_input_gnu_escapes`); this measures that gate on the hot path.

## Sources and binaries

| Name | Source | Built | `compiler` SHA-256 |
|---|---|---|---|
| base | main `66e05fbfb` | on benchpress, `./build.sh` (Release, native) | `56235c6a…3537` |
| head | `c8/1447-pedantic-escapes` `faf556743` | same | `12c8b247…64dd` |

Input: `sqlite3.c` (SHA-256 `b1dd5d74ec7f29055a6684fa06fb3c2f6821c87dd38f9a458dfd2e8a1db28189`, the frozen
amalgamation of `refine-claude/inputs`) and Buster's own `src/buster/compiler/main.c` at head, with
`-march=native -fwrapv -funsigned-char -fno-strict-aliasing`, each without and with `-pedantic`.

Host: clang 23.1.1, kernel 6.18.50-2-lts, CPU 2 (`taskset -c 2`), governor `performance`. One `time-runs` invocation
(21 runs, 2 warm-ups, Williams design) under the 9700X lock (`exclusive.sh`); `measure.sh` is the exact script and
`measure.log` its whole output.

## Results (medians, head against base)

| Input | Options | Wall | User cycles | Instructions |
|---|---|---|---|---|
| sqlite3.c | | 97.479 ms, +0.10% | 453.272 M, −0.01% | +0.02% |
| sqlite3.c | `-pedantic` | 97.302 ms, −0.46% | 454.554 M, −0.02% | +0.03% |
| main.c | | 586.843 ms, +0.12% | 2935.352 M, +0.12% | +0.22% |
| main.c | `-pedantic` | 586.399 ms, +0.03% | 2932.621 M, +0.09% | +0.22% |

Within the runs' spread on both inputs (main.c's wall range is 583.7–591.4 ms at base and 584.7–594.5 ms at head).
main.c's headers hold diagnostic pragmas, so its literals are scanned in both lists.
