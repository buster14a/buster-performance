# Ryzen 7 9700X preprocessing measurements for Buster PR 3663

Benchpress CPU 2 under the shared lock. Both Release compilers used Clang 23.1.4 for Zen 5. The head was `d1abb572fef5f0cda6d77e6234feeeb67a3c6a15` and the baseline was its exact parent, `dd308d43064fcb349ed8fb2ac06996d474c6c1bc`. The recorded merge base also incorporates #3660's direct compiler changes. This comparison uses the exact parent to isolate the preprocessing patch.

A single normal linker layout ran each workload in one warmup pair and 20 measured alternating pairs. Both heads produced identical preprocessed output within each workload. Redirected stderr was empty for successful SQLite and contained 1,024 warnings per sample for the synthetic directive workload. The warning count was stable as the new hints expanded stderr from 136,649 to 159,177 bytes.

| Preprocessing workload | Median user cycles | Median user instructions | Median task-clock |
| --- | --- | --- | --- |
| Frozen SQLite amalgamation | 64.910M → 64.991M (+0.13%) | 189.910M → 189.944M (+0.02%) | 14.155 → 14.165 ms (+0.07%) |
| 512 `#ifdef` and 512 `#endif` warnings with carets | 3.605M → 4.578M (+26.99%) | 10.865M → 13.711M (+26.19%) | 1.395 → 1.590 ms (+13.98%) |

Paired warning cycle deltas ranged from +24.10% to +31.10%. Paired SQLite cycle deltas ranged from −1.56% to +21.95%, with one high outlier. The head matched Clang on all 83 cases in the complete caret oracle.

[Raw samples, stderr and output hashes](raw.tar.gz)

---
Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
