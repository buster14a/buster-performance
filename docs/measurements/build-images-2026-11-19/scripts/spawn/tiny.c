// A minimal static process: no libc, exits at once. The floor of a compile client's own process.
void _start(void)
{
    __asm__ volatile("mov $60, %eax\n xor %edi, %edi\n syscall");
    __builtin_unreachable();
}
