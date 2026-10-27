# Reproduce the Buster microarchitecture measurements

The report analyzes source revision `92c025e71856d13eb34247477c5294d2cead139e`. It changes no compiler implementation. Commands below assume Linux on the target CPU, working performance-counter access, Clang, perf, a C compiler, zstd and the normal repository build dependencies. `jq` exports tables; libxml2 is needed only to extract the official uops.info XML.

The retained remote working directory is `/home/david/buster-fast-bench/microarch-20261027-exp` on `benchpress`. Never run a new benchmark there alongside CI or another measurement. Its shared lock is `/home/david/buster-fast-bench/exclusive.sh`; every build and timed run used it. On the local machine, `/home/david/dev/scripts/cores` grants the available cores while preserving the existing interactive reservation. Do not run the whole matrix inside a one-core grant.

## Files and identities

- `../analysis.md` contains findings, priorities and qualifications.
- `../results.json` contains key numerical results.
- `../tables/9700x-core-counters.csv` contains all 370 exposed named core-event entries, their encodings, counts, normalization, coverage and status. Five aliases share encodings, leaving 365 distinct raw configurations; both names remain visible.
- `../tables/local-core-counters.csv` contains 358 requested aliases and the names perf printed, including two aliases normalized to cycles/instructions.
- `../tables/derived-metrics.csv` preserves values as text, including `nan`. It includes the individually collected target metrics, the exploratory simultaneous sweep and the local controls. The broad target collection is marked exploratory because its core-event duty falls to 6%.
- `../tables/metric-collection-status.csv` lists every attempted individual metric, including empty/unsupported collections. On the target, 142 of 147 names return finite values with full scheduling coverage, four return nonfinite values and the generic LLC metric fails before the compiler starts. Coverage describes scheduling rather than proof that an exposed alias maps correctly to this client SKU.
- `../tables/metric-catalog.csv` preserves exposed expressions, units, descriptions and groups. The original JSON catalogs additionally retain all event types, PFM aliases and software/device events.
- `../raw/9700x` and `../raw/local` contain resource records, perf stat JSON streams, sampling captures, reports and manifests. Each perf stat file is newline-delimited JSON, not a single JSON array; use `jq -s` to read one as an array.
- `../reproduction/source-92c025e7.tar.zst` contains the exact compiler source, including its licenses and notices. `frozen-corpus.tar.zst` contains the exact source/header/predefine inputs.
- `../reproduction/compiler-9700x.zst` is the exact native executable with debug information. The local native executable is supplied separately. Hardware identity hashes use the original working filenames; the final deliverable hash inventory uses delivered paths.
- The target libc and target kallsyms are retained for symbol resolution. The uops XML itself is not duplicated: its URL and SHA-256 identify the input, and `uops-selected.csv` retains the extracted rows.

## Restore an independent working directory

Run these commands from this method directory. Choose an empty task-owned directory for `run_root`.

```sh
run_root=/path/to/empty/microarchitecture-run
mkdir -p "$run_root/source"
zstd -dc ../reproduction/source-92c025e7.tar.zst | tar -xf - -C "$run_root/source"
zstd -dc ../reproduction/frozen-corpus.tar.zst | tar -xf - -C "$run_root"
zstd -dc ../reproduction/compiler-9700x.zst > "$run_root/compiler-native"
zstd -dc ../reproduction/compiler-local.zst > "$run_root/compiler-common"
chmod +x "$run_root/compiler-native" "$run_root/compiler-common"
cc -O2 -Wall -Wextra -Werror microarch.c -o "$run_root/microarch"
cp ../hardware/9700x-core-encodings.tsv "$run_root/events.tsv"
jq -r '.[].MetricName // empty' ../hardware/9700x-perf-list-uncore.json | sort -u > "$run_root/metrics.txt"
```

Use the frozen executable only on a CPU supporting its Zen 5 host instruction set. For a new native build, run `./build.sh` in the restored source directory through the machine's allocator/lock, then copy `build/compiler` to the run root. This yields a new binary identity; retain it rather than silently mixing it into the old profiles. The measured builds use `-O3 -march=native` with debug information and the repository's arithmetic/aliasing flags. Bootstrap versions and build logs are in `../hardware/`.

## Throughput and stage suites

In `run_root`, prefix each target invocation with the shared lock and bound its execution. The lock acquisition may wait for another owner; the timeout below starts after the lock is granted.

```sh
EXCLUSIVE_OWNER=codex-microarch \
EXCLUSIVE_TITLE="Buster native throughput" \
EXCLUSIVE_LINK=codex://threads/01a17f1c-d48d-75d3-a93c-b8c53419636a \
/home/david/buster-fast-bench/exclusive.sh \
timeout 55 ./microarch suite throughput > results-throughput.jsonl
```

Repeat with `suite phases` for CLI phase controls, single-file lane scaling and stage-clock reports. `suite budgets` rotates nested lane budgets, scalar/vector pipeline controls and reference executables. It expects `compiler-common`, `/usr/bin/tcc` and `/usr/bin/clang`; the common executable is the native local build of the same source, not another processor measurement.

The direct command `./microarch bench compile 8 64 1 0 0 ./compiler-native` compiles 64 complete objects with eight workers and one lane per process. The arguments after `bench` are stage, jobs, total tasks, lanes, scalar-reference flag, stage-timing flag and executable. Stage is `pp`, `parse`, `check` or `compile`. Lane value zero omits the lane option. `BENCH_LABEL` selects the retained `scratch/` directory.

Each compile has the four feature macros listed in the report, GNU17, frozen predefines and headers, `--clang-features`, and generated-code target `znver5`. The timer includes launch, compilation, output writes and child exit. It excludes object deletion. The runner retains object zero, per-child resource records and diagnostic/stage logs. `maxrss_per_process_kb` is the largest child high-water mark, not aggregate peak RSS. Fresh subprocesses deliberately include page commitment and teardown costs.

`BENCH_COUNTERS=1` enables user-only cycles, instructions, branches, branch misses and retired operations on each child before exec. Inheritance includes its threads. Values stay unscaled and the minimum enabled/running ratio is retained. Do not add an outer competing core-event group to this mode and assume coverage remains unchanged.

## Core event and derived metric catalogs

`counter-suite START END` measures each half-open catalog range with only that raw event plus concurrent user cycles/instructions. The target used ranges `[0,70)`, `[70,140)`, `[140,210)`, `[210,280)`, `[280,350)` and `[350,370)`, each under its own bounded lock invocation. Each event cohort compiles eight translation units on eight physical cores. AMD's extended event selector bits, unit mask, edge, inversion and counter mask are encoded by the C runner. Kernel/hypervisor execution is excluded. The raw catalog is an inventory of exposed named vendor configurations, not every possible bitmask or device event.

`metric-suite START END` uses one exposed metric name per perf stat invocation, system-wide on CPUs 0–7, inside one outer lock. Use bounded chunks of 50 names; it stores each perf JSON, workload record, log and exit status under `results/metric-isolated`. Complex individual metrics can still require more simultaneous counters than are available; always inspect actual running coverage. The broad all-metric run is retained separately as exploratory data.

The original target chunks are `[0,50)`, `[50,100)` and `[100,147)`. Their manifest preserves an exit status of 1 for unsupported `llc_miss_rate`; that attempt has no benchmark workload record. The remaining 146 compiler cohorts have zero compilation failures. System-wide `CPUs_utilized` uses a different clock scope from process CPU time; the runner's resource-based utilization is the activity measure used in the report.

Finite values can still be invalid for a client SKU. The exposed DF DRAM bandwidth aliases fail a same-run cross-check against UMC: the read alias reports 85.08 GB/s against 31.65 GB/s of UMC reads, and the write alias is nearly zero against 19.37 GB/s of UMC writes. All have 100% scheduling duty. `df-umc-check.sh`, run from the remote task root under one bounded shared-lock invocation, reproduces the paired controls. Its JSON and workload records are in `../raw/9700x/df-umc-*`. Use UMC for the report's DRAM budget; do not treat the exposed twelve-channel DF expressions as validated on this two-channel client.

Core vendor events were measured separately, so values from different event cohorts must not be combined into an exact additive partition. The normalized table provides same-cohort cycles and instructions for that reason. Distinguish measured zeros, unsupported events, `nan`, collection errors and low scheduling duty.

Regenerate tables from the original delivered evidence with:

```sh
sh export-tables.sh ..
```

## Uncore and energy measurements

The target's running kernel is `6.18.50-2-lts`. Its module directory had been removed by a package update. The matching `amd-uncore.ko` was extracted from the official cached package `linux-lts-6.18.50-2-x86_64.pkg.tar.zst`, checked against the running kernel's vermagic, and loaded. This exposed `amd_df`, `amd_l3`, `amd_umc_0` and `amd_umc_1`. Loading the local module with `modprobe amd_uncore` likewise exposed its PMUs. No persistent setting was added.

The quantitative target run uses `perf stat -a -C 0-7` around `bench compile 8 128 1 0 0 ./compiler-native`. It collects both UMCs' `umc_cas_cmd.rd`, `umc_cas_cmd.wr`, `umc_mem_clk` and `umc_data_slot_clks.all`, package/core energy and the L3 latency metric. Exact event names, counts, runtime and coverage are in `uncore-allcore.perf.json`. Linux's AMD metric definition uses 64 bytes per CAS. Divide traffic by the counter interval for bandwidth, and by successful original source bytes for amplification; do not use summed CPU time as elapsed time.

`clocks-allcore.perf.json` records APERF/MPERF/TSC and another UMC control. Do not infer clock frequency solely from task user time and a cycle count. `memory-floor.c` is a separate integer AVX-512 streaming calibration with cached and non-temporal stores. Its GB/s counts logical array bytes, excluding initialization, write allocation and other physical traffic. It is not a measured DRAM hard ceiling.

## Standalone and simultaneous sampling

Target primary captures:

| Capture | Population | Quality |
|---|---|---|
| `cycles-allcore-7000.data` | Ordinary cycles, user and kernel, 4,999 Hz | Zero lost samples |
| `cycles-single-7001.data` | One-core ordinary cycles | Retained one-core control |
| `ibs-ops-standalone-9001.data` | IBS operation count, period 100,003 | Zero lost samples and misordered timestamps |
| `ibs-cycles-8001.data` | IBS cycle-count mode, period 100,003 | Zero lost samples |
| `branches-8002.data` | User-cycle branch-stack samples | Zero lost samples; branch-stack report population differs from cycle samples |
| `combined-readable-9100.data` | Four synchronous user counters plus IBS operations and fetch | Zero lost samples and misordered timestamps |

Reproduce the successful combined run using `./microarch "$run_root" 9700x results/joint joint` from the run root. The campaign applies the target lock itself. Its effective recording command is:

```sh
perf record -q -o combined.data \
  -e '{cycles:u,instructions:u,branches:u,branch-misses:u}:S' -c 4000003 \
  -m 64M \
  -e 'ibs_op/cnt_ctl=1,period=400003/' \
  -e 'ibs_fetch/period=1000003/' \
  -d -W -R --sample-cpu \
  -- ./microarch bench compile 8 64 1 0 0 ./compiler-native
```

The runner's `-s` variants are retained only to reproduce the observed perf reader failure; they are not primary evidence. A high-rate mixed recording and early high-rate DWARF recording also lost samples. Excluded exploratory captures remain in the original task's `work/excluded-*` directories rather than being presented as reliable profiles.

IBS does not supply a pure user-only hardware filter here; filter by executable/module before calling a distribution compiler-only. Operation-count sampling, cycle-count selection, fetch sampling and ordinary cycle sampling have different denominators. Group counter snapshots cover intervals between samples; they cannot attribute every counted event to the final instruction. Width classification is register use, not active lanes. Cache-miss latency weights apply to load misses, not all instructions or L1-hit latency.

## Resolve symbols and join to assembly

For target capture analysis on another machine, create the original executable and libc paths under a private symfs directory. Target kallsyms avoid confusing the analyzing machine's kernel with the measured kernel.

```sh
mkdir -p symfs/home/david/buster-fast-bench/microarch-20261027-exp symfs/usr/lib
zstd -dc ../reproduction/compiler-9700x.zst > symfs/home/david/buster-fast-bench/microarch-20261027-exp/compiler-native
cp ../reproduction/9700x-libc.so.6 symfs/usr/lib/libc.so.6
DEBUGINFOD_URLS= perf report --stdio --symfs symfs \
  --kallsyms ../reproduction/9700x-kallsyms.txt \
  -i ../raw/9700x/ibs-ops-standalone-9001.data --sort symbol,dso -n
```

Use `perf evlist -v -i CAPTURE` to inspect actual sample/read formats. Use `perf script -d -i CAPTURE -F event` to check ordering, and the report header for lost records. Preserve read/analysis errors instead of treating partial output as a valid complete report.

Build `profile-join.c`, disassemble the exact executable with `objdump -d --no-show-raw-insn -Mintel`, and export standalone IBS addresses with `perf script -F ip,sym,dso`. The join command is:

```sh
cc -O2 -Wall -Wextra profile-join.c -o profile-join
./profile-join compiler.dis addresses.txt instruction-samples.csv instruction-summary.json
```

All 402,497 compiler samples in the final target standalone IBS recording match exact addresses. `hot-address-source-lines.txt`, `value-zeroing-assembly.txt` and `libc-memset-assembly.txt` retain the source/assembly evidence for the examples in the report.

`ibs-raw-summary.c` reads perf's decoded raw IBS register dump from standard input and uses the exact-address CSV to identify compiler operations. It recovers completion-to-retirement and tag-to-retirement distributions for all matched operations, plus per-function branch/memory flags. Unlike perf's default cache-miss weight fields, these raw latency counters are present for ordinary sampled operations too.

```sh
cc -O2 -Wall -Wextra -Werror ibs-raw-summary.c -o ibs-raw-summary
DEBUGINFOD_URLS= perf script -D -i ../raw/9700x/ibs-ops-standalone-9001.data \
  | ./ibs-raw-summary ../raw/9700x/instruction-samples.csv ibs-raw-summary.json ibs-function-latencies.csv
```

The decoder reports invalid instruction-pointer flags and saturated counters explicitly. It matches addresses rather than trusting the analyzing machine's default kernel symbols. The category distributions can overlap and their latencies overlap in flight. Do not add them to wall time or call completion-to-retirement the instruction's own execution latency.

## uops.info and generated-code validation

The official XML input is `https://uops.info/instructions.xml`, dataset date 2026-03-29. Its SHA-256 is `e5e702caaf04c4fc1f75192a9bbe4d8554b3e174f7933a14d124cc33ca677ab3`. Compile the original extraction tool with `cc -O2 uops-extract.c $(pkg-config --cflags --libs libxml-2.0) -o uops-extract`; run `./uops-extract instructions.xml > uops-selected.csv`. The CSV separates measured loop/unrolled throughput, port-derived estimates and documented data for exact instruction forms. It is a selected extract, not a compiler throughput simulator. Attribute the measurements to [uops.info](https://uops.info/).

Compile `sqlite-smoke.c` with the frozen `sqlite3.h` and the actual object emitted by the measured compiler, linking `-lm -ldl`. Compare with Clang's SQLite object built under the same four feature macros. TCC's object requires its runtime/linker support; the control was linked using TCC. Successful controls print `rows=173 digest=d15437170bc02c7d`. The exact validated target object is retained with its hash. This validates the selected program paths, not complete compiler conformance or equivalent generated-program performance.
