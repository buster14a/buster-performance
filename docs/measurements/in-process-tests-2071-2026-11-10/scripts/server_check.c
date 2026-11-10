// Scratch check of #2071's clang server: each fixture's clang run through the server and spawned, compared byte for
// byte (status and standard error), and both timed. server_check SERVER CLANG FLAGS... -- FILES...
#define _GNU_SOURCE
#include <fcntl.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static bool io_all(int fd, void* data, size_t size, bool writing)
{
    char* at = data;
    bool ok = true;
    while (ok && size != 0)
    {
        ssize_t n = writing ? write(fd, at, size) : read(fd, at, size);
        ok = n > 0;
        if (ok)
        {
            at += n;
            size -= (size_t)n;
        }
    }
    return ok;
}

static double now(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return (double)t.tv_sec + (double)t.tv_nsec / 1e9;
}

static int spawn(char** argv, char** text, size_t* length)
{
    FILE* errors = tmpfile();
    pid_t child = fork();
    if (child == 0)
    {
        int null = open("/dev/null", O_WRONLY);
        dup2(null, 1);
        dup2(fileno(errors), 2);
        execvp(argv[0], argv);
        _exit(127);
    }
    int status = 0;
    waitpid(child, &status, 0);
    fseek(errors, 0, SEEK_END);
    *length = (size_t)ftell(errors);
    fseek(errors, 0, SEEK_SET);
    *text = malloc(*length + 1);
    *length = fread(*text, 1, *length, errors);
    fclose(errors);
    return WIFEXITED(status) ? WEXITSTATUS(status) : -1;
}

int main(int argc, char** argv)
{
    int split = 3;
    while (split < argc && strcmp(argv[split], "--") != 0)
    {
        split += 1;
    }
    int to_server[2];
    int from_server[2];
    pipe(to_server);
    pipe(from_server);
    pid_t server = fork();
    if (server == 0)
    {
        dup2(to_server[0], 0);
        dup2(from_server[1], 1);
        close(to_server[1]);
        close(from_server[0]);
        execl(argv[1], argv[1], (char*)NULL);
        _exit(127);
    }
    close(to_server[0]);
    close(from_server[1]);
    uint32_t version_request[2] = { 0, 2 };
    uint32_t reply[2];
    io_all(to_server[1], version_request, sizeof(version_request), true);
    io_all(from_server[0], reply, sizeof(reply), false);
    char version[64] = { 0 };
    io_all(from_server[0], version, reply[1] < sizeof(version) ? reply[1] : 0, false);
    printf("server's clang: %s\n", version);
    int files = argc - split - 1;
    int flags = split - 2;
    double spawned_time = 0;
    double served_time = 0;
    int differences = 0;
    for (int f = 0; f < files; f += 1)
    {
        char* args[64];
        int count = 0;
        for (int i = 0; i < flags; i += 1)
        {
            args[count++] = argv[2 + i];
        }
        args[count++] = argv[split + 1 + f];
        args[count] = NULL;
        char* spawned = NULL;
        size_t spawned_length = 0;
        double t0 = now();
        int spawned_status = spawn(args, &spawned, &spawned_length);
        double t1 = now();
        uint32_t header[2] = { (uint32_t)count, 2 };
        io_all(to_server[1], header, sizeof(header), true);
        for (int i = 0; i < count; i += 1)
        {
            uint32_t length = (uint32_t)strlen(args[i]);
            io_all(to_server[1], &length, sizeof(length), true);
            io_all(to_server[1], args[i], length, true);
        }
        io_all(from_server[0], reply, sizeof(reply), false);
        char* served = malloc(reply[1] + 1);
        io_all(from_server[0], served, reply[1], false);
        double t2 = now();
        spawned_time += t1 - t0;
        served_time += t2 - t1;
        bool same = (int32_t)reply[0] == spawned_status && reply[1] == spawned_length && memcmp(served, spawned, spawned_length) == 0;
        if (!same)
        {
            differences += 1;
            if (differences <= 2)
            {
                printf("DIFFERENT %s: spawned status %d, %zu bytes:\n%.*s\nserved status %d, %u bytes:\n%.*s\n", args[count - 1],
                       spawned_status, spawned_length, (int)spawned_length, spawned, (int32_t)reply[0], reply[1], (int)reply[1], served);
            }
        }
        free(spawned);
        free(served);
    }
    close(to_server[1]);
    waitpid(server, NULL, 0);
    printf("%d runs: spawned %.1f ms each, served %.1f ms each, %d different\n", files, 1000 * spawned_time / files,
           1000 * served_time / files, differences);
    return differences != 0;
}
