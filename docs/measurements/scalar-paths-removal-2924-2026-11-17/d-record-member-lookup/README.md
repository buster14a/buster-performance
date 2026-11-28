# Record-member lookup after index exhaustion

On cc7d4ffb4, a shared-memory compiler-worker census counted the ordinary member lookup's direct, indexed and exhausted routes. Lua had 7,391 direct and 1,929 indexed lookups, SQLite 19,822 and 14,932, and musl 7,374 and 1,920. The initializer added 484 direct and 121 indexed lookups on musl. Every ordinary corpus recorded zero walks. The native type suite reached 767,741 explicit or routed walks and visited 63,345,732 member rows.

The candidate scans names in 16 lanes, removes unnamed bit-fields and preserves declaration order when a direct name and a promoted name compete. It saves pending siblings and spills its visited-type set into scratch after eight distinct nonleaf types. Access qualifiers and byte offsets follow the accepted declaration path.

## One-bucket qualification

TypeCapacity interprets zero lookups as the default capacity. The initial direct-walk experiment called the walk explicitly on default-capacity records. The repeated experiment reserved exactly one bucket and asserted that every record wider than 16 routed to the exhausted-index walk. Of the 360 constructed records, 324 selected that walk and 36 qualified for the direct small scan. Each record had six requests. Both versions of the explicit walk were timed on all 360 records.

On the 9700X the candidate met the existing walk in 2,160 of 2,160 cases across three seeded runs. Widths ranged from 0 to 8,192. The median candidate/baseline ratio was 0.1593, and the slowest was 0.9989. The independent compiler oracle covered declaration-order shadowing, qualifying anonymous fields, a 64-deep shared graph, 100,000-member records and constrained scratch. Guarded name and flag columns cover every tail through 65 members. The native member suite passed 447,656 checks, and its separate Clang comparison passed 6,025 checks. Eight changes to precedence, bit-field filtering, qualifiers, offsets, sibling traversal, lane coverage and scratch handling each failed the independent oracle.

The initializer needs the outer field in which to continue brace elision. On the same one-bucket fixtures the three experimental initializer replacements satisfied 1,820, 1,899 and 1,908 of 2,160 timings. The compiler change leaves the initializer's separate capacity fallback in place.

## Complete compilation

All 1,371 objects and both output streams matched at each optimization tier. The table reports the median paired change in user cycles across five rounds of three compiles. The ordinary corpora take the indexed and small-scan paths described above.

| Corpus | Tier 0 | Tier 1 |
| --- | ---: | ---: |
| lua | -0.032% | +0.120% |
| sqlite | -0.174% | -0.009% |
| musl | +0.010% | +0.052% |

[Source changes, runner, saturation counts, per-case timings, object hashes and mutation receipts](record-member-evidence.tar.xz)

## Repeated whole-compile controls

Each of eight rounds launched two aliases of each Release executable. The launch order rotated across rounds. Each alias contributed its median user cycles from four complete compilations. The table shows the median of the eight ratios of the two candidate cycle counts combined to the two baseline counts combined.

| Tier | Corpus | Complete compile cycles |
| --- | --- | ---: |
| tier0 | lua | +0.018% |
| tier0 | sqlite | -0.156% |
| tier0 | musl | +0.078% |
| tier1 | lua | +0.108% |
| tier1 | sqlite | -0.060% |
| tier1 | musl | -0.002% |

Three of the six medians increased. The whole-compile gate remains open.

[Round-level counters, complete process records and runner](four-label-compile-control.tar.xz)

## Initializer designators with an exhausted index

These comparisons measure the initializer's distinct lookup rule. A direct name takes precedence over names promoted from anonymous members, and a successful promoted lookup returns its outer member. The fixture spans 90 widths through 8,192 fields, five record layouts, and seven requests including a zero name, a miss and a duplicate in a promoted child. Each candidate matched the baseline for all 3,150 cases. Every record over 16 fields used the exhausted-index path. The last column is the median candidate/baseline cycle ratio on those records. Each cell uses the median of three seed ratios on the 9700X.

| Method | All cells meeting baseline | Exhausted records over 16 fields meeting baseline | Median ratio over 16 fields |
| --- | ---: | ---: | ---: |
| Retain the first eligible child mask | 2,419/3,150 | 2,190/2,555 | 0.2238 |
| Retain the first unnamed group | 2,420/3,150 | 2,190/2,555 | 0.2121 |
| Test promoted children while scanning | 2,414/3,150 | 2,190/2,555 | 0.2478 |

For each method, 365 of the 2,555 cells over 16 fields still lost. Hits in the first member were sensitive to the cost of setting up the vector comparison. [Complete samples, population counts by lookup route and fixture](initializer-designator-gates.tar.xz)

## First-packet latency and tag descriptors

The direct packet variants change how the first names are loaded. Three other variants cache the first direct member name in the tag’s existing lookup word and use the exponent byte to distinguish an exhausted index. The experiment materialized a second descriptor view of the same records for the candidate. The baseline kept the original table. The three tagged runs used three different name ranges, including identifiers with the top bit set. Each result matched the original initializer rule, including a query for name zero.

| Method | All sizes and shapes meeting baseline | All exhausted-index cases meeting baseline | Exhausted records above 16 fields meeting baseline |
| --- | ---: | ---: | ---: |
| Full vector first packet | 2,421/3,150 | 2,415/2,884 | 2,190/2,555 |
| Right-aligned short packet | 2,397/3,150 | 2,390/2,884 | 2,190/2,555 |
| Four-name opening packet | 2,414/3,150 | 2,414/2,884 | 2,190/2,555 |
| Cached name and first eligible child mask | 2,826/3,150 | 2,826/2,884 | 2,555/2,555 |
| Cached name and first unnamed group | 2,827/3,150 | 2,827/2,884 | 2,555/2,555 |
| Cached name and eager promoted lookup | 2,824/3,150 | 2,824/2,884 | 2,553/2,555 |

Caching the first name removed the 365 losses previously observed above 16 fields in two variants. Exhausted records with one through five fields still had losses, and ordinary direct scans also paid for the additional descriptor check. These measurements time lookup on prebuilt descriptors. They exclude construction, replay and whole-compiler costs.

[Native data for all six variants, descriptor construction and timing drivers](first-name-and-packet-comparisons.tar.xz)

## Resolving direct names before promoted records in balanced whole compilations

In each of eight rounds, two baseline labels and two candidate labels each ran four fresh compilations. The launch order rotated. The candidate column is the median ratio of the two candidate cycle counts combined to the two baseline counts combined. The last two columns compare the paired labels of the same executable and show variation within this experiment.

| Tier | Corpus | Candidate user cycles | Rounds meeting baseline | Baseline label 2 vs. 1 | Candidate label 2 vs. 1 |
| --- | --- | ---: | ---: | ---: | ---: |
| tier0 | lua | +0.016% | 3/8 | +0.051% | +0.116% |
| tier0 | sqlite | -0.082% | 5/8 | -0.051% | +0.125% |
| tier0 | musl | -0.355% | 8/8 | -0.035% | +0.073% |
| tier1 | lua | +0.160% | 0/8 | +0.053% | -0.009% |
| tier1 | sqlite | +0.112% | 1/8 | -0.007% | -0.017% |
| tier1 | musl | -0.045% | 7/8 | +0.066% | +0.027% |

This alternative checks a direct name before visiting a promoted record. Both executables produced identical debug objects and diagnostics for all 1,371 translation units at each tier. The candidate median met baseline in three of the six configurations. All 48 process groups finished successfully.

[Implementation patches, native type checks, five-round compilations and output hashes](resolved-lookup-source-and-outputs.tar.xz)

[Round medians, complete process records and runner](resolved-lookup-balanced.tar.xz)
