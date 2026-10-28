# Bounded comma-context preparation (#529), 2026-10-28

**Assessment: retain this bounded slice.** Three independent SQLite cohorts
across six verified code placements improve whole-process wall time
**1.16–1.31%**, CPU 1.17–1.30%, cycles 1.45–1.50% and instructions 1.1688%.
Pooled RSS rises 22–56KiB with overlapping ranges. Tiny startup cost remains
unresolved. This frozen comparison establishes no current-main, general-corpus,
every-copy, eight-worker or additive speedup.

The change batches only the reverse expression-comma context pass, using the
unchanged scalar reverse-postorder loop as oracle and dependency fallback. It
adds no retained column or allocation. General literal preparation and broader
graph construction remain residual #529 work. Already merged #703/#646/#640,
and separate #628/#658/#641 work, are not counted again.

| Frozen identity | Revision or SHA256 |
| --- | --- |
| Baseline source | `e7f89091648f68940b595aadd648841c1ffc3ec5` |
| Candidate source | `b8ee29009260785aadc2659472daac30d44c081a` |
| Candidate tree | `22a598330a8db12a8116f6a22a2c1a81705067fb` |
| Native baseline compiler | `06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e` |
| Native candidate compiler | `3f162da86b82260fe26c443932cbcb0f9ea5d308641fef9eae01639edb044ec7` |

The [exact source patch](source.patch) preserves the frozen change independently
of a later publication port. The target is Ryzen 7 9700X with official Clang
23.1.4, `BUSTER_HOST_ARCH=native`, `BUSTER_DEBUG_INFO=1`, ordinary release flags.
Local debug0 builds/screens are separate. No host settings changed.

## Final native controls

Each cohort has six actual placements, three roles (base/head/base-again),
three fresh independent regular executable copies per placement, three measured
runs and one warm-up on CPU2. The exact accepted record has **648 measured
processes and 216 declared warm-ups**: three SQL cohorts and one tiny control.
All measured statuses are zero, counters fully scheduled, and major faults zero.
No sample drops. Successful warm-up resource values are not printed by the runner.
Pooled medians average the two middle values in each role's 54 measured rows.

| Cohort | Wall base → head, ms | Wall change | A/A wall | Cycles change | RSS base → head, KiB |
| --- | --- | --- | --- | --- | --- |
| SQLite 1 | 124.7185 → 123.0955 | -1.3013% | -0.1459% | -1.4639% | 377150 → 377206 |
| SQLite 2 | 124.4115 → 122.7755 | -1.3150% | -0.1435% | -1.5026% | 377180 → 377202 |
| SQLite 3 | 124.0540 → 122.6095 | -1.1644% | +0.0641% | -1.4512% | 377148 → 377204 |
| Tiny 1 | 1.3700 → 1.3710 | +0.0730% | -0.2555% | +1.2823% | 22052 → 21906 |

Each placement-pooled SQLite wall median improves. Individual copy tails remain:
SQL1 wall -2.51% to +0.93% and cycles -2.89% to +0.11%, beside A/A wall -0.92%
to +2.08% and cycles -1.38% to +1.68%. Tiny cycles have A/A +0.823%; copy changes
span -1.32% to +3.21%, beside A/A -1.59% to +2.66%. Tiny placement wall ranges
are much wider. There is no narrow equivalence or startup neutrality claim.
Larger local debug0 RSS increases (0.55–2.05MiB) remain retained in the record;
their cause is not attributed away. Old/new actual production context writes
touch the same logical output pages (SQLite176, tiny1, comma-heavy29).

Raw rows and independent summaries: [layout receipts](raw/layout/).
[DETAILS.md](DETAILS.md) retains Stage1 reader attribution (-3.35%, four measured
triples), 198 one-placement whole-process samples, all local screens and limits.
Those are separate from the final layout qualification.

## Control validity and correctness

The one baseline object-capture rebuild reproduces the immutable baseline ELF
byte-for-byte. The rejected ordinary-frontend padding did not move the hot reader
section; it was never timed. Corrected controls capture the checker unit once
per role and reuse the other 40 objects. Their zero controls exactly match all
26 allocated section layouts/bytes, ELF/program headers and defined symbols.
One count-checked cold-test x87 alias normalization restores direct-object bytes;
only named nonallocated debug content differs afterward. All original failed
controls and proofs are retained. No production source is patched by this method.

Offsets 0,704,1408,2112,2752,3456 shift two hot functions by the exact requested
amount in each role. All 24 address checks pass. Independent gates verify
84/84 emitted objects/stdout/stderr comparisons and 72/72 runtimes against Clang.
Closure verifies original/variant/source/header identities and the final output
object from each timing cohort. Output paths are reused, so these closure checks
do not individually byte-audit every timed output.

Frozen target checker: 498,771 checks/0 failures; driver21,660/0; deferred1,423/0.
Local native/generic checker: 498,775/0 and 501,558/0; both ASan/UBSan focused
comma/prefix/repair adapters5,891/0; corpus220/220; recursion audit0 bad cycles.
The generic production wrapper selects only the original scalar kernel.
Independent read-only source review found no concrete correctness blocker.

One source review focus: **an earlier separator parent must trigger full original
reverse-postorder replay**. Later parents are resolved; earlier fixed-context
parents can be evaluated directly. Full immutable token counts include repair
closers. Guarded tails, shuffled dependencies, deep chains and actual prefix/
repair views exercise this boundary.

See [reproduction](REPRODUCE.md), [archive scope and retained payloads](ARCHIVE_SCOPE.md),
and the [concise review handoff](REVIEW_HANDOFF.md). Publication/current-main
composition correctness is separate from these frozen performance measurements.
