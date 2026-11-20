# Sparse call-site discovery and batched inliner copying

[PR #3126](https://github.com/buster14a/buster/pull/3126) stacks on [#3119](https://github.com/buster14a/buster/pull/3119). The two opening passes inspect 64 IR opcode bytes at once and consult direct call descriptors only on selected lanes. During rewriting, the already recorded source node of the next expanded call bounds a whole run of ordinary instructions.

| Compile workload | Parent retired instructions | Candidate retired instructions | Median paired change |
| --- | ---: | ---: | ---: |
| SQLite 3.53.2 Tier 1 | 7,798,094,888.5 | 7,763,999,728.5 | −0.437% |
| Lua 5.4.8 parser | 150,376,342.5 | 149,723,622.5 | −0.434% |
| Lua 5.4.8 VM | 301,342,670.5 | 300,550,014 | −0.263% |
| SQLite Tier 0 control | 1,174,793,909 | 1,174,794,717.5 | +0.000% |

Eight alternating pairs ran locally on a Ryzen 9 7940HS with one compilation lane. SQLite’s paired cycle changes ranged from −1.12% to +1.78%, with a median of −0.019%. The intermediate version using the recorded nodes only during rewriting saved 0.123% of SQLite’s instructions. Locked Ryzen 7 9700X measurements are pending.

All 1,336 frozen musl object pairs were byte-identical, as were 70 Lua and SQLite objects built at two optimization levels with debug information and both linked Lua executables. Each Lua executable ran five workloads against Clang’s outputs. The inlining suite passed 125,214 checks and 22,432 independent executions, the pipeline passed 4,223 checks and debug/GDB passed 4,009 checks. The focused regression exercises shared call descriptors, direct, indirect and embedded calls, positions 63, 64, 127 and 128 and the next caller’s first selected call.

Run `python local-compiler-pair.py normal PARENT HEAD RESULTS sites --inputs INPUT_ROOT` with `inputs/sqlite3.c` and `inputs/lua/` below INPUT_ROOT. The raw acquisition and output hashes are in this directory. The two native compiler hashes identify the stripped binaries staged for the shared host.
