# 9700X record for buster#1388 (string literal blocks)

The authoritative-host half of this measurement, run on `benchpress` (AMD Ryzen 7 9700X, Linux 6.18.50-2-lts)
under `/var/lib/buster-9700x`'s exclusive lock, one run at a time, each `ab.sh` invocation its own lock hold.

- **base:** `d9442df0` (the same base as the Ice Lake record), built `BUSTER_DEBUG_INFO=0 ./build.sh`,
  SHA-256 `d9dce57f9e4edf369b09c9b02dc24ae76ade73f3e3a9c782c9067e23c5f8ee81`;
- **head:** `367a7f60` (the PR's rebased head), same build, SHA-256
  `5ac9d67e38226a924d884800166e43a842d4f26f4aa94ee1151321ae9dc7bed2`;
- **inputs:** the same `gen.py` (seed 1388) outputs; SHA-256s in `../sha256.txt` inputs section apply —
  regenerated identically on benchpress (`inputs.sha256` values match: hex `8eafe416…`, letters `bd7ff426…`,
  octal `d3e7d6dd…`, text `b36e8920…`, utf8 `66601eea…`, wide `28dc8189…`);
- **method:** `ab.sh BINARY 11` — 11 runs per input of `check --time-stages -c INPUT -o /tmp/ab.o`, pinned to
  CPU 1 (`taskset -c 1`); medians of wall, `check-input` and `preprocess` stages. `bc` is absent on benchpress,
  so `ab.sh` here divides the wall median with awk instead of `bc -l`; the stage medians are unchanged.

## Results (medians of 11)

| input | base wall ms | head wall ms | base check-input ms | head check-input ms |
| --- | ---: | ---: | ---: | ---: |
| letters | 9.45 | 6.57 | 5.885 | 2.954 |
| octal | 16.93 | 9.42 | 12.601 | 4.859 |
| hex | 30.51 | 8.60 | 26.187 | 4.177 |
| wide | 11.10 | 11.17 | 6.818 | 6.806 |
| utf8 | 24.04 | 8.26 | 19.616 | 3.998 |
| text | 16.51 | 6.76 | 12.699 | 2.997 |

`base.txt` and `new.txt` are the raw `ab.sh` outputs. The escaped-literal inputs improve 1.8×–3.5× wall and
1.5×–6.3× in `check-input`; `wide` (`L"…"`, untouched by the blocks) is neutral as expected.
