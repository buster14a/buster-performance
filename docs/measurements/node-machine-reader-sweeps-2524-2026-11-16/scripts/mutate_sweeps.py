#!/usr/bin/env python3
# mutate_sweeps.py ROOT N: applies single fault N to the reader-time C and X path (c_check_node_machine_reader.c, or the
# census's comparison), in place under ROOT/src/buster/compiler; prints "FILE\tNAME". N from 1; exits 1 past the last.
# Each fault is one textual change that keeps the unit compiling.
import sys
R = "c_check_node_machine_reader.c"
C = "c_check_node_census.c"
faults = [
    (R, "an initialization's root has a target though its conversion is empty",
     "        target = empty ? 0 : to;", "        target = empty ? to : to;"),
    (R, "an initialization's target keeps the object's qualifiers",
     "node_machine_reader_target(&typer->machine, type_unqualified(typer->graph.types[node]))", "node_machine_reader_target(&typer->machine, typer->graph.types[node])"),
    (R, "an initialization's root has no object",
     "    *object = declaration < reader->output->token_count ? reader->output->objects[declaration] : 0;", "    *object = declaration < reader->output->token_count ? 0 : 0;"),
    (R, "a string's object has nothing in its symbol's place",
     "            types->object_symbols[object] = object;\n        }\n    }\n    typer->strings = input->string_count;", "            types->object_symbols[object] = 0;\n        }\n    }\n    typer->strings = input->string_count;"),
    (R, "an object with a static declaration has nothing in its symbol's place",
     "                    symbols[object] = object;", "                    symbols[object] = 0;"),
    (R, "the root is evaluated as discarded",
     "NodeMachineRefusal swept = node_machine_contexts(machine, 0, target, object);", "NodeMachineRefusal swept = node_machine_contexts(machine, BUSTER_CHECK_LOWER_TEMPLATE_DISCARD, target, object);"),
    (R, "a tape is kept an entry short",
     "                            const uint32_t entries = taken ? machine->entry_count : 0;", "                            const uint32_t entries = taken && machine->entry_count != 0 ? machine->entry_count - 1 : 0;"),
    (R, "the kept classes are the entries' kinds",
     "memcpy(types->tape_classes + types->tape_count, machine->classes, entries);", "memcpy(types->tape_classes + types->tape_count, machine->kinds, entries);"),
    (R, "C and X run on an expression T refused",
     "                    if (sweeps && refusal == NODE_MACHINE_TAKEN)", "                    if (sweeps)"),
    (R, "no root is marked as swept",
     "                            types->refusals[root] |= BUSTER_NODE_FRONT_TYPED_SWEPT;", "                            types->refusals[root] |= 0;"),
    (R, "every root gets a target of its wrapper's type",
     "    *target = initialization && node < typer->graph.count ?", "    *target = node < typer->graph.count ?"),
    (C, "a global's entry is compared without the patch",
     "            const uint64_t patched = !global ? value : value < program->object_count ? program->object_symbols[value] : 0;", "            const uint64_t patched = value;"),
    (R, "a chunk's new strings are marked a chunk late",
     "    node_machine_settle(machine);\n    node_machine_reader_strings(typer, reader->output);\n    for (uint32_t pass = 0; pass < 2; pass += 1)",
     "    node_machine_settle(machine);\n    for (uint32_t pass = 0; pass < 2; pass += 1)",
     "            types->ticks += __rdtsc() - start;\n        }\n    }\n}",
     "            types->ticks += __rdtsc() - start;\n        }\n    }\n    node_machine_reader_strings(typer, reader->output);\n}"),
]
root, n = sys.argv[1], int(sys.argv[2])
if n < 1 or n > len(faults):
    sys.exit(1)
name_file, name = faults[n - 1][0], faults[n - 1][1]
pairs = faults[n - 1][2:]
path = root + "/src/buster/compiler/" + name_file
s = open(path).read()
for k in range(0, len(pairs), 2):
    a, b = pairs[k], pairs[k + 1]
    assert s.count(a) == 1, (n, name, s.count(a))
    s = s.replace(a, b)
open(path, "w").write(s)
print(name_file + "\t" + name)
