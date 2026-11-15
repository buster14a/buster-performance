// #2678: counts, in `objdump -d --no-show-raw-insn` output on stdin, the instructions and the adjacent pairs of a 32-bit
// immediate move (or xor of a register with itself) and a movslq of the same register, and of such a move and a
// cvtsi2sd or cvtsi2ss of its register.
#include <stdio.h>
#include <string.h>
static int dest32(const char* line, char* reg)
{
    // "mov    $0x1,%ecx" or "xor    %ecx,%ecx"
    const char* m = strstr(line, "\tmov    $");
    const char* x = strstr(line, "\txor    %");
    int found = 0;
    if (m != NULL) { const char* c = strchr(m, ','); if (c && c[1] == '%' && sscanf(c + 2, "%15[a-z0-9]", reg) == 1 && (reg[0]=='e' || (reg[0]=='r' && strchr(reg,'d')))) found = 1; }
    else if (x != NULL) { char a[16], b[16]; if (sscanf(x + 9, "%15[a-z0-9],%%%15[a-z0-9]", a, b) == 2 && strcmp(a, b) == 0 && (a[0]=='e' || (a[0]=='r' && strchr(a,'d')))) { strcpy(reg, a); found = 1; } }
    return found;
}
int main(void)
{
    char line[512], previous[512] = "";
    long instructions = 0, pairs = 0, floats = 0;
    while (fgets(line, sizeof line, stdin))
    {
        if (strchr(line, '\t') == NULL || strstr(line, ":\t") == NULL) { previous[0] = 0; continue; }
        instructions++;
        char reg[16];
        if (previous[0] && dest32(previous, reg))
        {
            char want[40];
            snprintf(want, sizeof want, "movslq %%%s,", reg);
            if (strstr(line, want)) pairs++;
            snprintf(want, sizeof want, " %%%s,%%xmm", reg);
            if ((strstr(line, "cvtsi2sd") || strstr(line, "cvtsi2ss")) && strstr(line, want)) floats++;
        }
        strcpy(previous, line);
    }
    printf("instructions %ld pairs %ld float-converts %ld\n", instructions, pairs, floats);
    return 0;
}
