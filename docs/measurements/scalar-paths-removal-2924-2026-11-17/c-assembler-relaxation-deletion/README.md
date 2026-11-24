# C11b: the assembler keeps one path, the scalar relaxation and the vector rest (#2924)

The owner's rule 1 (2026-11-23, buster#2924 7112387760): where the scalar twin wins at every size it becomes the one
implementation. The relaxation's scalar arms made layout 0.1% to 3.8% faster than its 16-fragment vector arms on every
input ([`../c-assembler-gate`](../c-assembler-gate), 6993414431), and the vector path won every other phase (6993324438).
buster branch `claude/2924-assembler`: tests commit `7aced79b` (base), deletion `b7fd2821`, fixtures `9ee3ac23` (head).
#3429 asks for a vectorized relaxation that wins.

## What changed

- `asm_relax_first` and `asm_relax_place` keep their running sums; the prefix-network arms and `asm_prefix16` go.
- `asm_word_length` keeps its 64-byte scan, which the rare-path lexer now takes too.
- `AsmOptions.vectorized` and `assemble --scalar` go; `benchmark-assembler` times its one path.
- The tests stop comparing the two paths: `BUSTER_ASM_TEST_DIGEST` (recorded while both agreed) and GNU as and clang
  stay as the oracles.

## Mutants (this container, AVX-512, `test-assembler`; cross-check where noted)

[`asm-mutants.py`](asm-mutants.py), logs in [`mutants/`](mutants). This container's GNU as is 2.42, whose padding differs
from 2.47's, so `--cross-check` has 5 failures on the unmutated code; a mutant counts as killed there by a sixth.

| Mutant | Killed by |
| --- | --- |
| first-offset-dropped | test-assembler, 31 failures |
| first-leb-events-dropped | test-assembler, 1 |
| first-region-shifted | `--cross-check`, a new `.text.forward` difference from GNU as |
| first-tail-zero | test-assembler, 120 |
| first-limit-unchecked | survived; killed by the new fixture (a 260 MiB section must fail at the crossing fill) |
| place-last-skipped | test-assembler, 1 |
| place-sizes-kept | test-assembler, 63 |
| place-offset-stale | test-assembler, 1 |
| word-long-cut | equivalent: a 63-byte step re-reads a word byte and ends at the same count |
| word-dot-dropped, word-digits-dropped | survived; killed by the new fixture (a 100-byte label with `.` and `9` past 64 bytes), 64 failures each |

`test-first-limit-unchecked.log`, `test-word-*.log` are the runs after the fixtures.

## The 9700X deletion run

[`asm-deletion.sh`](asm-deletion.sh), [`asm-parent.sh`](asm-parent.sh), [`logs.tar.gz`](logs.tar.gz). Release, CPU 2,
under the lock.

**Objects:** `assemble` of gcc's `-O2 -S` of sqlite3.c (AT&T), clang's `-O2 -masm=intel -S` of sqlite3.c and clang's
`-O2 -S` of Lua's `lvm.c`: base and head give byte-identical objects.

**Whole processes** (`ab`, three rounds around `time-runs --runs 5`), head against base, user cycles:

| Input | Rounds | Instructions |
| --- | --- | --- |
| sqlite3.c by gcc | +0.94%, +1.19%, +0.17% | 1,715.26 M → 1,712.31 M |
| sqlite3.c by clang | +1.50%, +1.51%, +0.38% | 1,765.26 M → 1,762.22 M |
| `lvm.c` | +0.77%, +0.79%, +0.64% | 41.56 M → 41.50 M |

**Placement control:** a clean build of the parent (main `968a085f`) timed beside them, three rounds, user cycles
against the parent:

| Input | base | head |
| --- | --- | --- |
| sqlite3.c by gcc | −0.78%, −0.12%, −0.29% | −0.39%, +0.24%, −0.10% |
| sqlite3.c by clang | −1.20%, −0.64%, −0.61% | +0.64%, +0.59%, +0.40% |

Base and the parent differ only by test code, and read up to 1.2% apart: the spread is placement. Head falls inside it
and retires 3 M fewer instructions. Its wait4 peak is 8.4 MB higher, with 25 fewer minor faults, on both sqlite3.c inputs; I
haven't traced that (wait4's peak includes the executable's own mapping).

**Phases** (`benchmark-assembler --functions 2048`, three runs each, ms; base's vector row against head), layout:

| Workload | base | head |
| --- | --- | --- |
| mixed | 2.239, 2.296, 2.369 | 2.274, 2.274, 2.234 |
| registers | 2.604, 2.496, 2.461 | 2.497, 2.506, 2.690 |
| simd | 3.013, 3.012, 3.008 | 3.042, 3.036, 3.046 |
| att | 2.232, 2.237, 2.221 | 2.244, 2.247, 2.220 |

Layout is at parity but on the SIMD workload (+1%, which has no branches to relax: one alignment per function). The
knob gate, which compared the arms inside one executable, is the decision's evidence; these runs check that the deletion
lost nothing beyond placement.

**Correctness blocks** of `tools/ci/correctness.tests` (the assembly frontends, the assembly sink, the `.s`/`.S` file
`-c`, GNU inline assembly's fixtures) through `parallel` on the deletion: all pass ([`asm.log`](logs.tar.gz)).

**Before the PR,** on the head merged with main (`20d17537c`), 9700X: Release build, `check-call-graph`,
`-fsyntax-only -Wall -Werror` of `main.c` (also with `BUSTER_COMPLETE_DRIVER`) and the same correctness blocks all pass.
`test-assembler` and `test-assembly-output` pass under `BUSTER_SANITIZER=undefined`, `address` and `memory` builds
(this container).
