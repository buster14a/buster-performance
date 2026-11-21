# Default production return-fact evaluation on the Ryzen 7 9700X

Default demand-driven evaluation cut SQLite compile time by 1.995 ms at the paired median and saved 15.22 total cycles per preprocessed token. All seven wall comparisons and all seven cycle comparisons favored the production compiler. The median per-compile time changed from 121.009 to 119.061 ms, and retired user instructions fell by 20.96 million. The 116 recorded compiler outputs matched within each of the three test sources.

Both smaller translation units saved retired instructions. Lua’s parser saved 288,968 per compile, with all three wall comparisons favoring the new compiler and cycle differences on both sides of zero. musl’s `vfprintf` saved 334,581 instructions and reduced cycles in all three pairs. Its elapsed-time differences crossed zero.

Both compilers used the ordinary `-c` command. The production change runs through the default path. The two builds had no diagnostic environment settings and each compilation ran on CPU 2 under the shared host lock. The comparison used a separate dedicated wall-time series and collected cycles and instructions in both user and kernel mode.

| Source | Bytes | Preprocessed tokens | Pairs per series | Median baseline cycles/token | Median production cycles/token | Paired total cycles/token, median [min, max] | Paired user instructions, median | Paired wall ms, median [min, max] |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| [sqlite](sqlite/README.md) | 9,507,037 | 716,136 | 7 | 936.7660 | 920.2512 | −15.2178 [−39.5855, −10.1991] | −20,955,068.5 | −1.9950 [−2.5040, −1.4485] |
| [lua-parser](lua-parser/README.md) | 56,339 | 24,078 | 3 | 1510.9174 | 1522.0267 | +11.1094 [−37.8229, +22.3843] | −288,968.0 | −0.1530 [−0.2840, −0.0065] |
| [musl-printf](musl-printf/README.md) | 16,763 | 16,184 | 3 | 1588.1538 | 1570.0901 | −29.2457 [−34.3076, −0.5944] | −334,581.0 | −0.1080 [−0.1605, +0.1225] |

The unmodified source revision was `875c08e9dd85c4c67bbe24a00e54bbe33f0890b5` with Release executable SHA-256 `643825d1f8c7c2281a299c766f1c14c62e2646b2f9dd1e1fbd9d65e255fa7f98`. The signed production revision was `fde14be84c074a65e8219f82c73202355635cfe1` with executable SHA-256 `653cfea8723183100eaad6c86908bab4a6285bd372241487cb5b771db74525e6`. The [production patch](production.patch) has SHA-256 `130be6b806648a5a3d659af1deff6cef09aa6a9333068808ff446a570427a031`.

Each round placed both executables in two symmetric slots and alternated the outer executable. The table gives differences within rounds before taking the median. [Exact flags](return-prod-one.sh), [scheduler](return-prod.sh), [mode and round selectors](return-prod-config.sh) and the [frozen driver method](../../window-compile-2850-2026-11-21/paired-driver/README.md) define the sampling. The [diagnostic precursor](../README.md) separately crossed demand-driven answers against the ordinary dense reference.

The [exact production-source checker and driver receipts](correctness/README.md) cover 848,394 checker assertions, 208,919 driver assertions and 18 parent/production object and diagnostic comparisons. Three cases exercise the corrected independent noreturn warning when return-type warnings are disabled.
