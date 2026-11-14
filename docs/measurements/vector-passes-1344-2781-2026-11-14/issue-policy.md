**LICM and value numbering applied only to vector and mask values take the vector lexer from 10.31 to 5.38 cycles/B (the unrestricted passes: 5.75) and leave `sqlite3.c`'s and Lua's objects byte-identical. `--tier1` runs neither today.**

Part of #1344 and #138; the vector half of #2719's policy. Found by #1344's census ([second](https://github.com/buster14a/buster/issues/1344#issuecomment-6884605885) and [third](https://github.com/buster14a/buster/issues/1344#issuecomment-6884688286) findings), with a prototype on [`droid/vector-passes-1344`](https://github.com/buster14a/buster/tree/droid/vector-passes-1344) (`24c4f2abb`).

## Evidence

`c_tokenize` of the compiler's own lexer on `mid200.c` (9,076 bytes), main `45cd9aec`, the owner's desktop (Zen 4, `-march=native`), nine interleaved rounds on one CPU of a `cores` grant. **Desktop numbers; the 9700X run is in progress and will be posted here.**

| Build | cycles/B (median) | instructions in the call | spill stores / loads | edge moves | hoisted / removed |
| --- | ---: | ---: | ---: | ---: | ---: |
| clang -O2 | 1.19 | 27,848 | | | |
| `--tier1` | 10.31 | 112,636 | 2,870 / 3,895 | 8,346 | 0 / 0 |
| `--tier1-passes=+licm,+gvn` | 5.75 | 94,957 | 8,203 / 9,275 | 18,848 | 1,886 / 57,071 |
| the same, vector and mask values only | **5.38** | 92,562 | 4,946 / 5,951 | 11,315 | 31 / 4,172 |

- **Why it is not #2719's regression:** what is worth sharing in vector code is a few long-lived constants (byte-class tables, splats, shuffle controls), each rebuilt at every use today as 8 to 16 immediate stores below `rsp` and a 64-byte load no store forwards to (#2744). 31 hoists and 4,172 merges remove them from the loops. The other 1,855 hoists and 52,899 merges of the unrestricted passes are scalar values, which is where #2719 measured the spills.
- **Scalar code is untouched:** under the restricted policy `sqlite3.c`'s Tier 1 object is byte-identical to the default's (sha256 `bd45910733866df0`) and so are all 33 of Lua's.
- **Value numbering is the cleaner half:** alone it gives 6.62 cycles/B with the spills near the default's (3,174 / 4,274). LICM alone hoists 90 values and adds 9,606 spill stores; after value numbering 31 hoists suffice.

## Design

1. **The gate.** A function with no vector or mask value (`ir_function_has_simd_path`, one compare over the type and operation columns) runs neither pass and reserves neither pass's arena: scalar units pay the scan alone. The prototype has no gate, and pays +80% on `-c sqlite3.c` for analyses whose results it drops.
2. **Value numbering.** The congruences are computed as today (a vector value's class may depend on its scalar operands' classes), and a congruence is applied only to a value of vector or mask type (`IR_V4I32` to `IR_M64`). The scalar operands a merged value leaves without users die in the optimizer. Next step, for compile time: number only the expressions that reach a vector value.
3. **LICM.** Of a loop's available candidates, those of vector or mask type move, with the in-loop candidates their operands need, transitively (a splat's scalar, a constant). Nothing else moves.
4. **Options.** A `vectors` item in `--tier1-passes=`, on by default, with `-vectors` to turn it off; `+licm` and `+gvn` keep meaning the unrestricted passes. `--tier1-report` counts the policy's hoists and merges apart from theirs.
5. **Twins and tests.** Both passes keep their scalar twins; the restriction is a filter over their results, the same in both paths. `test-ir-gvn` and `test-ir-licm` get cases with the filter on: a vector value merged and a scalar one beside it kept, a hoisted splat taking its scalar operand, a scalar candidate left in its loop. #142's campaigns run with it on.
6. **What it does not fix.** With the policy the call still executes 8,125 vector loads from the stack and 6,394 stores to it (clang: 392 and 366): the hoisted constants do not fit in xmm0 to xmm14. That is the next issue (zmm16 to zmm31 as value registers). The constants that stay inside a block or outside a loop are #2744's.

## Done when

- `--tier1` runs the policy by default, and the 9700X's `measure-tier1-rows --lexer` shows the lexer's `c_tokenize` cycles/B against the base's; `scan` and `rows` do not regress.
- `sqlite3.c`'s and Lua's `--tier1` objects are byte-identical with and without it, and `-c sqlite3.c`'s compile cycles are within noise of the base's on the 9700X.
- The compile cost on the lexer's unit is measured and recorded.
- Twins agree on the corpora and #142's campaigns pass with it on.

---
Agent session: b0df91f8-5327-4de1-a613-db1be1f3c3fb (Factory Droid session ID; no share URL is exposed)
Model: Fable 5.2 (as reported by Factory Droid, which names no provider)
