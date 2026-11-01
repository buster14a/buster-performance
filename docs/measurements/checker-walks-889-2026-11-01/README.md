# Checker walks' stack-field loads after the coded walk, Buster #889

This record measures the stack-field loads that [#889](https://github.com/buster14a/buster/issues/889) counted in the
checker's source-order and expression walks, on the 9700X, and the narrow change that reads the source-order walk's
visit mark once per token.

## Sources and host

- **old:** `586c2ae2e40f117f27330307944a6d64566e0882`, the issue's source. Its binary and IBS capture are the
  `buster-microarchitecture-2026-10-29-9700x-notices-v2.tar.zst` release asset
  (SHA-256 `c61260e01bf584f6f24b5356582c065d4634c984a4bc656ad1ef7ea6150787db`), whose `native/compiler` is
  `bc9fd0d427db66f1b4d50f05e763838e77de41cf24cb1057d2c9ca816cf27c1d`;
- **base:** `1acc0a171ac444a209d2279bdf1d09b801efd9cc`, this record's main;
- **mark:** `1acc0a17` plus commit `9027e7f10567f2457627b7a39bec8af0432681eb`, which reads the source-order
  walk's `visits[token]` once at the token, passes it to the reason tests, and refreshes it after the one step that
  can mark the token's own visit (`check_input_declaration` at a specifier job's finish).

Each tree was built on the host by `./build.sh`, with Clang 23.1.1, `-march=native` (znver5) and `-g`. The measured
executables are `raw/../executables.txt`: base `53f5f21d69f823862129ae1d2bb86197c69df3c7269ece19ea23d5978ab179d1`
and mark `850f15c488a08267729a316cf18fd90f036fb292fd557b4943e8e011dd4eed56`.

The host is the AMD Ryzen 7 9700X, kernel `6.18.50-2-lts`, Clang `23.1.1`, CPU 2. Every build, test and measurement
took the shared host lock (`~/buster-fast-bench/exclusive.sh`) for itself and ran pinned to CPU 2. The lock's waiting
messages are left out of the logs.

## Workload and method

The workload is the frozen `sqlite3.c` (SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, 9,507,037 bytes), compiled by
`-c -march=native -fwrapv -funsigned-char` into `/tmp/889-*-out.o`; each run starts a fresh process.

The IBS capture is `perf record -d -e ibs_op/cnt_ctl=1,period=100003/` over 30 compiles, one process at a time,
pinned to CPU 2. `scripts/stackloads.py PERF BINARY / ALL` joins each sample's IP to the executable's `objdump -d`
disassembly and counts the samples whose data address is in the stack range `[0x7ff000000000, 0x800000000000)`, whose
instruction is a `mov` whose memory source's base register is neither `rsp` nor `rbp`, and whose destination is a
64-bit register. The per-function denominator is the samples whose IP is in that function. This is the issue's metric
without its main-thread-stack allocation join; it reproduces the issue's per-function shares on `586c2ae2` (below).

The raw reports are `raw/old-stackloads.txt`, `raw/latest-base-stackloads.txt` and `raw/latest-mark-stackloads.txt`.
The captures are `raw/ibs-op-base.perf.zst` and `raw/ibs-op-mark.perf.zst`.

## The issue's metric

On `586c2ae2`, the method gives the issue's table to within 0.05 points:

| Function | issue's share | this method |
| --- | ---: | ---: |
| `check_input_expressions` | 16.9% | 16.86% (`4859/28818`) |
| `check_input_resolve_range` | 17.3% | 17.26% (`2262/13109`) |
| `check_control_children` | 24.4% | 24.37% (`1358/5572`) |
| `check_program` | 9.9% | 9.92% (`653/6585`) |
| `check_graph_run` | 9.4% | 9.40% (`351/3734`) |
| all compiler ops | 7.2% | 6.87% (`17400/253212`) |

The all-compiler difference is the issue's main-thread-stack join and its narrow fields; its own table's functions
agree.

## Results on `1acc0a17`

| Function | base | mark | change |
| --- | ---: | ---: | ---: |
| `check_input_resolve_range` | 17.79% (`2248/12635`) | 9.97% (`1169/11723`) | -7.82 points |
| `check_input_run` (the coded walk) | 6.10% (`1428/23393`) | 6.34% (`1484/23394`) | +0.24 |
| `check_control_children` | 19.06% (`1285/6743`) | 18.33% (`1237/6749`) | -0.73 |
| `check_lower_drain` | 8.13% (`849/10443`) | 8.06% (`856/10626`) | -0.07 |
| all compiler ops | 6.12% (`14351/234597`) | 5.73% (`13372/233324`) | -0.39 points |

The source-order walk's repeated `visits[token]` tests were most of its stack-field loads; the coded expression walk
(`check_input_run`) was already below the old walk's share. The remaining `check_control_children` and
`check_lower_drain` shares move with layout and are not this change's targets.

## Time

`benchmark-checker-bindings --only direct --passes 21` (`raw/checker-ab.txt`), five interleaved rounds:

| | base | mark | change |
| --- | ---: | ---: | ---: |
| median | 43.37 ms | 42.91 ms | -1.05% |
| cycles | 227.45 M | 224.91 M | -1.12% |

Whole `-c`, `time-runs --runs 31 --warmups 5` (`raw/time-runs.txt`):

| | base | mark | change |
| --- | ---: | ---: | ---: |
| wall, median | 117.243 ms | 116.671 ms | -0.49% |
| user cycles, median | 545.578 M | 542.366 M | -0.59% |
| user instructions, median | 1,256,660,150 | 1,249,701,226 | -0.55% |

The objects are byte for byte the same: both paths produce
`4981ae88f49f07edc8ce071fe89c3f9a076309ef194d3d12555a45cc00819b42`, including with `--scalar`.

## What did not move the time

Before the mark cache, the following candidates were measured on the same main; none improved whole `-c`:

- cache the reader's stable column pointers and loop bounds in the walks (#953's rejected candidate): no change;
- keep a scope's `scope_count` and `scope_end` in locals in the source-order walk: no change (43.25 -> 43.22 ms on
  `benchmark-checker-bindings`, inside its spread);
- write a literal's `CheckValue` into its graph leaf instead of through a 96-byte return buffer: it removed the
  old walk's largest single reload on `586c2ae2`, but on `1acc0a17` the coded walk inlines the literal action and
  the change moved neither `-c` nor the checker;
- pass the `visits` pointer to the reason tests without reading the byte once: no change;
- make the child-value helper `noinline`, and skip it for identifiers and literals: both slower (about +0.5%).

The issue's remaining reloads are L1 hits off the critical path, as #953 found; only removing the repeated
*byte* tests (not the pointer loads) moved the reader and the whole compile.

## Correctness

`test-checker --seed 133` (728,172 checks), `test-checker-driver --executable ./build/compiler` (48,090 checks), the
220 c-testsuite cross-check cases and `test-checker-corpus --symbols --clang clang` on the frozen `sqlite3.c` pass on
the mark tree. The base and mark objects of the frozen unit are identical on the vector and scalar paths.
