## Findings 4: the 9700X confirms it. Vector-only LICM + value numbering halves the lexer's cycles

Run on benchpress (Ryzen 7 9700X, Zen 5, `performance` governor, CPU 2, each step under `exclusive.sh`), buster `24c4f2abb` (the prototype branch `droid/vector-passes-1344`), every lexer built at `-march=znver5`. One `c_tokenize` call over `mid200.c` (9,076 bytes), 15 interleaved rounds, user cycles per byte:

| build | min | median | max | instr/B | vs clang -O2 |
|---|---|---|---|---|---|
| clang 23.1.1 -O2 | 0.715 | **0.722** | 0.737 | 3.086 | 1.00× |
| gcc 16.2.1 -O2, 32 vector registers | 0.800 | 0.809 | 0.833 | 3.388 | 1.12× |
| gcc -O2, 16 vector registers (`-ffixed-xmm16..31`) | 0.885 | 0.891 | 0.913 | 3.503 | 1.23× |
| gcc -O2, 15 vector registers | 0.888 | 0.909 | 0.927 | 3.508 | 1.26× |
| gcc -O2, 8 vector registers | 1.058 | 1.083 | 1.103 | 3.756 | 1.50× |
| Tier 1 default | 8.187 | **8.192** | 8.275 | 12.731 | 11.35× |
| `+licm` | 4.742 | 4.773 | 4.790 | 11.711 | 6.61× |
| `+gvn` | 5.327 | 5.330 | 5.344 | 11.042 | 7.38× |
| `+licm,+gvn` | 4.205 | 4.226 | 4.349 | 10.786 | 5.85× |
| vector-only LICM | 4.790 | 4.805 | 4.834 | 11.850 | 6.66× |
| vector-only value numbering | 5.292 | 5.297 | 5.359 | 10.946 | 7.34× |
| **vector-only LICM + value numbering** | 4.035 | **4.049** | 4.072 | 10.519 | **5.61×** |

All 12 builds agree with the scalar twin (exit 0 in every round; 0 failures).

What this settles:

- The vector-only policy of #2781 takes the lexer from **8.192 to 4.049 cycles/byte (−50.6%, 2.02× faster)** on the 9700X, and it beats the unrestricted `+licm,+gvn` (4.226) by 4.2% while leaving scalar code untouched (sqlite3.c and Lua objects are byte-identical, findings 3).
- The desktop (Zen 4) direction held: there the same pair went 10.31 → 5.38 (−47.9%).
- The remaining gap to clang is 5.6×. It is not the vector work itself: Tier 1 executes 10.5 instructions per byte against clang's 3.1, and findings 2 attributes the excess to stack traffic (vector reloads and stores, immediates stored to the stack, masks through GPRs).
- The register experiment also held on Zen 5: GCC loses 10% of its cycles going from 32 to 16 vector registers and 34% going to 8. Tier 1 uses 15 (`xmm0`–`xmm14`), so `zmm16`–`zmm31` as value registers is worth roughly that much once the stack traffic is otherwise gone; I will file it separately.

Compile cost of the prototype on the 9700X, lexer unit alone (user cycles of `-c`): default 925.5 M, vector-only value numbering 1,082.0 M (+17%), vector-only LICM 1,449.4 M (+57%), both 1,374.8 M (+49%). The prototype runs the passes ungated on every function; the implementation for #2781 gates them on functions with a vector or mask value and skips LICM's per-loop walk for loops without one, and I will measure that build here before the PR is ready.

Raw results (`rounds.tsv`, `rounds.log`, `variants.log`, object hashes, the script) go to buster-performance with the rest of this census.

---
Agent session: b0df91f8-5327-4de1-a613-db1be1f3c3fb (Factory Droid session ID; no share URL is exposed)
Model: Fable 5.2 (as reported by Factory Droid, which names no provider)
