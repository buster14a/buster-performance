# Native initialization for real window compilation at d1779cd3f

The opt-in path retired fewer user instructions. Both cycle and wall ranges span zero against ordinary main and against the candidate with its flag off.

The candidate admitted 1,507 expressions and replaced 3,068 ordinary graph nodes with 1,507 summaries. The resulting graph contained 322,062 nodes, 1,561 fewer than ordinary compilation.

| Mode | Cycles/token (user + kernel) | User instructions | Wall ms | MB/s |
| --- | ---: | ---: | ---: | ---: |
| ordinary main | 932.8560 | 1,343,997,319.0 | 121.2935 | 78.380 |
| candidate flag off | 930.3699 | 1,345,784,578.0 | 121.2145 | 78.432 |
| candidate flag on | 930.8709 | 1,340,657,736.5 | 120.9615 | 78.596 |

| Paired change, median (minimum to maximum) | Opt-in minus preceding control | Opt-in minus same-binary flag-off |
| --- | ---: | ---: |
| Cycles/token | +1.3517 (-9.5947 to +8.0935) | +0.3535 (-3.0319 to +10.8551) |
| User instructions | -3,339,579.0 (-3,339,610.0 to -3,339,208.5) | -5,126,869.0 (-5,127,501.5 to -5,126,448.0) |
| Wall ms | -0.0410 (-1.7720 to +1.0215) | -0.0705 (-1.1570 to +0.1505) |

PMU process page faults ranged from 5,657 to 5,671. The wall samples had 5,763 to 5,778 child minor faults.

Every one of the 90 observed non-warm-up compiles produced the same 2,061,192-byte object with SHA-256 efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa. Default diagnostics and stdout were empty. In the three warning compiles, stdout remained empty and each stderr had 3,701 bytes with SHA-256 a3137fb77b1b62c77da81db5afea4606c4e50940f8fe52656b9c71ce2a2bfc6c.

The candidate is d1779cd3faedc6dca8cd00a27cccc4c2abc2490c (Release binary SHA-256 99bd4d1d73f1f5a6b58b144f7fedb9a20f8c0defe7fdc411451153bcc065dd94). The control is bd35904be2f29a631661aa8abc5974c6db0002c7 (Release binary SHA-256 fcc04c8f284794ab31b2336f4f065945a0b59b2430c30ffe669eafa9104cfc8a). The included source patch applies to the control source.

[Method and scripts](../paired-driver/README.md) · [PMU samples](pmu.tsv) · [Elapsed samples](wall.tsv) · [Wall faults](wall-faults.tsv) · [Raw counters and stage reports](process-counters.tar.xz) · [Child time reports](wall-reports.tar.xz) · [Warning digests](warnings.tsv)
