# Dense directive placement on the Ryzen 7 9700X

The windowed preprocessor records one bit per directive token. On base `6ac6c1d5a`, a word with 17–64 bits set took a scalar loop and a second pass to add the word offset. Head `1cf8a0cb3` compresses the bit positions once, widens consecutive groups of 16 to dwords, and masks the last store. [Compiler issue #3439](https://github.com/buster14a/buster/issues/3439)

## Kernel timing

The gate compiled the two functions in separate translation units with Clang 23.1.4, `-O3 -march=znver5 -fno-strict-aliasing -funsigned-char -fwrapv`. Both used identical masks in each sample. CPU 2 ran the harness under `exclusive.sh`. Each of nine rounds alternated which implementation ran first and also timed base a second time. Each cell below is the range of median head ticks divided by median base ticks across the individual densities. The empty column has one density. [Raw samples](samples.tsv)

| Input words | Empty | 1–16 bits | 17–64 bits |
| ---: | ---: | ---: | ---: |
| 1 | 0.774 | 0.751–0.812 | 0.106–0.254 |
| 8 | 0.785 | 0.879–0.883 | 0.074–0.143 |
| 9 | 0.790 | 0.851–0.862 | 0.076–0.152 |
| 512 | 0.921 | 0.915–0.941 | 0.093–0.154 |

To repeat, set the lock owner, title and issue link as described in the compiler’s benchpress guide, and run `./replay.sh BUSTER_CHECKOUT OUTPUT_DIRECTORY` on the 9700X. The checkout must contain both revisions. The script extracts the kernels from Git. [Harness](gate.c) · [Replay script](replay.sh)

## Whole preprocessor

An instrumented base Release counted 18,226 words in SQLite’s windowed file, including 4,055 nonempty words and 36 with more than 16 directives. The largest contained 23. The Lua and musl invocations used whole-file preparation throughout. A 500-null-directive fixture with `--window-bytes 64` reached eight dense words and a maximum of 64.

The uninstrumented base and head produced identical `-E` stdout and stderr on SQLite, the 34 Lua units, 1,336 musl units, and the dense fixture. Three locked `ab` rounds ran `time-runs --runs 3` on CPU 2. Each cell below gives the three rounds’ median user-cycle change relative to base. The control ran the base executable again. [Driver logs and output digests](driver-logs.tar.gz)

| Corpus | Head | Control |
| --- | --- | --- |
| SQLite | −0.25%, +0.11%, +0.23% | +0.40%, +0.12%, +0.05% |
| Lua | +0.09%, +0.38%, +0.23% | +0.02%, +0.37%, +0.39% |
| musl | +0.36%, −0.29%, +0.18% | −0.00%, −0.25%, −0.41% |

The placement test checks cardinality, membership and strict order with both buffers ending at guard pages. The isolated test passed all 1,041 cases under ASan and UBSan. Fault insertion detected an incorrect word base, a wrong lane permutation, skipping a partial group, an incorrect final store mask and an unmasked partial input load.

The integrated Release suite passed `test-preprocessor --clang --jobs 4 --fuzz 64` with the pinned Clang 23.1.4 on `PATH` and `BUSTER_CLANG_RESOURCE_DIR` set to its resource directory, as in 9700X CI.
