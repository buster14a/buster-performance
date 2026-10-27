// Prints a C file of FUNCTIONS functions, each with inferred arrays of GNU vectors, extension vectors and structs whose
// elements are operators' values (#555's walk: binary operators, casts, conditionals, lanes, logic and swizzles), or
// with SIZED, the same arrays with their sizes written: the difference between the two files' checking is the inference
// walk's. Every element is whole, so the sizes are the initializers' counts.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const char* const vector_elements[] = {
    "x", "x + y", "-x", "~y", "x * y + z", "(x - y) * z", "n ? x : y", "(g4)l", "x & (y | z)", "m ? x : (g4)l",
    "(x + y) * (y - z)", "x << 2", "n ? (x + y) : z", "(g4)(l + l)", "x ^ y ^ z", "!e ? x : y",
};
static const char* const extension_elements[] = {
    "e", "!e", "e && f", "e || f", "e.wzyx", "e < f", "e ? 1 : 2", "(e < 2) ? 3 : 4", "e.xyzw + f", "-e", "e.xy.xyxy", "f ? e : 0",
};
static const char* const record_elements[] = {
    "*(p + 1)", "p[0]", "s", "n ? s : t", "*(p + (q - r))", "*((S*)r + 1)", "p[n == 0]", "*(n ? p : q)", "u.s", "*(p - 1)",
};

static void print_array(const char* type, const char* name, const char* const* elements, size_t element_count, unsigned seed, int sized)
{
    const unsigned count = 4 + seed % 5;
    printf("    %s %s[", type, name);
    if (sized)
    {
        printf("%u", count);
    }
    printf("] = { ");
    for (unsigned i = 0; i < count; i += 1)
    {
        printf("%s%s", i != 0 ? ", " : "", elements[(seed * 7 + i * 3) % element_count]);
    }
    printf(" };\n");
}

int main(int argc, char** argv)
{
    const unsigned functions = argc > 1 ? (unsigned)strtoul(argv[1], 0, 10) : 2000;
    const int sized = argc > 2 && strcmp(argv[2], "sized") == 0;
    printf("typedef int g4 __attribute__((vector_size(16)));\n");
    printf("typedef long long g2l __attribute__((vector_size(16)));\n");
    printf("typedef int e4 __attribute__((ext_vector_type(4)));\n");
    printf("typedef struct { int a, b; } S;\n");
    printf("typedef struct { S s; int k; } U;\n");
    for (unsigned f = 0; f < functions; f += 1)
    {
        printf("int f%u(int n, int m, g4 x, g4 y, g4 z, g2l l, e4 e, e4 f, S* p, S* q, S* r, S s, S t, U u)\n{\n", f);
        print_array("g4", "a", vector_elements, sizeof(vector_elements) / sizeof(vector_elements[0]), f, sized);
        print_array("e4", "b", extension_elements, sizeof(extension_elements) / sizeof(extension_elements[0]), f + 1, sized);
        print_array("S", "c", record_elements, sizeof(record_elements) / sizeof(record_elements[0]), f + 2, sized);
        print_array("g4", "d", vector_elements, sizeof(vector_elements) / sizeof(vector_elements[0]), f + 3, sized);
        printf("    return a[0][0] + b[0][1] + c[0].a + d[1][2];\n}\n");
    }
    return 0;
}
