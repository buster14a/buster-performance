# Buster on Zen 4 and Zen 5: a micro-architecture analysis, 4 November 2026

This record measures the compiler at main
[`9e7f918f`](https://github.com/buster14a/buster/tree/9e7f918f3cfdba7ece957c0f7aa23ada1d25d5f9)
on two hosts. Both run the **same three executables**, built once with clang 23.1.4
for `znver4`, `znver5` and the scalar `x86-64` host:

- the owner's Ryzen 9 7940HS (Zen 4);
- the shared Ryzen 7 9700X (Zen 5).

The measurements are wall time and stages, every core event perf lists, every perf metric, same-run top-down groups, per-function profiles (leader-sampled groups, IBS, LBR), multicore scaling, energy and, on the 9700X, DRAM traffic. A three-way A/B pins the largest finding to one pull request.

The [harness](harness/README.md) reruns all of it: a C runner and reducer (`uarch.c`), `run.sh` with one profile per host, and `tables.sh`, which rebuilds [every table](tables.md) from the raw files.

## Issues filed and updated

| | issue | what |
| --- | --- | --- |
| new | (linked in the next commit) | #1049's common warnings make `-c sqlite3.c` 52% slower on the 9700X (107.0 → 162.4 ms); `check-program` 10.4 → 58.6 ms |
| new | (linked in the next commit) | `check_common_evaluated` scans every graph node per `_Generic` selection: quadratic; the compiler's own `main.c` goes from 1.44 to 4.44 s |
| new | (linked in the next commit) | the vector path warns `-Wempty-body` at `sqlite3.c:74649`; `--scalar`, the x86-64 build and clang don't |
| evidence | [#672](https://github.com/buster14a/buster/issues/672) | 1/2/4/8-worker throughput, DRAM bytes per source byte and energy at main |
| evidence | [#1213](https://github.com/buster14a/buster/issues/1213) | musl's 1,355 units on 1–8 lanes: 22–31% of the time in the kernel, its profile |
| evidence | [#892](https://github.com/buster14a/buster/issues/892) | the mispredicted sites at main on both hosts |
| evidence | [#1175](https://github.com/buster14a/buster/issues/1175) | Zen 5's frontend-bound share, function by function |

## Findings

1. **#1049 (common warnings, merged 4 November) is the largest change in compile time since the 27 October attribution.**
   - On the 9700X, sqlite3.c's `-c` takes 107.0 ms before it (`aca9e53a`), 162.4 ms at its merge (`e36740b8`) and 165.1 ms at main.
   - User instructions go from 1,156 M to 1,972 M, mispredicts from 3.1 M to 7.0 M.
   - The 7940HS shows the same: 194.7 → 276.9 → 278.1 ms.
   - Its four functions take 23.8% of main's user cycles on the 9700X.
   - The pass has no vector path: the scalar host build spends as long in `check-program` as the AVX-512 build.
2. **The same pass is quadratic in `_Generic` selections.** The compiler's own `main.c` (36 MB preprocessed, 389 selections) goes from 1,442 to 4,437 ms on the 9700X, `check-program` from 102 to 2,885 ms. A generated unit shows `check-program` growing about 4× per doubling of selections (1.9 → 346 ms from 250 to 4,000).
3. **The vector and scalar paths disagree** on one `-Wempty-body` warning in sqlite3.c. Every build's object (`61eb96dd…`) and `-E` output are byte-identical across the three builds and both hosts; only that diagnostic differs.
4. **Zen 5 retires the same binary in 30% fewer cycles,** and the 8-wide machine is frontend-bound where Zen 4 is backend-bound.
   - For `znver4.sq-c`, IPC is 2.38 against 1.67.
   - Frontend-bound is 27.6% of slots on Zen 5 against 15.7% on Zen 4; whole cycles with nothing delivered are 17.2% against 8.6%.
   - Backend-bound is 34.5% against 49.9%; its memory part 30.8% against 41.4%.
   - Bad speculation is 11.2% against 8.3%, at the same 3.56 mispredicts per 1,000 instructions.
   - With the clocks (5.55 against 4.84 GHz), one compile takes 165 ms against 277 ms.
5. **`znver5` code buys about 1% on Zen 5.** Against `znver4` code on Zen 5: 164.8 against 166.8 ms, with the same instruction count (1,972 M against 1,970 M). The AVX-512 builds do 3.3 times fewer instructions than the scalar host build. They finish sqlite3.c in 2.3 times less time on the 9700X and 2.0 times less on the 7940HS; the scalar build retires at a higher IPC (3.35 on the 9700X).
6. **Eight independent compiles are DRAM-bound.**
   - 218.6 MB/s on the 9700X, 3.8 times one core.
   - 209.5 DRAM bytes per source byte at 45.9 GB/s. The quotient, 219 MB/s, is what was measured.
   - Each compile's user time grows 1.86 times and its system time 4.2 times against one alone.
   - One compile on 8 lanes is only 6% faster than on one (166 → 156 ms).
7. **Small units pay the kernel.** On one lane, musl's 1,355 units spend 22% (9700X) and 30% (7940HS) of their time in system time: about 282 page faults per unit.
8. **Microcoded ops are 1.6% of retired ops on Zen 5 and 2.7% on Zen 4,** against 0.06% in the scalar build. They gather in the functions whose AVX-512 code uses gathers, which both generations microcode. `check_input_asm_labels` has 20 `vpgatherqd`, and 71% of its ops are microcoded. The literal and identifier leaf writers have 8 to 20 gathers each.
9. **A diagnostic's first placement costs a line table:** `pp_diagnostic_place` is 1.3% of user cycles on the 9700X for the one warning sqlite3.c gets, with a 57% mispredicted newline loop.

## Hosts

| | Ryzen 9 7940HS (`zen4-7940hs`) | Ryzen 7 9700X (`zen5-9700x`) |
| --- | --- | --- |
| cores | 8 Zen 4, SMT on | 8 Zen 5, CPU 10 (CPU 2's sibling) offline |
| L1D, L2 per core; L3 | 32 KiB, 1 MiB; 16 MiB | 48 KiB, 1 MiB; 32 MiB |
| dispatch width (top-down slots) | 6 | 8 |
| measured CPU | one core of the `cores` pool (CPU 2 or 3), at normal priority | CPU 2, under the shared lock |
| governor, EPP | `powersave`, `balance_performance` | `performance`, `performance` (CPU 2) |
| effective clock in the compiles (APERF/MPERF × TSC) | 4.84 GHz | 5.55 GHz |
| kernel, perf | 7.3.1 (CachyOS), perf 7.3.1 | 6.18.50 LTS, perf 7.2.9 |
| microcode | `0xa704108` | `0xb404038` |
| THP | `always` | `always` |
| PMU access | paranoid −1, NMI watchdog off (6 counters) | paranoid −1, NMI watchdog on (5 counters); perf caps samples at 63,300/s |
| uncore PMUs | none loaded | `amd_umc`, `amd_l3`, `amd_df` |

`env/` in each host's directory has `uname`, `lscpu`, the first CPU's `cpuinfo`, every CPU's governor and frequency limits, THP and perf settings, tool versions, the binaries' and inputs' SHA-256, and perf's full event and metric catalog (`perf-list.json.gz`).

## What ran

**Executables** (`bin/` of the run root), built from `git archive 9e7f918f` with `./build.sh` (Release: `-O3`, debug information) and `BUSTER_HOST_ARCH` set:

| build | SHA-256 |
| --- | --- |
| `compiler-znver4` | `55139a4de50567dee47cb45ede78190beaf8cb4447144f90e33a238a643e93c9` |
| `compiler-znver5` | `5af412c4135ca2cd77913a10b4d10d3dd00ae9fb8e71bb3777612d95ce2e388b` |
| `compiler-x86-64` | `5e601ae3393e62727b3f9c62d4ee2a08f75bce8ea92f954b5622719803d7ae0b` |
| `compiler-pre1049-znver5` (`aca9e53a`) | `948cd833b8d4598377e6f896b686882e7253731c18b25734cd45c23eef2c44d8` |
| `compiler-pre1049-znver4` (`aca9e53a`) | `03cd8847af00f2279d4407e3f58b08d22825423064e47d71dadb6b6f0c4f8741` |
| `compiler-m1049-znver5` (`e36740b8`) | `0c5293b9a265bda7aa0e98df0b8aa639bc54bc84188f179542efbc5e9b94f1cf` |
| `compiler-m1049-znver4` (`e36740b8`) | `a683947a48fc83e2e6432b50f24cf1c4a5ac624987a1354d4225117d27eb9957` |

**Inputs:**

- The frozen CI corpus `preprocessor-391e729af658` (`MANIFESTS.sha256` `391e729a…`), linked as `corpus` in each run root. Its `sqlite3.c` is 9,507,037 bytes, SHA-256 `0a409f16…`.
- `self-main.i`: the compiler's `main.c` at `9e7f918f`, preprocessed once by `compiler-znver4 -E`. It is 36,149,566 bytes, SHA-256 `ff2cd38f…`, the same file on both hosts.

**Workloads** (`harness/workloads.sh`):

| name | command |
| --- | --- |
| `sq-c` | sqlite3.c, CI options (`--clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17`, pinned predefines and headers, 4 `SQLITE_*` defines), `-c --lanes 1` |
| `sq-syn` | the same, `-fsyntax-only` |
| `sq-E` | the same, `-E` |
| `self-syn` | `self-main.i`, `-fsyntax-only` |
| `musl-syn` | musl's 1,355 sources as one command, `-fsyntax-only --lanes N` |
| `tcc-c` | tcc 0.9.28rc on sqlite3.c with the frozen headers (the reference compiler) |

**Steps** (`harness/run.sh`, each held per chunk; [harness README](harness/README.md)):

| step | runs |
| --- | --- |
| `validate` | each build's outputs, hashed |
| `time` | 13 lists, 11 rotated rounds, with `--time-stages` runs |
| `groups` | 6 counter groups (at most 5 counters, never multiplexed), 5 runs each |
| `sweep` | every core event, user and kernel, 2 runs: Zen 4 `znver4` on `sq-c` and `sq-syn`; Zen 5 `znver5` and `znver4` on `sq-c` |
| `metrics` | every perf metric, 2 runs, native build, `sq-c` and `sq-syn` |
| `profiles` | cycles (user and kernel); leader-sampled groups for top-down L1/L2, memory, frontend and microcode; IBS ops (all, and L3 misses only); LBR |
| `scaling` | `sq-c` on 1..N lanes, `musl-syn` on 1..N lanes, K independent compiles with package energy |
| `energy` | package and core energy, APERF/MPERF |
| `uncore` | UMC CAS and activates (9700X) |
| `ab1049`, `ab3`, `ab-self` | before #1049, its merge and main |

## Results

[tables.md](tables.md) has every table for both hosts, generated by `harness/tables.sh`. The rest of this section picks from it.

### Whole processes and stages

| | 7940HS `znver4` | 9700X `znver5` | 9700X `znver4` | 9700X `x86-64` | tcc on the 9700X |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sq-c` wall | 276.9 ms | 164.8 ms | 166.8 ms | 373.3 ms | 42.3 ms |
| `sq-c` MB/s of source | 34.3 | 57.7 | 57.0 | 25.5 | 224.8 |
| `sq-syn` wall | 245.8 ms | 144.1 ms | 146.0 ms | 323.0 ms | |
| `sq-E` wall | 26.7 ms | 17.1 ms | 18.3 ms | 127.7 ms | |
| peak RSS (`sq-c`) | 295 MiB | 292 MiB | 292 MiB | 293 MiB | 13 MiB |

The stages of `sq-c --lanes 1`, medians of 11 runs (ms):

| stage | 7940HS `znver4` | 9700X `znver5` | 9700X `x86-64` |
| --- | ---: | ---: | ---: |
| preprocess | 16.76 | 9.35 | 106.85 |
| parse | 9.70 | 7.45 | 29.27 |
| check-input | 104.44 | 53.06 | 113.14 |
| check-expressions | 21.80 | 10.33 | 14.16 |
| check-program | 81.17 | 58.37 | 54.82 |
| lower | 15.68 | 10.45 | 15.55 |
| tier0 | 7.37 | 5.16 | 13.83 |
| branch-sizing + encode | 1.39 | 0.89 | 15.28 |
| release | 2.14 | 1.83 | 0.10 |
| total | 274.95 | 163.73 | 371.56 |

### Same binary, two micro-architectures

The fixed groups, user mode, `sq-c`, with `znver4` code on both hosts:

| | 7940HS (Zen 4) | 9700X (Zen 5) |
| --- | ---: | ---: |
| instructions | 1,970 M | 1,970 M |
| cycles | 1,183 M | 826 M |
| IPC | 1.67 | 2.38 |
| retiring | 27.0% | 26.7% |
| frontend-bound | 15.7% | 27.6% |
| of which whole-cycle (latency) | 8.6% | 17.2% |
| backend-bound | 49.9% | 34.5% |
| of which memory | 41.4% | 30.8% |
| bad speculation | 8.3% | 11.2% |
| microcoded ops | 2.71% | 1.57% |
| mispredicts per 1,000 instructions | 3.56 | 3.56 |
| op cache hit rate | 94.6% | 91.6% |
| DRAM demand fills per 1,000 instructions | 0.88 | 0.80 |
| L1 DTLB misses per 1,000 instructions | 0.50 | 0.18 |

From the sweeps (each host's native build; the instruction counts are within 0.1%), per 1,000 user instructions:

| event | 7940HS `znver4` | 9700X `znver5` |
| --- | ---: | ---: |
| L1D demand fills from L2 (`ls_dmnd_fills_from_sys.local_l2`) | 5.49 | 4.19 |
| L1D demand fills from L3 (`.local_ccx`) | 2.05 | 0.55 |
| L1D demand fills from DRAM (`.dram_io_near`) | 0.89 | 0.79 |
| all L1D fills (`ls_any_fills_from_sys.all`) | 15.90 | 11.44 |
| instruction cache fills from L2 (`ic_cache_fill_l2`) | 3.89 | 5.25 |
| op cache misses (`op_cache_hit_miss.op_cache_miss`) | 11.7 | 24.7 |
| microcoded ops (`ex_ret_ucode_ops`) | 27.0 | 14.0 |

Zen 5's 48 KiB L1D, larger L1 DTLB and 32 MiB L3 take away much of the data side's stall, and the backend-bound share falls. The wider front end becomes the next limit: Zen 5 fills a third more instruction-cache lines and misses its op cache twice as often for the same instructions. The instruction-cache tag events (`ic_tag_hit_miss`) count very differently per generation (16.6 against 394.7 accesses per 1,000 instructions), so this record compares fills, not tag misses.

### Per function (9700X, `znver5`, `sq-c`)

From the leader-sampled top-down groups (period 50,021 cycles, 8 compiles), functions with at least 1.3% of user cycles:

| function | cycles | IPC | retiring | frontend | backend | backend memory | bad spec | mispredicts per 1,000 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `check_driver_common_warnings` | 8.7% | 2.82 | 28.1% | 36.2% | 19.9% | 18.4% | 15.7% | 4.56 |
| `check_common_emit_run` | 6.6% | 2.83 | 30.8% | 25.0% | 31.0% | 30.6% | 13.1% | 2.74 |
| `check_common_evaluated` | 6.3% | 1.50 | 14.7% | 56.4% | 6.0% | 4.7% | 22.7% | 14.66 |
| `check_input_expression_coded` | 4.4% | 1.76 | 21.8% | 22.8% | 46.5% | 43.7% | 8.9% | 3.96 |
| (unsymbolized: libc) | 4.3% | 1.07 | 12.8% | 20.5% | 64.0% | 56.7% | 2.5% | 2.02 |
| `check_input_resolve_range` | 4.0% | 2.12 | 23.8% | 30.0% | 41.8% | 40.4% | 4.1% | 1.50 |
| `check_input_run` | 3.8% | 2.35 | 24.7% | 40.3% | 23.0% | 20.2% | 11.8% | 5.42 |
| `check_graph_run` | 3.6% | 3.45 | 38.0% | 28.9% | 22.4% | 21.3% | 10.5% | 2.09 |
| `check_lower_drain` | 2.3% | 2.65 | 28.1% | 31.7% | 30.5% | 29.5% | 9.6% | 2.55 |
| `check_program` | 2.3% | 1.59 | 17.3% | 27.1% | 41.5% | 40.7% | 13.9% | 5.12 |
| `check_common_emit_kids` | 2.2% | 2.88 | 31.3% | 24.7% | 31.1% | 30.7% | 12.8% | 2.64 |
| `pp_run_contexts` | 2.2% | 2.68 | 31.6% | 34.7% | 22.9% | 20.6% | 10.7% | 2.72 |
| `check_input_binding_answers` | 2.2% | 2.66 | 26.0% | 31.6% | 24.2% | 23.2% | 18.1% | 4.62 |
| `tier0_generate` | 1.9% | 2.45 | 33.9% | 38.0% | 18.0% | 10.4% | 9.9% | 2.86 |
| `tokenize_c_raw_no_separators` | 1.6% | 3.08 | 40.4% | 13.0% | 40.0% | 8.5% | 6.6% | 0.95 |
| `parse_tree_columns` | 1.4% | 3.66 | 47.8% | 7.6% | 39.6% | 39.2% | 4.9% | 0.01 |
| `check_control_drain` | 1.4% | 1.79 | 20.4% | 25.9% | 41.3% | 40.7% | 12.2% | 3.79 |
| `pp_diagnostic_place` | 1.3% | 1.16 | 14.3% | 22.2% | 37.8% | 29.9% | 25.5% | 11.58 |
| all | 100.0% | 2.31 | 26.0% | 30.1% | 32.8% | 29.0% | 10.9% | 3.48 |

In the frontend group, the functions with the worst op-cache hit rates (Zen 5) are big switch-dispatch functions:

- `tier0_generate`, 69%;
- `check_input_declarator_step`, 72%;
- `check_input_declaration`, 73%;
- `check_input_resolve_range`, 76%;
- `pp_run_contexts`, 82%.

### Memory and the kernel

- **Kernel share.** The kernel takes 10% of `sq-c`'s cycles on both hosts, and 19–21% of `sq-E`'s. `clear_page_erms` alone is 7.3% of all cycles on the 9700X. The 7940HS's kernel shows `get_page_from_freelist.cold` instead.
- **IBS loads (Zen 4, `sq-c`).** Of the sampled loads with a data source, 98% hit L1. The L3-miss-only IBS samples put 35% of the misses in libc: four adjacent stores of its `memset` loop take 27%, which is fresh memory being cleared. After libc come `check_driver_common_warnings`, the reader's literal and identifier writers, and `check_program`.
- **DRAM traffic (9700X UMC).** One compile at a time moves 165 bytes per source byte, at 9.5 GB/s. Eight at once move 209.5 B/B at 45.9 GB/s, with 0.80 activates per CAS.

### Scaling and energy

| | 9700X | 7940HS |
| --- | ---: | ---: |
| `sq-c`, 1 → 8 (6) lanes | 166.1 → 155.9 ms | 276.0 → 264.4 ms (best 251.4 at 4) |
| `musl-syn`, 1 → 8 (6) lanes | 855.9 → 173.6 ms (4.9×) | 1,521.7 → 352.3 ms (4.3×) |
| K independent `sq-c`, MB/s at 1, 2, 4, 8 (6) | 57.6, 102.6, 166.4, 218.6 | 35.6, 68.4, 113.0, 146.9 |
| core energy per `sq-c` (one core) | 1.94 J | 1.84 J |
| package energy above idle per `sq-c` | 2.82 J | 4.17 J |

### The full sweeps

Both hosts counted every core event `perf list` names, each with `cycles:u` and `instructions:u` in one group and in user and kernel mode, 2 runs:

- **7940HS:** 376 names on `sq-c` and on `sq-syn` (`znver4`). All counted at full duty; 14 needed the one-event fallback, and 280 are nonzero. `cycles`, `instructions` (the anchors themselves) and `temp1` (a sensor) have no value of their own.
- **9700X:** 416 names on `sq-c` (`znver5`). All counted at full duty; 40 through the fallback, and 267 are nonzero. 21 have no value: the anchors, two sensors, and 17 L3 events (`l3_lookup_state.*`, `l3_xi_sampled_latency*`) that perf lists among the core events but that count only system-wide.
- The 9700X's `znver4` sweep of `sq-c`, its metrics and its self-compile groups come in this record's next commit. Its `sq-syn` sweep stopped after 100 events: the run was narrowed to `sq-c` to keep the shared machine's holds few.
- **Metrics on the 7940HS:** 143 per workload. 103 gave a finite value at full duty; 37 failed per thread (uncore, RAPL and other system-wide metrics).

`sweep.tsv` (one per build and workload) gives each event's user and kernel medians, its rate per 1,000 user instructions and per user cycle, its kernel share, and its minimum duty. `metrics.tsv` gives each metric's reported values and whether it failed. Metrics that need system-wide counting (uncore, RAPL) fail per thread; that failure is recorded, not hidden.

## Limits

- **Single-core steps on the 7940HS ran on a busy desktop.** They took one core from the `cores` pool at normal priority, while other cores could run other work: its counts are reliable, its times less so than the 9700X's. Its clock varies with load (`powersave`/`balance_performance`); the 9700X's CPU 2 runs `performance`.
- **Cross-generation events are not one definition.** Perf's Zen 4 and Zen 5 tables name some events alike with different semantics (the instruction-cache tag event above, the L2 request groups). Top-down slots use each generation's own width.
- **The leader-sampled groups blend short functions.** Each sample's deltas go to the leader's address. On the 9700X, perf's 63,300 samples/s cap throttled the 50,021-cycle groups to about 69% of the cycles; the shares are ratios within the samples. A function far shorter than a period, such as the gather-heavy leaf writers called by `check_input_expression_coded`, shows its caller's ratios. The microcode attribution therefore names the gathers from the disassembly.
- **The sweep's events come from separate runs**, two per event. They do not partition one execution exactly.
- **`self-main.i` is preprocessed input.** It measures everything after preprocessing, on the same bytes on both hosts. The frozen headers lack `linux/audit.h`, so `main.c` itself does not compile against them.
- **The 9700X's lock receipts are in `holds.txt`,** one line per hold, the holder's own entry. Nothing else from the lock's owner file is kept.

## Files

```text
README.md                     this report
tables.md                     every table, from harness/tables.sh
harness/                      the harness (README.md: how to rerun)
harness/generic-scaling/      the _Generic scaling check and its Zen 4 output
zen4-7940hs/, zen5-9700x/     each host's results:
  env/                        identity, settings, catalogs, hashes
  validate.tsv                each build's output hashes
  time/time-summary.tsv       whole processes; stages-*.tsv: --time-stages medians
  groups/stat.tsv             the fixed groups' medians
  sweep-BUILD-WORKLOAD/sweep.tsv, metrics-BUILD-WORKLOAD/metrics.tsv
  profiles/BUILD/*.tsv, *.txt per-function tables, perf reports, record logs and headers
  scaling/, energy/, uncore/, ab1049/, ab3/, ab-self/
  holds.txt                   one receipt per lock hold or core grant
  raw.tar.zst                 every per-run file: perf stat CSVs, status files, logs
```

The perf.data files and the seven executables, with the source's license and notice files, are in the release [`microarchitecture-two-hosts-2026-11-04`](https://github.com/buster14a/buster-performance/releases/tag/microarchitecture-two-hosts-2026-11-04).

---
Agent session: 13c4c6ec-bedd-4c3c-8259-227a893edce8 (Claude Code desktop session ID; no share URL is exposed)
Model: Anthropic / claude-opus-5-5
