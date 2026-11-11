# -Wunicode's warnings of a `\u` clang reads as no UCN, Buster #1447 (2026-11-11)

Base-vs-head `-fsyntax-only` timings on the Ryzen 7 9700X (`benchpress`) for the PR that widens the preprocessor's
named-UCN candidate scan to `\u` and `\U` (package C8 of #1447, branch `c8/1447-wunicode-u`). A first head, which read
every block between a file's first and last candidate again, cost sqlite3.c +0.37% instructions (its `\u`s in string
literals are far apart); the measured head keeps the first 256 candidates' places, which the record pass reads alone.

## Sources and binaries

| Name | Source | Built | `compiler` SHA-256 |
|---|---|---|---|
| base | main `66e05fbfb` | on benchpress, `./build.sh` (Release, native) | `56235c6a…3537` |
| head | `c8/1447-wunicode-u` `cf280c039` | same | `655bf6c2…` (full hash in `measure.log`) |

Input: `sqlite3.c` (SHA-256 `b1dd5d74ec7f29055a6684fa06fb3c2f6821c87dd38f9a458dfd2e8a1db28189`, `refine-claude/inputs`)
and Buster's `src/buster/compiler/main.c`, `-march=native -fwrapv -funsigned-char -fno-strict-aliasing`, each without
and with `-pedantic`. Host: clang 23.1.1, kernel 6.18.50-2-lts, `taskset -c 2`, governor `performance`; one
`time-runs` invocation (21 runs, 2 warm-ups) under the 9700X lock. `measure.sh` is the exact script, `measure.log` its
output.

## Results (medians, head against base)

| Input | Options | Wall | User cycles | Instructions |
|---|---|---|---|---|
| sqlite3.c | | 97.336 ms, −0.17% | 453.586 M, −0.09% | 996.929 M vs 996.916 M |
| sqlite3.c | `-pedantic` | 97.816 ms, −0.64% | 453.668 M, −0.14% | 996.943 M vs 996.931 M |
| main.c | | 588.632 ms, +0.35% | 2944.079 M, +0.19% | 8838.145 M vs 8838.269 M |
| main.c | `-pedantic` | 587.695 ms, −0.05% | 2943.052 M, +0.10% | 8838.176 M vs 8838.287 M |

Instructions are the same within 0.002%; time and cycles are within the runs' spread.
