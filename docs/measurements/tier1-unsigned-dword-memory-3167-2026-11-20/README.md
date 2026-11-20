# Unsigned dword memory conversions in Tier 1

[PR #3167](https://github.com/buster14a/buster/pull/3167) compares parent #3120 `e28bcb9f09e36868a6330df4554deb900790db19` with `896bfdeef094c65e2d04a73e305d7596447dd7c9`. Both precisions use the existing single-use load fold. The exact AVX-512F memory form must be allowed for each precision. The fallback explicitly zero-extends the four-byte load. The recorded timings were taken on a Ryzen 9 7940HS targeting znver5.

| Workload | Retired instructions | User cycles |
| --- | --- | --- |
| Rolled conversion, 16 comparisons | −21.95% to −21.96% | −45.75% to +0.76%, 15 lower |
| Eight-way unrolled conversion, 16 comparisons | −26.27% to −26.28% | −32.41% to −2.78%, all lower |
| libtiff metadata, 64 samples, 8 comparisons | −0.20% to −0.21% | −1.62% to +0.47%, 5 lower |
| libtiff metadata, 4,096 samples, 8 comparisons | −2.55% to −3.97% | −24.65% to +14.88%, 5 lower |

Each number summarizes seven post-warm-up alternating-order pairs for that case. Float/double conversion kernels use four placements and two incoming upper-vector states. For znver5 the functions shrink from 35 to 30 bytes rolled and from 268 to 223 bytes unrolled. Every invocation checked its output. [512 loop process observations](loops/counters.tsv.gz) · [loop sizes](loops/objects.tsv).

The libtiff program builds unmodified 4.7.1 `tif_dirread.c` using Clang or the two Buster compilers. The remaining library has the same Clang build throughout. It reads valid little- and big-endian files through the public API, checks every SMIN/SMAX double and REFERENCEBLACKWHITE float, and repeatedly reparses the directory. There are nine new memory instructions in seven functions, which lost 32 function bytes combined. Six files with 64, 1,024 and 4,096 samples passed all 72 compiler and placement checks. [Sites](tiff/sites.tsv) · [program identities and verified output](tiff/programs.tsv.gz) · [256 timed processes](tiff/processes.tsv.gz).

The independently decoded Zstandard corpus preserved all 288 compressed and uncompressed hashes. Its frame generator had identical parent and candidate function sizes. The eight default-validation cycle medians ranged from −0.96% to +0.73% on 128 processes. All 1,336 musl objects built and were byte-identical. [Frames](zstd/frames.tsv.gz) · [musl objects](musl/objects.tsv.gz).

The exact public revision passed the four focused compiler suites and reproduced all 65 oracle configurations and all 24 conversion-loop object hashes used for timing. Each of 30 general configurations passed 1,024,000 independent integer-oracle, MXCSR and side-effect checks. Each of ten pressure configurations passed 786,432 spill checks and 16,384 MXCSR checks. Each of 25 memory configurations passed 262,144 ordering, bounds and rounding checks and four real fault outcomes. The committed compiler reproduced the libtiff and Zstandard timed object bytes. [Memory checks](edges/results.tsv) · [timed application objects](exact/apps.tsv) · [committed-head log](suites/committed-head.log.gz).

The earliest unpublished trial reused the address scale for the conversion kind. Eight pre-existing signed-conversion assertions and the libtiff oracle caught it. The committed rule carries the conversion kind independently. The original failing logs are retained under [initial-prototype](initial-prototype/).
