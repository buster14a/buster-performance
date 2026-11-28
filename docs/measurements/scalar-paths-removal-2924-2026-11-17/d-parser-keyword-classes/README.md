# Name-dependent K6 parser classes on the Ryzen 7 9700X

The original K6 block refines individual type and builtin tokens by name. The census counts each block when the normal parser reaches this check. The candidate compresses up to sixteen active token positions, gathers full 32-bit identifiers, looks up a byte class, then expands classes at the original positions. It retains the coarse class for unrelated names, mismatched grammar kinds and roles other than a right-hand leaf. Independently specified cases at a guard page checked 108,160 placements including high identifier IDs.

| Corpus | Files | Tokens | Typeof lanes | Type argument lanes | Classes changed | Blocks with one rare lane | Blocks with at least two | Candidate K6 cycles |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| lua | 34 | 571903 | 0 | 36 | 36 | 20 | 8 | +0.744% |
| sqlite | 1 | 716136 | 0 | 160 | 160 | 61 | 39 | -0.348% |
| musl | 1336 | 5039561 | 287 | 184 | 184 | 225 | 77 | +0.782% |

K6 cycles use the median of three paired rounds of the production benchmark. Each round times seven passes per input. For a corpus split into groups of files, the rates are weighted by the number of tokens before calculating the paired ratio.

The first isolated harness reconstructed the role table and spilled input vectors inside its baseline wrapper. The production caller already has those inputs. The second and third harnesses pass them to the baseline, which exposes the cost of gathering sparse keywords. Cells cover 65 live lengths and nine densities, using the median paired ratio across three rotated seeds.

| Baseline setup | Method | Cells meeting baseline | Median ratio | Slowest ratio |
| --- | --- | ---: | ---: | ---: |
| Reconstruct role inputs | Pack all active quarters | 160/585 | 6.2256 | 25.0597 |
| Reconstruct role inputs | Store each quarter | 260/585 | 1.7279 | 7.8943 |
| Reconstruct role inputs | Compress indices and gather | 585/585 | 0.4628 | 0.7657 |
| Use existing role inputs | Compress indices and gather | 366/585 | 0.6364 | 1.5749 |
| Use existing role inputs | Mask the index gather | 366/585 | 0.6364 | 1.6131 |
| Use existing role inputs | Broadcast quarter classes | 229/585 | 2.0872 | 14.9940 |
| Use existing role inputs | Apply per-class masks | 236/585 | 1.8742 | 15.1851 |
| Use existing role inputs | Group four identifiers | 396/585 | 0.8325 | 14.0808 |

A separate parser diagnostic surfaced in 120 mutations. The original and vector-refinement compilers had the same three mismatches. The standalone repair for the missing opening parenthesis after `_BitInt` and `_ExtInt` matched the first Clang error and its location on all 15 controls, including six where the original differed. Repeating the 120 mutations with the repair produced zero mismatches. Its final native suite passed 557 Clang snippets, 2,000 generated streams, 35,648 alignment inputs and 320 driver runs, including the fixed carets.

[Source changes, raw cycle samples, Clang results and production parser receipts](keyword-refinement-and-diagnostics.tar.xz)

## Full compiles with the keyword refinement

Each round compiled with debug information and one lane, in three fresh processes per executable. The table shows the median change in user cycles over five paired rounds. All 1,371 objects matched the parent byte for byte in each tier, along with stdout and stderr. The candidate used more cycles in each of the six comparisons.

| Corpus | Objects | Tier 0 | Tier 1 |
| --- | ---: | ---: | ---: |
| lua | 34 | +0.512% | +0.633% |
| sqlite | 1 | +0.099% | +0.543% |
| musl | 1336 | +0.304% | +0.294% |

[Object manifests, native process logs and source](compressed-keywords-production-compiles.tar.xz)
