# Exact-parent qualification for #3242 and #3243

Both PRs compare independently with Buster main `232da75f980c7ff9f01ffa3d849d655970bbed78`. The untouched frozen self-hosting source is that parent. Production #3242 is `e3b9626b572f8747acf8c93db8795c0b907f6eb3`, and production #3243 is `7cf585272148ef824595097eaf00e1bd54644f99`. The native build records include the binary hashes, parent and exact patch digest. [Original pilots and controls](HANDOFF.md)

## Seven one-core SQLite rounds

Each round executes ABBA, reversed on odd rounds. CPU 2 on the locked Ryzen 7 9700X runs the seven-pass consume kernels, one fresh huge-allowed `--time-stages -c` process with userspace PMU, and external ordinary and huge-allowed full compiles (one warmup and two measured children per arm per position). Each paired difference uses the median of all samples in its arm in the round. No outliers were removed. [Complete paired metrics](native/production-pairs.txt)

| Operation | Exact parent | PR | Paired change (range) |
| --- | ---: | ---: | ---: |
| #3242 fresh parse, ms | 7.126 | 7.000 | −1.643% (−3.698% to +0.154%) |
| #3242 fresh check-input, ms | 42.876 | 42.402 | −1.263% (−1.578% to −0.228%) |
| #3242 ordinary external wall, ms | 117.597 | 116.856 | −0.577% (−12.322% to −0.016%) |
| #3242 huge-allowed external wall, ms | 117.391 | 116.922 | −0.607% (−0.955% to −0.230%) |
| #3243 vector parse, cycles/token | 29.675 | 28.703 | −3.465% (−3.855% to −2.908%) |
| #3243 fresh parse, ms | 7.181 | 6.851 | −4.228% (−5.570% to +0.987%) |
| #3243 fresh check-input, ms | 42.950 | 42.891 | −0.147% (−0.544% to +2.759%) |
| #3243 ordinary external wall, ms | 117.452 | 117.274 | −0.001% (−0.644% to +0.237%) |
| #3243 huge-allowed external wall, ms | 117.352 | 117.444 | +0.074% (−0.235% to +0.881%) |

#3242’s large ordinary-page favorable outlier remains in the distribution; all seven huge-allowed pairs also favor the candidate. The complete user-instruction change was −0.030% for #3242 and +0.017% for #3243. #3243's repeatable gain is in its parser kernel. Complete wall spans both signs. [#3242 native raw](native/srcprod.tar.xz) · [#3243 native raw](native/bracketprod.tar.xz)

## Exact compiler outputs and shadow checks

For both heads the independently built exact-parent and candidate front witnesses produced 478,616,166 identical initialized bytes across all 1,372 TUs. Every original and candidate SHA pair and per-file manifest matched, including PP flags, kinds, values, locations and history, parser sources and pragmas, accepted/refused rows and traversal. The Clang-backed parser, 41 targeted translation units and the ordinary corpus command suite passed. The suite compared frozen `-E` marker text, full corpus syntax warning diagnostics/status and complete objects for the four representatives under default and `-Wall -Wextra`. Each coverage archive records the literal program source or full command. #3242 also passed six exact-head checker suites exercising attested views, diagnostics, requests, selection, overloads and embeds. #3243 also compared the 20,520 raw malformed/balanced K1 inputs against this parent.

Each Develop build passed 8,009 directed shadow probes and the six 15,000-program generated seeds (90,000 programs for each PR, zero findings). Across 1,313 tracked and 13,943 extracted programs in each of three warning policies, the tracked pile had 448 clean and 865 rejected. The extracted pile had 6,660 clean, 7,280 rejected and three findings per policy. The exact parent reproduces all three existing lean front differences: two attribute-argument fixtures each report two differences, and the existing conditional-pointer initializer fixture reports five. Their statuses and nonzero keys match both candidates for all three policies.

The stock warnings campaign found a trigger for 92 of 93 current IDs. The additional `__builtin_available(macos 1.2_3, *)` fixture produces the actual `-Wavailability` warning on the default Linux target. Its full diagnostics match between parent and both candidates under all three policies, with no unsound shadow take. [#3242 full shadow logs](native/srcprod-shadows.tar.xz) · [#3243 full shadow logs](native/bracketprod-shadows.tar.xz) · [Focused parent, candidate and availability replay](scripts/pp-parser-focused-controls.sh)
