# PR 1736: pinned 95fb integration, 2026-11-08

This record compares buster base `95fb03f06e8b90cf23a435a12fb3181e1735bcf3` with the unchanged [PR 1736](https://github.com/buster14a/buster/pull/1736) experiment integrated on that base as local commit `1f84c0401` (tree `1de55a0bd6af057e9c5d688ba982ce2b7e3fc817`). The compressed patch has stable patch ID `02561f4b386eab6393397792dc9f4cdd92f746f3`, identical to the published experiment's delta. This is an integration measurement, not a measurement of the PR's published head. Source archive SHA-256 values are `799357d209aa444f2171c1886e2b29d2008886a65d23f4a104bc1f20b24cc893` for base and `3e29bb1db968f7d6bd6b5e3d6efb362e99869372688721790477d52e67776dbb` for candidate. Independent review matched fresh Git archives to the transferred copies and checked the patch ID. Main may advance after this pinned comparison.

## SQLite speedtest1: dynamic tagged counts

| Observed edge-tagged instructions | Base | Integration | Change |
| --- | ---: | ---: | ---: |
| T: stores | 151,079,195 | 150,358,045 | -0.48% |
| U: reloads | 163,581,243 | 163,001,970 | -0.35% |
| e: register moves | 154,445,926 | 147,308,283 | -4.62% |
| Combined | 469,106,364 | 460,668,298 | -1.80% |
| Combined in `sqlite3VdbeExec` | 253,868,126 | 246,851,702 | -2.76% |

The observed tagged traffic does not establish #1216's ≥50% edge-traffic target for SQLite. An independent agent reproduced the totals and mapping. This is not a paired native runtime measurement, a Lua result, a compiler-throughput result, or proof that all edge operations were tagged. The corresponding [77fd integration record](../dispatch-1736-77fd-integration-2026-11-08/README.md) and [earlier frozen record](../dispatch-1736-frozen-2026-11-08/README.md) preserve prior evidence and limits.

Each revision's ordinary/tagged programs were byte-identical: base SHA-256 `4baa4619afd4bcbe9d1daba6fd7f9b079727109ee2d2b5d1fab25bae376da166`, candidate `81d3e519d80ac5f6e0111d6a92df05b234607cc6f1da5de9263b1e29e087b287`. These both differ from their 77fd counterparts. Each revision reported 2,709 Tier 1 compiled functions and no fallbacks, including `sqlite3VdbeExec`. All 2,709 tag rows per side have unique names and agree with the outcomes' counts. Empty-input static fits produced no row-fit diagnostics; `tag-class-audit.txt` verifies that every T/U/e tag maps to the expected stack-store, stack-load or register-copy instruction shape. This does not prove complete edge-tag coverage; previous vector/mask/rematerialization fixture limits remain.

Both `--verify` runs passed `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`. The separate verification and Callgrind executions all returned zero and produced logical database dump SHA-256 `3be217cd86db20ce5bd81e09c143e4b581061f1a3ac5bee7ee3e21a4ffd408d4`. Each used a fresh tmpfs database and individual shared Benchpress lock grant. Verification is a separate run, so matching dumps support but cannot prove identical behavior at every step. Exact arguments, outputs and statuses are in `raw.tar.gz`.

Independent mapping checked the actual `main` addresses and instruction lengths in each Callgrind 3.25.1 capture, establishing bias `0x4000000`. No sampled PCs inside either executable were unmatched. Each capture had 1,986 `???` instruction costs at 36 PCs outside its ELF executable interval; those costs were excluded and their origin is unconfirmed. The raw per-instruction captures, tag streams, disassemblies and count joins are retained; the earlier record's `gap.c` reproduces the joins. The SQLite disassemblies derive from public-domain SQLite 3.53.2 and its `speedtest1.c`; source hashes, upstream notice and blessing appear in the frozen record.

`raw.tar.gz` SHA-256 is `cc2483481f9c7a02bb2a7b19abcc633c1c8fee5ccb66151105467ebfe5abcea5`. It includes compiler build logs, input checks, source pins, receipts, both raw captures and their joins, but excludes generated programs and database dumps (their hashes are retained). `current-inputs.sha256` is the shared baseline input manifest, checked before and after the SQLite compiles. Full environmental closure was not established: system libraries, metadata and failed path probes, `/proc` and `/sys` state and other inputs were not exhaustively bound across these compiles. Candidate's first ordinary compile wrapper was accidentally replaced while queued and exited with a shell parse error after producing an ELF; that attempt is retained as failed and was not used. A fresh, separate retry completed successfully and produced the measured candidate ELF.
