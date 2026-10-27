// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original runtime byte oracle; link separately with each Buster/Clang object.
#include <pthread.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
extern unsigned char* get(void);
extern unsigned long get_size(void);
int target;
static unsigned char* main_pointer;

static void* tls_check(void* unused)
{
    (void)unused;
    unsigned char* pointer = get();
    return pointer != main_pointer && pointer[0] == 0 ? NULL : (void*)(uintptr_t)1;
}

int main(int argc, char** argv)
{
    bool valid = argc == 3;
    if (valid)
    {
        const char* mode = argv[1];
        const uint64_t size = strtoull(argv[2], NULL, 10);
        const bool negative = strcmp(mode, "negative") == 0;
        const bool dense = strcmp(mode, "dense") == 0 || strcmp(mode, "dense-tail-zero") == 0;
        const bool tail = strcmp(mode, "dense-tail-zero") == 0;
        const uint64_t expected_size = negative ? 16 : strcmp(mode, "bits") == 0 ? (size + 5) / 4 * 4 : size;
        valid = get_size() == expected_size;
        const unsigned char* bytes = get();
        for (uint64_t i = 0; valid && i < expected_size; i += 1)
        {
            const unsigned char expected = negative ? (i == 7 ? 0x80 : 0) : dense ? (i + 1 == size && tail ? 0 : i % 251 + 1) : 0;
            valid = bytes[i] == expected;
        }
        if (valid && strcmp(mode, "tls") == 0)
        {
            main_pointer = get();
            main_pointer[0] = 7;
            pthread_t thread;
            void* result = NULL;
            valid = pthread_create(&thread, NULL, tls_check, NULL) == 0;
            valid = valid && pthread_join(thread, &result) == 0 && result == NULL && main_pointer[0] == 7;
        }
    }
    return valid ? 0 : 1;
}
