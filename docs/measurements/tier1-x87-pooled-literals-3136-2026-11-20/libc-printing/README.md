# Static musl floating-point formatting

Four genuine musl v1.2.5 source objects supply `snprintf`, `vsnprintf`, `vfprintf` and `frexpl` in a complete static runtime. Link maps verified the source of each symbol. [Sources and object hashes](units.tsv) and [executable addresses and identities](programs.tsv) cover Clang and the Buster control, #3134, #3136 and #3138.

The [driver](printing.c) exercises hexadecimal, fixed, scientific, general, ordinary-double and positional conversions. It tests four rounding modes, 256 inputs, and five distinct destination sizes, including a null pointer and zero-length buffer. It checks untouched bytes beyond the produced output and records the return value, errno, x87 flags/TOP, MXCSR flags and every byte in the allocated buffer. All five builds agreed on all 30,720 records apiece. [Comparisons](comparisons.tsv).

The [648 local timing observations](counters.tsv.gz) used three Buster versions and four link placements. Each invocation renders 8,192 strings and checks a hash. In [eight measured pairs after warm-up](paired.tsv), hexadecimal long-double formatting used 0.52–1.23% fewer cycles with #3136 versus #3134 and 3.65–5.15% fewer over the full #3134/#3136 stack. Fixed and scientific formatting had changes in both directions. This experiment measures the complete formatting API and its fixed buffer-checking harness.
