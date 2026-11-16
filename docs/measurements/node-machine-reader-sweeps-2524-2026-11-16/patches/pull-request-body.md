Part of #2524, under [the claim for C and X where they sit](https://github.com/buster14a/buster/issues/2524#issuecomment-6904114428).

## What this does

#2867 ran the node machine's first sweep, T, where step 2 would run it: at reader time, in the shadow. This runs the other two there.

- **`measure-node-machine --shadow --front-sweeps`** (`c_check_node_machine_reader.c`): after T types a full expression at reader time and takes it, C and X run on the same records, before the unit's program exists.
- **The comparison is after the pipeline.** The shadow's own C and X run on the same expression. Reader time's tape must be theirs entry for entry once its globals' entries are patched with the program's symbols, with the same labels, calls and temporaries, the same refusal, and the root's conversion's target and object the lowering's pop's. A difference fails the command.
- **What C and X read of the program was one thing: an object's symbol.**

| what C and X read | after the pipeline | at reader time |
| --- | --- | --- |
| whether an object is a local or a global | whether it has a symbol, the selection's numbering | whether it has a static declaration, or is a string's |
| a global's symbol, in its entries and in a direct call's row | the selection's | the object itself, which a splice patches |
| a declaration's bits (register, compound, static) | the program's input's | the reader's input's, the same column |
| the root's context, its conversion's target, its object | the lowering's pop's | none, but an initialization's: its object's type without its qualifiers where the conversion writes entries, and the object |

It is the shadow only: no compile takes it.

## What it touches outside the reader-time file

- **`c_check_node_machine.c`:** the machine holds the objects' columns itself (`object_symbols`, `declaration_bits`, `object_count`), the program's after the pipeline. `node_machine_local`, `node_machine_address_takes`, `node_machine_symbolled` and `node_machine_call_target` read them; T's test of where a callee's symbol comes from is gone.
- **`c_check_node_machine_contexts.c`, `_expand.c`, `_lower.c`:** the nine reads of the program become reads of those columns. No rule changes.
- **The front's results** (`NodeFrontTypes`): C's and X's refusal, the root's target and object, and each taken expression's tape, kept for the comparison.
- **The census:** the option, the comparison (`node_shadow_swept`) and its report.

## Results on the 9700X

Release builds, CPU 2, under the lock, a hold a run; main `be6515fba` with #2867's branch (`u3`) against the same with this commit (`w2`). Medians of seven readings in turn, musl's of three; TSC ticks a record T typed, with the whole front before T.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions C and X ran on at reader time (those T took) | 55,063 | 12,568 | 49,115 |
| of them taken; refused for a template or a row | 50,393; 4,670 | 10,387; 2,181 | 41,209; 7,906 |
| compared with the shadow's C and X: expressions, entries, differences | 50,555, 331,155, 0 | 10,544, 65,963, 0 | 22,324, 133,898, 0 |
| patched in them: globals' entries, direct calls | 2,199, 12,555 | 668, 3,845 | 2,396, 4,871 |
| T alone at reader time | 69.1 | 85.6 | 138.7 |
| T, C and X at reader time | 127.7 | 139.9 | 235.9 |
| C and X in place (the difference) | 58.7 | 54.4 | 97.2 |
| C and X in the tight loop, its first pass | 44.0 | 39.8 | 42.8 |
| the three in the tight loop, its first pass | 106.9 | 99.8 | 104.5 |

- **Exact.** No expression differs in its root, its refusal, its tape, its labels or its calls, in any of 34 readings, whole front and lean.
- **A splice patches little:** 2,199 entries of 331,155 on `sqlite3.c`, and a quarter of a call an expression. Everything else on a tape was the expression's own already.
- **Where they sit, the three cost what a body's expressions a run cost.** On `sqlite3.c` they are 1.19 times their tight loop's first pass, about 212 cycles a node, where the design has 216.5 for the three sweeps with a body's expressions a run. C and X pay a third over their tight loop there and T a tenth.
- **Step 2's sum stands at 1.25 on `sqlite3.c`.** It took T and the one sweep at that position's figure.
- **Sparse expressions cost C and X as they cost T:** 1.40 times the tight loop's first pass on Lua for the three and 2.26 times on musl.
- **Two things the first run lacked,** both found by the comparison: a string's object is static without a declaration (1,054 of `sqlite3.c`'s tapes), and an initializer converts to its object's type without the qualifiers (14 roots).

### The machine's own sweeps, a compile, and #2850's kernels

- **A compile is unchanged.** `-c sqlite3.c` as whole processes from fresh copies: -0.47% (-0.55% to -0.29%) and -0.15% (-0.62% to +0.15%), with the same 1,363.464 M instructions.
- **The shadow's own sweeps retire fewer instructions and read 1.3% more cycles as built.** A taken node of `sqlite3.c` after the pipeline: 598.30 instructions become 597.76 (T's test of where a callee's symbol comes from is gone), and 173.3 cycles become 175.5. Lua: 145.0 and 147.4. musl: 192.6 and 192.9.
- **That is inside what the stack alone moves them.** The machine's structure is a local of the census's function, and the sweeps' frames are below it at a distance the build fixes. With that distance moved at run time over 32 places a page wide, the baseline's three sweeps read from 172.8 to 182.4 cycles a node (5.6%) and this build's from 174.5 to 189.1 (8.4%). At their best places the two are 1.0% apart, all of it X's, whose functions the Release build's parts now place beside T's. Store-to-load interference in the machine's functions is 44% up as built; its mispredicted branches and cache misses are within 2%.
- **#2850's kernels do the same work, and one loop moved.** Their instructions are within 0.05 a taken leaf or lookup on 21 rows, and every record is T's in 210 runs. Fifteen rows read within 1.5% or faster (to -4.8%). The lean leaves' loop with a body a window reads 8.9% slower on Lua's two rows and 3.0% and 4.3% on musl's, and faster on `sqlite3.c` (a leaf 7.19 to 5.44 cycles). Its code is 0x3260 bytes further on, the other half of its line, and on Lua it misses the op cache 15 times as often (0.3 M to 4.7 M over 160 passes). Nothing in that kernel is changed.

The record's sections 3 and 4 have these runs.

## Tests

- `test-checker --seed 133` in its eight parts: 842,449 checks, 0 failures on the native host; the census's part on a `BUSTER_HOST_ARCH=x86-64` build: 210,256 checks, 0 failures (the front does not run there and nothing is swept).
- The fixture runs C and X at reader time in its `--scalar` and `-funsigned-char` runs and in a fourth run without warnings, and the chunk-boundary text in its lean run. New fixture lines: a `const` object's initializer, one that converts nothing, one whose conversion is empty, a static local, a global's updates, and a `for` statement.
- 13 single faults in the reader-time path, one build each: the tests show all 13. Two needed a fixture line first, which the record explains.
- `--front-sweeps` with the whole front and the lean one on `sqlite3.c`, Lua and musl: no difference.

## Docs

`docs/node-machine.md` has a new section, "C and X where they sit", and one sentence of "What it says of step 2". `docs/commands/lowering.md` has the option, its comparison, its report and its tests.

## Record

[buster-performance, `docs/measurements/node-machine-reader-sweeps-2524-2026-11-16`](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/node-machine-reader-sweeps-2524-2026-11-16): the runs, scripts, patches of each build, the faults and the tables.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01NNmNQtUTU2NzKNtCgdUaJP

---
Agent session: [private session](https://claude.ai/code/session_01NNmNQtUTU2NzKNtCgdUaJP)
Model: Anthropic / claude-fable-5-2
