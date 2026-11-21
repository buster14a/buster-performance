# Reuse the physical source-page scan to plan optional ranges

The experiment collects optional-region hints while computing the line index for admitted LF sources. On ordinary frozen SQLite it found 94 ranges in 6,966 pages. The previous implementation collected those hints in a separate whole-source scan. The ordinary preprocessor still resolves conditional directives and expands an admitted span when live execution reaches it.

| Frozen input | Preprocessing, fused minus separate scan (ms) | Fresh wall, fused minus separate scan (ms) | Fresh wall, fused minus original compiler (ms) |
| --- | ---: | ---: | ---: |
| SQLite | +0.204 | +0.094 | +0.597 |
| SQLite with extra features | +0.011 | -0.007 | +1.075 |
| SQLite shell | -0.020 | +0.107 | +0.261 |
| All branches active | -0.088 | -0.003 | +0.003 |

Five locked 9700X CPU 2 rounds followed one warm-up round. The stage/PMU command used explicit huge pages. Elapsed time used a separate fresh-process series with the ordinary page setting. The base, earlier cursor candidate, and current executable with the option disabled, separately collected, or fused have individual receipts. [Observations](observations.tsv) · [Paired medians and ranges](paired.tsv)

The full resolved preprocessor and parser witnesses matched across six workloads. All 2,744 object comparisons matched across the four real corpora and two warning policies. The line-boundary, status and rejected-input matrices also matched. Behavioral and timing measurements use the same source pin `875c08e9d`. [Witness hashes](oracles.tsv) · [Source patches, scripts and detailed receipts](receipts.tar.gz)
