// A run of the driver whose address space may grow `limit` bytes past `base`: its exit status (-1 if it didn't report),
// how far past `base` its address space grew, and whether it left the address space and the descriptors as they were.
// A child writes them to `shared`, a page both see.
typedef struct ParseTestProbe ParseTestProbe;
struct ParseTestProbe
{
    int status;
    uint64_t peak;
    bool clean;
    char text[1024];
};

// Reads the file at `path` (a /proc file) into `text`, as much as fits.
static void parse_test_read_proc(const char* path, char* text, size_t capacity)
{
    const int fd = open(path, O_RDONLY | O_CLOEXEC);
    size_t length = 0;
    ssize_t got = fd >= 0 ? 1 : 0;
    while (got > 0 && length + 1 < capacity)
    {
        got = read(fd, text + length, capacity - 1 - length);
        length += got > 0 ? (size_t)got : 0;
    }
    if (fd >= 0)
    {
        close(fd);
    }
    text[length] = 0;
}

// Whether `other`, lines ending in '\n', has the line of `length` bytes at `line`.
static bool parse_test_has_line(const char* other, const char* line, size_t length)
{
    bool result = false;
    const char* at = other;
    while (!result && *at != 0)
    {
        const char* end = strchr(at, '\n');
        const size_t other_length = end != 0 ? (size_t)(end - at) : strlen(at);
        result = other_length == length && memcmp(at, line, length) == 0;
        at += other_length + (end != 0);
    }
    return result;
}

// Prints each line of `text` that `other` doesn't have, after `mark`.
static void parse_test_print_lines_missing(const char* text, const char* other, const char* mark)
{
    const char* at = text;
    while (*at != 0)
    {
        const char* end = strchr(at, '\n');
        const size_t length = end != 0 ? (size_t)(end - at) : strlen(at);
        if (!parse_test_has_line(other, at, length))
        {
            dprintf(STDOUT_FILENO, "driver:   %s: %.*s\n", mark, (int)length, at);
        }
        at += length + (end != 0);
    }
}

// What a probe's child that left the address space at `size` bytes, not `base` (`start` when its run began), or the
// lowest free descriptor at `after`, not `before`, prints to the standard output it shares with the parent (#2089): the
// mappings and the descriptors that differ from the parent's, which waits for the child, so its are as they were at the
// fork (the child's standard error is `capture`, the parent's).
static __attribute__((noinline)) void parse_test_report_residue(uint64_t base, uint64_t start, uint64_t size, int before, int after, int capture)
{
    static char parent_maps[1 << 18];
    static char child_maps[1 << 18];
    char path[64];
    snprintf(path, sizeof(path), "/proc/%d/maps", (int)getppid());
    parse_test_read_proc(path, parent_maps, sizeof(parent_maps));
    parse_test_read_proc("/proc/self/maps", child_maps, sizeof(child_maps));
    dprintf(STDOUT_FILENO, "driver: a child's run left VmSize %llu, not %llu (%llu when it began; VmStk %llu), the lowest free descriptor %d, not %d\n",
            (unsigned long long)size, (unsigned long long)base, (unsigned long long)start, (unsigned long long)parse_test_status_bytes("VmStk:"), after, before);
    parse_test_print_lines_missing(parent_maps, child_maps, "the parent's mapping, not the child's");
    parse_test_print_lines_missing(child_maps, parent_maps, "the child's mapping, not the parent's");
    for (int fd = 0; fd < 1024; fd += 1)
    {
        char parent_target[4096];
        char child_target[4096];
        snprintf(path, sizeof(path), "/proc/%d/fd/%d", (int)getppid(), fd == 2 ? capture : fd);
        const ssize_t parent_length = readlink(path, parent_target, sizeof(parent_target) - 1);
        snprintf(path, sizeof(path), "/proc/self/fd/%d", fd);
        const ssize_t child_length = readlink(path, child_target, sizeof(child_target) - 1);
        parent_target[parent_length > 0 ? parent_length : 0] = 0;
        child_target[child_length > 0 ? child_length : 0] = 0;
        if (strcmp(parent_target, child_target) != 0)
        {
            dprintf(STDOUT_FILENO, "driver:   descriptor %d: the parent's \"%s\", the child's \"%s\"\n", fd, parent_target, child_target);
        }
    }
}

// parse_test_probe's run, in a child, or with `warm` in this process, whose caller then restores its RLIMIT_AS and its
// standard error. Out of line, so that the warm run takes the frame a child's does from the same caller: it grows the
// stack as far as the child's run and observations take it. A child that grew it further would find the address space
// larger than its parent's though the run released everything, where the stack's top, which the kernel places at random
// within a page, leaves the deepest frame on a page the parent never touched (#2089).
static __attribute__((noinline, unused)) ParseTestProbe parse_test_probe(char** arguments, int count, int capture, uint64_t base, uint64_t limit, ParseTestProbe* shared,
                                                                        bool preprocess, bool warm)
{
    *shared = (ParseTestProbe){ .status = -1 };
    fflush(stdout);
    const pid_t child = warm ? 0 : fork();
    if (child == 0)
    {
        struct rlimit space;
        bool limited = getrlimit(RLIMIT_AS, &space) == 0 && base + limit <= space.rlim_max;
        space.rlim_cur = base + limit;
        limited = limited && setrlimit(RLIMIT_AS, &space) == 0 && dup2(capture, 2) == 2;
        const int before = parse_test_lowest_descriptor();
        const uint64_t start = parse_test_status_bytes("VmSize:");
        const int status = !limited ? -1 : preprocess ? run_preprocessor_command(count, arguments) : run_parse_command(count, arguments);
        const int after = parse_test_lowest_descriptor();
        shared->peak = parse_test_status_bytes("VmPeak:") - base;
        const uint64_t size = parse_test_status_bytes("VmSize:");
        shared->clean = size == base && after == before;
        shared->status = status;
        if (!warm && !shared->clean)
        {
            parse_test_report_residue(base, start, size, before, after, capture);
        }
        if (!warm)
        {
            _exit(0);
        }
    }
    int child_status = 0;
    pid_t waited = child;
    while (child > 0 && (waited = waitpid(child, &child_status, 0)) < 0 && errno == EINTR)
    {
    }
    ParseTestProbe result = *shared;
    result.status = warm || (child > 0 && waited == child && WIFEXITED(child_status) && WEXITSTATUS(child_status) == 0) ? result.status : -1;
    parse_test_read_capture(capture, result.text, sizeof(result.text));
    return result;
}

