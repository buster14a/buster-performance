// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #611 object/stage verification harness. Run as one bounded test under the shared host lock.
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    static const unsigned counts[] = { 2000, 4000, 8000, 16000, 32000 };
    bool valid = argc == 2;
    for (unsigned i = 0; valid && i < sizeof(counts) / sizeof(counts[0]); i += 1)
    {
        char outputs[2][4096];
        for (unsigned variant = 0; valid && variant < 2; variant += 1)
        {
            const char* name = variant == 0 ? "base" : "head";
            char compiler[4096];
            char source[4096];
            char stages[4096];
            int a = snprintf(compiler, sizeof(compiler), "%s/%s/build/compiler", argv[1], name);
            int b = snprintf(source, sizeof(source), "%s/evidence/vla-%u.c", argv[1], counts[i]);
            int c = snprintf(outputs[variant], sizeof(outputs[variant]), "%s/evidence/%s-%u.o", argv[1], name, counts[i]);
            int d = snprintf(stages, sizeof(stages), "%s/evidence/stages-%s-%u.txt", argv[1], name, counts[i]);
            valid = a > 0 && a < (int)sizeof(compiler) && b > 0 && b < (int)sizeof(source) && c > 0 && c < (int)sizeof(outputs[variant]) && d > 0 && d < (int)sizeof(stages);
            const pid_t child = valid ? fork() : -1;
            if (child == 0)
            {
                const int fd = open(stages, O_WRONLY | O_CREAT | O_TRUNC, 0644);
                if (fd >= 0 && dup2(fd, STDERR_FILENO) >= 0)
                {
                    close(fd);
                    execl(compiler, compiler, "--lanes", "1", "--time-stages", "-c", source, "-o", outputs[variant], (char*)0);
                }
                _exit(127);
            }
            int status = 0;
            valid = child > 0 && waitpid(child, &status, 0) == child && WIFEXITED(status) && WEXITSTATUS(status) == 0;
        }
        FILE* left = valid ? fopen(outputs[0], "rb") : 0;
        FILE* right = valid ? fopen(outputs[1], "rb") : 0;
        valid = valid && left != 0 && right != 0;
        bool more = valid;
        while (more)
        {
            unsigned char a[4096];
            unsigned char b[4096];
            const size_t na = fread(a, 1, sizeof(a), left);
            const size_t nb = fread(b, 1, sizeof(b), right);
            valid = na == nb && memcmp(a, b, na) == 0 && !ferror(left) && !ferror(right);
            more = valid && na != 0;
        }
        if (left != 0)
        {
            valid = fclose(left) == 0 && valid;
        }
        if (right != 0)
        {
            valid = fclose(right) == 0 && valid;
        }
        printf("vla %u: objects %s\n", counts[i], valid ? "identical" : "FAILED");
    }
    return valid ? 0 : 1;
}
