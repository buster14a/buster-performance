# Skipping complete DWARF source lifetimes

Part of #2542, stacked on #3141. When the machine-record cursor crosses every reachable source boundary of a local, the local is outside its source region at both endpoints. The debug-location walk can skip the corresponding queue entry. The spare half of the existing sort allocation records the last boundary at each local’s first occurrence. Locals already queued through other changes retain their entries.

In SQLite, 1,536,140 previously unqueued candidates disappeared from 14,168,052 boundary visits. In the Lua VM, 555,331 disappeared from 3,968,209 visits. With one lane on the local Ryzen 9 7940HS, debug Lua VM compilation retired 8.067% fewer instructions and took 4.750% fewer cycles across eight pairs. For debug SQLite at `-O2`, the reductions were 0.691% and 1.212%. The release SQLite instruction count was stable.

The fixture checks all 1,156 ordered cursor pairs, including forward and backward crossings with an already queued local. The debug suite passed 4,070 checks. All 1,336 musl debug objects matched the parent byte for byte. SQLite and Lua objects and linked Lua binaries matched at both optimization levels, and the resulting interpreters agreed with Clang on five programs.

The [compiler revisions](revisions.txt), [queue census](queue-census.tsv), [per-process observations](processes.tsv), [paired statistics](summary.txt), [SQLite and Lua object identities](application-objects.tsv), [musl hashes](musl-objects.tsv.gz) and [debug test output](debug.log) cover the exact isolated change. The [harness](harness/) includes the census instrumentation and corpus recipes. The non-debug SQLite row is a control.
