// Generates #1383's measurement inputs: gen SHAPE N > file.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static unsigned long long state = 1;

static unsigned draw(void)
{
    state = state * 6364136223846793005ULL + 1442695040888963407ULL;
    return (unsigned)(state >> 33);
}

static void floating(char* out, unsigned kind)
{
    static const char* const special[] = { "-0.0", "0x1p-1074", "4.9e-324", "1e-310", "0.1", "-3.5e2", "1.7976931348623157e308", "0" };
    if (kind % 16 == 0)
    {
        strcpy(out, special[(kind / 16) % 8]);
    }
    else
    {
        sprintf(out, "%s%u.%03u", draw() % 2 ? "-" : "", draw() % 100000, draw() % 1000);
    }
}

int main(int argc, char** argv)
{
    const char* shape = argc > 1 ? argv[1] : "flat";
    const unsigned n = argc > 2 ? (unsigned)strtoul(argv[2], NULL, 10) : 1000000;
    char a[64];
    char b[64];
    if (strcmp(shape, "flat") == 0)
    {
        printf("const int t[] = {\n");
        for (unsigned i = 0; i < n; i += 1)
        {
            printf("%d,%s", (int)(draw() % 200000) - 100000, i % 8 == 7 ? "\n" : " ");
        }
        printf("};\n");
    }
    else if (strcmp(shape, "rows") == 0 || strcmp(shape, "short") == 0 || strcmp(shape, "short-double") == 0)
    {
        const int is_short = strcmp(shape, "rows") != 0;
        const int is_double = strcmp(shape, "short-double") == 0;
        printf("const %s t[][4] = {\n", is_double ? "double" : "int");
        for (unsigned r = 0; r < n / 4; r += 1)
        {
            const unsigned length = is_short ? 1 + draw() % 4 : 4;
            printf("{");
            for (unsigned c = 0; c < length; c += 1)
            {
                if (is_double)
                {
                    floating(a, draw());
                    printf("%s%s", a, c + 1 < length ? ", " : "");
                }
                else
                {
                    printf("%d%s", (int)(draw() % 200000) - 100000, c + 1 < length ? ", " : "");
                }
            }
            printf("},\n");
        }
        printf("};\n");
    }
    else if (strcmp(shape, "struct-int") == 0)
    {
        printf("const struct { int a, b; } t[] = {\n");
        for (unsigned r = 0; r < n; r += 1)
        {
            printf("{%d, %d},\n", (int)(draw() % 200000) - 100000, (int)(draw() % 200000) - 100000);
        }
        printf("};\n");
    }
    else if (strcmp(shape, "struct-float") == 0 || strcmp(shape, "struct-float-local") == 0)
    {
        const int local = strcmp(shape, "struct-float-local") == 0;
        printf("struct R { int a; float b; double c; long double d; };\n%sconst struct R t[] = {\n", local ? "int f(int i) {\n static " : "");
        for (unsigned r = 0; r < n; r += 1)
        {
            floating(a, draw());
            floating(b, draw());
            printf("{%d, %sf, %s, %sL},\n", (int)(draw() % 200000) - 100000, strchr(a, 'x') || strchr(a, 'e') || !strchr(a, '.') ? "1.5" : a, b, b);
        }
        printf("};\n%s", local ? " return t[i].a;\n}\n" : "");
    }
    else if (strcmp(shape, "struct-double") == 0)
    {
        printf("const struct { int a; double b; } t[] = {\n");
        for (unsigned r = 0; r < n; r += 1)
        {
            floating(a, draw());
            printf("{%d, %s},\n", (int)(draw() % 200000) - 100000, a);
        }
        printf("};\n");
    }
    return 0;
}
