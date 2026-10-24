# Final integration receipt for #335

[PR #375](https://github.com/buster14a/buster/pull/375) merged at **2026-10-24 14:27:02 UTC** as `1402e80a6f124fdfeb77c0ec76ff1bf0223ea9e5`. [Issue #335](https://github.com/buster14a/buster/issues/335) closed as completed at **14:27:04 UTC**.

The final head was `aca9ba491fd260b6ed642a5ed3b4ad6785583d0a`. Approved-host [9700X run 40101837210](https://github.com/buster14a/buster/actions/runs/40101837210), [job 120895445940](https://github.com/buster14a/buster/actions/runs/40101837210/job/120895445940), and storage run 40101837216 all succeeded. The native job ran from 14:21:52 to 14:25:28 UTC on benchpress, Ryzen 7 9700X, Clang 23.1.1, with runner lock hooks and host release recorded.

CI checked out merge `2ed5b6e1f2b1b4cc749acf1b3d69e0d18f63b9e8`. It and the actual merge have parents `b971f832cf4e3cdf8bda6a7547887cbcde45d8c5` and the final head above, and identical tree `d02bf3c93fcd0890c1ce149514edefb2a31c9d05`. The coordinator verified main containment for both this head and qualified #336 head `2612e7e0676baa8029d4cbfa3632e2e07230d84c` with behind_by zero.

Executed checks:

- Full normal test step passed. Guarded handoff oracle: **13,845 streams × 2 retained paths, zero failures** per parser invocation. Profiling tools: **42 checks, zero failures**.
- Explicit pragma fixture test passed at 14:25:00 UTC: **one file, three parser tokens, Clang accepted, zero mismatches**. Its source expands to 512 balanced pack events.
- The fixture benchmark completed `--passes 1 --only vector`. Its unconditional check compares both retained handoff rows before timing, exercising pragma-event capacity independently of parser-token capacity.
- Static review confirms the committed loader requires successful scalar initialization and both parser fatal fields equal NONE before treating outcomes as matching. Matching nonfatal syntax errors remain allowed. **Runtime allocation-fault injection was not performed.**

The experiment was rejected using the separately published [whole-driver campaign](https://github.com/buster14a/buster-performance/blob/d31c4d99d84a3b016f95fdb0bf2d2e8c2761d8f4/docs/measurements/handoff-335-2026-10-24/README.md): 2,520 measured status-zero children, 120 zero-status warmups and 18 fully cleaned accounting processes. No fused production option remains.

The earlier #336 main run **40099459804 was externally canceled**, according to the coordinator; its successful qualified PR gate is a separate result. Postmerge main run **40102546737 was pending** at this receipt snapshot. Final PR success, actual merge/main containment and postmerge main validation remain distinct facts.

`receipt.json` preserves metadata and step results. `native-job-120895445940.log` is the complete decoded job log. `SHA256SUMS` records the saved files' bytes.
