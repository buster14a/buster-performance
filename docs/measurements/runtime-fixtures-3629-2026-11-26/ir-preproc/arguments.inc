// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
static int pp_test_arguments(const PPTestCase* test, const char* directory, const char* path, char* text, uint32_t capacity, char** arguments)
{
    const int standard = snprintf(text, capacity, "-std=%s", test->standard);
    bool valid = standard >= 0 && (uint32_t)standard < capacity;
    uint32_t used = valid ? (uint32_t)standard + 1 : 0;
    int count = 1;
    arguments[0] = text;
    const char* options = test->options != 0 ? test->options : "";
    while (valid && *options != 0)
    {
        while (*options == ' ')
        {
            options += 1;
        }
        if (*options != 0)
        {
            valid = count + 1 < BUSTER_PP_TEST_MAX_ARGUMENTS && used < capacity;
            if (valid)
            {
                arguments[count++] = text + used;
            }
            while (valid && *options != 0 && *options != ' ')
            {
                if (options[0] == '%' && options[1] == 'd')
                {
                    const size_t length = strlen(directory);
                    valid = length < capacity - used;
                    if (valid)
                    {
                        memcpy(text + used, directory, length);
                        used += (uint32_t)length;
                        options += 2;
                    }
                }
                else
                {
                    valid = used + 1 < capacity;
                    if (valid)
                    {
                        text[used++] = *options++;
                    }
                }
            }
            if (valid)
            {
                text[used++] = 0;
            }
        }
    }
    if (valid)
    {
        arguments[count] = (char*)path;
    }
    else
    {
        fprintf(stderr, "test-preprocessor: %s: fixture arguments exceed their bound\n", test->name);
    }
    return valid ? count : -1;
}
