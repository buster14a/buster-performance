# Real compilation of the generated programs and historical probes

Ordinary compilation and `--node-window` produced identical exit codes, stdout and stderr for all 90,000 generated programs. Of these, 73,203 compiled and 16,797 received diagnostics that stopped compilation. No process terminated by signal. In separate counter runs, at least 272 of the successfully compiled programs took the new path. These counter runs were limited to successful files whose generated statement contained a numeric or character return candidate.

All 8,009 historical probes compiled successfully to byte-identical objects in both modes, with matching stdout and stderr. The 26 per-suite results and each generator seed's SHA-256 over its source texts in order are in [results.log](results.log).

The compiler was the Develop build of Buster commit `55700f5a4ca30d139fd406bb36dc3ee38adf7ffd`. Its production source is the same as `84a7d3d76891d6c393497e62e6aff38f2b162fc2`. The subsequent commit classified the four new checker fields in the attested tests. The corpus came from buster-performance checkout `82d34745b301a699ac0d2161035d6e1fae5e6a6d`.

## Reproduce

From the buster-performance checkout, point the command at a built compiler and the script in this directory. The last argument is a scratch directory. The driver uses two worker processes.

```sh
python3 path/to/compare.py /path/to/buster/build/compiler \
    docs/measurements/summary-facts-2850-2026-11-21/fuzz/fuzz.py \
    /path/to/scratch > results.log
```

The driver preserves the generator's statement draws, seeding, multi-statement and padding modes, floating-environment pragma, loose type choices, and the `-Wall -Wextra` flags from the historical six-seed campaign. Each generated program goes through `-fsyntax-only` twice. Each historical probe uses its own suite flags with `-c`. The driver compares the object bytes and preserves the inputs, object files and output of any differing probe in the scratch directory.
