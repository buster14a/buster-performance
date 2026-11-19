# Narrow reloads after a zero-extended store

Buster's opt-in Tier 1 memory pass removes one executed memory read in each of two C functions. Both keep the full four-byte store and still execute four instructions, including the return. The new code has a register copy in place of the reload. [Issue #3033](https://github.com/buster14a/buster/issues/3033)

| C function | Narrow reads, base → head | 32-bit stores, base → head |
| --- | ---: | ---: |
| `put_byte` | 1 → 0 | 1 → 1 |
| `put_word` | 1 → 0 | 1 → 1 |
| `other_byte`, reads offset 1 | 1 → 1 | 1 → 1 |
| `may_alias`, intervening byte write | 1 → 1 | 1 → 1 |

The word witness emitted these instructions through `ret`.

| Base | Head |
| --- | --- |
| `movzx eax,si` | `movzx eax,si` |
| `mov DWORD PTR [rdi],eax` | `mov ecx,eax` |
| `movzx eax,WORD PTR [rdi]` | `mov DWORD PTR [rdi],ecx` |
| `ret` | `ret` |

## Reproduction

Run `bash reproduce.sh` on an ordinary AVX-512 Linux VM with Git, Bash, binutils, gzip, curl and the repository's build prerequisites. The script creates a disposable checkout under the system temporary directory. It fetches Buster base `6427879e1143026a12fb0388a20bdea1fe4b2bc5`, head `037f264e1f1b6964082bb6a0ad6472bb3702a60a`, the repository's pinned build tools, and zlib's `puff.c` and `puff.h` at `51b7f2abdade71cd9bb0e7a373ef2610ec6f9daf`. The C driver invocation for both revisions is below.

```sh
build/compiler --tier1 --verify --tier1-report -O2 -march=x86-64 \
    -fno-strict-aliasing --tier1-passes=+memory -c kernel.c -o kernel.o
```

The first reproduction used a GitHub-hosted Intel Xeon Platinum 8573C. The paired run built and executed both revisions on one GitHub-hosted AMD EPYC 9V74 with the complete vector feature probe, Clang 23.1.4, CMake 4.4.3 and Ninja 1.13.2. Both used Release, `BUSTER_HOST_ARCH=vector` and `BUSTER_DEBUG_INFO=0`. The baseline preceded the compiler change. [First reproduction](https://github.com/buster14a/buster-performance/actions/runs/44600883629/job/135831634288) · [Paired run](https://github.com/buster14a/buster-performance/actions/runs/44602571730/job/135837595355)

## Results

- All four C functions compiled in Tier 1. The existing driver counter `loads_forwarded` went from 0 to 2 with `+memory`. The ordinary default emitted byte-identical witness `.text` on both builds. `test-ir-source --print` shows each promoted C function's narrow SSA value, zero extension, store and same-address load. The `memory` row of `test-ir-source --passes` changed zero of four functions on base and two on head, with zero failures.
- The two Buster objects and Clang's object passed the same native harness over all 65,536 input values. It checks each return, all four written bytes, neighbor guards, the high byte, and aliasing writes at offsets 0 and 1 or to a separate byte.
- `test-ir-optimize` passed 290,949 checks on base and 290,964 on head. The new IR pair verifies the exact narrow SSA operand, a previously forwarded operand, repeated loads, overlapping and uncertain writes, different address families, offsets and widths, volatile, atomic, segment, fence, call and lifetime boundaries, an `undef` source, sign extension and a block boundary.
- Unmodified zlib `puff.c` emitted the same 5,729 bytes of `.text`, SHA-256 `7626004e98c3b9619edcf6293a2835244990b46a04c1712b219bedbea8b595b0`. Both builds reported 24 forwarded loads, and five of six functions compiled in Tier 1. The base, head and Clang decompressors decoded the same 4,274-byte dynamic-Huffman stream to the 12,278 original bytes of Buster's license.
- The compiler inspects at most the preceding event on an eligible narrow-load miss. It reuses existing family and offset columns, with no extra pass over the function or scratch table. Compiler throughput and Zen 5 program timings were unmeasured. The code-quality result is scoped to the opt-in pass.

`hosted-output.txt` contains the runner's probe, tool versions, test output, verified C IR, disassembly and comparison results. GitHub timestamps and the build and checkout logs are omitted from that excerpt.

---
Agent session: [private session](https://chatgpt.com/c/6aff4f35-5210-83ed-8280-551754572b17) · Codex `6aff4f36-f38c-8191-a85d-90df33b9f072`
Model: OpenAI / gpt-6.2-astra
