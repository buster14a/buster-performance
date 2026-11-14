#include <string.h>

int a_length(const char* text)
{
    return (int)strlen(text);
}

int a_sum(const int* values, int count)
{
    int sum = 0;
    for (int i = 0; i < count; i += 1)
    {
        sum += values[i];
    }
    return sum;
}
int main(void)
{
    return 0;
}
