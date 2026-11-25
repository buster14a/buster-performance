extern const unsigned long values[32768];
int main(void) {
    for (unsigned int i=0; i<32768u; ++i) if (values[i] != 0x80000000UL + i%256u) return 1;
    return 0;
}
