# Tier 1 call-preservation investigation (#2610), 2026-11-26

**Interim checkpoint: none of the policies in this packet is accepted for production.** The investigation of [buster#2610](https://github.com/buster14a/buster/issues/2610) continues in [draft #3630](https://github.com/buster14a/buster/pull/3630). [Draft #3639](https://github.com/buster14a/buster/pull/3639) is temporary measurement instrumentation and must not be merged.

This checkpoint preserves expensive, reproducible evidence from the rejected recipe, soft-preference and join-guard experiments. The complete packet is [evidence-interim.tar.gz](evidence-interim.tar.gz), SHA256 `7dad7ee0c998a7cbefd3325063d78ff0db68c294ed61cda06027895165a02e00`. It contains 544 files: source/build identities, compiler and input digests, exact commands, native output and certificate receipts, instrumented origin sidecars, focused regression/mutation fixtures, and compact completed dynamic accounting. It contains no executable binaries.

## Findings recorded here

The baseline `yy_reduce` executes **3,923,938 C/R instructions**, still above the issue's 660,000 target. Its preferred allocation is taken, and the relevant raw frame addresses already have recipes. Recognizing additional folded frame recipes does not reduce that function's C/R; it regresses the parser's conditional token loop.

Soft caller-register avoidance cuts `yy_reduce` C/R to 28,951, but it increases ordinary spills and edge traffic. A call handler's changed convention reaches the shared return. Guards against internal joins and promotions spanning several blocks fail to contain all later propagation. In Lua, a return handler changes the later phi conventions and adds a store/reload pair to the hot dispatch path, each executed 3,813,727 times.

### SQLite size-5 mix1 accounting

| Variant | Target instructions | Difference from baseline | Transport union | yy_reduce C + R |
| --- | ---: | ---: | ---: | ---: |
| e000 | 2,250,814,969 | 0 | 253,741,219 | 3923938 |
| e002 | 2,316,064,243 | 65,249,274 | 294,626,083 | 28951 |
| e003 | 2,316,960,661 | 66,145,692 | 294,537,264 | 28951 |
| e006 | 2,346,573,685 | 95,758,716 | 297,595,329 | 28951 |
| e011 | 2,283,860,117 | 33,045,148 | 273,057,483 | 2914569 |
| e018 | 2,322,759,489 | 71,944,520 | 306,246,912 | 1886742 |
| e034 | 2,258,941,425 | 8,126,456 | 249,380,972 | 2759194 |

`e000` is baseline; `e002` soft avoidance; `e003` soft avoidance plus folded recipes; `e006` soft avoidance plus broader residency of existing recipes; `e011` a two-call guard plus folded recipes; `e018` an internal-join guard; `e034` a single-block guard. The [full comparison](comparison-vs-baseline.tsv) includes all five Lua workloads and rematerialization/frame categories. Every listed dynamic capture passed the complete target-address/origin audit with zero unmatched target instructions.

Transport is the **deduplicated union** of ordinary spills/reloads, call saves/restores, and edge traffic. The separate spill and edge totals overlap on edge memory operations and must not be added.

## Reproduction and validation

[INTERIM.md](INTERIM.md) contains the full narrative from the frozen packet; paths it names refer to files inside the archive. [PROVENANCE.md](PROVENANCE.md) records the frozen source inputs and compiler artifacts. [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) preserves relevant attribution.

Extract the archive at the root of a buster-performance checkout. It restores the complete directory, including the original detailed README and its file manifest:

```sh
tar -xzf docs/measurements/tier1-call-preservation-2610-2026-11-26/evidence-interim.tar.gz
cd docs/measurements/tier1-call-preservation-2610-2026-11-26
sha256sum -c SHA256SUMS
```

The same pinned inputs and shared executable/database paths are used across variants. SQLite's verification hash and all five fixed-seed Lua output oracles pass. Whole executable and origin-sidecar controls establish that instrumentation and later hosted merge builds retain the original baseline and soft-only programs. Corpus coverage remains SQLite 2709/2709 Tier 1 functions and Lua 1086/1087, with its existing `luaD_rawrunprotected` unsupported fallback.

The packet distinguishes compiler source commits from GitHub test merges and documents the baseline local pipeline's sandbox-specific failures. It does not treat those local pipeline checks as passing. Full emitter and paired SQLite certificate receipts for the join guard are included, with the unchanged emitted-code certification limitation stated explicitly.

These are deterministic generated-program instruction counts and correctness checks on the cloud Xeon host. **No timing or 9700X qualification is claimed; Benchpress/9700X was not accessed.** Raw Callgrind captures and complete joins remain with the measurement owner; this checkpoint contains compact completed summaries and audits. Later experiment 128, its compiler, and its results are not part of this frozen checkpoint and will be recorded separately.

---
Agent session: 6b07eef1-3474-83ed-9c43-8fe10b12d07a (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6 Astra Pro
