# Independent read-only reduction

A separate review agent wrote `reduce.c` and checked the completed raw data
without running compiler images, rebuilding shipping sources, taking the host
lock or adding measurements. This is a technical evidence audit, not a GitHub
approval event or personal contribution certification.

It validates all 972 unique successful timing cells, six successful producer
statuses/completion markers and the canonical 33 stage files. All 24 whole
summary rows match the primary strict reader exactly; all 21 stage metric rows,
including minimum/maximum values, agree numerically. Its per-layout and all-cross
layout/copy envelopes preserve physical-copy sensitivity and repeated-baseline
drift. `receipt.txt` records successful final reduction.

To reproduce into a new output prefix, compile the standalone C reader and pass
the packet directory plus the output prefix:

```sh
cc -std=c17 -O2 -Wall -Wextra -Werror reduce.c -o /tmp/read-pr920
/tmp/read-pr920 /absolute/path/to/packet /tmp/pr920-final
```

The reducer writes `-whole.csv`, `-placement.csv`, `-sensitivity.csv` and
`-stages.csv`. These are descriptive medians/envelopes, with no independence or
statistical-significance assumption. The strict primary reader's malformed
numeric/grid controls and stage-fixture controls are separately retained under
`reader-review-controls/`; real oracle/count controls are in `diagnostics/`.
