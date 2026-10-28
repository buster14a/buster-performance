static bool check_input_region_transfer(const CheckInputReader* reader, uint32_t source, uint32_t target)
{
    const Parser* parser = reader->parser;
    bool valid = true;
    // Most units have no GNU statement expression. Otherwise only regions below the source and target's common
    // ancestor can be entered: a region above it holds both. Existing postorder intervals recognize that ancestor
    // without another token column or a walk from the source. Keep the full parent walk on the scalar path as oracle.
    const bool scalar = parser->options.scalar;
    const uint32_t source_position = !scalar && reader->output->region_count != 0 && source < parser->tokens.count ? reader->postorder_positions[source] : BUSTER_CHECK_NONE;
    for (uint32_t ancestor = target; valid && ancestor < parser->tokens.count && (scalar || reader->output->region_count != 0); ancestor = parser->tree.parents[ancestor])
    {
        const uint32_t selected = reader->output->expression_regions[ancestor];
        if (selected != 0)
        {
            const CheckInputRegion* region = &reader->output->regions[selected - 1];
            valid = source > region->opening && source < region->closing;
        }
        if (!scalar)
        {
            const uint32_t position = reader->postorder_positions[ancestor];
            const uint32_t size = parser->sizes[position];
            if (source_position <= position && position - source_position < size)
            {
                break;
            }
        }
    }
    return valid;
}

