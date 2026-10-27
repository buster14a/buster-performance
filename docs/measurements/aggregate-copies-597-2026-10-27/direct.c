// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original direct-link/ABI regression for large assignment, consumed value and self-assignment.
struct S
{
    unsigned char bytes[16385];
};
static struct S a;
static struct S b;
static struct S c;
static int destinations;
static int sources;
static struct S* destination(void)
{
    destinations += 1;
    return &b;
}
static const struct S* source(void)
{
    sources += 1;
    return &a;
}
int main(void)
{
    for (unsigned i = 0; i < sizeof(a.bytes); i += 1)
    {
        a.bytes[i] = (unsigned char)(i * 37 + 13);
    }
    c = (*destination() = *source());
    b = b;
    int failed = destinations != 1 || sources != 1;
    for (unsigned i = 0; i < sizeof(a.bytes); i += 1)
    {
        failed |= a.bytes[i] != b.bytes[i] || a.bytes[i] != c.bytes[i];
    }
    return failed;
}
