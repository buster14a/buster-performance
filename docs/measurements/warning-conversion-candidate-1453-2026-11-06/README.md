# Discarded conversion-reach candidate (#1453)

This record preserves one paired exploration for [buster PR #1453](https://github.com/buster14a/buster/pull/1453). Candidate `f445567afab54e91052c13100d3a80e2766a73ef`, based on `74f9cc4250874becc1c43438df5f156e54565d59`, avoids a conversion-flag load when an integer candidate has the same source and destination type. It was not pushed: the observed SQLite instruction difference was small, while cycle samples varied. These results do not establish a general compiler speedup, performance acceptance, or correctness qualification.

Both Release compilers were built with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0` and run on Benchpress (Ryzen 7 9700X, Linux 6.18.50-2-lts). The script invokes `exclusive.sh` separately for each build and each of six runs, alternating the pair order. Each sample receipt records `BUSTER_9700X_HELD=1`, the same lock owner before and after, compiler hash, successful exit and output hashes. Receipt timestamps are consistent with the script order but their one-second resolution cannot independently establish within-second ordering. Positive build-lock receipts were not recorded. Each run compiled one SQLite input with `-fsyntax-only`, CPU 2 and the flags in the archived script; `instructions:u` and `cycles:u` were measured at 100% running.

| Pair | Parent instructions | Candidate instructions | Parent cycles | Candidate cycles |
| --- | ---: | ---: | ---: | ---: |
| 1 | 1,390,651,902 | 1,390,550,064 | 585,236,862 | 614,944,508 |
| 2 | 1,390,651,905 | 1,390,549,551 | 581,018,783 | 580,489,730 |
| 3 | 1,390,652,468 | 1,390,549,552 | 589,484,326 | 581,488,417 |

The instruction medians differ by −102,353 (about −0.0074%). The candidate's first cycle sample is substantially higher; three pairs cannot establish a reliable cycle change. The six stdout streams are empty, and each stderr stream has SHA-256 `8fdc9c0a66cb58dbf305ab63c97a595c36f2661ef1d74d29df63ad439a40cf35`.

The retained bundle and patch preserve the candidate source (tree `56c3ea6edeb2400de4b3c275fd95f0b19a68ca3b`). Recorded compiler hashes are `12d6ec12af9d640c9d0fe59dadf947d3d7308eaa4ea58dd6f1d9763583475e9b` for the parent and `ec807a8192add1760bb9e90c808305651383c8de92b86e8b1126c33b8a9f417b` for the candidate. Post-collection checks found clean tracked worktrees at those revisions and matching binaries, and SQLite source hash `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`; they do not prove build-time source/input state, and included headers were not individually verified. The collector reports that a local 280-case expression comparison matched; its individual outputs are not included, and no full candidate suite or independent code review is claimed.

The archive contains the build logs, script, bundle, patch, compiler-hash and post-collection checks, six counter/output files and receipts. The script is a historical record, not a direction to rerun without checking current source and host policy. Verify archived bytes and counter rows:

```sh
sha256sum -c SHA256SUMS
mkdir -p /tmp/buster-1453-conversion-candidate
tar -xzf raw-evidence.tar.gz -C /tmp/buster-1453-conversion-candidate
python3 verify.py /tmp/buster-1453-conversion-candidate
```

These checks verify retained bytes, exact event counts, and the recorded owner, compiler, status and output hashes, not build provenance or a general performance conclusion. Collection and packaging: OpenAI Codex, model OpenAI / GPT-6, session `01a1b0e0-a314-7252-9c29-d958f2e64d73`, thread `01a1b0e1-01c7-77e3-aac3-5e875d1c15e1`. No shareable session URL was exposed.
