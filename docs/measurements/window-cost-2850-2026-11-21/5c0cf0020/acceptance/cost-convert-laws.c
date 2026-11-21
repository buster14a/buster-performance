#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

static unsigned recode(unsigned old)
{
    return (old & ~0x14u) | ((old & 0x10u) ? 0x04u : 0u) | ((old & 0x14u) ? 0x10u : 0u);
}

int main(void)
{
    unsigned long long comparisons = 0;
    unsigned wrong[5] = {0};
    for (unsigned l = 0; l < 256; ++l) {
        if ((l & 0x14u) == 0x14u) continue;
        for (unsigned r = 0; r < 256; ++r) {
            if ((r & 0x14u) == 0x14u) continue;
            const unsigned ln = recode(l), rn = recode(r);
            for (unsigned enabled = 0; enabled < 2; ++enabled) {
                for (unsigned always = 0; always < 2; ++always) {
                    for (unsigned extra = 0; extra < 256; ++extra) {
                        if ((extra & 0x14u) != 0) continue;
                        const unsigned old_sends = extra | (enabled ? 0x14u : 0u);
                        const unsigned new_sends = extra | (enabled ? 0x10u : 0u);
                        const unsigned old_sent = (l | r) & old_sends;
                        const unsigned new_sent = (ln | rn) & new_sends;
                        const unsigned classes = enabled && !always ? 0x10u : 0u;
                        const bool control = !always && (l & 0x14u) && (r & 0x14u) && old_sent && (old_sent & ~0x14u) == 0;
                        const bool candidate = (ln & rn & classes & 0x10u) != 0 && new_sent == 0x10u;
                        if (control != candidate) return 1;
                        wrong[0] += (control != (((ln | rn) & classes & 0x10u) != 0 && new_sent == 0x10u));
                        wrong[1] += (control != ((ln & rn & classes & 0x10u) != 0 && (new_sent & 0x10u) != 0));
                        wrong[2] += (control != ((ln & rn & 0x10u) != 0 && new_sent == 0x10u));
                        wrong[3] += (control != ((ln & classes & 0x10u) != 0 && new_sent == 0x10u));
                        wrong[4] += (control != ((rn & classes & 0x10u) != 0 && new_sent == 0x10u));
                        ++comparisons;
                    }
                }
            }
        }
    }
    printf("%llu property pairs and warning send masks agree\n", comparisons);
    const char *labels[] = {"either-converts", "additional-triggers-ignored", "unconditional-class", "right-operand-ignored", "left-operand-ignored"};
    for (unsigned i = 0; i < 5; ++i) {
        printf("%s caught on %u cases\n", labels[i], wrong[i]);
        if (!wrong[i]) return 2;
    }
    return 0;
}
