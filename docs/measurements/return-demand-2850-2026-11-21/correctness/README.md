# Demand-return candidate acceptance

The signed candidate is a7c300f3ae627ffed2dee744835ce03886a72892 at base 4dd0f0b163d258dd7778cbb14676a7ac4bf3510a. The local Develop compiler ran the ordinary pipeline, demand mode and dense-oracle verification for each case. All 27 compilations returned zero. Each object and diagnostic stream matched across the three modes.

| -c input | Graph nodes | Bodies | Eligible control graphs | Terminal proofs | Coarse walks | Precise walks | Demanded nodes | Dense fallbacks |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| sqlite | 323,623 | 2,674 | 1,708 | 1,631 | 77 | 0 | 0 | 0 |
| lua-vm | 19,786 | 32 | 24 | 6 | 18 | 0 | 0 | 0 |
| lua-parser | 6,031 | 96 | 31 | 25 | 6 | 4 | 125 | 0 |
| musl-printf | 5,226 | 36 | 33 | 33 | 0 | 0 | 0 | 0 |
| musl-malloc | 2,955 | 62 | 36 | 35 | 1 | 0 | 0 | 0 |
| controls-default | 459 | 16 | 15 | 2 | 12 | 12 | 61 | 1 |
| controls-wall | 459 | 16 | 15 | 2 | 12 | 12 | 61 | 1 |
| controls-no-return | 459 | 16 | 4 | 0 | 2 | 2 | 0 | 0 |
| compiler-main | 1,407,863 | 8,670 | 7,606 | 7,328 | 1 | 0 | 0 | 0 |

The warning control includes fall-through, noreturn, an indirect call, switch, aggregate return, a GNU statement expression and a 180-operand addition that exercises the depth fallback. A dense fallback computes the remaining whole graph and reuses it for later requests. The demanded-node column counts individually memoized nodes.

The reproduction compares exit status, object SHA-256, stdout and stderr with only its separately enabled counter line removed. The counts and all hashes are in objects-and-counts.json.
