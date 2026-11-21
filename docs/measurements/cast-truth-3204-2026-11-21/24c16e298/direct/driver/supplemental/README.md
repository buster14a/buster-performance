# Cast return-flow oracle

The 7,636 generated C functions compare the three outcomes of Clang's return-flow diagnostic. Each function either returns on every reachable path, returns on some paths, or has no reachable value-returning path. The matrix runs once with ordinary floating-point evaluation and once with `#pragma STDC FENV_ACCESS ON`. It includes nested scalar and complex casts, logical operands, 129- and 257-bit integer conversions, addresses, and builtin queries.

Against Clang, the baseline disagreed on 1,569 functions. The candidate disagreed on 899. The candidate corrected 670 outcomes and introduced zero differences in this sample. The 899 existing differences include strict floating-point evaluation and builtin-query reachability. The implementation preserves prior numeric conversion behavior.

| Tool | Revision | Local executable SHA-256 |
| --- | --- | --- |
| Buster baseline, Develop | `0647d69ba8af4e466c89df2519dea0b382524d37` | `2a0ba1c410c36c3d6c027e347a9201e44a1da57b7f7571028b99cb4bd407879a` |
| Buster candidate, Develop | `24c16e298bc7a5235711ff566fe652402d32173b` | `384265e06daa79b3cb7b74de19a5ebfc1b7bd233c4cfd7198c35e843b74c2818` |
| Clang 23.1.4 | `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5` | `c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67` |

Run from the directory containing the script, substituting paths to the three executables.

```sh
python3 cast-return-flow.py --clang /path/to/clang --baseline /path/to/baseline/compiler --candidate /path/to/candidate/compiler
```

The test exits with a failure if a newly different outcome appears. Per-matrix counts appear in `results.tsv`.
