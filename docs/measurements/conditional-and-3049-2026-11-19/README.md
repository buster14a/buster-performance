# One-arm integer AND in Tier 1

Buster compiles an ELF section flag intersection with the carried accumulator in `rax`. At base the old `rax` feeds an AND and the AND result feeds a conditional move back to `rax`. At head the conditional move chooses the current mask or all ones and only the final AND reads the old accumulator. [Issue #3049](https://github.com/buster14a/buster/issues/3049) · [Paired hosted job](https://github.com/buster14a/buster/actions/runs/44606577611/job/135851744540)

| Kernel | Base | Head |
| --- | --- | --- |
| Update on `SHF_ALLOC` | `and rdx,rax` → `cmovne rax,rdx` | `cmovne r9,rdx` chooses the mask, then `and rax,r9` reads old `s` |
| Update without `SHF_ALLOC` | `and rdx,rax` → `cmove rax,rdx` | `cmovne rdx,r9` chooses the mask, then `and rax,rdx` reads old `s` |
| 32-bit `if` | `and edx,eax` → `cmovne eax,edx` | `cmovne r9d,edx` chooses the mask, then `and eax,r9d` reads old `s` |

Each 64-bit loop gains a seven-byte immediate `mov r9,-1`. Measured from the first instruction at the back-edge target through the closing `jb`, the body grows from 31 to 38 bytes. The two operations on the longest old-to-new accumulator path become one. The experiment measures emitted instructions and bytes. It includes no compiler or generated-loop timing.

## Replay

From a checkout of `buster14a/buster` on an AVX-512 Linux x86-64 machine, set `record` to this directory in a checkout of `buster14a/buster-performance` and run

```sh
bash "$record/compare.sh" b847801169f2b73aed6496c8fa23e9a5499c94e7 a2157ceaf5ec05a176118beb843cc4eb6f6aa967
```

Both compiler builds used vector Release, `BUSTER_DEBUG_INFO=0` and `BUSTER_SANITIZER=none`. The C-driver witness used `--tier1 --tier1-strict --verify -O2 -march=x86-64-v4`. The min/max fixture comparison additionally used `--tier1-passes=+vectorize`. The script prints the toolchain versions and the Clang executable hash, builds each revision in the same directory and runs `build/compiler test-ir-optimize` at each revision. Full instruction bytes and branch targets are in [base.asm](base.asm) and [head.asm](head.asm). The compiler revisions are [base](https://github.com/buster14a/buster/commit/b847801169f2b73aed6496c8fa23e9a5499c94e7) and [head](https://github.com/buster14a/buster/commit/a2157ceaf5ec05a176118beb843cc4eb6f6aa967).

## Conditions and controls

* `conditional.c` and `check.c` extract the actual 64-bit `sh_flags` from every section header in the hosted Clang ELF and intersect prefixes of its allocated and nonallocated sections. A scalar specification and separately compiled Clang functions check empty prefixes, all lengths, four accumulator seeds and the high bit. Deterministic inputs through 257 elements also cover 8-, 16-, 32- and 64-bit C results, both orientations, a shared update, and division. A second volatile array is placed on a `PROT_NONE` page when every update is inactive.
* The six compiled control functions use an externally consumed arm result, a repeat volatile read, a separately guarded volatile mask, guarded integer division, a floating condition and a plain repeat read. Their concatenated `.text` bytes match across the pair. The min/max C fixture includes all eight kernels and the direct and inlined volatile controls from [#3029](https://github.com/buster14a/buster/pull/3029). The nine floating-select kernels came from [#2933](https://github.com/buster14a/buster/pull/2933), which includes [#2921](https://github.com/buster14a/buster/pull/2921). These compare both compilers on the same fixture sources.
* `saved.ir` and `reload.ir` are scalar if-conversion entry dumps taken on the original baseline `6427879e1`. The saved value's update arm contains only an AND and a branch. The plain and volatile repeat-read forms produce byte-identical entry dumps, including the unflagged second load. Base already combines these two volatile reads into one in the native loop. This fold declines every region with an arm load marked for reuse or speculation. The separately guarded volatile access remains behind a branch. [Pre-change IR trace](https://github.com/buster14a/buster/actions/runs/44602802211/job/135838421644) · [Volatility audit #1248](https://github.com/buster14a/buster/issues/1248)
* Verified IR cases exercise both arm orientations and both operand orders at i8, i16, i32 and i64. They cover a missing or existing all-ones entry, an original constant table with no zero, and a second phi reading the arm. Ordinary C `unsigned char` and `unsigned short` expressions undergo integer promotion and their native loops retain the existing dependency.

## Recorded results

The GitHub-hosted AMD EPYC 9V45 passed the repository vector probe. Clang 23.1.4, CMake 4.4.3 and Ninja 1.13.2 built both revisions. [Selected job output and hashes](results.txt)

| Check | Base | Head |
| --- | ---: | ---: |
| `test-ir-optimize` checks, zero failures | 290,949 | 291,517 |
| Native values and guard checks, including 40 ELF sections (34 allocated) | 8,914 | 8,914 |
| C23 `_BitInt(8)` and `_BitInt(16)` values compared with Clang | 1,098,240 | 1,098,240 |
| SQLite amalgamation `.text` bytes | 1,831,320 | 1,831,320 |

The ordinary C and C23 8- and 16-bit examples retain the AND→CMOV chain at both revisions. Their native comparisons complement the direct i8/i16 structural and execution tests. The C23 disassembly is identical. [C23 narrow loops](narrow.asm)

On the 9,507,037-byte SQLite amalgamation a temporary counter reported one accepted i32 AND. The instrumented head and the uninstrumented head produced identical full objects. Buster base, head and Clang all completed `tests/sqlite/core.sql`, reached the appended end marker, and produced byte-identical stdout (176 lines, 8,968 bytes), stderr and exit status. Status 1 includes the script's intentional datatype mismatch. The fold adds compiler work to find the required mask only when an AND is accepted. It can scan the constant table once per used width and copy it once in that round if a mask is missing. The counter, IR dumps and byte comparisons are measurement tools.

## Annotated native loops

Addresses and instructions below come from the paired C-driver objects. Both versions carry `s` in `rax` between iterations.

### `common_alloc_flags`

Base

```asm
  a:  mov    rdx,rcx
  d:  mov    rdx,QWORD PTR [rdi+rdx*8]
 11:  mov    r8,rdx
 14:  and    r8,0x2
 18:  and    rdx,rax                   # candidate reads old s
 1b:  test   r8,r8
 1e:  cmovne rax,rdx                   # candidate and old s select new s
 22:  add    ecx,0x1
 25:  cmp    ecx,esi
 27:  jb     a <common_alloc_flags+0xa>
```

Head

```asm
  a:  mov    rdx,rcx
  d:  mov    rdx,QWORD PTR [rdi+rdx*8]
 11:  mov    r8,rdx
 14:  and    r8,0x2
 18:  mov    r9,0xffffffffffffffff
 1f:  test   r8,r8
 22:  cmovne r9,rdx                    # select mask independently of s
 26:  and    rax,r9                    # old s -> new s
 29:  add    ecx,0x1
 2c:  cmp    ecx,esi
 2e:  jb     a <common_alloc_flags+0xa>
```

### `common_nonalloc_flags`

Base

```asm
 3a:  mov    rdx,rcx
 3d:  mov    rdx,QWORD PTR [rdi+rdx*8]
 41:  mov    r8,rdx
 44:  and    r8,0x2
 48:  and    rdx,rax                   # candidate reads old s
 4b:  test   r8,r8
 4e:  cmove  rax,rdx                   # candidate and old s select new s
 52:  add    ecx,0x1
 55:  cmp    ecx,esi
 57:  jb     3a <common_nonalloc_flags+0xa>
```

Head

```asm
 4a:  mov    rdx,rcx
 4d:  mov    rdx,QWORD PTR [rdi+rdx*8]
 51:  mov    r8,rdx
 54:  and    r8,0x2
 58:  mov    r9,0xffffffffffffffff
 5f:  test   r8,r8
 62:  cmovne rdx,r9                    # select mask independently of s
 66:  and    rax,rdx                   # old s -> new s
 69:  add    ecx,0x1
 6c:  cmp    ecx,esi
 6e:  jb     4a <common_nonalloc_flags+0xa>
```

---
Agent session: 6aff5035-ce48-8191-a36b-e0d3a6a4b06f (OpenAI Codex session ID; no private session URL exposed)
Model: OpenAI / GPT-6 (Codex)
