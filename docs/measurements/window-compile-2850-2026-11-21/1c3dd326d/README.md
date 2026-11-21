# Default packed singleton expression chains across four complete corpora

Both exact Release compilers ran ordinary `--lanes 1 -c` on the locked Ryzen 7 9700X. The unmodified baseline was `6e9c51b9d238734468dccc03ab1b6c715449804e`, executable SHA-256 `4e5c9d27a80a151bbf0d9cf4f9b6be43a56ac42a5a1b36811170c26d78b93f1c`. The candidate was `1c3dd326dada28dd227abc738eb042e6ad764932`, executable SHA-256 `8be01620867fd77c14f5946ba30fbc0d7fd9566b3f4405f5f9bddd2323c6ed9a`. Graph sampling, mode overrides and poisoning were unset. Each corpus used seven independent PMU and seven independent child-wall rounds, alternating A-B-B-A with B-A-A-B. Every wall observation followed one warm-up of the same binary and command.

| Corpus | Units | Tokens | Wall ms, baseline → candidate | Paired wall ms, median [min, max] | Paired cycles/token, median [min, max] | Paired user instructions, median |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| [sqlite](sqlite/README.md) | 1 | 716,136 | 120.705 → 120.121 | −0.5205 [−1.2315, +0.7610] | −4.6458 [−10.0821, +1.2333] | +5,494,409.5 |
| [lua](lua/README.md) | 34 | 571,543 | 73.186 → 73.435 | +0.2490 [−0.3820, +0.3985] | −0.0144 [−6.3374, +2.6644] | +2,137,385.0 |
| [musl](musl/README.md) | 1,336 | 5,039,639 | 658.966 → 662.661 | +3.6220 [+2.0280, +6.2695] | +2.3315 [−2.5379, +3.2161] | +19,202,720.5 |
| [main](main/README.md) | 1 | 2,433,922 | 688.620 → 687.924 | −1.3155 [−3.7975, +2.4045] | +0.2137 [−10.8969, +9.7027] | +37,694,412.0 |

Each of the 62 timed and qualification invocations per corpus produced the same complete object manifest. This covers 85,064 captured object outputs. The multi-file Lua and musl series used one complete driver invocation each. Their token counts came from separate single-unit compiles that matched every corresponding object. The Buster corpus was `main.c` from 84a7d3d76 with [frozen predefines](proof-predefines.h) SHA-256 `40159bd8f0802b54dfc139a19f55df8d7b6adc1dec44d493ea9809ba5549bb00`.

The [exact source patch](production.patch), [trial command](full-chain-1c3-one.sh), [scheduler](full-chain-1c3.sh), [per-unit token audit](full-chain-tokens.py), [manifest verifier](full-chain-manifest.py) and [corpus definitions](corpora.sh) specify the inputs and measurement.

The candidate retired more user instructions in all seven rounds on each of the four corpora. The full musl compile took longer in every independent wall round. The other three wall intervals crossed zero. The [checker, driver, MSan and tracked-source qualification](correctness/README.md) covers the final source and the corrected statement-expression case.
