# Emitting each inlined-subroutine range list once per DWARF writer pass

[Compiler PR #3123](https://github.com/buster14a/buster/pull/3123) compares parent `7dd1a7aba9a44c7423a884f174fe46e3a9f4912c` from PR #3121 with head `aba549e23cc0c6e75b2912fd4ce4ac5e980af133`. Both used the repository Release build, `BUSTER_HOST_ARCH=znver5` and pinned Clang 23.1.4 at `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`. The compiler hashes are in `compiler-sha256.txt`.

## Work removed and local checks

The writer used to scan the body's spans to determine whether an inline subtree has a range list, then scan again to emit it. The change saves the start offset and emits the list immediately. A subtree without spans consumes zero bytes. The outer DWARF measuring and emitting passes each use this operation.

On a Ryzen 9 7940HS the parent attributed 6.13% of sampled cycles to `check_debug_inline_ranges` on SQLite 3.53.2 at `--tier1 -O2 -g`. The candidate retired 17,142,876,815 instructions against 18,348,653,885 on the parent, a reduction of 1,205,777,070 (6.57%). Both SQLite objects and the 34 Lua translation units were byte-identical at each of `-O0 -g` and `-O2 -g`. Both Lua executables were byte-identical and passed all five workload output checks. All 1,336 optimized musl debug objects matched. The debug cross-check passed 4,059 checks, including nested inline frames and guarded sections.

The separate lexical-scope change from [PR #3118](https://github.com/buster14a/buster/pull/3118) at `e00b28f6cf0d3a1ab93bb4b0329eb1f49fe1c155` was applied to both parent and candidate. The two combined compilers each passed the 4,059 debug checks and produced the same complete optimized SQLite debug object (8,014,992 bytes, SHA-256 `0dbc531f11e0acb80d3c50d14bb03258ec57e8c41ce4ead78f1b3bc59b9e5a87`).

The SQLite input SHA-256 is `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. The one-lane flags and corpus definitions are in the supplied compiler harness. Run `python compare-musl.py BASE HEAD OUT --debug --corpus CORPUS` for the musl comparison. Use the same working directory for both builds' input files when comparing objects with source paths.
