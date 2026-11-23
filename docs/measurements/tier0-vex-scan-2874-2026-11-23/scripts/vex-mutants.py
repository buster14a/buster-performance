#!/usr/bin/env python3
# vex-mutants.py UPPER_STATE_C: the fault round of buster#2874's piece 3b. Each mutant of x86_vex_find (in a copy of
# x86_upper_state.c) is built into vex-harness.c (test-tier0's "VEX window" check, standalone, with x86_64_encoder.c)
# and run: "failures 0, exit 0" is a survivor. clang from CI's staged toolchain, the repository's src/ on -I.
import subprocess, sys, os
here = os.path.dirname(os.path.abspath(__file__))
base = open(sys.argv[1]).read()
src = os.environ.get('BUSTER_SRC', '/home/user/buster/src')
clang = os.environ.get('CLANG', 'clang')
mutants = [('none', None, None),
 ('blend halves', 'mask_blend_epi16(0xff00ff00u, pairs[0], pairs[1])', 'mask_blend_epi16(0x00ff00ffu, pairs[0], pairs[1])'),
 ('blend others', 'mask_blend_epi16(0xff00ff00u, pairs[2], pairs[3])', 'mask_blend_epi16(0x00ff00ffu, pairs[2], pairs[3])'),
 ('blend forms', 'mask_blend_epi16(0xffff0000u, halves, others)', 'mask_blend_epi16(0x0000ffffu, halves, others)'),
 ('pick word', '62, 54, 46, 38, 30, 22, 14, 6);', '62, 54, 46, 38, 30, 22, 14, 4);'),
 ('no inside', '& inside;', ';'),
 ('rows 191', '_mm512_set1_epi16(BUSTER_X86_VEX_ROWS)', '_mm512_set1_epi16(BUSTER_X86_VEX_ROWS - 1)'),
 ('swap tables', 'low_entry, third)', 'third, low_entry)'),
 ('one row subtraction', '    row = _mm512_mask_sub_epi16(row, _mm512_cmpge_epu16_mask(row, rows), row, rows);\n    // A row below', '    // A row below'),
 ('one quadword', '0x5555555555555555ull) * 3;', '0x5555555555555555ull) * 1;'),
 ('second half', 'quadwords >> (16 * p + 8)', 'quadwords >> (16 * p)'),
 ('bit 64', '_mm512_set1_epi16(64)), first, second)', '_mm512_set1_epi16(32)), first, second)'),
 ('full live', '_bzhi_u32(UINT32_MAX, count)', 'UINT32_MAX'),
 ('window base', 'table + BUSTER_X86_VEX_FIRST + 32 * k', 'table + BUSTER_X86_VEX_FIRST + 32 * k + 1'),
]
for name, old, new in mutants:
    s = base
    if old is not None:
        assert s.count(old) == 1, name
        s = s.replace(old, new)
    open('mutant.c', 'w').write(s)
    r = subprocess.run([clang, '-march=native', '-O1', '-I' + src, '-DUPPER="' + os.path.abspath('mutant.c') + '"', os.path.join(here, 'vex-harness.c'), '-o', 'harness'],
                       capture_output=True, text=True)
    if r.returncode != 0:
        print(name, 'not built'); continue
    p = subprocess.run(['./harness'], capture_output=True, text=True)
    print('%-22s failures %s exit %d' % (name, p.stdout.strip(), p.returncode))
