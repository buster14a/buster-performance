// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
static bool ir_parse_test_read(const char* path, Arena* source, String8* text)
{
    FILE* stream = fopen(path, "rb");
    bool ok = stream != 0;
    if (ok)
    {
        ok = fseek(stream, 0, SEEK_END) == 0;
        const long length = ok ? ftell(stream) : -1;
        ok = length >= 0 && fseek(stream, 0, SEEK_SET) == 0;
        char* bytes = ok ? arena_push(source, (uint64_t)length, 1) : 0;
        ok = bytes != 0 && ok;
        if (ok)
        {
            ok = fread(bytes, 1, (size_t)length, stream) == (size_t)length && ferror(stream) == 0;
            if (ok)
            {
                *text = (String8){
                    .pointer = bytes,
                    .length = (uint64_t)length,
                };
            }
        }
        fclose(stream);
    }
    return ok;
}
