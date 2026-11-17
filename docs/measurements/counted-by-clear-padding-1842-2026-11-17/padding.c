// #1842: __builtin_clear_padding's generated code, timed: argv[1] "large" clears a record holding a 64-element inner
// array (a table's loop) 2 million times, "small" one holding a 2-element inner array (stores in place) 50 million.
struct A { char c; int i; short s; };
struct H { char c; struct A a[64]; short t : 3; };
struct S { char c; struct A a[2]; long l; };
static struct H large[16];
static struct S small[64];
volatile unsigned sink;
int main(int argc, char** argv)
{
    const int which = argc > 1 && argv[1][0] == 's';
    unsigned total = 0;
    const unsigned long rounds = which ? 50000000ul : 2000000ul;
    for (unsigned long r = 0; r < rounds; r += 1)
    {
        if (which)
        {
            __builtin_clear_padding(&small[r & 63]);
            total += (unsigned)small[r & 63].c;
        }
        else
        {
            __builtin_clear_padding(&large[r & 15]);
            total += (unsigned)large[r & 15].c;
        }
    }
    sink = total;
    return 0;
}
