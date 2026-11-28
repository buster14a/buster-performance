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

## Complete partitions and sorted completion

Two sort candidates rank or sort eight initial rows together and merge groups by comparing vector packets with the other run's head. A separate stable-order oracle checked the class number and sorted position of every input row. The 860 cells cover 86 lengths and ten distributions, including all-equal hashes, distinct metadata under hash collisions, vector constants differing only in the last word and reordered phi inputs. Order and hash arrays end at protected pages.

Two key-generation candidates exercise the compiler's complete partition routine. One omits supplemental hashes and resolves every tie by checking complete operands. The other hashes vector constants and unordered phi predecessor/class pairs across independent instructions. A generated equivalence relation checks class membership in both directions and checks the class count independently of the assigned labels. Both bounded probing and forced sorting ran on twelve layouts at each of 86 lengths, with three seeds per cell. The 12 include two independently generated ordinary relative-key workloads.

| Candidate and comparison | Cells meeting parent | Median cycle ratio | Slowest cycle ratio |
| --- | ---: | ---: | ---: |
| Packet ranks before merging | 96/860 | 3.2078 | 33.8182 |
| Eight-lane sorting network before merging | 43/860 | 3.3067 | 74.5000 |
| Fixed-column hashes and complete collision checks | 411/2,064 | 1.4694 | 19.4293 |
| Same fixed-column version in the three-way comparison | 408/2,064 | 1.5021 | 18.8251 |
| Exceptional hashing across instructions in a packet | 555/2,064 | 1.1867 | 4.7485 |

When vector constants shared both leading words or phis shared fixed fields, omitting supplemental hashes could send many distinct keys through the collision comparator. Hashing the exceptional operands across instructions reduced that cost. All candidates still had slower sizes on the 9700X.

[Production patches, exact kernels, independent oracles and per-seed timings](key-generation-and-sort-comparisons.tar.xz)

## Stable radix splits and complete pass drivers

The radix candidate splits on the highest differing bit of the hash, then of successive key columns. Tied vector constants extend the key with six words. Tied phis extend it with classes in canonical predecessor order. Rows with differently ordered input lists still match. Stable masked compression partitions each group, and recursion visits the smaller subrange first to bound its stack. The independent oracle verified the order and classes in all 860 cases. The candidate met the parent in 73/860 three-seed timing comparisons, with median cycle ratio 6.5077.

Separately, the fixed-column hash candidate passed the native GVN suite on three seeds and produced byte-identical optimizer pass reports on all three corpora. Five paired rounds of the complete pass driver gave cycle changes of +0.136% on Lua, -0.350% on SQLite and +1.046% on musl.

[Implementation, stable-order oracle, GVN suite logs, complete pass reports and timing records](radix-and-pass-drivers.tar.xz)
