# PR #920: reuse of runtime declaration lists

This packet qualifies only item 2 of [Buster #877](https://github.com/buster14a/buster/issues/877)
and [PR #920](https://github.com/buster14a/buster/pull/920). The shipping change
reuses the source-ordered declaration/initializer list that lowering already
produces. The native runtime-name lookup traverses that list; the scalar oracle
retains the original full-token traversal. No production allocation or extra
compaction pass is added. All existing producer, storage, reverse initializer/
local walk, lookup and preparation costs remain in the whole compilation and
`lower` stage measurements.

The complete qualification passes. Shipping SQLite whole-process wall upper
medians are 1.03% lower in the ordinary state and 0.93% lower after the recorded
light-integer conditioning. Charged LOWER is 8.83% lower in the ordinary-layout
stage campaign. Layout/copy sensitivity remains visible, including an
per-round all-cross-copy envelope crossing zero. These results support the bounded reuse
change and its work reduction; they do not claim every copy/layout contrast
wins, a corpus-wide speedup, or qualification of later integrated main.

The frozen-input runtime-name scan has these derived traversal trip counts:

| Input | Old full-token visits | Native compact-list visits | Visits removed | Ratio |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 716,136 | 30,880 | 685,256 | 23.19× |
| Lua `lstrlib.c` | 27,553 | 2,741 | 24,812 | 10.05× |

These are the unconditional traversal bounds, not dynamic instruction counters
or a claim that all token-linear work disappears. Both corpus paths actually
exercise spelled/native/scalar modes; all four count/cardinality receipts agree.
The complete runtime table, including errno, agrees with the full-token oracle
on each exact checked program. The source regression tests separately cover
nonzero preseeded slots. The deliberately corrupted
copy is refused with status 134 and no nonempty output object; core storage is
`none` with the task's core limit zero.

All 28 uninstrumented source/layout/scalar outputs and all eight untimed
diagnostic outputs have status 0 and agree byte for byte within each corpus.
The complete SQLite object SHA256 is
`f7fca7bd043b4b661c268da5146c89b06585763e3ff47ff066f55a14fd8a555f`;
Lua is `5908c248a6773133f0c570d40dddc038f0f63d311a32da60f80947ee987496ad`.
Raw receipts are in `semantic/`, `diagnostics/` and their logs.
Object parity is recorded by the successful `cmp` commands and digest receipts;
the large emitted objects and measured compiler images remain task-owned host
artifacts, rather than being archived in this Git packet.

## Exact sources and normal CI

| Role | Commit | Tree |
| --- | --- | --- |
| Baseline | `aca7ee0e1581d93d052482a045e8efd5381eebc9` | `646e02e2d3d0c7c35c9377f02c0409d2fa527c6b` |
| Candidate | `f33d3a7e22dade61c9e028197eabe767025ec799` | `2681e481d0a6c9ca697ef779fad0f7950ba54394` |
| Actual PR CI merge | `9efa06f1c0c0458d6fa7148c02ba1a28dc445874` | `2681e481d0a6c9ca697ef779fad0f7950ba54394` |

The complete checked merge tree equals the public candidate tree. Normal
[run 41083284252](https://github.com/buster14a/buster/actions/runs/41083284252)
and measurement storage pass: official Clang 23.1.4 hosted native/x86-64
builds, parsing and configured correctness/corpus tests, baseline emulation,
then complete locked-9700X native vector correctness and ordinary benchmarks.
The plain-PR libFuzzer skip is expected. This is not a sanitizer/fuzzer campaign
or qualification of a later main composition. Full compressed logs and run
metadata are retained under `logs/integrated-ci*`.

The original contribution is `13e4acbbd324fa629b19f563547d950127600d68` on
`d12fd5831f9c73bb7b30505da2ce9616e915143e`. Its successful ordinary CI checked
a distinct synthetic tree that also included #917; those historical receipts
remain under `logs/original-ci*`. The signed additive integration preserves the
original three implementation/test blobs; `source/owned-blobs.txt` records them.
[PROVENANCE.md](PROVENANCE.md) separates authentic certification, source history,
tool reuse, input licensing and measurement scope.

## Build and effective placement

The pair uses official upstream Clang 23.1.4, `-O3 -march=znver5`, no debug or
sanitizer instrumentation, production flags/source order, and the same local
Wild 0.11.0 binary. The shared baseline was independently verified and copied
read-only. Every one of the 40 non-checker object files is byte-identical across
the pair. Actual retained checker compile arguments and expanded NUL-delimited
flags match. The wrapper only retains production's temporary object directory.

The checker has its own page-aligned `.text.buster_checker` contribution.
Offsets 0/16/64/256/1024/2048 are inserted inside that contribution, preserving
the original other 40 objects and link order. Whole zero object and whole zero
final-image identity are mandatory. Unchanged qualified tools prove the full
object translation and actual linked symbols, non-relocation code and local
PLT32 targets. The actual production runtime caller `check_lower_prepare` is
explicitly required, alongside the generic emit/drain/batch classifier anchors;
every owned hot function must move by the requested amount. This is structural
placement evidence, paired with separate runtime parity, rather than a claim
that placement cannot affect performance.

Each offset proves all 819 baseline / 820 candidate owned hot functions and
1,478 / 1,482 actual local PLT32 targets. The production preparation caller is
14,898 / 14,789 bytes. `logs/geometry.tsv` and the full per-image JSON retain
its actual addresses, sizes and exact deltas. All nine targeted structural
negative controls reject their mutated real-file inputs; the attempted
`Wild --no-threads` zero image also correctly failed identity and is excluded.

## Charged stage observation

Eleven ordinary-layout samples per label use the shipping compiler's
`--time-stages`, in rotating slot order. These upper medians are milliseconds:

| Stage | Baseline | Candidate | Repeated baseline |
| --- | ---: | ---: | ---: |
| Preprocess | 9.548 | 9.505 | 9.519 |
| Check input | 57.028 | 57.073 | 57.061 |
| Check program | 12.234 | 12.175 | 12.280 |
| Backend setup | 0.715 | 0.713 | 0.716 |
| LOWER | 15.600 | 14.222 | 15.599 |
| Stage total | 129.258 | 127.504 | 129.273 |

LOWER is 1.378 ms (8.83%) lower in this campaign. Its boundaries charge
`check_lower_prepare`, including the existing producer/list and runtime lookup,
plus body lowering. This is a whole-phase observation from one ordinary
placement, not an isolated runtime-loop timing. Stage total is 1.754 ms (1.36%)
lower. Its driver-stage clock has different boundaries from the separate
whole-process wall measurement, which includes exec/loader through process exit.
All 33 rows retain the same positive lowering counts
`evaluated=266862 batched=14573 classified=14675`, one active worker and no
fallback. The complete canonical samples, min/max values and approximate
post-exec process-peak RSS are retained in `stages/` and
`logs/stages-summary.csv`; no allocation-request change is claimed.

## Whole-process observation

All 972 measured processes have status 0, finite time fields and positive valid
user-cycle/instruction counters. The strict reader verifies the complete unique
grid and zero missing counter pairs, independently of the producer's
stable-status rule. Each round has a successful completion marker and status.

These are pooled upper medians of 162 process observations per label/state:

| State | Baseline wall ms | Candidate wall ms | Repeated baseline wall ms | Candidate change | Baseline user cycles M | Candidate user cycles M |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Ordinary | 129.658 | 128.329 | 129.718 | −1.03% | 609.602 | 602.393 |
| After 200 ms light integer work | 129.599 | 128.395 | 129.751 | −0.93% | 609.448 | 602.318 |

`logs/grid.csv` retains per-round and pooled wall/cycle/instruction medians;
the six raw `logs/time-*.log` files retain every process and producer sensitivity
summary. Baseline-repeat drift and all-cross-placement/copy sensitivity are
part of the interpretation. These observations describe the frozen SQLite
input, pinned source pair, official compiler and recorded host state. Lua is
qualified for table/count/object parity here, with no Lua latency claim.

The independent reducer compares every candidate layout median against every
baseline layout median, and likewise all 18 layout/copy medians. Equal offset
numbers are not treated as matched addresses. Percent-change envelopes are:

| State | Pooled six-layout envelope | Pooled 18 layout/copy envelope | Union of per-round 18 layout/copy envelopes |
| --- | ---: | ---: | ---: |
| Ordinary | −1.388% to −0.569% | −1.502% to −0.422% | −1.887% to +0.081% |
| After light integer work | −1.323% to −0.669% | −1.585% to −0.410% | −1.785% to +0.164% |

Pooled repeated-baseline drift is +0.046% / +0.117%. All six per-round aggregate
candidate wall medians are favorable (0.945%–1.062%), while the per-round copy
envelopes include zero. This supports the small descriptive whole-process
observation and retains its sensitivity. `independent-review/` contains the
separately written reducer and complete whole/layout/sensitivity/stage CSVs.

## Reproduction and acceptance gates

Source manifests, archives' hashes, all ordinary object/image hashes, actual
commands and official resource-header hashes are retained. The configured
runtime inputs are frozen SQLite with its complete header/predefine manifest,
and a task-owned Lua `lstrlib.c` source/header copy with a complete manifest.
No copied compiler image is run during local structural mutation controls.

`scripts/place-local.sh` takes the source checkout, 41 retained objects, ordinary
image, official toolchain, new output directory and proof-tool directory.
`scripts/build-probes-local.sh` makes only untimed diagnostic clones from the
two exact source archives and matching retained inputs. Compile/link work is
reserved through local `cores`; the host execution scripts require the shared
9700X lock, performance governor, CPU 10 offline and CPU 2 affinity.

Each `scripts/round.sh ROUND STATE` invocation takes its own host lock. The
complete grid is three rounds in ordinary and after-200ms light-integer states, three
A/B/A labels, six effective placements, three fresh executable copies and three
measured processes per slot, plus one warm-up per slot: 972 measured processes
and 324 warm-ups. These are process observations, not 972 independent
statistical replicates. Slot order rotates; the repeated baseline label measures
A/A drift and does not assert chronological bracketing of every candidate.
Equal offset numbers across images do not imply equal absolute function
addresses. Placement/copy ranges and baseline-repeat drift remain part of the
interpretation. `read_grid.c` requires complete unique cells, exact status 0,
finite times and strictly parsed positive counters. Removed/duplicated/nonzero,
infinite/overflow/negative and zero-counter controls must fail. The wait4 RSS
scope and printed precision are retained; these are not executable-only peaks.
The `time-runs --after-scalar 200` conditioning is an untimed light integer
xor/shift busy loop before each measured child. It is separate from the
compiler's `--scalar` correctness/oracle runs.

`scripts/stages.sh` rotates 11 A/B/A stage samples. The reducer checks the exact
33-file run/slot/label grid, unique positive finite required metrics and successful
producer statuses before emitting upper medians. Stage system-time fields retain
their producer's unqualified accuracy label and are not subtracted or ranked.

The diagnostic trace reader requires exercised native/scalar/spelled paths and
matching full/compact counts across both revisions. Trip counts describe only
the runtime-name traversal, not total lower work. Full tables and complete
emitted objects must match. The corrupt-copied-slot control runs only in an
untimed clone with core dumps disabled; it must refuse with no nonempty object.
All extra oracle/tracing work is excluded from the shipping timing grid.

Large generated proof JSON and full-source snapshots, the verbatim source
patch and compiler-version outputs are stored with deterministic lossless gzip.
`manifests/raw-artifacts.sha256` records their decompressed bytes; the complete
compressed/readable packet is covered by `manifests/all-files.sha256`.
