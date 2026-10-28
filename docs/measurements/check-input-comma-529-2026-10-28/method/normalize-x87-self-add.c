// Original count-checked restoration of the one lossy MC assembly spelling in the cold checker test.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char** argv)
{
    if (argc != 3) return 2;
    FILE* input = fopen(argv[1], "r");
    FILE* output = input != NULL ? fopen(argv[2], "w") : NULL;
    if (output == NULL) return 2;
    char* line = NULL;
    size_t capacity = 0;
    ssize_t length;
    unsigned functions = 0, replacements = 0;
    bool inside = false, valid = true;
    const char* label = "check_test_action_constraints:";
    while (valid && (length = getline(&line, &capacity, input)) >= 0)
    {
        if (strncmp(line, label, strlen(label)) == 0) { inside = true; functions += 1; }
        if (inside && strncmp(line, ".Lfunc_end", 10) == 0) inside = false;
        char opcode[32] = { 0 }, source[32] = { 0 }, target[32] = { 0 };
        if (inside && sscanf(line, " %31s %31s %31s", opcode, source, target) == 3 && strcmp(opcode, "fadd") == 0 &&
            strcmp(source, "%st,") == 0 && strcmp(target, "%st(0)") == 0)
        {
            valid = fputs("\t.byte\t0xdc, 0xc0\n", output) >= 0;
            replacements += 1;
        }
        else valid = fwrite(line, 1, (size_t)length, output) == (size_t)length;
    }
    valid = valid && functions == 1 && replacements == 1 && !ferror(input) && !ferror(output);
    free(line);
    const int a = fclose(input), b = fclose(output);
    fprintf(stderr, "cold x87 restoration: function_matches=%u instruction_matches=%u valid=%u\n", functions, replacements, valid);
    return !(valid && a == 0 && b == 0);
}
