typedef unsigned int uint32_t;
uint32_t reverse_sum(const uint32_t *a, uint32_t n)
{
    uint32_t sum = 0;
    for (uint32_t i = n; i != 0; --i)
        sum += a[i - 1];
    return sum;
}
