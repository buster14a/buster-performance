# Address-cast correction and masked scratch initialization at 24c16e298

The seven paired rounds met the T5 no-increase target on all three frozen corpora. Each corpus's median C-loop cost decreased on both the first call and the repeated call on the same chunk. Costs are TSC ticks per swept context record. The small programs for the original diagnostic and the exact-head corpus matrix cover different parts of the change.

| Candidate minus #3213 | SQLite | Lua | musl |
| --- | ---: | ---: | ---: |
| First C-loop median | −0.03795 | −0.22071 | −1.65419 |
| First C-loop range | −0.16131 to +0.06957 | −0.74145 to +0.78247 | −6.02849 to +3.51240 |
| Repeated C-loop median | −0.09298 | −0.08224 | −0.15586 |
| Repeated C-loop range | −0.14630 to −0.05379 | −0.15283 to −0.05601 | −0.43839 to +0.03082 |
| Context records per invocation | 321,434 | 91,252 | 377,187 |

The locked Ryzen 7 9700X Release comparison used reference 0647d69ba8af4e466c89df2519dea0b382524d37 and candidate 24c16e298bc7a5235711ff566fe652402d32173b. The included patch recreates the candidate from that reference and has SHA-256 17b744a648d4f527f8010f269bfc1d262ae81598f859b4a9900209ff2b48fb3c. The Release executable has SHA-256 b104c4b03ee0154f8deb457833d915d7d0822dbcd4e5b266ca006311e6872a3b. The change after 90d2af699 removes redundant clearing of eight 64-byte scratch vectors. The standalone [MemorySanitizer check](far-lanes.c) exercised 65,602 lane masks with pinned Clang 23. [Test output](far-lanes-msan.log)

Every A-B-B-A invocation held the host's exclusive lock for its duration and ran on CPU 2. All 84 returned success and had zero reported shadow differences. Each binary was freshly copied once per round. The shared benchmark host served two independently queued Release builds after the final musl B call (10:59:03 UTC) and before the closing A call (11:01:55 UTC). The initial musl measure has considerable within-round variation, also present in the [identical-binary and reversed-order controls for the predecessor](../90d2af699/controls/README.md). The table preserves all seven rounds.

The [corpus matrix](corpora.tsv) compares the candidate and #3213 on SQLite, Lua, musl and the compiler itself under default warnings and under `-Wall -Wextra`. All eight ordinary syntax checks returned the same exit status, stdout and stderr bytes. All eight window-shadow reports had zero differences, including their branch-truth counters. [Full corpus reports](corpora.tar.xz)

Reproduce the C-loop table from the [84 reports](timing-runs.tar.xz).

```sh
tar -xJf timing-runs.tar.xz
python3 ../intermediate/c-loop.py refcast24c cast24c -cast24c
```

## Exact-head semantic checks

The [direct checker and driver campaigns](direct/README.md) record the original 805 cast cases, 3,600 mixed casts, 4,200 address cases, 4,800 object-size queries and 7,636 supplemental cases on this production head. Seven rebuilt single-term branch mutations gave the same observability as the predecessor. Four produced a source-level diagnostic difference, one more was distinguished by replaying the implicit representation, and two had no observed source-level effect. A separate test poisons all eight scratch rows inside the real C sweep. Each of two mutations that skips a needed far-lane write was detected. The export includes the generators, per-case results, compiler and Clang provenance and a SHA-256 manifest.

A separate first-order mutation inverted the exact result-kind predicate, changing `== NONE` to `!= NONE`. It produced ten diagnostics under GNU17 and ten under C23, with clean unmodified controls. The original deletion of that predicate still had no observed effect in the source-level matrix. [Inversion, fixture and results](inversion/README.md)

The [complete broad campaign](campaign/README.md) passed on this exact head. All eight checker and eight driver shards exited zero. The shadow found zero discrepancies on 13,879 extracted programs and 1,230 tracked files under each of three policies, all 93 warning triggers, and 8,009 one-statement probes across 26 suites. Six seeds produced 90,000 additional inputs, with 16,797 rejected and 73,203 clean. The campaign archive contains the per-input tables, run scripts, binary provenance and SHA-256 manifest.
