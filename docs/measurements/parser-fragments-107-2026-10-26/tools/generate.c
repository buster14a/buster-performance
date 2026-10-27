// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
//
// The two generated corpora of buster14a/buster#107: C translation units whose expressions are, at one end, long (each
// function returns one expression of thousands of operators, balanced trees and long chains of every precedence level)
// and, at the other, short (thousands of small functions of a few statements each, as ordinary code has them). Both are
// deterministic for a seed, use only int and unsigned arithmetic on parameters and locals (no constant to fold), and
// must be accepted by clang -fsyntax-only and by buster's checker.
//
// Usage: generate long|small SEED > file.c

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint64_t state;

static uint32_t next(uint32_t bound)
{
    state = state * 6364136223846793005u + 1442695040888963407u;
    return (uint32_t)((state >> 33) % bound);
}

static const char* const binary[] = { "+", "-", "*", "&", "|", "^", "<", ">", "==", "!=", "<=", ">=", "&&", "||" };
static const char* const names[] = { "a", "b", "c", "d", "e", "f", "g", "h" };

// An expression of about `operators` operators, written by an explicit stack of pending sizes rather than recursion:
// each entry is a subexpression still to write, or a closing text to emit.
static void expression(uint32_t operators, uint32_t shape)
{
    uint32_t sizes[4096];
    const char* closers[4096];
    uint32_t depth = 0;
    sizes[depth] = operators;
    closers[depth] = 0;
    depth += 1;
    while (depth != 0)
    {
        depth -= 1;
        const char* closer = closers[depth];
        const uint32_t size = sizes[depth];
        if (closer != 0)
        {
            fputs(closer, stdout);
        }
        else if (size == 0)
        {
            const uint32_t pick = next(16);
            if (pick < 12)
            {
                fputs(names[next(8)], stdout);
            }
            else if (pick < 14)
            {
                printf("p[%s & 7]", names[next(8)]);
            }
            else if (pick < 15)
            {
                printf("u%u(%s)", next(4), names[next(8)]);
            }
            else
            {
                printf("%u", next(100));
            }
        }
        else if (depth + 4 > sizeof(sizes) / sizeof(sizes[0]))
        {
            fputs(names[next(8)], stdout);
        }
        else
        {
            // Shape 0 balances the two sides, 1 chains to the left, 2 chains to the right; a few subexpressions get
            // parentheses, a cast, a unary operator or a conditional.
            const uint32_t left = shape == 0 ? (size - 1) / 2 : shape == 1 ? size - 1 : 0;
            const uint32_t right = size - 1 - left;
            const uint32_t form = next(32);
            static const char* const opens[] = { "(", "(unsigned)(", "-(", "~(", "!(" };
            const uint32_t open = form < 3 ? 0 : form < 4 ? 1 : form < 5 ? 2 : form < 6 ? 3 : form < 7 ? 4 : 5;
            if (open < 5)
            {
                fputs(opens[open], stdout);
                sizes[depth] = 0;
                closers[depth] = ")";
                depth += 1;
            }
            if (form == 31 && right != 0)
            {
                // left ? right : left'
                sizes[depth] = 0;
                closers[depth] = ")";
                depth += 1;
                sizes[depth] = right / 2;
                closers[depth] = 0;
                depth += 1;
                sizes[depth] = 0;
                closers[depth] = " : ";
                depth += 1;
                sizes[depth] = right - right / 2;
                closers[depth] = 0;
                depth += 1;
                sizes[depth] = 0;
                closers[depth] = " ? ";
                depth += 1;
                sizes[depth] = left;
                closers[depth] = 0;
                depth += 1;
                fputs("(", stdout);
            }
            else
            {
                const char* operator = binary[next(sizeof(binary) / sizeof(binary[0]))];
                static char spaced[4096][8];
                snprintf(spaced[depth], sizeof(spaced[depth]), " %s ", operator);
                sizes[depth] = right;
                closers[depth] = 0;
                depth += 1;
                sizes[depth] = 0;
                closers[depth] = spaced[depth - 1];
                depth += 1;
                sizes[depth] = left;
                closers[depth] = 0;
                depth += 1;
            }
        }
    }
}

static void prologue(void)
{
    puts("unsigned u0(unsigned x);\nunsigned u1(unsigned x);\nunsigned u2(unsigned x);\nunsigned u3(unsigned x);");
}

int main(int argc, char** argv)
{
    const int long_corpus = argc == 3 && strcmp(argv[1], "long") == 0;
    const int small_corpus = argc == 3 && strcmp(argv[1], "small") == 0;
    int result = 1;
    if (long_corpus || small_corpus)
    {
        state = strtoull(argv[2], 0, 10) * 2 + 1;
        prologue();
        if (long_corpus)
        {
            // 60 functions: 20 of each shape, of 500 to 8,000 operators.
            for (uint32_t f = 0; f < 60; f += 1)
            {
                printf("unsigned long_%u(unsigned a, unsigned b, unsigned c, unsigned d, unsigned e, unsigned f, unsigned g, unsigned h, const unsigned* p)\n{\n    return ", f);
                expression(500 + next(7500), f % 3);
                puts(";\n}");
            }
        }
        else
        {
            // 6,000 small functions of 2 to 6 statements, each of a short expression.
            for (uint32_t f = 0; f < 6000; f += 1)
            {
                printf("unsigned small_%u(unsigned a, unsigned b, unsigned c, unsigned d, const unsigned* p)\n{\n", f);
                puts("    unsigned e = a;\n    unsigned f = b;\n    unsigned g = c;\n    unsigned h = d;");
                const uint32_t statements = 2 + next(5);
                for (uint32_t s = 0; s < statements; s += 1)
                {
                    const uint32_t form = next(4);
                    if (form == 0)
                    {
                        fputs("    if (", stdout);
                        expression(next(3), 0);
                        fputs(")\n    {\n        g = ", stdout);
                        expression(next(4), 0);
                        puts(";\n    }");
                    }
                    else if (form == 1)
                    {
                        fputs("    for (unsigned i = 0; i < 4; i += 1)\n    {\n        h += ", stdout);
                        expression(next(4), 0);
                        puts(";\n    }");
                    }
                    else
                    {
                        printf("    %s = ", names[4 + next(4)]);
                        expression(next(6), 0);
                        puts(";");
                    }
                }
                fputs("    return ", stdout);
                expression(next(5), 0);
                puts(";\n}");
            }
        }
        result = 0;
    }
    else
    {
        fputs("usage: generate long|small SEED > file.c\n", stderr);
    }
    return result;
}
