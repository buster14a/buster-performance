import subprocess, sys, os
tree = os.path.expanduser(os.environ.get('BUSTER_TREE', '~/.cache/claude-2850/wt-alone'))
src = tree + '/src/buster/compiler/'
faults = [
    ('an operand written as the front\'s record, not the graph\'s node', 'c_check_node_machine_alone.c',
     "operands[k] = operand != BUSTER_NODE_FRONT_UNKNOWN && operand < record ? front->nodes[operand] : BUSTER_CHECK_NONE;",
     "operands[k] = operand != BUSTER_NODE_FRONT_UNKNOWN && operand < record ? operand : BUSTER_CHECK_NONE;"),
    ('a leaf without its object', 'c_check_node_machine_alone.c', ".object = front->leaf_objects[record],", ".object = 0,"),
    ('a leaf without its constant\'s kind', 'c_check_node_machine_alone.c', ".constant_kind = (CheckConstantKind)front->leaf_constants[record],", ".constant_kind = (CheckConstantKind)0,"),
    ('a call without its arguments', 'c_check_node_machine_alone.c', "view->argument_counts[node] = argument_count;", "view->argument_counts[node] = 0;"),
    ('a call\'s arguments as the front\'s records', 'c_check_node_machine_alone.c',
     "view->argument_nodes[view->argument_count + i] = argument < record ? front->nodes[argument] : BUSTER_CHECK_NONE;",
     "view->argument_nodes[view->argument_count + i] = argument < record ? argument : BUSTER_CHECK_NONE;"),
    ('a record without its type', 'c_check_node_machine_alone.c', "view->types[node] = front->types[record];", "view->types[node] = 0;"),
    ('a record without its member', 'c_check_node_machine_alone.c', "view->members[node] = front->members[record];", "view->members[node] = 0;"),
    ('one root kept a token', 'c_check_node_machine_alone.c', "while (*link != 0 && *link - 1 != root)", "while (false && *link != 0 && *link - 1 != root)"),
    ('a body\'s lost root not counted', 'c_check_node_machine_alone.c',
     "verdict = !room ? BUSTER_NODE_ALONE_BODY_ROOM : node_alone_lost(alone->report) != lost ? BUSTER_NODE_ALONE_BODY_LEFT : verdict;",
     "verdict = !room ? BUSTER_NODE_ALONE_BODY_ROOM : false && node_alone_lost(alone->report) != lost ? BUSTER_NODE_ALONE_BODY_LEFT : verdict;"),
    ('a declaration\'s discard taken for a root of the body\'s verdict', 'c_check_node_machine_alone.c',
     "if (verdict == BUSTER_NODE_ALONE_BODY_WHOLE && !node_machine_reader_discard(reader, front, record, operand))",
     "if (verdict == BUSTER_NODE_ALONE_BODY_WHOLE)"),
    ('the tests reading the reader\'s graph', 'c_check_node_machine_alone.c', "node_census_reader_input(alone->tests, &alone->input);", "node_census_reader_input(alone->tests, reader->output);"),
    ('the reader\'s graph given to the machine for the piece\'s', 'c_check_node_machine_alone.c', "            typer->graph = alone->view;\n", "            typer->graph = reader->output->graph;\n"),
    ('a literal with a warning\'s event made a record (the walk then warns at a taken root)', 'c_check_node_machine_front.c',
     "plain = plain && result->valid && result->bit_width == 0 && !result->resource && !check_literal_warning_event(result, token, &event);",
     "plain = plain && result->valid && result->bit_width == 0 && !result->resource && (check_literal_warning_event(result, token, &event) || true);"),
    ('a character constant of several characters made a record', 'c_check_node_machine_front.c', "plain = result->valid && !escaped && result->characters <= 1;", "plain = result->valid && !escaped;"),
    ('a fault\'s node digested as the graph\'s', 'c_check_node_machine_reader.c',
     "digest = node_machine_mix(digest, (uint64_t)fault_record << 32 | value.object_bit_offset);", "digest = node_machine_mix(digest, (uint64_t)(fault_record - fault_record + value.fault_node) << 32 | value.object_bit_offset);"),
]
only = [int(a) for a in sys.argv[1:]]
caught = 0
for i, (name, file, old, new) in enumerate(faults):
    if only and i not in only: continue
    path = src + file
    text = open(path).read()
    if text.count(old) != 1:
        print(f'{i:2} NOT APPLIED ({text.count(old)} places): {name}', flush=True); continue
    open(path, 'w').write(text.replace(old, new))
    env = dict(os.environ, CORES_TITLE='#2850: the machine alone, a fault a build', CORES_LINK='https://github.com/buster14a/buster/issues/2850')
    b = subprocess.run(['cores', '-n', '4', '--', './build.sh', '--config', 'Develop', '--target', 'compiler'], cwd=tree, env=env, capture_output=True, text=True)
    if b.returncode != 0:
        print(f'{i:2} DID NOT BUILD: {name}', flush=True)
    else:
        t = subprocess.run(['./build/cmake/native/Develop/compiler', 'test-checker', '--part', '45/64'], cwd=tree, capture_output=True, text=True, timeout=1500)
        lines = [l for l in (t.stdout + t.stderr).split('\n') if 'node-alone' in l]
        seen = t.returncode != 0
        caught += seen
        print(f"{i:2} {('caught' if lines else 'caught (the run faults, status ' + str(t.returncode) + ')') if seen else 'NOT CAUGHT (status ' + str(t.returncode) + ')'}: {name}" + (': ' + lines[0][:330] if lines else ''), flush=True)
    open(path, 'w').write(text)
print(f'caught {caught}', flush=True)
