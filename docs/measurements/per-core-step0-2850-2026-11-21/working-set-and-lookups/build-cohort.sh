set -eu
cd "$(dirname "$0")"
python3 - <<'PY'
from pathlib import Path
s=Path('tools/single.c').read_text()
s=s.replace('        const uint32_t end = unit->roots[end_root - 1] + 1;','''        // Stop on a complete expression whose end also aligns to a vector block, when one is nearby.
        const uint32_t nominal=end_root;
        const uint64_t limit=(uint64_t)unit->roots[nominal-1]+1024;
        while (end_root<unit->root_count && (unit->roots[end_root-1]&63)!=63 && unit->roots[end_root]<limit) ++end_root;
        if(end_root<unit->root_count && (unit->roots[end_root-1]&63)!=63) end_root=nominal;
        const uint32_t end = unit->roots[end_root - 1] + 1;''')
s=s.replace('(uint64_t)window + longest + 63', '(uint64_t)window + longest + 1024 + 63')
Path('tools/aligned.c').write_text(s)
PY
