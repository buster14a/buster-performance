# Direct unsigned qword conversion on x86

[PR #3144](https://github.com/buster14a/buster/pull/3144) compares base `3804c5e7b9` with `91272118b3`.

Tier 1 can lower an unsigned 64-bit integer to float or double with `vcvtusi2ss` or `vcvtusi2sd` when the output target admits the corresponding register form. A zeroed merge operand breaks the destination dependency. The instruction respects MXCSR rounding. Each form has its own target check, and the existing software sequence serves baseline and AVX2 output. The same lowering is available in the straight-line and control-flow emitters.

Each build passed 1,361,920 result-bit and floating-exception comparisons against an independent integer rounding oracle. The inputs include both sides of ties near every relevant power of two, the full unsigned range, four rounding modes, pre-existing sticky flags, loaded operands and control-flow joins. Across five target configurations and default/post scheduling, the three configurations without AVX-512F produced identical parent/candidate objects. The two eligible configurations used direct conversions. The full compiler driver passed 196,392 checks with the pinned Clang reference.

On the local Ryzen 9 7940HS, float and double array conversion loops retired 57.53% fewer instructions when rolled and 62.42% fewer when unrolled eight ways. Across four entry placements and clean or dirty upper vector state, cycles fell 29.96–60.47%. In frozen musl one of 1,336 objects changed. The real `getloadavg` function shrank from 175 to 133 bytes. With a deterministic system-information provider, cycles fell 13.56–14.18% across four placements. Zstd’s `BMK_benchFunction` also lost 42 bytes. With a deterministic timer its instruction count fell 3.20% while cycles ranged from 0.53% lower to 1.72% higher.

Part of #2829. Measurements above are local. The two Zen 5 scheduler rows and direct 9700X runtime checks are pending.

The [integer reference](oracle.c) and [25 compiled configurations](results.tsv) independently check result bits and sticky flags. The [application runs](real/) use unmodified musl getloadavg and zstd benchmark sources, with deterministic system information and elapsed times supplied by the driver. The Clang reference used strict rounding and scalar code. Under ordinary optimized Clang, an unmasked vector conversion of unused system-information entries could set the inexact flag on an otherwise exact, one-element call. The strict scalar reference and both Buster versions agree. The [five actual SQLite workload hashes](sqlite/checks.tsv) agree across all three compilers. The [compile-time counter samples](compile-normal-summary.txt) use separate real application compilations.

The [SQLite JSON5 query](sqlite-json/) exercised the changed conversion 8,192 times on large values. Its four JSONB placements retired 0.811% fewer instructions and took 1.05–1.85% fewer cycles on the local Ryzen 9 7940HS.
