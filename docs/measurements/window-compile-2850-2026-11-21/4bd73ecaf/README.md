# Function-local source graphs and checked outputs

The experimental reader checks one complete external declaration at a time. On SQLite 3.53.2 and the frozen Buster compiler it reproduced every ordinary graph node, typed checker report and checked effect fingerprint. The unit-wide expression graph had one slot and held zero nodes throughout. The complete ordinary compiler produced matching ELF objects in a separate process. The experimental source path stopped at the checked rows. [Per-declaration comparisons and object hashes](oracle/totals.tsv)

| Input | Functions checked | Function nodes | All external declarations | All nodes | Largest function | Largest declaration |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| SQLite | 2,674 | 319,280 | 7,298 | 323,623 | 14,820 | 14,820 |
| Buster | 8,667 | 586,965 | 12,518 | 1,407,416 | 5,379 | 347,286 |

The producer keeps token identities, declarations, bindings and a shared mutable C type table. It runs the existing expression reader from each postorder root into a recyclable graph and then runs the production checker. It retires graph, stream and scratch together. Its type comparison uses C structure, qualifiers, function ABI and nominal tags to account for differences in the order of interning. A file-scope assertion in Buster requires a derived array-decay type to persist from one declaration into another. [Implementation patch](implementation.patch)

The oracle checks graph operators, source identities, all three fixed operands, call argument edges and tokens, source ranges, FP context, warning suppression, types, leaves and constant-evaluation flags. For checked output it includes every value, conversion, member offset, primary diagnostic, warning and typed report. It includes all fields of the store, varargs, misc, floating, query, atomic, vector, x86, bit-cast, overload and overload-address effect records. It also checks constant-warning requests and published checker warning events. Every row is keyed by its closing parser token. Each compressed TSV carries both fingerprints. The accompanying compressed stderr files preserve the original process output in each mode. [SQLite receipts](oracle/sqlite/) and [Buster receipts](oracle/buster/)

The supplemental observer computed an independent field fingerprint for each side record in source order. The source-local sequence and whole-unit sequence match byte-for-byte for all 1,597 SQLite entries and all 11,446 Buster entries. These include zero counts for unexercised families. Each record names its closing source token, family and normalized owner node. The observer adds only receipt emission under an environment switch. [Counts by effect kind](effects/counts.tsv), [SQLite records](effects/sqlite/) and [Buster records](effects/buster/)

## Resident memory

The per-process Linux smaps audit ran at the same source-reader boundary, immediately after producing and checking all declarations. Both paths used fresh processes on a Ryzen 9 7940HS with zero anonymous huge pages in the captured mappings. The checker translation unit used an unoptimized debugging build for this attribution. Counts are live KiB at that boundary. [Per-mapping RSS and huge pages](residency/mapping.tsv)

| Input | Whole graph and checker | Per-declaration graph and checker | Difference |
| --- | ---: | ---: | ---: |
| SQLite | 199,600 KiB | 158,508 KiB | −41,092 KiB |
| Buster | 960,696 KiB | 799,680 KiB | −161,016 KiB |

SQLite's largest function, sqlite3VdbeExec, contains 28,599 tokens. Its local graph, stream and scratch mappings retained 1,708,032, 2,326,528 and 106,496 bytes respectively after all functions. Buster's largest function by node count is lane_test_arenas. The corresponding mappings retained 831,488, 851,968 and 94,208 bytes. Buster's monolithic static initializer accounts for the 347,286-node external declaration and increases the three all-declaration mappings to 25,481,216, 49,303,552 and 348,160 bytes. [Raw source-mode summaries](oracle/buster/declarations.source.stderr.xz)

The parser and token-indexed declaration passes still own whole-unit state. At the SQLite source-mode exit the reader's output and scratch alone held 31,544 and 70,896 KiB. Buster retained 335,624 and 251,372 KiB respectively. The source-first witness ends before the remaining source finalizers, driver warning rendering, lowering and ELF writing. [SQLite mapping capture](residency/sqlite/mapping-source.stderr) and [Buster mapping capture](residency/buster/mapping-source.stderr)

## Optimized one-core stage comparison

Five ABBA/BAAB rounds per input used the normal native Develop build on one Ryzen 9 7940HS core. Each observation starts a new process, preprocesses C source, parses and resolves it, and checks all its nodes. The dense control and the per-declaration design both return directly from the same reader phase after the checker runs. The ordinary checkpoint returns after the unit's intervening source finalizers and ordinary checker run. Full object emission lies beyond both checkpoints. [Per-process samples](stage/samples.tsv), [paired summaries](stage/paired.tsv), [raw reports](stage/raw-reports.tar.xz) and [optimized build](stage/build.tsv)

| Input | Control | Paired wall change | Faster rounds | Paired user CPU | Paired system CPU | Paired peak KiB | Paired minor faults |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| SQLite | Same reader boundary | +0.504 ms | 2/5 | +25.418 ms | −18.906 ms | −41,078 | −11,608.5 |
| Buster | Same reader boundary | +6.979 ms | 2/5 | +67.708 ms | −61.760 ms | −161,026 | −43,644 |
| SQLite | Ordinary checker checkpoint | −4.087 ms | 4/5 | +9.654 ms | −17.799 ms | −19,414 | −11,584 |
| Buster | Ordinary checker checkpoint | −25.691 ms | 4/5 | +38.847 ms | −64.468 ms | −73,524 | −42,250.5 |

The same-boundary comparison reduced peak RSS and page faults in every round. The extra user CPU offset the system CPU savings in median elapsed time. Invoke `stages.py --rounds 5` with the same compiler and frozen paths to repeat both schedules.

## Reproduction

The source patch applies to Buster commit `0e1d5b825801135bf50e79da9d546bc95209ab30` and reconstructs the tracked tree of `4bd73ecaf27519017ab6d710a3d7c0d4d49071aa`. The corpus uses a clean Buster checkout at `84a7d3d76891d6c393497e62e6aff38f2b162fc2` and the 9,507,037-byte SQLite 3.53.2 amalgamation. The script checks the frozen SQLite and predefines hashes. Independent checkouts can embed different absolute source path strings in the compiler ELF. Each comparison checks both compiler outputs in the same checkout. [Input and toolchain identities](provenance.tsv)

From the performance-record directory, use the following with an unmodified Buster source checkout, an empty target directory for each worktree, and an extracted SQLite amalgamation.

```sh
record=$PWD
git -C "$BUSTER_REPO" worktree add --detach "$PATCHED_BUSTER" 0e1d5b825801135bf50e79da9d546bc95209ab30
git -C "$PATCHED_BUSTER" apply "$record/implementation.patch"
git -C "$BUSTER_REPO" worktree add --detach "$FROZEN_BUSTER" 84a7d3d76891d6c393497e62e6aff38f2b162fc2
(cd "$PATCHED_BUSTER" && ./build.sh)
python3 reproduce.py --compiler "$PATCHED_BUSTER/build/compiler" --base-compiler "$BASE_BUSTER_COMPILER" \
  --self-source "$FROZEN_BUSTER" --sqlite "$SQLITE_AMALGAMATION/sqlite3.c" --output "$RESULTS/oracle"
python3 stages.py --compiler "$PATCHED_BUSTER/build/compiler" --self-source "$FROZEN_BUSTER" \
  --sqlite "$SQLITE_AMALGAMATION/sqlite3.c" --maps --rounds 0 --output "$RESULTS/residency"
```

The oracle and mapping files above used a local one-core functional witness with an unoptimized checker translation unit and the ordinary Develop build for the other partitions. The baseline executable came from commit `fbef2d68dfc952c269d7a2fd008220341428e727`, whose source directory matches the patch base. The driver used normal source compilation and one lane in all cases. [Exact binary hashes](oracle/binaries.json)

To reproduce the side-record files from the same checkout, apply `effect-observer.patch` on top of `implementation.patch`, rebuild and run `effects.py` with the same `--compiler`, `--sqlite` and `--self-source` paths and a new output directory. The supplemental patch reconstructs commit `804a88de19c8ca325609b0286208b3483a4927c7`. [Observer patch](effect-observer.patch) and [verification script](effects.py)

## Live diagnostic publication

A second supplemental build retains the checked graph and stream until the compiler has submitted its diagnostic events to the real preprocessor diagnostic publisher. It runs the ordinary common-expression, return-stack, format and self-assignment checks, the typed report and warning event publishers and a unit-level pass over source warning events. For supported functions the production control writer and return-flow analysis run while the local graph is live. The driver then retires the body. Five additional unit token-index arrays serve the control writer. This supplement has its own memory profile. [Supplemental source](live-diagnostics.patch)

The process oracle matched exit status, stdout and byte-exact diagnostic stderr in all 112 comparisons across 28 directed C files under default warnings, `-Wall -Wextra`, `-Wall -Wextra -Werror` and `-w`. Each comparison records that the live local driver reached its own publication boundary. The cases cover notes on invalid call arguments, type errors, static-assert text, pragma suppression, incompatible casts, shift precedence, reachable arithmetic faults, compile-time unselected arms, statements after return, format arguments, self-assignment and return-path analysis. A separate first-five-source sample from each of Lua and musl matched all 20 default and `-Wall -Wextra` process results, including an emitted musl header diagnostic. [Directed comparisons](diagnostics/directed.tsv), [raw source, stderr and per-invocation receipts](diagnostics/directed-raw.tar.xz) and [real source sample](diagnostics/sample.tsv)

The control path excludes bodies containing switches, labels, inline assembly, statement expressions, cleanups and registered variable-length arrays. Those bodies still run the graph-based diagnostics with reduced control context. The witness ends before general initializer, recovery, selection and object-emission diagnostics. The receipt's `control-bodies` and `other-bodies` fields report admission. These tests establish exact diagnostic output only for their own source and policy pairs. Apply `live-diagnostics.patch` atop the original `implementation.patch`, rebuild and run `python3 diagnostics.py --compiler "$PATCHED_BUSTER/build/compiler" --output "$RESULTS/diagnostics"`. The directed campaign used the unoptimized checker translation unit. [Diagnostic reproducer](diagnostics.py) and [build identities](provenance.tsv)

## Per-declaration checks on Lua and musl

The same independent per-declaration fingerprints matched all 20,522 roots and 93,759 nodes in 34 Lua 5.4.8 source files and all 297,004 roots and 774,130 nodes in 1,336 musl source files. Both processes returned success for each file. Five musl inputs preprocess to zero parser tokens. A one-line supplemental change accepts the completed empty declaration sequence. The ordinary run completed object emission and recorded its ELF hash for every file. The source-graph witness ends at the checker. This earlier boundary omits ordinary downstream warnings in 251 musl files. [Source-by-source totals](corpora/totals.tsv), [Lua paired rows](corpora/lua/rows.tsv.xz) and [musl paired rows](corpora/musl/rows.tsv.xz)

Apply `empty-unit.patch` on top of `implementation.patch`, rebuild and run `python3 corpora.py --compiler "$PATCHED_BUSTER/build/compiler" --lua-source "$LUA/src" --musl-source "$MUSL" --musl-generated "$MUSL_BUILD/obj" --output "$RESULTS/corpora"`. The original run used the diagnostic checker build mode recorded above. Object hashes are comparable with the same source paths, including absolute paths embedded by file macros. The manifests give SHA-256 and size for each corpus input, including generated configuration headers. [Lua manifest](corpora/lua-src-inputs.tsv.xz), [musl manifest](corpora/musl-src-inputs.tsv.xz), [generated headers](corpora/musl-generated-inputs.tsv.xz) and [empty-unit correction](empty-unit.patch)

## Live diagnostics on the two complete compiler inputs

The next diagnostic build bounds the token scans for `sizeof`, `_Generic` and displaced expression roots to their owning source declaration. It indexes declaration attributes once for the unit. Each body runs the existing uninitialized-variable analysis using its own checked values and the current declaration's slice of the unit’s seven reusable token columns. Statement-expression regions are bound to their source owner and inline assembly outputs carry local graph node numbers. [Supplemental changes](diagnostic-consumer.patch)

The completed publisher matched ordinary source compilation on SQLite and Buster, under both default options and `-Wall -Wextra`. Default stderr was empty. SQLite under the expanded warnings printed twelve uninitialized-variable warnings with source excerpts and notes, 5,942 bytes in total. Buster printed five warnings, 2,681 bytes. Every byte, stdout and exit status matched for each source and policy. SQLite ran the ordinary control writer for 2,487 of its 2,674 functions and used graph diagnostics without those controls for 187. Buster did so for 8,606 of 8,667 functions and used the reduced context for 61. Every declaration reached the live diagnostic publisher. These four observations use the functional checker build. [Measurements and body counts](diagnostics/corpora/large.tsv), [SQLite diagnostics](diagnostics/corpora/sqlite/) and [Buster diagnostics](diagnostics/corpora/buster/)

To reproduce this variant, apply `diagnostic-consumer.patch` atop `live-diagnostics.patch` in the checkout containing `implementation.patch`, rebuild and run `python3 diagnostic-corpora.py --compiler "$PATCHED_BUSTER/build/compiler" --sqlite "$SQLITE_AMALGAMATION/sqlite3.c" --self-source "$FROZEN_BUSTER" --output "$RESULTS/live-corpora"`. The script also accepts additional warning policies. [Verification script](diagnostic-corpora.py)

The five-policy run at the same revision matched all SQLite outputs, including the errors promoted by `-Wall -Wextra -Werror` and the warnings from `-Weverything`. Buster matched its default, wall, strict and quiet runs. Its everything run omitted ten ordinary enum conversion warnings. All 68 Lua comparisons matched. In musl, 1,331/1,336 default and 1,329/1,336 wall runs matched. All 2,672 musl executions reached the local publisher. The differences identified five files with missing parentheses or string-plus-integer warnings and two more with control-dependent warning differences. [Expanded policy receipts](diagnostics/corpora/policies-ef95.tsv), [raw large stderr](diagnostics/corpora/policies-ef95-stderr.tar.xz), [small-corpus totals](diagnostics/corpora/small-ef95.tsv), [Lua rows](diagnostics/corpora/lua-ef95.tsv.xz), [musl rows](diagnostics/corpora/musl-ef95.tsv.xz) and [musl differences](diagnostics/corpora/musl-ef95-differences.tar.xz)

## Case-aware diagnostic control and bounded variable storage

The next version publishes parentheses, string arithmetic, array decay and shift warnings within the active declaration. It uses the ordinary grammar case collector, case values and named branch labels while building a function's control program. It sorts dropped token ranges before the warning evaluator looks up a token. Seven reusable columns for uninitialized-variable analysis now index only the active declaration's source tokens, plus one ignored slot for external objects. SQLite's largest external function declaration spans 28,607 tokens, giving those seven arrays a 457,728-byte bound. Buster's spans 10,276 tokens, giving a 164,432-byte bound. At whole-unit token capacity the arrays required 11,458,176 and 38,937,008 bytes. These are exact array payload bounds. The checker's other token-indexed declaration and control columns remain unit-wide. [Candidate patch](diagnostic-case-controls.patch)

All 2,744 process comparisons matched ordinary source compilation in both status and every byte of stdout and stderr under default warnings and `-Wall -Wextra`. Every execution reached the declaration-local diagnostic publisher. This covers the two large inputs, 34 Lua units and 1,336 musl units. The receipts include each unit's count of functions using the local control writer and those using graph-only diagnostics. The tested path terminates after publishing diagnostics. [Per-corpus totals](diagnostics/case-controls/totals.tsv), [SQLite rows](diagnostics/case-controls/sqlite-cases.tsv.xz), [Buster rows](diagnostics/case-controls/buster-cases.tsv.xz), [Lua rows](diagnostics/case-controls/lua-cases.tsv.xz) and [musl rows](diagnostics/case-controls/musl-cases.tsv.xz)

Apply `diagnostic-case-controls.patch` after `diagnostic-consumer.patch`, rebuild and run `diagnostic-corpora.py` as above, adding `--lua-source "$LUA/src" --musl-source "$MUSL" --musl-generated "$MUSL_BUILD/obj"` to include all four corpora. [Experiment revisions and hashes](provenance.tsv)

## Optimized diagnostic publication timing

On one leased Ryzen 9 7940HS core, normal Develop build `ef95f4686` took longer in every paired `-fsyntax-only` round while reducing peak RSS and page faults. Five alternating ABBA/BAAB rounds per source and warning policy produced 80 fresh-process observations. Each local process and ordinary control produced identical stdout, stderr and status within its round. The ordinary command runs the compiler's complete syntax/diagnostic path. The local producer terminates after its own diagnostic publication. These results measure those two commands. [Raw samples](diagnostics/stage-ef95/samples.tsv), [paired statistics](diagnostics/stage-ef95/paired.tsv) and [build and core](diagnostics/stage-ef95/provenance.tsv)

| Source | Policy | Local wall change | Peak RSS change | Minor fault change |
| --- | --- | ---: | ---: | ---: |
| SQLite | Default | +53.885 ms | −9,428 KiB | −12,349.5 |
| SQLite | Wall | +55.589 ms | −3,808 KiB | −11,344 |
| Buster | Default | +475.524 ms | −145,758 KiB | −63,974 |
| Buster | Wall | +542.892 ms | −148,668 KiB | −65,060.5 |

A separate sampling run of Buster's local/default command attributed 30.28% of sampled user cycles to `check_sparse_next` and 9.14% to `check_program_static_initializers`. The live control writer at this revision prepares initializer marks by scanning a unit-wide sparse column when it sees a function's first initializer. [Buster local profile](diagnostics/stage-ef95/buster-local.txt.xz), [Buster ordinary profile](diagnostics/stage-ef95/buster-whole.txt.xz), [SQLite local profile](diagnostics/stage-ef95/local.txt.xz) and [SQLite ordinary profile](diagnostics/stage-ef95/whole.txt.xz)

Rebuild the `diagnostic-consumer.patch` revision in normal Develop configuration and run `diagnostic-stages.py` with the same `--compiler`, `--sqlite`, `--self-source` and a separate `--output` directory. [Reproducer](diagnostic-stages.py)
