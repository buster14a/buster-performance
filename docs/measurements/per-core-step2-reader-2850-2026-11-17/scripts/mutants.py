#!/usr/bin/env python3
# mutants.py: the faults of the fact words' kernel at reader time (buster#2850's step 2, --front-facts), one at a time,
# in a COPY of the tree (/home/user/mut2/tree): each is a text of the new code replaced by a faulty one, the Debug
# compiler built, and the node machine's tests run (test-checker part 5 of 8). A fault the tests don't fail is a
# survivor. Every text is checked to be unique before any build, and the file is restored after each fault.
#   mutants.py check        : every fault's texts are unique, applies and reverts
#   mutants.py run [NAME..] : the campaign (all the faults, or those named); results in /home/user/mut2/results.txt
import subprocess, sys, os, shutil, time

TREE = '/home/user/mut2/tree'
SRC = TREE + '/src/buster/compiler/'
F = 'c_check_node_machine_facts.c'
R = 'c_check_node_machine_reader.c'

MUTANTS = [
    # the expression's records in the front's arrays
    ('f-initialization-size', F,
     '    bool whole = size != 0 && count == (initialization ? size : size + 1) && size <= operand + 1 && operand + 1 - size >= front->made;',
     '    bool whole = size != 0 && count == (initialization ? size + 1 : size + 1) && size <= operand + 1 && operand + 1 - size >= front->made;'),
    ('f-root-size', F,
     '    bool whole = size != 0 && count == (initialization ? size : size + 1) && size <= operand + 1 && operand + 1 - size >= front->made;',
     '    bool whole = size != 0 && count == (initialization ? size : size) && size <= operand + 1 && operand + 1 - size >= front->made;'),
    ('f-kept-records-read', F,
     'size <= operand + 1 && operand + 1 - size >= front->made;',
     'size <= operand + 1 && operand + 1 - size >= front->made * 0;'),
    ('f-root-record', F,
     '        const uint32_t x = root ? record : start + r;',
     '        const uint32_t x = root ? start + r - 1 : start + r;'),
    ('f-root-distance', F,
     '        const uint32_t a = root ? 1 : front->distances[0][x];',
     '        const uint32_t a = root ? 2 : front->distances[0][x];'),
    ('f-root-distance-front', F,
     '        const uint32_t a = root ? 1 : front->distances[0][x];',
     '        const uint32_t a = front->distances[0][x];'),
    ('f-second-first', F,
     '        const uint32_t b = front->distances[1][x];',
     '        const uint32_t b = front->distances[0][x];'),
    ('f-third-second', F,
     '        const uint32_t c = front->distances[2][x];',
     '        const uint32_t c = front->distances[1][x];'),
    ('f-far-first-taken', F,
     '        whole = a != BUSTER_NODE_FRONT_FAR && b != BUSTER_NODE_FRONT_FAR && c != BUSTER_NODE_FRONT_FAR && a <= r && b <= r && c <= r;',
     '        whole = a != 0x100 && b != BUSTER_NODE_FRONT_FAR && c != BUSTER_NODE_FRONT_FAR && a <= r && b <= r && c <= r;'),
    # the leaves
    ('f-identifier-as-literal', F,
     '            if (category == BUSTER_NODE_FRONT_LEAF_IDENTIFIER)\n            {\n                const uint32_t number = node_facts_front_line(',
     '            if (category == BUSTER_NODE_FRONT_LEAF_STRING)\n            {\n                const uint32_t number = node_facts_front_line('),
    ('f-high-taken', F,
     '                const bool high = number != 0 && ((uint32_t)(facts->lines[4 * (uint64_t)number + 3] >> 32) & BUSTER_NODE_FACTS_HIGH) != 0;',
     '                const bool high = number != 0 && ((uint32_t)(facts->lines[4 * (uint64_t)number + 3] >> 32) & BUSTER_NODE_FACTS_REGISTER) != 0;'),
    ('f-high-always', F,
     '                kind = number != 0 && !high ? BUSTER_NODE_FACTS_IDENTIFIER : BUSTER_NODE_FACTS_LITERAL;',
     '                kind = number != 0 && high ? BUSTER_NODE_FACTS_IDENTIFIER : BUSTER_NODE_FACTS_LITERAL;'),
    ('f-identifier-entry', F,
     '                entry = kind == BUSTER_NODE_FACTS_IDENTIFIER ? number : 0;',
     '                entry = kind == BUSTER_NODE_FACTS_IDENTIFIER ? number + 1 : 0;'),
    ('f-literal-not-integer', F,
     '(facts->rows[index].flags & BUSTER_NODE_FACTS_INTEGER) != 0)\n            {\n                const uint32_t number = node_facts_front_integer(',
     '(facts->rows[index].flags & BUSTER_NODE_FACTS_INTEGER) == 0)\n            {\n                const uint32_t number = node_facts_front_integer('),
    ('f-literal-kind', F,
     '                const uint32_t number = node_facts_front_integer(facts, parser, token, type, index, front->leaf_integers[x]);\n                kind = number != 0 ? BUSTER_NODE_FACTS_LITERAL_LINE : BUSTER_NODE_FACTS_LITERAL;',
     '                const uint32_t number = node_facts_front_integer(facts, parser, token, type, index, front->leaf_integers[x]);\n                kind = number != 0 ? BUSTER_NODE_FACTS_LITERAL : BUSTER_NODE_FACTS_LITERAL;'),
    ('f-integer-zero-any', F,
     "    const bool zero = integer == 0 && parser->tokens.kinds[token] == PARSE_KIND_NUMBER && parser->tokens.names[token] == 0;",
     "    const bool zero = parser->tokens.kinds[token] == PARSE_KIND_NUMBER && parser->tokens.names[token] == 0;"),
    ('f-integer-zero-never', F,
     "        .flags = BUSTER_CHECK_ICE | (zero ? BUSTER_CHECK_LITERAL_ZERO : 0),",
     "        .flags = BUSTER_CHECK_ICE | (zero ? 0 : 0),"),
    ('f-integer-not-ice', F,
     "        .flags = BUSTER_CHECK_ICE | (zero ? BUSTER_CHECK_LITERAL_ZERO : 0),",
     "        .flags = (zero ? BUSTER_CHECK_LITERAL_ZERO : 0),"),
    ('f-integer-payload', F,
     "        .payload = integer,\n        .standing = BUSTER_NODE_MACHINE_STANDING(CHECK_RVALUE, CHECK_CONSTANT_INTEGER),",
     "        .payload = integer + 1,\n        .standing = BUSTER_NODE_MACHINE_STANDING(CHECK_RVALUE, CHECK_CONSTANT_INTEGER),"),
    ('f-string-not-static', F,
     "                        .flags = BUSTER_CHECK_STATIC_OBJECT | (object != 0 ? BUSTER_CHECK_NONNULL_ADDRESS : 0),",
     "                        .flags = (object != 0 ? BUSTER_CHECK_NONNULL_ADDRESS : 0),"),
    ('f-string-nullable', F,
     "                        .flags = BUSTER_CHECK_STATIC_OBJECT | (object != 0 ? BUSTER_CHECK_NONNULL_ADDRESS : 0),",
     "                        .flags = BUSTER_CHECK_STATIC_OBJECT | (object != 0 ? 0 : 0),"),
    ('f-string-rvalue', F,
     "                        .category = CHECK_LVALUE,\n                        .flags = BUSTER_CHECK_STATIC_OBJECT",
     "                        .category = CHECK_RVALUE,\n                        .flags = BUSTER_CHECK_STATIC_OBJECT"),
    ('f-value-line-floating', F,
     "        .payload = offset != 0 ? offset : floating ? significand : low,",
     "        .payload = offset != 0 ? offset : low,"),
    ('f-value-line-exponent', F,
     "        .exponent = floating ? (uint16_t)exponent : 0,\n    };\n    return !rare && fields <= 1;",
     "        .exponent = 0,\n    };\n    return !rare && fields <= 1;"),
    # the operators
    ('f-cast-root-not-void', F,
     "                const TypeId written = root ? BUSTER_TYPE_VOID : reader->query_types[token];",
     "                const TypeId written = reader->query_types[token];"),
    ('f-cast-always-void', F,
     "                const TypeId written = root ? BUSTER_TYPE_VOID : reader->query_types[token];",
     "                const TypeId written = root ? BUSTER_TYPE_VOID : BUSTER_TYPE_VOID;"),
    ('f-discard-kind', F,
     "                kind = !discard ? kind : facts->lean ? BUSTER_NODE_FACTS_DISCARD : BUSTER_NODE_FACTS_LOOKUP;",
     "                kind = !discard ? kind : facts->lean ? BUSTER_NODE_FACTS_DISCARD : kind;"),
    ('f-discard-code', F,
     "                code = discard ? BUSTER_NODE_FACTS_CODE_DISCARD : code;",
     "                code = discard ? code : code;"),
    ('f-member-name', F,
     "                entry = parser->tokens.names[token + 1];",
     "                entry = parser->tokens.names[token];"),
    ('f-return-type', F,
     "                entry = reader->return_types[token];",
     "                entry = reader->query_types[token];"),
    ('f-conditional-third', F,
     "            else if (op == CHECK_OP_CONDITIONAL)\n            {\n                entry = c;",
     "            else if (op == CHECK_OP_CONDITIONAL)\n            {\n                entry = b;"),
    ('f-call-count', F,
     "                const uint32_t argument_count = operands - 1;",
     "                const uint32_t argument_count = operands;"),
    ('f-call-argument-step', F,
     "                    distance += front->sizes[x - distance];",
     "                    distance += 1;"),
    ('f-call-argument-order', F,
     "                    set->arguments[set->argument_count + k] = (uint16_t)distance;",
     "                    set->arguments[set->argument_count + argument_count - 1 - k] = (uint16_t)distance;"),
    ('f-call-entry', F,
     "                entry = set->argument_count;\n                arguments = (uint16_t)argument_count;",
     "                entry = 0;\n                arguments = (uint16_t)argument_count;"),
    # the class and the stores
    ('f-class-first-operand', F,
     "                round = a != 0 ? node_facts_round(round, code, set->classes[w - a]) : round;",
     "                round = a != 0 ? node_facts_round(round, code, BUSTER_NODE_FACTS_NO_CLASS) : round;"),
    ('f-class-second-operand', F,
     "                round = b != 0 ? node_facts_round(round, code, set->classes[w - b]) : round;",
     "                round = b != 0 ? node_facts_round(round, code, BUSTER_NODE_FACTS_NO_CLASS) : round;"),
    ('f-class-third-operand', F,
     "                round = c != 0 ? node_facts_round(round, code, set->classes[w - c]) : round;",
     "                round = c != 0 ? node_facts_round(round, code, BUSTER_NODE_FACTS_NO_CLASS) : round;"),
    ('f-class-arguments', F,
     "                    round = node_facts_round(round, code, set->classes[w - set->arguments[entry + i]]);",
     "                    round = node_facts_round(round, code, BUSTER_NODE_FACTS_NO_CLASS);"),
    ('f-position-token', F,
     "            set->positions[w] = check_input_expression_end(reader, token);",
     "            set->positions[w] = token + 1;"),
    # a declaration's line at hand, and an enumerator's value at reader time
    ('f-line-type-unchecked', F,
     "    const bool settled = number != 0 && (TypeId)facts->lines[4 * (uint64_t)number] == input->declared_types[use] &&",
     "    const bool settled = number != 0 && (TypeId)facts->lines[4 * (uint64_t)number] != 0 &&"),
    ('d-enumerator-listed-at-reader-time', F,
     "    const bool listed = facts->enum_values == NULL;",
     "    const bool listed = facts->enum_values == NULL || facts->literal_capacity != 0;"),
    ('d-high-never', F,
     "                 (valued && (uint64_t)(value >> 64) != 0 ? BUSTER_NODE_FACTS_HIGH : 0),",
     "                 (valued && (uint64_t)(value >> 64) != 0 ? 0 : 0),"),
    # the driver
    ('e-not-given-not-copied', F,
     "        memcpy(set->kinds + base, facts->kinds + base, count);",
     "        memset(set->kinds + base, 0, count);"),
    ('e-settle-skipped', F,
     "    // The rows of the types made since: the walk's, and T's own derivations' for this expression.\n    node_facts_settle(facts);",
     "    // The rows of the types made since: the walk's, and T's own derivations' for this expression.\n    if (facts->record_count > 100000000u)\n    {\n        node_facts_settle(facts);\n    }"),
    ('l-again-argument-places', F,
     "                state->front.argument_count = state->argument_bases[e];",
     "                state->front.argument_count = state->front.argument_count;"),
    ('l-made-counts-wanted', F,
     "                    counts[NODE_FACTS_COUNT_MADE] += wanted && made;",
     "                    counts[NODE_FACTS_COUNT_MADE] += wanted;"),
    ('l-taken-counts-all', F,
     "                counts[NODE_FACTS_COUNT_TAKEN_RECORDS] += taken;",
     "                counts[NODE_FACTS_COUNT_TAKEN_RECORDS] += 1;"),
    ('l-literal-lines-kept', F,
     "    facts->windows[0] = 0;\n    facts->literal_count = 0;\n    state->front.argument_count = 0;",
     "    facts->windows[0] = 0;\n    state->front.argument_count = 0;"),
    ('r-whole-machine-ignores-tests', R,
     "tested && sweeps && verdict == 0 && swept == NODE_MACHINE_TAKEN);",
     "tested && sweeps && swept == NODE_MACHINE_TAKEN);"),
    ('r-whole-machine-ignores-sweeps', R,
     "tested && sweeps && verdict == 0 && swept == NODE_MACHINE_TAKEN);",
     "tested && sweeps && verdict == 0);"),
    ('r-kernel-without-lean', R,
     "(options & BUSTER_NODE_READER_FACTS) != 0 && (reader->pp->options.node_front & BUSTER_NODE_FRONT_LEAN) != 0)",
     "(options & BUSTER_NODE_READER_FACTS) != 0 && (reader->pp->options.node_front & BUSTER_NODE_FRONT_LEAN) == 0)"),
]

def read(path):
    return open(path).read()

def check():
    ok = True
    names = set()
    for name, f, old, new in MUTANTS:
        s = read(SRC + f)
        if name in names:
            print('DUPLICATE NAME', name); ok = False
        names.add(name)
        if s.count(old) != 1:
            print(name, 'old text occurs', s.count(old)); ok = False
        if old == new or s.count(new) != 0:
            print(name, 'new text is not new', s.count(new)); ok = False
        t = s.replace(old, new)
        if t.count(new) != 1 or t.replace(new, old) != s:
            print(name, 'does not revert'); ok = False
    print(len(MUTANTS), 'faults;', 'all unique' if ok else 'PROBLEMS')
    return ok

def run(only):
    if not check():
        sys.exit(1)
    results = open('/home/user/mut2/results.txt', 'a')
    for name, f, old, new in MUTANTS:
        if only and name not in only:
            continue
        path = SRC + f
        saved = '/home/user/mut2/saved.c'
        shutil.copyfile(path, saved)
        s = read(path)
        open(path, 'w').write(s.replace(old, new))
        start = time.time()
        build = subprocess.run(['./build.sh', '--config', 'Debug'], cwd=TREE, capture_output=True, text=True)
        built = build.returncode == 0
        verdict = 'NOT BUILT'
        detail = ''
        if built:
            try:
                test = subprocess.run(['./build/compiler', 'test-checker', '--seed', '133', '--part', '5/8'], cwd=TREE, capture_output=True, text=True, timeout=900)
                failed = test.returncode != 0
                lines = [l for l in (test.stderr + test.stdout).splitlines() if 'test-checker' in l and 'retained' not in l]
                detail = ' | '.join(l[:150] for l in lines[:2])
                verdict = 'caught' if failed else 'SURVIVED'
            except subprocess.TimeoutExpired:
                verdict = 'caught (timeout)'
        else:
            detail = (build.stderr + build.stdout)[-300:].replace('\n', ' ')
        shutil.copyfile(saved, path)
        line = f'{name}: {verdict} ({time.time() - start:.0f} s) {detail}'
        print(line, flush=True)
        results.write(line + '\n'); results.flush()
    subprocess.run(['./build.sh', '--config', 'Debug'], cwd=TREE, capture_output=True, text=True)
    print('campaign done', flush=True)
    results.write('campaign done\n'); results.flush()

if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == 'check':
        sys.exit(0 if check() else 1)
    run(sys.argv[2:] if len(sys.argv) > 2 else [])
