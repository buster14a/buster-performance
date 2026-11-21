# Bare local-read and warning retention at 227853575

The additional 707 admissions reduced the graph by 707 nodes. The comparison with the opt-in parent retired more user instructions. Its cycle and wall ranges span zero.

The candidate admitted 2,214 expressions and replaced 4,482 ordinary graph nodes with 2,214 summaries. The resulting graph contained 321,355 nodes, 2,268 fewer than ordinary compilation.

| Mode | Cycles/token (user + kernel) | User instructions | Wall ms | MB/s |
| --- | ---: | ---: | ---: | ---: |
| preceding returns opt-in | 930.6036 | 1,340,657,731.5 | 121.0720 | 78.524 |
| candidate flag off | 931.8422 | 1,346,137,069.0 | 120.9750 | 78.587 |
| candidate flag on | 931.1812 | 1,340,752,939.0 | 120.9810 | 78.583 |

| Paired change, median (minimum to maximum) | Opt-in minus preceding control | Opt-in minus same-binary flag-off |
| --- | ---: | ---: |
| Cycles/token | +2.3995 (-2.7176 to +4.2888) | -0.9097 (-4.4466 to +2.5379) |
| User instructions | +95,267.5 (+94,184.0 to +96,045.5) | -5,384,039.5 (-5,385,145.0 to -5,383,005.0) |
| Wall ms | -0.1270 (-0.6430 to +0.4905) | -0.0975 (-0.3740 to +0.3945) |

PMU process page faults ranged from 5,663 to 5,671. The wall samples had 5,769 to 5,778 child minor faults.

Every one of the 90 observed non-warm-up compiles produced the same 2,061,192-byte object with SHA-256 efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa. Default diagnostics and stdout were empty. In the three warning compiles, stdout remained empty and each stderr had 3,701 bytes with SHA-256 a3137fb77b1b62c77da81db5afea4606c4e50940f8fe52656b9c71ce2a2bfc6c.

The candidate is 227853575f341342bb02e6b4c38c79044ce691bc (Release binary SHA-256 40eb5cb1f9015f76232e62ea06efc931c659fee590481f3679bfdb33820bc6ba). The control is d1779cd3faedc6dca8cd00a27cccc4c2abc2490c (Release binary SHA-256 99bd4d1d73f1f5a6b58b144f7fedb9a20f8c0defe7fdc411451153bcc065dd94). The included source patch applies to the control source.

[Method and scripts](../paired-driver/README.md) · [PMU samples](pmu.tsv) · [Elapsed samples](wall.tsv) · [Wall faults](wall-faults.tsv) · [Raw counters and stage reports](process-counters.tar.xz) · [Child time reports](wall-reports.tar.xz) · [Warning digests](warnings.tsv)

The superseded pre-merge fix at 3c06b4abbab9ada53e8fb0bee572f0169ef5f678 also completed the three stage-instrumented compiles against 55700f5a4. All three produced the same object. The candidate's 2,214 admissions and 321,355-node graph match this merged-head result. That earlier comparison was checkpointed before its first PMU position. [Superseded stage receipts](pre-merge-stages.tar.xz)
