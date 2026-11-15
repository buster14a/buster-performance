static int bench_single_backward(void)
{
    const char* path = getenv("BUSTER_LINE_BENCH");
    FILE* file = fopen(path, "rb");
    if (file == NULL || fseek(file, 0, SEEK_END) != 0) return 1;
    const long length = ftell(file);
    if (length <= 0 || (unsigned long)length > UINT32_MAX || fseek(file, 0, SEEK_SET) != 0) return 1;
    uint8_t* bytes = malloc((size_t)length);
    if (bytes == NULL || fread(bytes, 1, (size_t)length, file) != (size_t)length) return 1;
    fclose(file);
    PPFileData data = { .bytes = bytes, .length = (uint32_t)length };
    PPRange range = { .base = 1000, .length = (uint32_t)length, .file = 0, .bytes = bytes };
    PPFile pp_file = { .data = 0 };
    static Preprocessor pp;
    pp.ranges = &range; pp.files = &pp_file; pp.datas = &data;
    pp.arena = arena_reserve(1 << 20);
    if (pp.arena.base == NULL) return 1;
    uint32_t offsets[] = { 0, (uint32_t)length / 2, (uint32_t)length - 1 };
    for (unsigned k = 0; k < 3; k += 1)
    {
        const uint32_t expected = 1 + pp_count_lines(&data, 0, offsets[k]);
        for (unsigned i = 0; i < 22; i += 1)
        {
            arena_pop_to(&pp.arena, 0);
            data.line_pages = NULL; data.line_cursor = (uint32_t)length; data.line_cursor_line = 1;
            struct timespec a, b;
            clock_gettime(CLOCK_MONOTONIC, &a);
            const uint32_t actual = pp_line_of(&pp, 0, 1000 + offsets[k], NULL);
            clock_gettime(CLOCK_MONOTONIC, &b);
            if (actual != expected) return 1;
            if (i != 0) printf("offset=%u ns=%lld indexed=%d\n", offsets[k], (long long)(b.tv_sec-a.tv_sec)*1000000000LL + b.tv_nsec-a.tv_nsec, data.line_pages != NULL);
        }
    }
    arena_release(&pp.arena); free(bytes); return 0;
}
