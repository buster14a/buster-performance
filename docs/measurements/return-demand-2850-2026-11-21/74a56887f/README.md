# Corrected production build of demand-driven return facts

The corrected default compiler saved 11.66 total cycles per preprocessed token and 1.866 ms per SQLite compile against pristine 875c08e9d. All seven PMU pairs and all seven independent wall pairs favored the corrected source. In a separate build comparison, the [complete ELF section inventory](native-sections.tsv) isolated the binary difference from its predecessor to `.debug_line`. Every allocated section had the same contents, address and size. The [exact Develop and self-host receipt](develop-and-self-host.txt) also confirms that the corrected lean self-compile succeeds.

The signed corrected source, `74a56887f46611325fbfe2a17166f016e68c1342`, adds an unused-function attribute to the dense diagnostic oracle for lean self-host compilation. The previous exact source was `fde14be84c074a65e8219f82c73202355635cfe1`. The build used the same absolute paths, native compiler toolchain, configuration and build script as its predecessor on the 9700X. The tested pristine base was `875c08e9dd85c4c67bbe24a00e54bbe33f0890b5`. The complete [production source patch](production.patch) has SHA-256 `1eeb17360db62ebb6efca1f6dd71c25db9f42b1756a0d47ec8b6e8c05c966418`.

| Source | Native Release binary SHA-256 |
| --- | --- |
| 875c08e9d pristine | `643825d1f8c7c2281a299c766f1c14c62e2646b2f9dd1e1fbd9d65e255fa7f98` |
| fde14be84 before the attribute | `653cfea8723183100eaad6c86908bab4a6285bd372241487cb5b771db74525e6` |
| 74a56887f corrected | `1adf04d0721ff85688929ef4c294bffb540e7ef8575a707d35a0f91a4d3b1305` |

The complete executable digests differed. Consequently both this corrected compiler and the unmodified base underwent fresh seven-round ordinary SQLite `-c` measurement. PMU and true child wall time were measured in separate series. Each round used two symmetric positions per binary and changed which binary occupied the outer positions. The [exact invocations](return-corrected-one.sh) and [order](order.tsv) record all flags and positions.

| Metric | Pristine median | Corrected median | Paired median [min, max] |
| --- | ---: | ---: | ---: |
| cycles/token | 934.0343 | 922.4241 | −11.6646 [−19.0274, −5.4921] |
| user cycles/token | 824.0582 | 811.3243 | −11.4214 [−17.7752, −6.2801] |
| kernel cycles/token | 114.2826 | 112.5975 | −0.0192 [−2.9085, +1.1301] |
| total instructions | 1,382,367,037.0 | 1,361,473,547.0 | −20,927,043.5 [−21,243,118.0, −20,712,840.0] |
| user instructions | 1,347,887,606.0 | 1,326,932,500.5 | −20,955,120.0 [−20,955,930.0, −20,954,467.5] |
| kernel instructions | 34,480,065.0 | 34,541,539.5 | +28,161.0 [−288,038.0, +243,090.0] |
| PMU process faults | 5,663.5 | 5,660.0 | −4.0 [−5.0, −1.5] |
| wall ms | 121.4265 | 119.6045 | −1.8660 [−2.3220, −1.2605] |
| wall minor faults | 5,771.5 | 5,768.5 | −3.0 [−3.5, −2.0] |

All 60 recorded objects matched at 2,061,192 bytes, SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Both warning policies had identical output. The denominator for cycles was 716,136 preprocessed tokens. [Raw process reports](reports.tar.xz), [per-position counters and faults](samples.tsv), [paired values](paired.tsv), [object receipts](objects.tsv) and [diagnostic receipts](diagnostics.tsv) accompany this comparison.

The [same-path build script](same-path-build.sh) preserves both complete Release executables for direct comparison.
