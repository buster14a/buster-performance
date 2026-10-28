#define _GNU_SOURCE
#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

/* One bounded benchmark invocation, with rotated fresh-process cohort samples. */
int main(int argc, char** argv)
{
    int result = 2;
    if (argc >= 10)
    {
        const unsigned rounds = (unsigned)strtoul(argv[1], NULL, 10);
        result = rounds == 0 || rounds > 101 || (mkdir(argv[5], 0755) != 0 && errno != EEXIST);
        char** command = calloc((size_t)argc + 1, sizeof(char*));
        result |= command == NULL;
        for (unsigned round = 0; result == 0 && round < rounds; round += 1)
        {
            for (unsigned turn = 0; result == 0 && turn < 2; turn += 1)
            {
                const unsigned role = (round + turn) % 2;
                char directory[PATH_MAX];
                const int written = snprintf(directory, sizeof(directory), "%s/r%03u-role%u", argv[5], round, role);
                if (written < 0 || (size_t)written >= sizeof(directory))
                {
                    result = 2;
                    break;
                }
                command[0] = argv[6];
                command[1] = argv[2];
                command[2] = argv[3];
                command[3] = argv[4];
                command[4] = directory;
                command[5] = argv[7 + role];
                for (int a = 9; a < argc; a += 1) command[a - 3] = argv[a];
                command[argc - 3] = NULL;
                printf("sample round=%u role=%u jobs=%s binary=%s\n", round, role, argv[2], argv[7 + role]);
                fflush(stdout);
                const pid_t child = fork();
                if (child == 0)
                {
                    execv(command[0], command);
                    _exit(127);
                }
                int status = 0;
                pid_t waited = -1;
                if (child > 0)
                {
                    do { waited = waitpid(child, &status, 0); } while (waited < 0 && errno == EINTR);
                }
                result = child < 0 || waited != child || !WIFEXITED(status) || WEXITSTATUS(status) != 0;
            }
        }
        free(command);
    }
    if (result != 0) fprintf(stderr, "samples: failed or invalid arguments (%d)\n", result);
    return result;
}
