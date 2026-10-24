# PP/parser handoff qualification: reject fusion

The fused keyword/conversion alternative does not establish a representative whole-driver gain beyond observed spread. Keep the existing complete keyword pass and parser conversion. Remove the opt-in flag, pending state and fused production paths; retain the independent handoff oracle, plain combined handoff benchmark rows, native fresh-process timing tool and documented consumer contract.

## Exact provenance and acceptance

- Repository: buster14a/buster, [PR #375](https://github.com/buster14a/buster/pull/375), candidate `0c55c026cccc7e62b4e8e90c802e31d693a99c89`.
- The approved Ryzen 7 9700X CI built GitHub merge commit `1897f1edab59c56112e894a70680b7bf8854936e`, with parents `e39e54f2c7cb96077ac7ee7b9e2f4791c6c93052` and the candidate above. Its tree `770064c1604f8dffbf0f5576836ed2e0f6f6ad8f` exactly equals the candidate tree; every recorded source SHA matches that checkout.
- [Workflow 40099391974, campaign job 120888228734](https://github.com/buster14a/buster/actions/runs/40099391974/job/120888228734) succeeded. Artifact 12562915582 ZIP SHA-256: `68fa9863de76beb76cda685533975c200317e590a98110a75da39511a3986a01`.
- The external recipe is frozen at performance commit `09ca55a91db3cdb4842dfe286fb179a2a6ad1db2`. All measured compiler children ran on CPU 2, within one exclusive runner job, without a nested lock.
- 12 cells × 5 rounds × 21 measured children × 2 lists = 2,520 measured processes, all with status zero. Sixty zero-failure completions and first-warmup matching prove all 120 warmups also had status zero. Every cell has five summaries per list, and `raw/COMPLETE.txt` is present.
- All 18 accounting processes report `ready=1`, `remaining_mapped=0` and `remaining_logical=0`. All three frozen-source Clang comparisons are identical, with zero skips/errors. Native profile tests passed 42 checks with zero failures. Parser default/C99/C23/SQLite and preprocessor tests passed, including 13,845 independent handoff streams across four paths in each parser invocation.

## Whole-driver results

Negative change means fused was faster. Each change pairs the plain/fused medians of 21 fresh processes within a round; the reported middle value is the median of those five paired changes. Do not compute it by dividing separately aggregated medians. Spin 200 runs an untimed 200 ms scalar loop before each child on the same CPU. Both production drivers include preparation, preprocessing, conversion, parsing/checking, diagnostics and cleanup, plus process startup/teardown. Per-round medians, ranges and RSS are in [results.csv](results.csv); per-child timings and accounting are in [raw](raw).

| Input | Driver | Scalar work ms | Median paired change | Five-round change range | Plain round spread ms |
| --- | --- | ---: | ---: | ---: | ---: |
| small | parse | 0 | -0.064% | -0.255 to 0.319% | 0.026 |
| small | parse | 200 | -0.561% | -1.456 to 0.916% | 0.053 |
| small | checker | 0 | -0.088% | -0.351 to 0.242% | 0.015 |
| small | checker | 200 | -0.132% | -0.723 to 0.220% | 0.024 |
| headers | parse | 0 | -0.242% | -0.458 to -0.027% | 0.029 |
| headers | parse | 200 | -0.350% | -0.808 to 0.108% | 0.023 |
| headers | checker | 0 | 0.000% | -0.192 to 0.103% | 0.014 |
| headers | checker | 200 | -0.039% | -0.116 to 0.116% | 0.035 |
| sqlite | parse | 0 | -0.019% | -0.211 to 0.010% | 0.059 |
| sqlite | parse | 200 | -0.283% | -0.345 to -0.043% | 0.030 |
| sqlite | checker | 0 | -0.103% | -0.179 to -0.045% | 0.258 |
| sqlite | checker | 200 | 0.011% | -0.289 to 0.098% | 0.221 |

All six checker cells cross zero across rounds except sustained SQLite. Its 66–261 µs paired saving overlaps the 258 µs plain round spread and is not sustained after scalar work (median +0.011%). SQLite parsing after scalar work is the strongest positive cell (all rounds −0.345…−0.043%, 9–72 µs), but the matrix does not demonstrate a repeated gain across representative whole drivers in both states. The small parse cell after scalar work also has substantial process variation; raw per-child times and user/system/RSS/faults remain the evidence.

## Handoff, allocation and traffic

The isolated combined keyword/conversion kernel improves across three independent benchmark processes per input: small 0.179–0.182 to 0.153–0.157 ns/token; headers 0.166–0.168 to 0.148–0.151; SQLite 0.177–0.180 to 0.163–0.171. This is approximately 9–15% at this narrow boundary and at most a few to roughly 11 µs on these workloads. It is insufficient for adoption by itself.

No column or allocation is removed. Off/on mapping counts are 76/76 for small and 87/87 for headers/SQLite. Arena pushes are 4,635, 10,974 and 33,200 respectively, equal between modes. Peak mapped virtual capacity is equal between modes. The flag adds 83 requested logical arena bytes and 80/88 peak logical bytes from option storage; parser scratch peaks remain 12,402, zero and 9,286 bytes. All 18 processes release every tracked mapping/logical arena.

Representative token counts are 16,184 / 28,505 / 705,670, with vector occupancy 99.9506% / 99.8634% / 99.9918%. Fallback is eight items / 530 tokens, zero, and three items / 185 tokens respectively. PP source data and all parser payload columns/padding remain present. Selected logical column byte counts are source-level accounting, rather than total hardware traffic: table accesses, exceptional scalar rescans, cache effects and physical DRAM bytes are excluded. Arena high-water includes alignment and fully pushed sparse capacity; unpushed reservations are excluded. It does not measure touched/resident memory. Mapped virtual high-water excludes loader/libc/stack. RSS covers the whole instrumented process, including the probe; phase times are diagnostic only. Raw accounting logs contain all phase/preparation/cleanup/scratch/payload values.

## Historical evidence

Earlier host `raw` and `raw2` logs and their original recipes/source metadata are preserved under [historical](historical) as diagnostic historical results. Their snapshot labels/source provenance differ from the fresh composed campaign; do not present them as exact candidate evidence. [pr375-initial.patch](pr375-initial.patch) preserves the original experiment, and [qualified-fused-production.patch](qualified-fused-production.patch) preserves the relevant qualified production change. The original compiler source retains its licenses and notices in [the qualified checkout](https://github.com/buster14a/buster/tree/0c55c026cccc7e62b4e8e90c802e31d693a99c89).

A future variant needs new frozen whole-driver qualification. This rejected flag is not retained as an indefinite user option. `SHA256SUMS` covers the campaign payload, including the original artifact ZIP; the summary itself is retained by its Git commit.
