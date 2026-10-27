# Buster compiler bottlenecks on the Ryzen 7 9700X

Measured on 27 October 2026. Compiler source: `buster14a/buster` at **92c025e71856d13eb34247477c5294d2cead139e**, the remote `main` observed at the start of this investigation. All performance figures below are new measurements of that frozen revision. Later changes on other branches are not included.

## The result

**Full object compilation reaches about 188 MB/s across eight physical cores on the frozen SQLite workload. The immediate target needs roughly 5.3× more throughput.** The larger problem is the amount and lifetime of intermediate data, followed by the semantic work performed for each source byte. The existing SIMD front end is already much faster than the complete compiler.

| Configuration | Full object throughput, median | Range across five rounds | User IPC |
|---|---:|---:|---:|
| One compilation, one core, one lane | 63.79 MB/s | 57.61–63.90 | 2.24 |
| Two independent compilations | 106.55 MB/s | 106.53–107.67 | 1.96 |
| Four independent compilations | 159.31 MB/s | 157.69–159.81 | 1.54 |
| Eight independent compilations, one per physical core | **187.53 MB/s** | **185.72–188.25** | **0.99** |
| Fifteen compilations on every online logical CPU | 182.18 MB/s | 182.12–182.64 | 0.51 |

Each round compiles four copies per requested worker as fresh processes. Worker counts rotate through the rounds. The first one-core round incurred cold executable/file faults; its result is retained in the range. Eight workers achieve about 2.94× the one-core throughput, or 37% of ideal linear scaling. All eight cores are busy: CPU time divided by wall time is about 7.8. Adding SMT workers makes throughput about 2.9% worse.

The work count barely changes: **165.34 user instructions and about 148 retired macro-ops per original source byte**. The user cycles per byte rise from approximately 74 on one core to 167 across eight. This is evidence of a scaling problem in addition to an excessive work budget; it is not a case of idle worker cores waiting for a single external task queue.

These are decimal MB/s and GB/s. The denominator is the original 9,507,037-byte `sqlite3.c` for each successful compilation. It includes comments and inactive source. The exact configuration produces **716,157 preprocessed parser tokens**. The eight-core baseline therefore processes about **14.1 million tokens/s**. A 1 GB/s target on this case corresponds to approximately **75.3 million tokens/s**.

This is aggregate throughput over independent translation units. It does not mean one translation unit is compiled at 188 MB/s.

## The memory traffic is large enough to rule out a small instruction-tuning fix

A separate long eight-core run compiled 128 translation units, or 1.2169 GB of original source, at 192.55 MB/s. The UMC counters ran for their full enabled time, without multiplexing:

| Measurement | Observation |
|---|---:|
| DRAM read CAS commands, both controllers | 3,166,659,711 |
| DRAM write CAS commands, both controllers | 1,943,081,928 |
| Traffic using the Linux AMD event definition, 64 bytes/CAS | **327.02 GB** |
| DRAM traffic / original source bytes | **268.74 bytes/byte** |
| Sustained physical DRAM traffic over the counter interval | **51.62 GB/s** |
| Memory-controller data-bus utilization | About 62% on each controller |
| Package energy | 525.37 J |
| Package average power over the counter interval | About 82.9 W |
| Energy per original source byte | About 432 nJ/byte |
| Sampled L3 fill/miss latency reported by this CPU's perf metric | About 208 ns |

System-wide counters include the kernel, file cache, controller process, and normal background activity. The shared benchmark lock excluded other compiler campaigns and CI from the measured interval. These values describe whole-machine traffic while compiling; they are not user-code load counts.

The 9700X has two populated 32 GB DDR5 DIMMs. Firmware reports **5200 MT/s configured**, despite the modules' nominal 5600 MT/s rating. Two 64-bit channels at that configured rate have a theoretical data-transfer ceiling of **83.2 GB/s**, before protocol overhead.

At the current traffic amplification:

- **1 GB/s source throughput needs about 269 GB/s of DRAM traffic.** Even the theoretical channel ceiling permits only about **310 MB/s** at that amplification.
- At the observed 51.6 GB/s traffic rate, 1 GB/s requires **at most about 52 DRAM bytes per source byte**, a **5.2× reduction** from the measured footprint in traffic.
- Even at the theoretical 83.2 GB/s ceiling, the target needs traffic at or below 83 bytes/source byte: a **3.2× reduction**.
- **1 GB/s per core means 8 GB/s aggregate.** At the theoretical channel ceiling, the complete compiler would have only **10.4 DRAM bytes per source byte**. At the current traffic rate it would have about 6.5. That calls for a different storage and streaming design, not a few faster vector instructions.

Traffic amplification is distinct from peak resident memory. Each one-lane process peaks around **519,000–520,000 KiB, approximately 532 MB**, for 9.5 MB of top-level source: about 56 resident bytes/source byte. Eight coincident per-process peaks would be approximately 4.26 GB; that multiplication is an estimate, not a sampled aggregate RSS peak. The same arrays are cleared, traversed, copied, and revisited, so DRAM traffic is much larger than RSS.

An independent original AVX-512 integer streaming calibration measured about **40.5 GB/s of logical array traffic** across eight cores. Logical read/write bytes in that calibration exclude effects such as write allocation and page initialization; they must not be equated to UMC physical traffic. It is a workload calibration, not a replacement for the 83.2 GB/s theoretical limit.

### An exposed bandwidth metric gives inconsistent results on this client CPU

The individually collected Data Fabric bandwidth metrics initially suggested roughly 82.7 GB/s of DRAM reads and almost no writes. Two additional controls collect the relevant DF metric and both UMCs simultaneously over the same 64-compilation execution:

| Same-run control | DF-derived value | UMC-derived value | Minimum counter coverage |
|---|---:|---:|---:|
| DRAM reads | **85.08 GB/s** | **31.65 GB/s** | 100% |
| DRAM writes | **0.0000084 GB/s** | **19.37 GB/s** | 100% |

The read control's UMC write rate is also 19.43 GB/s; the write control's UMC read rate is 31.55 GB/s. The UMC total therefore remains around 51 GB/s in both executions, agreeing with the longer primary run. The DF read value alone exceeds the configured channels' theoretical aggregate rate. This discrepancy is not explained by multiplexing or by comparing separate workload intervals.

The exposed DF expressions sum twelve DRAM-channel aliases, while this client has two populated memory channels. Exposure and successful scheduling do not establish that those aliases map meaningfully on this SKU. **Reject these DF-derived bandwidth values for this investigation until their client event mapping is validated.** The exact mapping/driver/catalog cause has not been established; this is an instrumentation-validity finding, not a demonstrated compiler defect. `df-umc-validation.json` and `method/df-umc-check.sh` preserve the results and reproducer. The traffic budgets in this report use UMC CAS counts throughout.

## Sampling and counters point to the same bottlenecks

The standalone all-core cycle profile contains about 127,000 samples and reports **zero lost samples**. It attributes:

| Location | Share of sampled cycles |
|---|---:|
| Kernel `clear_page_erms` | **21.55%** |
| `check_input_expressions` | 8.77% |
| `check_input_run` | 7.14% |
| Two hot instructions inside libc's AVX-512 `memset` loop | At least 6.58% |
| `check_input_resolve_range` | 3.52% |
| `check_program` | 2.91% |
| `check_graph_validate_vector` | 2.13% |
| `check_graph_run` | 2.09% |

By module, the compiler accounts for 67.54%, the kernel 24.81%, and libc 7.63%. Disassembly identifies the hot libc offsets as `__memset_avx512_unaligned_erms`; the stores are already full-width ZMM stores. Replacing scalar code with AVX-512 cannot eliminate bytes that are already being filled by AVX-512 or kernel clearing.

A separate kernel counter run measured about 31.8 billion kernel cycles and 2.48 billion kernel instructions over 64 compiles. Its very low kernel IPC is consistent with bulk clearing and memory waits. Only six major faults occurred across the run. Storage reads of the source are not a plausible explanation for the whole throughput gap in this warm-file-cache experiment.

The raw user-mode dispatch events, normalized to each event's concurrently measured cycles and instructions, put roughly **69.5% of dispatch slots in backend stalls**, around **15.6% in frontend starvation**, and about **11% in retiring macro-ops**. FP-scheduler and reorder-buffer resource-stall events are each around 4.5–4.8% of user cycles in the initial catalog block. These events have different denominators and can overlap; their percentages must not be added to the cycle-profile percentages.

The retired branch events report approximately 29 branches and 0.47 branch mispredictions per source byte, or about a 1.6% misprediction rate. Branch work is substantial, but the evidence does not support treating branch prediction or a single expensive vector instruction as the main explanation for the fivefold gap.

The complete event sweep adds useful detail:

| User event or resource | Normalized observation | Implication |
|---|---:|---|
| Integer physical-register resource stalls | 25.74% of user cycles | Dependent work and long-lived in-flight state deserve attention |
| Store-queue resource stalls | 23.72% of user cycles | Bulk stores and delayed memory progress are material |
| Reorder-buffer resource stalls | 4.75% of user cycles | Less prevalent than the store/register events |
| FP-scheduler resource stalls | 4.48% of user cycles | Making the vector arithmetic units busier is not the main target |
| Load-queue resource stalls | 4.41% of user cycles | Load-side pressure also exists |
| Demand instruction/data requests missing L2, excluding L2 prefetch | 4.61 per 1,000 user instructions | Cache misses remain relevant despite high L1 hit rates |
| Instruction-cache fills from L2 | 2.77 per 1,000 user instructions | Code delivery is a secondary area to inspect after data traffic |
| L1 DTLB misses, all page sizes | 0.130 per 1,000 user instructions | Translation misses are uncommon in the current huge-page policy |
| L1 misses that also miss L2 DTLB and request a page walk | 0.0117 per 1,000 user instructions | The data does not justify disabling huge pages as a general cure |

Resource-stall events overlap. Each row is a separate short cohort with concurrently measured cycles and instructions; this is not an additive partition of one execution. The integer-register and store-queue events identify pressure, but do not prove that changing register allocation in the bootstrap compiler would remove its underlying memory dependencies.

Separate, fully scheduled system-wide metric controls report **63.61% of dispatch slots backend bound**, with **62.03% attributed to memory** and **1.65% to CPU resources**, and **25.14% frontend bound**. These include kernel execution and differ from the user-only raw-event population above. They reinforce memory as the first constraint; they are not cycle-time shares or a single coherent partition assembled from independent runs.

The collection includes standalone cycle sampling, sampling with simultaneous counter-group reads, IBS operation-count sampling, IBS cycle-count sampling, IBS fetch sampling, and branch-stack sampling. The successful simultaneous run records **25,834 synchronous reads of the four-member user cycle/instruction/branch/misprediction group**, alongside **235,008 IBS operation samples and 30,021 IBS fetch samples**. It has **zero lost samples and zero misordered timestamps**. Group counts are snapshots at sample boundaries; their deltas cover the preceding interval and are not the isolated cost of the instruction where sampling landed. Whole-run totals come from the separate direct-counter cohorts.

Sampling populations differ. Ordinary cycle samples can skid. IBS operation-count samples describe sampled retired operations, not elapsed-time percentages. IBS cycle-count samples emphasize operations selected during long dispatch/retirement intervals. Summed load-miss latencies are not additive wall time because misses overlap. The raw files preserve those distinctions.

The standalone IBS operation capture contains **427,506 samples**, including **402,497 compiler samples**, all matched to exact instruction addresses. Its report has zero lost samples and its ordering check has zero misordered timestamps. Among the compiler samples, **30,521 use ZMM registers, 8,072 XMM and 1,680 YMM**: respectively 7.58%, 2.01% and 0.42%. These are sampled register-width classes, not SIMD lane occupancy. Mask operations and instructions without those vector register operands remain in the other class.

The same IBS capture has 142,912 compiler load samples. Of these, 139,780 are labeled L1 hits, 1,286 L2 hits, 196 L3 hits and 1,650 RAM hits. Linux emits the cache-miss latency weight only for sampled loads that miss L1; zero weights on L1 hits do not mean zero-cycle loads. The miss-latency distributions are:

| Reported data source | Samples | Median cycles | 90th percentile cycles | 99th percentile cycles |
|---|---:|---:|---:|---:|
| L2 | 1,286 | 12 | 756 | 4,640 |
| L3 | 196 | 47 | 642 | 5,190 |
| RAM | 1,650 | 711 | 1,812 | 6,392 |

The long tails include contention, translation and queueing effects; these are not isolated cache access benchmarks. RAM's mean is about 991 core cycles. A high proportion of sampled L1 hits does not contradict bandwidth pressure: kernel clearing, write allocation, stores, prefetches and overlapping misses all contribute traffic that this compiler-load subset does not count. See the [Linux IBS weight extraction](https://github.com/torvalds/linux/blob/v6.18/arch/x86/events/amd/ibs.c) for the exact field population.

The raw IBS registers also preserve tag-to-retirement and completion-to-retirement counters for ordinary operations, beyond the cache-miss weights that perf exposes by default. The original C decoder joins them back to the same 402,497 compiler addresses. No compiler sample has a saturated 16-bit latency counter or completion-to-retirement greater than tag-to-retirement. Eighteen invalid-RIP records exist in the whole capture and are excluded from this address-based analysis.

| Compiler operation population | Samples | Median tag to retirement | 90th percentile tag to retirement | Median completion to retirement |
|---|---:|---:|---:|---:|
| All selected compiler operations | 402,497 | 37 cycles | 821 cycles | 19 cycles |
| Loads | 142,912 | 34 | 788 | 16 |
| Stores | 50,570 | 35 | 729 | 14 |
| Branches | 78,800 | 33 | 817 | 16 |
| Loads missing L1 | 3,132 | 551 | 1,864 | 13 |

The means for all selected compiler operations are **230.54 cycles from tag to retirement and 181.98 from completion to retirement**. Within `check_input_expressions`, they are approximately 332 and 304 cycles. Completed younger operations can wait behind older work before retiring; these values support investigating memory dependencies and head-of-line blocking rather than interpreting a sampled address as a 300-cycle arithmetic instruction. Operations overlap in flight, and the categories overlap where the hardware flags do, so these lifetimes cannot be summed into elapsed time. `ibs-function-latencies.csv` preserves per-function counts, means and branch/memory flags.

## Where a single compilation spends its time

The instrumented production driver reports approximately 148 ms inside its stages on one core. The table below shows a representative one-lane run; the retained reports include five repeats.

| Stage | Time | Share of driver span |
|---|---:|---:|
| Preprocess | 9.32 ms | 6.3% |
| Parse | 9.53 ms | 6.5% |
| Semantic input construction (`check-input`) | **65.04 ms** | **44.1%** |
| Expression checking | 15.42 ms | 10.5% |
| Declaration checking | 5.43 ms | 3.7% |
| Program checking | 12.29 ms | 8.3% |
| Lowering | 15.56 ms | 10.6% |
| Tier 0 | 4.96 ms | 3.4% |
| Branch sizing | 0.47 ms | 0.3% |
| Encoding | 0.41 ms | 0.3% |
| Object construction + write | 0.93 ms | 0.6% |

The checker-related stages dominate. The encoder and object writer are small on this workload; even eliminating them would leave the target largely untouched. Repeated whole-unit semantic representations, their initialization, and their transitions deserve attention first.

The separate CLI controls reinforce this conclusion:

| Command contract | Eight-core aggregate throughput, median |
|---|---:|
| `-E`, including text rendering to `/dev/null` | 2.22 GB/s |
| `parse -fsyntax-only`, tree-only syntax parsing | 1.11 GB/s |
| `-fsyntax-only`, including semantic checking | 211 MB/s |
| `-c`, complete Tier 0 object compilation | About 184–193 MB/s across these campaigns |

These are different contracts. In particular, `-E` includes rendering that the parser does not perform, and the parser-only command skips optional traversal products that the checker needs. Do not subtract these CLI timings to estimate production stage costs; use the stage-clock reports above.

## Two different parallelism problems

### Independent files saturate memory before eightfold speedup

Eight processes, each pinned to one physical core and using one lane, are busy but achieve less than threefold scaling. Instructions/source byte remain essentially constant while cycles/source byte more than double. The UMC traffic and the clearing profile explain why adding threads cannot recover the missing throughput.

### One large file retains a long serial prefix

| Lanes inside one translation unit | Median throughput |
|---|---:|
| 1 | 63.88 MB/s |
| 2 | 67.31 MB/s |
| 4 | 69.85 MB/s |
| 8 | 70.79 MB/s |

Eight backend lanes improve one-file throughput by about **10.8%**. In the eight-lane stage report, the semantic reader still takes roughly 66 ms, expression checking 15 ms, and program checking 12 ms. The lane span shrinks part of the backend, but leaves most latency in front of it.

The next parallel boundary needs to encompass useful semantic/function work, with correct declaration-point environments, one writer for mutable facts, and bounded per-worker memory. Merely creating more backend threads cannot hide the measured serial prefix.

Nested translation-unit and function parallelism also needs one explicit budget. In three rotated rounds, eight file processes with one lane each reach a median **184.23 MB/s**. Giving each process eight internal lanes reaches **178.56 MB/s**; the default lane policy reaches **178.89 MB/s**. Involuntary context switches rise from 28–58 per cohort to 271–369. The roughly 3% throughput loss is worth fixing, although it cannot account for the much larger target gap.

## What SIMD changes in the complete pipeline

Three paired rounds with eight physical-core workers give the following medians:

| Pipeline | Throughput | User instructions per source byte | User IPC |
|---|---:|---:|---:|
| Production vector paths | **183.82 MB/s** | **165.34** | 0.98 |
| Test scalar reference paths | 173.37 MB/s | 318.30 | 1.73 |

The vector paths remove about 48% of user instructions but improve complete throughput by only **6.0%**. The `--scalar` switch also selects different reference algorithms, so this is a pipeline comparison rather than a pure vector-width toggle. The result is still decisive about priorities: reducing instruction count and raising IPC are not interchangeable with reducing elapsed time. The smaller vector work stream still encounters the large memory footprint and traffic.

A separate production-vector clock control records an **APERF/MPERF ratio of 1.420**, corresponding to approximately **5.39 GHz during active execution** using its 3.793 GHz reference counter rate. This is an aggregate active-frequency estimate across the monitored physical cores, rather than a fixed clock setting or a measurement of every scalar/vector path. It provides no indication of a large frequency collapse in that production run.

## Source-level causes and concrete directions

These are performance findings and design candidates. They are not claims of a newly proven language-correctness bug.

1. **Token-sized columns for rare facts, plus whole-column initialization.** [`check_input_run`](https://github.com/buster14a/buster/blob/92c025e71856d13eb34247477c5294d2cead139e/src/buster/compiler/c_check_input.c#L4658) allocates many output and scratch columns at `token_count + 1`, including facts for relatively rare syntax. The initialization region contains many full `memset`s and a per-token sentinel-fill loop. The stage adds **267,680 KiB, approximately 274 MB**, to the resident high-water mark in the representative run.

   This revision already performs a token census for selected capacities, including VLA, asm and builtin-constant storage. Extend that approach to the remaining columns by measuring each column's useful occupancy and bytes initialized/read/written. Move rare facts to compact side tables, use small bitsets to select meaningful entries, and make unconditionally consumed common columns compact and contiguous. Where data is written before any valid read, eliminate redundant fills with an explicit lifetime proof. Generation tags or sparse defaults need to earn their extra lookup work against the instruction budget.

2. **A large general-purpose value payload on the hot path.** [`CheckValue`](https://github.com/buster14a/buster/blob/92c025e71856d13eb34247477c5294d2cead139e/src/buster/compiler/c_check_actions.c#L73) contains 128-bit integer storage, two long-double components, object/overload/offset facts, and fault metadata. The reader and later checker carry substantial value storage and transitions. The sampled assembly includes long-double stores in value construction, even though most of this source is integer and pointer code.

   At `check_input_expressions` source line 3772, identifier leaf construction emits `fldz`, `fld st(0)` and two `fstp TBYTE PTR` stores to the floating and imaginary fields. The two stores at `0x81c302` and `0x81c307` receive 526 and 460 precise IBS operation samples. This directly connects an integer/pointer-heavy semantic path to initialization of cold floating payloads.

   Separate common type/category/flag facts from cold constant, complex, overload, and fault payloads. Use dense IDs and contiguous hot columns, with explicit initialization and ownership. Do not replace a large record with another pointer-heavy graph that merely trades bandwidth for dependent misses. Existing related work includes [PR #617](https://github.com/buster14a/buster/pull/617); its proposed footprint reduction must be measured on its own revision before assigning it any speedup here.

3. **A serial, pointer-dependent semantic construction walk.** [`check_input_expressions`](https://github.com/buster14a/buster/blob/92c025e71856d13eb34247477c5294d2cead139e/src/buster/compiler/c_check_input.c#L3625) visits the complete postorder and follows child/value links while testing many syntax cases. This is the hottest compiler function in the cycle profile. The existence of SIMD kernels elsewhere does not make this walk data parallel.

   Compact the actual semantic node stream, batch independent nodes with the same operation, retain derived facts once, and replace linked sibling/value walks with bounded contiguous ranges where that reduces total work. Measure fused construction/checking or function-owned processing against the full cost of building and traversing the intermediate graph. Preserve diagnostics, unevaluated contexts, source-point visibility, and all required checks.

4. **Repeated page commitment and teardown.** Every fresh compiler process commits hundreds of megabytes and releases them. Kernel clearing alone occupies over a fifth of the all-core cycle samples. User-space clearing then adds another large pass over memory.

   A multi-translation-unit invocation with persistent workers could reuse private backing pages and bounded buffers while resetting all semantic state correctly. That is buffer reuse, not permission to reuse stale macro/type/binding state. Publish cold-process and batch-throughput results separately. Prefer fixing working-set amplification before adding large caches or more workers.

5. **Diagnostic preparation scans the token domain even on successful input.** [`check_driver_reports`](https://github.com/buster14a/buster/blob/92c025e71856d13eb34247477c5294d2cead139e/src/buster/compiler/c_checker_driver.c#L212) allocates and initializes per-token warning storage when warnings are enabled, then collects warning information. It appears in both cycle and IBS operation profiles.

   Accumulate sparse warning candidates while producing the relevant facts, or use compact candidate masks and one ordered merge. Keep the normal diagnostic contract. Turning off warnings to improve a benchmark is a different compilation contract, not an equivalent optimization.

6. **Code and instruction-form tuning is useful after the big work reductions.** The native `check_input_run` function spans 79,818 machine-code bytes; `check_input_expressions` spans 22,756 and `check_input_resolve_range` 24,376. Each core has a 32 KiB L1 instruction cache. Precise operation samples touch 7,480 distinct compiler code cache lines, totaling 478,720 bytes, over the complete capture. That cumulative sample footprint is not a measured instantaneous instruction working set, but it supports inspecting hot/cold separation and excessive inlining alongside the frontend counters.

   Use the retained assembly, precise sampled addresses, counter catalog, and instruction-form data to select actual hot loops. Investigate cold semantic/error cases, load dependencies, store forwarding and code placement without hiding necessary checks. Re-test whole compilation at several code placements for small changes; a single favorable layout is insufficient proof.

## How uops.info informs the SIMD investigation

The investigation downloads the official **29 March 2026 machine-readable dataset**, retains its hash, and extracts the relevant measured and documented Zen 4/Zen 5 instruction forms into `uops-selected.csv`. Measurement rows and documentation rows are separate.

Examples from the Zen 5 measured data:

| Instruction form | Reciprocal throughput in the measured loop | Why it matters |
|---|---:|---|
| `VPGATHERDD zmm{k}, [VSIB-zmm]` | About 12.6 cycles | A gather is not the cost of a contiguous vector load; avoid using it as a cheap substitute for a better layout |
| `VPGATHERDQ zmm{k}, [VSIB-ymm]` | About 6.1 cycles | This actual Tier 0 form differs from the gather used in branch sizing |
| `VPCOMPRESSD zmm{k}, zmm` | About 1 cycle | Register compaction can support dense candidate streams |
| `VPCOMPRESSD [mem]{k}, zmm` | About 3 cycles | The memory-destination form has a different cost from register compaction |

The source and sampled assembly are joined by exact instruction address. The Tier 0 gather at `0x124d06e` has 443 precise operation samples, or 0.110% of compiler samples; branch sizing's gather at `0x120d820` has 315, or 0.078%. Those shares do not estimate latency or potential speedup, but they place the instruction-form investigation in the full workload. Register widths are reported as XMM/YMM/ZMM usage, not as active-lane utilization or useful work per instruction. A masked vector instruction with one live lane is still a ZMM instruction in this classification.

uops.info's cache-resident instruction measurements do not include this compiler's DRAM misses, allocation, data dependencies, or all-core power behavior. Summing reciprocal throughputs would not predict compilation time. Documentation-only entries and port-derived estimates are not treated as hardware measurements.

Primary references: [uops.info XML dataset](https://uops.info/xml.html), [gather form](https://uops.info/html-instr/VPGATHERDD_ZMM_K_VSIB_ZMM.html), [register compression](https://www.uops.info/html-instr/VPCOMPRESSD_ZMM_K_ZMM.html), [memory compression](https://www.uops.info/html-instr/VPCOMPRESSD_M512_K_ZMM.html). AMD explains the distinct sampling populations in its [IBS introduction](https://docs.amd.com/r/en-US/68658-uProf-getting-started-guide/Introduction-to-IBS-Instruction-Based-Sampling) and [IBS derived-event definitions](https://docs.amd.com/r/en-US/57368-uProf-user-guide/7.9.3.2.4.-IBS-Derived-Events).

## What AMD uProf would add

For this investigation, μProf's main advantage would be an integrated analysis workflow: AMD's predefined collection profiles and derived metrics, source/assembly views, call-stack and thread views, and packaged system/uncore/energy monitoring where the platform supports it. In particular, its IBS-derived views spare the manual decoding and aggregation used here for memory sources, miss latency and retirement delays. See the [AMD μProf overview](https://www.amd.com/en/developer/uprof.html) and [AMDuProfPcm options](https://docs.amd.com/r/en-US/57368-uProf-user-guide/4.5.-AMDuProfPcm-Command-Line-Options).

Linux perf already captures the core PMCs, raw IBS operation/fetch registers, branch stacks, UMC/L3 counts and energy data used in this report. Loading the matching uncore driver, collecting small counter groups, joining exact assembly addresses and decoding the raw IBS fields made the relevant evidence available without installing μProf. uops.info supplies separate instruction-form measurements that can inform either tool's profiles.

## A budget for 1 GB/s

Perfect scaling of today's one-core result would produce only about **510 MB/s** at that one-core operating point. Recovering scaling alone is insufficient. The compiler also needs approximately a twofold or larger reduction in per-core work, with the exact requirement depending on clocks, useful IPC, and kernel overhead after the memory redesign.

A practical first design budget for **1 GB/s aggregate** is:

- **Below roughly 50–80 DRAM bytes/source byte**, depending on sustainable bandwidth. Use the lower end to leave real headroom.
- **Roughly 60–80 user instructions/source byte**, conditional on recovering useful IPC around 2–2.5 and maintaining high aggregate user-cycle availability. This is a planning envelope, not a measured future result.
- A small enough hot working set to retain function-local facts in cache, rather than multiplying a half-gigabyte translation-unit image across workers.
- One concurrency budget across files, semantic work, lowering, and code generation.
- Identical successful behavior, diagnostics, and supported semantics, with emitted code quality measured independently.

The reader's 65 ms is already close to the **76 ms per 9.5 MB translation unit** that one of eight perfectly scaling workers would have at 1 GB/s aggregate. It leaves essentially no budget for the rest of today's pipeline. For **1 GB/s per core**, the entire 9.5 MB compile must finish in **9.5 ms**; today's preprocessing plus parsing alone exceeds that.

Suggested sequence:

1. **Establish a 250 MB/s milestone** by reducing resident working data, clearing, and rereads; retain full counter and correctness evidence. Measure existing footprint-reduction candidates first.
2. **Aim for 500 MB/s** by removing redundant semantic representations/passes and introducing a correct function-owned or batched semantic pipeline. Check work/source byte and DRAM/source byte, not only kernel timings.
3. **Attempt 1 GB/s** only when the instruction and traffic budgets make it physically plausible. Validate across a frozen corpus of large and small translation units, macro-heavy sources, system headers, invalid input, and representative build concurrency.
4. Treat **1 GB/s/core** as a separate architectural research target. It requires much less work and traffic per token, not simply another factor of eight threads.

These milestones are experiment targets. Their gains are not promised, and candidate gains cannot be multiplied together without measuring their combined implementation.

“Fastest compiler in the world by several orders of magnitude” needs a defined workload and output-quality contract. A lexer result, cached/incremental result, syntax-only result, or reduced language subset cannot establish it for complete compilation. Competitors must compile the same programs successfully, with comparable diagnostics and generated-program requirements.

## Reference compilation context

Three rotated eight-worker rounds compile this SQLite source with the same four SQLite feature macros and GNU17 mode:

| Compiler executable on the 9700X | Median throughput | User instructions per source byte | Approximate peak RSS per process |
|---|---:|---:|---:|
| Buster built natively on the 9700X | 184.65 MB/s | 165.34 | 532 MB |
| Same Buster source built on the local Zen 4 machine | 182.82 MB/s | 165.13 | 532 MB |
| TCC 0.9.28rc, packaged 2026-01-17 revision | **1,506.08 MB/s** | 56.53 | 13.6 MB |
| Clang, default unoptimized output | 112.29 MB/s | About 699 | About 221 MB |

Buster uses frozen Clang headers/predefines; the reference drivers use their normal installed headers and predefined macros. The compilers' diagnostics, language coverage and generated-code quality also differ. These results are context, not a controlled compiler ranking or a comparison of the two processors. TCC's emitted object passes the same 173-row SQLite smoke test when linked using TCC and its runtime support. Its result demonstrates that the 1 GB/s aggregate milestone alone would not establish world-leading throughput.

The next competitive benchmark should pin equivalent preprocessed inputs and required semantics, validate every output, and measure generated-program performance separately. A claim of several orders of magnitude requires that comparison across a corpus, including small-file startup costs and adversarial/invalid inputs.

## Supplemental local observations

The local Ryzen 9 7940HS has eight Zen 4 cores, with six available to these runs under the existing interactive-core reservation. Native compilation reaches medians of **48.57 MB/s on one core, 88.57 on two, 138.74 on four, 166.61 on six physical cores and 169.13 on twelve available logical CPUs**, over seven rounds. Peak RSS remains about 519,200 KiB per process. The local native binary and its own assembly/IBS join are retained separately.

Its standalone cycle profile reports zero lost samples. `check_input_expressions` accounts for 9.04%, `check_input_run` 6.80%, and `check_input_resolve_range` 5.31%; the kernel's cold page-allocation path accounts for 11.87%. A separate six-worker UMC run records **92.23 GB of physical traffic for 608.45 MB of source**, or **151.58 DRAM bytes/source byte**, at **25.80 GB/s**. Its package-energy reading is 156.56 J over 3.575 seconds, about 43.8 W gross package power. All of these uncore counters have full scheduling coverage. The traffic amplification differs from the target's experiment; it is not a constant that can be transferred between hosts or concurrency levels.

Firmware reports two 32 GiB DIMMs configured at 5600 MT/s locally. The initial recorded CPU temperature is already 91.9°C, and the machine remains a live desktop. Thermal/power policy and background activity therefore need their own controls before using local numbers for an architectural comparison.

This machine also shows poor scaling relative to the one-core result, without changing instructions or working-set design. Its allocation policy, kernel, governor, available core quota, memory and desktop activity differ, so the difference between these numbers and the 9700X numbers is not assigned to a microarchitecture feature.

| Recorded hardware or tool property | Local Ryzen 9 7940HS | Ryzen 7 9700X |
|---|---:|---:|
| CPU family | Zen 4 | Zen 5 |
| Physical cores | 8 | 8 |
| Online logical CPUs | 16 | 15 |
| Physical cores granted for these throughput runs | 6 | 8 |
| L1 data cache per core | 32 KiB | 48 KiB |
| L1 instruction cache per core | 32 KiB | 32 KiB |
| L2 cache per core | 1 MiB | 1 MiB |
| Shared L3 cache | 16 MiB | 32 MiB |
| Running kernel | 7.3.0-5-cachyos | 6.18.50-2-lts |
| perf package | 7.2.11-1 | 7.2.9-1 |

## Measurement method and limits

- The source was cloned into a task-owned checkout. The main development checkout was not modified. Both native builds use the repository's normal build: `-O3 -march=native`, with debug information retained for profiling. Bootstrap Clang is 23.1.1 on the 9700X and 23.1.4 locally. The measured generated output is the current Tier 0 object path, not an optimizing-compiler comparison.
- The workload is the frozen `sqlite3.c` with SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. It uses GNU17, frozen headers/predefines, the explicit generated-code target `znver5`, `--clang-features`, and `SQLITE_OMIT_LOAD_EXTENSION`, `SQLITE_THREADSAFE=0`, `SQLITE_ENABLE_MEMSYS5`, and `SQLITE_ENABLE_RTREE`.
- Each successful object is about 2.342 MB. Throughput includes process startup, preprocessing, syntax and semantic checking, lowering, encoding, object construction, ordinary buffered file writes, and teardown. It does not request `fsync` durability. Object deletion happens after the runner stops the timer. It excludes final executable linking.
- All target builds and measurements use the shared 9700X lock. Runs are bounded and release the machine between independent benchmark invocations. One-core controls use CPU 2; all-core runs use physical CPUs 0–7. The SMT experiment uses all 15 online logical CPUs; CPU 10 remains offline under the host's existing dedicated-core configuration.
- Boost remains enabled. CPU 2 uses the performance governor; the other target cores retain their existing policy. Frequencies were not fixed. Raw counts, wall time, resource use, energy, and clock counters are retained so policy and clock effects can be distinguished from work reduction.
- Counter suites open events on each compiler process before exec, enable them on exec, inherit through its threads, and record enabled/running time. The target sweep measures **370 exposed named core-event entries, representing 365 distinct raw encodings**, each paired with user cycles and instructions: all have **100% running coverage, zero collection errors and zero compile failures**. The five duplicate encodings are retained as their named aliases. **128 entries measure zero**; those remain zeros rather than being dropped. The supplemental local sweep measures 358 requested aliases, including aliases normalized by perf to `cycles` and `instructions`.
- All **147 exposed derived metric names** were first attempted together in the target exploratory sweep. It returns 142 finite values and five nonfinite values, with core-event duty as low as **6%**. A follow-up measures each name individually, system-wide on CPUs 0–7: **142 return finite values with 100% scheduling coverage, four return nonfinite values, and one fails before compilation because the generic LLC event is unsupported**. The original broad sweep remains marked exploratory. The supplemental local pass attempts 143 names: 104 return finite values, six nonfinite values and 33 no metric result, often because a shared uncore metric requires system-wide mode.
- Scheduling coverage establishes counter availability, not semantic validity of every exposed alias on every CPU SKU. Unsupported generic backend/LLC/prefetch events, zero denominators for nonexistent remote-memory activity, and `nan` results remain explicit in the raw records and tables. A system-wide `CPUs_utilized` metric also counts the monitored CPU-clock scope; actual benchmark CPU utilization here comes from child CPU time divided by wall time.
- The same-run DF/UMC check rejects the exposed DF DRAM bandwidth aliases on this client pending mapping validation. Their finite values remain in the tables for audit, with a separate metric-validation note. The fully scheduled UMC controls are the source of the quantitative memory-traffic conclusions.
- Kernel counts, system-wide UMC/L3/energy counts, user-only core counts, and sampled operation distributions describe different populations. They are not silently combined as if interchangeable.
- The 9700X's running kernel is Linux 6.18.50-2-lts. An update had removed its loadable module directory. The matching official cached kernel package supplied `amd-uncore.ko`; loading that module exposed the previously missing DF/L3/UMC PMUs. The local AMD uncore module was also loaded. No reboot, governor change, SMT change, or security-setting change was performed.
- AMD μProf was not installed or used because its download requires accepting a separate license. Its public documentation and AMD event information were used. Linux perf and AMD IBS supplied the measured evidence.
- The local Ryzen 9 7940HS data is supplemental. Six physical cores were available under the owner's existing two-core interactive reservation, and runs used the shared core allocator. Its desktop activity, kernel, bootstrap version, governor policy, and core quota differ from the 9700X; the data is not presented as a controlled CPU comparison.
- An early exploratory high-rate DWARF recording and an early mixed recording lost samples and were excluded from primary evidence. A later `perf record -s` mixed recording triggered `processing failed for event of type: READ ... [Bad address]` in the reader. Removing per-thread `-s` records while retaining the synchronous sampled counter group produced the readable, zero-loss, correctly ordered final combined capture. This is a reproduced profiler-format/reader interoperability problem, not a demonstrated compiler bug. Sampling overhead is excluded from the baseline throughput results.

## Correctness evidence

The actual object emitted by the profiled 9700X compiler was linked into an independent C test driver. It was exercised on both machines and compared with SQLite built by Clang. The TCC reference object also passes locally. The driver covers indexed joins, recursive CTEs, window aggregates, transactions/savepoints/rollback, RTree queries, JSON, floating-point formatting, 64-bit bound parameters, UTF-8 text, blobs, backup, and integrity checks. The 173 result rows agree at digest `d15437170bc02c7d`.

This is a useful generated-code smoke test, not full language conformance, corpus qualification, sanitizer acceptance, or a generated-program performance comparison. No newly reproduced miscompilation is asserted by this report. The established problems are throughput, working-set/traffic amplification, serial semantic work, and scaling limitations.

## Evidence and reproduction

`raw/9700x/` holds native scaling, stage reports, counter sweeps, counter attributes, standalone/combined sampling captures, and supporting reports. `raw/local/` holds the supplemental local campaigns. `hardware/` records CPU topology, toolchains, settings, module/memory information, complete exposed event/metric catalogs, and identities. `method/` contains the original C collection, memory-calibration, instruction-join, uops extraction, and SQLite validation tools.

The core catalogs enumerate named events exposed by these Linux tools and CPUs. This is not an assertion that every possible raw unit-mask combination, off-core device event, unsupported SKU feature, software probe, or model-specific register has a meaningful compiler measurement. Aliases, unsupported events, scope restrictions, zero counts, and low-coverage derived metrics must remain visible in the accompanying data.

The machine-readable counter tables and final collection manifest accompany this report. Reproduction instructions are in `method/README.md`.
