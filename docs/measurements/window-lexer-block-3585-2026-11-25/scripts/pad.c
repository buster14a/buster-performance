// A function of PAD bytes of nops, linked ahead of c_direct.c's code to move it (placement copies of an arm).
#ifndef PAD
#define PAD 0
#endif
#define BUSTER_STR2(x) #x
#define BUSTER_STR(x) BUSTER_STR2(x)
__attribute__((used, noinline)) void buster_placement_pad(void)
{
    __asm__ volatile(".fill " BUSTER_STR(PAD) ", 1, 0x90");
}
