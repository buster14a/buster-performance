void flip(float *negative, float *original, const float *input, unsigned n) {
    for (unsigned i=0; i<n; i++) {
        float x = input[i]; negative[i] = -x; original[i] = x;
    }
}
