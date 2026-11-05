# The checker's `bc11fddb`..`d11a91d2` regression on the 9700X, and the const receipts' fix

The locked 9700X's measurements for Buster's issue
[#872](https://github.com/buster14a/buster/issues/872) and its fix,
[#980](https://github.com/buster14a/buster/pull/980). #872 was found by #847's
campaign M7: main `d11a91d2` read the checker's units slower than
`bc11fddb`, most on the units that include the C library's headers. This
record measures every first-parent merge in `bc11fddb..d11a91d2` against its
parent on the 9700X, the fix's parent and head, and current main, on M7's ten
units, in source order and with the deferred reader on one lane and by its
lane rule.

In short:

- **#754 is the whole regression.** On the ten units' one-lane readings, #754
  changes the median by +1.6% (`+2.1%` in source order), `sqlite3.c` by
  +4.9% (source order +3.0%), `00204.c` by +15.0%, `00200.c` by +7.3% and
  `00213.c` by +12.9%. Each of the other ten first-parent merges changes the
  ten-unit median by between −0.8% and +1.2% one lane (−1.6% to +1.6% in
  source order), no monotonic accumulation, and the whole
  `m754..d11a91d2` stretch is +0.4% one lane and +0.4% in source order: the
  campaign's noise.
- **The cost is #754's own work.** In the units' own terms it is 4.0 ns per
  input token on `sqlite3.c` in the deferred reader's one lane (2.1 in
  source order), 9.7 on `00204.c`, 2.9 on `00200.c` and 23.5 on `00213.c`:
  the const receipts' tries, byte copies, initializer re-evaluation and
  liveness walk. `perf stat` counts +4.06% instructions and +3.74% cycles on
  `sqlite3.c` and +3.82% and +11.19% on `00204.c`.
- **The fix removes the accidental share.** #980's `fresh` skip costs 0.5%
  of the ten-unit median one-lane change less, 0.4% on `sqlite3.c`'s
  one-lane reading, and 0.06% of its instructions (0.20% of `00204.c`'s);
  on the rule's multi-lane reading the fixed head's token-weighted total is
  `bc11fddb`'s (54.13 against 54.11 ms).
- **Later main is later features.** `97824e90` is 148 first-parent merges
  past `d11a91d2`. Its token-weighted one-lane total is 1.5% above the fixed
  head's and 8.0% above `bc11fddb`'s, of which this range's own account is
  6.4%; the further 1.5% of `sqlite3.c`'s instructions (and the larger
  shares on the small units) accumulates over the later checker features
  (#927, #966, #968, #1002 and the intervals around them), outside #872.

## Sources and inputs

The campaign's trees are the first-parent chain from `bc11fddb` to
`d11a91d2`, the fix's parent and head, and current main; `p965`, `p969`,
`p973`, `p968` and `p1002` are post-range checkpoints for `perf` only. Each
tree is a `git archive` of the named commit with a `COMMIT` file. `trees.txt`
has each tree's commit, the SHA-256 of its source manifest (the SHA-256 of
`build.sh` and every file under `src`) and its file count; the
`source-TREE.sha256` files are the manifests.

| Tree | Commit | What it is |
| --- | --- | --- |
| `base` | `bc11fddb` | main before #791, #764's campaigns' main |
| `m754` | `5655370e` | merge of #754, the const receipts |
| `m729` | `25d16a03` | merge of #729, the oracle runner's cache |
| `m747` | `cc324f7f` | merge of #747, foreign symbols' canonical order |
| `m759` | `7a1f7373` | merge of #759, the SSE builtins |
| `m800` | `716e00cc` | merge of #800, deep wide and vector values |
| `m790` | `3e86e2e3` | merge of #790 |
| `m826` | `e85d634a` | merge of #826, the Tier 0 vector NaN fixture |
| `m735` | `e18f2d33` | merge of #735, K&R parameter entry conversions |
| `m752` | `5c7a0bd7` | merge of #752, parenthesized atomic K&R lists |
| `m756` | `6a713e5b` | merge of #756, bounded K&R tag scope |
| `end` | `d11a91d2` | merge of #831, #872's measured head |
| `pre980` | `976ea0b1` | #980's parent |
| `fix980` | `5a0fea1b` | #980's merge, the `fresh` skip |
| `main` | `97824e90` | current main when the campaign ran |
| `p965` | `693926a7` | post-range checkpoint (`perf` only) |
| `p969` | `f269c462` | post-range checkpoint (`perf` only) |
| `p973` | `d599b289` | post-range checkpoint (`perf` only) |
| `p968` | `17a88f15` | post-range checkpoint (`perf` only) |
| `p1002` | `1cd79711` | post-range checkpoint (`perf` only) |

The inputs are the ten units of #847's campaign M7, from record A2's 43:
four of c-testsuite's single-exec programs at
`5c7275656d751de0e68b2d340a95b5681858ed07`, the frozen `sqlite3.c`, and
five synthetic units from A2's generator. `inputs.sha256` has their SHA-256;
they are the same bytes as #847's record's. They are read
with the frozen corpus's pinned predefines and headers,
`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`, and
`SOURCE_DATE_EPOCH=1792454400`, with `CPATH` and `C_INCLUDE_PATH` unset
(`scripts/env.sh`).

Host (`host.txt`): AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1,
GCC 16.2.1, perf 7.2.9-1; transparent huge pages `always` (defrag
`madvise`); CPU 2 performance governor, CPUs 0, 1 and 3 to 7 powersave.

## Method

Each tree was built as the 9700X job builds it, `env BUSTER_DEBUG_INFO=0
./build.sh`, in a lock hold of its own (`scripts/build.sh`;
`logs/builds.txt`). The builds are reproducible: `base` and `end` have the
same SHA-256 as #847's record's binaries (`45b8e9b2…` and `48c87eaf…`).

Each run is one process of

```sh
./build/compiler benchmark-checker-deferred --passes 24 --lanes 8 --cpus 2,0,1,3,4,5,6,7 \
    --predefines $corpus/provenance/gnu17-pinned-predefines.txt --clang-features \
    --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc \
    -isystem $corpus/headers/usr/lib/clang/23/include \
    -isystem $corpus/headers/usr/local/include \
    -isystem $corpus/headers/usr/include FILE
```

with `--passes 12` for `sqlite3.c` (`scripts/runs.sh`). A run reports, in
nanoseconds per input token, source order's reading, the deferred reader's
one-lane reading and its reading on the lanes the reader's rule gives it
(`--lanes 8` is the upper bound). The command pins itself to CPU 2 and its
lanes to 2, 0, 1, 3, 4, 5, 6 and 7.

The campaign has five rounds. Each round visits the ten units in an order
that starts three units further on, and for each unit the fifteen trees in an
order that starts two trees further on and one more for each unit: every tree
is measured once per round on every unit, and no tree keeps a place in the
order. Each run takes the shared lock for itself (`exclusive.sh`), so CI
jobs and other sessions go between runs. The campaign's 750 runs all exited
0 (`logs/runs.txt`, `analysis/m872sum.py`).

`perf stat -r 3 -e instructions:u,cycles:u` over the same command with
`--lanes 1` and `--passes 24` (`6` for `sqlite3.c`), pinned to CPU 2, gives
the instruction and cycle counts of the endpoint and post-range trees on
`00204.c` and `sqlite3.c` (`scripts/perf.sh`, `logs/perf.txt` and
`logs/perf-post.txt`, `tables/perf.md`). Each count is the median of three
runs; the instruction counts' relative spread was 0.00% and the cycles'
at most 0.54%.

## The campaign

- `tables/medians-source.md`, `tables/medians-one-lane.md` and
  `tables/medians-rule.md`: every unit's median ns/token for every campaign
  tree, in source order, one lane and by the rule.
- `tables/merges.md`: each first-parent merge against its parent, the fix
  against its parent, current main against the fix, and the endpoints, with
  each unit's change and the change of the reading's phases (`top`, `walks`,
  `merge`, `rest`).
- `tables/totals.md`: the sum over the ten units of tokens times the median
  ns/token, so that a change on `sqlite3.c` counts as the compile actually
  sees it, and each tree's change.
- `tables/perf.md`: the instructions and cycles, against `base`.

## What the campaign found

**#754 is the range.** Its one-lane change is +4.9% on `sqlite3.c`, +15.0%
on `00204.c`, +7.3% on `00200.c` and +12.9% on `00213.c`; the token-weighted
total rises from 66.42 to 69.48 ms (+4.6%). The cost is in the reading's
walks and merge phases (`tables/merges.md`): on `sqlite3.c` the one-lane
walks are +14.8% and the merge +16.0%, while `rest` is −0.2%; on `00204.c`
they are +63.8% and +50.2%.

**The ten later merges are noise.** Each changes the ten-unit median one-lane
reading by −0.8% to +1.2% and the source-order one by −1.6% to +1.6%; the
stretch from `m754` to `end` sums to +0.4% one lane (+0.4% in source order,
+0.5% by the rule), and the three K&R merges (#735, #752 and #756) are +0.0%,
+0.3% and +0.1% by the one-lane median. The endpoint `bc11fddb..d11a91d2` is
+5.0% one lane by the token-weighted total (+3.3% in source order, +3.3% by
the rule), of which #754's +4.6% is all but the noise. `perf` confirms it:
#754 is +4.06% instructions on `sqlite3.c` and +3.82% on `00204.c`, while
`m754..d11a91d2` is +0.15% and +0.03%.

**The fix's share is small and real.** `pre980..fix980` is −0.5% by the
ten-unit median one-lane change, −0.4% on `sqlite3.c`, −1.2% on `00204.c`
and −2.0% on `00213.c`; `perf` counts −0.06% of `sqlite3.c`'s instructions
and −0.20% of `00204.c`'s. On the rule's reading, where the lanes read the
bodies apart, the fixed head's token-weighted total is `bc11fddb`'s exactly
(54.13 against 54.11 ms): the duplicate search was the part of #754 that
didn't belong to the feature, and it is gone. The rest of the feature's cost
remains, as the issue asks: 4.0 ns/token on `sqlite3.c` one lane (2.1 in
source order), 9.7 on `00204.c`, 2.9 on `00200.c` and 23.5 on `00213.c`.

**Current main is later features.** `97824e90` is 148 first-parent merges
after `d11a91d2`. Its token-weighted one-lane total is 71.73 ms against the
fixed head's 70.70 (+1.5%) and `bc11fddb`'s 66.42 (+8.0%); source order is
59.63 against 58.51 and 55.87 (+1.9% and +6.7%). `perf` puts +2.4% of
`sqlite3.c`'s instructions between `d11a91d2` and #980's parent and another
+1.5% between the fix and `p1002`; the post-range checkpoints show those
intervals contain 132 and 13 first-parent merges, including the checker
features #927's implicit library declarations, #966's library builtins,
#968's default warnings and #1002's aligned `_Expect`s. None is part of
#872's range, and the campaign does not attribute them further; they are
their own issues' work.

## Limits

- The benchmark's figures are medians over five process rounds of the
  benchmark's medians over 24 passes (12 for `sqlite3.c`). `00213.c` has 460
  tokens, so its fixed per-reading costs dominate; its changes are the
  noisiest of the ten and the campaign's ranges above are what a five-round
  comparison resolves, not a claim about single runs.
- The "by the rule" reading's lane count is the reader's: `00213.c` and
  `00200.c` read on one lane, `00204.c` and `h16x10.c` on two or three,
  `sqlite3.c` on eight; the tables give each reading's `active` count in the
  log, not per median.
- This measures the reader (`check_input` and `check_input_deferred`) alone,
  not the graph's checking after it, code generation or compile time. The
  later-main figures are endpoint evidence, not an attribution of those 148
  merges.
- The campaign ran on 2026-11-01 with the corpus, host and software in
  `host.txt`; a different main, corpus or clang can move the later-main
  figures.

## Files

- `trees.txt`, `source-*.sha256`, `binaries.sha256`, `inputs.sha256`,
  `host.txt`: the identities.
- `scripts/`: `env.sh` (corpus, options, lock owner), `build.sh`,
  `runs.sh`, `perf.sh`, `artifacts.sh`.
- `logs/builds.txt`, `logs/runs.txt`, `logs/perf.txt`,
  `logs/perf-post.txt`: every build's and run's heading, output and exit
  status; the lock's waiting messages, which name other sessions' work, are
  removed (`analysis/strip_lock.py`).
- `analysis/m872sum.py`, `analysis/sum872.py`: the medians, merges, totals
  and perf tables from the logs.
- `tables/`: the generated tables.
