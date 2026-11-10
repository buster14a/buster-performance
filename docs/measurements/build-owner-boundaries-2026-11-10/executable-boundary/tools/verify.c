// Original one-off definition preservation check for the executable boundary.
#define main extraction_main
#include "split.c"
#undef main

int main(int argc, char** argv)
{
    assert(argc == 4);
    size_t original_size;
    char* original = read_file(argv[1], &original_size);
    scan_functions(original, original_size);
    size_t original_count = function_count;
    Function* originals = malloc(original_count * sizeof(Function));
    bool* seen = calloc(original_count, sizeof(bool));
    assert(originals && seen);
    memcpy(originals, functions, original_count * sizeof(Function));
    size_t verified = 0;
    for (int file = 2; file < argc; file++)
    {
        size_t size;
        char* candidate = read_file(argv[file], &size);
        function_count = 0;
        scan_functions(candidate, size);
        for (size_t f = 0; f < function_count; f++)
        {
            Function* function = &functions[f];
            size_t index = 0;
            while (index < original_count && strcmp(originals[index].name, function->name)) index++;
            assert(index < original_count && !seen[index]);
            Function* before = &originals[index];
            size_t bytes = before->end - before->start;
            assert(bytes == function->end - function->start);
            assert(memcmp(original + before->start, candidate + function->start, bytes) == 0);
            seen[index] = true;
            verified++;
        }
        printf("%s: %zu definitions preserved byte-for-byte\n", argv[file], function_count);
        free(candidate);
    }
    assert(verified == original_count);
    for (size_t i = 0; i < original_count; i++) assert(seen[i]);
    printf("All %zu original functions preserved exactly once; no changed, missing or added definitions.\n", original_count);
    free(seen);
    free(originals);
    free(original);
    return 0;
}
