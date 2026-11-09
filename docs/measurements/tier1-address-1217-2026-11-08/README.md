<!-- SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception -->
# #1217: CI runtime evidence for PR #1740

This record preserves the successful [CI run](https://github.com/buster14a/buster/actions/runs/42426133513) and [9700X hardware job](https://github.com/buster14a/buster/actions/runs/42426133513/job/128567077539) for [buster14a/buster#1740](https://github.com/buster14a/buster/pull/1740), implementing shared-address folding, coalesced ADD emission and validated jump-table base reuse/hoisting.

**This is runtime evidence, not complete acceptance of [#1217](https://github.com/buster14a/buster/issues/1217).** The corrected #1189 dynamic non-frame LEA/power-of-two IMUL breakdown and real SQLite/Lua dispatch inspection were not performed. A separate paired workload also records a lexer regression that still needs diagnosis.

## Source and measurement identity

| Role | Revision |
|---|---|
| PR head | `7d5155cddf89c4968123986d11eb06117a204d8b` |
| Actual tested merge checkout | `00034f42e4f2be795afc0a4d592f08a078f7bd9b` |
| Tested merge's main parent | `232b4e9e958d52dfa9ae93d9531a636a8bb01445` |
| Separate rows benchmark's CI base compiler | `470295cbca871ebdee69591d48739d7813eb9766` |

The rows base is the logged `AB_BASE_SHA`, verified by the job before `--base` is passed. It differs from the tested merge's main parent: the comparison includes intervening main changes from #1730 as well as #1740. It does not isolate #1740.

Hardware: AMD Ryzen 7 9700X, runner `buster-zen5-9700x`, fingerprint `9700X/6.18.50-2-lts/0xb404038/gcc-16.2.1/glibc_2.44/sw-bdb9cac7a839f792`. The shared machine lock spans 2026-11-07 23:58:05.173 UTC through 2026-11-08 00:03:31.935 UTC. Program measurements occur inside that interval. The command pins to the first allowed CPU with `taskset`; the resolved numeric CPU is not printed and is not asserted here.

Clang is 23.1.4, LLVM `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`. Each program/build gets one warm-up and 11 measured whole-process executions. Order rotates by round. Wall time, user cycles and instructions each have their own median; ranges in the receipt are minimum/maximum wall time. Generated executable and current compiler binary digests are unavailable.

## SQLite and five Lua programs

| Program | Tier 1 median wall ms | Clang -O2 median wall ms | Tier 1 / Clang |
|---|---:|---:|---:|
| speedtest1 | 195.795 | 128.908 | 1.519 |
| calls | 29.805 | 17.795 | 1.675 |
| tables | 46.275 | 33.002 | 1.402 |
| strings | 52.002 | 36.906 | 1.409 |
| arithmetic | 48.339 | 32.960 | 1.467 |
| closures | 67.331 | 45.134 | 1.492 |

The Lua values sum to **243.752 ms** for Tier 1 and **165.797 ms** for Clang -O2, a ratio of **1.470**. This is a sum of independent script medians, not a median of combined script executions.

The command measures current Tier 0, current Tier 1, Clang -O0, Clang -O2 and tcc. **It has no pre-change compiler baseline.** These numbers do not establish how much #1740 changed the six programs' runtime.

All five speedtest1 builds produce verification hash `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`. Every Lua output matches Clang -O0 byte-for-byte. The log contains 360 program observations: 30 warm-ups and 330 measured executions, each with exit status 0 and counted=1.

Exact invocation, with the job's checked variable definitions retained in the log:

```bash
taskset -c "$cpu" ./build/compiler measure-tier1-programs --runs 11 --clang clang --tcc "$tcc" --sqlite "$sqlite" --speedtest "$inputs" --lua "$inputs/lua-5.4.8/src" --scripts "$scripts" --directory /tmp
```

Frozen inputs: SQLite amalgamation SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`; speedtest1 from SQLite `ccc132c5be20ab5c755c97a08d06b1b592fef330`, SHA-256 `b5eaf4bbcbb320fd8eb3f3e6c4cd5f51a64dd0cd70efe969634d1785e3419675`; Lua 5.4.8 archive SHA-256 `4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae`. Lua scripts are from performance commit `818cfbbc0be238da287c16d8e2a91fd7275cf228`, `docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua`. The receipt retains tcc's binary digest.

## Separate paired rows workloads

| Program | CI base median wall ms | Tested merge median wall ms | Change |
|---|---:|---:|---:|
| rows | 8.290 | 8.257 | -0.398% |
| scan | 13.008 | 11.936 | -8.241% |
| lexer | 46.099 | 47.095 | 2.161% |

The lexer regression is observed in this run: its wall range is 46.025–46.193 ms for the base and 46.993–47.332 ms for the head; user cycles rise 2.233% while instructions fall 1.095%. Do not dismiss the regression as noise or infer a cause from fewer instructions.

This harness uses one executable per program/build, with one warm-up and 11 measured runs and rotating order. It provides neither an exact-parent comparison nor a placement/layout sweep. It cannot attribute the result to address folding, ADD emission, table hoisting, or the intervening main changes. The three workloads are separate from speedtest1/Lua.

```bash
taskset -c "$cpu" ./build/compiler measure-tier1-rows --runs 11 --clang clang "${base[@]}" --march znver5 --lexer src/buster/compiler/c_lexer.c --directory /tmp
```

The base/head values, ranges and all counters are in [receipt.json](receipt.json). The 144 row-workload observations (12 warm-ups and 132 measured samples) are in the full log.

## Qualification and outstanding work

All eight selected hosted correctness shards passed (135 inventory commands per host architecture); the hardware job, final qualification, Coverage record, DCO and storage-policy checks passed. The PR workflow skips its separate complete native vector correctness and libFuzzer stages.

The new regression fixtures check the MOVSXD → ADD → JMP core and table-base placement before a loop backedge. The normal runtime command omits `--keep` and deletes its generated SQLite/Lua objects and executables, so this run retains no corpus dispatch disassembly. Normal artifacts contain coverage and hosted memory admission only.

To finish #1217, collect the corrected #1189 instruction breakdown and inspect the actual corpus dispatches on the locked 9700X, then diagnose the observed lexer regression with an exact-parent comparison and controlled code placements. This agent session lacks the documented Tailscale executables and authentication configuration for direct benchpress access. No instruction-count threshold or general speedup is claimed here.

## Files and provenance

- [hardware-job.log](hardware-job.log): complete decoded public GitHub job log, preserving the BOM, timestamps, command text, output and 360 six-program observations; **562,170 bytes**, SHA-256 `4e7d0a06ce318a538b64576335b954ae4c346d383d65b9819713aeaae709cdb6`.
- [receipt.json](receipt.json): source identities, settings, frozen inputs, all 30 six-program result rows, all 12 related rows results, and limitations.
- This report: interpretation of the evidence and acceptance boundary.

Original report and receipt use Apache-2.0 WITH LLVM-exception. The public CI log is preserved as retrieved, including external tool output; this record asserts no new license over third-party output. SQLite, Lua, Clang, tcc and their binaries/sources are external inputs and are not incorporated. No new measurement harness or compiler implementation is copied here.

---
Agent session: 01a1b841-530c-76b5-9807-2eefb608e06a (OpenAI session ID; no private share URL is exposed), with task /root/acceptance
Model: OpenAI / GPT-6 Astra Pro
