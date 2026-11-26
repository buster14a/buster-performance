# Ryzen 7 9700X replay after integrating Buster PR 3652

[PR 3652](https://github.com/buster14a/buster/pull/3652) at `d4f8be004` compared with its pinned merge base `8cfefb2d`. Both Release compilers used Clang 23.1.4. The original 50-million-iteration asm-goto harness ran in five alternating pairs per mode on CPU 2 under the Benchpress lock. All paired checksums matched.

| Target and compiler tier | Median user cycles, base → head | Median user instructions, base → head |
| --- | ---: | ---: |
| Zen 5, Tier 0 | 594.01M → 594.04M (≈0%) | 4,159.05M → 4,159.05M (≈0%) |
| Zen 5, Tier 1 | 605.01M → 449.61M (−25.68%) | 3,752.80M → 2,952.80M (−21.32%) |
| x86-64, Tier 0 | 594.02M → 594.01M (≈0%) | 4,159.05M → 4,159.05M (≈0%) |
| x86-64, Tier 1 | 605.02M → 449.62M (−25.68%) | 3,752.80M → 2,952.80M (−21.32%) |

Both Tier 1 compilers reported three functions and zero fallbacks at both targets. The integrated head passed 893 assembly-output checks including 440 C-suite round trips, 124 Tier 1 asm driver checks and 5,830 checker asm checks. The GNU as round-trip suite used `--compress-debug-sections=none`.

[Raw samples](raw.tar.gz) · [Native correctness logs](native-checks.tar.gz)

---
Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
