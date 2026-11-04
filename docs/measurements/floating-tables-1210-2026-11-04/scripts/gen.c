#include <stdio.h>
#include <stdlib.h>
int main(int argc, char** argv)
{
    // gen TYPE COUNT STYLE: f = 1.234567f suffix, d = plain double literal, i = small ints
    const char* type = argv[1];
    long count = atol(argv[2]);
    char style = argv[3][0];
    unsigned s = 12345;
    printf("%s table[] = {\n", type);
    for (long i = 0; i < count; i += 1)
    {
        s = s * 1103515245u + 12345u;
        double v = (double)(s >> 8) / 16777216.0 - 0.5;
        if (style == 'f') printf("%.9gf,", v);
        else if (style == 'd') printf("%.17g,", v);
        else if (style == 'x') printf("%.17g,", v / 3.0);
        else printf("%d,", (int)(s >> 22));
        if (i % 8 == 7) printf("\n");
    }
    printf("};\n");
    return 0;
}
