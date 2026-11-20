# Fold a first FMA factor with proven operand priority

[PR #3142](https://github.com/buster14a/buster/pull/3142) compares [de4e763e86](https://github.com/buster14a/buster/commit/de4e763e8675b232169815ba0afae8025773783b) with [f90cd47781](https://github.com/buster14a/buster/commit/f90cd477811ce6510c8c850b11c2a6d9083d970f).

A loaded first multiplicand can occupy the x86 FMA memory slot when the other multiplicand is proven incapable of supplying a competing NaN. The selector keeps its second-factor and addend choices ahead of this case and reuses the existing load eligibility and address folding checks. It retains the register form when both factors might be NaNs. The fixture includes a volatile load, repeated use, an intervening store and each destination alias.

The parent and candidate each passed 360,448 hardware value and MXCSR comparisons in each of four target and scheduling configurations. The 44-leaf fixture grew from 22 to 38 memory-factor instructions. All 1,336 frozen musl objects matched byte for byte and the full C driver passed 196,392 checks.

In Vorbis 1.3.7 just one of 22 library objects changed. The floor fitter lost 32 text bytes. Its actual `accumulate_fit` function retired 1.66–4.63% fewer instructions and took 0.44–3.97% fewer cycles in all 16 distribution and placement comparisons on the Ryzen 9 7940HS. Its unchanged instruction bytes were promoted from the real application object for this timing. In the full encoder, instructions fell 0.04–0.14% in all 12 comparisons, and five took fewer cycles. Six builds with Clang and the successive Buster changes each passed the 528 upstream codec cases. All 96 encoded stream checks and 144 cross-decoder checks agreed.

Five Opus objects changed per build configuration. Encoder instructions ranged from 0.030% fewer to 0.003% more, and cycles varied across placements. All 30 upstream Opus test runs passed. These application timings are local. Direct 9700X application timing is pending.

Part of #2829. Stacked on #3139.

The [upstream Vorbis results](vorbis/official.tsv), [all stream and decoder hashes](vorbis/applications/), [production floor-fitting object and checks](vorbis/floor/), [Opus timings](opus/timing/paired.tsv), and [floating-point oracle](proven/checks.tsv) give the results per input. Each Vorbis floor distribution runs on four address placements. In the full codec the input, packet and output digests were identical for all six builds. The full driver used system Clang 23.1.6 and reports the skipped implicit-library-name comparisons for that reference version.
