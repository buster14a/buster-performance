# Asm bodies' output addresses through the operand block — #1839 item 7, 2026-11-11

Question: buster#1839's item 7 proposed passing an asm body's register outputs' addresses as its call row's arguments,
instead of storing each into the operand block before the template and loading it back after. An input's round trip
through the block had failed store-to-load forwarding once a statement (buster-performance's
asm-bodies-1839-2026-11-09, `ls_bad_status2.stli_other`); this checks whether the outputs' does.

## Run

On `benchpress` (Ryzen 7 9700X), under the shared host lock, pinned with `taskset -c 2` (`perf.sh`):
- buster main `d86de4563c05` (`base.rev`, the Release build of asm-goto-body-1839-2026-11-11's base), Tier 0, and
  clang -O0 (host clang), each building `out.c`: 200 million iterations of two asm bodies, one of one `"=r"` output and
  one of two outputs through pointers (400 million statements);
- `perf stat` of cycles, instructions and `ls_bad_status2.stli_other`, one run each (`perf-*.csv`; both print the same
  result, `perf-*.out`).

`out.c`'s `leal` names its operands `%q1`, `%q2`: buster's assembler refuses the 32-bit address `(%eax,%ecx)` that clang
takes (an 0x67-prefixed form), a gap filed separately.

## Result

| build | cycles | instructions | stli_other |
|---|---|---|---|
| buster Tier 0 (addresses through the block) | 1,802,272,550 | 12,602,295,138 | 1,556,170 |
| clang -O0 | 1,802,317,408 | 10,202,297,120 | 6,745 |

The outputs' addresses forward: 1.56 million failures in 400 million statements (0.4%), and buster's Tier 0 code runs
in clang -O0's cycles. Passing the addresses as arguments has nothing measurable to win on Tier 0, so item 7 is not
implemented there; Tier 1's side is buster#2144.
