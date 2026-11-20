# DWARF region changes per local

[Compiler PR #3129](https://github.com/buster14a/buster/pull/3129) compares parent `2d4b2bdf588caafbf4fd40758308b7fd336ff79c` and head `0c8766eea35c44bd7f3638e2f05dd738ca95fc0c`. Both were built with the pinned Clang Release toolchain for the znver5 host. Local measurements used a Ryzen 9 7940HS, one compiler lane and eight alternating pairs after warm-up.

On SQLite, the parent visited 23,675,840 region boundaries while crossing source positions and newly queued 2,378,645 locals. The Lua VM visited 5,421,755 boundaries and newly queued 732,788 locals. The candidate stores each local’s preceding event in spare sort storage and reports the first occurrence in each crossed interval. The intermediate compact-only candidate coalesces adjacent end/start pairs, without the preceding-event index.

Compiler instructions fell 1.507% on SQLite `-O2 -g` and 9.285% on the Lua VM. The respective paired cycle changes were −0.874% (mixed individual signs) and −9.420% (every pair lower). Lua parser instructions fell 0.011%. The 1,336 musl debug objects, 70 SQLite/Lua application objects, both linked Lua binaries and ten script results matched the parent. The debug checker passed 4,064 checks, including forward and backward crossings, duplicated and already queued locals, boundary lanes, and the final partial group. Direct 9700X comparisons are pending.
