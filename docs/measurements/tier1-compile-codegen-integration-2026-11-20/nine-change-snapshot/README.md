# Nine changes applied to current main

The baseline is Buster `5ef1800d267bb9dac1867beed1039925fea33f70`. The combined source tree is `a8dd87d9c648ec7e6d2e5e5bbc30170df1240e34`. Starting from the baseline, merge the heads for [#3117](https://github.com/buster14a/buster/pull/3117), [#3122](https://github.com/buster14a/buster/pull/3122), [#3124](https://github.com/buster14a/buster/pull/3124), [#3125](https://github.com/buster14a/buster/pull/3125) and [#3126](https://github.com/buster14a/buster/pull/3126), in that order. Their ancestors include the other four changes. The complete source and executable identities are in `source-heads.tsv`. Both were built by the repository’s pinned Clang 23.1.4 with the Release configuration and `BUSTER_HOST_ARCH=znver5`.

## Local compiler throughput

Eight alternating single-lane pairs on a Ryzen 9 7940HS, after warm-up, measured the complete compiler process. The local CPU was shared with other core-manager leases. Within-pair cycle ranges show the uncertainty.

| Input | Parent retired instructions | Combined retired instructions | Paired instruction change | Paired user-cycle change |
| --- | ---: | ---: | ---: | ---: |
| SQLite 3.53.2, Tier 1, release | 7,852,201,100.5 | 7,736,029,162 | −1.479% | −0.765% (−3.55% to +0.69%) |
| SQLite 3.53.2, Tier 1, `-O2 -g` | 19,103,719,706.5 | 15,674,014,815.5 | −17.953% | −10.473% (−10.77% to −9.42%) |
| Lua 5.4.8 VM, `-O2 -g` | 703,500,613 | 551,352,561.5 | −21.627% | −15.528% (−17.12% to −14.58%) |
| Lua 5.4.8 parser, `-O2 -g` | 321,581,103.5 | 306,310,360 | −4.749% | −5.056% (−7.62% to +0.50%) |

For SQLite `-O2 -g`, median compiler CPU time was 2,155.52 to 1,957.57 milliseconds. The paired reduction was 9.733%. The raw release and debug campaigns both include the release SQLite workload. They agree on retired instructions. The release campaign had mixed cycle signs and the debug campaign’s release control showed a 1.636% paired reduction. Full per-pair ranges, output hashes and the Tier 0 control are included. The shared Ryzen 7 9700X is a separate qualification.

## Independent applications and generated programs

The 220-program c-testsuite completed on both compilers. Both compiled all 430 reported functions with Tier 1. Across the 380 functions comparable for size, code fell from 62,350 to 62,298 bytes. Total executable sections fell from 63,662 to 63,598 bytes. Clang’s corresponding totals were 45,748 and 48,981 bytes. The existing informational code-size gate reported `fail` on both builds.

Classic [zlib 1.3.1](https://github.com/madler/zlib/tree/51b7f2abdade71cd9bb0e7a373ef2610ec6f9daf) produced 17 byte-identical objects between Buster variants. The upstream example passed on both and on Clang. The streaming test compared 75 combinations of level, strategy and input chunk size on each of four inputs, including empty, binary, repeating and SQLite source data. All 300 full compressed streams per compiler agreed with Clang, passed decompression in the tested library and in an independent zlib implementation, and matched both checksums. Gzip round-trips and compressed bytes also agreed. For the 15 library units, median paired compiler instructions fell 0.775% in release and 2.692% with debug information. Paired cycles fell 0.400% and 2.238%, respectively. All 30 release/debug unit outputs were byte-identical across compilers and measured runs.

The repository’s two-tier Csmith and YARPGen harness generated 48 programs with seeds 3040 through 3063, once per generator. Both compilers had identical per-seed outcomes and source hashes. All four executable outputs matched for 38 programs. Eight YARPGen sources exceeded the Clang reference’s small code model at link time and two Csmith reference programs exceeded the 30-second execution limit. The official campaign therefore reports failure on both variants. The ledger preserves the 10 failures and all accepted output hashes. The Csmith revision was `0cdc710315cfee9035e22ef4363ca479270d1934` and YARPGen’s was `1adb290f453505838f3aa33dc571f292b0c1810f`.

## Self-hosting, debugging information and generated programs

The control and combined compilers each compiled their own source twice. All 43 object files and the linked executable matched between stages 2 and 3 for each source tree. The combined compiler also compiled the baseline source through the same 43-unit driver. On that common source, linked machine-code text changed from 50,052,067 to 50,050,467 bytes. The three per-artifact ledgers include SHA-256 hashes. Every build also passed 14 smoke checks, five probes, ten object comparisons and ten probe executions.

Each compiler produced identical objects over one, two and four lanes for SQLite, the Lua parser and the Lua VM with both optimization settings and debug information. All 12 independent LLVM DWARF checks reported zero errors. SQLite produced 7,559 existing empty-DIE warnings, the VM 172 and the parser 49 under both compilers. The combined address/undefined-behavior/bounds build passed the inliner, emitter, pipeline, debug and debug-checker suites, including the external child-process checks.

A second YARPGen campaign fixed array dimensions at two and covered 96 consecutive seeds, 3040 through 3135. The two compilers agreed on every generated source, pass/fail and accepted output. Ninety-three cases passed each reference and both tiers. Seeds 3046, 3087 and 3130 exceeded the existing Tier 0 call argument limit on both compilers. They remain recorded as failures.
