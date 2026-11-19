# Assembler fragment partition, buster#3091

The assembler groups fragments into section ranges in source order. This change uses the existing boundary array as the write cursors. It removes four bytes of temporary scratch per section and the full copy of the section starts. Both revisions make one count pass and one scatter pass over the fragments, and one prefix pass over the sections. [Buster issue and scope](https://github.com/buster14a/buster/issues/3091)

Base `3741c264fb349e86359acfd1c732ee1c2eaa4052` and published head `9b0f4bbbe554293c491b3b88236a61a59c161beb` were compared using the patch in the bundle. Its local commit `4b6076537461499a89410ee792087c14a1cadba6` and the published head have the same base and Git tree `722d386332839818b5d4a0316179289c15f773ce`. The host was a Linux Ryzen 9 7940HS with Clang 23.1.5, GCC 16.2.1 and binutils 2.47. Builds used Debug, native ISA and one job.

| Input | Section slots | Fragments before CFI | Base cursor scratch | Head cursor scratch |
| --- | ---: | ---: | ---: | ---: |
| Interleaved assembly with CFI | 16 | 15 | 64 B | 0 B |
| 1,024 custom section declarations | 1,038 | 1,037 | 4,152 B | 0 B |
| Sparse private fixture | 4,097 | 6 | 16,388 B | 0 B |

All eight ELF objects matched byte-for-byte, as did the source IDs, order and boundaries before and after CFI insertion. The GNU assembler agreed on the representative section payloads and decoded frame rows. Making either permanent allocation one byte short preserved the original output and diagnostic on both builds. Exhausting only the cursor scratch made base fail and head emit the ordinary object. The complete assembler cross-check passed 1,984,303 checks on base and 1,984,308 on head.

## Reproduce

Download the bundle and run these commands from a Buster checkout containing the base revision on a supported non-9700X Linux host. The script creates its own disposable worktree. [Download the reproduction bundle](./assembler-section-cursors-repro.tar.gz?raw=true)

```sh
tar -xzf assembler-section-cursors-repro.tar.gz
bash assembler-section-cursors/reproduce.sh "$PWD" "$(mktemp -d)/results"
```

The archive contains the exact input files, code patch, paired instrumentation, raw section arrays, complete objects, diagnostics and test logs. Its SHA-256 is `19afca28b4f849abe093b9922701bb7c55dc6015175dc1197072da73392aa187`.

---
Agent session: 6aff6bbb-9248-8191-b6e6-308b27e9e06b (OpenAI Codex session ID; no share URL is exposed)
Model: OpenAI / GPT-6 (Codex)
