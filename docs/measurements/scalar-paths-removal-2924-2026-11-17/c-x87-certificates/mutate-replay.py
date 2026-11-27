"""Make a disposable mutation worktree at compiler commit f53e5a9c2.

Run from that compiler checkout with a mutation number (1..8), build the
ordinary Release compiler, and run build/compiler test-tier1-wide.
Use a fresh disposable worktree for each mutation.
"""
from pathlib import Path
import sys
p = Path('src/buster/compiler/x87_transfer.c')
rules = [
  ('annotations + first);','annotations);'),
  ('_bzhi_u64(UINT64_MAX, count)', '_bzhi_u64(UINT64_MAX, count - (count != 0))'),
  ('_mm512_test_epi8_mask(tags, _mm512_set1_epi8(BUSTER_X87_TRANSFER_RELOAD))', '_mm512_test_epi8_mask(tags, _mm512_set1_epi8(BUSTER_X87_TRANSFER_STORE))'),
  ('((transported >> home) & 1) == 0', 'true'),
  ('home == r && (annotations[token] & BUSTER_X87_TRANSFER_STORE) != 0 && memcmp', 'home == r && memcmp'),
  ('const uint32_t home = owner - first;', 'const uint32_t home = owner;'),
  ('candidates &= reads & ~repeated;', 'candidates &= ~reads & ~repeated;'),
  ('left >= 64 ? UINT64_MAX : _bzhi_u64(UINT64_MAX, left)', '_bzhi_u64(UINT64_MAX, left)')
]
number = int(sys.argv[1])
assert 1 <= number <= len(rules)
old, new = rules[number-1]
source = p.read_text()
assert old in source
p.write_text(source.replace(old,new))
