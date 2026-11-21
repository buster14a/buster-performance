# Direct control-root exceptions in the ordinary program writer

The complete frozen SQLite translation unit used ordinary `-c` under the host lock on Ryzen 7 9700X CPU 2. The parent was `fde14be84c074a65e8219f82c73202355635cfe1`. Both other modes ran `0b0a5ddff8004151f151caa32050bd167306eb5e`. The off mode left `BUSTER_PROGRAM_DIRECT_ROOTS` unset. The on mode set it to `on`. Three rotated symmetric PMU rounds used two positions of each mode per round. Each difference subtracts the two within-round means.

| Comparison | Total cycles/token, median [min, max] | User instructions, median [min, max] | Process faults, median [min, max] |
| --- | ---: | ---: | ---: |
| on minus parent | −4.6232 [−14.3550, +0.1621] | −1,049,414.0 [−1,050,527.5, −1,048,528.0] | +0.0 [−1.0, +0.0] |
| on minus off | −4.2556 [−7.4522, −1.3538] | −1,153,528.5 [−1,154,631.5, −1,153,308.5] | +0.0 [−1.0, +0.0] |
| off minus parent | −0.3676 [−6.9028, +1.5158] | +104,104.0 [+103,894.5, +105,000.5] | +0.0 [+0.0, +0.0] |

The 18 timed runs and seven separate initial checks produced identical 2,061,192-byte objects, SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. The separate verifier checked 40,299 lookups with zero head or next differences. Every PMU counter was 100% enabled and the recorded token count was 716,136. The [per-position reports](reports.tar.xz), [round calculations](paired.tsv), [object receipts](objects.tsv), [verification output](verification.txt), [warning receipts](diagnostics.tsv), [run order](order.tsv), [commands](program-roots-one.sh) and [source patch](experiment.patch) preserve the screen.

The native parent executable’s SHA-256 was `653cfea8723183100eaad6c86908bab4a6285bd372241487cb5b771db74525e6`. The candidate executable’s SHA-256 was `6c29ff8cf6c8b5e2df922f9c2150991b4ea85ad0ebc74e7280f5a9bf99c87c62`.

The broader checker found that the nested folded-for path still read the old index. The tested source is retained as an intermediate performance experiment. A later source revision, e857d41355a7cb68180a479f8afd85c53100a1a7, changes that reader to the shared provider. This table applies to the earlier revision and the frozen SQLite input.
