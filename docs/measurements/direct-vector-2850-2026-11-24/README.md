# Fused AVX-512 direct-to-ELF64 compiler (`c_direct`, buster#2850) on the 9700X

Raw measurements collected on the approved AMD Ryzen 7 9700X (`benchpress`, Linux `6.18.50-2-lts`) under `~/buster-fast-bench/exclusive.sh` on 2026-11-24.

## Workload and build

- **Corpus:** frozen `sqlite3.c` (`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`), `9,507,037` bytes, sha256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.
- **Flags:** `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$SQLITE $SQLITE/sqlite3.c`.
- **Build:** `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release`, debug info stripped (`strip --strip-debug`), sha256 `e6b83184ae64b446be9ad9861de6a502a9a69a3b02c18d1af0bf5672c76d28af` (branch `antigravity/2850-fused-vector-direct`, based on `buster` `main` `26d0450d0`).

## Summary of results

### 8-core and 1-core `allcore counted` (`0` strays, `0` failures)

| Configuration | 1-core MB/s | 1-core wall | 8-core MB/s | 8-core wall | 8-core RSS | Speedup vs `main` (1c / 8c) | Delta vs `main` (8c) |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `main` (`--no-direct`, tmpfs) | 83.75 MB/s | 113.463 ms | 340.91 MB/s | 219.725 ms | 188.8 MiB | 1.00x / 1.00x | baseline |
| `c_direct` (`v4`, tmpfs) | **512.18 MB/s** | **18.377 ms** | **3,224.10 MB/s** | **23.573 ms** | **29.5 MiB** | **6.12x / 9.46x** | **+2.883 GB/s** |
| `c_direct` (`v4`, BTRFS disk) | **447.58 MB/s** | **21.091 ms** | **2,683.62 MB/s** | **28.279 ms** | **29.7 MiB** | **5.34x / 7.87x** | **+2.343 GB/s** |

Byte-for-byte determinism check: `cmp one.w0.o eight.w7.o` identical (`2,056,840` bytes, `-0.22%` vs `--no-direct`'s `2,061,432` bytes).

### Interleaved single-core `measure-compile --runs 7` on CPU 2

| Compiler | Median wall (range) | Throughput | User cycles | User instructions | Peak RSS | vs `c_direct` |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| **`c_direct` (default)** | **19.132 ms** (18.401–19.226) | **496.9 MB/s** | **91.7 M** (128.2 / tok) | **230.9 M** (322.8 / tok) | **38.0 MiB** | **1.00x** |
| `tcc` | 42.435 ms (42.123–42.846) | 224.0 MB/s | 219.1 M (306.3 / tok) | 537.6 M (751.5 / tok) | 13.3 MiB | 2.22x slower |
| `buster --no-direct` | 112.813 ms (112.194–113.252) | 84.3 MB/s | 545.6 M (762.8 / tok) | 1,273.0 M (1,779.7 / tok) | 240.6 MiB | 5.90x slower |
| `clang -O0` | 572.049 ms (571.074–574.010) | 16.6 MB/s | 3,064.2 M (4,283.8 / tok) | 6,646.9 M (9,292.4 / tok) | 191.6 MiB | 29.90x slower |
| `gcc -O0` | 1,938.599 ms (1,937.434–1,944.096) | 4.9 MB/s | 10,579.0 M (14,789.5 / tok) | 24,261.2 M (33,917.3 / tok) | 316.7 MiB | 101.33x slower |

### Un-multiplexed hardware counters (`perf stat -r 5` vs `-r 3`, CPU 2)

| Counter | `main` (`--no-direct`) | `c_direct` (`v4`) | Reduction |
| --- | ---: | ---: | ---: |
| `instructions:u` | 1,273,039,836 | **230,888,332** | **5.51x** |
| `cycles:u` | 547,874,768 | **91,530,596** | **5.99x** |
| `cycles:k` | 73,384,464 | **9,950,761** | **7.37x** |
| `branches:u` | 190,118,278 | **41,090,830** | **4.63x** |
| `branch-misses:u` | 3,306,611 | **1,072,440** | **3.08x** |
| `L1-dcache-load-misses:u` | 18,628,265 | **541,098** | **34.43x** |
| `L1-icache-load-misses:u` | 2,166,237 | **761,058** | **2.85x** |

### Generated-code quality (`speedtest1 --size 20 --memdb`, CPU 2, 3 runs)

- `c_direct` (`v4`): **0.513 s** (0.513, 0.513, 0.513) — **8.2% faster than `clang -O0`**
- `clang -O0`: 0.559 s (0.559, 0.563, 0.559)
- `buster --no-direct` (Tier 0): 0.403 s (0.404, 0.403, 0.402)

## Files

- `v4_hold1_allcore_tmpfs.log`: `allcore counted` + `table` on tmpfs (1 & 8 workers, `cmp` determinism, host/loadavg/ps receipts).
- `v4_hold2_allcore_disk.log`: `allcore counted` + `table` on BTRFS disk (1 & 8 workers, `cmp` determinism, host/loadavg/ps receipts).
- `v4_hold3_measure_compile.log`: interleaved `measure-compile --runs 7` (`default`, `--no-direct`, `tcc`, `clang -O0`, `gcc -O0`), un-multiplexed `perf stat` groups, and object size comparison.
- `v4_hold4_quality_and_musl.log`: `speedtest1 --size 20 --memdb` runtime comparison (`c_direct` vs `--no-direct` vs `clang -O0`).
- `baseline_nodirect_allcore_tmpfs.log`: `allcore counted` + `table` baseline on the same host & day for `--no-direct` (`main` Tier 0 pipeline).
