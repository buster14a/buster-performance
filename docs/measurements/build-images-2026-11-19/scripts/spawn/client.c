// A resident compiler's client at its floor: a static process with no libc that connects to the server's Unix socket,
// sends its arguments with its standard descriptors and its working directory (SCM_RIGHTS), waits for a one-byte status
// and exits with it. An experiment for the design, not compiler code.
typedef unsigned long u64;
static long sys(long n, long a, long b, long c, long d, long e, long f)
{
    long r;
    register long r10 __asm__("r10") = d;
    register long r8 __asm__("r8") = e;
    register long r9 __asm__("r9") = f;
    __asm__ volatile("syscall" : "=a"(r) : "a"(n), "D"(a), "S"(b), "d"(c), "r"(r10), "r"(r8), "r"(r9) : "rcx", "r11", "memory");
    return r;
}
struct sockaddr_un { unsigned short family; char path[108]; };
struct iovec { void* base; u64 len; };
struct msghdr { void* name; int namelen; struct iovec* iov; u64 iovlen; void* control; u64 controllen; int flags; };
struct cmsghdr { u64 len; int level; int type; int fds[4]; };
static const char socket_path[] = "/dev/shm/build-images-server.sock";
__attribute__((noreturn)) void start(long* stack)
{
    long argc = stack[0];
    char** argv = (char**)(stack + 1);
    int fd = (int)sys(41, 1, 1, 0, 0, 0, 0); // socket(AF_UNIX, SOCK_STREAM)
    struct sockaddr_un address = { .family = 1 };
    for (int i = 0; socket_path[i] != 0; i += 1) address.path[i] = socket_path[i];
    int status = 99;
    if (sys(42, fd, (long)&address, sizeof address, 0, 0, 0) == 0) // connect
    {
        char buffer[4096];
        u64 length = 0;
        for (long a = 0; a < argc; a += 1)
        {
            for (char* p = argv[a]; *p != 0 && length < sizeof buffer - 1; p += 1) buffer[length++] = *p;
            if (length < sizeof buffer) buffer[length++] = 0;
        }
        int cwd = (int)sys(257, -100, (long)".", 0x200000 | 0x10000, 0, 0, 0); // openat(AT_FDCWD, ".", O_PATH|O_DIRECTORY)
        struct iovec io = { buffer, length };
        struct cmsghdr control = { .len = sizeof(u64) + 2 * sizeof(int) + 4 * sizeof(int), .level = 1, .type = 1, .fds = { 0, 1, 2, cwd } };
        struct msghdr message = { .iov = &io, .iovlen = 1, .control = &control, .controllen = sizeof control };
        sys(46, fd, (long)&message, 0, 0, 0, 0); // sendmsg
        unsigned char reply = 99;
        if (sys(0, fd, (long)&reply, 1, 0, 0, 0) == 1) status = reply; // read
    }
    sys(60, status, 0, 0, 0, 0, 0);
    __builtin_unreachable();
}
__asm__(".globl _start\n_start:\n mov %rsp, %rdi\n and $-16, %rsp\n call start\n");
