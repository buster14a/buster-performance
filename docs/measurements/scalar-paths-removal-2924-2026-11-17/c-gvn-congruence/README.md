# Cyclic congruence and GVN throughput on the Ryzen 7 9700X

The original scalar pass searches for available expressions and cannot merge equivalent cyclic phis. The vector pass determines congruence classes across the whole function. This experiment keeps both passes and measures three policies on SQLite, Lua 5.4.8 and musl. The baseline was `0a2c3034c`. The candidate was `e7d78cb4b`. [Compiler issue #3433](https://github.com/buster14a/buster/issues/3433)

The candidate registers unresolved uses against their copy roots and freezes singleton classes between refinement rounds. A dominator-preorder interval determines where each representative can be reused. The shared rewrite skips CFG-thread construction when disabled. Output verification compares the actual rewritten graph before reusing dominator intervals and checks the rewritten operands.

## Pass measurements

Both revisions were built with the official Clang 23.1.4 in native Release. An experimental knob selects scalar or vector GVN at the pass entry. It records elapsed TSC ticks before printing each row. Runs used a single Tier 1 lane, CPU 2 and the 9700X exclusive lock. Three rounds alternate scalar/vector order. Each cell divides the sum of candidate-vector per-call medians by the corresponding comparison sum. Sizes count input IR instructions in the comparison build.

| Driver configuration | Comparison | Calls per round | Overall | 0–15 | 16–63 | 64–255 | 256–1023 | 1024+ |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Default | Original vector | 40 | .762 | — | .750 | .776 | .715 | .765 |
| Default | Original scalar | 40 | .888 | — | .803 | .940 | .816 | .893 |
| Default | Candidate scalar | 40 | 1.046 | — | 1.038 | 1.146 | 1.028 | 1.044 |
| All passes | Original vector | 16,654 | .676 | .709 | .671 | .672 | .676 | .677 |
| All passes | Original scalar | 16,654 | .830 | .783 | .762 | .802 | .836 | .858 |
| All passes | Candidate scalar | 16,654 | 1.200 | 1.031 | 1.111 | 1.189 | 1.220 | 1.216 |
| Pressure numbering | Original vector | 6,742 | .684 | .672 | .661 | .667 | .681 | .698 |
| Pressure numbering | Original scalar | 6,742 | .864 | .763 | .754 | .801 | .857 | .924 |
| Pressure numbering | Candidate scalar | 6,742 | 1.214 | 1.034 | 1.117 | 1.191 | 1.234 | 1.235 |

Calls are paired by corpus and invocation order. Both vector revisions received identical input sizes at every call. Earlier scalar/vector optimizations changed downstream input lengths or block counts for 509 calls with all passes and 305 with pressure numbering. The table includes every call. No default-policy call in this corpus had fewer than 16 instructions. [Raw logs](function-logs.tar.xz) · [Comparison script](compare.py)

The candidate vector and original vector produced byte-identical objects for all 1,371 inputs in each of the three configurations. The scalar walk gains from shared preparation, rewriting and verification improvements. It remains faster in the candidate build. [Object comparison counts](object-counts.txt)

## Whole compiler

Uninstrumented builds of the two commits ran three locked AB rounds per corpus and configuration. Each round used three repeats for each of baseline, candidate and a second copy of baseline. Each cell below gives the range of candidate changes in median user cycles. The baseline control ranged from −0.06% to +0.26% across the 27 rounds. All driver processes exited successfully.

| Tier 1 policy | SQLite | Lua | musl |
| --- | ---: | ---: | ---: |
| Default | −0.99% to −0.89% | −0.54% to −0.41% | −0.65% to −0.26% |
| All passes | −5.85% to −5.69% | −5.05% to −4.90% | −2.80% to −2.73% |
| Pressure numbering | −4.47% to −4.18% | −3.43% to −3.37% | −1.67% to −1.56% |

At the candidate revision, the standard 21-sample GVN fixtures measured 3641 vector and 3907 scalar TSC ticks on the small DAG, and 284012 vector and 297811 scalar on the large DAG. On the cyclic phi fixture the vector pass took 4225 ticks and reduced 15 instructions to 11. The scalar pass took 3438 ticks and kept all 15. The official GVN, rewrite, LICM and SIMD suites passed. [Raw driver, fixture and test logs](driver-logs.tar.xz)

## Reproduction

For each revision, apply `python3 instrument.py` from the root of a clean compiler checkout and build with `./build.sh --config Release` under the 9700X lock. Put the executable in `GVN_RUN_DIR` under the name `base` or `head9`. Set `GVN_CORPUS` to the pinned SQLite/musl corpus root and `GVN_LUA` to the Lua source directory. Set the lock owner, title and link for your run. Run `corpus.sh BUILD MODE GROUP PATH ROUND` for each combination of `default/all/numbering`, `sqlite/lua/musl`, `scalar/vector` and rounds 1 through 3. The original run reversed scalar/vector order in round 2. [Instrumentation](instrument.py) · [Corpus command](corpus.sh)

To replay the published comparison, unpack the log archive and run `python3 compare.py logs all base:scalar head9:vector`. Each tuple gives the number of calls, the cycle ratio and the number whose input shape changed.

## Dominator-preorder follow-up

Revision `d7fb8eb93` assigns permanent classes to distinct impure leaves in batches, stages substitutions during the dominator-preorder walk in fully reachable phi-free functions, and uses established operand classes when initializing a cyclic partition. Staged substitutions are published after numbering succeeds. All GVN, SIMD, LICM and rewrite checks passed at this revision. The preceding `e7d78cb4b` revision also passed 2,195,152 GVN checks under ASan and UBSan. [Compiler branch](https://github.com/buster14a/buster/tree/d7fb8eb93283d17715dc8e9ddd5608a9d202e8c8)

| Driver configuration | Comparison | Overall | 0–15 | 16–63 | 64–255 | 256–1023 | 1024+ |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Default | Original vector | .744 | — | .753 | .763 | .695 | .746 |
| Default | Original scalar | .867 | — | .806 | .925 | .793 | .872 |
| Default | Same-build scalar | 1.031 | — | 1.042 | 1.143 | 1.006 | 1.028 |
| Default | Prior candidate vector | .976 | — | 1.004 | .984 | .971 | .976 |
| All passes | Original vector | .650 | .626 | .624 | .636 | .652 | .662 |
| All passes | Original scalar | .798 | .692 | .709 | .759 | .806 | .839 |
| All passes | Same-build scalar | 1.163 | .953 | 1.044 | 1.132 | 1.183 | 1.199 |
| All passes | Prior candidate vector | .962 | .883 | .930 | .947 | .964 | .978 |
| Pressure | Original vector | .665 | .606 | .630 | .643 | .664 | .684 |
| Pressure | Original scalar | .839 | .688 | .718 | .772 | .835 | .905 |
| Pressure | Same-build scalar | 1.189 | .956 | 1.066 | 1.152 | 1.208 | 1.223 |
| Pressure | Prior candidate vector | .972 | .901 | .952 | .964 | .975 | .980 |

The candidate vector generated byte-identical objects to the original vector for all 1,371 files in each configuration. With all passes enabled it used 35.0% fewer pass ticks than the original vector and 20.2% fewer than the original scalar. It used 16.3% more than the scalar in its own build. The vector path was faster in the 0–15-instruction bin for both all-passes and pressure runs.

All 27 uninstrumented driver rounds took fewer median user cycles than main. The all-pass changes were −6.24% to −6.19% on SQLite, −5.36% to −5.20% on Lua and −3.05% to −2.88% on musl. Default changes were −1.46% to −1.06%, −0.70% to −0.54% and −0.57% to −0.53% respectively. To replay the pass table, unpack the original function logs and the follow-up archive in the same directory, then use `head13:vector` as the candidate. [Pass and driver runs](preorder-logs.tar.xz)
