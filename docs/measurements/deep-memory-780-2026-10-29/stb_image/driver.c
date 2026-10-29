// Decodes each image with stb_image and prints its size, channels and an FNV-1a hash of its pixels: 8-bit, 16-bit
// and float loads, each as the file has its channels and as RGBA.
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
unsigned char* stbi_load(const char* filename, int* x, int* y, int* comp, int req_comp);
unsigned short* stbi_load_16(const char* filename, int* x, int* y, int* comp, int req_comp);
float* stbi_loadf(const char* filename, int* x, int* y, int* comp, int req_comp);
void stbi_image_free(void* retval_from_stbi_load);
const char* stbi_failure_reason(void);
static uint64_t fnv(const void* bytes, size_t length)
{
    const unsigned char* p = bytes;
    uint64_t h = 1469598103934665603ull;
    for (size_t i = 0; i < length; i += 1)
    {
        h = (h ^ p[i]) * 1099511628211ull;
    }
    return h;
}
int main(int argc, char** argv)
{
    for (int a = 1; a < argc; a += 1)
    {
        for (int want = 0; want <= 4; want += 4)
        {
            int w = 0, h = 0, c = 0;
            unsigned char* p8 = stbi_load(argv[a], &w, &h, &c, want);
            int channels = want != 0 ? want : c;
            printf("%s want %d u8: %dx%dx%d %016llx\n", argv[a], want, w, h, c, p8 != 0 ? (unsigned long long)fnv(p8, (size_t)w * (size_t)h * (size_t)channels) : 0ull);
            stbi_image_free(p8);
            unsigned short* p16 = stbi_load_16(argv[a], &w, &h, &c, want);
            channels = want != 0 ? want : c;
            printf("%s want %d u16: %dx%dx%d %016llx\n", argv[a], want, w, h, c, p16 != 0 ? (unsigned long long)fnv(p16, (size_t)w * (size_t)h * (size_t)channels * 2) : 0ull);
            stbi_image_free(p16);
            float* pf = stbi_loadf(argv[a], &w, &h, &c, want);
            channels = want != 0 ? want : c;
            printf("%s want %d f32: %dx%dx%d %016llx\n", argv[a], want, w, h, c, pf != 0 ? (unsigned long long)fnv(pf, (size_t)w * (size_t)h * (size_t)channels * 4) : 0ull);
            stbi_image_free(pf);
        }
    }
    return 0;
}
