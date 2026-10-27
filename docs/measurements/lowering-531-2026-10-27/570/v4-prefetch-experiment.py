import sys
path = sys.argv[1]
s = open(path).read()
old = """        for (uint32_t i = 0; i < body.entry_count && status->status == CHECK_PROGRAM_OK; i += 1)
        {
            if (sources)
            {
                // A statement's entries are its token's (check_lower_task_source sets a nested one's).
                check_lower_change_source(writer, program->controls[body.first + i].token);
            }
            check_lower_control(writer, i);"""
new = """        uint32_t prefetched = 0;
        for (uint32_t i = 0; i < body.entry_count && status->status == CHECK_PROGRAM_OK; i += 1)
        {
            if (sources)
            {
                // A statement's entries are its token's (check_lower_task_source sets a nested one's).
                check_lower_change_source(writer, program->controls[body.first + i].token);
            }
            for (uint32_t k = i == 0 ? 0 : 1; k < 2; k += 1)
            {
                const uint32_t ahead = i + k < body.entry_count ? program->controls[body.first + i + k].node : BUSTER_CHECK_NONE;
                if (ahead != BUSTER_CHECK_NONE && ahead < program->stream->count && ahead + 1 > prefetched)
                {
                    const uint32_t from = ahead + 1 - prefetched > 64 ? ahead + 1 - 64 : prefetched;
                    const uint8_t* values = (const uint8_t*)(program->stream->values + from);
                    const uint8_t* values_end = (const uint8_t*)(program->stream->values + ahead + 1);
                    for (const uint8_t* line = values; line < values_end; line += 64)
                    {
                        __builtin_prefetch(line);
                    }
                    const uint8_t* conversions = (const uint8_t*)(program->stream->conversions + from);
                    const uint8_t* conversions_end = (const uint8_t*)(program->stream->conversions + ahead + 1);
                    for (const uint8_t* line = conversions; line < conversions_end; line += 64)
                    {
                        __builtin_prefetch(line);
                    }
                    prefetched = ahead + 1;
                }
            }
            check_lower_control(writer, i);"""
assert s.count(old) == 1
s = s.replace(old, new)
open(path, "w").write(s)
print("patched")
