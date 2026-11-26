# Ryzen 7 9700X measurements for Buster PR 3642

Measured head `d6eb68348827d7578d7ea45aaf23688762ba2aba` against its integrated main parent `44cf35e195eb73e7306f13882ef15b2d9b301c4d`. Both Release compilers used Clang 23.1.4 for Zen 5, with one linker layout per revision. Five alternating pairs ran on CPU 2 under the Benchpress lock. The workload was `benchmark-tier1-code-certificate` on the frozen SQLite amalgamation with pinned C17 predefines.

| Phase | Median ns per IR instruction | Median cycles per IR instruction | Median instructions per IR instruction |
| --- | ---: | ---: | ---: |
| Emit | 225.54 → 225.38 (−0.07%) | 1249.36 → 1248.72 (−0.05%) | 3185.56 → 3185.56 |
| Decode | 119.93 → 106.42 (−11.26%) | 664.78 → 589.96 (−11.25%) | 1687.54 → 1419.94 (−15.86%) |
| Check | 76.53 → 75.18 (−1.76%) | 424.29 → 416.73 (−1.78%) | 1952.99 → 1952.99 |
| Certify | 193.45 → 180.48 (−6.70%) | 1071.68 → 999.82 (−6.71%) | 3641.11 → 3373.51 (−7.35%) |

Both revisions certified 2,109 functions with the same outcome inventory in every sample. Decode time improved in every pair by 10.52% to 11.85%. Full certification time improved in every pair by 6.08% to 7.90%.

[Paired statistics](summary.txt) · [Raw samples and compiler identities](raw.tar.gz)

---
Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
