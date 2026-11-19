# C11a: the assembler's lexer, register cache, batches and matcher keep their vector paths alone (#2924)

buster `c11` branch, on C10c (`c98e08a5a`):
- **`5da09045f` tests:** `test-assembler`'s in-process checks fold the vector path's outputs into one digest. With the default seed and fuzz count it must be `0x29134b61c976fff1`, recorded where every path comparison passed. The round trip's encoding choices gain Intel syntax's `xchg` with the accumulator first, and its shift of one operand.
- **`22f3d4625` deletion:** the lexer's, the register cache's, the batch parser's and `x86_match`'s scalar arms, and `x86_match_candidate`, `x86_match_operand` and `x86_match_immediate`. The relaxation keeps both arms, with `AsmOptions.vectorized` and `assemble --scalar`, for #2924's answer (C11b).

C11's gate is [`../c-assembler-gate`](../c-assembler-gate).

## 9700X

[`run.sh`](run.sh), [`logs.tar.gz`](logs.tar.gz): base `5da09045f` against head `22f3d4625`, Release, every run under the lock, timings on CPU 2, every process from a fresh copy.

**Objects:** byte-identical.
- `-c` (Tier 0): 1,375 of 1,375, the `assemble` objects of the gate's three inputs among them.
- `-c --tier1`: 1,372 of 1,372.
- The inputs are sqlite3.c, Lua, musl (inline assembly) and buster's `main.c`.

**Whole compiles:** `ab`, three rounds, around `time-runs` of base, head and base again, `--lanes 1` (`logs/time.log`).

User cycles against base, by round:

| Compile | Head | Base again | Instructions, head against base |
| --- | --- | --- | --- |
| musl's units, `-c` | −0.20%, +0.09%, +0.12% | −0.23%, +0.51%, −0.02% | 0.066 M fewer |
| sqlite3.c, `-c` | −0.03%, +0.29%, −0.08% | −0.12%, +0.38%, −0.08% | 0.004 M fewer |

Head is within base again's spread.

**`benchmark-assembler --only vector`** (`logs/assembler-ROUND-SIDE-INPUT.log`):
- The script ran base, head and base again in each round. The base runs wrote one log name, so `base` there is base again, the run after head's.
- Head's total against base again's, by round:

| Input | Rounds 1, 2, 3 |
| --- | --- |
| sqlite3.c by gcc | 0.995, 0.999, 1.032 |
| sqlite3.c by clang (Intel) | 1.006, 0.961, 0.948 |
| Lua's `lvm.c` by clang | 0.986, 0.985, 0.977 |
| mixed Intel, 256 functions | 1.005, 0.997, 1.006 |
| AT&T, 256 functions | 0.994, 0.993, 1.011 |

**Layout in the synthetic workloads:** head reads 0.263 to 0.277 ms in every round, against base's 0.256 to 0.258. The real inputs' layout reads 0.974 to 1.020 of base's.
- Layout's code is inlined in `asm_assemble`, which has the same 12,329 instructions in both executables, once addresses and symbol names are left out.
- `asm_assemble` starts 16 bytes into a cache line in base and at a line start in head. The difference is where the code sits, not what it does.

**Tests on head:**
- **Pass:**
  - `test-assembler --cross-check` (binutils 2.47) and `--seed 7`;
  - `test-x86-semantics --cross-check`, `test-x86-target-selection` and `test-checker-asm`;
  - `test-call-graph`, `check-call-graph`, `test-files` on the benchmarks, the complete driver's `-fsyntax-only -Wall -Werror` and `--verify -c` of `main.c`, and the ownership check.
- **`test-x86-target` fails on base and head alike:** benchpress's system clang 23.1.1 predefines `__SSP_STRONG__ 2`, and these builds' predefines have no stack protector (`logs/t4.log`, `logs/t4-base.log`, 26 of 26 option sets).

## Local checks

On head, in the cloud container:
- **Pass:** `test-assembler` (and `--seed 7`), `test-x86-semantics`, `test-x86-target`, `test-x86-target-selection`, `test-checker-asm`, and the ownership check.
- **`test-assembler --cross-check`, run from the repository root:** 5 failures, all `.text` against the container's GNU as 2.42, which orders code padding unlike binutils 2.47. C10c's build, without C11, has the same 5.

**MSan and ASan** ([`sanitizers.sh`](sanitizers.sh), [`sanitizers.log`](sanitizers.log)), all clean: `test-assembler` (and `--seed 7`), `test-x86-semantics` and `test-checker-asm`.

## Mutants

[`mutation/`](mutation/): eighteen mutants of the vector paths that lose their twins ([`mutants_c11.py`](mutation/mutants_c11.py)). Each is applied to an archived copy of the tree, built by `./build.sh` (Develop) and checked against `test-assembler` alone ([`run_c11.py`](mutation/run_c11.py)).

17 are killed:
- **The lexer:** the letters' range, `;` as a separator, the whitespace range, and the instruction capacity's count.
- **The batch parser:** the leading-zero rule, a negative immediate, RIP as a standalone register, and `xchg`'s exact path.
- **The register cache:** the vector registers' limit and MMX's.
- **The matcher:** broadcasts, the accumulator's class rule, a displacement's range, a symbolic immediate's field, the shift by one, a memory operand's segment, and VVVV's register.

**The first round** ([`c11.results`](mutation/c11.results)), on the first deletion commit (`73bdd2996`):
- `b4-batch-xchg` survived. No fixture wrote an Intel `xchg` with the accumulator first, where the batch would skip `asm_instruction`'s swap. The tests commit gained those fixtures, and the second round ([`c11b.results`](mutation/c11b.results), on `22f3d4625`) kills it.
- `b3-batch-rip` didn't build. The removed check left its variables unused, so the second round changes the class it compares with instead, and kills it.

**The survivor, `l3-lex-boundary`,** leaves out the check that a word ending at a load's last byte continues into the next byte. The term only decides where a load stops:
- A deferred word is lexed from the next load into the same token.
- A 64-byte word goes to `asm_word_length` either way.

So it can change how much is re-read, never a token.
