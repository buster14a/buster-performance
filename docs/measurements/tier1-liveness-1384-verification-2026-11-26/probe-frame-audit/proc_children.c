#define _GNU_SOURCE
#include <sys/prctl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <signal.h>
#include <poll.h>
struct Child { pid_t pid; pid_t session; int error; };
int main(void)
{
    errno = 0;
    int sub = prctl(PR_SET_CHILD_SUBREAPER, 1);
    printf("PR_SET_CHILD_SUBREAPER=%d errno=%d (%s)\n", sub, errno, strerror(errno));
    if (sub != 0) return 1;
    int pair[2];
    if (pipe(pair) != 0) return 2;
    pid_t child = fork();
    if (child == 0)
    {
        close(pair[0]);
        pid_t grandchild = fork();
        if (grandchild == 0)
        {
            errno = 0;
            struct Child report = { .pid = getpid() };
            report.session = setsid();
            report.error = errno;
            ssize_t sent = write(pair[1], &report, sizeof(report));
            close(pair[1]);
            usleep(500000);
            _exit(sent == sizeof(report) ? 0 : 3);
        }
        close(pair[1]);
        _exit(grandchild > 0 ? 0 : 4);
    }
    close(pair[1]);
    struct pollfd poller = { .fd = pair[0], .events = POLLIN };
    struct Child report = { 0 };
    int ready = poll(&poller, 1, 2000);
    ssize_t received = ready > 0 ? read(pair[0], &report, sizeof(report)) : -1;
    close(pair[0]);
    int status = 0;
    pid_t waited = waitpid(child, &status, 0);
    printf("direct_child_wait=%ld exited=%d status=%d\n", (long)waited, WIFEXITED(status), WIFEXITED(status) ? WEXITSTATUS(status) : -1);
    char path[128];
    snprintf(path, sizeof(path), "/proc/self/task/%ld/children", (long)getpid());
    errno = 0;
    FILE *file = fopen(path, "r");
    int proc_error = errno;
    printf("proc_children_open=%s errno=%d (%s) path=%s\n", file ? "success" : "failure", proc_error, strerror(proc_error), path);
    if (file != NULL)
    {
        char line[256];
        if (fgets(line, sizeof(line), file) != NULL) printf("children=%s\n", line);
        fclose(file);
    }
    printf("grandchild_report_bytes=%ld pid=%ld setsid=%ld errno=%d (%s)\n", (long)received, (long)report.pid, (long)report.session, report.error, strerror(report.error));
    errno = 0;
    pid_t grandchild_wait = report.pid > 0 ? waitpid(report.pid, &status, 0) : -1;
    printf("adopted_grandchild_wait=%ld errno=%d (%s) exited=%d status=%d\n", (long)grandchild_wait, errno, strerror(errno), WIFEXITED(status), WIFEXITED(status) ? WEXITSTATUS(status) : -1);
    return received == sizeof(report) && report.session > 0 && waited == child && grandchild_wait == report.pid ? 0 : 5;
}
