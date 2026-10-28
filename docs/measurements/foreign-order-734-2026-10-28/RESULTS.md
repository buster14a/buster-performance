# Measured correctness and cost

This is the complete frozen `abc6bf2455c6d1d78f16bc2d494276380c546a79`
to `732b79132a52264683abdd0b757053c3901e622b` cohort on the approved Ryzen 7
9700X with official Clang 23.1.4. Source PR #747's integration `74430099`
has identical foreign production/test files. The coordinator's subsequent
`85629e6c` changes the conversion gather/guards; its qualification and timings
remain separate. The measured source snapshots stayed unchanged throughout
the cohort.

## Resolver samples

Each process preserves 320 groups of 21 timed samples: eight input/kind cases,
one/eight lanes, vector/exact paths, and whole resolver plus nine phases.
Six processes preserve **40,320 samples**, including every large value.
Raw samples are emitted after each resolution loop's timed intervals and before
the original median sort. They are available beside each derived CSV.

For the largest (102,400-worker, 512-unit, up-to-64-filler) vector inputs,
the three paired median differences are:

| Kind | Lanes | Whole resolver added, ms (pairs 1 / 2 / 3) | Whole added, % | Winners added, ms |
| --- | ---: | --- | --- | --- |
| Dynamic | 1 | 1.188 / 1.212 / 1.260 | 8.36 / 8.52 / 8.94 | 1.084 / 1.102 / 1.092 |
| Dynamic | 8 | 0.923 / 0.973 / 0.979 | 13.01 / 13.80 / 13.86 | 0.941 / 0.956 / 0.947 |
| Static | 1 | 1.112 / 1.271 / 1.215 | 7.52 / 8.62 / 8.23 | 1.082 / 1.108 / 1.086 |
| Static | 8 | 1.000 / 0.922 / 0.949 | 13.74 / 12.55 / 12.94 | 0.931 / 0.951 / 0.939 |
| Archive members | 1 | 1.056 / 0.926 / 0.568 | 5.61 / 4.91 / 2.99 | 1.087 / 1.076 / 1.076 |
| Archive members | 8 | 0.801 / 0.962 / 0.897 | 9.13 / 11.06 / 10.32 | 0.929 / 0.949 / 0.963 |

Across these rows the second/third baseline whole medians differ from the
first baseline by **−1.00% to +1.01%**. The repeated added winners cost is
larger than its baseline variation (−2.51% to +0.67%). The winners phase now
includes key completion and canonical order sorting, in addition to its
pre-existing work. Its baseline ratio to whole resolver median is
10.58–18.61% across the six rows above. This ratio of medians of slowest-lane
phase samples is descriptive; phases are not an additive decomposition.

All 320 rows, including exact paths, medium and tiny cases, are retained in
[`phase-comparison.csv`](raw/phase-comparison.csv). Small eight-lane whole
times have substantial process variation; this record does not attribute every
such fluctuation to sorting or discard it.

## Production command controls

The unmodified production `benchmark-link --only linkers --linkers
link-foreign` command runs its real compiler subprocesses. It reports seven
timed runs per placement (minimum, median and maximum), with warm-up and
resource-counting runs handled separately by the existing command. Four
placements per model/kind are retained: automatic threads, forced eight lanes,
one thread on inherited CPUs, and one thread pinned to CPU 2.

The **two baseline/candidate pairs contain 96 reported rows / 672 timed
subprocesses**. This command does not expose its individual seven timings;
only its original reported summaries are available. The complete original
stdout/stderr and all 96 derived min/median/max/resource rows are retained.

| Workers | Kind | Placement | Added median, ms (pairs 1 / 2) | Added, % (pairs 1 / 2) | Baseline repeat drift, % |
| ---: | --- | --- | --- | --- | ---: |
| 2,000 | Dynamic | 8 lanes | 0.377 / 0.463 | 16.45 / 21.22 | −4.75 |
| 2,000 | Static | 8 lanes | 0.452 / 0.479 | 13.00 / 13.92 | −0.99 |
| 2,000 | Dynamic | CPU 2, 1 thread | 0.052 / 0.072 | 4.35 / 6.05 | −0.56 |
| 2,000 | Static | CPU 2, 1 thread | −0.004 / −0.003 | −0.19 / −0.16 | −0.10 |
| 102,400 | Dynamic | 8 lanes | 0.932 / 1.640 | 2.78 / 4.99 | −1.71 |
| 102,400 | Static | 8 lanes | 0.824 / 0.728 | 2.35 / 2.13 | −2.25 |
| 102,400 | Dynamic | CPU 2, 1 thread | −1.346 / −2.641 | −2.24 / −4.38 | +0.58 |
| 102,400 | Static | CPU 2, 1 thread | −1.739 / −2.616 | −2.79 / −4.19 | +0.09 |

The largest forced-eight-lane baseline medians are 32.90–35.02 ms;
candidate medians are 34.40–35.85 ms. Dynamic/static output lengths remain
49,250,384 / 47,562,480 bytes. Byte-identical output is required across
partition perturbations within the candidate, not between old and new order.
The complete automatic/unpinned/tiny rows and all ranges/resources are in
[`whole-command.csv`](raw/whole-command.csv) and
[`whole-comparison.csv`](raw/whole-comparison.csv). For example, the first
largest dynamic-eight-lane candidate maximum is 50.235 ms; it is retained.

These whole-command models differ from the resolver models. Both use the
default worker/filler sizes, but the command uses a minimum of four units,
`max(functions / 50, 32)` globals and seed 1; the resolver uses one/ten/512
units, eight globals and seed `1 + model_index`. The command includes process,
conversion, relocation and output work. An exact resolver-phase fraction of
the command delta is therefore unavailable. In particular, the medium
eight-lane command delta exceeds the medium resolver phase increment on its
different inputs; this record does not invent a causal allocation or claim
that parallelizing sorting alone removes it.

## Interpretation and next decision

Canonical symbol order passes the independent functional controls in the
[main record](README.md), while old production fails 336/1,143 functional
checks. The cost is a material, repeated tradeoff, especially on eight lanes.
There is no universal performance-neutrality or speedup claim, no current-main
timing claim, no confidence-interval claim from min/max summaries, and no
hardware-counter or same-input whole-command profile in this cohort.

The final manifests prove all retained generated resolver inputs agree
between six processes, and all retained largest-model command objects agree
between four. Whole-command smaller-model object files are overwritten by the
existing command's directory reuse; no final hash is claimed for those bytes.
Runtime snapshots are source-dependent internal serialized inputs, with
different baseline/candidate hashes and identical repeats within each source.
They are disclosed as part of the complete command, rather than described as
byte-identical external ELF inputs.

The current stable radix has a same-design potential follow-up: parallelize
its count/place passes on the existing team. That is an unmeasured proposal,
not an implemented or accepted mitigation. The reviewer/maintainer decides
whether to accept this correctness tradeoff or request a bounded follow-up;
source is held unchanged pending that decision.

Initial integration744 CI is not green: hosted x86-64 passes; hosted native
passes the foreign matrix but rejects the two native gather builtin
expansions during own-unit checking. The physical build prerequisite fails
and its benchmark job is skipped. The coordinator's subsequent correction856
has both hosted jobs in progress at receipt collection, with changes/storage
policy passing. Its source admission and new exact-source sanitizer work are
reported in the [public handoff](https://github.com/buster14a/buster/pull/747#issuecomment-6481872037).
This cohort does not qualify that changed gather helper, clear current CI,
or recommend landing by itself.
