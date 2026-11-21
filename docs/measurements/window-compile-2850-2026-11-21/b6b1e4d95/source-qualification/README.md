# Source-order lowering qualification

Clean revision `b6b1e4d95f22934d116305c445c684872b629200` and its parent `325883abf9607ac726966a0af2097377832d53ac` matched over 1,372 complete translation units under ordinary, `-Wall -Wextra`, and `-Weverything -Wno-c++-compat` compilation. Each pair checks the exit code, ELF contents, stdout and complete diagnostics. All eight local checker shards ran with seed 2850. The linked fixture compared 201 calls in each of six configurations. Its Clang and Buster checksums were 494089899 in all cases.

With Clang on PATH, run `bash focused.sh "$PWD" /absolute/path/to/head/compiler /absolute/path/to/base/compiler` in a writable copy of this directory. The separate [locked Release measurements](../README.md) exercise ordinary single-core SQLite and Buster builds.
