# Emission layout validation

The production verifier checks final instruction offsets when the compiler resolves debug and unwind metadata. In automatic mode, a missing layout or a non-empty layout with a missing offsets column enters the scalar verifier to return an error. This record measures that input-dependent handoff and the candidate validators. [Issue #3454](https://github.com/buster14a/buster/issues/3454) · [Production source](https://github.com/buster14a/buster/blob/b42a31642f30d791cd59f2386a97334b74cceb9c/src/buster/compiler/emission_metadata.c#L243)

| Input | Automatic calls | Explicit scalar calls | Structurally invalid calls | Largest layout |
| --- | ---: | ---: | ---: | ---: |
| lua-tier0 | 2,192 | 0 | 0 | 9,171 |
| lua-tier1 | 3,118 | 0 | 0 | 7,130 |
| musl-tier0 | 5,513 | 0 | 0 | 1,816 |
| musl-tier1 | 7,656 | 0 | 0 | 2,681 |
| sqlite-tier0 | 5,336 | 0 | 0 | 12,072 |
| sqlite-tier1 | 7,365 | 0 | 0 | 18,029 |
| suite-tier0 | 14,703 | 14,554 | 9 | 97 |

Across both tiers, the 1,371 Lua, SQLite and musl inputs produced 31,180 calls with complete columns. The official suite made nine structurally invalid calls. The synthetic oracle covers null structures, absent columns, zero-width records, overlap, ordering, bounds, and first-error precedence at 159 record counts from 0 through 8,194. Its sixteen placements per size and shape include arrays ending at a protected page. Each candidate passed all 106,848 oracle comparisons.

The native 9700X comparisons below use three locked Release repetitions per size. The cells count nonzero record counts with a median at or below the original automatic caller on the same malformed input. Each column covers 158 sizes. A second placement leaves 256 accessible bytes after both arrays. The null-structure case receives a null pointer for every size.

| Change | Placement | Starts absent | Ends absent | Both absent | Null layout |
| --- | --- | ---: | ---: | ---: | ---: |
| Packed pointer check | guard | 158 | 158 | 158 | 158 |
| Packed pointer check | slack | 0 | 158 | 0 | 158 |
| Eager presence check | guard | 150 | 158 | 158 | 158 |
| Eager presence check | slack | 0 | 158 | 0 | 158 |
| Direct error with explicit-mode dispatch | guard | 1 | 1 | 1 | 0 |
| Direct error with explicit-mode dispatch | slack | 87 | 157 | 89 | 84 |
| Aligned vector scan | guard | 138 | 1 | 147 | 157 |
| Aligned vector scan | slack | 155 | 134 | 155 | 157 |

The packed pointer check matched or beat the old automatic route at all four malformed shapes in the protected placement. It lost on missing starts and both missing columns in the ordinary placement. The native suite passed 2,451,887 checks for both the packed and eager candidates, including frozen outcomes for every column-presence combination at counts 0–65. [Exact cycle samples, sources, census and oracle receipts](emission-layout.tar.xz)
