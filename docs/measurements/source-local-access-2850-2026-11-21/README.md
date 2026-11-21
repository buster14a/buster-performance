# Source pointer types and local warning replay for Buster #2850

In a one-lane SQLite object compile, the source reader replaced 1,959 integer-expression operands before graph construction. All 1,959 supplied the actual native lowerer. This removed 3,951 graph records and preserved the ordinary ELF byte for byte. The raw graph comparison checked 319,672 surviving nodes and 260,844 edges through the ordinary fallback. Every checked value, diagnostic, warning and surviving conversion/member field agreed after relocating node indices. The retained tapes held 5,870 native rows. This is an experimental compiler on Buster 84a7d3d76891d6c393497e62e6aff38f2b162fc2. It carries no compile-speed measurement.

## Pointer types available at the source reader

The ordinary emitted-graph diagnostic pass populates pointer-type side rows between source chunks. Suppressing that pass removed every source-derived call row and 103 previously used native roots from SQLite. The source reader can populate its side rows from the canonical registered types without altering their numbering. It can also ask the live type table to create a missing pointer when an address or decay operation needs it. The latter experiment exposes a type-numbering dependency.

| SQLite mode | Selected source roots | Native tapes written | CALL entries | Native root requests filled | Old requests lost | Added |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Diagnostic pass warms source side rows | 26,370 | 26,303 | 7,154 | 4,866 | 0 | 0 |
| Source only | 18,546 | 18,480 | 0 | 4,763 | 103 | 0 |
| Source only, lookup of existing pointer types | 21,595 | 21,529 | 2,062 | 4,805 | 74 | 13 |
| Source only, demand missing pointer types | 28,524 | 28,457 | 9,182 | 4,805 | 74 | 13 |

All four ELF files share the digest recorded in identities.tsv. The plain production graph (57,094,544 bytes) also matches the source-only and lookup-only graphs exactly. The diagnostic-warmed graph itself has different type numbering. Compare each semantic graph against the plain compile.

Demand created 14 address pointers, 1,252 function pointer types and one array-decay pointer type. Compared to plain output, 68 checked-value rows and 9,920 surviving conversion/member rows differ. The same-run source/ordinary value comparison passed because both sides saw the newly interned type IDs. The raw semantic graph exposes this interference. The lookup-only source side table preserves the ordinary IDs. In pointer-kinds.c the live-demand reader created two address, three function and one array pointer types and produced two native CALL rows. That short TU retains the exact plain semantic graph as well as its ELF. At all 103 watched native roots the lookup recovered the source checked-value tape. The remaining 74 omitted native requests include assignment of string literals whose target-symbol mapping needs a separate source producer.

## Replay of automatic reads and writes

The positive grammar here uses ordinary integer arithmetic and direct stores. The source reader records the automatic object's declaration, occurrence token and access kind. The compact value contributes the read order. Its surviving enclosing statement contributes write order. Uninitialized analysis conditions first reads and writes on the original enclosing control's evaluation. Used/set analysis also consumes syntactic reads and writes from unreachable source. The first read retains its original identifier token for diagnostics. The warning gate refuses unsupported policies and loop-sensitive constructs lacking their source facts.

The direct warning fixture compares default behavior, uninitialized reads, set-but-unused parameters and the combined Wall/Wextra policy. Suppressing the source read events removed eight uninitialized warning/note lines. Suppressing writes increased that count from eight to fourteen. On the set-but-unused policy, the correct one diagnostic became four without reads and zero without writes. All corresponding complete-replay diagnostics, locations and objects agreed. The generated suite covered nine type TUs and the direct fixture under five policies, including debug information. All 50 pairs agreed on stderr, stdout, exit status and full objects. The individual pairs are in generated.tsv.

| Corpus and policy | TUs | Identical compile pairs | Compacted operands | Actually used by native | Graph rows removed |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite, default | 1 | 1 | 1,959 | 1,959 | 3,951 |
| SQLite, Wall/Wextra | 1 | 1 | 62 | 62 | 132 |
| Lua, default | 34 | 34 | 207 | 207 | 420 |
| Lua, Wall/Wextra | 34 | 34 | 10 | 10 | 24 |
| musl, default | 1,336 | 1,336 | 1,012 | 959 | 2,026 |
| musl, Wall/Wextra | 1,336 | 1,336 | 27 | 27 | 54 |
| Buster main, default | 1 | 1 | 546 | 239 | 1,185 |
| Buster main, Wall/Wextra | 1 | 1 | 44 | 6 | 177 |

Every TU compiled successfully. All 2,744 pairs matched on the complete diagnostic byte stream after removing experiment counters, stdout, exit status and the full object. The receipts include both individual digests and native request counts. The 398 roots the native lowerer did not request all belong to whole functions the ordinary compiler omits. The independent body-selection observer compared the full source range, declaration and selection bit of every defined function in all 20 affected TU/policy pairs. Both compilers selected identical function sets. musl accounted for 53 sites under the default policy. Buster main accounted for 307 under the default policy and 38 under Wall/Wextra. Every compacted root in every emitted function was consumed. The per-root, per-definition receipts are in ordinary-body-selections.tsv.gz.

## Branch and body selection

Without a source control check, two of 1,961 SQLite operands occur under a known-false build-configuration guard. Both were checked, neither reached the native lowerer. The retained value and full ELF still agree in that experiment. The signed guard c4f74340e uses parser structure and decimal integer spellings to recognize proven false or true conditions, including a decisive operand in an AND/OR chain. It retains the ordinary graph in an excluded arm. For an immediately constant switch it leaves the whole switch ordinary. It also offers an intentionally restrictive comparison that declines all guarded statements. In SQLite the latter leaves 61 operands. Adding the outward noninline body test leaves three. The primary pruned mode keeps 1,959.

The mixed source fixture includes dead arms, early exits, loops, a switch and five unused static or inline definitions. Before this guard 52 roots were compacted and 36 consumed. The pruned mode compacts 38 and consumes 33. The five remaining roots belong to the five omitted functions. The additional external-body gate gives 33 of 33. General switch fallthrough, indirect control and final symbol selection require additional information beyond the decimal parser rule. Keep actual native counts distinct from physically removed graph records.

## Reproduce

Use the frozen compiler and source SHA-256s in inputs.sha256 and identities.tsv. Start from a Git checkout with Buster commit 84a7d3d76891d6c393497e62e6aff38f2b162fc2 and the SQLite amalgamation named in inputs.sha256. reproduce.sh creates a separate worktree, applies the experiment and checks the plain graph, warning/omission controls, branch modes and generated programs. Supply a fresh output directory.

~~~sh
bash reproduce.sh /path/to/buster /path/to/sqlite3.c /fresh/output
~~~

The patches include the entire layered source graph/native producer at the public Buster base, canonical pointer lookup (signed 7c698e812), demand-only live interning (f3674357e), automatic access replay (c4a3282fb), the watched-site observer and the source guard (c4f74340e). The ordering recreates the measured source files. The reproduction's ordinary mode refers to the diagnostic-warmed optional splice. The plain mode invokes the production compiler path with the post-check observer alone. Only plain is the independent semantic baseline.

The source and header fingerprints for all four corpora are recorded in corpus-sources.sha256.gz. For all four corpora, source corpus-arguments.sh in the Buster frozen-input directory that holds sqlite, inputs/lua-5.4.8, libc/musl and musl-generated. h points to this measurement directory, tree to the pinned Buster source above and cc to the rebuilt experiment. Each worker compiles the same TU twice, in one lane. Run under a two-core reservation.

~~~sh
source "$h/corpus-arguments.sh"
gzip -cd "$h/proof-predefines.h.gz" > "$out/proof-predefines.h"
main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $out/proof-predefines.h $tree/src/buster/compiler/main.c"
python3 "$h/verify-corpora.py" "$cc" "$out/corpora" "$sqlite_arguments" "$lua_arguments" "$musl_arguments" "$main_arguments"
~~~

To reproduce the final selection witness, apply 07-body-witness.patch.gz to the six-patch build, run build.sh, then run the following command against the same four-corpus receipts. The observer reads the ordinary selector's actual reachable-body bit for every parser range. It never supplies an admission decision.

~~~sh
python3 "$h/verify-bodies.py" "$out" "$cc" "$sqlite_arguments" "$lua_arguments" "$musl_arguments" "$main_arguments"
~~~

The source-root admission and source-event comparison that justify the warning gate have a separate 45,327-case campaign. [Warning admission](https://github.com/buster14a/buster-performance/tree/d1ed9acdefd5ab27a1be307281f80e13dff1d486/docs/measurements/pregraph-warning-admission-2850-2026-11-21) and [event comparison](https://github.com/buster14a/buster-performance/tree/4ae9b3371a91f11a0aaf04fb0d90e1117ef829b8/docs/measurements/pregraph-warning-access-2850-2026-11-21).
