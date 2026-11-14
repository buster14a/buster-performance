## Third findings: scalar units' objects are byte-identical under the restricted passes; the prototype is pushed

Prototype: branch [`droid/vector-passes-1344`](https://github.com/buster14a/buster/tree/droid/vector-passes-1344), commit `24c4f2abb` on main `45cd9aec` (`BUSTER_PROTO_VECTORS=1` with `--tier1-passes=+licm,+gvn`; a measurement prototype, not for merge as is).

| Unit (`--tier1 -fno-asynchronous-unwind-tables`, #136's flags) | default | restricted `+licm,+gvn` | unrestricted `+licm,+gvn` |
| --- | --- | --- | --- |
| `sqlite3.c`, object sha256 | `bd45910733866df0` | `bd45910733866df0` (identical) | `771344abcdcff431` |
| `sqlite3.c`, records | 387,075 | 387,075 | 439,716 |
| `sqlite3.c`, spill stores / loads | 12,487 / 13,741 | 12,487 / 13,741 | 19,724 / 20,461 |
| `sqlite3.c`, edge moves | 34,984 | 34,984 | 65,326 |
| Lua 5.4.8's 33 sources, objects | | 33 of 33 identical | |

So the restricted policy changes no code that has no vector or mask value: #2719's speedtest1 and Lua regressions cannot come from it.

**Its compile cost is the open part.** The prototype runs both analyses in full and then drops what it does not want, so it pays for them everywhere (`--lanes 1`, user cycles, the desktop):

| Unit | default | restricted (prototype) | unrestricted |
| --- | ---: | ---: | ---: |
| `-c sqlite3.c` | 3.87 G | 6.96 G (+80%) | 7.22 G (+87%) |
| Lua's 33 sources | 1.26 G | 1.82 G (+44%) | |
| the lexer's unit | 1.13 G | 1.64 G (+45%) | 1.65 G |

A function with no vector or mask value needs neither pass: `ir_function_has_simd_path` is one compare over the type and operation columns, and with it as the gate `sqlite3.c` and Lua pay that scan and nothing else. What is left is the cost in the functions that have vectors (the lexer's +45%), where numbering only the vector expressions is the next step.

(`gvn_removed` in `--tier1-report` is the instructions the pass's output lacks, dead ones it drops included: it reads 2,523 for `sqlite3.c` under the restricted policy with an identical object.)

---
Agent session: b0df91f8-5327-4de1-a613-db1be1f3c3fb (Factory Droid session ID; no share URL is exposed)
Model: Fable 5.2 (as reported by Factory Droid, which names no provider)
