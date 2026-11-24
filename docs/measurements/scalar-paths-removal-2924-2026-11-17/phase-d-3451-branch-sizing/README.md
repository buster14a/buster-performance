# #3451 / #2924 phase D: branch sizing's worklist (rejected)

Session: `session_01EgbxndFreFrJqAywiEGoue`. The census is `phase-d-3451-census/`: the worklist is reached once in its
inputs, in Lua 5.4.8 at `-c --tier1 -g`.

After `BUSTER_BRANCH_SIZING_ROUNDS` (4) rounds, `branch_sizing_worklist` grows the branches still out of range, one at
a time, in order. Its marks are already vector (`branch_sizing_mark_vector`: a short branch's ±63-branch window, 16 at
a time). Two parts are scalar:
- the scan for the last round's growths, a branch at a time;
- `branch_sizing_displacement`, which sums a dirty branch's span's growths one at a time.

The rounds can't replace the worklist: a chain takes a round per link, so a chain of n links would take n vector
passes over its n branches.

## The gate

`gate.c` and `side.c` build one executable with main `9da8765c5`'s `size_branches` (old) and a variant's (new), each
with its tree's encoder and lanes:
- **Inputs:** chains of 5 to 4,000 links, forward and backward, from main's `branch_sizing_chain`. That is the
  worklist's case: 5 rounds, then 1 to 3,996 evaluations.
- **Check:** records, offsets, length, rounds, long branches and evaluations compared.
- **Timing:** rdtsc ticks a call, 21 passes alternating which side goes first, the medians.

Every variant matched main exactly. Measured in the cloud container:

| variant | new/old |
| --- | --- |
| span sums 64 lanes at a time (four masked loads and a reduction), growth scan 16 at a time | 1.09-1.38 |
| no span sums: the marks add each growth to the displacements of the branches whose spans hold it, so the column stays current | 1.01-1.10 |
| the same, the marks gathered in two words before the stores | 1.03-1.19 |
| the growth scan 16 at a time alone (the span sums scalar) | 1.05 at 5 links to 0.97 at 2,000 |

- **The span sums:** in a chain, each dirty branch's span holds one or two branches. The scalar sum is one or two adds,
  which four masked loads and a reduction, or a displacement update in every mark, cost more than.
- **The growth scan:** only from about 32 links up do 16 lanes at a time win.

No variant is at least as fast at every size, so the worklist stays as it is, under the owner's rule for #2924. The
9700X was not used: every variant lost at some size in the container by more than its noise.
