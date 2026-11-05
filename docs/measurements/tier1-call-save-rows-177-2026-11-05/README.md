# Tier 1's call-save rows for the registers a call saves alone (buster#177, buster#1433)

The measurements behind buster14a/buster#1433. They were taken on benchpress, the Ryzen 7 9700X, on 2026-11-05.
- **Lock:** every step took its own hold of `~/buster-fast-bench/exclusive.sh` (owner `claude-177-callsave`), and every timed run its own hold.
- **Pinning:** every timed run was pinned to CPU 2 by `taskset -c 2`.
- **Builds:** `BUSTER_HOST_ARCH=znver5`.

**Before #1433,** both Tier 1 consumers gave every caller-saved general register a call-save row in every function that calls, for the whole function, whether a value was saved there or not. The fixed registers' sequences got the same: a division's `rax` and `rdx`, a shift's `rcx`. **After it,** a row exists only for a register some call or fixed register's sequence actually saves.

## Revisions and inputs

**Revisions** of buster14a/buster:
- main: `74720ed7fd68e5620e3d343166fdee1887cf288b`, the merge of #1415.
- head: `f257b6ef2def3600b3c44080cd06ea56ca895e34`, #1433 with main merged in.
- head2: `f9779980e0b1d0d8220c51aa5ca1b74cd6884ba8`, #1433's pass made sparse.
- head3: `30918c182ae48a39afe82d76d7c6bf05f0b2100d`, #1433's search short cut.

head2's and head3's `--tier1` objects of `sqlite3.c` are head's byte for byte, and head2's Lua executable is too (`out2/identity.txt`, `out5/identity.txt`). Their code is head's, so head's frames and run times stand for them.

**Inputs** (`out/inputs.txt`):

| File | SHA-256 |
| --- | --- |
| `sqlite3.c` | `0a409f16…` |
| `speedtest1.c` | `b5eaf4bb…` |
| Lua 5.4.8 | `~/buster-fast-bench/claude-141-reciprocal/inputs/lua-5.4.8` |
| Lua's five scripts | `~/buster-fast-bench/claude-141-reciprocal/lua` |

The flags are #136's and #1415's (`run.sh`). The compiler is clang 23 (`clang -O2`, `clang -O0`).

## Correctness

- **Tier 0's object of `sqlite3.c`** is main's byte for byte (`out/identity.txt`: `t0-same`). The change is Tier 1's alone.
- **speedtest1's `--verify` hash** is the same for main's Tier 1 build and head's (`out/st/verify.txt`).
- **Lua's five scripts:** each one's output, by main's and head's Tier 1 builds and head's Tier 0 build, is clang -O0's (`out/lua/compare.txt`: 15 same, 0 differ).
- **Code-shift builds:** all 16 executables' output for `closures.lua` is clang -O0's (`out4/compare.txt`).
- **On the 9700X**, head's build passes `test-tier1-emit`, `test-tier1-pipeline`, `test-tier1-masks`, `test-tier1-cfg` and `test-tier1-frame-execution` (`out/tests.txt`).

## Frame sizes

By head's `measure-frames`, over the functions each build shares with clang -O2's (`out/steps.log`). The per-function TSVs stay on benchpress in `~/buster-fast-bench/177-callsave-claude/out/frames/`, with their SHA-256s in `out/frames/tsv.sha256`.

| Corpus | Tier 1, main | Tier 1, head | Tier 0 |
| --- | ---: | ---: | ---: |
| `sqlite3.c`, 1,600 functions | 1.493 | **0.894** | 1.272 |
| Lua 5.4.8, 653 functions | 1.448 | **0.894** | 1.215 |

The ratios are each build's frame bytes over clang -O2's. Over all of `sqlite3.c`'s 2,668 functions by `--tier1`, head against main:
- frame bytes fall from 242,384 to 134,880 (ratio 0.556; median ratio 0.5);
- 2,174 functions are smaller, 494 equal and none larger;
- `.text` falls 1.5%, from 1,272,192 to 1,253,232 bytes.

Against clang -O2 on `sqlite3.c`, head's Tier 1 frames are larger in 474 functions, equal in 708 and smaller in 418.

## Run time

Each table gives medians over 11 rounds, main and head alternating, the order flipping by round (`out/st/runs.txt`, `out/lua/runs.txt`).

**speedtest1**, with `--size 5`, from a fresh database:

| Build | ms | Instructions | Cycles |
| --- | ---: | ---: | ---: |
| main's Tier 1 | 200.7 | 3,688M | 1,014M |
| head's Tier 1 | 201.1 (+0.21%) | 3,686M (−0.04%) | 1,015M (+0.15%) |

**Lua's scripts** (ms):

| Script | main | head | Change |
| --- | ---: | ---: | ---: |
| `calls` | 30.87 | 30.94 | +0.23% |
| `tables` | 50.00 | 50.35 | +0.70% |
| `strings` | 53.02 | 52.79 | −0.43% |
| `arithmetic` | 56.57 | 56.47 | −0.18% |
| `closures` | 68.62 | 71.27 | +3.86% |

Every script runs the same instructions in both builds.

### `closures.lua`

`closures.lua`'s difference persists when the environment's size moves the stack (`out2/closures.txt`): +3.1% to +5.2% of cycles at 0, 700, 1,900 and 3,333 bytes of environment.

**The code-shift experiment:**
- **Method:** each build's Lua objects (`-c` by `--tier1`) were linked by `cc` after a padding object of N bytes, which moves all of Lua's code by N (`shift.sh`, `out4/runs.txt`). There were 7 rounds, alternating.
- **Spread from placement alone:** main's cycles span 4.4% over the eight shifts and head's 3.3%.
- **The difference:** it ranges from −1.6% to +4.6% depending on the shift, with a median of +1.6%. Head is slower at 7 of the 8 shifts.

| Shift (bytes) | 0 | 16 | 32 | 48 | 64 | 80 | 96 | 112 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| head / main, ms | +1.9% | +0.5% | +4.6% | +4.1% | +2.7% | +1.9% | −1.6% | +1.5% |

**Counters** at shifts 0, 32 and 96, over 5 rounds (`counters.sh`, `out4/counters.txt`):
- **The front end follows the cycles.** Dispatch slots with no ops from the front end (`de_no_dispatch_per_slot.no_ops_from_frontend`) change by +13%, +16% and −10% at the three shifts. Ops from the x86 decoder rather than the op cache (`de_src_op_disp.x86_decoder`) change by +68%, +15% and −19%. Both move with the cycles in both directions, so placement drives the timing.
- **The interlock failures don't.** Store-to-load interlock failures (`ls_bad_status2.stli_other`) rise at every shift: 1.8M → 3.7M, 1.6M → 1.9M and 1.5M → 4.3M. That last shift is where head is the faster build.
- **Where they occur:** sampling those failures (`stli.sh`, `out4/stli-*-symbols.txt`) spreads them over many functions, with no single site.
- **Cycle profiles:** `profile.sh` and `out3/` hold profiles of both builds.

## Compile time

The compile is `--tier1 -fno-asynchronous-unwind-tables -c sqlite3.c`, 11 rounds, main and the head in question alternating. The figures are medians, as changes against main:

| Revision | Instructions | Cycles | ms | File |
| --- | ---: | ---: | ---: | --- |
| head | +0.46% | +0.80% | +0.75% | `out/compile.txt` |
| head2 | +0.23% | +0.44% | +0.43% | `out2/compile.txt` |
| head3 | +0.16% | +0.22% | +0.24% | `out5/compile.txt` |

At head3, main's and head3's cycle ranges overlap: 2,753M–2,774M against 2,760M–2,775M.

## Files

**Scripts:**
- `run.sh`: correctness, frames, run time and compile time at head.
- `run2.sh`: head2's identity, compile time, and `closures.lua` at four environment sizes.
- `run5.sh`: head3's identity and compile time.
- `shift.sh`: the code-shift experiment.
- `counters.sh`: the counters.
- `profile.sh`: cycle profiles.
- `stli.sh`: interlock-failure profiles.

**Data:** the `out*/` files named above, as the scripts wrote them.
