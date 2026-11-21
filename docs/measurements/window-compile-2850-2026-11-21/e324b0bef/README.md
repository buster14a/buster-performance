# Block lifetime control markers and expression reference roots

The [source change in #3241](https://github.com/buster14a/buster/pull/3241) keeps control markers out of the expression reference set used to retain symbols. These two independent three-round groups measured full SQLite compilation on the same locked Ryzen 7 9700X. The [ordinary driver](ordinary/README.md) and [explicit Tier 1 driver](tier1/README.md) each compare the exact unmodified parent against the candidate.

The native [registered regression](fixture/lifetime-reference-roots.c) emitted named symbols `first`, `kept`, `live` and `second` with the [parent](fixture/prepbase232.nm). The [candidate](fixture/life3241.nm) emitted only `kept` and `live`. The [fixture command](fixture/lifetime-smoke.sh) used a fresh actual Tier 1 object at each revision.
