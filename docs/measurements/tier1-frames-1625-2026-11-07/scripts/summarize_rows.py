#!/usr/bin/env python3
# #1625: patch_1625.py's per-function lines summed: the frames' bytes, the general call-save rows' bytes (8 each) and
# the most those rows could shrink to shared among themselves (the bound: the most registers any one call saves, which
# the patch computes in the CFG consumer alone; a straight-line function's is taken as 1, the least a function with rows
# needs, so that the saving stays an upper bound), the spill slots, and the callee-saved pushes. Usage:
# summarize_rows.py FILE...
import re, sys
for path in sys.argv[1:]:
    rows = []
    for line in open(path):
        if line.startswith('measure-1625'):
            rows.append({k: int(v) for k, v in re.findall(r'(\w+)=(\d+)', line)})
    n = len(rows)
    frame = sum(r['frame'] for r in rows)
    call_rows = sum(r['call_rows'] for r in rows)
    bound = sum(max(r['bound'], 1) if r['call_rows'] != 0 else 0 for r in rows)
    with_rows = sum(1 for r in rows if r['call_rows'] != 0)
    shrinkable = sum(1 for r in rows if r['call_rows'] > max(r['bound'], 1))
    spills = sum(r['spills'] for r in rows)
    pushed = sum(r['pushed'] for r in rows)
    vectors = sum(r['vector_rows'] for r in rows)
    masks = sum(r['mask_rows'] for r in rows)
    # With spill slots too (8 bytes each, as general values'): a function's rows can't shrink below none, nor past its
    # bound less what its spill slots could take of it.
    both = sum(min(r['call_rows'], r['call_rows'] - max(r['bound'], 1) + r['spills']) for r in rows if r['call_rows'] != 0)
    print('    sharing with the spill slots too: at most %d bytes (%.1f%% of the frames)' % (8 * both, 100.0 * 8 * both / max(frame, 1)))
    largest = sorted(rows, key=lambda r: r['call_rows'] - max(r['bound'], 1), reverse=True)[:3]
    print('%s: %d functions; frames %d bytes; general call-save rows %d (%d bytes, %.1f%% of the frames) in %d functions, '
          'shared among themselves at least %d (%d bytes): at most %d bytes (%.1f%% of the frames) to save, in %d functions; '
          'vector rows %d, mask rows %d; spill slots %d; callee-saved pushes %d' %
          (path, n, frame, call_rows, 8 * call_rows, 100.0 * 8 * call_rows / max(frame, 1), with_rows, bound, 8 * bound,
           8 * (call_rows - bound), 100.0 * 8 * (call_rows - bound) / max(frame, 1), shrinkable, vectors, masks, spills, pushed))
    for r in largest:
        print('    a frame of %d bytes: %d rows, bound %d, %d calls' % (r['frame'], r['call_rows'], r['bound'], r['calls']))
