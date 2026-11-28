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
