// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Independent runtime expectations for generate.c; compile with -DKIND=0..6 and link a measured object.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if KIND == 3
struct Row
{
    int id;
    const char* text;
    double value;
    short pair[2];
};
extern const struct Row* get(int i);
#elif KIND == 2
extern const int* get(int i);
#elif KIND == 6
extern int get(int i);
#else
extern const char* get(int i);
#endif

int main(int argc, char** argv)
{
    const int count = argc == 2 ? atoi(argv[1]) : 0;
    bool valid = count > 0 && count <= 160000;
    for (int i = 0; valid && i < count; i += 1)
    {
        char expected[80];
        const int number = KIND == 1 ? 0 : KIND == 4 || KIND == 5 ? (i == 0 ? 0 : count - 1) : i;
        snprintf(expected, sizeof(expected), "string number %d of the table", number);
#if KIND == 3
        const struct Row* row = get(i);
        valid = row->id == i && strcmp(row->text, expected) == 0 && row->value == (double)i + 0.25 &&
                row->pair[0] == i % 30000 && row->pair[1] == (i + 1) % 30000;
#elif KIND == 2
        const int* text = get(i);
        for (size_t at = 0; valid && at <= strlen(expected); at += 1)
        {
            valid = text[at] == (unsigned char)expected[at];
        }
#elif KIND == 6
        valid = get(i) == i;
#else
        valid = strcmp(get(i), expected) == 0;
#endif
    }
    printf("kind=%d count=%d valid=%u\n", KIND, count, valid);
    return valid ? 0 : 1;
}
