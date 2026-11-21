# A direct scalar struct field as a source call argument

The private reader on Buster e81d07a75 admitted 2,337 SQLite call expressions. A source-only extension added 508 complete calls whose arguments include a plain local pointer's scalar field, bringing the total to 2,845. The SQLite object and the entire 4,121,401-byte native input matched the preceding call implementation. These comparisons establish semantic and native coverage. Locked throughput remains unmeasured.

## The source reader's first rejection

The observer at 178b71d87 recorded all 13,690 SQLite call actions at the parser-action reader. It included the source parent, the following action within the current window, preprocessed argument kinds and the exact first gate that returned to ordinary processing. The reader took 2,337 calls. Another 6,225 were outside the return or discarded-call candidates visited by the current scanner. The remaining 5,128 reached an explicit rejection. Among rejected direct return/discard spellings, 867 used only the new `identifier -> identifier` form beyond the existing literal and identifier arguments, 336 used only `&identifier` and 270 only string literals. These counts precede semantic admission. Of the 504 first typed-argument refusals, 276 involved a simple local pointer and a different formal pointer type.

The initial private test of the bitfield guard took zero sites. Debugging an ordinary integer field showed that the type-table construction input and its canonical member columns encode field status differently. The tested production candidate 74bd3f32c uses the canonical member flag, as the ordinary member checker does. The source census, full argument spellings and typed refusal records are archived here.

## Physical selection and warning effects

The candidate requires a complete return or discarded call and retains the preceding direct-callee, argument count, target attribute, return and ABI guards. A new argument must be a single field of a qualifying automatic local pointer to a struct complete at that source position. It uses the canonical member lookup and requires the exact unqualified scalar formal type. It declines bitfields, indirect anonymous members, volatile and atomic accesses, union fields, marked unavailable or deprecated fields, unresolved members, static pointer objects and nested or side-effecting argument expressions.

A selected field reads the local pointer at its identifier token, applies its byte offset and loads the formal scalar type. Rows use the source tokens of the ordinary operations. The local pointer's read flag reaches later uninitialized-variable analysis. Its value and the following arguments retain their ordinary order at the native call. The production prototype uses the ordinary debug path. The separate debug observer can explicitly force compact member arguments to check DWARF and native token origins.

## Whole compilations

| Corpus | Translation units per policy | Added calls per policy | Field loads | Native entries in the additional calls |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 1 | 508 | 577 | 3,486 |
| Lua | 34 | 21 | 23 | 147 |
| musl | 1,336 | 2 | 2 | 7 |
| Buster main | 1 | 14 | 17 | 95 |

All 2,744 default and Wall/Wextra compilation pairs agreed on exit status, diagnostic bytes, native input, references and complete ELF. The 1,372 additional debug pairs agreed on the same outputs, under explicit call-only compaction with the native source token column enabled. The 34 units without native bodies produced matching empty observations. Disabling the extension in its measured binary reproduced every preceding e81d07a75 per-TU admission count and every published diagnostic, object, native and reference hash in both nondebug policies.

All 11 units containing new sites also ran through the surviving checker graph comparator. Their 545 added calls and 619 field loads removed 3,051 graph records. All 1,744,754 surviving records matched after relocation, including 1,158,261 operand edges, 97,877 argument edges and conversions, semantic values, member offsets and every canonical type count. SQLite alone removed 2,845 records. The surviving graph contained 308,938 records and 4,740 types.

The focused matrix compared 78 real translation units under eight policies. It covered arguments in all eight positions, distinct offsets, repeated and distinct pointer identities, packed and qualified types, incomplete records at the use, invalid and unavailable members, atomic and volatile memory, nested side effects, runtime aliasing, uninitialized pointers, debug, Tier 1, two lanes and poisoned arenas. All 624 pairs matched. Fifty physical member sites occurred in each eligible policy, including genuine promoted uninitialized warnings.

## Fault controls

A linked program reads multiple arguments whose struct fields and pointer bases have different values, and changes a field through another call between two invocations. The ordinary and qualified programs returned zero. Both the default and debug builds caught each of the two mutations in the native tape, the ELF and the executing program.

| One changed behavior | Observed consequence |
| --- | --- |
| Use zero for each member offset | The linked program returned 1 at its first value check. |
| Exchange the first two member arguments' pointer object identities | The linked program returned 1 at its first value check. |
| Drop the local-pointer READ event at a substituted member | The real compiler accepted and wrote an object for a program ordinarily rejected by -Werror=uninitialized. |

The read-event fault preserved the successful runtime program's native bytes. The stored diagnostics distinguish that control from the two native-order controls.

## Reproduction

The source identifiers, qualified executable hashes and incremental patches are in this record. The preceding directory supplies the exact public base-to-e81d07a75 patch, frozen predefines, source hashes and build arguments. The snapshot used for Buster's self-compilation was 84a7d3d76891d6c393497e62e6aff38f2b162fc2. Full source-classification rows include their parser token indices. The supplementary graph comparator derives the deleted Operand and Arrow nodes from each ordinary call and compares every surviving graph row after relocation.

~~~sh
bash reproduce.sh /path/to/buster /fresh/output /frozen/corpus/root /path/to/self-source
~~~

The optional corpus root contains SQLite, Lua 5.4.8, musl and its generated headers as described in the preceding experiment. With only its first two arguments the script builds the three executables and replays the focused and linked controls. The archive includes the first failing gate's original diagnostic source line, so the exact census patch is necessary to resolve those line numbers. [Preceding source and debug evidence](https://github.com/buster14a/buster-performance/tree/2b06abd3a60e230485dbf9ceab06b4a696867e4b/docs/measurements/source-call-effects-2850-2026-11-21)
