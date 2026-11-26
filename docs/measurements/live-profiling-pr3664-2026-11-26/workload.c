unsigned mix(unsigned x) { return x * 33u + 1u; }
int main(void)
{
    unsigned x = 0;
    for (unsigned i = 0; i < 1000000; i += 1) x = mix(x);
    return x != 0x6b071e40u;
}
