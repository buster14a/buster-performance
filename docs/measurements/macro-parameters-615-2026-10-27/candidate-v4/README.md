# Fourth candidate: near-baseline wall time, extra cycles for tiny lists

Source: Buster `69d138d7ac2c8b3b22ff6e1873bc13e4be80a3a6`.
Default executable SHA-256:
`806cff2d19397d058485e0010f0dc0c008516744a3746b1147269a2ea1eb0f83`.
Baseline and inputs are recorded in the parent report. This candidate uses
the same six frontend placements (0/704/1408/2112/2816/3520 bytes), three fresh
copies and three rounds as the final campaign. All three primary rounds
complete: 162 samples per build/input. All three after-scalar rounds complete:
36 per build/input, in the four-list order described in the parent report.
Every measured process exits zero. Samples are not pooled with another source.

The single-placement preliminary screen (42 per build/input) is retained
separately in `single-placement/`. Its results motivated the six-placement
check; it is excluded from `summary.tsv`.

For 10,000 definitions and first invocations (`summary.tsv`, lists 7–10):

| Parameters | Baseline wall ms | Candidate wall ms | Second baseline wall ms | Baseline cycles | Candidate cycles | Second baseline cycles |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 1.762 | 1.765 | 1.754 | 5,700,336 | 5,738,150 | 5,687,070 |
| 1 | 1.866 | 1.876 | 1.862 | 6,210,305 | 6,270,783 | 6,202,879 |
| 2 | 2.513 | 2.518 | 2.507 | 8,490,259 | 8,526,859 | 8,477,634 |
| 4 | 3.628 | 3.628 | 3.628 | 12,988,087 | 12,952,470 | 12,987,996 |

Wall changes are small, but zero/one-parameter user cycles rise by 0.66% and
0.97%, respectively, beyond the central A/A differences. Instructions rise by
0.84% and 1.44%. In the first round, both cycle comparisons' ranges over
placements exclude zero, while their wider placement-and-copy ranges include
it. Complete round-specific floors and distributions remain in the native
harness reports; no timing outlier is removed.

This version keeps large descriptor construction and lookup outside
`pp_compile_macro` and removes its added stack-protector check. It still forces
the definition's parameter parser inline: native `pp_define` is 4,659 bytes
against the baseline's 2,720. The next revision restores the parser's call
boundary, keeping this cold complexity outside the ordinary definition caller.

Large-list scaling gains remain in the retained full primary/after-scalar
results. Local/native release builds, complete Clang/preprocessor suites with
3,000 generated cases, call-graph checks, frozen SQLite (706,237 identical
tokens), and focused ASan+UBSan checks all pass for this revision. Its matching
logs, source/binary hashes, placement symbols and assembly are retained here.
