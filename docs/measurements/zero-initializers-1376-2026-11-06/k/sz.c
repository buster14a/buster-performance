long s16(int i) { long a[2] = { 0 }; a[i & 1] = i; return a[(i * 7) & 1]; }
long s32(int i) { long a[4] = { 0 }; a[i & 3] = i; return a[(i * 7) & 3]; }
long s64(int i) { long a[8] = { 0 }; a[i & 7] = i; return a[(i * 7) & 7]; }
long s96(int i) { long a[12] = { 0 }; a[i & 7] = i; return a[(i * 7) & 7]; }
long s128(int i) { long a[16] = { 0 }; a[i & 15] = i; return a[(i * 7) & 15]; }
long s136(int i) { long a[17] = { 0 }; a[i & 15] = i; return a[(i * 7) & 15]; }
long s192(int i) { long a[24] = { 0 }; a[i & 15] = i; return a[(i * 7) & 15]; }
long s256(int i) { long a[32] = { 0 }; a[i & 31] = i; return a[(i * 7) & 31]; }
