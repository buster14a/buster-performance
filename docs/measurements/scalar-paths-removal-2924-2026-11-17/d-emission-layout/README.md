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

## Checking structure at the metadata entry point

Both planning and resolution call the same metadata checker. It first validates the metadata descriptor, then rejects structural errors before either the scalar or vector row validator receives the layout. This preserves descriptor-error priority when both inputs are invalid. The row validators now receive every non-empty layout with both columns present.

The timed entry point takes the metadata descriptor as a separate argument from the benchmark translation unit. At each size, the same executable alternates the actual baseline automatic call and candidate. It measures both a protected-page ending and an ordinary placement with accessible space after the columns. Cells include all 159 sizes for each of four shapes. Non-null empty layouts are valid in the three absent-column shapes. The null layout is always invalid.

| Candidate | Placement | Cells at parity or better | Median ratio | Worst ratio |
| --- | --- | ---: | ---: | ---: |
| caller | guard | 636/636 | 0.909 | 1.000 |
| caller | slack | 636/636 | 0.906 | 1.000 |
| compact | guard | 0/636 | 1.421 | 1.607 |
| compact | slack | 0/636 | 1.406 | 1.607 |
| pointers | guard | 309/636 | 1.029 | 1.125 |
| pointers | slack | 369/636 | 1.000 | 1.077 |
| mask | guard | 633/636 | 0.909 | 1.017 |
| mask | slack | 633/636 | 0.901 | 1.016 |
| control | guard | 619/636 | 1.000 | 1.048 |
| control | slack | 629/636 | 1.000 | 1.077 |

The caller variant met parity in all 1,272 size, shape and placement comparisons. The control uses two independent copies of baseline. The four column-pointer alternatives show that moving or reordering the check affects throughput. The separate correctness oracle compared each implementation on all 106,848 cases. ASan and UBSan passed on both caller implementations and the oracle caught eight deliberate defects in each. The native development build passed the metadata suite’s 2,452,019 checks, the debug suite, and GDB-backed unwind validation. [Sources, timing data and test receipts](metadata-entry.tar.xz)

## Explicit scalar comparison and exact PR debug builds

The malformed layouts were also measured through baseline’s explicit scalar entry point against the candidate’s ordinary entry point. For three of the four shapes a zero-row layout is valid. A null layout is invalid at every size. Each entry below covers all 159 sizes for each of the four shapes.

| Candidate | Placement | Cells at parity or better | Median ratio | Worst ratio |
| --- | --- | ---: | ---: | ---: |
| caller | guard | 636/636 | 0.838 | 1.000 |
| caller | slack | 636/636 | 0.839 | 1.000 |
| control | guard | 600/636 | 0.938 | 1.091 |
| control | slack | 613/636 | 0.938 | 1.091 |

PR head `36b1aa04f` passed 2,452,086 and 2,455,422 seeded metadata checks, the debug suites and 7,621 unwind checks including an external GDB oracle. Both baseline and head reproduced 1,371 complete debug objects in each tier. The compilers used the same working directory, including for the DWARF compilation directory. Three corpora produced identical object bytes, stdout and stderr. Seven paired rounds used six runs per build.

| Tier | Lua user cycles | SQLite user cycles | musl user cycles |
| --- | ---: | ---: | ---: |
| tier0 | -0.132% | +0.052% | +0.104% |
| tier1 | +0.085% | +0.050% | +0.038% |

The small increases on five of the six whole-compiler comparisons keep the PR in draft while the balanced copy rotations run. [Explicit scalar samples, whole builds, alternate implementations and native suites](explicit-scalar-and-debug-builds.tar.xz)
