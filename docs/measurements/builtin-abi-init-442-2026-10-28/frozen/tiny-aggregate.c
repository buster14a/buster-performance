// Original whole-process derived aggregate ABI control.
struct Pair
{
    double value;
    long count;
};

struct Pair increment(struct Pair pair)
{
    pair.count += 1;
    return pair;
}
