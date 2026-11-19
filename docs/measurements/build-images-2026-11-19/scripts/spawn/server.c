// The other end of client.c: accepts a connection, reads the request and its descriptors, closes them, answers 0.
#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>
int main(void)
{
    const char* path = "/dev/shm/build-images-server.sock";
    unlink(path);
    int listener = socket(AF_UNIX, SOCK_STREAM, 0);
    struct sockaddr_un address = { .sun_family = AF_UNIX };
    strcpy(address.sun_path, path);
    if (bind(listener, (struct sockaddr*)&address, sizeof address) != 0 || listen(listener, 64) != 0) { perror("server"); return 1; }
    for (;;)
    {
        int c = accept(listener, 0, 0);
        char buffer[4096];
        char control[CMSG_SPACE(4 * sizeof(int))];
        struct iovec io = { buffer, sizeof buffer };
        struct msghdr message = { .msg_iov = &io, .msg_iovlen = 1, .msg_control = control, .msg_controllen = sizeof control };
        ssize_t n = recvmsg(c, &message, 0);
        for (struct cmsghdr* h = CMSG_FIRSTHDR(&message); n > 0 && h != 0; h = CMSG_NXTHDR(&message, h))
        {
            int* fds = (int*)CMSG_DATA(h);
            for (size_t k = 0; k < (h->cmsg_len - CMSG_LEN(0)) / sizeof(int); k += 1) close(fds[k]);
        }
        unsigned char status = 0;
        write(c, &status, 1);
        close(c);
    }
}
