## Second findings: LICM and value numbering restricted to vector and mask values beat the unrestricted passes on the lexer

Same method and file as the first findings (`mid200.c`, 9,076 bytes, one `c_tokenize` call), main `45cd9aec`, the owner's desktop (Ryzen 9 7940HS, Zen 4, `-march=native`). **Desktop numbers, not a 9700X timing**; that run is still to do. Cycles are 9 interleaved rounds of all twelve programs on one CPU of a `cores -n 1` grant; counts are exact.

The prototype is two filters behind an environment variable (default objects are byte-identical to main's): LICM moves only the available candidates of vector or mask type (`IR_V4I32` and on) and the in-loop operands those need; value numbering applies a congruence only to values of those types.

| Build | cycles/B min | median | max | instr/B | instructions (exact) | spill stores / loads | edge moves | records | `licm_moved` / `gvn_removed` |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| clang -O2 | 1.174 | 1.188 | 1.204 | 3.09 | 27,848 | | | | |
| `--tier1` (default) | 10.275 | 10.309 | 11.046 | 12.73 | 112,636 | 2,870 / 3,895 | 8,346 | 76,955 | 0 / 0 |
| `+licm` | 6.892 | 6.930 | 7.296 | 11.71 | 103,322 | 13,943 / 11,685 | 20,411 | 99,587 | 3,752 / 0 |
| `+gvn` | 6.744 | 6.761 | 6.929 | 11.04 | 97,306 | 5,099 / 6,563 | 13,657 | 69,555 | 0 / 53,393 |
| `+licm,+gvn` | 5.709 | 5.748 | 5.834 | 10.79 | 94,957 | 8,203 / 9,275 | 18,848 | 76,421 | 1,886 / 57,071 |
| vector-only `+licm` | 6.728 | 6.884 | 7.097 | 11.85 | 104,645 | 12,476 / 10,534 | 16,538 | 94,589 | 90 / 0 |
| vector-only `+gvn` | 6.598 | 6.622 | 6.681 | 10.95 | 96,441 | 3,174 / 4,274 | 8,839 | 65,505 | 0 / 3,713 |
| **vector-only `+licm,+gvn`** | 5.343 | **5.376** | 5.549 | 10.52 | 92,562 | 4,946 / 5,951 | 11,315 | 68,328 | 31 / 4,172 |

(The last five columns are `--tier1-report`'s totals for the whole unit.)

**1. The restricted passes are faster than the unrestricted ones, 5.38 against 5.75 cycles/B, and 1.92 times the default's speed.** 31 hoisted values and 4,172 merged ones do nearly all of it; the other 1,855 hoists and 52,899 merges of the unrestricted passes are scalar values, and on this unit they cost more than they give: the unrestricted pair has 8,203 / 9,275 spill stores and loads and 18,848 edge moves, the restricted pair 4,946 / 5,951 and 11,315. That is #2719's pressure seen from the other side: its cost is in the general registers, and the vector constants that are worth sharing are few and long-lived. `rematerializations` is 1,865 in every variant. All variants give the scalar lexer's tokens (exit 0).

Value numbering alone is the cleaner half: vector-only `+gvn` leaves the spills near the default's (3,174 / 4,274 against 2,870 / 3,895) and takes 36% of the cycles. LICM alone hoists 90 values and still adds 9,606 spill stores; with value numbering before it, 31 hoists suffice, because the duplicates it would have hoisted one by one are one value by then.

**2. What 32 vector registers are worth, measured with GCC on the same unit.** GCC 16.2.1 `-O2 -march=native`, with `-ffixed-` on the registers taken away (checked in the objects: the 16-register build names xmm0 to xmm15 only, and so on):

| GCC's vector registers | cycles/B min | median | max | instr/B |
| --- | ---: | ---: | ---: | ---: |
| 32 | 1.293 | 1.307 | 1.414 | 3.41 |
| 16 (xmm0 to xmm15) | 1.514 | 1.538 | 1.608 | 3.55 |
| 15 (xmm0 to xmm14, Tier 1's set) | 1.492 | 1.516 | 1.662 | 3.57 |
| 8 | 1.738 | 1.778 | 1.801 | 3.78 |

So on this code the upper sixteen are worth about 18% of the cycles to an optimizing allocator, the fifteenth against the sixteenth nothing, and halving again another 16%. For Tier 1 it is the second lever, after the constants: with the restricted passes the one call still executes 8,125 vector loads from the stack and 6,394 vector stores to it (clang: 392 and 366), 16% of its 92,562 instructions. The default executes 4,906 and 1,917, so what spills is the hoisted and shared constants themselves. I have not prototyped it.

What the one call executes, by class (`stephist` joined with the disassembly; the classes that differ most):

| Executed in the call | default | `+licm,+gvn` | vector-only pair | clang -O2 |
| --- | ---: | ---: | ---: | ---: |
| immediate stores to the stack | 28,458 | 3,563 | 8,762 | 68 |
| vector loads from / stores to the stack | 4,906 / 1,917 | 7,630 / 5,997 | 8,125 / 6,394 | 392 / 366 |
| general loads from / stores to the stack | 7,772 / 6,747 | 8,625 / 8,313 | 7,772 / 6,747 | 867 / 653 |
| general stores to other memory | 1,432 | 7,636 | 1,432 | 3 |
| scalar compute | 11,132 | 9,233 | 11,132 | 2,993 |
| general register moves | 6,107 | 5,611 | 6,107 | 410 |
| mask to or from a general register | 3,740 | 3,740 | 3,740 | 136 |
| vector and mask compute | 19,204 | 14,582 | 14,582 | 12,744 |
| vector register moves | 5,132 | 4,514 | 4,514 | 1,480 |
| **total** | 112,636 | 94,957 | 92,562 | 27,848 |

The unrestricted pair removes 5,199 more immediate stores than the restricted one and 1,899 scalar computations, and pays 6,204 general stores to memory and 2,419 more general stack loads and stores for them.

**3. Compile cost.** The lexer unit, `--lanes 1`, user cycles: default about 1.13 G, `+licm,+gvn` 1.65 G, the prototype 1.64 G. The prototype filters after the full analyses ran, so it pays for all of them; a real policy has to decide before the analyses (a function with no vector value is skipped; in one with them, only vector expressions are numbered), or #2719's compile-cost objection stands.

**4. A measurement trap on the desktop.** The same objects swing about 35% in cycles/B with the machine's state (the default lexer 10.3 to 12.0, clang's 1.18 to 1.6), not with the environment, ASLR or stack alignment. Only interleaved rounds under a `cores` grant compare; an earlier 7.7 I read for `+licm,+gvn` was that (same object, sha `bce7f94d595cca60`).

Next, each posted as it lands: whether scalar units' objects are unchanged under the restricted policy (sqlite3.c, Lua), the prototype pushed as a draft branch, the issues for the policy, for zmm16 to zmm31 as value registers and for masks through general registers, and the 9700X's cycles.

---
Agent session: b0df91f8-5327-4de1-a613-db1be1f3c3fb (Factory Droid session ID; no share URL is exposed)
Model: Fable 5.2 (as reported by Factory Droid, which names no provider)
