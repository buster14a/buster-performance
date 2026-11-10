int bad_instruction(int value)
{
    __asm__ volatile("this_is_not_an_x86_instruction" : "+r"(value));
    return value;
}
