# GVN refinement and sorted partitioning

Ryzen 7 9700X, Release, under the shared exclusive runner. The parent is `cc7d4ffb4`. #3449 tracks the exceptional GVN keys and the sorted completion of partition refinement. The merged congruence pass also handles cyclic phi nodes.

## Reach on compiler workloads

Each counter is shared across compiler workers. The three corpora comprise 34 Lua translation units, one SQLite amalgamation and 1,336 musl translation units. Each was compiled at Tier 1 with default passes, with numbering enabled explicitly, and with all passes. The suite ran 2,189,930 checks. A sorted request is a partition entered with the sort flag already set. The count excludes any additional sorting triggered later by probe-budget exhaustion. Phi-class reads include the acyclic pass and key comparisons as well as refinement hashing.

| Passes | Corpus | Functions | Ordinary partitions | Sorted requests | Exceptional vector keys | Full phi keys | Relative phi keys | Phi-class reads | Reads requiring reorder |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| default | lua | 2 | 0 | 0 | 0 | 0 | 0 | 36 | 16 |
| default | sqlite | 18 | 2 | 0 | 0 | 2 | 2 | 1,599 | 91 |
| default | musl | 20 | 3 | 0 | 0 | 2 | 4 | 525 | 149 |
| numbering | lua | 1,097 | 45 | 0 | 0 | 34 | 96 | 4,251 | 530 |
| numbering | sqlite | 2,688 | 291 | 0 | 0 | 238 | 380 | 35,406 | 2,653 |
| numbering | musl | 2,957 | 190 | 0 | 0 | 173 | 200 | 11,967 | 904 |
| all | lua | 2,820 | 79 | 0 | 0 | 68 | 164 | 6,943 | 689 |
| all | sqlite | 7,195 | 498 | 0 | 0 | 423 | 626 | 52,384 | 4,786 |
| all | musl | 6,639 | 306 | 0 | 0 | 267 | 325 | 18,468 | 1,385 |
| tests | suite | 1,670 | 3,071 | 1,659 | 6 | 5,852 | 2,974 | 39,840 | 68 |

## Predecessor and class fingerprints

The candidate hashes eight stored predecessor/class pairs at a time, including the unsigned-ID and copy-alias lookups. A commutative accumulator makes the fingerprint independent of predecessor storage order. The existing complete comparison still distinguishes colliding keys. The guarded test checks each method against its specified mathematical fingerprint, including zero inputs, reordered predecessors, aliases and IDs on both sides of the signed boundary.

Three seeded comparisons covered the 86 lengths in the archive from zero to 2,048. Each result below uses the median of the three candidate/baseline ratios at each length. The candidate met baseline in 534/688 comparisons. Ordered inputs with aliases and small phis still favor the original hashing procedure.

| Layout | Lengths meeting baseline | Median cycle ratio | Slowest cycle ratio |
| --- | ---: | ---: | ---: |
| Ordered | 81/86 | 0.5104 | 2.1966 |
| Reverse | 83/86 | 0.0941 | 2.1940 |
| Shuffled | 83/86 | 0.0921 | 2.2043 |
| Ordered with aliases | 33/86 | 1.0466 | 3.5887 |
| Reverse with aliases | 78/86 | 0.2077 | 3.5823 |
| Shuffled with shared class | 77/86 | 0.2089 | 3.6178 |
| Ordered with full-range aliases | 23/86 | 1.0937 | 3.5506 |
| Reverse with full-range aliases | 76/86 | 0.2074 | 3.6323 |

[Shared-worker counters, timings, production patches, oracle and runners](reach-and-phi-fingerprints.tar.xz)
