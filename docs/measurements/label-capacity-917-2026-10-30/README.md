# PR #917: label-table sizing qualification

The unchanged candidate reduces the frozen SQLite compilation's full-unit
label-table request from **8 MiB to 2 KiB**, a factor of **4,096**. Both sources
have successful source/placement controls and all 972 measured processes exited
zero. Whole-compilation medians are slightly favorable (about 0.2%), with
placement/copy ranges crossing zero. This supports the exact table-accounting
result and records the small, placement-sensitive timing observation; it does
not claim a consistent throughput gain across layouts or other inputs.

This continues only item 4 of [Buster #877](https://github.com/buster14a/buster/issues/877)
and [PR #917](https://github.com/buster14a/buster/pull/917). The other sparse scans,
attribute representations, #529 and #628 remain outside this work. Original
material certification remains open and the PR stays draft. See
[PROVENANCE.md](PROVENANCE.md) for the source, license and certification boundary.

## Exact sources and ordinary CI

| Role | Commit | Tree |
| --- | --- | --- |
| Baseline | `434eb27646fa189662e5ada0e61a41f54ba70c4f` | `f6cb4cd4280fb1bcfd267bfb2835e1d491b3adc2` |
| Candidate | `f24e3cd4a1339774318fa8da35910ecb8a89e222` | `79342e99dd82470a45abf01c240e84791b7ed319` |
| PR CI merge | `6d409f4e8bd05a8cdd5dff5e05f37bc4349c73ff` | `79342e99dd82470a45abf01c240e84791b7ed319` |

The actual CI merge was fetched and its complete tree compared byte-for-byte
with the candidate. [Run 41050376643](https://github.com/buster14a/buster/actions/runs/41050376643)
passes official Clang 23.1.4 hosted native/x86-64 builds, source parsing and the
configured correctness/corpus routes, baseline emulation, then complete native
vector correctness on the locked 9700X. Measurement storage also passes. The
plain-PR libFuzzer skip is expected; this run does not supply sanitizer/fuzzer
qualification or execution of later main. Raw run metadata and the compressed
full log are retained in `logs/pr-ci-run.json` and `logs/pr-ci.log.gz`.

## Build and placement controls

The fresh ordinary builds use official Clang 23.1.4, `-O3 -march=znver5`, the
production NUL-delimited flags/source APIs, no debug or sanitizer instrumentation,
and the recorded `/usr/bin/wild` binary. Build flags, tool identities, source
manifests, CPU/microcode, performance governor and CPU 10 offline state are
retained in the build receipts. All 40 non-checker objects match exactly; only
`main_unit_checker.c`'s object differs between sources.

The checker has a separate `.text.buster_checker` input contribution, so ordinary
`.text` padding is insufficient. These controls add 0/16/64/256/1024/2048 zero
bytes inside that contribution, preserving all original objects and link order.
The normalized zero assembly object and full zero executable must be byte
identical to the ordinary build. Object relocation translation, every owned hot
function's exact address delta and size, linked non-relocation bytes, and actual
signed-32-bit local PLT32 targets are checked. This covers 810 baseline/811
candidate hot functions and 1,445/1,448 actual local PLT32 targets at each shift.
Reader/control/prefix functions are explicitly required. Detailed JSON proofs
are in `placements-{base,candidate}-v4/`; [geometry.tsv](logs/geometry.tsv) totals them.

The retained original refusals led to the bounded adaptations documented in
PROVENANCE.md. Hash-verified local copies pass positive object/image checks and
nine targeted rejection controls for missing/double/wrong addends, a wrong
actual linked target, a wrong ownership anchor, an ambiguous duplicate, wrong
NULL address, extended NULL metadata and a noncanonical ET_REL NULL row. These
inspect files and never execute the copied compiler images. `local-controls/`
retains their results, including the initial mutation-fixture construction failure.

Before timing, all 12 source/placement compiler outputs and the candidate
scalar output compile the frozen SQLite input to the same complete object:
`f7fca7bd043b4b661c268da5146c89b06585763e3ff47ff066f55a14fd8a555f`.
The corpus/header/predefine manifests are verified. `logs/semantic.status` is
zero and the raw stage/stdout/hash receipts remain in `semantic/` and `logs/`.

## Whole-process observation

Every round takes the shared host lock separately and pins the driver and every
child to CPU 2. Per state there are three independently repeated rounds, six
effective placements, three fresh physical executable copies per placement,
three measured processes per slot, and the baseline/candidate/baseline-again
labels. Each slot also has one warm-up. The internal order rotates by run.
The second state adds 200 ms of untimed scalar work before every measured child.
That gives 972 measured processes and 324 warm-ups. All measured statuses are
explicitly checked as zero, independently of time-runs' stable-status rule.

| State | Baseline wall ms | Candidate wall ms | Baseline-again wall ms | Candidate change | Baseline user cycles M | Candidate user cycles M |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Ordinary | 129.593 | 129.290 | 129.593 | −0.23% | 610.210 | 609.142 |
| After 200 ms scalar | 129.499 | 129.159 | 129.569 | −0.26% | 609.787 | 608.592 |

These are pooled upper medians of 162 measured processes per label/state.
Per-round medians, raw samples and all layout/copy ranges remain in the six
`logs/time-*.log` files and [grid.csv](logs/grid.csv). All six cross-placement
candidate cycle ranges include zero; their full layout/copy ranges are wider.
The table is an observation on this frozen input and pinned pair, with a small
median effect relative to layout sensitivity. There is no corpus-wide or
placement-independent speedup claim.

The independent C reader validates all 972 unique grid cells, all statuses and
all counters; missing cycle/instruction pairs are zero. It rejects removed,
duplicated and nonzero-status sample controls. The production counter reader
also refuses multiplexed reads. These controls validate the packet, not extra
hardware executions. `time-runs`' RSS columns retain the explicit wait4 scope.
Contemporaneous argv/script/lock metadata is retained for ordinary round 3 and
all after-scalar rounds. Ordinary rounds 1–2 used the same commands before that
metadata-only extension; their exact invocations are recorded by `round.sh`
with state `plain`, rounds 1 and 2, and their started/ended/status receipts.

## Charged path and capacity accounting

Eleven separate ordinary-layout stage-clock compilations per label ran in
rotating A/B/A order. The full `check-input` elapsed span charges the new count
scan, table allocation/initialization and control walk, together with the rest
of the reader; it does not isolate a subphase timer for the scan alone.

| Upper median, ms | Baseline | Candidate | Baseline-again |
| --- | ---: | ---: | ---: |
| check-input | 57.265 | 57.127 | 57.297 |
| check-program | 12.206 | 12.223 | 12.177 |
| complete stage-clock span | 129.201 | 128.822 | 129.129 |

The stage sample set's approximate post-exec-through-last-mark peak medians are
390,248 / 388,932 / 390,240 KiB. These are separate resource observations from
the table request; stage system-time marks retain their recorded unqualified
status and are not used to rank or subtract elapsed time. All 33 raw argv,
stage and process-resource records are in `stages/`.

Separate **untimed diagnostic clones** print the actual table request before
allocation. Both see 716,136 tokens and a full-unit prefix of zero:

| | Slots | Bytes |
| --- | ---: | ---: |
| Baseline | 2,097,152 | 8,388,608 |
| Candidate | 512 | 2,048 |

Each diagnostic compiler emits an object identical to the uninstrumented
reference. Its one-line source patch, modified-source/compiler digests,
diagnostic output, object digests and successful exit are retained as
`logs/capacity-*`. Those binaries never enter the timing grid.

## Reproduction and remaining gates

Use the pinned sources and configured frozen corpus on the approved host. The
scripts assume an isolated Q and verified official toolchain; choose a fresh Q
and update `scripts/env.sh` for reproduction rather than overwriting these
receipts. Create each source archive with `git archive COMMIT | gzip -n`, extract
it under Q/base or Q/candidate, verify its retained manifest, and run:

1. `scripts/build.sh base` and `candidate`, each under its own shared lock.
2. `scripts/place-v4.sh base` and `candidate`, each under its own lock.
3. Copy the hash-verified baseline/16 artifacts for the local proof controls;
   run `scripts/proof-controls-local.sh DIRECTORY`. Preserve status0 for the
   host semantic precondition, then run `scripts/semantic.sh` under the lock.
4. `scripts/round.sh N plain` and `N after-scalar`, N=1,2,3, taking the lock for
   each invocation. Run `scripts/stages.sh` and each `scripts/capacity.sh KIND`
   as separate lock holds. No owner sets `BUSTER_9700X_HELD` manually.
5. Compile `proof-tools/read_grid.c` with C17/O2/warnings-as-errors and pass the
   three plain logs followed by the three after-scalar logs in round order.

The original #917 material certification, maintainer review/readiness and final
live actual-head/main/check/rule/mergeability gates remain. Any later source
integration needs its own qualification; these receipts retain this exact pair.
This packet leaves #877 open and does not take over its other slices.
