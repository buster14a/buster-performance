# Checked window records through ordinary native lowering

The experiment types front records before the ordinary checker creates their expression graph. It supplies the resulting records to the existing warning, context and row sweeps for complete placed expressions. Each native tape has its own entry count, kinds, classes and 64-bit values. A separate calls table retains the callee object, argument count, converted argument classes and variadic flag. After normal selection, the comparison resolves global and callee objects to program symbols and asks the ordinary lowerer for the entries owned by each root.

| Input | Complete T roots with X rows | Roots compared with ordinary native lowering | Native entries | Calls | Call arguments | Variadic calls | Differences |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| SQLite | 45,048 | 44,996 | 269,441 | 9,511 | 22,308 | 226 | 0 |
| Lua | 6,719 | 6,601 | 35,029 | 1,513 | 3,223 | 11 | 0 |
| musl | 27,288 | 13,478 | 71,093 | 506 | 930 | 0 | 0 |
| Compiler main | 33,574 | 13,463 | 72,876 | 2,700 | 4,793 | 65 | 0 |

SQLite’s compared entries include 1,126 global symbol references and 714 labels. The lowering oracle supplies label locations, source ownership and the local-number correspondence. The shadow still uses ordinary expression placement and eligibility. Only the entries for roots reached by the lowered program are compared with native output. The table’s compiler input is this patched compiler’s main translation unit.

Replacing a subset of an incomplete expression’s records breaks the conversion its consumer wrote back into the argument record. The broader substitution control reproduced 2,340 context and 374 row differences in SQLite. Replacing complete expressions gave zero across the four workloads. A literal payload mutation in the preceding scoped trial produced 22,522 SQLite row differences. On the final bridge, flipping the first native class in each nonempty tape produced exactly 44,996 native differences. Substituting an invalid callee object or toggling every call’s variadic flag each produced 9,253, one per call-bearing root. Corrupting the first argument class where present produced 9,150. The original per-record checked-value and conversion comparison is described in the [typing record](../../window-call-typing-2850-2026-11-21/).

Apply [experiment.patch](experiment.patch) to [84a7d3d76](https://github.com/buster14a/buster/commit/84a7d3d76891d6c393497e62e6aff38f2b162fc2). Build with `./build.sh` and run `measure-node-machine --shadow --window-rows --front-first --passes 0` on the frozen inputs with `NODE_PROOF_NO_FP=1 NODE_PROOF_POINTERS=1 NODE_PROOF_CALLS=1 NODE_PROOF_TO_ROWS=1 NODE_PROOF_NATIVE=1`. [Original runner and corpus arguments](scripts/) · [Per-case results](comparisons.tsv) · [Raw compiler and oracle reports](runs.tar.xz) · [Build digests](build.txt). The trials exercise correctness. Their instrumented execution has no throughput qualification.
