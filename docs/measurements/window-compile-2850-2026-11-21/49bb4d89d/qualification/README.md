# Source qualification

The candidate passed 850,925 checks across the eight checker shards and matched the unmodified parent in all 4,116 per-unit comparisons on SQLite, Buster, Lua and musl. A further 480 directed compilations matched exit status, diagnostic streams and object output across the recorded modes. The compressed tables retain the observations for each comparison. [Checker log](checker.log) · [Directed results](directed.tsv.gz)

## Source fixtures

The local Develop parent was `fbef2d68d`. Its only difference from the native timing parent `0e1d5b825` is documentation. The native timing runs used the exact baseline and source patch in the build receipts.

The [padded-source-cases](padded-source-cases.tar.xz) fixtures matched in 145 compilations across five modes. In 34 of those comparisons, the linked candidate and Clang executables also agreed on stdout, stderr and exit status. [Observations](padded-source-cases.tsv) · [Reproducer](verify-discard-fixtures.py)

## Graph coverage

The local debugger stopped at checker entry and counted physical graph records and annotated operands. SQLite has the same 716,136 tokens as the hardware input. The local Buster source has 2,433,563 tokens. The independently timed Buster source has 2,433,922.

| Local source | Tokens | Parent nodes | Candidate nodes | Prepared nodes |
| --- | ---: | ---: | ---: | ---: |
| sqlite | 716,136 | 323,623 | 295,115 | 28,508 |
| main | 2,433,563 | 1,407,416 | 1,382,139 | 25,277 |

[GDB breakpoint and reads](root-coverage.gdb). The offsets in this file are from the native layout of this candidate. The counts were collected outside the timed hardware processes.
