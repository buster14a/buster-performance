# #529 comma-context review handoff

**Source:** `b8ee29009260785aadc2659472daac30d44c081a` on frozen
`e7f89091648f68940b595aadd648841c1ffc3ec5`; clean `work/next-529`.
Seven files, 282 additions / 10 deletions. Batches comma contexts without a
new allocation/column; keeps the original scalar oracle and dependency fallback.
General literals and broader graph construction remain residual. No duplicate
attribution to merged #703/#646/#640 or separately owned #628/#658/#641.

**Gates passed:** local native/generic builds and checker 498,775/0 + 501,558/0;
both ASan/UBSan comma/prefix/repair 5,891/0; both deferred 1,423/0; corpus220/220;
no-recursion0. Target native checker498,771/0, driver21,660/0, deferred1,423/0;
stage1 objects7/7 and runtimes12/12. Actual production postorders and output
write-page sets match the oracle (SQLite176, tiny1, comma-heavy29 pages).

**Stage1 native screen, provisional:** official Clang23.1.4/native/debug1;
head image `3f162da8…`, exact unchanged e7 baseline `06132c96…`.

| Workload | Result | Retained limit |
| --- | --- | --- |
| SQLite whole | 124.548→123.138ms (-1.13%); instructions-1.169% | A/A+0.09%; RSS+144KiB |
| Whole reader | 49.634→47.964ms; paired-3.35% | A/A+0.014%; RSS-14KiB |
| Tiny | wall+0.50%, cycles+1.32% | unresolved within copy/A/A ranges; RSS-150KiB |
| Comma-heavy | wall-0.60% | A/A-0.33%; RSS-12KiB |

All198 measured whole processes and15 reader processes pass with full counters;
all measured majors0. Local debug0 RSS rises0.55–2.05MiB and noisy timings remain
separate; the cause is not attributed to allocation or incidental layout.

**Stage2 status:** one justified baseline rebuild reproduces `06132c96…` exactly.
Ordinary frontend padding was rejected before timing because it did not move
the isolated reader hot section. Corrected controls reuse two checker-unit
assembly captures and the other40 original objects. A single count-checked cold
x87 alias restoration gives strict equality of all26 allocated sections, ELF/
program headers and defined symbols; only named nonallocated debug data differs.
Real offsets 0,704,1408,2112,2752,3456 are verified for two hot functions in both
roles. All 84 variant objects/diagnostics match the original and 72 runtimes match
Clang. Three independent SQLite cohorts and one tiny cohort are complete:
648 measured processes plus 216 declared warm-ups; no sample drops. All measured
statuses are zero, counters complete, and major faults zero. SQLite pooled wall
time improves 1.16–1.31%, CPU 1.17–1.30%, cycles 1.45–1.50%, instructions 1.1688%.
Pooled RSS rises 22–56KiB with overlapping ranges. Tiny wall is +0.073% and cycles
+1.28%; its A/A and copy ranges leave startup cost unresolved. One SQLite copy
has cycles +0.11%, within A/A extrema; no every-copy or equivalence claim.

**One review focus:** an earlier separator parent must trigger complete
reverse-postorder replay; later parents are already complete and earlier
fixed-context parents can be evaluated directly. Real prefix/repair views,
synthetic closers, shuffled dependencies, guarded tails and deep chains cover it.

**Current state:** the parent accepted this bounded slice; no more measurements
are authorized. The evidence record is curated with full raw rows, text archives,
native/local excluded-payload inventories and zero/control proofs. Source
publication will merge one fresh main pin into a new branch and run focused
composition gates; those gates are pending and make no new timing claim. No
source-correctness blocker remains at the frozen revision.

Full identities, raw receipts, costs and rejected controls: `README.md`, `raw/` and `archives/`.
