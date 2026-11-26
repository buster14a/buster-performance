# SQLite and Lua runtime with memory value numbering

[PR 3622](https://github.com/buster14a/buster/pull/3622) at `e5cff9f6` was built as Release for `znver5` with official Clang 23.1.4. The repository's `measure-tier1-programs` compared the default Tier 1 pipeline, an explicit `+vectors` control and `+memory`, all using that compiler. It verified frozen speedtest1 and all five Lua 5.4.8 outputs across builds, then ran nine rounds on CPU 2 under the shared Benchpress lock.

| Workload | Default Tier 1, user cycles M | Explicit +vectors, user cycles M | +memory, user cycles M |
| --- | ---: | ---: | ---: |
| SQLite speedtest1 | 726.3 | 722.6 (−0.51%) | 716.2 (−1.39%) |
| Lua, sum of five script medians | 977.5 | 974.1 (−0.36%) | 963.6 (−1.43%) |

With `+memory`, retired instructions rose 1.08% for speedtest1 and 1.84% for Lua. The benchmark also records compile cost. With the memory pass enabled, speedtest1 compilation used 3.65% more user cycles and Lua compilation used 2.58% more. The results cover the harness's link layouts. A layout sweep is needed to establish placement-independent gains.

The runtime and compile tables, verification results, and all individual runs are in `results.txt`. The linked executable hashes and workload identities are retained with the raw output.

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
