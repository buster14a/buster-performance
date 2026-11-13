// diag.c: the census-time diagnostic used for the breakdown (not in any commit). Pasted into
// c_check_node_machine_type.c's node_machine_type, in the action branch after the action_ops count, at main
// df85213e, and run with NM_DIAG=1 measure-node-machine --shadow --passes 0 ...; decode.py and groups.py read its lines
// (ops.txt: CheckOp's ordinals at that revision).
                if (getenv("NM_DIAG") != NULL && refusal == NODE_MACHINE_TAKEN)
                {
                    char line[512];
                    int at = snprintf(line, sizeof(line), "NMDIAG op=%u target=%u res=k%u/c%u/cat%u", (unsigned)op,
                                      graph->types != NULL && graph->types[node] != 0 ? (unsigned)type_kind(machine->types, type_strip_aligned(machine->types, graph->types[node])) : 99u,
                                      (unsigned)type_kind(machine->types, type_strip_aligned(machine->types, result.value.type)), (unsigned)result.value.constant_kind,
                                      (unsigned)result.value.category);
                    const uint32_t ops[3] = { a, b, c };
                    for (uint32_t k = 0; k < 3; k += 1)
                    {
                        if (ops[k] < r)
                        {
                            const uint32_t o = ops[k];
                            const TypeId t = machine->columns->value_types[o];
                            at += snprintf(line + at, sizeof(line) - (size_t)at, " o%u=k%u/c%u/cat%u/q%u/w%u/op%u/b%u", k,
                                           (unsigned)type_kind(machine->types, type_strip_aligned(machine->types, t)), (unsigned)node_machine_record_constant_kind(machine, o),
                                           (unsigned)node_machine_record_category(machine, o), (unsigned)(type_qualifiers(t) != 0),
                                           (unsigned)((machine->columns->standings[o] & BUSTER_NODE_MACHINE_WIDE) != 0), (unsigned)machine->columns->codes[o],
                                           (unsigned)(type_index(t) < BUSTER_NODE_MACHINE_KINDS));
                        }
                    }
                    fprintf(stderr, "%s\n", line);
                }
