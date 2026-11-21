# Checked void-literal statement discards at 4d0bba342

The additional 5,403 admissions reduced the graph by 10,806 nodes. Every round used fewer cycles and less wall time than the immediately preceding assignment opt-in. The same-binary flag-off comparison spans zero for both metrics.

The candidate admitted 8,380 expressions and replaced 23,743 ordinary graph nodes with 8,380 summaries. The resulting graph contained 308,260 nodes, 15,363 fewer than ordinary compilation.

| Mode | Cycles/token (user + kernel) | User instructions | Wall ms | MB/s |
| --- | ---: | ---: | ---: | ---: |
| preceding assignments opt-in | 936.8952 | 1,340,045,319.5 | 121.8685 | 78.011 |
| candidate flag off | 930.0818 | 1,346,114,372.5 | 121.0345 | 78.548 |
| candidate flag on | 928.2929 | 1,327,447,724.5 | 120.7495 | 78.734 |

| Paired change, median (minimum to maximum) | Opt-in minus preceding control | Opt-in minus same-binary flag-off |
| --- | ---: | ---: |
| Cycles/token | -9.6079 (-16.2636 to -7.3100) | -3.4258 (-9.1179 to +1.7129) |
| User instructions | -12,597,553.0 (-12,598,864.5 to -12,596,129.5) | -18,666,706.5 (-18,667,688.0 to -18,666,600.5) |
| Wall ms | -1.1635 (-13.4755 to -0.8930) | -0.3855 (-0.5795 to +0.6270) |

PMU process page faults ranged from 5,659 to 5,673. The wall samples had 5,766 to 59,949 child minor faults. The assignment parent had 59,949 minor faults and a 149.023 ms wall sample in round 2. Omitting that whole round gives an on-minus-parent median of −1.1413 ms (−1.2235 to −0.8930). The corresponding on-minus-off median is −0.3953 ms (−0.5795 to +0.4660). All PMU samples remained in the lower fault band.

Every one of the 90 observed non-warm-up compiles produced the same 2,061,192-byte object with SHA-256 efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa. Default diagnostics and stdout were empty. In the three warning compiles, stdout remained empty and each stderr had 3,701 bytes with SHA-256 a3137fb77b1b62c77da81db5afea4606c4e50940f8fe52656b9c71ce2a2bfc6c.

The candidate is 4d0bba342eb2d9eebf149bd3bd67b82023406a7b (Release binary SHA-256 7cb1d94d0155c36182a289be2c1693c86a7aeecb1e4e154f28ff2d9af0c657f7). The control is 39cd1b6ce77f2289a56ec0d1de2f5044e1607979 (Release binary SHA-256 87ba92c216cb2aa2762acbc36a591c9cc850bd102cf1f675621850869752eced). The included source patch applies to the control source.

[Method and scripts](../paired-driver/README.md) · [PMU samples](pmu.tsv) · [Elapsed samples](wall.tsv) · [Wall faults](wall-faults.tsv) · [Raw counters and stage reports](process-counters.tar.xz) · [Child time reports](wall-reports.tar.xz) · [Warning digests](warnings.tsv)

The [independently rotated comparison](cumulative/README.md) measures the same candidate alongside ordinary main, the returns and reads stages, and a duplicate-executable control.
