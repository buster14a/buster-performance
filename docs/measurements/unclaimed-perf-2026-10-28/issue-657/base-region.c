static bool check_input_region_transfer(const CheckInputReader* reader, uint32_t source, uint32_t target)
{
    const Parser* parser = reader->parser;
    bool valid = true;
    for (uint32_t ancestor = target; valid && ancestor < parser->tokens.count; ancestor = parser->tree.parents[ancestor])
    {
        const uint32_t selected = reader->output->expression_regions[ancestor];
        if (selected != 0)
        {
            const CheckInputRegion* region = &reader->output->regions[selected - 1];
            valid = source > region->opening && source < region->closing;
        }
    }
    return valid;
}

