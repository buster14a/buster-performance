void flip(double *negative, double *original, const double *input, unsigned n) {
    for (unsigned i=0; i<n; i++) {
        double x = input[i]; negative[i] = -x; original[i] = x;
    }
}
