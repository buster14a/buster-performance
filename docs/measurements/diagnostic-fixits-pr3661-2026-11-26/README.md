# Ryzen 7 9700X diagnostic fix-it measurements for Buster PR 3661

Measured [PR 3661](https://github.com/buster14a/buster/pull/3661) head `dd308d43064fcb349ed8fb2ac06996d474c6c1bc` against merge base `8cfefb2dccc92c754092cd3ce9a0eafa62c6bdca`. Both Release compilers were built with Clang 23.1.4 for Zen 5. The runs used CPU 2 on Benchpress under the shared lock.

## SQLite compile throughput

Each mode ran 31 interleaved pairs compiling the same frozen SQLite amalgamation. The base and head emitted byte-identical objects in each mode.

| Mode | Median wall, base → head | Median user cycles, base → head |
| --- | ---: | ---: |
| Default | 15.172 → 15.146 ms (−0.17%) | 75.400M → 75.400M (+0.00%) |
| `--no-direct` | 112.583 → 112.525 ms (−0.05%) | 543.800M → 544.900M (+0.20%) |

## Warning-heavy diagnostic workload

The generated source contains 512 functions. Each produces an assignment-in-condition warning and an integer-plus-string warning. Half the conditions use a macro. Both revisions produced all 1,024 warnings in each sample. Each mode ran 21 alternating pairs through `--no-direct -fsyntax-only` with stderr redirected to a local file. The percentages compare the per-revision medians.

| Mode | Median task-clock, base → head | Median user cycles, base → head | Median user instructions, base → head | Stderr bytes, base → head |
| --- | ---: | ---: | ---: | ---: |
| Carets off | 4.560 → 4.880 ms (+7.02%) | 13.428M → 15.266M (+13.68%) | 41.081M → 45.158M (+9.92%) | 280,234 → 280,234 |
| Carets on | 4.950 → 5.800 ms (+17.17%) | 15.245M → 19.792M (+29.83%) | 47.489M → 61.707M (+29.94%) | 402,627 → 514,755 (+27.85%) |

With carets off, stderr matched byte for byte. Every pair used more user cycles on the head in both modes. The two modes measure complete compiler invocations on the synthetic warning-heavy source.

Both sides also ran the head's 74-case diagnostic catalog against pinned Clang. The base matched 43 of 74 cases and the head matched all 74. The separate hosted qualification was incomplete, with the native job canceled. [Hosted run](https://github.com/buster14a/buster/actions/runs/45874524597)

[Raw samples, compiler identities, and logs](raw.tar.gz)

---
Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
