// Original exact-line adapter: preserve compiler sources, add one observation before their production pass.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static bool copy(const char* input, const char* output, const char* needle, const char* replacement)
{
    FILE* from = fopen(input, "r");
    FILE* to = from != NULL ? fopen(output, "w") : NULL;
    if (to == NULL) return false;
    char* line = NULL;
    size_t capacity = 0;
    unsigned matches = 0;
    while (getline(&line, &capacity, from) >= 0)
    {
        if (strcmp(line, needle) == 0) { fputs(replacement, to); matches += 1; }
        else fputs(line, to);
    }
    free(line);
    const bool valid = !ferror(from) && !ferror(to) && matches == 1;
    const int a = fclose(from), b = fclose(to);
    return valid && a == 0 && b == 0;
}

int main(int argc, char** argv)
{
    if (argc == 3)
    {
        // Preserve exactly the ordinary build's objects after its ordinary link and before its existing EXIT cleanup.
        return !copy(argv[1], argv[2], "    link_program build/compiler \"${linked[@]}\" \"$@\"\n",
                     "    link_program build/compiler \"${linked[@]}\" \"$@\"\n"
                     "    test -n \"${BUSTER_CAPTURE_OBJECTS-}\"\n"
                     "    mkdir -p \"$BUSTER_CAPTURE_OBJECTS\"\n"
                     "    cp -a \"$object_directory/.\" \"$BUSTER_CAPTURE_OBJECTS/\"\n");
    }
    return argc != 5 || !copy(argv[1], argv[2], "#include \"buster/compiler/c_check_input.c\"\n",
                              "#include \"input-pages.c\"\n") ||
           !copy(argv[3], argv[4], "        check_input_expression_commas(&reader);\n",
                 "        comma_page_probe(&reader);\n        check_input_expression_commas(&reader);\n");
}
