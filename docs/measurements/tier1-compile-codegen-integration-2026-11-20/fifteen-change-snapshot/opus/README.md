# Opus 1.5.2 portable and x86-dispatched codecs

Both builds use [upstream Opus 1.5.2](https://github.com/xiph/opus/tree/ddbe48383984d56acd9e1ab6a090c54ca6b735a6) at `ddbe48383984d56acd9e1ab6a090c54ca6b735a6`. Portable and dispatch configurations contain 137 and 152 C compilation units respectively. The normal upstream stack-protector flag is unsupported by both Buster compilers. These configurations used Opus's supported `OPUS_STACK_PROTECTOR=OFF` option. Upstream enabled the x86 dispatch implementations only in the dispatch builds. The [unit ledger](all-units.tsv.gz) and [totals](all-totals.tsv) cover all three compilers and both generated targets, znver5 and x86-64-v3. The local Ryzen 9 7940HS cannot execute the `vpdpwssd` instruction in the Clang znver5 dispatch binary. All local execution comparisons here use x86-64-v3 for every compiler.

The [64-frame audio workload](audio.c) exercises seven configurations spanning CELT and SILK, 8 through 48 kHz, stereo and mono, integer and floating APIs, DTX, in-band FEC and simulated loss. All 42 [encoded packet streams](x86-64-v3-packets.tsv) were byte-identical across their three encoder variants per configuration. The [252 decoder artifacts](x86-64-v3-pcm.tsv) cover each encoder, each decoder and both normal and packet-loss schedules. Each pair of decoder compilers agreed on all 7,864,320 PCM samples. [Per-comparison statistics](x86-64-v3-decoders.tsv). [Thirty upstream API, extension, padding, encoder and decoder test invocations](official-results.tsv) passed for all six v3 archives, with deterministic seed 1387 where the suite accepts a seed.

The [1,792 timed, output-verified processes](timing/observations.tsv.gz) cover all seven profiles, the two dispatch configurations, encoding and decoding, and four linked placements. The [paired changes](timing/paired.tsv) exclude the first of eight rounds. Across all 56 encoder cases the candidate retired 0.54–1.85% fewer instructions. Cycle medians vary by profile and placement.

## Per-PR attribution

Six versions of the same main source added the five code-generation PRs in sequence. The [compiler identities](attribution/manifest.tsv), [object identities](attribution/units.tsv.gz) and [48 linked audio programs](attribution/programs.tsv) identify each step. The first and last steps reproduce the corresponding full 15-change build byte for byte, including all 289 library objects and each executable placement. Each of the six steps also ran all 21 packet/PCM checks per configuration. [252 check results](attribution/audio-checks.tsv).

| PR applied | Portable objects changed | Portable text bytes | Dispatch objects changed | Dispatch text bytes | Encoder instructions across 56 cases |
|---|---:|---:|---:|---:|---:|
| [#3117](https://github.com/buster14a/buster/pull/3117) | 16 | -448 | 17 | -443 | -0.141% to +0.000% |
| [#3120](https://github.com/buster14a/buster/pull/3120) | 10 | -111 | 10 | -95 | -0.164% to -0.000% |
| [#3122](https://github.com/buster14a/buster/pull/3122) | 21 | -603 | 20 | -464 | -1.733% to -0.352% |
| [#3128](https://github.com/buster14a/buster/pull/3128) | 12 | -192 | 12 | -224 | -0.108% to -0.024% |
| [#3132](https://github.com/buster14a/buster/pull/3132) | 2 | -12 | 2 | -12 | -0.025% to +0.001% |

The [5,376 additional verified process observations](attribution/counters.tsv.gz) rotate and reverse the order of the six compilers. The [per-case summaries](attribution/paired.tsv.gz) retain every metric and both the per-step and combined change. These are conditional effects in the recorded application order. Local cycle measurements include process setup and file output.
