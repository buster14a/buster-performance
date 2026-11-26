# Round 16: #3577 after merging main a508b743b (#3596) and 5ce76f08c (#3621)

[buster#3597](https://github.com/buster14a/buster/pull/3597)'s head 0b15487ea (main a508b743b and 5ce76f08c merged into
the branch) against main 5ce76f08c on the 9700X, `benchpress`. `bp-m11.sh` built both trees as the 9700X job builds
(`BUSTER_HOST_ARCH=znver5`, Release) under the host lock, each build a hold of its own, then in one hold ran the job's
instructions' baseline step on both and `measure-compile`'s 41 interleaved runs of the head against main, on the frozen
corpus's `sqlite3.c` (sha256 checked by the script). `bp-m11.out` is the script's whole output.

| | wall | user cycles | user instructions |
| --- | --- | --- | --- |
| main 5ce76f08c | 15.285 ms | 75.5 M | 195.8 M |
| head 0b15487ea | 16.656 ms (+9.0%) | 83.8 M (+11.0%) | 218.8 M (+11.7%) |

The baseline step: main reads 195,788,804 instructions, -0.494% of main's `tools/ci/compile-instructions.txt`
(196,761,445; the band is 0.5%); the head reads 218,808,126, which the PR's file now holds (ce7633e91).

Against round 13 (main 8e4d32879: 196.8 M; the head c7a26809d: 219.3 M) #3596 took 1.0 M instructions out of main's
compile and 0.5 M out of the head's. The checks' cost is 23.0 M instructions against 22.5 M then.

The two objects differ in .text only, at sqlite's `AtomicLoad`/`AtomicStore` sites: main's direct path answers
`__has_extension(c_atomic)` 0 where its full pipeline answers 1, so it compiles sqlite's plain-store branch; the head
answers as the full pipeline does. The head's object is byte-identical to the branch's before the merges.
