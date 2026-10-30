unsigned tiny_count(unsigned argument)
{
    unsigned folded = argument * 1103515245u + 12345u;
    unsigned shifted = folded ^ (folded >> 13);
    return __builtin_popcount(shifted);
}

int main(void)
{
    return (int)tiny_count(27u);
}
