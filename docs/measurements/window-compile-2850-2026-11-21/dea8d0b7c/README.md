# Conditional initialization of expression-list tails

The compiler uses a sentinel in the head of each expression list. Each publisher of a nonempty head writes the last node and length alongside it. The candidate removes the initial four-byte tail fill per token and guards the optional numbering verifier’s length read with the head test. SQLite avoids 2,864,548 bytes of initial writes and Buster avoids 9,734,256. Across 1,372 real inputs, both images produced identical graphs (2,598,928 checked nodes and 184,584 arguments), ordinary diagnostics and ELF. Eight checker shards passed 848,405 checks and eight driver shards passed 211,028. [Graph receipts](graphs.tsv) · [Shard counts](shards.json) · [Source and individual receipts](source-and-receipts.tar.gz)

Seven alternating pairs each on locked 9700X CPU 2 retired fewer user instructions in all four workloads. The following are paired median changes for `dea8d0b7c` versus `b86eadcbd`. All four full-compile wall ranges and total-cycle ranges include both signs. [Full paired statistics](paired.json) · [Raw runs and complete object manifests](native-runs.tar.zst)

| Input | User instructions | Total cycles | Elapsed ms, median [min, max] |
| --- | ---: | ---: | ---: |
| SQLite | −456,921 | +132,327 | −0.189 [−0.390, +0.726] |
| Lua | −180,441 | −109,654 | −0.181 [−0.786, +0.636] |
| musl | −2,152,601 | −5,419,736 | +1.237 [−0.407, +4.988] |
| Buster | −2,242,239 | −3,784,899 | −1.497 [−4.514, +39.284] |

The additional instrumented reader lifetime study has one outstanding observation. A run that left reader scratch poisoned after the reader ended matched 452 of 456 cases. Four modes reported an uninitialized read in the later lowering body-opening map. Source inspection confirms that map writes only selected function openings and examines the previous contents when a declaration names an omitted body. Pristine and candidate builds without the instrumentation passed that fixture. The table above reports ordinary Release measurements.
