#!/usr/bin/env bash
# fixed.sh TSV...: around each fixed register's sequence (div, idiv, one-operand mul and imul, a shift by %cl), the
# stores of rax, rdx or rcx into the stack in the 5 instructions before it and the loads of them after it within 3
# (the consumer's saves of values live past it, tier1_emit_fixed), and a divisor moved into r11 right before it, by
# callgrind's counts (gap.c's rows, GAP_INSTRUCTIONS=1), per function; then the totals.
cat "$@" | awk -F'\t' '
$1 != "#ins" { next }
{ fn = $2; text = $7; n = $6 + 0 }
fn != prev { k = 0; pending = 0; prev = fn }
{
  if (pending > 0) {
    if (text ~ /^mov +-?(0x[0-9a-f]+)?\(%rsp\),%r(ax|dx|cx)$/) { loads[fn] += n; L += n }
    pending -= 1
  }
  seq = (text ~ /^(i?div|i?mul) +%[a-z0-9]+$/) || (text ~ /^(shl|shr|sar) +%cl,/)
  if (seq) {
    for (j = 1; j <= 5 && j <= k; j += 1) {
      t = win[(k - j) % 5]; c = cnt[(k - j) % 5]
      if (t ~ /^mov +%r(ax|dx|cx),-?(0x[0-9a-f]+)?\(%rsp\)$/) { stores[fn] += c; S += c }
    }
    if (k >= 1) { t = win[(k - 1) % 5]; if (t ~ /^mov +%r(ax|dx),%r11$/) { scratch[fn] += cnt[(k - 1) % 5]; R += cnt[(k - 1) % 5] } }
    for (j = 2; j <= 3 && j <= k; j += 1) { t = win[(k - j) % 5]; if (t ~ /^mov +%r(ax|dx),%r11$/) { scratch[fn] += cnt[(k - j) % 5]; R += cnt[(k - j) % 5] } }
    seqs[fn] += n; Q += n
    pending = 3
  }
  win[k % 5] = text; cnt[k % 5] = n; k += 1
}
END {
  for (f in seqs) if (stores[f] + loads[f] + scratch[f] > 10000) printf "%10.3f M saves %10.3f M loads %10.3f M divisors via r11 %10.3f M sequences  %s\n", stores[f]/1e6, loads[f]/1e6, scratch[f]/1e6, seqs[f]/1e6, f
  printf "total: %.3f M saves, %.3f M loads, %.3f M divisors via r11, over %.3f M sequences\n", S/1e6, L/1e6, R/1e6, Q/1e6
}' | sort -rn
