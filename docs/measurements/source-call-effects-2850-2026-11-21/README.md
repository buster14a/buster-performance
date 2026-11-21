# Target-feature diagnostics and DWARF for direct source calls

A plain callee can trigger a target-feature error because of its **caller**. In this input, ordinary Buster and Clang 23.1.5 under `-mavx2 -c` reject the call at its identifier.

~~~c
extern int target(int);
__attribute__((target("no-avx2"), flatten))
int needs_check(void) { return target(1); }
~~~

The initial direct-call prototype collapsed this call into a source summary, returned success and wrote an ELF. Buster's late target-feature check walks ordinary graph calls in emitted bodies. It consults the caller's flatten and target attributes as well as the callee's attributes. The compact prototype's callee-only check admitted this case because the callee has a plain integer prototype and no attributes.

The source-side guard uses the parser/binding reader's attribute table and ordinary function object identity across declarations. On encountering a flatten attribute it marks each definition of that object by its source closing brace. Candidate calls under those braces retain their graph. Other callers in the same translation unit still take source calls. A unit with no flatten occurrence needs no caller ancestry walk. This guard conservatively keeps the ordinary route in a flatten body with otherwise-compatible targets as well.

## Diagnostic and source controls

The fixture generator covers 54 sources and five policies. Cases include target and flatten attributes on separate declarations, lexical scopes and macros, returns, discarded calls, constant and variable control, unused bodies, ABI typedefs, source pragmas, inline and weak definitions, lexical type aliases, spelling locations and ordinary function names. The ungated physical prototype diverged on **22 of 270 pairs** across 11 source shapes. Every divergence suppressed a required target diagnostic and created an object for a rejected program. The guard made all 270 ordinary and opted-in pairs agree on status, complete diagnostic stream, stdout and entire ELF.

The regular driver currently uses ordinary input for debug options. The observer independently forces physical call records in debug builds and retains ordinary actions for other expression shapes. This made 135 real call replacements across the 270 policy pairs. Every output agreed. All 72 available declaration dumps also agree, including the raw type IDs. The raw parser-derived marks cover live function bodies, declarations within those roots and transitive typedefs reached from those definitions.

The source matrix also ran Clang on the supported host command lines. Five default cases gave Clang and ordinary Buster different primary diagnostics or exit status. Three use the unsupported semantic `#pragma clang attribute` in Buster. The other two involve the type-level Microsoft ABI and `__declspec`. These pre-existing differences were unchanged by the physical prototype and the guard. GCC target pragmas, diagnostic push/pop, symbol visibility, pragma sections and floating-environment scopes are independently present in the paired cases.

## Actual corpus calls

The ordinary parser-action prototype used 3,238 direct call summaries in the default normal-driver builds. The caller guard preserved every one compared with the same unguarded path. The call-only debug experiment took the same 3,238 calls in the -g object builds. All 2,744 paired compiles succeeded with identical diagnostic streams and full objects. All 586,125 observed declarations had identical source marks, object and declaration keys, and raw type IDs. This compares declarations visible to the DWARF consumer. The separate graph-record audit covers additional checker type fields.

| Corpus | TUs per policy | Calls retained in default | Calls retained in forced -g | Debug declarations compared |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 1 | 2,337 | 2,337 | 26,249 |
| Lua | 34 | 506 | 506 | 40,572 |
| musl | 1,336 | 170 | 170 | 436,726 |
| Buster main | 1 | 225 | 225 | 82,578 |

The corpus receipts distinguish genuine explicit debug admissions from the normal driver's debug fallback. A separate two-lane run of the 54-source matrix is in two-lane.tsv.

## Debug function references, origins and declaration marks

A separate TU puts integer, pointer and local scalar arguments in direct returns and discarded calls, with arities zero through eight, a static callee, nested typedefs, macro expansion and a line directive. Forcing the debug route physically replaced 22 calls. All 63 declaration records and the complete object matched the ordinary compile under `-g`. The source fixture, eight policy rows and the ELF readers' section/line/DIE transcripts are included.

Three one-term controls exercise independently visible effects.

| Control | What the actual consumer observed in the mixed TU under -g |
| --- | --- |
| Replace the call's callee-token origin with the compact root token | Only `.debug_line` and `.rela.debug_line` differ. All declaration marks agree. |
| Drop the source call's function-symbol reference from ordinary body/data selection | The backend cannot emit the object. Across the 270 cases, all 135 physically active comparisons detect its omission. |
| Remove used marks from reached file-scope typedefs before DWARF construction | Only `.debug_info` and `.rela.debug_info` differ. The normal diagnostic output and line tables match. |

The first control survived the smaller 54-source matrix, where many call and return locations share a source line. The multiline arity fixture distinguishes it. The typedef control changed 24 debug objects in the 270-pair matrix. This records both the positive witnesses and the limits of the smaller fixture.

## Reproduce

`reproduce.sh` builds the initial direct-call prototype from public Buster 6e9c51b9d238734468dccc03ab1b6c715449804e, adds its dormant graph observer at 6dc6d1b81 for the exact initial image, runs the original matrix, removes that observer and then adds the signed guard 621ae3851de6ab27c1b0866cffc2929e26e7b98f and the separate experiment-only observer 77c5399a9b5b7cbf2d0556c326c7a88a8b9223b9. The qualified executables' hashes are in compiler-sha256.txt. The fixed matrix exercises the normal diagnostic gate. The debug matrix explicitly activates call-only compaction for debug modes. Negative-control matrices record each original and mutated result.

~~~sh
bash reproduce.sh /path/to/buster /fresh/output
~~~

The compiler-self corpus input uses source 84a7d3d76891d6c393497e62e6aff38f2b162fc2. The compressed corpus manifest gives all files' hashes. The corpus script records individual object SHA-256s, actual source call counts, observed declaration counts, diagnostic parity and every differing ELF section. Start in the frozen corpus directory holding sqlite, inputs/lua-5.4.8, libc/musl and musl-generated.

~~~sh
source "$record/corpus-arguments.sh"
gzip -cd "$record/predefines.h.gz" > "$out/predefines.h"
main_arguments="-march=native -I$self/src -fwrapv -funsigned-char --predefines $out/predefines.h $self/src/buster/compiler/main.c"
python3 "$record/corpora.py" "$out" "$out/source/build/compiler" "$out/unfixed" "$sqlite_arguments" "$lua_arguments" "$musl_arguments" "$main_arguments"
~~~

The observer and the call-only debug activation are exploratory. This work contains no locked-hardware timing or acceptance claim for the full #2850 pipeline.
