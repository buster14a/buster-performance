# One fewer preprocessing run for ignored enum warnings

PR #3251 reduces an ordinary compile of the frozen Buster compiler source from 680.091 to 621.766 ms on the locked single-core Ryzen 7 9700X. The median paired change was -8.511% and retired user instructions changed -9.791%. This fixes a duplicate preprocessing run caused by checking a silent enum warning during semantic checking. SQLite's default compilation already preprocesses once. The 35-cycle front target needs independent evidence. [Buster PR #3251](https://github.com/buster14a/buster/pull/3251) · [Experiment claim](https://github.com/buster14a/buster/issues/2850#issuecomment-7065419385)

## Where the second run came from

Two enum operands can belong to the ordinary named comparison group or the separately configurable anonymous enum group. Before selecting the group, the checker built the operands' canonical diagnostic spelling. Naming an anonymous type needed the preprocessor's expansion history, which was deferred on this compile. The GDB stack runs from `check_common_enum_mix` through type spelling, `pp_history_ensure` and a new `pp_preprocess_file`. The ordinary Buster default and `-Wall` compile emitted no warnings.

Four independent patches compare on source parent `b86eadcbd3d6c5cdf687f6b67b0281df2ac34034`. Testing just the two warning groups' policy retained the replay. Taking an ordinary file tag's direct location and reserving history for macro-generated tags also retained it. The declaration-class variant identified the first naming typedef or unnamed tag, using the declaration scan the eventual renderer requires. It removed the unwanted replay. The initial production head `89eeb323b2dd0b3105f63c3daf99df9503292d41` adds allocation handling and the pinned warning-policy regression. [Four patches](patches) · [Initial GDB, stage, PMU, ordinary objects and control receipts](raw/first-controls.tar.xz)

The final production head is `8a5dd554d9f2082dd685590e6c54f9fdff1fc2a2`, on the actual #3242 main merge `ec320d42bbe10f34fc62bf6d0072ba8898da2df0`. Its tree `dead56c03d526cb0e25b4fffda3f11175fec6f93` is identical to the independently staged native tree. The integrated patch SHA-256 is `b1f304f094addba481cf158a295afdd749eabb5f19c344dafd873bfcf3e18eef`. The retained tag location uses #3242's parser-source accessor. [Final source patch](patches/pp-enum-queue-integrated.patch) · [Final parent and candidate evidence](raw/final.tar.xz)

| Source, `-c` policy | Parent PP calls | Final PP calls |
| --- | ---: | ---: |
| Buster main, default and -Wall | 2 | 1 |
| SQLite, default | 1 | 1 |
| SQLite, -Wall | 2 | 2 |
| Lua lvm, default and -Wall | 1 | 1 |
| musl vfprintf, default and -Wall | 2 | 2 |

The Buster stage that paid for the replay was `check-program`, 123.195 → 66.427 ms on the final pair. Initial `preprocess` was 37.483 → 37.033 ms. External wait4 peak was 1,212,756 → 1,118,154 KiB. The separately timed b86 source as its own input kept one pass in both debug builds, where history is recorded from the start. With `-Wall -Wextra` it retained two passes and the exact same five printed warnings. Its ordinary wall then moved +0.171% (-1.295% to +0.783%). The inspection scripts retain the original regular `-c` ELF digests, normal, warning and debug call stacks. [Trace driver](scripts/pp-enum-trace.sh) · [Self-host controls](scripts/pp-enum-current.sh)

## End-to-end measurements

Each cell ran seven alternating two-arm rotations on native CPU 2 under the machine's shared lock. One `perf stat` process per arm included the compiler's complete huge-page-allowed `--time-stages -c` run. Separate ordinary-allocation compiles used two measured children after one warmup. Each paired ratio uses that round's median external time per arm. The parent and candidate emitted equal complete objects in every measured cell. Rows measure single translation units. The full-corpus object checks below compare output separately. [Absolute medians, PMU, stage times and seven-round ranges](raw/paired.tsv)

| Final parent → PR | External wall, ms | Paired external wall, range | User instructions | User + kernel cycles | Check-program wall |
| --- | ---: | ---: | ---: | ---: | ---: |
| Frozen Buster default | 680.091 → 621.766 | -8.511% (-8.729% to -8.132%) | -9.791% | -8.820% | -46.013% |
| Frozen Buster -Wall | 701.201 → 642.995 | -8.307% (-8.533% to -7.993%) | -9.593% | -8.144% | -40.566% |
| SQLite default | 117.284 → 116.915 | -0.044% (-0.797% to +0.422%) | +0.000% | +0.171% | -0.357% |
| Lua lvm default | 10.954 → 11.015 | -0.411% (-2.267% to +1.146%) | -0.001% | -4.760% | -0.195% |
| musl vfprintf default | 4.001 → 4.005 | +0.064% (-2.718% to +3.391%) | +0.001% | -3.011% | -1.120% |

The current b86 source and its initial production compiler were also measured against their own untouched parent. This independent source has five real warnings with both warning groups enabled.

| b86 source and compiler | External wall, ms | Paired external wall, range | User instructions | User + kernel cycles | Check-program wall |
| --- | ---: | ---: | ---: | ---: | ---: |
| Default | 679.451 → 623.149 | -8.331% (-8.664% to -8.163%) | -9.795% | -8.472% | -46.374% |
| -Wall -Wextra | 703.334 → 703.227 | +0.171% (-1.295% to +0.783%) | -0.070% | -0.508% | -0.861% |

## Semantic checks

The final native parent and candidate matched stdout, stderr, exit status and every available complete normal or debug ELF on 245 warning-policy/source combinations and 216 edge combinations. The fixtures cover unnamed and typedef-named enums expanded from macros, source order, qualified and aligned typedefs, GNU typeof, anonymous members, pragma push/pop, a filename containing the renderer's marker text, a system header, fatal warnings and rejected source. Two opposite pragma mappings were separately verified against Clang 23.1.4. Its native type-sugar and operand-diagnostic subsets recorded 4,227 and 1,585 checks with no failures. [Cases and replay commands](scripts)

Complete object manifests, diagnostic bytes and status matched for every one of the 1,372 sources (SQLite, all 34 Lua units, 1,336 musl units, and Buster main) under default and `-Wall -Wextra` options, as did four separate full-corpus syntax invocations per policy. The independent native shadow controls reproduced both two-difference attribute-argument fixtures and the five-difference conditional pointer fixture under default, extra warnings and all warnings on both original and final parents. The supplemental availability fixture emitted its expected warning with the same diagnostics and shadow summary on both final sources.

The initial Develop head ran 90,000 generated programs and 8,009 directed probes with no new findings. In each of three warning policies the tracked pile had 448 clean and 865 rejected programs. The 13,944 extracted snippets included 6,661 clean, 7,280 rejected and the same three pre-existing findings. The sweep found 92 of 93 warning IDs, with the separate fixture exercising the remaining availability ID. [Initial standing shadow suite](raw/initial-shadows.tar.xz)

All eight independent final-source checker shards and eight checker-driver shards passed against pinned Clang. [Final local shard logs](raw/final-normal-shards.tar.xz)
