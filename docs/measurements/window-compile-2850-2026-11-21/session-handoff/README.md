# Handoff for Buster #2850

The incoming owner has the issue, open pull requests, candidate decisions and the target machine. The requested outcome remains a fresh, single-core ordinary compile of the frozen SQLite 3.53.2 amalgamation in **9.507037 ms**. The last protected change in this session measured **112.328 ms**, or **84.64 MB/s**, at its reviewed head. The gap is about 11.8×. There is no 1 GB/s whole-compiler result in these records. [Incoming owner's claim](https://github.com/buster14a/buster/issues/2850#issuecomment-7077096460) · [Released claims](https://github.com/buster14a/buster/issues/2850#issuecomment-7077105081) · [Protected result and target receipts](../e73c2723a/).

## Pull requests at transfer

| PR | Exact head | Evidence and action transferred |
| --- | --- | --- |
| [#3268](https://github.com/buster14a/buster/pull/3268) | `b76d5d237` | Ready. All four 9700X controls completed against `40ae34f9d`. Median paired wall changes were SQLite −0.727 ms, Buster −0.924 ms, Lua −0.032 ms and musl +0.092 ms. The patch on the machine exactly matches the reviewed Git diff. The incoming owner has current-main integration. [All metrics](pr-3268-target.tsv) · [PR handoff](https://github.com/buster14a/buster/pull/3268#issuecomment-7077162638). |
| [#3270](https://github.com/buster14a/buster/pull/3270) | `6835c375c` | Draft. Hosted head checks and all eight local shards passed, 850,927 assertions. The underlying storage change matched 6,860 source/policy results including 863 expected errors. SQLite incurred 902 fewer minor faults in each of three local PMU pairs. The 9700X comparison had been staged and had no result at transfer. The incoming owner has measurement and disposition. [Local measurements](../053372796/) · [Exact-head tests](runs/ordinary-selected-operands-study.tar.gz) · [Target harness](runs/selected-operand-target.tar.gz). |
| [#3226](https://github.com/buster14a/buster/pull/3226) | `d44ba035e` | Conflicting draft. The same-binary 9700X control cost an additional 6.9352 cycles/token. All 92 objects and diagnostics matched. The PR body links its source and separate timing series. The incoming owner has disposition. |
| [#3269](https://github.com/buster14a/buster/pull/3269) | `e73c2723a` | Merged through the protected queue at `d541430bf`. Buster saved 9.142 ms and 400.723 million user instructions in the median pair. SQLite saved 0.139 ms in the median pair. [Merge and exact-head results](https://github.com/buster14a/buster/issues/2850#issuecomment-7074491571). |

The incoming owner also identified five branches without open PRs. Their recorded heads are `7e5a53d39` (packed comma contexts), `3482b7310` (flat window), `46934f02a` (binding linkage cache), `ce67967f5` (demand-selected operands) and `1c3dd326d` (packed value chains). Search [the source index](source-index.tsv) by SHA to restore each one. The incoming owner's overlap checks and disposition are pending. [Branch inventory and planned disposition](https://github.com/buster14a/buster/issues/2850#issuecomment-7077096460).

The original record-layout experiment passed Step 0. Step 1 reproduced the ordinary type results. SQLite leaf facts cost 5.3 cycles and lookups cost 39.9 cycles apiece, past the stated 20-cycle refutation line. The owner authorized other designs in pursuit of the end-to-end target. [Step 0](https://github.com/buster14a/buster/issues/2850#issuecomment-6898510406) · [Step 1](https://github.com/buster14a/buster/issues/2850#issuecomment-6900508040).

## Where the source-ordered design stands

- **End-to-end control.** On the 9700X, the complete source-owned driver at `966a95df3` emitted the correct SQLite object while retiring the persistent expression graph. It took 129.537 ms against 114.219 ms ordinary and added 231.192 million user instructions. The latest fast ordinary baseline and this older paired experiment have different revisions. [Paired samples, profiles and linked SQLite runs](../966a95df3/).
- **Direct source to machine code.** At `30daf8d67` the physical source reader could assemble call-containing bodies while preprocessing still had an active source context. An intervention on SQLite’s `subjournalPageIfRequired` changed two early call targets. Exactly six bytes changed in two ELF relocation addends, and the linked test produced one modified journal record in place of zero. Eight balanced local whole-compile groups still added 10.586 ms on SQLite. The sibling direct-encoder experiment at `2bda365dd` reports 32 directly owned SQLite wrappers with 1,183 bytes, 186 ordinary graph rows and 160 typed rows removed. Read the revision receipt alongside each table. [Calls, intervention and timing](runs/live-native-calls-study.tar.gz) · [Direct encoder](runs/live-direct-call-encoder-study.tar.gz).
- **Checked prefix reuse.** The ordinary backend accepted pre-EOF machine code for 1,614 SQLite functions using full typed-body and relocation comparison. The sealed-call successor at `919164454` also skipped final expression graphs for 22 SQLite and three Buster bodies at checkpoint 24. Its small external-call oracle exercises one and two call fields, late rename and weak declarations, independent Clang linkage, and exact ordinary objects. The local bounded-graph variant accepted 1,864 SQLite functions with a 128-action residual cap, but added 63.16 ms against its nested-expression control. The scoped-metadata follow-up and its observations are included. [Ordinary reuse](../158e31618/) · [Sealed calls](runs/sealed-native-calls-study.tar.gz) · [Bounded residuals](runs/source-bounded-roots-study.tar.gz) · [Scoped metadata](runs/source-scoped-metadata-study.tar.gz).
- **Declarations and types.** At checkpoint 24 the two-bit binding producer retained 93,914 transitions and supplied 40,058 final SQLite name/type answers, using 22,576 extra evidence bytes. Buster retained 109,758 transitions and 12,743 answers. The ordinary resolver still executes the declarations. The attempted persistent-TypeTable continuation at `a4449c4e1` produced matching type/tag/member/parameter counts but **declined adoption on both inputs**. Its ordinary fallback emitted both expected objects. The independent boundary capture found one tag name and four member names differing in each input at the matching cursor. The next discriminating test is to compare identifier spellings across the private and live intern tables before considering an ID remap. Later completions can independently change genuine tag layout. [Binding qualification](runs/integrated-event-use-masks-study.tar.gz) · [Type continuation](runs/persistent-source-types-study.tar.gz) · [First differences and capture scripts](runs/prefix-type-state-study.tar.gz).
- **Frontend budget.** The physical grammar had populated 709,161 of 716,136 SQLite token rows before EOF. The supplied-macro-and-header oracle reached 3.108 ms for preprocessing with work supplied externally. Actual conditional batching measured 11.067 ms versus 9.265 ms ordinary on the 9700X. The actual fresh-header producer measured 9.570 ms versus 9.181 ms. Each pair of figures is the median of six fresh PP measurements per arm. Neither forms an end-to-end qualification. [Parser milestone](https://github.com/buster14a/buster/issues/2850#issuecomment-7073504797) · [Frontend tools and controls](runs/pp-directive-frontier.tar.gz) · [Target receipts](target-receipts.tar.gz).
- **Memory and incomplete work.** The source ELF writer was neutral on ordinary SQLite, +0.081 ms, four of eight groups lower. Fresh memory-owner traces remain available. A pure deletion of the expression-head fill crashed under poisoned storage. Its classifier-based successor passed four independently poisoned SQLite/Buster policy runs. The compact semantic operand experiment is an uncommitted overlay at the protected baseline with a build and census. None of these has qualified the throughput target. [Writer](https://github.com/buster14a/buster-performance/commit/02fc8fbb25623940709840a285d7ad91fc6ac203) · [Page owners](runs/fresh-arena-owners-study.tar.gz) · [Failed control](runs/postorder-value-init-study.tar.gz) · [Repair](runs/classified-value-init-study.tar.gz) · [Compact operand census](runs/direct-compact-semantic-study.tar.gz).

## Restore the code

Choose a named snapshot from the [frontier guide](frontiers.tsv). The [full source index](source-index.tsv) names 699 snapshots across 558 distinct commits, including predecessors, failed variants and reference controls. The Git bundle carries the commits beyond public main history. The [overlay index](overlays.tsv) records staged changes, unstaged changes and a new fixture separately. Use `--overlay` when restoring the exact working state of an unfinished experiment. The [frontier patches](frontier-patches/) are directly readable diffs for committed heads against their public merge bases.

Run from a fresh working directory on a vector-capable Linux x86-64 machine. The Buster build uses its repository-pinned toolchain.

```sh
git clone --filter=blob:none --sparse https://github.com/buster14a/buster-performance.git evidence
packet=docs/measurements/window-compile-2850-2026-11-21/session-handoff
git -C evidence sparse-checkout set "$packet"
git clone https://github.com/buster14a/buster.git buster
python3 "evidence/$packet/restore.py" buster sealed-native-calls candidate
git -C buster worktree add --detach baseline 40ae34f9d77afc42face58eff3338b7b1d1ba469
(cd candidate && ./build.sh --config Develop --target compiler --jobs 1)
(cd buster/baseline && ./build.sh --config Develop --target compiler --jobs 1)
curl -fLO https://www.sqlite.org/2026/sqlite-amalgamation-3530200.zip
unzip -q sqlite-amalgamation-3530200.zip
python3 "evidence/$packet/reproduce-sqlite.py" buster/baseline/build/compiler candidate/build/compiler sqlite-amalgamation-3530200 sealed-calls --audit-file sealed.log
```

The SQLite runner checks the 9,507,037-byte source hash, starts independent compiler processes and verifies full objects, stdout and stderr. The local recorded object hash is `2238999c41e256cc9c14ddbe21e379f0b3c09df25fb642b056e18b8a7ea773a0`. Toolchain, system headers and path spelling can affect emitted bytes. Compare the two arms in the same environment. To investigate the type handoff, select `persistent-source-types` and use the `continue-types` mode. For direct calls select `live-native-calls-measured` and use `direct-calls`. The original Buster self-input source snapshot is `84a7d3d76891d6c393497e62e6aff38f2b162fc2`. The original include flags, predefines and directory spellings are in the [shared harness inputs](runs/common.tar.gz).

## Reproduce the target comparison

The 9700X runner used CPU 2, a fresh process per compile and a distinct shared-machine lease per build or invocation. The original working directory on `benchpress` is `~/buster-fast-bench/2850-codex-step2`. The incoming owner controls when measurements start. Extract [the target receipts](target-receipts.tar.gz) in a new directory to inspect them or reproduce the #3268 summary:

```sh
mkdir target
tar xzf "evidence/$packet/target-receipts.tar.gz" -C target
python3 "evidence/$packet/summarize-3268.py" target reproduced-3268.tsv
cmp reproduced-3268.tsv "evidence/$packet/pr-3268-target.tsv"
```

The staged `selected3270.sh` runner tests baseline `40ae34f9d` and head `6835c375c`. It builds the candidate, checks objects and diagnostic streams, runs five balanced four-process wall groups per source and takes three separate counter pairs. On the target host, fetch the PR's head into the benchmark's `src` clone if required. From the established benchmark directory use `bash selected3270.sh`. Results go under `results/selected3270-paired/{sqlite,main}`. A later rebase requires recording the new revisions and updating the pinned script.

The [study index](studies.tsv) lists 67 local archives. The [receipt index](receipt-index.tsv) records the digest of every indexed file. The [additional packet index](additional-records.tsv) describes 595 previously unpublished or locally updated measurement and fixture files. The prepared records preserve partial and negative experiments as well as passing ones. Historical scripts can include paths from the original workspace and benchmark host. The restore helper and SQLite comparison above work from a fresh directory. See [recovery verification](recovery-verification.txt).
