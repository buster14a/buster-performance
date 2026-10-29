# The IR's verifier, CFG builder and optimizer over placements, Buster #786

Compiler branch: `claude/ir-placement-786` of buster14a/buster, its pull request buster14a/buster#861, for
[the claim on #786](https://github.com/buster14a/buster/issues/786).

#786: after #774, `benchmark-ir`'s verifier and `benchmark-ir-optimize`'s passes ran slower on the 9700X at about the
same instructions. This record holds the runs that measured how much of that is where the code falls and how much is
work, and the comparison of the fix: the hot functions start 64-byte lines of their own (`aligned(64)`, and the
verifier's `noinline`), and `ir_operand` finds an operand's place by a table instead of a loop.

## Sources and host

Each tree is a `git archive` of its commit, extracted into a fresh directory on the 9700X; `logs/placements-c/manifest-*.sha256`
lists every file's SHA-256 as the host had it after the runs, which matched `git archive` of each commit file for file:

- **old:** `9bb5060ebe347de5c7a0a92ba325a7b14a567788`, #774's base;
- **main:** `74af99374e75a1325f5ffce7932fca372585a490`, main when #786 was filed (the first two runs);
- **base:** `da8424103bf67b1fc608acfbd37b1b3523f9c650`, the branch's base, main later;
- **head:** `db858e6cbc5743c36ad87272f51c62574c95ae8a`, the fix.

Host (`logs/placements-c/host.txt`, captured after the runs, from the same session): AMD Ryzen 7 9700X, Linux
6.18.50-2-lts, clang 23.1.1, perf 7.2.9, CPU 2's governor and energy preference `performance`. Each tree was built with
`BUSTER_DEBUG_INFO=0 ./build.sh shifts DIR main_unit_backend.c 0 640 1344 2048 2752 3456`: six links of the same objects,
the backend's unit (which holds both benchmarks and the code they run) that many bytes later, each a multiple of its
`.text`'s 64-byte alignment. `logs/placements-c/executables.sha256` gives every link's SHA-256. Every build, run and the
receipts took a separate hold of the host's lock (`exclusive.sh`), and every run was pinned to CPU 2. The lock's waiting
messages are taken out of the logs: its `exclusive.sh: waiting for the 9700X` lines and the `title:`, `link:` and
`pull request:` lines under them, the only lines of those shapes in any log.

## Old against main over placements

`scripts/q786a.sh` (`logs/placements-a/`): each link of old and main running `benchmark-ir` and
`benchmark-ir-optimize` once, the trees alternating and the order turning, two rounds. Medians of the twelve samples
(six placements, two rounds), ns per instruction for `benchmark-ir` and per function for `benchmark-ir-optimize`, and
the spread (the largest over the smallest):

| Row | Old | Spread | Main | Spread | Main/old |
| --- | ---: | ---: | ---: | ---: | ---: |
| 32 instructions: scalar verifier | 9.395 | 11.4% | 10.111 | 12.0% | +7.63% |
| vector verifier | 5.888 | 8.7% | 6.479 | 12.4% | +10.03% |
| uses | 10.921 | 4.3% | 11.117 | 6.6% | +1.80% |
| CFG | 1.681 | 4.0% | 1.740 | 2.4% | +3.48% |
| 262,144 instructions: scalar verifier | 8.721 | 13.5% | 9.296 | 10.5% | +6.59% |
| vector verifier | 5.517 | 7.7% | 5.906 | 18.3% | +7.06% |
| uses | 12.479 | 19.5% | 12.517 | 8.4% | +0.30% |
| CFG | 1.342 | 4.0% | 1.383 | 3.1% | +3.09% |
| small-dag, scalar | 2,100.4 | 9.4% | 2,106.2 | 3.9% | +0.28% |
| small-dag, vector | 2,169.1 | 7.7% | 2,138.6 | 3.0% | −1.40% |
| large-dag, scalar | 131,773.5 | 13.9% | 130,721.5 | 3.1% | −0.80% |
| large-dag, vector | 133,802.5 | 4.3% | 132,498.6 | 4.5% | −0.97% |
| phi-diamond, scalar | 1,634.5 | 4.0% | 1,791.2 | 7.6% | +9.59% |
| phi-diamond, vector | 1,853.1 | 4.0% | 1,936.0 | 10.3% | +4.48% |
| loop, scalar | 1,859.7 | 3.1% | 1,983.8 | 7.6% | +6.67% |
| loop, vector | 2,222.1 | 3.6% | 2,291.3 | 11.8% | +3.11% |
| jump-chain, scalar | 7,803.1 | 2.7% | 8,259.6 | 6.2% | +5.85% |
| jump-chain, vector | 17,863.9 | 7.1% | 17,440.1 | 15.8% | −2.37% |

The verifier's time depends on the placement in both trees, by up to 18%. A placement's effect repeats between the
rounds, and at some placements main is as fast as old. The CFG builder and the optimizer's scalar phi-diamond, loop
and jump-chain are slower in main at every placement. These shifts move the code by whole lines, so they don't vary
where it falls within one: main's `ir_verify_path` starts 32 bytes into a line, and its hottest loop 48 bytes in,
where old's start lines.

## Zen 5's counters at one placement

`scripts/q786b.sh` (`logs/counters-b/`): old's and main's unshifted links, two rounds of two groups of events each
(`stat-*.csv`), and a profile of each (`report-*.txt`, `annotate-*.txt`). At this placement main runs `benchmark-ir`
in 0.1% to 0.2% more cycles per instruction than old (the CFG builder 7.3%, noisily). In both trees, 10% to 15% of
the verifier's op-cache accesses miss, and 19% of the optimizer's, which then takes 13% to 14% of its ops from the
decoders.

## On a Zen 4 laptop

`local/zen4-counters/` (`scripts/zen4-ratios.py` prints its tables): the 9700X's unshifted links of old and main run on
a Ryzen 9 7940HS, every event normalized by its run's own instructions, three runs each. Main executes about as many
instructions per run as old (+0.4% for `--only scalar`), in 9.1% to 10.6% more cycles per instruction. The dispatch
slots that the front end leaves empty grow 67% to 74% per instruction. Back-end stalls fall 2% to 4%. Mispredictions,
op-cache misses, I-cache misses and pipeline restarts stay under 0.05 per 1,000 instructions.

`local/variants/` retains historical exploratory trials labeled `v0` through `v4` on the laptop. The original
notes describe five versions of `ir.c`, linked with the same other objects by `variants-build.sh`. The source
construction or patches for `v1`, `v2` and `v3`, and the local executable hashes and build/toolchain receipts for
all five variants, are not retained in this record. That script assumes already prepared source directories; it does not
reconstruct them. The labels below therefore do not establish identified-source causal comparisons or prove
that the local `v4` executable matches the separately identified 9700X head.

`scripts/variants-report.py` recomputes the counter table from the retained receipts, using a matched-work subset
of `benchmark-ir --only PATH --passes 1`. It excludes `v0-scalar-3` and `v1-scalar-1`: those logged 4,096 small-function
repetitions instead of the selected 8,192 (all large-function scalar samples have one repetition). This keeps
**58 of 60 counter samples**. Scalar counts for `v0/v1/v2/v3/v4` are **2/2/3/3/3**; each other path keeps three
samples per variant. The selected repetition tuples for vector, scalar, uses and CFG are `(8192, 1)`, `(8192, 1)`,
`(4096, 1)` and `(32768, 4)` respectively. No raw receipt is changed. Run the report with Python from any directory;
its default input is this record's `local/variants/` (an optional argument selects another receipt directory).

| Historical trial label and reported description | Instructions | Cycles |
| --- | ---: | ---: |
| `v3`, the pins alone | −0.5% to −2.9% | −0.8% to −2.8% |
| `v4`, the pins and the table | −1.7% to +1.5% | −2.4% to −4.7% |
| `v2`, those and the dominance loop reading a local copy of the function | +1.9% to +6.2% | −2.3% to −4.6% |
| `v1`, a rewrite of the dominance loop | +4.9% to +14.4% | +0.2% to +30.4% |

Each difference is against the trial labeled `v0` (reported as main `da842410`), over the four paths (vector,
scalar, uses, CFG). These local observations are not qualifying evidence for the source changes. The primary
9700X campaign below has separate complete source manifests, executable identities and build/run receipts.

## Old, base and head over placements

`scripts/q786c.sh` (`logs/placements-c/`): base's and head's six links, and old's from the first run, each running
both benchmarks once, the three trees in a turning order, two rounds. Medians of twelve samples:

| Row | Old | Spread | Base | Spread | Head | Spread | Head/old | Head/base |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 32 instructions: scalar verifier | 9.357 | 5.1% | 9.684 | 7.2% | 8.989 | 11.1% | −3.93% | −7.18% |
| vector verifier | 5.950 | 10.4% | 6.114 | 8.2% | 5.447 | 9.0% | −8.44% | −10.91% |
| uses | 10.817 | 8.9% | 10.811 | 5.8% | 10.188 | 6.0% | −5.82% | −5.76% |
| CFG | 1.681 | 6.7% | 1.744 | 16.5% | 1.751 | 7.2% | +4.10% | +0.40% |
| 262,144 instructions: scalar verifier | 8.717 | 7.0% | 9.005 | 5.7% | 8.479 | 8.5% | −2.74% | −5.84% |
| vector verifier | 5.633 | 9.1% | 5.645 | 7.9% | 5.285 | 10.6% | −6.18% | −6.37% |
| uses | 12.492 | 7.5% | 12.090 | 4.5% | 11.758 | 5.0% | −5.88% | −2.74% |
| CFG | 1.352 | 4.3% | 1.384 | 26.9% | 1.374 | 3.8% | +1.63% | −0.72% |
| small-dag, scalar | 2,092.9 | 8.5% | 2,096.7 | 3.3% | 1,997.5 | 2.1% | −4.56% | −4.73% |
| small-dag, vector | 2,174.6 | 8.9% | 2,120.3 | 2.2% | 2,036.9 | 2.8% | −6.33% | −3.93% |
| large-dag, scalar | 130,679.2 | 13.2% | 129,586.2 | 2.9% | 124,234.3 | 2.9% | −4.93% | −4.13% |
| large-dag, vector | 134,045.8 | 6.1% | 131,291.0 | 2.6% | 123,842.0 | 4.5% | −7.61% | −5.67% |
| phi-diamond, scalar | 1,652.9 | 4.0% | 1,714.3 | 1.9% | 1,684.6 | 1.8% | +1.92% | −1.73% |
| phi-diamond, vector | 1,864.9 | 4.4% | 1,863.2 | 2.8% | 1,854.7 | 3.0% | −0.55% | −0.46% |
| loop, scalar | 1,857.0 | 4.1% | 1,914.5 | 3.0% | 1,891.7 | 2.4% | +1.87% | −1.19% |
| loop, vector | 2,214.9 | 6.2% | 2,241.0 | 3.1% | 2,237.2 | 3.0% | +1.01% | −0.17% |
| jump-chain, scalar | 7,792.3 | 1.9% | 8,041.3 | 1.5% | 8,051.5 | 4.6% | +3.33% | +0.13% |
| jump-chain, vector | 17,866.6 | 5.5% | 17,332.7 | 3.3% | 17,282.0 | 7.1% | −3.27% | −0.29% |

Head's verifier, at both sizes and on both paths, and its use lists are below old's at the same placement and round in
70 of these six rows' 72 samples (every vector and uses sample, and 11 of each scalar row's 12). Base's CFG spreads of
16.5% and 26.9% come from two samples per row, at 640 bytes in the first round and 3,456 in the second (2.010 and 1.985
against at most 1.839, and 1.737 and 1.726 against at most 1.402).

## What it shows, and what it doesn't

- Head is faster than old on the verifier (2.7% to 8.4%), on the use lists (5.8% to 5.9%), and on six of the
  optimizer's ten rows.
- The CFG builder (+1.6% and +4.1%) and the optimizer's scalar phi-diamond (+1.9%), loop (+1.9%) and jump-chain
  (+3.3%) stay slower than old, about as base is, at every placement's two-round median. Source inspection identifies
  #774's added per-function checks (the shape check's labels, ABI records and a variadic frame's anchors) and
  per-block checks (`br_indirect`'s arms in the successors), which small functions don't amortize; this work
  explanation is separate from the placement observations.
- The vector loop's pooled median is +1.0% over old, but head is faster at shifts 0 and 2,048: respectively
  2,236.25 versus 2,242.35 and 2,241.65 versus 2,265.25 ns/function in the two-round medians. Its regression is
  not present at every placement.
- Pinning to lines doesn't make the verifier alike over these placements: head's spreads (8.5% to 11.1%) are as wide
  as old's and base's. Moving the code by whole lines changes which op-cache sets its lines take, and the op cache
  misses 10% to 15% of the time here. Pinning fixes only where the loops fall within their lines, which no longer
  depends on the code before them.

## Limitations

Two rounds per placement, six placements, all moving the code by whole lines; one host. The Zen 4 study is on another
microarchitecture and isn't the target's measurement. Its local variant comparison uses the matched-work subset
above and has incomplete source/binary/build identities, so it cannot reproduce or establish attribution to the
reported edits. The host receipts were captured after the runs.
