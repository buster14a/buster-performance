# Ryzen 7 9700X upper-vector allocation measurements for Buster PR 3662

Measured [PR 3662](https://github.com/buster14a/buster/pull/3662) head `2c3f33bbfbb777f9caf9e40ca137dd607879c509` versus merge base `8cfefb2dccc92c754092cd3ce9a0eafa62c6bdca`. Both Release compilers used Clang 23.1.4 targeting Zen 5. Benchpress measurements ran on CPU 2 under the shared lock.

## Compile throughput and lexer

| Workload | Base → head | Change |
| --- | ---: | ---: |
| SQLite default compile, median wall | 15.215 → 15.250 ms | +0.23% |
| SQLite Tier 1 compile, median wall | 601.505 → 603.630 ms | +0.35% |
| SQLite Tier 1 compile, median user cycles | 3,233.4M → 3,245.1M | +0.36% |
| Tier 1 lexer harness, median user cycles | 74.33M → 74.65M | +0.43% |
| Tier 1 `c_tokenize`, cycles/byte | 3.270 → 3.356 | +2.63% |

SQLite used 31 interleaved pairs per mode. The default objects matched byte for byte. Tier 1 text grew by 16 bytes. The lexer harness used 21 runs at one link layout. Its corpus and token outputs matched Clang, and the machine-row and byte-scan counters stayed within 0.2%. The reported `c_tokenize` cycles/byte ranges were 3.263–3.280 on base and 3.349–3.369 on head.

## Generated-program runtime

Both revisions used Tier 1 to compile the frozen SQLite speedtest1 mix1 input and Lua 5.4.8. Each linker padding used seven alternating pairs. The Lua column sums the five script medians. All SQLite verification hashes and Lua script outputs matched.

| Text padding | SQLite user cycles, base → head | Lua aggregate user cycles, base → head |
| --- | ---: | ---: |
| 0 B | 672.917M → 671.216M (−0.25%) | 986.642M → 984.500M (−0.22%) |
| 16 B | 671.384M → 674.108M (+0.41%) | 987.103M → 986.923M (−0.02%) |
| 32 B | 677.877M → 675.265M (−0.39%) | 983.450M → 987.909M (+0.45%) |
| 48 B | 674.834M → 675.546M (+0.11%) | 982.682M → 983.798M (+0.11%) |

The raw archive contains counter logs, output checks, compile samples, binary identities and dispatch symbol placements. [Raw data](raw.tar.gz)

---
Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
