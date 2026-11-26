# Late definitions follow their earlier body convention

This is the first measured definition-convention experiment for compiler issue #2553. It is superseded by [the call-convention refinement](../definition-v2/README.md). It replaces the rejected latch hypotheses with a smaller hint change, against clean baseline `8e4d32879e17b7d9548cad54257a2f8461328366`.

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

The four SQLite snapshots reduce resolved moves by 3, 18, 9 and 5 respectively. Their new fragments evict or recompute recipes; none adds a register-to-spill transition. These local replay observations do not prove whole-program dynamic improvement or the absence of extra spills elsewhere. Hosted compilation, native-output verification and tagged instruction counts are complete below. No hardware performance claim is made, and benchpress/9700X remains excluded by the session constraint.

## Actual emitted programs and controlled counts

SQLite and all five Lua workloads pass their native and Callgrind output checks. The final compiler inputs captured from the emitted programs are byte-identical to baseline snapshots except the allocation fingerprint field, and reproduce the predicted allocations exactly. The integrated source and regressions pass 107,668 full CFG checks and 159 focused ASan/UBSan checks, with no failures or sanitizer diagnostics.

Lua's executable name is observable input: the first captures used different argv[0] strings and produced small setup/collector differences. Those captures are retained as a diagnosed confound. The authoritative comparison reruns both exact binaries through the same `/dev/shm/buster-2553-lua-stable/lua` pathname, cwd, script arguments and environment. All ten controlled joins and output checks pass.

| Whole executable | SQLite baseline | SQLite definition | Controlled Lua baseline | Controlled Lua definition |
| --- | ---: | ---: | ---: | ---: |
| Instructions | 2,250,813,933 | 2,250,807,530 | 3,994,122,886 | 3,981,380,282 |
| Edge register moves | 37,068,474 | 36,134,979 | 82,467,924 | 69,725,320 |
| Edge stores | 30,206,285 | 30,205,544 | 5,541,088 | 5,541,088 |
| Edge reloads | 53,535,497 | 53,534,756 | 21,581,948 | 21,581,948 |
| Spill stores | 21,270,991 | 21,270,991 | 29,251,356 | 29,251,356 |
| Spill reloads | 19,142,024 | 19,142,024 | 12,898,903 | 12,898,903 |

No function has increased S/L/T/t/U/u in either authoritative workload comparison. Per-function call saves/restores are unchanged too. Lua's entire instruction reduction equals its 12,742,604 removed edge moves; 12,742,052 are in luaV_execute. All other full-program origin groups are identical.

SQLite's edge improvement is partly offset by **1,091,787 additional call-setup instructions**, chiefly 1,037,030 in sqlite3BtreeIndexMoveto. The new definition hint blocks existing call-register propagation through ties. The second experiment fixes that precedence and ordering before promotion. SQLite's main Vdbe dispatcher remains unchanged.

[Detailed analysis](analysis.txt), [exact receipt](receipt.tsv), [canonical category table](canonical-family-category-comparison.tsv) and [per-workload totals](canonical-workload-totals.tsv) accompany [the raw evidence](definition-v1-raw.tar.xz). The archive includes paired and diagnosed traces, disassembly, tags, fresh CFG inputs, compiler provenance, output checks and integrated test sources/logs. Large instruction joins and text allocation dumps are regenerable. Its internal `ARCHIVE-SHA256SUMS` covers every retained file. Archive SHA-256: `b83e6eaa8aa8f8cf6435702909f77ff1ad17ad65c7670b69b7f5dda4e968b3da`.
