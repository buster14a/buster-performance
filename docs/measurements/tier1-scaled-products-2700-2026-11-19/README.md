# Integer products as scaled LEA operands on Zen 5

[Buster PR #3117](https://github.com/buster14a/buster/pull/3117) addresses the register base-plus-product cases of [#2700](https://github.com/buster14a/buster/issues/2700). Base is `3741c264fb349e86359acfd1c732ee1c2eaa4052`. Head is `735e25f71d2d6ee79a484f8d212648244dcb5894`.

## Generated machine code

Compile `leaves.c` with each Buster using `--tier1 --tier1-strict --verify -O2 -march=znver5 -c`. Four unshared scales went from two arithmetic instructions to one scaled LEA. Including the return, the function sizes were 8→5 bytes (64-bit ×2), 9→5 (64-bit ×4 and ×8) and 7→4 (32-bit ×4). The shifted, scale-16 and shared-product controls retained their code. The disassemblies capture every leaf and each separately compiled loop. The single arithmetic instruction can still have the same latency as the original pair.

## Dependent recurrence

The 9700X ran each program on CPU 2 under the shared per-run lock, with the performance governor and boost enabled. The host ran Linux 6.18.50-2-lts. `recurrence.c` feeds the previous result into a scaled add and an XOR with a right shift. The driver prints the final value. Scale 2 uses 32-bit unsigned arithmetic and scales 4 and 8 use 64-bit unsigned arithmetic. All 144 runs agreed with the reference.

| Scale | Measured pairs | Median base cycles/iteration | Median head cycles/iteration | Base retired instructions/iteration | Head retired instructions/iteration |
| --- | ---: | ---: | ---: | ---: | ---: |
| 2 | 20 | 3.0061 | 3.0061 | 8.0035 | 7.0035 |
| 4 | 20 | 3.0061 | 3.0061 | 8.0035 | 7.0035 |
| 8 | 20 | 3.0061 | 3.0061 | 8.0035 | 7.0035 |

Each program runs 32,000,000 iterations. Corresponding base and head kernels start at the same address. Four placements cover offsets 0/16/32/48 in a 64-byte line. Round 0 is warmup, followed by five measured rounds. Order alternates within pairs and rotates across rounds. The median paired cycle difference at every scale and placement rounds to 0.00%. Counters include process startup and the common driver. These observations cover dependency-chain latency at these placements.

To reproduce, run `CC=clang ./build-programs.sh /path/to/base/compiler /path/to/head/compiler > addresses.txt`, then `programs/oracle-2 32000000` (and the other scales) to check the expected output files. On the benchpress host set `EXCLUSIVE_OWNER` to your session, then run `./confirm.sh` from a fresh directory containing the harness, programs and expected outputs. A busy lease ends the command. Rerun later to resume missing samples. The captured binary hashes accompany the results. `raw.tsv` contains every counter and checksum, including warmups. `host-activity.tsv` contains the load readings around individual runs.

## Application checks

SQLite 3.53.2 amalgamation SHA-256 is `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. Compile with `--tier1 -O2 -march=znver5 --lanes 1 -w -DSQLITE_THREADSAFE=0 -DSQLITE_OMIT_LOAD_EXTENSION -c`. ELF `.text` is 1,441,816 bytes on both revisions. Of 1,316 text symbols, 20 shrank and one grew. The sum of function sizes grew by 10 bytes (1,431,625→1,431,635), including 80 extra bytes in `sqlite3WhereCodeOneLoopStart`. The linker’s section padding hides this difference in the section total. The changed symbols and both object digests accompany this record.

Build the matching SQLite `test/speedtest1.c` (SHA-256 `b5eaf4bbcbb320fd8eb3f3e6c4cd5f51a64dd0cd70efe969634d1785e3419675`) as a second object and link the corresponding pair. With `--memdb --verify --size 3 --testset main`, parent, candidate and Clang -O0 agree on the full verification hash. Timings printed in those local correctness logs are incidental.

Compile each Lua 5.4.8 source with `--tier1 -O2 -march=znver5 --lanes 1 -w -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX`. Of the 34 generated objects, only `lgc.o` changed. Link the Lua interpreter, omitting the separate luac driver. Its output for the repository's calls, tables, strings, arithmetic and closures scripts matches the parent and Clang -O0 byte for byte. The per-output SHA-256s accompany this record.
