# Folding scalar floating precision conversions

A separate #2829 experiment folds the single-use floating operand of `cvtss2sd` and `cvtsd2ss`. The [first prototype](zeroing-prototype.patch) clears the destination to break the legacy instruction’s read dependency. The [second](direct-prototype.patch) emits just the conversion. Their source bases are `450efe4c01f19148e691a82ffce7197c3b6c362e` and `450efe4c01f19148e691a82ffce7197c3b6c362e`. Both variants remain experimental.

The oracle exercises ordinary, indexed, packed and looped loads at the edge of an accessible memory page. Each of 16 binaries across four ISAs passed 526,336 comparisons of result bits and six MXCSR flags with hardware instructions. Inputs include infinities, signaling and quiet NaNs, normals and subnormals, four rounding modes, four DAZ/FTZ combinations and preexisting flags. [Objects, executable hashes and results](oracles.tsv)

The zeroing prototype changed seven of 1,336 musl objects, with six smaller text sections and seven fewer text bytes in aggregate. In the separate streaming loop, the baseline's rolled and eight-way bodies occupy 29 and 221 bytes. Zeroing uses 28 and 212, and omitting it uses 25 and 185. [Musl object comparisons](objects.tsv) and [all 64 program identities](loops/programs.tsv)

The local Ryzen 9 7940HS timing experiment has 768 process samples. Seven counterbalanced comparisons follow warm-up at each input precision, unroll setting, placement and initial upper-register state. With the zeroing idiom the paired cycle medians range from −1.38% to +2.92% in clean state and −1.33% to +3.78% in dirty state. Omitting the zero slows every clean case (+45.64% to +178.08%) and speeds every dirty case (−26.67% to −24.20%). The driver checks the entire output buffer. A native Zen 5 comparison is pending. [Paired medians](loops/paired.tsv) and [individual counters](loops/counters.tsv)

## Reproduce the experiment

Apply the accompanying patches to separate checkouts at their recorded bases. Build all three Buster compilers for the same host target. Export `PARENT`, `ZERO` and `DIRECT` as absolute paths to those executables and set `CC` to the pinned Clang. Run `bash verify.sh`, then `bash verify-nozero.sh`. From this directory, `python loops/compare.py build` prepares and verifies the placed kernels, and `python loops/compare.py time` measures them on an available pinned core.
