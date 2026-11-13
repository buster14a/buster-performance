# buster#1840's bit shuffles and quadword operations: Zen 5 rows, machine rows and compile time

buster#1840 item 4's next families, after the byte shuffles by an immediate
(`../ir-shuffle-immediates-1840-2026-11-13`):
- **the casts into SSE carriers and their extensions** (`4807d05e`): `lane_extract` and `extend` of an `f32` or `f64`;
- **the bit shuffles into a mask** (`33ceffd2`): a `bitshuffle` intrinsic, `vpshufbitqmb`;
- **the quadword operations** (`6df967dc`): a `quadword_op` intrinsic, `vpmultishiftqb` and `vpsadbw`.

This records the 9700X's measurement of the 12 forms that had no Zen 5 row, the machine rows before and after, and the
compile time of main against all four families.

## Zen 5 rows

- **Host:** benchpress (AMD Ryzen 7 9700X); the first record's `host.txt` has its kernel, clang and governor.
- **Build:** buster `6df967dc`, the quadword operations' commit, with the 12 rows `U`. The session sent it to the host
  as a git bundle, before it was pushed. It is pushed unchanged, with branch `claude/trusting-thompson-ye0dvx`.
- **Build command:** `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0` under one hold of `~/buster-fast-bench/exclusive.sh`
  (`rows-build.log`). `rows-binary.txt` has the binary's SHA-256.
- **Command:** `measure-x86-zen5 --missing --table`, pinned to CPU 2 under a second hold (`run-rows.sh`).

**Lock receipts:** each hold's first command appended the holder's line of `/var/lib/buster-9700x/owner` to
`rows-holds.txt`. `exclusive.sh`'s wait blocks, which name other sessions' commands, titles and links, are removed
from the `.log` and `.txt` files, each from its `exclusive.sh: waiting` line through its `link:` line.

`rows-table.txt` is the measurement's output; `rows.txt` holds its 12 rows. In 1/256 cycle:

| Forms | Latency | Throughput | Macro-ops |
| --- | ---: | ---: | ---: |
| `vpshufbitqmb` k of 16 bytes, register and masked | 768 | 128 | 256 |
| `vpshufbitqmb` k of 32 bytes, register and masked | 1024 | 128 | 256 |
| `vpshufbitqmb` k of 64 bytes, register and masked | 1536 | 128 | 256 |
| `vpmultishiftqb`, every width | 768 | 128 | 256 |
| EVEX `vpsadbw`, every width | 768 | 128 | 256 |

## Machine rows

Both compilers compiled the same sources, buster `2f0aa376`'s (the families and their measured rows), by
`--tier1 --tier1-report -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing`. They are Develop builds in
the cloud session, with the first record's counting aid; these are counts, not timings. `machine-rows.txt` holds them.

| Unit | Rows, main `26f0bb0e` | Rows, `2f0aa376` | Records, main | Records, `2f0aa376` |
| --- | ---: | ---: | ---: | ---: |
| `main_unit_frontend.c` | 1 | 1 | 635,525 | 635,525 |
| `main_unit_backend.c` | 268 | 96 | 1,608,654 | 1,608,616 |

By family, in `main_unit_backend.c`:
- byte shuffles by an immediate: −98;
- carriers: −38;
- bit shuffles: −27;
- quadword operations: −9.

The 38 records fewer are the carriers' moves into their rows' roles: row moves 195 → 157, spills equal.

## Compile time

`time/time-g2.sh` measured two compilers built on the 9700X:
- **base:** main `26f0bb0e`, the first record's build (the same binary: `time-binaries.txt`);
- **head:** `2f0aa376`, built under one hold.

**Command:** the head's `time-runs --runs 11 --warmups 2`, pinned to CPU 2, one hold per mode, on `main.c` of the
head's sources: `-c` and `--tier1 -c`, at `-march=znver5 -fwrapv -funsigned-char -fno-strict-aliasing -o /dev/null`.
`time-holds.txt` has the lock receipts.

| Median of 11 | base | head | head against base |
| --- | ---: | ---: | ---: |
| `--tier1 -c main.c`, wall | 1,190.6 ms | 1,190.4 ms | −0.02% |
| `--tier1 -c main.c`, user cycles | 6,241.6 M | 6,238.4 M | −0.05% |
| `-c main.c`, wall | 688.4 ms | 687.8 ms | −0.10% |
| `-c main.c`, user cycles | 3,479.2 M | 3,475.0 M | −0.12% |

Within noise on both paths.
