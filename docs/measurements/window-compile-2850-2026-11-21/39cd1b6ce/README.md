# Assignment and retained native rows at 39cd1b6ce

The additional 763 admissions reduced the graph by 2,289 nodes and retired fewer instructions. Cycles per token rose in every paired round against both the preceding opt-in and this binary with its flag off.

The candidate admitted 2,977 expressions and replaced 7,534 ordinary graph nodes with 2,977 summaries. The resulting graph contained 319,066 nodes, 4,557 fewer than ordinary compilation.

| Mode | Cycles/token (user + kernel) | User instructions | Wall ms | MB/s |
| --- | ---: | ---: | ---: | ---: |
| preceding reads opt-in | 931.4937 | 1,340,753,048.5 | 120.8360 | 78.677 |
| candidate flag off | 932.2938 | 1,346,114,407.5 | 120.9600 | 78.597 |
| candidate flag on | 936.2297 | 1,340,045,303.0 | 121.7905 | 78.061 |

| Paired change, median (minimum to maximum) | Opt-in minus preceding control | Opt-in minus same-binary flag-off |
| --- | ---: | ---: |
| Cycles/token | +6.4791 (+0.5750 to +12.8405) | +3.6142 (+0.3504 to +10.3827) |
| User instructions | -708,072.5 (-709,199.5 to -707,711.0) | -6,069,086.5 (-6,070,619.0 to -6,069,079.5) |
| Wall ms | +0.8490 (-5.5990 to +1.3890) | +0.7140 (-12.0190 to +1.6810) |

PMU process page faults ranged from 5,660 to 5,670. The wall samples had 5,768 to 60,045 child minor faults. One ordinary flag-off sample in round 2 took 147.360 ms and had 60,045 minor faults. Dropping that entire round gives an on-minus-off median of +0.7723 ms (+0.3690 to +1.6810) and an on-minus-parent median of +0.7320 ms (−5.5990 to +1.3890). Another preceding opt-in sample took 136.285 ms with 5,780 faults. All PMU samples remained in the lower fault band.

Every one of the 90 observed non-warm-up compiles produced the same 2,061,192-byte object with SHA-256 efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa. Default diagnostics and stdout were empty. In the three warning compiles, stdout remained empty and each stderr had 3,701 bytes with SHA-256 a3137fb77b1b62c77da81db5afea4606c4e50940f8fe52656b9c71ce2a2bfc6c.

The candidate is 39cd1b6ce77f2289a56ec0d1de2f5044e1607979 (Release binary SHA-256 87ba92c216cb2aa2762acbc36a591c9cc850bd102cf1f675621850869752eced). The control is 227853575f341342bb02e6b4c38c79044ce691bc (Release binary SHA-256 40eb5cb1f9015f76232e62ea06efc931c659fee590481f3679bfdb33820bc6ba). The included source patch applies to the control source.

[Method and scripts](../paired-driver/README.md) · [PMU samples](pmu.tsv) · [Elapsed samples](wall.tsv) · [Wall faults](wall-faults.tsv) · [Raw counters and stage reports](process-counters.tar.xz) · [Child time reports](wall-reports.tar.xz) · [Warning digests](warnings.tsv)
