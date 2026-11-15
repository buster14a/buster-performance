// A struct of N longs copied from a source nothing has written for a long time: no store is in flight.
struct Big { long a[N]; };
void k_cold(struct Big *out, const struct Big *in) { *out = *in; }
