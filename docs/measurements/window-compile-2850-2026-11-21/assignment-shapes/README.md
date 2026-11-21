# Assignment shapes in the independent checker window

The frozen SQLite translation unit contains 11,006 discarded plain assignments whose complete subtrees the pregraph type kernel accepts with pointer support and floating types excluded. These subtrees contain 65,852 records. Every record's 96-byte reconstructed checked value matches the ordinary stream, including integer payloads below a cleared constant kind. The independent comparison also found equal operand conversions and member bit offsets and no ordinary stream warning bits on those records. The existing program supplied ordinary values only after the pregraph kernel had saved its records. Whole-driver warning comparisons appear below.

| Selected subtree | Roots | Records |
| --- | ---: | ---: |
| Discarded plain assignment in the integer-only kernel | 2,460 | 11,222 |
| Discarded plain assignment including pointer/member operators | 11,006 | 65,852 |
| Other compound assignment, increment or decrement in that wider kernel | 2,721 | 11,771 |
| Simple destinations and sources, plain local int from int literal or local int | 1,491 | 5,964 |
| Plain local int from a binary operator on two int literals or locals | 101 | 606 |
| Field directly selected through a local pointer, with a simple value or another field on the right | 2,457 | 12,626 |
| Integer field directly selected through a local pointer, with an int literal on the right | 1,013 | 5,065 |

The largest direct field/literal group has 659 target integers of types other than int and unsigned int. The other two groups have 252 int fields and 102 unsigned int fields. The 1,013 candidate roots include 405 unsigned char fields, 97 unsigned short fields and two qualified unsigned int fields. Each has consecutive source tokens. The 1,491 simple local assignments include 614 immediately under a closing for header, 90 under a closing condition, 780 in ordinary blocks or function bodies and seven under other roles. The broad scan also found 1,288 postfix increments across all destinations.

## Actual compiler comparisons

Both private commits are independent children of Buster `0d84c3cdb8b3146c03c874ac2c553279c4d1eed2`. Every count below is from a separate production compile via the explicit assignment option. Each experimental build preserves the 2,214 generic return windows.

| Explicit assignment option | Taken | Ordinary nodes replaced | Remaining graph nodes | Added vs parent |
| --- | ---: | ---: | ---: | ---: |
| Parent `0d84c3cdb` | 2,977 | 7,534 | 319,066 | 0 |
| Integer-literal stores into members, `0a01ce366` | 3,858 | 11,939 | 315,542 | 881 |
| First expression of a for loop, `a62702e32` | 3,587 | 9,974 | 317,236 | 610 |

The member implementation uses the existing T member-selection, assignment-conversion and discard operators. It requires an ordinary local pointer, a complete unqualified structure, a non-bit-field builtin integer member and a representable nonnegative int literal. Its typed tape reads the pointer and adds the member offset when nonzero, emits the converted constant, stores through the address and discards the result. First-for-semicolon admission checks the matching for opener and its literal or local assignment against the existing postorder mask and reuses the three-entry store implementation.

Direct captures in the Develop binaries matched every admitted 96-byte checked value to the ordinary root at its source token. Each experiment yielded the ordinary kinds, classes, 64-bit operands and parser source tokens for all 381,191 native entries in 2,668 functions. The common SHA-256 of the per-function digest file is `1ba79e2802a0d1b1d4d7cecd5e60dd429ea3e22f0d8a875a9707375a0f3d554d`. Both experiments produced identical SQLite objects with and without their option, with equal status and diagnostic bytes under `-Wall -Wextra`, `-Weverything` and `-Wall -Wextra -Werror`.

Each built-in checker shard passed 210,491 checks. The first-for-semicolon driver passed 1,454 checks. Separate focused Clang 23.1.4 comparisons passed 24 language, warning, lane and output combinations for each feature. The field test included the ordered uninitialized pointer warning and note, scoped macros, bit-field truncation, out-of-range constants and the value of a GNU statement expression. A separate conditional-pointer example exposed an existing discrepancy under `-Wsometimes-uninitialized`: ordinary Buster and the field experiment both omit the same Clang warning. In a second field campaign, 96 generated units under four policies gave 384 matching status/diagnostic pairs, 288 identical whole objects and 703 admissions. A runtime checking five real field widths returned checksum 204054 in all three compiler modes.

## Reproduction

Apply `pregraph-assignment-census.patch` to Buster `84a7d3d76891d6c393497e62e6aff38f2b162fc2` and build it. In two runs of `measure-node-machine --shadow --window-rows --front-first --passes 0`, pass the same SQLite path and preprocessor flags as `verify-frozen.sh`. For the broad run set `NODE_PROOF_POINTERS=1 NODE_PROOF_NO_FP=1`. For the integer-only run unset both variables. The two compressed logs contain each accepted assignment root and its constituent ordinary nodes. `python3 analyze-shapes.py trace.log report.txt` reproduces the partitions from the decompressed stderr. `field-shapes.py trace.log` reports literal token and target type constraints.

Apply either feature patch with `git am` on its common parent and build Develop. Run `verify-frozen.sh path/to/build/compiler path/to/sqlite3.c output-directory`. The GDB probes use the native x86-64 layouts of these commits. The first probe records the actual driver stream at dump time, checks every root against a separately compiled ordinary stream and writes the exact 96-byte payloads. The second selects the same input option in the lower-inventory entry and calls the existing source-aware lowering wrapper. This exposes the actual parser-source token associated with each native instruction. The complete SQLite comparison runs separately from timing. Both probes validated the compiler fixture before the frozen run.

Agent session: 01a1fd72-c69a-7aa3-9540-11ff6816d868 (Codex session ID, no share URL is exposed, collaborating agent warnings)
Model: OpenAI / GPT-6
