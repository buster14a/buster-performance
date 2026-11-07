# GVN acyclic numbering (#866), 2026-11-06

Measurement record for [buster14a/buster#866](https://github.com/buster14a/buster/issues/866)
and its change [#1560](https://github.com/buster14a/buster/pull/1560) (merged).
The pass now numbers every value from which no cycle of operand dependences is reachable
once, in dependency order. It refines in rounds only the values that reach a cycle, where
before it refined every instruction in every round. The partition, and so the rewritten
function, is unchanged. [`docs/ir-value-numbering.md`](https://github.com/buster14a/buster/blob/main/docs/ir-value-numbering.md),
"Acyclic numbering (#866)" and "The acyclic numbering on the 9700X", has the design and
the summary ([#1583](https://github.com/buster14a/buster/pull/1583)).

## Trees and host

- `base`: buster `ec5f0f6b` (`origin/main` when the work started).
- `cand`: `ec5f0f6b` with #1560's change applied. Its `src/` diff is byte-for-byte
  `git diff ec5f0f6b 52003046 -- src` (index lines aside), the commit #1560 merged.
- Host: Ryzen 7 9700X (benchpress), Clang 23.1.1, `./build.sh` Release, host
  `native`, `BUSTER_DEBUG_INFO=0` (`scripts/build-both.sh`; `build-*.log`).
- Every process ran under `~/buster-fast-bench/exclusive.sh`, pinned with `taskset -c 2`,
  taking the lock for itself alone (the `ab` rounds take it per run themselves). The logs
  keep the lock's owner lines where a run waited.
- Inputs: the frozen corpus `preprocessor-391e729af658` at
  `/var/lib/buster-9700x/corpora/` (`sqlite/sqlite3.c`, its pinned predefines and headers).

## How it ran

The lock was heavily contended (13 synthetic runs took about three hours), so the A/B ran
in three scripts:

1. `scripts/ab.sh shifts synthetic` (started by `scripts/run-all.sh`, copied as
   `run-866-ab.sh`). It built the placements with `./build.sh shifts`, putting
   `main_unit_backend.c`'s code 256 and 1,024 bytes later (`shifts-*.log`). Then it ran
   rounds 1 and 2 of the synthetic step and round 3's first process. It was stopped while
   waiting for the lock before round 3's second process; `synthetic.log` marks the empty
   heading.
2. `scripts/ab2.sh synthetic3 source tier1 perf` ran:
   - the rest of round 3;
   - the source step, with every `benchmark-ir-source` variant in each process, so `gvn`
     and `gvn-scalar` come from one process, three per tree;
   - a tier1 step, which is **invalid**: it passed the source benchmark's
     `--no-default-config` to the C driver, which refuses it, so every compile exited at
     once with status 1. Its log is kept as `tier1-invalid-arguments.log` and nothing is
     read from it;
   - the profile.
3. `scripts/ab3.sh tier1` (started by `scripts/after-ab2.sh`) repeated the tier1 step
   with the driver's options. It ran `ab --rounds 3` over both trees with `time-runs
   --runs 5` of `-c --tier1` and `-c --tier1 --tier1-gvn`, then one `--tier1-gvn` compile
   per tree for the object comparison (`tier1.log`).

## Synthetic whole pass

`benchmark-ir-optimize-passes --pass gvn --instructions 4096 --samples 21`, three
processes per tree and placement, with the tree that ran first alternating by round.
Each cell is the median of the three processes' 21-sample medians, then the change:

| Shape (instructions) | Path | Placement 0 | Placement 256 | Placement 1024 |
| --- | --- | ---: | ---: | ---: |
| `small-dag` (36) | vector | 3,746.6 → 3,130.7 ns (−16.4%) | 3,681.0 → 3,101.1 (−15.8%) | 3,683.6 → 3,128.6 (−15.1%) |
| `large-dag` (4,100) | vector | 342,084 → 264,055 ns (−22.8%) | 338,839 → 261,021 (−23.0%) | 343,789 → 266,256 (−22.6%) |
| `cyclic-phi` (15) | vector | 2,473.2 → 2,479.7 ns (+0.3%) | 2,422.4 → 2,428.1 (+0.2%) | 2,372.2 → 2,452.2 (+3.4%) |
| `small-dag` (36) | scalar (control) | 3,366.7 → 3,372.5 ns (+0.2%) | 3,380.9 → 3,423.5 (+1.3%) | 3,312.2 → 3,417.0 (+3.2%) |
| `large-dag` (4,100) | scalar (control) | 289,587 → 292,035 ns (+0.8%) | 293,921 → 289,334 (−1.6%) | 288,181 → 290,948 (+1.0%) |
| `cyclic-phi` (15) | scalar (control) | 2,375.0 → 2,401.9 ns (+1.1%) | 2,377.8 → 2,372.5 (−0.2%) | 2,331.7 → 2,405.1 (+3.1%) |

The vector path's time over its scalar twin's:

| Shape | Before | After |
| --- | --- | --- |
| `large-dag` | 1.181 / 1.153 / 1.193 | 0.904 / 0.902 / 0.915 |
| `small-dag` | 1.113 / 1.089 / 1.112 | 0.928 / 0.906 / 0.916 |
| `cyclic-phi` | 1.041 / 1.019 / 1.017 | 1.032 / 1.023 / 1.020 |

Eight of `cyclic-phi`'s fifteen values reach its recurrences, so it is still refined;
its change stays within the scalar control's. Every process of both trees removed 1,024
instructions from `large-dag` and 8 from `small-dag`. On `cyclic-phi` the vector path
removed 4 and the scalar twin 0.

## Source-derived IR

`benchmark-ir-source` on the frozen `sqlite3.c` with the 9700X job's options, three
processes per tree, alternating, all variants per process (`source.log`):

| Variant, per typed entry | `base` (three processes) | `cand` (three processes) | Change of medians |
| --- | --- | --- | ---: |
| `gvn` ns | 316.69, 316.63, 316.81 | 194.03, 193.72, 193.49 | −38.8% |
| `gvn` cycles | 1,755.05, 1,753.96, 1,753.97 | 1,075.03, 1,073.25, 1,072.31 | −38.8% |
| `gvn` instructions | 5,577.14 | 3,525.52 | −36.8% |
| `gvn-scalar` ns (control) | 198.50, 198.80, 198.79 | 199.16, 199.65, 198.61 | +0.2% |
| `gvn-scalar` instructions | 3,660.56 | 3,680.74 | +0.6% |

The vector path's time over its twin's went from 1.59 to 0.97. Both trees removed 94,314
instructions by both paths.

| Work counter | `base` | `cand` |
| --- | ---: | ---: |
| Refinement rounds | 15,002 | 0 |
| Key comparisons | 3,717,064 | 241,031 |
| Collision-budget completions | 0 | 0 |

`cand` numbered all 599,254 instructions in the acyclic pass. The scalar twin's 0.6% more
instructions are the new scratch columns, which every path allocates and zeroes so that
`scratch_bytes` doesn't depend on the path.

## Tier 1: `-c --tier1-gvn` of the frozen `sqlite3.c`

`ab --rounds 3 --cpu 2 --lock exclusive.sh base cand -- time-runs --runs 5`, with the
two option lists `-c --tier1` and `-c --tier1 --tier1-gvn` and the driver's options for
the same frozen file (`tier1.log`). Each round's figure is the median wall time of five
fresh processes:

| Compile | `base` rounds | `cand` rounds | Change of medians |
| --- | --- | --- | ---: |
| `--tier1` (control) | 455.948, 456.025, 455.484 ms | 455.253, 455.288, 455.579 ms | −0.1% |
| `--tier1 --tier1-gvn` | 583.985, 583.055, 582.185 ms | 529.356, 529.179, 530.337 ms | −9.2% |

What `--tier1-gvn` adds to the compile went from 127.1 ms (+27.9%) to 74.1 ms (+16.3%).
In instructions it went from 2,034 million (6,128.5 to 8,162.6 million) to 1,201 million
(6,128.5 to 7,329.8 million). The two trees' `--tier1-gvn` objects are byte-identical
(text 1,499,281 bytes), as the unchanged partition requires. `--tier1-gvn` stays off by
default for #1020's reasons (the merged values' live ranges cost Tier 1's allocation);
this record changes only what the option costs.

## Profile

`perf record -e cycles -F 4999` of `cand`'s `benchmark-ir-source --only gvn`, the whole
process, including the lowering it does outside the timed region
(`perf-cand-gvn.report`, 11,658 samples):

- The acyclic numbering (`ir_gvn_number`, `ir_gvn_visit`, `ir_gvn_payload`) has about 6%
  of the samples.
- The IR verifier and its derived arrays have about 54%: `ir_check_rows` 24.4%,
  `ir_check_dominance` 13.6%, `ir_build_uses` 9.5%, `ir_cfg_validated`, `ir_check_graph`
  and `ir_check_shape` 6.4%.

`ir_optimize_prepare` checks the input's rows three times: in `ir_verify`, in
`ir_build_cfg`, and in `ir_verify` again inside `ir_build_uses`. That cost is every
optimizer pass's, and is outside this change.

The numbering is scalar because numbering one value is a dependent chain: its key needs
the classes its operands were just given. At 6% of the samples, even a free numbering
would save at most that much, against the eight-lane refinement rounds it replaced on
these inputs.

## Limitations

- **Placements:** the source and tier1 steps ran at the default placement only. The
  synthetic step covers three placements.
- **Profile:** it is one process of one tree, a sampling profile of the whole process.
- **Fixtures:** the synthetic fixtures are synthetic. The source rows qualify the pass on
  the lowered IR of one real file. Tier 1 still doesn't route C source through GVN by
  default, so no default compile or emitted-code effect is claimed.

## Provenance

These are original measurements of original Buster code. The frozen corpus is an external
runtime input, used as the 9700X job uses it; nothing from it is incorporated here
besides command lines and counts.
