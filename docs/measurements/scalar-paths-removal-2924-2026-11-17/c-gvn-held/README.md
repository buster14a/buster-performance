# C9g: value numbering's congruence solver deleted, held for the owner (#2924)

The branch in [`patches/`](patches/) (on main `968a085f`) keeps value numbering's scalar available-expression walk
and deletes the congruence solver, as rule 1 decided on speed (the walk took 0.87 to 0.93 times the solver's ticks in
every bin, [`../c-ir-gate-again/`](../c-ir-gate-again/)). It is held: the walk is not an exact twin. It never merges
phis, so equal phis and equivalent cyclic recurrences, which the solver merges, stay apart. The coordinator put that
to the owner (2026-11-23). Evidence that the corpora never reach the difference: the C9 gate's 1,371 of 1,371 objects
identical with the walk forced, and `test-ir-source --passes` on c-testsuite's subset, where both remove 5,520
instructions.

The branch also fixes the walk under `pressure`: a refused value now keeps the class it matched, as the solver's
"congruences computed as without it" did (test-ir-optimize's frozen `gvn-pressure` pair needs it). #3433 is the
follow-up for a vectorized form.

[`mutation/`](mutation/): 12 mutants of the walk (and round 2's rerun of three); 11 killed after the branch's fixtures,
and `h1` (fewer words hashed) changes hash quality alone.
