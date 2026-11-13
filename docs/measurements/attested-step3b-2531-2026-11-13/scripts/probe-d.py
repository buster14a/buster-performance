# probe-d.py SRC_DIR: probe-c.py's probes, and the clears split: the token columns' (p24 before), the names' arrays'
# (p26), the tags' and the rest (p27); and the block after the bindings split at the expressions' preparations (p28).
import sys, subprocess
src = sys.argv[1]
subprocess.check_call(['python3', sys.argv[0].replace('probe-d.py', 'probe-c.py'), src])
p = src + '/src/buster/compiler/c_check_input.c'
s = open(p).read()
def before(anchor, text):
    global s
    assert s.count(anchor) == 1, anchor[:60]
    s = s.replace(anchor, text + anchor, 1)
before('        memset(reader.parameter_seen, 0, (uint64_t)pp->table->count * sizeof(uint32_t));\n', '        PROBE(24);\n')
before('        memset(reader.tag_completions, 0xff, (uint64_t)types->tags.capacity * sizeof(uint32_t));\n', '        PROBE(26);\n')
s = s.replace('            PROBE(24);\n            check_input_output_none(input, &reader, count);', '            PROBE(27);\n            check_input_output_none(input, &reader, count);', 1)
before('                if (deferred == NULL || !check_deferred_constant_contexts(deferred, &reader))\n', '                PROBE(28);\n')
s = s.replace('for (int k = 0; k < 26; k += 1) fprintf(stderr, " p%d %llu"', 'for (int k = 0; k < 30; k += 1) fprintf(stderr, " p%d %llu"')
open(p, 'w').write(s)
