# GVN bounded partition grouping (#866), 2026-10-31

Measurement record for [buster14a/buster#866](https://github.com/buster14a/buster/issues/866)
and its candidate [PR #946](https://github.com/buster14a/buster/pull/946). The
candidate replaces the per-round whole-function comparison sort with bounded
exact-key interning and keeps the comparison sort on the same keys as the
collision-budget completion and the scalar oracle.

## Trees and host

- Main: `c1c5ed02` (`origin/main` when the PR merged it).
- Candidate: `6901c083`, the PR head after merging `c1c5ed02`; its pass commit
  is `20c96d03`.
- `basegvn`: main's `ir_optimize_gvn.c` and `ir_optimize_gvn_test.c` with the
  candidate's `main.c` and `ir_source_benchmark.c`, so both trees time the same
  benchmark adapter and only the pass differs. Its source benchmark has the
  three counter accumulations removed that main's `IrGvnResult` does not have;
  the timed code is unchanged.
- Host: Ryzen 7 9700X, 8 cores, Clang 23.1.1, wild linker, `BUSTER_DEBUG_INFO=0`.
- Every process ran under `~/buster-fast-bench/exclusive.sh`, pinned with
  `taskset -c 2`, one lock acquisition per process. The logs include the lock's
  owner lines when it waited.

## Synthetic whole pass

`benchmark-ir-optimize-passes --pass gvn --instructions 4096 --samples 21`,
three process pairs per code placement, alternating which tree runs first.
`default`, `256` and `1024` are `./build.sh shifts` placements of
`main_unit_backend.c`'s `.text`.

| Shape (instructions) | Path | Placement 0 | Placement 256 | Placement 1024 |
| --- | --- | ---: | ---: | ---: |
| `small-dag` (36) | vector | −21.9% | −22.4% | −23.6% |
| `large-dag` (4,100) | vector | −75.3% | −74.6% | −75.0% |
| `cyclic-phi` (15) | vector | −5.6% | −8.4% | −5.5% |
| `small-dag` (36) | scalar (control) | +2.2% | −0.2% | +1.1% |
| `large-dag` (4,100) | scalar (control) | +3.9% | +2.0% | +2.9% |
| `cyclic-phi` (15) | scalar (control) | +1.4% | −2.4% | +1.3% |

Absolute medians, in nanoseconds:

| Shape, path | Main default/256/1024 | Candidate default/256/1024 |
| --- | ---: | ---: |
| `small-dag` vector | 4,618.6 / 4,698.2 / 4,610.2 | 3,606.3 / 3,645.1 / 3,522.2 |
| `large-dag` vector | 1,375,020 / 1,353,000 / 1,311,961 | 339,513 / 344,156 / 328,266 |
| `cyclic-phi` vector | 2,406.1 / 2,483.4 / 2,412.9 | 2,272.3 / 2,274.3 / 2,280.7 |
| `large-dag` scalar | 271,899 / 275,772 / 270,243 | 282,564 / 281,395 / 277,981 |

Both trees remove 1,024 instructions from `large-dag`, 8 from `small-dag`, and
the vector path removes 4 from `cyclic-phi` while its scalar twin removes 0.
The scalar control does not take the new grouping path; its 2–4% variation is
reported here rather than used as a claim.

## Source-derived IR

`benchmark-ir-source --only gvn` and `--only gvn-scalar` on the frozen
`sqlite3.c` with the 9700X job's options (2,602 functions, 396,928 typed
entries, 598,425 lowered instructions). Three process pairs per variant,
21-sample medians of the whole corpus.

| Variant | Main (ns/entry) | Candidate (ns/entry) | Change |
| --- | ---: | ---: | ---: |
| `gvn` | 811.61 | 320.52 | −60.5% |
| `gvn-scalar` | 199.64 | 202.11 | +1.2% |

Both paths remove 94,358 instructions over the corpus. The candidate's vector
path runs 14,998 refinement rounds, makes 3,704,792 key comparisons and takes
no collision-budget sort completion. The source rows are a correctness and
whole-pass measurement of the pass on real IR, not a C-driver throughput claim:
the Tier 1 pipeline does not yet route C through GVN (#139).

## Reproduction

Copy `main` and the candidate to a host directory as `basegvn` and `cand`; for
`basegvn`, restore main's `src/buster/compiler/ir_optimize_gvn.c` and
`ir_optimize_gvn_test.c` and drop the candidate's counter fields the base result
does not have. Build both with `./build.sh` and, for the placements,
`./build.sh shifts shifted main_unit_backend.c 256 1024`. Then run
`ab-synthetic.sh` and `source-ab.sh` with `ROOT` set. `ab-synthetic.log` and
`source-ab.log` are the raw output of the runs above.

## Provenance

Original harness use and measurements; no external code, data or generated
corpus was imported. The fixture and frozen source are the repository's and its
oracle corpus's.
