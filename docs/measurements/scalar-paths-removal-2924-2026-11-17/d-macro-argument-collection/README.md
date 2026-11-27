# Collect macro arguments across preprocessing contexts

The baseline collects tokens one at a time when an invocation crosses a context or directive boundary, goes beyond the bounded fast scan, or drops comments under `-C`. The corpus census counts nonempty visits in the actual collector. The four columns give visits and tokens in parentheses. [Compiler baseline](https://github.com/buster14a/buster/tree/0a2c3034cf6093cda0f461e519ceb04484739259) · [Issue #3438](https://github.com/buster14a/buster/issues/3438)

| Input | File macro | File builtin | Buffer macro | Buffer builtin |
| --- | ---: | ---: | ---: | ---: |
| sqlite | 0 (0) | 0 (0) | 0 (0) | 77 (181) |
| lua | 6 (81) | 0 (0) | 8 (135) | 2662 (6427) |
| musl | 2 (9) | 0 (0) | 2209 (26138) | 0 (0) |
| normal | 7 (205) | 0 (0) | 0 (0) | 0 (0) |
| comments | 9 (494) | 0 (0) | 0 (0) | 0 (0) |


The first candidate copies an uninterrupted argument prefix up to 64 tokens at a time. The second uses prefix depths to include nested parentheses and commas in the same copy, and compresses the retained file tokens in comment mode. The final prototype also invalidates the stack index through the normal reservation operation and honors token buffers without origin storage. The fixtures expand 64 calls across embedded directives at each of 75 body lengths from zero through 257. Each measurement compares median whole-preprocessor user cycles from five runs under the 9700X lock. Every measured source produced identical stdout and an empty diagnostic stream on both builds.

| Candidate | Shape | Sizes at or below baseline | Median ratio across sizes | Worst ratio |
| --- | --- | ---: | ---: | ---: |
| arg-runs | ordinary | 63/75 | 0.932 | 1.042 |
| arg-runs | macros | 62/75 | 0.945 | 1.085 |
| arg-runs | nested | 0/75 | 1.082 | 1.184 |
| arg-runs | comments | 0/75 | 1.098 | 1.268 |
| arg-balanced | ordinary | 60/75 | 0.946 | 1.065 |
| arg-balanced | macros | 60/75 | 0.948 | 1.116 |
| arg-balanced | nested | 43/75 | 0.943 | 2.002 |
| arg-balanced | comments | 33/75 | 1.010 | 1.120 |
| arg-final | ordinary | 59/75 | 0.951 | 1.073 |
| arg-final | macros | 58/75 | 0.951 | 1.106 |
| arg-final | nested | 56/75 | 0.952 | 1.113 |
| arg-final | comments | 28/75 | 1.015 | 1.146 |

The following whole-corpus changes are medians over five rounds of five runs each. Each candidate and baseline pair used the same driver flags and passed full stdout digest and stderr comparisons.

- arg-runs, sqlite, +1.128% user cycles.
- arg-runs, lua, +1.139% user cycles.
- arg-runs, musl, +0.044% user cycles.
- arg-balanced, sqlite, +0.715% user cycles.
- arg-balanced, lua, +1.210% user cycles.
- arg-balanced, musl, +0.209% user cycles.
- arg-final, sqlite, +0.545% user cycles.
- arg-final, lua, +1.345% user cycles.
- arg-final, musl, +0.544% user cycles.

The per-size results retain the scalar route on main. The archive contains compiler patches, census rows, input and timing drivers, raw per-size timings and output digests. [Reproduction and results](argument-scans.tar.xz)
