    if (valid && getenv("BUSTER_COUNT_COLUMNS") != NULL)
    {
        const struct { const char* name; const uint32_t* column; } words[] = {
            { "declarations", input->declarations }, { "initializer_nodes", input->initializer_nodes }, { "initializer_begins", input->initializer_begins },
            { "initializer_ends", input->initializer_ends }, { "token_nodes", input->token_nodes }, { "evaluation_nodes", input->evaluation_nodes },
            { "body_declarations", input->body_declarations }, { "declaration_bodies", input->declaration_bodies }, { "parameter_next", input->parameter_next },
            { "control_owners", input->control_owners }, { "label_targets", input->label_targets }, { "case_ranges", input->case_ranges },
            { "string_ids", input->string_ids }, { "parameters", input->parameters }, { "objects(0)", input->objects }, { "expression_regions(0)", input->expression_regions },
        };
        for (uint32_t c = 0; c < BUSTER_ARRAY_LENGTH(words); c += 1)
        {
            const uint32_t empty = words[c].name[strlen(words[c].name) - 1] == ')' ? 0 : BUSTER_CHECK_NONE;
            uint64_t entries = 0, blocks64 = 0, blocks1k = 0, blocks512k = 0;
            uint64_t last64 = UINT64_MAX, last1k = UINT64_MAX, last512k = UINT64_MAX;
            for (uint32_t t = 0; words[c].column != NULL && t <= count; t += 1)
            {
                if (words[c].column[t] != empty)
                {
                    entries += 1;
                    blocks64 += (t >> 4) != last64; last64 = t >> 4;
                    blocks1k += (t >> 10) != last1k; last1k = t >> 10;
                    blocks512k += (t >> 19) != last512k; last512k = t >> 19;
                }
            }
            fprintf(stderr, "column %-24s entries %8lu  64B-lines %7lu  4K-pages %5lu  2M-pages %2lu  of %u tokens\n", words[c].name, entries, blocks64, blocks1k, blocks512k, count);
        }
        const struct { const char* name; const uint8_t* column; } bytes[] = {
            { "declaration_kinds", input->declaration_kinds }, { "constant_warnings", input->constant_warnings }, { "constant_warning_ignored", input->constant_warning_ignored },
            { "defined", input->defined }, { "tentative", input->tentative }, { "static_objects", input->static_objects }, { "registers", input->registers },
            { "thread_local", input->thread_local }, { "compound_objects", input->compound_objects }, { "function_flags", input->function_flags },
            { "explicit_abis", input->explicit_abis }, { "linkage", input->linkage },
        };
        for (uint32_t c = 0; c < BUSTER_ARRAY_LENGTH(bytes); c += 1)
        {
            uint64_t entries = 0, bits = 0, blocks1k = 0, last1k = UINT64_MAX, max = 0;
            for (uint32_t t = 0; bytes[c].column != NULL && t <= count; t += 1)
            {
                if (bytes[c].column[t] != 0)
                {
                    entries += 1; bits |= bytes[c].column[t]; max = bytes[c].column[t] > max ? bytes[c].column[t] : max;
                    blocks1k += (t >> 12) != last1k; last1k = t >> 12;
                }
            }
            fprintf(stderr, "bytes  %-24s entries %8lu  bits 0x%02lx max %3lu  4K-pages %5lu\n", bytes[c].name, entries, bits, max, blocks1k);
        }
    }
