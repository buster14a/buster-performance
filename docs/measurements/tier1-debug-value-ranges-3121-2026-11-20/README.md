# Publishing Tier 1 debug value ranges in one pass

[Compiler PR #3121](https://github.com/buster14a/buster/pull/3121) compares base `8bfdf2f9584680af813f2adad7b139cf839afe8c` with `7dd1a7aba9a44c7423a884f174fe46e3a9f4912c`. The code change is `786e48c3be8ad0b42d04e5f91f3d0b5aac336612`. Rebuilding after the comment-only follow-up produced the same stripped executable. Both compilers used the repository Release build, `BUSTER_HOST_ARCH=znver5` and pinned Clang 23.1.4 at `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`. The compiler hashes are in `compiler-sha256.txt`.

## Work removed and local checks

A single-lane Ryzen 9 7940HS profile of Tier 1 compiling SQLite 3.53.2 with `-O2 -g` attributed 6.73% of user cycles to the value-range proof. The emitter had walked locations and assignments once to count and once to write each variable's ranges. It now extends the trailing output array when a range closes. The regression fixtures cover an output arena with exactly enough space and one a byte short.

The local SQLite compile retired 19,103,619,614 instructions on the base and 18,348,557,810 on the candidate. The difference is 755,061,804 or 3.95%. `local/sqlite.tsv` includes `-O0 -g` and `-O2 -g` and hashes the entire output. Both revision pairs matched byte for byte. All 1,336 optimized musl debug objects matched as well. The debug cross-check passed 4,059 checks, including GDB. The same command and the optimized SQLite debug compile completed under AddressSanitizer and UndefinedBehaviorSanitizer with halt-on-error enabled and leak detection disabled. LLVM’s DWARF verifier found zero errors. It reported 7,559 warnings about subroutine-type DIEs with a children flag and no children.

The SQLite source has SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. The compiler built it with `--tier1 -O2 -g -march=znver5 --lanes 1 -w -DSQLITE_THREADSAFE=0 -DSQLITE_OMIT_LOAD_EXTENSION -c`. Comparisons share a working directory and input spelling because debug objects record source paths. Run `python compare-musl.py BASE HEAD OUT --debug --corpus CORPUS` for the musl comparison.
