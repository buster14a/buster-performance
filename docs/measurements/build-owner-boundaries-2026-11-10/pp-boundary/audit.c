#define main extraction_main
#include "split.c"
#undef main
#include <openssl/sha.h>

static void print_digest(const char* bytes, size_t length)
{
    unsigned char digest[SHA256_DIGEST_LENGTH];
    SHA256((const unsigned char*)bytes, length, digest);
    for (size_t i = 0; i < sizeof(digest); i++) printf("%02x", digest[i]);
}

int main(int argc, char** argv)
{
    assert(argc == 3);
    const char* names[4] = { "c_preprocessor.c", "c_preprocessor_history.c", "c_preprocessor_impl.c", "c_preprocessor_history_impl.c" };
    Source before[2] = { 0 }, after[4] = { 0 };
    char path[4096];
    for (size_t i = 0; i < 2; i++)
    {
        snprintf(path, sizeof(path), "%s/%s", argv[1], names[i]);
        before[i].text = read_file(path, &before[i].length);
        scan_functions(before[i].text, before[i].length, i);
    }
    size_t before_count = function_count;
    Function original[2048];
    memcpy(original, functions, before_count * sizeof(Function));
    function_count = 0;
    for (size_t i = 0; i < 4; i++)
    {
        snprintf(path, sizeof(path), "%s/%s", argv[2], names[i]);
        after[i].text = read_file(path, &after[i].length);
        scan_functions(after[i].text, after[i].length, i);
    }
    size_t mismatches = 0, data = 0, bodies = 0, moved = 0;
    puts("kind\tname\tbytes\tsha256\tbefore\tafter\tequal");
    for (size_t i = 0; i < before_count; i++)
    {
        Function* base = &original[i];
        const char* bytes = before[base->source].text + base->start;
        size_t length = base->end - base->start;
        Function* candidate = 0;
        size_t matches = 0;
        for (size_t j = 0; j < function_count; j++)
        {
            if (!strcmp(base->name, functions[j].name)) { candidate = &functions[j]; matches++; }
        }
        bool equal = matches == 1 && candidate->end - candidate->start == length && !memcmp(bytes, after[candidate->source].text + candidate->start, length);
        mismatches += !equal;
        if (base->data) data++; else bodies++;
        moved += candidate && candidate->source >= 2;
        printf("%s\t%s\t%zu\t", base->data ? "data" : "function", base->name, length);
        print_digest(bytes, length);
        printf("\t%s\t%s\t%s\n", names[base->source], candidate ? names[candidate->source] : "MISSING", equal ? "yes" : "NO");
    }
    for (size_t j = 0; j < function_count; j++)
    {
        bool original_name = false;
        for (size_t i = 0; i < before_count; i++) original_name |= !strcmp(original[i].name, functions[j].name);
        if (!original_name && strcmp(functions[j].name, "pp_implementation_interfaces")) { fprintf(stderr, "unexpected definition: %s\n", functions[j].name); mismatches++; }
    }
    fprintf(stderr, "original functions=%zu data=%zu definitions=%zu; candidate definitions=%zu; moved definitions=%zu; mismatches=%zu\n", bodies, data, before_count, function_count, moved, mismatches);
    for (size_t i = 0; i < 2; i++) free(before[i].text);
    for (size_t i = 0; i < 4; i++) free(after[i].text);
    return mismatches ? 1 : 0;
}
