// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// #335's header-heavy input: the C library's common headers, from the frozen corpus's header bundle, and a small body.
#include <ctype.h>
#include <errno.h>
#include <inttypes.h>
#include <limits.h>
#include <locale.h>
#include <math.h>
#include <pthread.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>
#include <wchar.h>

int main(int argc, char** argv)
{
    struct stat information;
    const int status = argc > 1 && stat(argv[1], &information) == 0 ? (int)(information.st_size % 7) : EINVAL;
    printf("%d %s %" PRIu64 "\n", status, strerror(errno), (uint64_t)time(0));
    return isdigit((unsigned char)argv[0][0]) ? status : 0;
}
