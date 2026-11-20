# Expired source regions in the Tier 1 debug-location proof

[PR #3133](https://github.com/buster14a/buster/pull/3133) at `27e6e86d68dabf69e3e48518967323e8b64bc521` was compared to [#3129](https://github.com/buster14a/buster/pull/3129) at `0c8766eea35c44bd7f3638e2f05dd738ca95fc0c`.

Tier 1 can rule out a debug location immediately if a local has no source regions or the entry is past its final half-open interval. The ordered lookup still checks the source interval, machine block and machine interval for any possible match. The change needs no new table or per-local scratch.

Profiling the Lua VM and SQLite debug builds found 371,446 and 1,335,535 region queries respectively. Of these, 355,840 and 955,346 were already past the local’s last source interval. The old lookups performed 541,214 and 2,600,009 binary-search probes in total.

With eight interleaved local Ryzen 9 7940HS pairs, Lua VM debug compilation retired 1.626% fewer instructions and SQLite debug compilation at both optimization settings retired 0.138% fewer. Lua’s paired cycle median fell 0.614%, with individual pairs on both sides of zero. SQLite cycle results were mixed. Lua parser and the SQLite release control had no measurable instruction change. Direct Ryzen 7 9700X confirmation remains open.

All 1,336 frozen musl debug objects and all 70 SQLite and Lua objects matched byte for byte at the tested settings. Two linked Lua executables and ten script outputs matched. The debugger and LLVM cross-check passed 4,065 checks, including a new fixture for a local with no regions, the inclusive start and exclusive end, the maximum source entry and a different machine block.

Part of #2542, stacked on #3129.

The [compiler counters](compiler-processes.tsv) include a warm-up and eight measured pairs per workload, with per-run SHA-256 digests. The [summary](local-pairs.txt) reports median paired percentages and their observed range. The final fixture-only rebuild adds one debugger assertion. The [debugger transcript](debugger.txt) comes from that final build. Every parent and candidate [musl object](musl-debug-objects.tsv.gz) matched, as did the [application objects and binaries](application-digests.tsv).

[Query totals](queries.tsv) come from a separately instrumented parent, compiled with one lane. It reproduced the ordinary parent's objects for all three profiled inputs. The three compressed per-function tables use the same field order after their leading `region-query` tag. Insertion ranks are recorded independently for each local within one function. Beyond-last counts exclude locals with zero source windows.
