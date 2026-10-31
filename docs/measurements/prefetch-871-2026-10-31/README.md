# Software-prefetch placement qualification (#871), 2026-10-31

buster14a/buster's issue [#871](https://github.com/buster14a/buster/issues/871) asked for an
evidence-first qualification of the compiler's software-prefetch sites: ~87% of dispatched hints in the
earlier count were "ineffective" (data-cache hit or MAB match), and the question was which families earn
their dispatch slots. This record is the toggle-variant campaign, its CSVs and scripts, and the outcome the
landed change in PR [#985](https://github.com/buster14a/buster/pull/985) is based on.

## Sources

- measured tree: the worktree at `devin/871-prefetch-qualification`, parent `14210fb2`
  (`Merge pull request #971`), plus temporary `#ifndef`-guarded toggles (`BUSTER_PREFETCH_SEQUENTIAL`,
  `BUSTER_PREFETCH_INDIRECT`, `BUSTER_PREFETCH_NODES`, and `BUSTER_CHECK_LOWER_PREFETCH_NODES` for the
  distance sweep). Toggles only gated `_mm_prefetch` instructions; no algorithm or output changed. The
  toggles were removed before landing; `BUSTER_BUILD_DEFINES` in `build.sh` is the retained hook the
  variants were built with.
- landed head: `2ccdd042` (`Compiler: drop unproductive software prefetch sites (#871)`)

## Host and method

AMD Ryzen 7 9700X, every build and run under `~/buster-fast-bench/exclusive.sh`
(`EXCLUSIVE_OWNER=devin-871`), all timing `taskset -c 2`, clang 23.1.1, `BUSTER_HOST_ARCH=znver5`.

Five binaries (`variants/compiler-{all,none,seq,ind,nonodes}`) built with `BUSTER_BUILD_DEFINES` toggling
each family, plus `compiler-nodes32`/`compiler-nodes128` distance variants. Variants were rotated within
each repetition so drift hits every variant alike (`scripts/run-campaign.sh`). Perf events:

- group A: `cycles,instructions,ls_pref_instr_disp.all,ls_inef_sw_pref.all,ls_sw_pf_dc_fills.all,ls_hw_pf_dc_fills.all`
- group B: `cycles,instructions,ls_alloc_mab_count,de_no_dispatch_per_slot.backend_stalls,ls_inef_sw_pref.data_pipe_sw_pf_dc_hit,ls_inef_sw_pref.mab_mch_cnt`
- parallel run: `umc_cas_cmd.rd/`, `umc_cas_cmd.wr/` per worker count.

## Corpus

- `sqlite3.c` from the frozen `preprocessor-391e729af658` corpus (9,507,037 bytes): `-E -P` ×20 reps,
  `-fsyntax-only` ×15, `-c` ×15 per variant.
- header-heavy: 120 musl sources (~584 KiB total, `logs/musl-files.txt`), `-E -P` ×15 per variant through
  the corpus's generated musl includes.

## Results

`logs/runs.csv` — all interleaved campaign rows (rep, workload, variant, perf group, event, value).
`logs/cc-sweep.csv` — `BUSTER_CHECK_LOWER_PREFETCH_NODES` distance sweep on `-c`.
`logs/parallel.csv` — `all` vs `nonodes` wall time and UMC read/write commands at 1/2/4/8 workers ×2 reps.

Attribution on `sqlite3.c -E -P` (medians): `all` dispatched 756,174 hints / 655,858 ineffective /
112,064 fills; the indirect family alone was 666,382 / 579,354 / 103,098 — ~88% of the population and ~87%
ineffective. `none` left 41,522 dispatches (residual builtin-checker prefetches, confirmed by an
instruction census of the five binaries).

Cycle medians:

| workload | all | none | seq | ind | nonodes |
|---|---|---|---|---|---|
| `-E -P` | ~75.5M | ~75.6M | ~76.4M | ~75.3M | ~75.5M |
| `-fsyntax-only` | ~564.7M | ~564.8M | ~566.1M | ~565.0M | ~564.4M |
| `-c` | ~701.4M | ~708.9M | ~709.2M | ~708.5M | ~708.2M |

Verdict per family:

- **removed**: refine pass A column/source lookahead (`BUSTER_REFINE_PREFETCH_TOKENS`,
  `BUSTER_REFINE_PREFETCH_SOURCE`), `refine_hash_batch` bucket prefetches (3 sites),
  `pp_finish_directives` lookahead (`BUSTER_PP_DIRECTIVE_AHEAD`), `type_derive_batch` bucket prefetches.
  No cycle benefit anywhere; the `-E -P` binary drops to 37K dispatches / 17.5K ineffective / 4.8K fills.
- **retained**: `check_lower_prefetch` — `nonodes` gives up the whole `-c` advantage (~708.2M vs ~701.4M),
  distance sweep showed 64 stays best of 32/64/128; `foreign_resolve_records` — ~11% on
  `benchmark-foreign`'s multi-round member resolution; `files_find_new`/`files_add_first`/
  `intern_bulk_replace` shared-table probes — same cold-table mechanism as foreign (the ET0 write-hints
  feed serialized lock-cmpxchg slots that cannot overlap a miss); not isolable in this campaign.

Post-change check (6 interleaved reps, final binary vs old `all`/`none`): `-E -P` ~78.5M cycles at
none-parity; `-c` ~704.0M, matching `all` ~704.5M and ~0.7% under `none` ~708.6M — the nodes win survives.
`-E -P` text and `-c` object are byte-identical between the pre-change `all` binary and the landed binary
(SHA-256 `ce40c6fe…` and `7b13786b…`).

Multicore (`logs/parallel.csv`): `all` vs `nonodes` wall ms 135/160/212/350 vs 135/163/215/351 at 1/2/4/8
workers; UMC rd/wr within noise. No aggregate-throughput regression from keeping the node prefetch.

The musl header-heavy set was run (`hdr` rows in `runs.csv`) but its cycle distribution was bimodal on
page-cache/IO effects; no per-family claim is made from it — recorded as such rather than as a result.

## Reproducing

`scripts/run-campaign.sh "pp syn cc hdr" REPS` from the bench checkout after building the variants;
`scripts/run-cc-sweep.sh` for the distance sweep; `scripts/run-parallel.sh` for the worker/UMC run;
`scripts/run-benches.sh` for `benchmark-foreign`/`benchmark-files`/`benchmark-types` per variant.
