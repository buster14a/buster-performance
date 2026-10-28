// Original exact prefix extraction: reuse build.sh's link functions, omit its build dispatch.
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
    bool found = false;
    while (getline(&line, &capacity, input) >= 0)
    {
        if (strcmp(line, "defines=()\n") == 0) { found = true; break; }
        fputs(line, output);
    }
    const bool valid = found && !ferror(input) && !ferror(output);
    free(line);
    const int a = fclose(input), b = fclose(output);
    return !(valid && a == 0 && b == 0);
}
