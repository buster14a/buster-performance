# Late definitions follow their earlier body convention

This is an unaccepted experiment for compiler issue #2553. It replaces the rejected latch hypotheses with a smaller hint change, against clean baseline `8e4d32879e17b7d9548cad54257a2f8461328366`.

A non-phi, non-rematerializable value whose defining block follows its loop body in layout may already have an established register in the earlier body range. When the definition has no operand, tie or interval hint, it follows that first range's opening. The existing allocator can then yield that register from an unused rematerializable value. No new eviction or call-save policy is introduced.

The helper masks 16 values at a time, performs a bounded parallel binary search over each eligible value's disjoint interval slice, and gathers/scatters only selected rows. The resulting source has one vector implementation.

- [Patch against clean baseline](definition-hints.patch), SHA-256 `dac68a83e6697b1186b822ddb8bcb75c47651caa42d880864f7b5424b91bd438`.
- Resulting `tier1_cfg.c` SHA-256: `308189ce8354270996464799b6210a6aa605f6aaa242eb02462e31ccbfbd9a5f`.
- Vector and initial exploratory scalar formulations reproduce identical allocations on the actual Lua dispatcher and all four captured SQLite functions. The scalar formulation is not proposed production code.

| Captured input | New fingerprint | Certificate |
| --- | --- | --- |
| Lua 1257 blocks | `628b63303053c54b` | 0 |
| SQLite 3591 blocks | `72d59ec7c997b17f` | 0 |
| SQLite 2080 blocks | `e306ec9885efa2ec` | 0 |
| SQLite 1161 blocks | `e16d7a0ddab2a998` | 0 |
| SQLite 1910 blocks | `0e8729b8423cadaf` | 0 |

Lua changes the late definitions of cl and k in startfunc. Its 577 resolved edge moves become 575, with the same 40 spill values and 10,546 fragments. On the most frequent returning edge, two three-instruction register swaps become one four-instruction cycle. That edge ran 6,371,026 times in the baseline captures: the predicted two-instruction reduction must be confirmed in freshly emitted code.

The four SQLite snapshots reduce resolved moves by 3, 18, 9 and 5 respectively. Their new fragments evict or recompute recipes; none adds a register-to-spill transition. These local replay observations do not prove whole-program dynamic improvement or the absence of extra spills elsewhere. Hosted compilation, native-output verification, tagged instruction counting and final regression coverage are pending. No hardware performance claim is made, and benchpress/9700X remains excluded by the session constraint.
