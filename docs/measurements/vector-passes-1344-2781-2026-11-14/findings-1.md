## First findings: what Tier 1's `c_tokenize` runs beyond clang's on main `45cd9aec`, and two things no issue names

Method as in buster-performance's `tier1-vector-lexer-breakdown-1344-2026-11-14` (`stephist`, every executed instruction of one `c_tokenize` call on `mid200.c`, 9,076 bytes), on the owner's desktop (Ryzen 9 7940HS, Zen 4, `-march=native`, clang 23.1.5, Release compiler). Counts are exact; the cycles are this desktop's counters, **not a 9700X timing** (that run is still to do).

| Build | instructions | per byte | cycles/B (`benchmark-lexer`, this desktop) |
| --- | ---: | ---: | ---: |
| clang -O2 | 27,848 | 3.07 | 1.18 |
| `--tier1` | 112,636 | 12.41 | 10.41 |

**1. The gap is the same 4.1 times in the per-lane loops and in the per-block code.** By execution count, 128 to 144 times is a 64-byte lane's code and 18 times a 512-byte block's:

| Part | `--tier1` | clang -O2 | ratio |
| --- | ---: | ---: | ---: |
| Per 64-byte lane | 53,888 | 13,276 | 4.06 |
| Per 512-byte block | 52,757 | 12,784 | 4.13 |

So clang's unrolling is not what separates them: clang keeps those lane loops too.

**2. The passes that `--tier1` leaves off cut the cycles by 45% here.** `--tier1-passes=` on the lexer's unit, same file, same desktop:

| `--tier1-passes=` | cycles/B | instructions/B | IPC | instructions (exact) | immediate stores to the stack | spill stores / loads in the report |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| default | 10.41 | 12.73 | 1.22 | 112,636 | 28,458 | 2,870 / 3,895 |
| `+licm` | 6.87 | 11.71 | 1.70 | 103,322 | 5,962 | 13,943 / 11,685 |
| `+gvn` | 6.85 | 11.04 | 1.61 | 97,306 | 16,762 | 5,099 / 6,563 |
| `+licm,+gvn` | 5.71 | 10.79 | 1.89 | 94,957 | 3,563 | 8,203 / 9,275 |

#2719 keeps both off because they cost speedtest1 and Lua cycles (values that live across code where the allocator spills them). On vector code the trade goes the other way: what they hoist and merge are the vector constants that are otherwise rebuilt at every use (16 doubleword stores below `rsp` and a 64-byte load that none of them forwards to, #2744), and a hoisted constant that spills costs one 64-byte reload, which does forward. The lane loop goes from 400 to 140 instructions an iteration (clang: about 104). All six lexers give clang's corpus line and tokens.

**3. Tier 1's vector values take 15 of the target's 32 registers.** `BUSTER_TIER1_EMIT_VECTOR_REGISTERS` is `0x7fff` (xmm0 to xmm14, xmm15 the scratch) at every target; zmm16 and on are only a row's or a call's staging within a node. In the lexer's Tier 1 object zmm16 to zmm23 appear 36 times each and zmm24 to zmm31 never; in clang's object of the same unit 43% of the vector register operands are zmm16 to zmm31. With `+licm,+gvn` the lane loop uses zmm1 to zmm9 and zmm15, and every iteration stores and reloads hoisted constants around them: 5,997 vector stores to the stack and 7,630 loads from it in the one call (clang: 366 and 392), 14% of what is left.

**4. Every mask goes through a general register.** The Tier 1 object names `k1` 1,976 times and `k2` to `k7` never: each compare is `vpcmpeqb k1; kmovq r, k1`, and a mask that only writes a blend comes back by `kmovq k1, r` (3,740 `kmov`s between k and general registers in the call, clang 136; clang stores masks to memory from the k register and uses `k0` to `k7`).

What I do next, each posted as it has numbers: LICM and value numbering restricted to vector-class values (do they keep the 45% without the general registers' extra spills, and leave scalar units' objects unchanged), a design for zmm16 to zmm31 as value registers where every record naming the value has an EVEX form, and the 9700X's cycles for the table above.

---
Agent session: b0df91f8-5327-4de1-a613-db1be1f3c3fb (Factory Droid session ID; no share URL is exposed)
Model: Fable 5.2 (as reported by Factory Droid, which names no provider)
