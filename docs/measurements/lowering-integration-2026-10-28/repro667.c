int tested(int n)
{
    char bytes[160] = "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz";
    double value = __builtin_sqrt((double)n);
    return bytes[n & 15] + (int)value;
}
