# Fixed IR operand remapping over unsigned 32-bit value IDs

Compiler baseline `cc7d4ffb4`, candidate `e5b82994e`, on the Ryzen 7 9700X. The original remap used a scalar loop above the signed gather limit. The candidate gathers relative to the middle of the map. Fixed and optional value columns share one opcode table derived from the IR rows. The packet masks preserve literal fields and absent operands. The short partial packet can gather up to five active rows from all three columns together.

## Reach

The optimizer pass driver processed 1,334 remaps and 9,512 rows on Lua, 9,875 and 64,385 on SQLite, and 5,657 and 36,589 on musl. A separate, shared-memory counter includes any worker that exits without running C destructors. On the ordinary one-lane Tier 1 debug-free compiler path, Lua performed zero remaps, SQLite 5,873 and musl 3,952. Enabling all passes reached 5,436, 67,694 and 21,506 respectively. The largest function in that run contained 50,241 instructions. All corpus calls used the narrow map.

## Per-size comparison

Each of three seeds exercised 90 lengths from zero to 8,192, four opcode distributions, and narrow and full unsigned map extents. The gate alternated six implementations in rotating order over nine trials per seed, then took the median paired ratio across seeds. The oracle checked every output row, including surrounding canaries, seven columns, fixed and optional operands, and protected gaps between valid map pages. The wide regression fixture covers both sides of the signed boundary and the last usable unsigned ID.

| Map | Distribution | Sizes at parity or faster | Median candidate / baseline | Slowest |
| --- | --- | ---: | ---: | ---: |
| Narrow | Mixed operators | 90/90 | 0.9257 | 0.9714 |
| Narrow | Arithmetic | 90/90 | 0.9170 | 0.9625 |
| Narrow | Literals | 90/90 | 0.7024 | 0.9519 |
| Narrow | All opcodes | 90/90 | 0.9184 | 0.9715 |
| Wide | Mixed operators | 90/90 | 0.6408 | 0.8706 |
| Wide | Arithmetic | 90/90 | 0.6276 | 0.9016 |
| Wide | Literals | 90/90 | 0.5627 | 0.7559 |
| Wide | All opcodes | 90/90 | 0.6413 | 0.8419 |

The native function body extracted from the final source produced the same 937 bytes of machine code as the measured variant. Eight intentional changes to gather addressing, merged lanes, operand selection and metadata all failed the oracle. The native optimizer, store-motion and unroll suites passed 358,076, 394 and 5,955 checks.

## Complete compiler and pass driver

The complete pass reports matched byte for byte. All debug objects and diagnostic streams matched across both tiers. The columns report median paired user-cycle changes over five rounds of three fresh processes. Ordinary compilation showed small increases in all six measurements.

| Corpus | Objects per tier | Complete pass driver | Tier 0 compile | Tier 1 compile |
| --- | ---: | ---: | ---: | ---: |
| Lua | 34 | +0.125% | +0.118% | +0.293% |
| SQLite | 1 | -0.174% | +0.206% | +0.333% |
| musl | 1336 | -0.059% | +0.144% | +0.057% |

[Raw site runs, candidate sources, mutation results, driver counters, object hashes and complete-process samples](remap-evidence.tar.xz)

## Repeated whole-compile controls

Each of eight rounds launched two aliases of each Release executable. The launch order rotated across rounds. Each alias contributed its median user cycles from four complete compilations. The table shows the median of the eight ratios of the two candidate cycle counts combined to the two baseline counts combined.

| Tier | Corpus | Complete compile cycles |
| --- | --- | ---: |
| tier0 | lua | +0.039% |
| tier0 | sqlite | +0.174% |
| tier0 | musl | +0.081% |
| tier1 | lua | +0.232% |
| tier1 | sqlite | +0.226% |
| tier1 | musl | +0.048% |

All six comparisons used more cycles with the candidate. The complete-compile gate remains open.

[Round-level counters, complete process records and runner](four-label-compile-control.tar.xz)

## Remapping neighboring IR ranges together in balanced whole compilations

In each of eight rounds, two baseline labels and two candidate labels each ran four fresh compilations. The launch order rotated. The candidate column is the median ratio of the two candidate cycle counts combined to the two baseline counts combined. The last two columns compare the paired labels of the same executable and show variation within this experiment.

| Tier | Corpus | Candidate user cycles | Rounds meeting baseline | Baseline label 2 vs. 1 | Candidate label 2 vs. 1 |
| --- | --- | ---: | ---: | ---: | ---: |
| tier0 | lua | +0.063% | 2/8 | -0.226% | +0.159% |
| tier0 | sqlite | -0.102% | 6/8 | +0.199% | +0.086% |
| tier0 | musl | +0.107% | 1/8 | -0.022% | +0.046% |
| tier1 | lua | +0.291% | 0/8 | +0.005% | +0.004% |
| tier1 | sqlite | +0.101% | 0/8 | +0.032% | +0.018% |
| tier1 | musl | +0.162% | 0/8 | +0.016% | +0.010% |

The candidate median met baseline in 1 of the six configurations. All 48 process groups finished successfully.

[Round medians, complete process records and runner](contiguous-remap-balanced.tar.xz)

## Copying adjacent ranges and identifying rows that own extra operands

The remap combines an instruction range and its terminator when their output positions are adjacent. The opcode lookup also reports whether a range contains an instruction with a separate operand list. The caller can skip its second scan when the range has none. The guarded fixtures cover all five owning opcodes, ordinary arithmetic, absent operands and padding. They rejected 14 deliberate changes.

The second timing harness compiles both implementations from their full compiler translation units, including the actual IrFunction layout and opcode tables. Each harness compares 90 lengths, four opcode distributions and two map extents. Each cell is the median paired ratio over three seeds.

| Timing harness | Map | Cells meeting baseline | Median ratio | Slowest ratio |
| --- | --- | ---: | ---: | ---: |
| Reduced fixture layout | Narrow | 360/360 | 0.9001 | 0.9654 |
| Reduced fixture layout | Full unsigned | 360/360 | 0.6272 | 0.9321 |
| Compiler translation units | Narrow | 360/360 | 0.9129 | 0.9866 |
| Compiler translation units | Full unsigned | 359/360 | 0.6871 | 1.0158 |

The native unroll, optimizer and store-motion suites passed 5,962, 358,076 and 394 checks. Each pair of complete pass reports matched byte for byte. Both tiers produced the same debug objects, standard output and diagnostics. The timing columns give median paired user-cycle changes across five rounds with three fresh processes per executable.

| Corpus | Objects per tier | Optimizer pass driver | Tier 0 compile | Tier 1 compile |
| --- | ---: | ---: | ---: | ---: |
| lua | 34 | -0.188% | -0.155% | +0.090% |
| sqlite | 1 | -0.464% | -0.110% | +0.214% |
| musl | 1336 | -0.291% | -0.102% | -0.008% |

[Source, both per-size sweeps, guarded oracle, mutations, pass reports, object hashes and process logs](ir-range-extra-owners.tar.xz)

## Short vector stores in the complete IR remapper

For final packets of one to four instructions, the remapper packed the three operand columns into four-lane quarters, gathered once and stored each quarter directly. Both experiments compiled the actual IR translation units and opcode tables. The five-way run included the preceding revision and two other changes to mask generation. The two-way run compared the short stores directly with the untouched parent. Each cell is the median candidate/parent ratio for three seeds.

| Executables in sweep | Candidate | Cells meeting parent | Median ratio | Slowest ratio |
| ---: | --- | ---: | ---: | ---: |
| 5 | Range and extra-operand detection | 720/720 | 0.7609 | 0.9881 |
| 5 | Three four-lane columns | 720/720 | 0.7178 | 0.9691 |
| 5 | Packed opcode classes | 720/720 | 0.7226 | 0.9854 |
| 5 | Empty third-column shortcut | 720/720 | 0.7414 | 0.9926 |
| 2 | Three four-lane columns | 720/720 | 0.7450 | 0.9722 |

The short stores passed four new injected faults, all three native IR suites and the parent object checks for 1,371 files at each tier. In the debug-object comparison, both versions compiled from the same working directory. Both candidate layouts produced byte-identical optimizer pass reports. The complete pass driver took more cycles on each corpus for both layouts. The table gives median paired cycle changes across five rounds with three fresh processes per executable.

| Candidate | Lua | SQLite | musl |
| --- | ---: | ---: | ---: |
| Three four-lane columns | +0.520% | +0.210% | +1.044% |
| Remap extra operands during the copy | +1.375% | +0.904% | +1.525% |

[Source, both sweeps, injected faults, native suites, compiler pass reports and debug object hashes](ir-short-vector-stores.tar.xz)

## Identifying rows with extra operands in balanced whole compilations

In each of eight rounds, two baseline labels and two candidate labels each ran four fresh compilations. The launch order rotated. The candidate column is the median ratio of the two candidate cycle counts combined to the two baseline counts combined. The last two columns compare the paired labels of the same executable and show variation within this experiment.

| Tier | Corpus | Candidate user cycles | Rounds meeting baseline | Baseline label 2 vs. 1 | Candidate label 2 vs. 1 |
| --- | --- | ---: | ---: | ---: | ---: |
| tier0 | lua | -0.098% | 6/8 | +0.059% | -0.142% |
| tier0 | sqlite | -0.048% | 5/8 | +0.019% | -0.254% |
| tier0 | musl | -0.078% | 5/8 | +0.062% | -0.002% |
| tier1 | lua | +0.071% | 1/8 | -0.006% | -0.004% |
| tier1 | sqlite | +0.186% | 0/8 | +0.024% | +0.030% |
| tier1 | musl | -0.014% | 6/8 | +0.027% | +0.002% |

The candidate median met baseline in 4 of the six configurations. All 48 process groups finished successfully.

[Round medians, complete process records and runner](ir-extra-lists-balanced.tar.xz)

## Limiting the short operand store to four instructions

All methods used the actual IR translation units, two map extents, four opcode distributions and 90 lengths. Each cell is the median paired ratio across three seeds. The four-lane form passed all 720 combinations and all three native suites. Its complete optimizer reports matched byte for byte.

| Method | Cells meeting parent | Median ratio | Slowest ratio |
| --- | ---: | ---: | ---: |
| Remap with extra-operand detection | 720/720 | 0.7310 | 0.9866 |
| Four-lane stores through length four | 720/720 | 0.7228 | 0.9791 |
| Store columns directly for short tails | 719/720 | 0.7445 | 1.0670 |
| Group two operand columns | 713/720 | 0.7999 | 1.2360 |

The first timing column measures the four-lane form in the complete pass driver. The last two columns measure the preceding quarter-store implementation in complete compilations across five paired rounds. Both compilers ran from the same directory and produced identical debug objects, standard output and diagnostics on all 1,371 translation units in each tier.

| Corpus | Short form pass driver | Preceding quarter stores, Tier 0 | Preceding quarter stores, Tier 1 |
| --- | ---: | ---: | ---: |
| lua | +0.382% | +0.026% | +0.240% |
| sqlite | -0.503% | -0.366% | +0.296% |
| musl | +1.201% | +0.051% | +0.077% |

[All samples, report and object comparisons, sources and suites](ir-short-tail-and-objects.tar.xz)
