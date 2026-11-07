# Tier 1 block layout: CI runtime evidence for #1218

The existing 9700X job for [Buster PR #1737](https://github.com/buster14a/buster/pull/1737) completed successfully. All 330 measured samples and 30 warmups exited successfully and recorded hardware counters. This is a runtime observation of the tested merge; [#1218](https://github.com/buster14a/buster/issues/1218)'s compare/branch dynamic-count gate remains unproven.

## Source and execution

| Field | Recorded identity |
| --- | --- |
| Compiler repository | `buster14a/buster`, GitHub ID `1421805693` |
| PR head | `ea1a0c9886c048baf8ab9318bb9d5e39590f607e` |
| Actual tested checkout | `cab94a006fd6324a8f05d2a54a012e55dfa242b3` |
| Actual merge parents | `232b4e9e958d52dfa9ae93d9531a636a8bb01445`, then the PR head above |
| Run metadata's PR base / separate comparison worktree | `470295cbca871ebdee69591d48739d7813eb9766` |
| CI run | [42425764011](https://github.com/buster14a/buster/actions/runs/42425764011), number `4873`, attempt `1`, `pull_request`, completed successfully |
| Run start / branch | `2026-11-07T23:33:09Z` / `codex/1218-branch-layout` |
| Hardware job | [128566041616](https://github.com/buster14a/buster/actions/runs/42425764011/job/128566041616), Native tests and benchmarks on Benchpress (Ryzen 7 9700X), successful |
| Measurement step | Step 87, Time speedtest1 and Lua's scripts by both tiers, clang -O0 and -O2 and tcc, successful |
| Runner / machine | `buster-zen5-9700x` (runner `2.338.2`) / `benchpress` |
| CPU / recorded host identity | AMD Ryzen 7 9700X 8-Core Processor / `9700X/6.18.50-2-lts/0xb404038/gcc-16.2.1/glibc_2.44/sw-bdb9cac7a839f792` |
| Compiler build | Release, `znver5-g0`, `BUSTER_HOST_ARCH=znver5`, `BUSTER_DEBUG_INFO=0`, Clang `23.1.4` |
| Clang revision / target | `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5` / `x86_64-unknown-linux-gnu` |
| Evidence repository base | `buster14a/buster-performance` (ID `1432078863`), `4be4a56ef03076768be23a39ff2eb647123274e1` |

The triggering checkout records the full tested SHA at `23:44:23.6541355Z`. Its parents also match [the merge commit](https://github.com/buster14a/buster/commit/cab94a006fd6324a8f05d2a54a012e55dfa242b3). The later `470295cbca8` checkout is a separate comparison build; the earlier `2e17f0ebd3f` checkout belongs to the previous runner workspace. Neither is the actual tested merge.

The runner hook explicitly reports `this job has the machine` at `23:44:17.2026323Z` and `gave the machine back` at `23:49:43.5594603Z`, bracketing this measurement's output (`23:47:51.1856934Z`–`23:48:34.8124292Z`). The command pins the process to the first CPU in its allowed list; the numeric CPU value is not printed.

## Inputs and invocation

The [pinned workflow](https://github.com/buster14a/buster/blob/cab94a006fd6324a8f05d2a54a012e55dfa242b3/.github/workflows/9700x.yml) and [measurement harness](https://github.com/buster14a/buster/blob/cab94a006fd6324a8f05d2a54a012e55dfa242b3/src/buster/compiler/tier1_programs_measure.c) define the commands. The excerpt records SQLite and tcc hash checks as `OK`, verified cached speedtest1/Lua downloads, and the pinned script checkout.

| Input | Identity |
| --- | --- |
| SQLite 3.53.2 `sqlite3.c` | SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d` |
| `speedtest1.c` | SQLite revision `ccc132c5be20ab5c755c97a08d06b1b592fef330`; SHA-256 `b5eaf4bbcbb320fd8eb3f3e6c4cd5f51a64dd0cd70efe969634d1785e3419675` |
| Lua 5.4.8 archive | SHA-256 `4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae` |
| Five Lua scripts | Performance revision `818cfbbc0be238da287c16d8e2a91fd7275cf228`, `docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua` |
| `/usr/bin/tcc` | SHA-256 `49e2d1afd09cdab6593ca127b056ccc35fc5f3a2d0e08dae67f604db2751c082` |

```sh
taskset -c "$cpu" ./build/compiler measure-tier1-programs --runs 11 --clang clang --tcc "$tcc" --sqlite "$sqlite" --speedtest "$inputs" --lua "$inputs/lua-5.4.8/src" --scripts "$scripts" --directory /tmp
```

The excerpt preserves all variable assignments: `sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite`, `inputs=$RUNNER_TEMP/tier1-programs`, and `scripts=$PWD/build/tier1-programs-evidence/docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua`. The environment identifies `build/cmake/znver5-g0/Release/compiler` in the triggering checkout; the harness created `/tmp/measure-tier1-programs-3zp2qV`.

Tier 1 uses `--tier1 -fno-asynchronous-unwind-tables`. SQLite uses `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE` and runs `--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1`, resetting database/temporary files outside timing. Lua uses `-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -lm -ldl` (tcc omits `-std=gnu99`).

## Results

All five builds produced speedtest1's verification hash `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`. Every Lua script matched clang `-O0` output byte for byte. The 360 samples comprise one warmup and 11 rotating measured rounds for six workloads and five builds: `tier0`, `tier1`, `clang0`, `clang2`, `tcc`. All have `status=0`, `counted=1`; each workload/build pair has exactly 11 measured samples.

| Workload | Tier 1 median, ms | clang -O2 median, ms | Tier 1 / clang -O2 |
| --- | ---: | ---: | ---: |
| speedtest1 | 194.093377 | 129.121433 | 1.503185 |
| calls.lua | 28.150658 | 17.657812 | 1.594233 |
| tables.lua | 47.296433 | 32.984015 | 1.433920 |
| strings.lua | 51.352541 | 36.749262 | 1.397376 |
| arithmetic.lua | 49.012174 | 32.939081 | 1.487964 |
| closures.lua | 67.083367 | 45.244441 | 1.482687 |

Each median is the sixth sorted integer `wall_ns` value among the 11 `phase=measured` rows for that workload/build, divided by 1,000,000. Ratios divide exact nanosecond medians before rounding. Warmups are excluded; no measured samples are rejected or trimmed. Wall time covers exec release through `wait4` return; raw user-cycle/instruction counters cover whole processes, including all threads.

## Raw evidence and extraction

The complete decoded log was fetched with `github_fetch_workflow_job_logs` for `buster14a/buster`, job `128566041616`. This archive retains the relevant excerpts, preserving timestamps, ANSI sequences, whitespace and line order; the provenance file retains its initial UTF-8 BOM.

| File | Source selection | Bytes / lines |
| --- | --- | ---: |
| [9700x/measure-tier1-programs.log](9700x/measure-tier1-programs.log) | Complete measurement step: full-log lines 2368–2822 | 51,674 / 455 |
| [9700x/provenance.log](9700x/provenance.log) | Full-log lines 1–497, 2226–2367, 3204–3211 concatenated in order, with no inserted separators | 69,477 / 647 |
| [9700x/runs.tsv](9700x/runs.tsv) | All normalized `tier1-programs-run` records: header plus 360 samples | 29,465 / 361 |

Full-log ranges are one-based and inclusive. Normalization removes only each matching line's timestamp and separating space, retaining header, warmups, order, positions, status and counted fields. Reproduce from this directory:

```sh
sed -n '/^[^ ]* tier1-programs-run\t/s/^[^ ]* //p' 9700x/measure-tier1-programs.log >9700x/runs.tsv
```

Raw-file SHA-256 digests ([SHA256SUMS](SHA256SUMS) additionally covers this report):

```text
705023099df46388849e744a8422dae1b25cee5679c390530bcf26bf503ccefd  9700x/measure-tier1-programs.log
416bad330195cbc527a176d151d4ab7738dea9a711941e19e8b147b1d933cfc0  9700x/provenance.log
d85646659cd8cd7e7ac418b3531f51edd7644f3e78ed465f6cae1942511b56e2  9700x/runs.tsv
```

## Limits and provenance

- This is one measurement session and one layout per program build, at the tested merge. It is not a measurement of the PR head in isolation or a paired before/after layout experiment; separate base builds used by other CI steps do not establish a speedup for these workloads.
- The log lacks digests of the Buster compiler, generated speedtest1/Lua binaries and individual clang executable; individual Lua-source/script hashes; tcc's version string; and the numeric CPU pin. Source archive hashes and the script revision supply the recorded input identities. The command omits `--keep`, and this archive contains no program binaries.
- No Callgrind opcode categories were captured. Whole-process instruction counts and wall-time ratios do not establish #1218's compare/branch dynamic-count threshold of at most `1.3x` clang `-O2`; that gate remains unproven.

SQLite, Lua and toolchains were external runtime inputs; no upstream implementation or corpus is incorporated here. Original report text follows this repository's retained Apache-2.0 WITH LLVM-exception terms.
