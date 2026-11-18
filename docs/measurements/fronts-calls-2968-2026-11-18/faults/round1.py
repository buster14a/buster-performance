#!/usr/bin/env python3
# faults3.py: the faults of #2968's and #2970's fixes, one at a time, in the copy /home/user/mut13/tree0: a text of the
# new code replaced by a faulty one, the Debug compiler built, and the node machine's tests run (test-checker part 5 of
# 8). A fault the tests don't fail is a survivor. Results in /home/user/mut13/round3-results.txt.
import subprocess, time
TREE = '/home/user/mut13/tree0'
SRC = TREE + '/src/buster/compiler/'
FAULTS = [
    ('d-type-row', 'c_check_node_machine_facts.c', 'const TypeId type = designator ? type_unqualified(records[a].type) : node_facts_pointee(records, a, row);', 'const TypeId type = designator && records == NULL ? type_unqualified(records[a].type) : node_facts_pointee(records, a, row);'),
    ('d-word-row', 'c_check_node_machine_facts.c', 'const uint32_t word = designator ? row->word : row->element_word;', 'const uint32_t word = designator && records == NULL ? row->word : row->element_word;'),
    ('d-type-qualified', 'c_check_node_machine_facts.c', 'designator ? type_unqualified(records[a].type) :', 'designator ? records[a].type :'),
    ('d-kind-pointer', 'c_check_node_machine_facts.c', 'const bool designator = (uint8_t)(records[a].word >> 16) == BUSTER_TYPE_KIND_FUNCTION;', 'const bool designator = (uint8_t)(records[a].word >> 16) == BUSTER_TYPE_KIND_POINTER;'),
    ('d-kind-always', 'c_check_node_machine_facts.c', 'const bool designator = (uint8_t)(records[a].word >> 16) == BUSTER_TYPE_KIND_FUNCTION;', 'const bool designator = (uint8_t)(records[a].word >> 16) != BUSTER_TYPE_KIND_NONE;'),
    ('d-category-word', 'c_check_node_machine_facts.c', 'const CheckCategory category = (uint8_t)(word >> 16) == BUSTER_TYPE_KIND_FUNCTION ? CHECK_FUNCTION : CHECK_LVALUE;\n        uint32_t flags = pointer.flags;', 'const CheckCategory category = (uint8_t)(row->element_word >> 16) == BUSTER_TYPE_KIND_FUNCTION ? CHECK_FUNCTION : CHECK_LVALUE;\n        uint32_t flags = pointer.flags;'),
    ('f-front-unit', 'c_check_node_machine_front.c', 'left = count == BUSTER_NODE_FRONT_UNKNOWN || count == 0 || input->kr_parameter_count != 0 ||', 'left = count == BUSTER_NODE_FRONT_UNKNOWN || count == 0 || input->kr_parameter_count != 0 || input->no_builtin ||'),
    ('f-flat-unit', 'c_check_node_machine_flat.c', 'const bool refused = input->kr_parameter_count != 0;', 'const bool refused = input->kr_parameter_count != 0 || input->no_builtin;'),
    ('f-library-unmasked', 'c_check_node_machine_front.c', 'library = library != 0 && check_input_no_builtin(reader, reader->parser->tokens.names[use], use) ? 0 : library;', 'library = library != 0 && reader == NULL ? 0 : library;'),
]
out = open('/home/user/mut13/round3-results.txt', 'w')
for name, f, a, b in FAULTS:
    text = open(SRC + f).read()
    assert text.count(a) == 1, (name, text.count(a))
    open(SRC + f, 'w').write(text.replace(a, b))
    t0 = time.time()
    build = subprocess.run(['./build.sh', '--config', 'Debug', '--jobs', '3'], cwd=TREE, capture_output=True, text=True)
    if build.returncode != 0:
        verdict = 'NOT BUILT ' + (build.stdout + build.stderr)[-300:].replace('\n', ' ')
    else:
        test = subprocess.run(['./build/compiler', 'test-checker', '--seed', '133', '--part', '5/8'], cwd=TREE, capture_output=True, text=True, timeout=900)
        first = (test.stderr.strip().split('\n') or [''])[0][:260]
        verdict = ('caught' if test.returncode != 0 else 'SURVIVED') + ' [status %d] %s' % (test.returncode, first)
    out.write('%s: %s (%d s)\n' % (name, verdict, time.time() - t0)); out.flush()
    open(SRC + f, 'w').write(text)
subprocess.run(['./build.sh', '--config', 'Debug', '--jobs', '3'], cwd=TREE, capture_output=True, text=True)
out.write('done\n'); out.close()
