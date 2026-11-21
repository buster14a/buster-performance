# Canonical function decay replay with debug call summaries

The physical call prototype here replays the first missing function-to-pointer conversion in ordinary graph order. This repeats the target and DWARF comparisons on the integrated source. The debug experiment adds an explicit environment switch to exercise real compacted call sites under debug options. The normal driver's debug options retain the ordinary graph.

| Input | TU pairs under default and -g | Real calls per policy | Declarations compared under -g |
| --- | ---: | ---: | ---: |
| SQLite | 2 | 2,337 | 26,249 |
| Lua | 68 | 506 | 40,572 |
| musl | 2,672 | 170 | 436,726 |
| Buster main | 2 | 225 | 82,578 |

All 2,744 ordinary and opted-in pairs exited successfully with identical diagnostic bytes and whole objects. All 586,125 declaration records matched on source token, binding kind, marks, object, binding and raw declared type ID. The opt-in path retained 3,238 calls under default and the same 3,238 under forced debug. The corpus files and arguments are in the parent record. These measurements are confined to the debug declaration consumer. The semantic survivor graph requires its separate comparison.

The 54-source, five-policy matrix agreed on all 270 pairs for each of standard and forced-debug modes. The normal driver took 54 calls across the five policies. Forced-debug took 135, including debug and line-table cases. The eight-policy mixed shape test includes multiline calls, macro source mapping, static references, arities zero through eight, local arguments and nested typedefs. At -g it took 22 calls. Moving their source locations changed only the line table and its relocations. Removing marks for transitive typedefs changed only debug info and its relocations. Suppressing the callee references caused emission to fail.

A separate 120-pair matrix covers 20 caller-attribute and alias shapes under six policies, including interrupt, register-saving and preserving conventions, naked functions, valid and invalid musttail returns, alternate ABI, target/flatten and explicit symbol names. Ordinary and compact status, diagnostics, stdout, raw debug marks and whole objects all agreed. Across five supported policies the compiler took 85 calls, including sites where the ordinary warning is promoted to an error. The sixth policy, -mgeneral-regs-only, hit the existing checker target restriction before site selection for all 20 inputs.

Six fixtures exercising predeclared and late function-pointer types, generated signatures and the physical runtime inputs ran at one and two lanes with both the default backend and Tier 1. The 24 pairs took 1,072 physical calls and compared 9,416 declaration records. Status, diagnostic bytes, stdout, raw type IDs and whole objects all agreed. The earlier diagnostic observer also matched on those inputs. The declaration stream alone does not expose the full graph type-order failure the integrated scheduling change addresses.

## Reproducing the comparisons

The two compressed patches reproduce the exact observed source tree from the same public baseline as the parent record. Compiler and tree hashes are in compiler.txt. The integrated report scripts use the corpus manifests, initial unguarded compiler and primary diagnostic and shape drivers from the parent directory. Run the parent's reproduce.sh to obtain the initial unguarded executable, then use the integrated script in a separate output directory.

~~~sh
bash reproduce.sh /path/to/buster /new/integrated-output
~~~

To replay the corpus, run the corpus command in the parent record with the integrated compiler and the original unguarded compiler. The earlier declaration witness in witness-v1.tsv.gz used the parent record's final diagnostic observer. It serves as a scope control for the declaration-only comparison. Hashes in each raw matrix compare the two routes for one source path and compiler. Compiler diagnostics and DWARF include the source paths used for that run.
