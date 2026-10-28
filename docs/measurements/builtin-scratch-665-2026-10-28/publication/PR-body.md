Each integer builtin call currently reserves fresh operand and recipe temporaries for the rest of its function. Reuse private U64 recipe scratch and cache operand slots by active builtin depth, argument position and value class. Nested results, equal-class operands and signed/unsigned 128-bit objects retain separate lifetimes. Integer recipe refusals now name the exhausted entry/local limit or lowering storage.

The original issue's 8,000-call refusal is already removed by main's larger local limit. This change addresses the remaining scratch growth and frames. General source-local lifetimes and other builtin recipe families keep their existing allocation contracts.

Local frame controls were replayed on this publication head `25783a29`, on a Ryzen 9 7940HS with Clang 23.1.4, release host build (`BUSTER_DEBUG_INFO=0`, usual `-O3 -march=native` flags). Probe inputs use GNU17; the reference is Clang `-O0 -fwrapv`. Both probes match Clang on 143 inputs, with scalar/vector object equality.

| One-function control | main `241fcb3e` reservation | this head | Clang -O0 |
| --- | ---: | ---: | ---: |
| 8,000 add-overflow calls, each with a block-local `int r` | 831,912 B | 64,008 B | 31,880 B |
| 4,000 popcount accumulations | 127,920 B | 0 B | 0 B |

Reservations exclude pushed registers and the red zone. Both Buster overflow builds push 48 B, Clang 8 B; pooled popcount pushes none. The remaining overflow frame is principally the ordinary source result objects at 8 B each. These are frame/runtime correctness controls, not throughput measurements.

Validation on this publication head, based on pinned main `12db4a0e` including #678:

- Release: all 41 units; integer builtin lowering: 970,287 checks, 0 failures.
- Full checker: 465,960 checks, 0 failures; driver: 21,648 checks, 0 failures.
- Focused generic scalar-host source fixtures: 89 checks, 0 failures under ASan/UBSan; scalar-host checker syntax passes.
- Repeated recipes, nested destinations, mixed widths/signedness and wide objects; many-body single/two-lane/scalar objects agree and match Clang on 143 inputs.

**Native performance qualification is pending.** The separate frozen candidate `a207fcd7` is retained at `codex/665-frozen-native-candidate`; its intended 9700X comparison is against `241fcb3e`, without #688's register-home optimization. No target timings have been accepted, no gain is claimed for this publication head, and small/SQLite cost controls remain to run. Hosted CI is pending. Raw native evidence will be published separately when qualification completes.

Addresses #665.
