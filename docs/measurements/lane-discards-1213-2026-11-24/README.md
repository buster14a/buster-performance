# Arena discards between translation units

[Buster issue 1213](https://github.com/buster14a/buster/issues/1213) and [implementation PR 3541](https://github.com/buster14a/buster/pull/3541)

The base is `7515714d05caa655e8c2e1e2776e07aa9b8058df`. The candidate is `6209173bc4d93a99ff9f5db14d42b8c945141716`. The PR head, `888f2533d61a8279fa0e7d825660995ed5dc942b`, then reformatted five initializers. Both measured revisions include the writable-prefix query from #3289 and the preprocessor root image. The candidate batches writable ranges during unit teardown, borrows base pages for small type tables and retains up to 8 MiB of scratch within each lane's unused admission credit.

## VM counters and output comparison

The host was an AMD EPYC 9V74 VM running Linux 6.18.57. Both Release executables were built with Buster's pinned Clang 23.1.4, native target and debug information disabled, then copied to the same tmpfs directory. All commands used CPUs 0–3 with a four-CPU quota. The kernel reported seccomp mode 0. Strace 6.13 traced system calls in one process tree per row. The fault and peak RSS columns are medians of five separate, untraced runs for each build. The first build in the pair alternated each round. Four lanes can assign different units to a given lane on different runs.

| Command | Lanes | Discard calls, base → candidate | Minor faults, base → candidate | Peak RSS in KiB, base → candidate |
| --- | ---: | ---: | ---: | ---: |
| 256 empty units to objects | 1 | 2,560 → 1,280 | 3,788 → 3,023 | 13,552 → 13,552 |
| 256 empty units to objects | 4 | 2,638 → 1,352 | 6,075 → 5,301 | 15,064 → 15,148 |
| 256 units of 3 functions to objects | 1 | 2,561 → 1,793 | 26,035 → 26,035 | 22,380 → 22,520 |
| 256 units of 3 functions to objects | 4 | 2,643 → 1,876 | 29,852 → 29,790 | 35,120 → 35,044 |
| 64 units of 200 functions to objects | 1 | 643 → 451 | 36,714 → 36,712 | 58,224 → 58,364 |
| 64 units of 200 functions to objects | 4 | 738 → 543 | 50,594 → 50,651 | 106,120 → 105,724 |
| 33 Lua units to objects | 1 | 403 → 304 | 19,195 → 19,127 | 47,792 → 51,580 |
| 33 Lua units to objects | 4 | 439 → 343 | 32,598 → 32,730 | 93,952 → 97,988 |
| 33 Lua units linked | 1 | 430 → 331 | 22,566 → 22,496 | 49,244 → 53,020 |
| 33 Lua units linked | 4 | 472 → 368 | 35,474 → 35,703 | 93,608 → 98,708 |

Discard calls count each scalar or vector invocation with `MADV_DONTNEED` once. Across the ten candidate traces, all 2,056 vector calls returned a positive byte count. On one lane the base issued 54 scalar discards of exactly 6 MiB while linking Lua. The candidate issued zero. The retained scratch raised median peak RSS for this link by 3.7 MiB on one lane and 5.0 MiB on four. The clearest fault reduction was on empty units. The traces count userspace requests to Linux.

For each workload the harness compared SHA-256 manifests of every output and the complete diagnostics across builds, lane counts and runs. All 609 object files and the Lua executable matched. The Lua executable also matched when `strace` forced either `pidfd_open` or `process_madvise` to return `EPERM`. Buster's arena resource fixture separately launches a command under a seccomp filter that terminates the child on either optional syscall. That fixture detected the failure before the mode check and passed afterward.

## Reproducing the VM comparison

Use `BUSTER_DEBUG_INFO=0 ./build.sh --config Release` in each revision, with the same pinned toolchain. Set `PATH` and `BUSTER_CLANG_RESOURCE_DIR` to its Clang binary and resource directories. Copy both resulting compilers to the same filesystem. The harness generates its synthetic units using the base compiler's `test-check-units --generate` command. Lua is the upstream Git tree at `6e22fedb74cf0c9b6656e9fce8b7331db847c605` (v5.4.8). It compiles all top-level C sources except `ltests.c` and `onelua.c`. Its link uses `-lm -ldl`. The VM commands use the toolchain's default headers. The hardware workflow uses the frozen corpus's headers and predefines.

```sh
python3 compare.py /path/to/base /path/to/candidate /path/to/lua /path/to/new-output
```

[Syscall counts](vm/traces.tsv) · [Paired rusage](vm/rusage.tsv) · [Output manifests, digests and diagnostics sizes](vm/products.tsv) · [Raw strace logs](vm/raw) · [Harness](compare.py)
