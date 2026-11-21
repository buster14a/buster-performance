# Pooled native tape storage and cached control lookup

Each pass ran the independent source-window semantic, diagnostic and native pipeline in the shadow driver. The measurements are invariant TSC readings around the named stages. A production compile includes additional work outside those intervals. All options used source masks and late native rows. The cached mode reads the two mutation-control environment fields once for the window. The pooled mode also allocates retained tape and entry storage by window. All three modes used the same native Release executable, SHA-256 `f120bea0f492e2fbd1c36d29944b0681b3df05e4d7270817ca0ee4f782da997f`, built by applying the [exact patch](experiment.patch) to `84a7d3d76891d6c393497e62e6aff38f2b162fc2`.

On the locked Ryzen 7 9700X, caching the two control lookups reduced retention cost in all 28 paired comparisons. Pooling after caching reduced the SQLite total in all seven rounds. Its total-stage results on the other three corpora included both faster and slower pairs.

Seven rounds per corpus placed each mode in two symmetric slots, rotating the outer mode per round. The paired values below use the difference between the two within-round means. Differences use TSC ticks per swept record and brackets show the minimum and maximum paired differences across the seven rounds. A positive value indicates more time in the candidate.

| Corpus | Added operation | Retention stage, median [min, max] | All instrumented stages, median [min, max] |
| --- | --- | ---: | ---: |
| sqlite | cached minus uncached | −9.5659 [−10.0707, −9.3091] | −9.1015 [−10.1859, −8.4710] |
| sqlite | pooled minus cached | −0.8403 [−0.8994, −0.6962] | −0.3880 [−1.4039, −0.1892] |
| sqlite | pooled minus uncached | −10.3194 [−10.9701, −10.2078] | −9.6155 [−11.2412, −9.1401] |
| lua | cached minus uncached | −4.9884 [−5.0143, −4.6106] | −4.7535 [−5.9218, −3.3711] |
| lua | pooled minus cached | −0.4419 [−0.7469, −0.3512] | +0.8039 [−2.4901, +3.0899] |
| lua | pooled minus uncached | −5.3656 [−5.4600, −5.2834] | −3.9317 [−5.8612, −1.5885] |
| musl | cached minus uncached | −2.3591 [−2.4561, −1.4620] | −2.0532 [−6.9333, −0.4979] |
| musl | pooled minus cached | +0.3570 [−0.5539, +0.5483] | +1.4645 [−3.4228, +7.0659] |
| musl | pooled minus uncached | −2.0159 [−2.2264, −1.8422] | −1.0897 [−5.4760, +2.2898] |
| main | cached minus uncached | −0.9432 [−1.3075, −0.1574] | −0.8610 [−1.8915, +1.2782] |
| main | pooled minus cached | −0.0734 [−0.8772, +0.1899] | −0.0202 [−2.2984, +1.3698] |
| main | pooled minus uncached | −1.0281 [−1.1799, −0.7872] | −0.7051 [−1.5366, +0.0618] |

The final [per-corpus counts](qualification.tsv) use the complete selected output. All verification and measured receipts agreed across modes, including native rows, calls and final shadow comparison. Four separate SQLite [mutation controls](mutations.tsv) were checked with source-selection verification enabled. The primary campaigns disabled that verification and all mutations.

The [schedule](pooled-capture.sh), [exact command](pooled-capture-one.sh), [corpus arguments](corpora.sh), [all per-run TSC and comparison receipts](stage-observations.tar.xz), [run order](order.tsv) and [reducer](pooled-reduce.py) reproduce the paired analysis. Per-stage results are available for [cached minus uncached](cached-minus-uncached.tsv), [pooled minus cached](pooled-minus-cached.tsv) and [pooled minus uncached](pooled-minus-uncached.tsv).

The compiler compiles its own sources and emits its source path in preprocessor expansions. An additional same-binary [source-path control](compiler-source-paths.tsv) changed only the spelling of the root directory. The primary 65-byte spelling yielded 3,839 native roots and 22,077 entries. A symlink spelling of 84 bytes yielded 3,833 and 22,053. A 110-byte spelling reproduced the local capture of 3,859 roots and 22,144 entries. All had zero native differences. Substituting the [two headers with different preprocessor line markers](headers.sha256) at the two shorter spellings preserved their counts. Each timed mode used the identical 65-byte spelling.
