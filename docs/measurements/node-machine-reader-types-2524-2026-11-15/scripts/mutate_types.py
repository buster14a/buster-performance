#!/usr/bin/env python3
# mutate_types.py SRC_DIR: rewrites the reader-time machine's files with single faults, each selected at run time by
# BUSTER_TYPES_MUTATION=N (unset or 0: none). The caller keeps the unmutated files.
import sys, os
d = sys.argv[1]
M = 'node_machine_types_mutation()'
def edit(name, pairs):
    p = os.path.join(d, name)
    s = open(p).read()
    for number, old, new in pairs:
        assert s.count(old) == 1, (number, s.count(old), old[:80])
        s = s.replace(old, new)
    open(p, 'w').write(s)

edit('c_check_node_machine.c', [
    # 5: no object has a symbol at reader time
    (5, "                             object < machine->reader_objects && machine->reader_declarations[object] != BUSTER_CHECK_NONE;\n",
        f"                             {M} != 5 && object < machine->reader_objects && machine->reader_declarations[object] != BUSTER_CHECK_NONE;\n"),
    # 9: returns_twice forgotten at reader time
    (9, "                             (machine->reader_facts[object] & BUSTER_NODE_MACHINE_OBJECT_TWICE) != 0;\n",
        f"                             {M} != 9 && (machine->reader_facts[object] & BUSTER_NODE_MACHINE_OBJECT_TWICE) != 0;\n"),
])
edit('c_check_node_machine_reader.c', [
    # 1: a memory builtin's size is never asked
    (1, "        if (marked && memory)\n", f"        if (marked && memory && {M} != 1)\n"),
    # 2: an asm label is ignored
    (2, "        own = marked && !labelled;\n", f"        own = marked && (!labelled || {M} == 2);\n"),
    # 4: the graph's own contexts as they stand after the chunk
    (4, "    typer->graph = reader->output->graph;\n    typer->graph.contexts = front->shadow->contexts;\n    node_machine_settle(machine);\n",
        f"    typer->graph = reader->output->graph;\n    typer->graph.contexts = {M} == 4 ? reader->output->graph.contexts : front->shadow->contexts;\n    node_machine_settle(machine);\n"),
    # 6: the names that return twice aren't looked up
    (6, "            machine->twice_names[k] = identifiers != NULL ? intern_find(identifiers, (const uint8_t*)entry->name, entry->length) : 0;\n",
        f"            machine->twice_names[k] = identifiers != NULL && {M} != 6 ? intern_find(identifiers, (const uint8_t*)entry->name, entry->length) : 0;\n"),
    # 7: the range starts a node late
    (7, "                    const uint32_t first = inner + 1 - size;\n", f"                    const uint32_t first = inner + 1 - size + ({M} == 7 && size > 1);\n"),
    # 8: an initialization's INITIALIZE is a record
    (8, "                const bool initialization = front->ops[record] == CHECK_OP_INITIALIZE;\n",
        f"                const bool initialization = front->ops[record] == CHECK_OP_INITIALIZE && {M} != 8;\n"),
    # 10: an object's first static declaration, not its last
    (10, "                    machine->reader_declarations[object] = token;\n",
         f"                    if ({M} != 10 || machine->reader_declarations[object] == BUSTER_CHECK_NONE)\n                    {{\n                        machine->reader_declarations[object] = token;\n                    }}\n"),
    # 11: a settled type is complete everywhere
    (11, "        machine->type_complete_at[index] = (word & BUSTER_NODE_MACHINE_WORD_VALID) != 0 ? node_machine_complete_at(types, machine->graph, type) : UINT32_MAX;\n    }\n    if (count > machine->type_count)\n",
         f"        machine->type_complete_at[index] = {M} == 11 ? 0 : (word & BUSTER_NODE_MACHINE_WORD_VALID) != 0 ? node_machine_complete_at(types, machine->graph, type) : UINT32_MAX;\n    }}\n    if (count > machine->type_count)\n"),
    # 12: the tag that marks a jmp_buf isn't looked up
    (12, "        machine->twice_tag = identifiers != NULL ? intern_find(identifiers, (const uint8_t*)jmp_buf_tag, sizeof(jmp_buf_tag) - 1) : 0;\n",
         f"        machine->twice_tag = identifiers != NULL && {M} != 12 ? intern_find(identifiers, (const uint8_t*)jmp_buf_tag, sizeof(jmp_buf_tag) - 1) : 0;\n"),
    # 13: an asm label is never recorded
    (13, "                if (input->asm_capacity != 0 && attributes != NULL && check_input_attribute_of(attributes, CHECK_ATTRIBUTE_ASM_LABEL) != NULL)\n",
         f"                if ({M} != 13 && input->asm_capacity != 0 && attributes != NULL && check_input_attribute_of(attributes, CHECK_ATTRIBUTE_ASM_LABEL) != NULL)\n"),
    # 14: returns_twice is never recorded
    (14, "                    machine->reader_facts[object] |= (bits & BUSTER_CHECK_PROGRAM_ATTRIBUTE_RETURNS_TWICE) != 0 ? BUSTER_NODE_MACHINE_OBJECT_TWICE : 0;\n",
         f"                    machine->reader_facts[object] |= (bits & BUSTER_CHECK_PROGRAM_ATTRIBUTE_RETURNS_TWICE) != 0 && {M} != 14 ? BUSTER_NODE_MACHINE_OBJECT_TWICE : 0;\n"),
    # 15: a lean root's operand a record late
    (15, "                                         distance != 0 && distance < BUSTER_NODE_FRONT_FAR ? node_front_record_at(front, front->ordinals[record] - distance) :\n",
         f"                                         distance != 0 && distance < BUSTER_NODE_FRONT_FAR ? node_front_record_at(front, front->ordinals[record] - distance - ({M} == 15 && distance > 1)) :\n"),
])
edit('c_check_node_machine_type.c', [
    # 3: a type T makes at reader time gets no word
    (3, "    const TypeId pointer = type_pointer(machine->types, type);\n    if (machine->program == NULL)\n",
        f"    const TypeId pointer = type_pointer(machine->types, type);\n    if (machine->program == NULL && {M} != 3)\n"),
    # 19: a type the action makes at reader time gets no word
    (19, "    if (machine->program == NULL)\n    {\n        // The action may have made a type",
         f"    if (machine->program == NULL && {M} != 19)\n    {{\n        // The action may have made a type"),
])
edit('c_check_node_machine_front.c', [
    (0, "// What the shadow reports of the front (CheckInput.node_front), in the output's arena.\n",
        "static int node_machine_types_mutation_value = -1;\nstatic int node_machine_types_mutation(void)\n{\n    if (node_machine_types_mutation_value < 0)\n    {\n        const char* text = getenv(\"BUSTER_TYPES_MUTATION\");\n        node_machine_types_mutation_value = text != NULL ? atoi(text) : 0;\n    }\n    return node_machine_types_mutation_value;\n}\n// What the shadow reports of the front (CheckInput.node_front), in the output's arena.\n"),
    # 16: a call's arguments are no part of its subtree's size
    (16, "                                front->sizes[record] += front->sizes[argument];\n", f"                                front->sizes[record] += {M} == 16 ? 0 : front->sizes[argument];\n"),
    # 17: a kept record loses its subtree's size
    (17, "            front->sizes[kept] = front->sizes[record];\n", f"            front->sizes[kept] = {M} == 17 ? 1 : front->sizes[record];\n"),
    # 18: an operand taken twice counts twice
    (18, "                size += k == 0 || operand != a ? front->sizes[operand] : 0;\n", f"                size += k == 0 || operand != a || {M} == 18 ? front->sizes[operand] : 0;\n"),
])
print('mutations 1-19')
