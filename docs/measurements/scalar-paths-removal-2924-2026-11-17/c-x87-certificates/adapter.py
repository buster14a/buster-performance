from pathlib import Path
import sys
d=Path('src/buster/compiler')
kind=sys.argv[1]
for file,anchor,end,rows,start,finish,tier in [
 ('tier0.c','static void tier0_x87_transfers(', '// Follow a constant','count','        const uint64_t mark = scratch->length;','        arena_pop_to(scratch, mark);','0'),
 ('tier1_emit_cfg.c','static void tier1_emit_cfg_x87_transfers(', 'static Tier1EmitError tier1_emit_cfg_records','records','    const uint64_t mark = scratch->length;','    arena_pop_to(scratch, mark);','1')]:
 p=d/file;s=p.read_text();a=s.index(anchor);b=s.index(end,a);t=s[a:b]
 t=t.replace(start,start+'\n    _mm_lfence(); const uint64_t measurement_start = __rdtsc(); _mm_lfence();',1)
 t=t.replace(finish,finish+'\n    _mm_lfence(); const uint64_t measurement_end = __rdtsc(); _mm_lfence();\n    '+('if (emitted->prepared.x87_count != 0) ' if tier=='1' else '')+'fprintf(stderr,"x87-adapter '+tier+' %u %lu\\n", '+rows+', measurement_end-measurement_start);',1)
 if kind=='scalar':
  t=t.replace('tokens, eligible, boundaries, true);','tokens, eligible, boundaries, false);')
 p.write_text(s[:a]+t+s[b:])
