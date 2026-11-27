import sys
s=open(sys.argv[1]).read()
def rep(old,new):
    global s
    assert old in s, old[:80]
    s=s.replace(old,new,1)
rep('''static BUSTER_DIRECT_HOT uint8_t fast_pp_skip_inactive(FastPP* pp, FastIncludeFile* f)
{''','''static BUSTER_DIRECT_HOT __attribute__((noinline)) uint8_t fast_pp_skip_inactive(FastPP* pp, FastIncludeFile* f)
{''')
rep('''// ---------------------------------------------------------------------------------------------------------------------
// Include guard cache & file resolution''','''#include <linux/perf_event.h>
#include <sys/syscall.h>
#include <sys/ioctl.h>
static int skip_count_fd = -2;
static uint64_t skip_count_calls;
__attribute__((destructor)) static void skip_count_report(void)
{
    uint64_t v = 0;
    if (skip_count_fd >= 0 && read(skip_count_fd, &v, sizeof(v)) == (ssize_t)sizeof(v))
    {
        fprintf(stderr, "skip-count: %llu instructions in %llu calls\\n", (unsigned long long)v, (unsigned long long)skip_count_calls);
    }
}
static __attribute__((noinline)) uint8_t fast_pp_skip_inactive_counted(FastPP* pp, FastIncludeFile* f)
{
    if (skip_count_fd == -2)
    {
        struct perf_event_attr a;
        memset(&a, 0, sizeof(a));
        a.type = PERF_TYPE_HARDWARE;
        a.size = sizeof(a);
        a.config = PERF_COUNT_HW_INSTRUCTIONS;
        a.disabled = 1;
        a.exclude_kernel = 1;
        a.exclude_hv = 1;
        const int opened = (int)syscall(SYS_perf_event_open, &a, 0, -1, -1, 0);
        skip_count_fd = opened >= 0 ? fcntl(opened, F_DUPFD, 900) : -1;
    }
    skip_count_calls += 1;
    ioctl(skip_count_fd, PERF_EVENT_IOC_ENABLE, 0);
    const uint8_t r = fast_pp_skip_inactive(pp, f);
    ioctl(skip_count_fd, PERF_EVENT_IOC_DISABLE, 0);
    uint64_t v = 0;
    if (skip_count_fd >= 0 && read(skip_count_fd, &v, sizeof(v)) == (ssize_t)sizeof(v))
    {
        char text[64];
        const int n = snprintf(text, sizeof(text), "%llu %llu\\n", (unsigned long long)v, (unsigned long long)skip_count_calls);
        const int out = open("/tmp/3577-claude-skip-count.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
        if (out >= 0)
        {
            ssize_t w = write(out, text, (size_t)n);
            (void)w;
            close(out);
        }
    }
    return r;
}

// ---------------------------------------------------------------------------------------------------------------------
// Include guard cache & file resolution''')
rep('''            const uint8_t kw = fast_pp_skip_inactive(pp, f);''','''            const uint8_t kw = fast_pp_skip_inactive_counted(pp, f);''')
open(sys.argv[2],'w').write(s)
