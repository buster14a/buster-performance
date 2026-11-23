#!/usr/bin/env python3
# passes.py CHAINS IPS...: Tier 0's samples by pass: each sample's inline chain walked from its innermost frame out to
# the first function named in PASSES (buster#2874). Samples in no Tier 0 frame are counted apart.
import collections, sys
PASSES = ['tier0_vector_labels', 'tier0_vector_values', 'tier0_vector_fuse', 'tier0_operation_effects', 'tier0_vector_depths',
          'tier0_raw_effects', 'tier0_select_vector_entries', 'tier0_select_vector_memory', 'tier0_select_deep',
          'tier0_count_references_vector', 'tier0_direct_references', 'tier0_assign_homes', 'tier0_layout_frame',
          'tier0_count_tail_finish', 'tier0_frame_alignment_vector', 'tier0_frame_input_valid',
          'tier0_call_memo_find', 'tier0_call_memo_write', 'tier0_count_deferred', 'tier0_count_call', 'tier0_count_prologue',
          'tier0_count_epilogue', 'tier0_measure_vector_entries', 'tier0_push_output', 'tier0_emit_prologue', 'tier0_emit_epilogue',
          'tier0_emit_call', 'tier0_emit_deferred_entry', 'tier0_emit_deferred', 'tier0_emit_vector_entries', 'tier0_copy_choices',
          'x86_choose_forms', 'tier0_apply_choices_vector', 'tier0_label_records', 'tier0_tail_records', 'tier0_push_entries',
          'tier0_generate', 'tier0_compile_entries', 'tier0_compile_upper', 'tier0_vex', 'x86_upper_dirty']
counts = collections.Counter()
for path in sys.argv[2:]:
    for line in open(path):
        counts[int(line.split()[0], 16)] += 1
frames = {}
cur = None
for line in open(sys.argv[1]):
    line = line.rstrip('\n')
    if line.startswith('0x'):
        a, rest = line.split(': ', 1); cur = int(a, 16); frames[cur] = [rest.split(' at ')[0]]
    elif line.startswith(' (inlined by) '):
        frames[cur].append(line[14:].split(' at ')[0])
by = collections.Counter()
inner = collections.defaultdict(collections.Counter)
for a, n in counts.items():
    chain = [f.replace('.buster_split', '') for f in frames.get(a, ['??'])]
    hit = None
    for f in chain:
        if f in PASSES:
            hit = f
            break
    if hit is None and any(f.startswith('tier0') for f in chain):
        hit = 'other tier0: ' + chain[-1]
    if hit is not None:
        by[hit] += n
        inner[hit][chain[0]] += n
total = sum(by.values())
print('tier0 samples', total)
for k, n in by.most_common(60):
    tops = ', '.join('%s %d' % kv for kv in inner[k].most_common(3))
    print('%6d %5.1f%%  %-34s %s' % (n, 100.0 * n / total, k, tops))
