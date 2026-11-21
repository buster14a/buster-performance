# Type effects of erasing direct calls in the ordinary checker

A direct call converts its function designator to a pointer. The ordinary graph checker interns that pointer at the call. Erasing a call can move the first allocation of a type or eliminate it entirely. A later expression can then carry a different numeric type ID despite generating the same instructions. This experiment compares an ordinary reader-window compilation with the same compiler's direct-call option, and with a third mode that replays each missing conversion at its former position in graph order.

The frozen SQLite compile took 2,337 plain calls with 302 distinct function types. At graph entry 520 of the call sites, representing 49 distinct function types, already had the required pointer. The other 253 function types all received their pointers while checking the ordinary graph. SQLite began graph checking with 3,445 type slots and interned 1,295 more, all pointers.

| Default graph checker on SQLite | Baseline | Compacted calls | Compacted calls with ordered replay |
| --- | ---: | ---: | ---: |
| Graph nodes | 321,355 | 311,783 | 311,783 |
| Type slots including reserved slot zero | 4,740 | 4,678 | 4,740 |
| Matched surviving nodes with a changed check value, conversion or member offset | — | 8,225 | 0 |
| Surviving checked nodes compared | — | 309,446 | 309,446 |
| Complete ELF identical | — | yes | yes |

The type-table comparison includes the slot number, kind, code, flags, base type, extent, size and structural hash. In the replay lane every slot matched the ordinary table in order. The semantic comparison groups by (source token, opcode), then by occurrence, and compares full checked values, all three operand conversions and the store conversion, member offsets and actual CALL argument conversions. The 11,909 original nodes replaced by 2,337 new summary nodes are excluded from the surviving-node comparison. No overlapping source/opcode key had unequal positive multiplicities on SQLite. Other safety work on admission, target features and warning/debug effects has separate receipts.

The stand-alone `first-use.c` reduces the mechanism to one erased call followed by a different function call. Its two functions have distinct signatures. Without ordered replay, the surviving second call uses a different conversion, and the final table loses a slot. With replay, all seven surviving nodes and all type slots match. Its three object files have identical bytes.

The diagnostic observer uses a direct node-indexed summary array to isolate ordering and retains an ordered trace of allocations in the ordinary default checker. It also records every checked row and emits complete ELF files. The sparse prototype stores the function origin and summary node in reader order and materializes types at those positions. A first-use variant remembers types already scheduled or previously interned, avoiding repeated requests for the same prototype.

## Reproduction

Apply `scanner.patch` to the public commit recorded in `base.txt`. The observer, the sparse schedule and the first-use schedule are three separate patches against that scanner. Build with Buster's pinned toolchain. For the observer, compile with `--lanes 1 -c`, using `--node-window` for the baseline and `--node-window-calls` for both compacted cases. Supply `NODE_CALL_EFFECT_TRACE` and `NODE_CALL_EFFECT_VALUES` as separate output filenames. Set `NODE_CALL_EFFECT_REPLAY=1` for ordered replay. The frozen SQLite arguments enable MEMSYS5 and RTREE, disable load extensions and threading and add the amalgamation's own directory to the include path. These runs measure semantic coverage and allocation ordering. Elapsed-time and instruction costs need separate qualification on the correct compiler.

The per-call sparse schedule records 1,817 missing conversions on SQLite. The first-use schedule records 253. Both schedules matched every type slot, all 309,446 compared surviving rows, the complete ELF and diagnostics in each of the four graph scheduling policies. Six additional translation units exercise nested calls, variadic calls, pointer and array types including a VLA, shadowing and prototype reuse, giving 28 pairs for each schedule. See `sparse-results.json` and `first-results.json`.

The first-use schedule also passed all 2,744 paired one-lane compiles across the four frozen inputs and two warning policies (ordinary and `-Wall -Wextra`). SQLite scheduled 253 distinct function decays. Lua scheduled 151 across 34 translation units, musl 120 across 1,336, and the compiler translation unit 73. Each lane exited successfully and matched stdout, stderr, the complete object's SHA-256 and the final ordered type table. The raw comparison includes translation units where the schedule has no work. Per-translation-unit tuples in `corpus-types.tar.xz` contain status, stdout SHA-256, stderr SHA-256, ELF SHA-256, type-table SHA-256 and scheduled count.

For the two sparse variants apply `sparse-observer.patch` after the applicable schedule patch. The ordinary scheduling mode is the default. Set one of `NODE_CALL_TEST_REGIONS`, `NODE_CALL_TEST_LEVEL`, or `NODE_CALL_TEST_TRANSITIONS` to use regions, level order with regions, or memoized transitions. `corpus.py` accepts the instrumented compiler path, a result label, an output directory and the ordinary compilation flags and C input files. The frozen SQLite, musl and Lua arguments are in `corpora.sh`. The frozen compiler source is commit `84a7d3d76891d6c393497e62e6aff38f2b162fc2`. See `corpus.sh` for its argument list and warning policies. The six small inputs alongside SQLite in the four-policy check are supplied in `fixtures/`.
