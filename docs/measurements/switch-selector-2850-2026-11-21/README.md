# Switch selector types in expression summaries

[Buster PR 3217](https://github.com/buster14a/buster/pull/3217) keeps a taken switch selector's type before integer promotion. The original code was aa7a6abb0 on fdde7b975. The integrated head 05dbff5f9 includes the diagnostic-hole changes in PR 3213 and is compared with its parent cb920fe57.

## Correctness

The focused fixture has nine selectors, including six enums. Corrupting a saved type triggers the comparison for each of the nine. The independent 75-function matrix produced identical diagnostics to Clang 23.1.4 in GNU17 and C23. The exact-head checker part 5 passed 210,478 checks and checker-driver part 4 passed 14,966. SQLite, Lua, musl and the Buster compiler source passed with default warnings and with `-Wall -Wextra`. They compared respectively 70, 85, 115 and 27 selectors, including 0, 20, 3 and 6 enums. [Native transcript](shadow/05dbff5f9-native.txt) and [matrix](shadow/selector-matrix.c).

The integrated source-file sweep includes 1,247 repository files and 13,888 programs extracted from 558 compiler test files. Each warning policy, default, `-Wall -Wextra` and `-Weverything -Wno-c++-compat`, had 417 clean repository files, 829 rejected, and one existing window summary discrepancy. All three policies had 6,638 clean and 7,250 rejected inline programs. All 8,009 probes passed. Of the 93 warning triggers in the standing catalog, 92 had a source, and every comparison that ran matched. The six deterministic randomized seeds had 90,000 programs altogether, 73,203 accepted, 16,797 rejected, and no differences. [Integrated campaign](shadow/05dbff5f9-campaign.txt).

The existing discrepancy is line 8 of `tests/checker/sources/pointer-constant-equality.c`, a conditional expression comparing a string address to zero. The program has two references and the shadow retains three. Both cb920fe57 and 05dbff5f9 reproduce this under all three warning policies. Its truth, fold and effects match, and the source contains no switch. The other committed campaign transcripts show the pre-integration state for both original SHAs. [Paired status](shadow/pointer-equality-status.txt).

## Locked Ryzen 7 9700X

Every measured process ran on CPU 2, under the shared benchmark lock, using the frozen SQLite, Lua and musl inputs from the standing Step 2 record. Both release builds were built for Zen 5. Each of seven rounds used fresh executable copies for four invocations in baseline, head, head, baseline order. Percentages are the median of the seven within-round changes from the two baseline readings to the two head readings. All 112 commands per comparison succeeded. Within each comparison all 28 SQLite objects agreed byte-for-byte. The archives include individual perf counter files, completion records and object digests.

| Full process cost | Original head vs parent, cycles | Integrated head vs parent, cycles |
| --- | ---: | ---: |
| SQLite shadow | −0.44% | −0.24% |
| Lua shadow | −0.35% | −0.03% |
| musl shadow | +0.05% | +0.06% |
| SQLite default compile | +21.24% | +13.10% |

These are full-process cycle counts. The selector's saved word and its comparison run outside the existing summary sweep timers. The default SQLite compile had two distinct instruction-count modes. A separate counter run used the same executable path and output path for both builds and alternated the ABBA direction. Its 14 baseline processes and 13 of 14 candidate processes had about 1,343M user instructions, 35–42M kernel instructions and 5,756 minor faults. The remaining candidate process also retired 1,343M user instructions, but recorded 225M kernel instructions and 60,032 minor faults. Its system cost accounted for the elevated instruction count. The compiler chooses its arena page policy from machine load in `arena_page_policy`. Controlled page-size runs and stage reporting distinguish this from a change in the switch warning pass's executed work.

A further 56 exact-head compiles fixed each process's page policy through `BUSTER_HUGE_PAGES`. For each policy there were seven rounds with two invocations per source revision. All used one lane, had zero major faults and zero migrations, and produced the same object. With transparent huge pages enabled, both revisions had about 5,763 minor faults and 39M kernel instructions. The head's median paired change was −0.08% for cycles and −0.010% for instructions. With huge pages disabled, both had about 60,044 minor faults and 227M kernel instructions. The changes were +0.27% for cycles and −0.004% for instructions. Within each fixed policy the user-instruction change was below 0.001%. [Per-process counters, stage reports and object digests](9700x/fixed-page-policy.tar.gz).

The direct host-load control toggled the startup heuristic using `BUSTER_TEST_HOST_BUSY`. Forced idle gave system huge pages for both builds, with about 5,763 faults and a median paired cycle change of −0.15%. Forced busy gave base pages for the arenas in both builds, about 60,045 faults, and a +0.07% change in cycles. All 32 objects matched. Separately, 80 stage-instrumented invocations exercised automatic admission, one explicit lane, one lane with attestation off, identical-binary A/A, and leader-only perf accounting. CPU 2 was the sole allowed CPU and `nproc` returned 1. Every run used one lane and recorded zero migrations. Within each series the median paired difference in user instructions stayed below 0.001%. High fault counts also occurred on unmodified baseline runs, including some for which the compiler reported the system policy. These runs establish parity at fixed page policy and show that either binary can incur the high system cost under the defaults. [Forced host-load samples](9700x/forced-host-load.tar.gz) and [lane, A/A and inheritance controls](9700x/lanes.tar.gz).

[Original counters](9700x/fdde7b975-aa7a6abb0.tar.gz), [integrated counters](9700x/cb920fe57-05dbff5f9.tar.gz) and [source and executable hashes](9700x/revisions.txt).
