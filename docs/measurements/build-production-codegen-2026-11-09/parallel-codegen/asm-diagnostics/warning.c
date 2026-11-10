int warning_directive(int value)
{
    __asm__ volatile(".warning \"codegen diagnostic fixture\"" : "+r"(value));
    return value;
}
