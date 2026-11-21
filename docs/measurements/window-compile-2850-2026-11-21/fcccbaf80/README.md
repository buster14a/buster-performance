# Constant operands with the ordinary expression timing disabled

The integrated [PR #3247](https://github.com/buster14a/buster/pull/3247) candidate passes the common visit counter to regular and constant windows. An ordinary command receives a null counter. The [three-way four-corpus comparison](four-corpus/README.md) compares the accepted #3252 mainline compiler and the two modes of the [candidate](implementation.patch) on SQLite, all 34 Lua files, all 1,336 musl files and the Buster compiler.

All 12 [contiguous and remapped source tests](regression-object-sha256.txt) emitted identical complete debug objects, including ordinary and profiled commands and both the baseline and candidate. Both positive source forms admitted four roots and removed ten nodes. [Native checker assertions](checker-shard.txt), the [per-source counts](admission-counts.txt) and [local full source and semantic qualification](correctness/README.md) complement the ordinary compile wall and PMU measurements.
