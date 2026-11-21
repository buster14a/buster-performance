# Current-main integration

Pristine b86eadcbd3d6c5cdf687f6b67b0281df2ac34034 plus the source lexer changes produces a1609b1e923184f18c30ff98275f54f99339312e. Its lexer source is byte-identical to adf1a57146b57f1f3e7ae82e12ff3ca1cfacc754, the qualified endpoint on the original comparison base. No other source changed in the replay.

The separate b86/a160 Develop and 9700X Release pairs each agreed in all 196 driver cases, including 159 ELF outputs, 13 diagnostic rejections, 2,587,151 preprocessing-output bytes and 26,027 diagnostic bytes. Twelve additional Develop command pairs cover the assembly-output path and error branches on this base. Full default preprocessing and refinement suites passed on the integrated Develop build. The Release build also passed the full refinement suite, including 50,570 spellings, 20,000 random inputs with 414,937 live IDs, and 9,600 guarded page-edge inputs.

| Build | Pristine executable SHA-256 | Candidate executable SHA-256 |
| --- | --- | --- |
| Develop | 28ea66f0133d48410906eede5f19fac7aeef7120a87f6b385db8ceb6449a7d6f | b23ce8f8ba8aae2982de43218ece431b0af3fd32048df7723e5ea964b46516e0 |
| 9700X Release | 06e22d737854b1308c2d2ac408b01574348e08ca07823114b993aaf271b563d3 | 78dfcbf8379f5ad35cf24aeb8b125072cbef327f8b0311c6e48d87df0ffd12f1 |

The existing repository lexer suite detects a private mutation discarding lanes that own only token ends. The C page-edge test then reports 3,058 different streams out of 35,200, and the number suite reports 6,665 different streams out of 80,946.
