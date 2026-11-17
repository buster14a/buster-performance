# Mutants for #2924's dominators deletion: the PR tree's tests (no twin) must kill each. o1 and t1 change values that
# only the default seed's frozen digests read (rpo_index's values, children order); f2 and l2 bite past 512 blocks.
D = 'src/buster/compiler/dominators.c'
MUTANTS = [
    ('s1-evaluate-stops-early', D, '} while (links[top].ancestor >= processed);', '} while (links[top].ancestor > processed);'),
    ('s2-idom-is-semi', D, '        uint32_t candidate = parents[number];', '        uint32_t candidate = semi[number];'),
    ('s3-links-least-parent', D, '            .least = number,', '            .least = parents[number],'),
    ('o1-rpo-index-reversed', D, 'result->rpo_index[result->rpo[i]] = i;', 'result->rpo_index[result->rpo[i]] = finished - 1 - i;'),
    ('o2-rpo-half-reversed', D, 'for (uint32_t i = 0; i < finished / 2; i += 1)', 'for (uint32_t i = 0; i < finished / 4; i += 1)'),
    ('t1-children-reversed', D, 'result->tree_children[cursors[parent]] = block;', 'result->tree_children[result->tree_offsets[(uint64_t)parent + 1] - 1 - (cursors[parent] - result->tree_offsets[parent])] = block;'),
    ('t2-subtree-end-short', D, 'result->subtree_end[frame->block] = entered;', 'result->subtree_end[frame->block] = entered - 1;'),
    ('f1-entry-frontier-stop', D, 'const uint32_t stop = block == cfg->entry ? BUSTER_DOMINATOR_NONE : result->idom[block];', 'const uint32_t stop = result->idom[block];'),
    ('f2-frontier-clear-half', D, 'memset(result->frontiers, 0, (uint64_t)cfg->block_count * result->row_words * sizeof(uint64_t));', 'memset(result->frontiers, 0, (uint64_t)cfg->block_count * 8 * sizeof(uint64_t));'),
    ('c1-ancestor-interval', D, 'dfs_begin[block] < dfs_end[target];', 'dfs_begin[block] <= dfs_end[target];'),
    ('c2-unreachable-flagged', D, 'component[block] == BUSTER_DOMINATOR_NONE ? 0 : flags[component[block]];', 'component[block] == BUSTER_DOMINATOR_NONE ? 1 : flags[component[block]];'),
    ('l1-unreachable-in-body', D, 'if (result->rpo_index[source] != BUSTER_DOMINATOR_NONE && !dominators_bit(body, source))', 'if (!dominators_bit(body, source))'),
    ('l2-size-first-vector', D, '                    for (uint64_t word = 0; word < result->row_words; word += 1)\n                    {\n                        uint64_t bits = body[word];\n                        while (bits != 0)\n                        {\n                            const uint32_t block = (uint32_t)(word * 64 + __builtin_ctzll(bits));\n                            bits &= bits - 1;\n                            size += 1;', '                    for (uint64_t word = 0; word < 8; word += 1)\n                    {\n                        uint64_t bits = body[word];\n                        while (bits != 0)\n                        {\n                            const uint32_t block = (uint32_t)(word * 64 + __builtin_ctzll(bits));\n                            bits &= bits - 1;\n                            size += 1;'),
    ('l3-loop-irreducible-header', D, 'irreducible |= result->irreducible[block];', 'irreducible |= result->irreducible[header];'),
    ('l4-self-loops-dropped', D, 'flags[target] |= dominators_dominates(result, target, block);', 'flags[target] |= dominators_dominates(result, target, block) && target != block;'),
    ('a1-frontier-budget-inclusive', D, 'matrix_bytes > options.max_matrix_bytes)', 'matrix_bytes >= options.max_matrix_bytes)'),
    ('a2-loop-budget-inclusive', D, 'if (status == DOMINATOR_OK && kept_bytes > options.max_matrix_bytes)', 'if (status == DOMINATOR_OK && kept_bytes >= options.max_matrix_bytes)'),
    ('a3-peak-understated', D, '    if (status == DOMINATOR_OK && kept_bytes > result->matrix_peak_bytes)\n    {\n        result->matrix_peak_bytes = kept_bytes;', '    if (status == DOMINATOR_OK && kept_bytes > result->matrix_peak_bytes)\n    {\n        result->matrix_peak_bytes = kept_bytes - 64;'),
    ('v1-multiset-unchecked', D, 'valid = counters[source] != 0;', 'valid = counters[source] + 1 != 0;'),
    ('s4-compression-drops-least', D, '            link->least = least;', '            link->least = link->least + 0 * least;'),
    ('l5-first-loop-unflagged', D, 'result->loop_irreducible[loop] = irreducible;', 'result->loop_irreducible[loop] = irreducible && loop != 0;'),
]
