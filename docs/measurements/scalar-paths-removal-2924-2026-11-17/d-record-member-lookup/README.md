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
