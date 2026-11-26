# Tier 1 call-preservation investigation (#2610), 2026-11-26

**Interim checkpoint: none of the policies in this packet is accepted for production.** The investigation of [buster#2610](https://github.com/buster14a/buster/issues/2610) continues in [draft #3630](https://github.com/buster14a/buster/pull/3630). [Draft #3639](https://github.com/buster14a/buster/pull/3639) is temporary measurement instrumentation and must not be merged.

This third checkpoint completes the weighted global-exchange experiment. **Mask 256 improves aggregate SQLite instruction counts but leaves `yy_reduce` unchanged, so it fails the primary target.** The complete packet is [evidence-weighted.tar.gz](evidence-weighted.tar.gz), SHA256 `5a166ec22fe2e4a0fd52ce3e77ad185b53cae21b64dfb23a23c85ae1236ce919` (6,759,591 bytes). It contains 1,031 checksummed files plus its root manifest, including all eight fresh compressed raw Callgrind captures, source/build identities, exact commands, native and certificate receipts, origin sidecars, focused proofs, and completed accounting. It contains no executable binaries. The preceding [exchange checkpoint](https://github.com/buster14a/buster-performance/tree/c502d005bf2f261dc3b11a0058c105a412da9293/docs/measurements/tier1-call-preservation-2610-2026-11-26) remains immutable; its archive is also retained here.

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
| e128 | 2,247,566,845 | -3,248,124 | 246,014,704 | 3923938 |
| e256 (fresh pair) | 2,236,572,790 | -14,242,179 | 233,060,363 | 3923938 |

`e000` is baseline; `e002` soft avoidance; `e003` soft avoidance plus folded recipes; `e006` soft avoidance plus broader residency of existing recipes; `e011` a two-call guard plus folded recipes; `e018` an internal-join guard; `e034` a single-block guard; `e128` a global caller/callee register exchange that preserves the original fragments and edge moves. The [full comparison](comparison-vs-baseline.tsv) includes all five Lua workloads and rematerialization/frame categories. Every listed dynamic capture passed the complete target-address/origin audit with zero unmatched target instructions.

Transport is the **deduplicated union** of ordinary spills/reloads, call saves/restores, and edge traffic. The separate spill and edge totals overlap on edge memory operations and must not be added.

## Global exchange and exact target diagnosis

Mask 128 preserves ordinary spills, rematerialization and edge traffic, but fails acceptance. `yy_reduce` is unchanged, and Lua closures adds 4,625,292 target instructions. The savings at calls are outweighed by entry copies on paths that never execute those calls. Arithmetic and calls also add 91 and 144 instructions.

A diagnostic-only hosted compiler at `7b6f0a5ce11496dbc74732b379a63ef204ca5bf9` reproduces the entire mask-128 SQLite executable and origin sidecar. `yy_reduce` supports all 617 calls. The RDI/RSI exchanges with R14/R15 pass the original live-mask subset condition but are vetoed because one call adds one argument shuffle. No fixed-register or unsupported-argument defect is involved. The archive retains the exact masks, call positions, trace source, build identity and parity checks.

### Completed weighted exchange (mask 256)

The new scorer models actual lazy save/restore epochs, exact ABI parallel copies, and bounded uniform CFG visit estimates. Its qualified helper snapshots pass 2,017 epoch checks, 1,100 frequency checks plus 17 arena-adapter checks, and 113 combined cost/native checks, including 32 hostile-call executions. Frequency address/UB checks and two mutation checks pass. Hosted run [45813208911](https://github.com/buster14a/buster/actions/runs/45813208911) built actual test merge `298b9d7189127039b433a2007497e171425312e0`; all nine staged source blobs match that merge. Masks 0 and 128 reproduce their complete original SQLite/Lua executables and origin sidecars. Mask 256 passes 257,194 emitter checks, native corpus oracles, and the paired full SQLite certificate build with unchanged coverage.

The fresh SQLite pair removes 20,680,856 call-save/restore instructions and 716,572 argument moves, but adds 7,155,249 entry copies: a net reduction of 14,242,179 instructions (0.632756544%). Spills, edges, rematerialization, frame instructions and ordinary nodes are unchanged. Lua arithmetic removes 4,252 instructions. The remaining Lua workloads were not captured for 256 after target failure was established. [The fresh comparison](comparison-vs-fresh-baseline.tsv) keeps these paired counts separate from historical results.

The complete `yy_reduce` symbols both contain 50,459 bytes and 12,103 instructions at identical relative offsets. Of these, 814 differ only in verified PC-relative displacement fields to the same symbolic targets; every other byte matches. Its tags are byte-identical. Thus the linked bytes are not wholly identical, but the allocation and instruction structure are unchanged. The scorer chooses no exchange: its best two estimates are RSI/R15 -0.195837039500 and RDI/R15 -0.223028070759 instructions per invocation.

Actual entry frequency is 1,227,631. RSI and RDI preservation cost only 1.239521 and 1.214795 instructions per invocation before an entry copy, displaced callee epochs or argument shuffles. The switch dispatch runs on 83.265167% of invocations versus the static estimate's 50%. A read-only lowering audit finds that the CFG also loses jump-table entry multiplicities and includes an unused default edge. These are diagnosed model limitations, not evidence for a chosen replacement probability or an accepted fix.

## Reproduction and validation

[INTERIM.md](INTERIM.md) contains the full narrative from the frozen packet; paths it names refer to files inside the archive. [PROVENANCE.md](PROVENANCE.md) records the frozen source inputs and compiler artifacts. [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) preserves relevant attribution.

Extract the archive at the root of a buster-performance checkout. It restores the complete directory, including the original detailed README and its file manifest:

```sh
tar -xzf docs/measurements/tier1-call-preservation-2610-2026-11-26/evidence-weighted.tar.gz
cd docs/measurements/tier1-call-preservation-2610-2026-11-26
sha256sum -c SHA256SUMS
```

The same pinned inputs and shared executable/database paths are used across variants. SQLite's verification hash and all five fixed-seed Lua output oracles pass. Whole executable and origin-sidecar controls establish that instrumentation and later hosted merge builds retain the original baseline and soft-only programs. Corpus coverage remains SQLite 2709/2709 Tier 1 functions and Lua 1086/1087, with its existing `luaD_rawrunprotected` unsupported fallback.

The packet distinguishes compiler source commits from GitHub test merges and documents the baseline local pipeline's sandbox-specific failures. It does not treat those local pipeline checks as passing. Full emitter and paired SQLite certificate receipts for the join guard are included, with the unchanged emitted-code certification limitation stated explicitly.

These are deterministic generated-program instruction counts and correctness checks on the cloud Xeon host. **No timing or 9700X qualification is claimed; Benchpress/9700X was not accessed.** An executor restart cleared the original temporary raw captures after compact results were saved; those older raw files remain unavailable. After restoring the pinned tools, all six baseline workloads were recaptured and compared to mask 256 for SQLite and arithmetic. All eight new raw captures and compressed native/counted outputs are included in this archive. Four baseline totals match the historical results; calls and tables each execute two fewer ordinary-node instructions, with all transport totals unchanged. No cause is asserted. Candidate 256 is compared to the fresh baseline. A later acceptable policy still needs its own complete paired qualification.

---
Agent session: 6b07eef1-3474-83ed-9c43-8fe10b12d07a (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6 Astra Pro
