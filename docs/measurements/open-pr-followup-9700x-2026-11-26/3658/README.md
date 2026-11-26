# Ryzen 7 9700X measurements for PR 3658

[3658](https://github.com/buster14a/buster/pull/3658) at `3d48a78e9f6ee277c8d041022da296086c6a84f3` versus merge base `74eacd4744a8131ba4c1a5bd8ad87b89ec0f7dbe`.

| SQLite compile mode | Median wall, base → head | Median user cycles, base → head | Object bytes |
| --- | ---: | ---: | --- |
| Default | 15.296 → 15.344 ms (+0.31%) | 75.6M → 75.8M (+0.26%) | Match |
| Tier 1, -O2 -march=znver5 | 605.168 → 606.057 ms (+0.15%) | 3,256.1M → 3,261.6M (+0.17%) | Match |

Five alternating pairs per width, 20 million calls per sample. Both sides passed strict Tier 1 verification and matched the Clang checksum for every width.

| Kernel | Median base → head user cycles | Change | Median base → head user instructions |
| --- | ---: | ---: | ---: |
| 4 × u32 | 500.23M → 107.84M | −78.44% | 580.12M → 560.12M |
| 8 × u32 | 560.23M → 204.52M | −63.49% | 1,060.12M → 1,040.12M |
| 16 × u32 | 680.24M → 420.95M | −38.12% | 1,700.12M → 2,080.12M |

The four-lane kernel eliminated stack traffic. The eight- and sixteen-lane kernels still contained stack loads and stores. The sixteen-lane kernel retired 22.35% more instructions despite using fewer cycles.

[Measurement protocol](../README.md) · [Raw data and logs](raw.tar.gz)
