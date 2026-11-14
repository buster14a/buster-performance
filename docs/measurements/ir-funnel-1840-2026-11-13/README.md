# buster#1840's funnel shifts and rotates: Zen 5 rows, machine rows and compile time

buster#1840 item 4's last family: a ternary `funnel` intrinsic (`2f6fb2ef`). It takes clang's `fshl`/`fshr` rows
(`vpshldv`, `vpshrdv`) and the rotates by an immediate (`vprold` to `vprorq`), and Tier 1 selects the immediate
rotates back. This records:
- the 9700X's measurement of the 36 forms that had no Zen 5 row;
- the machine rows of main against the whole series;
- the compile time of main against the series' head `dba29d02`. The series is the byte shuffles, the carriers, the bit
  shuffles, the quadword operations and the funnels.

## Zen 5 rows

- **Host:** benchpress (AMD Ryzen 7 9700X); `../ir-shuffle-immediates-1840-2026-11-13/host.txt` has its kernel, clang
  and governor.
- **Build:** buster `2f6fb2ef`, the funnels' commit, with its 36 rows `U`. It was sent to the host as a git bundle before
  it was pushed, and is pushed unchanged.
- **Build command:** `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0` under one hold of the lock (`rows-build.log`);
  `rows-binary.txt` has its SHA-256.
- **Command:** `measure-x86-zen5 --missing --table`, pinned to CPU 2 under a second hold (`run-rows.sh`).

**Lock receipts:** `rows-holds.txt` and `time/time-holds.txt` have each hold's owner line. `exclusive.sh`'s wait
blocks (other sessions' commands, titles and links) are removed from the `.log` and `.err` files and
`rows-errors.txt`, each from its `exclusive.sh: waiting` line through its `link:` line.

`rows.txt` holds the 36 rows. Every one, `vpshldvw` to `vpshldvq` and `vpshrdvw` to `vpshrdvq`, `vprold` to `vprorq`
and `vpshldw` and `vpshrdw` by an immediate, at 16, 32 and 64 bytes:
- latency 512 (2 cycles);
- throughput 128 (2 per cycle);
- 256 macro-ops (one).

## Machine rows

Both compilers compiled buster `dba29d02`'s sources by
`--tier1 --tier1-report -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing`. They are Develop builds in
the cloud session, with the first record's counting aid; these are counts, not timings. `machine-rows.txt` holds them.

| Unit | Rows, main `26f0bb0e` | Rows, `dba29d02` | Records, main | Records, `dba29d02` |
| --- | ---: | ---: | ---: | ---: |
| `main_unit_frontend.c` | 1 | 1 | 635,525 | 635,525 |
| `main_unit_backend.c` | 268 | 92 | 1,613,912 | 1,613,870 |

Row moves 195 → 154 and spills equal. The funnels take the last 4 rows of these families: 3 `vpshrdvd` (with their
moves) and 1 `vprold`. The 92 left are 74 gathers and a scatter, 13 compress-stores and 4 masked truncations.

## Compile time

`time/time-g3.sh` measured two compilers built on the 9700X:
- **base:** main `26f0bb0e`, the first record's build (the same binary: `time-binaries.txt`);
- **head:** `dba29d02`, built under one hold.

**Command:** the head's `time-runs --runs 11 --warmups 2`, pinned to CPU 2, one hold per mode, on `main.c` of the
head's sources: `-c` and `--tier1 -c`, at `-march=znver5 -fwrapv -funsigned-char -fno-strict-aliasing -o /dev/null`.

| Median of 11 | base | head | head against base |
| --- | ---: | ---: | ---: |
| `--tier1 -c main.c`, wall | 1,191.5 ms | 1,189.0 ms | −0.21% |
| `--tier1 -c main.c`, user cycles | 6,251.7 M | 6,233.2 M | −0.30% |
| `--tier1 -c main.c`, instructions | 19,803.6 M | 19,799.2 M | −0.02% |
| `-c main.c`, wall | 687.2 ms | 686.0 ms | −0.17% |
| `-c main.c`, user cycles | 3,479.3 M | 3,474.2 M | −0.15% |

The wall-time ranges overlap (`--tier1`: base 1,187.9–1,197.1 ms, head 1,185.4–1,202.2 ms), so this is within noise.
