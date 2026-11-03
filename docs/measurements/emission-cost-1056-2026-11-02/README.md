# The no-debug compile's cost of the tier-neutral emission: Buster #1056

This record is [buster #1056](https://github.com/buster14a/buster/issues/1056)'s last acceptance item: "The no-debug
path's compile cost and storage are measured on the locked 9700X." It measures
[buster #1145](https://github.com/buster14a/buster/pull/1145), whose default compile now builds each Tier 0 function's
frame events (`emitted_from_tier0`), resolves them through the final layout and checks them
(`emission_metadata_resolve`, `emission_metadata_check`), and writes the fixed descriptor from the result, where main
wrote the fixed descriptor directly from Tier 0's frame. It is a cost measurement, not a speedup claim.

## Frozen inputs

| Input | Identity |
| --- | --- |
| base: main | `c10aa68e0ff3d56f7eed9ec739bae6ba5c5a3fa9` (the main #1145's head merges) |
| head: #1145 | `5052211a16f62873fef01c38e6a189652b0f32f3` (base and #1145's changes, nothing else) |
| Executables | twelve, six placements of each tree; SHA-256 in [hashes.txt](hashes.txt) |
| Frozen SQLite input | `sqlite3.c`, SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d` |
| musl input | the frozen corpus's 72 `src/string/*.c` files; SHA-256 of each in [hashes.txt](hashes.txt) |
| Corpus | `/var/lib/buster-9700x/corpora/preprocessor-391e729af658` |
| Host | Ryzen 7 9700X (`benchpress`), CPU 2 (governor `performance`), kernel `6.18.50-2-lts`, perf `7.2.9-1` |
| Build | `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh shifts`, clang 23.1.1, Wild 0.10.0 |

[host.txt](host.txt) has the raw identities. Every build and measured run took the shared 9700X lock for its own run
(`exclusive.sh`, through `ab --lock` for the timing).

## Method

[scripts/](scripts/) holds the harness as it ran, from `~/buster-fast-bench/1056-claude`:

1. `setup.sh`: a clone with the two trees as worktrees.
2. `build.sh`: each tree's `./build.sh shifts` (Buster's `docs/profiling.md`, "Comparing two versions"), with the
   checker's unit (`main_unit_checker.c`, which holds the driver's emission) at 0, 704, 1408, 2112, 2752 and 3456 bytes
   later, spread over a page; its `.text` is aligned to 64.
3. `check.sh`: both builds' `-c` of each workload, whose objects must be the same bytes.
4. `timing.sh`: `ab --rounds 3 --cpu 2` over `time-runs --runs 3 --copies 3`, with builds base, head and base again (the
   comparison's floor), each at its six placements and from three fresh copies: 54 executables, 162 processes per
   build and workload. The workloads are `-c sqlite3.c` with `docs/compile-time.md`'s options and one `-c` of the 72
   musl files with CI's musl options.
5. `stages.sh`: `measure-compile --runs 11` of `sqlite3.c`, each build with the other as its reference, for
   `--time-stages`' attribution.
6. `profile.sh`: a `perf record -e instructions:u` of each build's `sqlite3.c` compile, by symbol.

## Results

Both builds compile both workloads into the same bytes: `sqlite3.o` is SHA-256
`af27a8f98f345e1470fbe92ff41e0999ebb5a53eaeef44a2300393b747165e73` by each, and all 72 musl objects are identical.

### Whole compiles, medians of 162 processes per build ([logs/timing.log](logs/timing.log))

| `-c` | build | instructions | user cycles | wall | peak RSS (wait4) | minor faults |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | base | 1,271.555 M | 545.514 M | 116.426 ms | 323,828 KiB | 5,122 |
| | head | 1,280.831 M (+0.730%) | 549.061 M (+0.650%) | 116.975 ms (+0.472%) | 323,746 KiB (−0.025%) | 5,123 |
| | base again | 1,271.555 M (±0.000%) | 545.453 M (−0.011%) | 116.389 ms (−0.031%) | 323,818 KiB | 5,122 |
| 72 musl files | base | 163.291 M | 72.380 M | 30.669 ms | 28,476 KiB | 12,563 |
| | head | 163.412 M (+0.074%) | 72.548 M (+0.231%) | 30.681 ms (+0.036%) | 28,512 KiB (+0.126%) | 12,563 |
| | base again | 163.291 M (±0.000%) | 72.430 M (+0.069%) | 30.716 ms (+0.153%) | 28,476 KiB | 12,563 |

`sqlite3.c`'s instructions are the same in every process of a build: 1,271,554,821 by base and 1,280,831,186 by head,
9,276,365 more (+0.730%). musl's vary by a few thousand (base 163.282 to 163.294 M, head 163.403 to 163.414 M).

### By round, against base ([logs/timing.log](logs/timing.log), `time-runs`' comparison)

| `-c` | measure | round 1 | round 2 | round 3 | base again, rounds 1 to 3 |
| --- | --- | --- | --- | --- | --- |
| `sqlite3.c` | user cycles | +0.66% (placements +0.14 to +1.10) | +0.61% (+0.31 to +0.94) | +0.69% (+0.25 to +2.04) | −0.08%, −0.06%, +0.12% |
| | wall | +0.47% (−0.63 to +0.98) | +0.51% (−0.02 to +1.16) | +0.61% (−0.19 to +1.55) | −0.12%, −0.05%, +0.07% |
| musl | user cycles | +0.14% (−0.91 to +1.25) | +0.40% (−0.46 to +1.43) | +0.20% (−0.41 to +0.88) | −0.02%, +0.19%, +0.07% |
| | wall | −0.05% (−1.21 to +1.06) | +0.42% (−2.30 to +1.40) | −0.05% (−1.05 to +1.08) | −0.03%, +0.25%, +0.08% |

`sqlite3.c`'s user-cycle difference is outside the floor in every round, its range over the placements excludes 0, and
its instructions grow by a fixed 0.73%: a cost of about 0.65% of the cycles and 0.5 ms of the 116 ms. musl's
difference is within base's against itself.

### Where it goes ([logs/stages.log](logs/stages.log), `--time-stages`, medians of 11)

| stage | base | head | difference |
| --- | ---: | ---: | ---: |
| `tier0` | 4.793 ms (4.789 to 4.808) | 5.030 ms (5.007 to 5.081) | +0.237 ms |
| `unwind` | 0.190 ms (0.189 to 0.193) | 0.451 ms (0.449 to 0.456) | +0.261 ms |
| every other stage | | | within its runs' range |

Neither stage's ranges overlap between the builds, and the two differences add up to +0.498 ms. `measure-compile`'s own
comparison of the default compiles agrees: head 0.497 ms slower with base as the reference, base 0.691 ms faster with
head as the reference. `tier0`'s lap (`c_check_program_emit.c`) now includes `emitted_from_tier0`, which builds each
function's frame events from `unwind_tier0_frame_tails`' boundaries. `unwind`'s includes `check_program_emit_frame`,
which resolves them through the final layout, checks them and finds the fixed shape, where base wrote the descriptor
at once.

### Storage

The objects are the same bytes, so the output is unchanged. Peak resident memory is unchanged on `sqlite3.c`
(−82 KiB of 324 MB, within noise) and 36 KiB (0.13%) higher on musl's 72 units, with the same page faults.

## Limitations

- One host and toolchain: the 9700X's clang 23.1.1, not CI's official 23.1.4, and one build mode (znver5, no debug
  information). The musl workload is `src/string` alone.
- The instruction profile ([logs/counts-base.txt](logs/counts-base.txt), [logs/counts-head.txt](logs/counts-head.txt))
  is indicative only. perf throttled the fixed-period sampling to about 8,000 samples of each compile, and #1145
  changes the checker unit's inlining, so many symbols exist in one build only. It shows #1145's functions
  (`check_program_emit_frame`, `emitted_from_tier0`, `emission_metadata_check`, `emission_metadata_resolve`,
  `unwind_function_rows`) among the samples, but not their exact shares. The stage clock is the attribution.
- Retried SSH calls started three copies of `timing.sh`. Two were stopped during round 1, while the 9700X was held by a
  CI job, and the remaining one ran the whole campaign: the log has 972 process lines, 3 rounds × 3 runs × 2 workloads
  × 54 executables. The copies' truncations left NUL bytes in the log, which were removed.
- The logs' `exclusive.sh: waiting ...` lines, which name other sessions' and CI jobs' runs, were removed. They preceded
  the waiting command and overlap no timing.
