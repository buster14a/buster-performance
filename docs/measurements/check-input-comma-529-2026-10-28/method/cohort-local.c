#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <sched.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

/* Original campaign helper. Each process has one physical CPU and one output.
   The caller rotates binary order and holds the shared host lock per cohort. */
static double seconds(void)
{
    struct timespec value;
    clock_gettime(CLOCK_MONOTONIC, &value);
    return (double)value.tv_sec + (double)value.tv_nsec / 1000000000.0;
}

int main(int argc, char **argv)
{
    int result = 2;
    if (argc >= 8)
    {
        unsigned jobs = (unsigned)strtoul(argv[1], NULL, 10);
        unsigned tasks = (unsigned)strtoul(argv[2], NULL, 10);
        cpu_set_t inherited;
        CPU_ZERO(&inherited);
        const bool affinity = sched_getaffinity(0, sizeof(inherited), &inherited) == 0;
        int selected_cpu = -1;
        for (int cpu = 0; affinity && selected_cpu < 0 && cpu < CPU_SETSIZE; cpu += 1)
        {
            if (CPU_ISSET(cpu, &inherited)) selected_cpu = cpu;
        }
        struct stat input;
        if (jobs == 1 && selected_cpu >= 0 && tasks >= jobs && tasks <= 10000 && stat(argv[3], &input) == 0 &&
            (mkdir(argv[4], 0755) == 0 || errno == EEXIST))
        {
            // Local screening stays inside the inherited cores grant; target CPU2 placement is a separate campaign.
            const int cpus[8] = {selected_cpu};
            pid_t running[8] = {0};
            unsigned indices[8] = {0};
            unsigned launched = 0, finished = 0, failed = 0;
            double user = 0, system = 0;
            long rss = 0, minor = 0, major = 0, voluntary = 0, involuntary = 0;
            uint64_t output_bytes = 0;
            char detail_path[PATH_MAX];
            snprintf(detail_path, sizeof(detail_path), "%s/children.tsv", argv[4]);
            FILE *details = fopen(detail_path, "w");
            if (details == NULL) return 2;
            fprintf(details, "task\tcpu\tstatus\tuser_s\tsystem_s\tmaxrss_kb\tminor_faults\tmajor_faults\tvoluntary_cs\tinvoluntary_cs\tobject_bytes\n");
            const double begin = seconds();
            while (finished < tasks)
            {
                for (unsigned slot = 0; slot < jobs && launched < tasks; slot += 1)
                {
                    if (running[slot] != 0) continue;
                    const unsigned index = launched++;
                    const pid_t child = fork();
                    if (child == 0)
                    {
                        cpu_set_t set;
                        CPU_ZERO(&set);
                        CPU_SET(cpus[slot], &set);
                        if (sched_setaffinity(0, sizeof(set), &set) != 0) _exit(125);
                        char output[PATH_MAX], error[PATH_MAX];
                        snprintf(output, sizeof(output), "%s/output-%04u.o", argv[4], index);
                        snprintf(error, sizeof(error), "%s/stderr-%04u.txt", argv[4], index);
                        int fd = open(error, O_WRONLY | O_CREAT | O_TRUNC, 0644);
                        int quiet = open("/dev/null", O_WRONLY);
                        if (fd < 0 || quiet < 0 || dup2(fd, 2) < 0 || dup2(quiet, 1) < 0) _exit(125);
                        close(fd);
                        close(quiet);
                        char **command = calloc((size_t)argc, sizeof(char *));
                        if (command == NULL) _exit(125);
                        for (int a = 5; a < argc; a += 1)
                            command[a - 5] = strcmp(argv[a], "@OUTPUT@") == 0 ? output : argv[a];
                        execv(command[0], command);
                        _exit(127);
                    }
                    if (child < 0) { perror("fork"); return 2; }
                    running[slot] = child;
                    indices[slot] = index;
                }
                int status = 0;
                struct rusage usage;
                pid_t child;
                do { child = wait4(-1, &status, 0, &usage); } while (child < 0 && errno == EINTR);
                if (child < 0) { perror("wait4"); return 2; }
                for (unsigned slot = 0; slot < jobs; slot += 1)
                {
                    if (running[slot] != child) continue;
                    int code = WIFEXITED(status) ? WEXITSTATUS(status) : 128 + WTERMSIG(status);
                    char output[PATH_MAX];
                    snprintf(output, sizeof(output), "%s/output-%04u.o", argv[4], indices[slot]);
                    struct stat object;
                    uint64_t bytes = 0;
                    if (stat(output, &object) == 0) bytes = (uint64_t)object.st_size;
                    if (bytes == 0 && code == 0) code = 124;
                    failed += code != 0;
                    const double u = (double)usage.ru_utime.tv_sec + (double)usage.ru_utime.tv_usec / 1000000.0;
                    const double s = (double)usage.ru_stime.tv_sec + (double)usage.ru_stime.tv_usec / 1000000.0;
                    user += u;
                    system += s;
                    if (usage.ru_maxrss > rss) rss = usage.ru_maxrss;
                    minor += usage.ru_minflt;
                    major += usage.ru_majflt;
                    voluntary += usage.ru_nvcsw;
                    involuntary += usage.ru_nivcsw;
                    output_bytes += bytes;
                    fprintf(details, "%u\t%d\t%d\t%.6f\t%.6f\t%ld\t%ld\t%ld\t%ld\t%ld\t%llu\n", indices[slot], cpus[slot], code, u, s, usage.ru_maxrss, usage.ru_minflt, usage.ru_majflt, usage.ru_nvcsw, usage.ru_nivcsw, (unsigned long long)bytes);
                    running[slot] = 0;
                    finished += 1;
                }
            }
            const double elapsed = seconds() - begin;
            fclose(details);
            printf("{\"jobs\":%u,\"tasks\":%u,\"failures\":%u,\"source_bytes\":%lld,\"wall_s\":%.9f,\"MB_per_s\":%.6f,\"user_s\":%.6f,\"system_s\":%.6f,\"maxrss_kb\":%ld,\"minor_faults\":%ld,\"major_faults\":%ld,\"voluntary_cs\":%ld,\"involuntary_cs\":%ld,\"output_bytes\":%llu}\n", jobs, tasks, failed, (long long)input.st_size, elapsed, (double)input.st_size * (tasks - failed) / elapsed / 1000000.0, user, system, rss, minor, major, voluntary, involuntary, (unsigned long long)output_bytes);
            result = failed != 0;
        }
    }
    if (result == 2) fprintf(stderr, "usage: cohort JOBS TASKS INPUT OUTDIR BINARY ARG... -o @OUTPUT@\n");
    return result;
}
