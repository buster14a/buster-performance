#include <stdio.h>
#include <sys/mman.h>
#include <errno.h>
int main(void) { void* p = mmap(0, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0); int r = madvise(p, 4096, 23); printf("madvise 23 -> %d errno %d\n", r, r ? errno : 0); r = madvise(p, 4096, 4); printf("madvise 4 -> %d\n", r); return 0; }
