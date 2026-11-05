// gen2 TYPE COUNT STYLE: tables of 32-bit LCG values. f: %.9gf (exact in float); x: %.17g of a third (rounds to float);
// s: integers of at most three digits, either sign; l: integers below 2^24 in magnitude, of four or more digits (exact in
// float and double); m: those four and hexadecimal integers in turn.
#include <stdio.h>
#include <stdlib.h>
static unsigned s = 12345;
static unsigned next(void) { s = s * 1103515245u + 12345u; return s; }
static void value(char style)
{
    double v = (double)(next() >> 8) / 16777216.0 - 0.5;
    if (style == 'f') printf("%.9gf", v);
    else if (style == 'x') printf("%.17g", v / 3.0);
    else if (style == 's') printf("%d", (int)(next() % 1999) - 999);
    else if (style == 'l') { int n = (int)(next() >> 9) % 8388608 + 1000; printf("%d", (next() & 1) ? -n : n); }
    else printf("0x%x", next() >> 8);
}
int main(int argc, char** argv)
{
    long count = atol(argv[2]);
    char style = argv[3][0];
    static const char cycle[] = "fxslh";
    printf("%s table[] = {\n", argv[1]);
    for (long i = 0; i < count; i += 1)
    {
        value(style == 'm' ? cycle[i % 5] : style);
        printf(i % 8 == 7 ? ",\n" : ",");
    }
    printf("};\n");
    return 0;
}
