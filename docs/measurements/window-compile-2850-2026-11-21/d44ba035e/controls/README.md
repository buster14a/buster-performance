# Where the condition experiment spends time on SQLite

Discovery and scheduling added 2.268 million user instructions and 5.06 cycles per token over counting control masks. Every paired round had a positive cycle difference. Certifying 1,367 bounded conditions at the front added 1.186 million instructions. Splicing the prepared native rows recovered 3.445 million instructions. Taken together, the full pipeline still cost 1.138 million extra user instructions and 6.22 cycles per token compared with disabling condition processing.

| Added stage | Median change in user instructions | Median change in cycles/token | Cycle range, seven pairs |
| --- | ---: | ---: | ---: |
| Reserve condition scratch | +3,553 | +0.0242 | −3.6416 to +3.3718 |
| Count 11,447 control markers | +597,072 | −0.2022 | −3.4081 to +3.0107 |
| Discover and schedule 5,540 bounded candidates | +2,267,827 | +5.0578 | +2.4094 to +12.0877 |
| Certify 1,367 conditions at the front | +1,186,402 | +2.1535 | −4.6559 to +6.1573 |
| Run T on 1,367 conditions | +460,689 | −1.0153 | −2.4157 to +4.3668 |
| Encode 4,101 native rows | +68,348 | −1.1936 | −5.2720 to +4.8711 |
| Publish 1,367 conditions | −3,445,290 | −1.6347 | −4.8677 to +2.1129 |
| Full pipeline minus disabled | +1,137,792 | +6.2231 | +4.1020 to +7.4653 |

All eight modes used one Release executable, SHA-256 `bdabb4f3e0084025038e63982638c720d01f82e611c2f3e25384dd2c8e66c512`, from `ccf2160d5f803f8ba50fc407be61cf33251e058a` (diagnostic child of `d44ba035e84172eaac4ddd4b4b3339bb4fd34b9b`). Each invocation compiled frozen SQLite with `--node-window-conditions -c`. The environment variable `BUSTER_CONDITION_COST` selected how far to execute the pipeline. Only the separate stage receipts used `BUSTER_CONDITION_COST_REPORT=1`. The first seven modes reported 2,977 taken expressions and 319,066 final graph nodes. Publication brought these to 4,344 and 316,332.

Seven rounds rotated and reversed the order and included two observations per mode. The table takes the median of paired differences between within-round means. Total cycles include user and kernel time and use 716,136 preprocessed tokens as denominator. The 112 PMU runs, eight stage controls and eight warning controls yielded the same 2,061,192-byte object, SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. The default output was quiet and `-Wall -Wextra` stdout/stderr agreed across modes. All counters ran at 100% enabled time and fault counts were 5,667–5,815.

The [diagnostic source patch](condition-stages.patch), [exact invocations](native-matrix-one.sh), [mode configuration](native-matrix-config.sh), [round order](order.tsv), [per-invocation counters](samples.tsv), [original perf and stage output](reports.tar.xz), [object receipts](objects.tsv) and [diagnostic receipts](diagnostics.tsv) accompany the [paired driver method](../../paired-driver/README.md).
