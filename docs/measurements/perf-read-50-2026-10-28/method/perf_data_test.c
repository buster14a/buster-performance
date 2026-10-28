/* Original synthetic ABI fixtures; no captured workload or upstream source.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */
#define _POSIX_C_SOURCE 200809L
#include "perf_data.h"
#include <inttypes.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

typedef struct
{
    unsigned char bytes[4096];
    size_t size;
    size_t data;
    size_t attrs;
    unsigned count;
    uint64_t sample_type;
    uint64_t read_format;
} Fixture;
static unsigned cases;
static unsigned failures;
static PerfDataSummary last_summary;
static void put(Fixture *f, size_t at, uint64_t value, unsigned width)
{
    for (unsigned i = 0; i < width; i++)
        f->bytes[at + i] = (unsigned char)(value >> (8 * i));
}
static void word(Fixture *f, uint64_t value)
{
    put(f, f->size, value, 8);
    f->size += 8;
}
static void init(Fixture *f, unsigned count, uint64_t sample_type, uint64_t read_format)
{
    memset(f, 0, sizeof(*f));
    f->count = count;
    f->sample_type = sample_type;
    f->read_format = read_format;
    f->attrs = 104 + count * 8;
    f->data = f->attrs + count * 96;
    f->size = f->data;
    memcpy(f->bytes, "PERFILE2", 8);
    put(f, 8, 104, 8);
    put(f, 16, 96, 8);
    put(f, 24, f->attrs, 8);
    put(f, 32, count * 96, 8);
    put(f, 40, f->data, 8);
    for (unsigned i = 0; i < count; i++)
    {
        size_t a = f->attrs + i * 96;
        put(f, 104 + i * 8, i + 1, 8);
        put(f, a + 4, 80, 4);
        put(f, a + 24, sample_type, 8);
        put(f, a + 32, read_format, 8);
        put(f, a + 40, UINT64_C(1) << 18, 8);
        put(f, a + 80, 104 + i * 8, 8);
        put(f, a + 88, 8, 8);
    }
}
static void header(Fixture *f, size_t start, unsigned type)
{
    put(f, start, type, 4);
    put(f, start + 6, f->size - start, 2);
    put(f, 48, f->size - f->data, 8);
}
static void append_values(Fixture *f, unsigned owner, uint64_t lost)
{
    unsigned nr = (f->read_format & 8) ? f->count : 1;
    if (f->read_format & 8)
        word(f, nr);
    else
        word(f, 5);
    if (f->read_format & 1)
        word(f, 10);
    if (f->read_format & 2)
        word(f, 9);
    for (unsigned i = 0; i < nr; i++)
    {
        if (f->read_format & 8)
            word(f, 5);
        word(f, (f->read_format & 8) ? i + 1 : owner);
        if (f->read_format & 16)
            word(f, lost);
    }
}
static void add_sample(Fixture *f, unsigned owner, uint64_t time, uint64_t lost)
{
    size_t start = f->size;
    word(f, 0);
    word(f, owner);
    word(f, time);
    if (f->sample_type & 16)
        append_values(f, owner, lost);
    header(f, start, 9);
}
static size_t add_read(Fixture *f, unsigned owner, uint64_t lost)
{
    size_t start = f->size;
    word(f, 0);
    word(f, 1); /* pid/tid, not part of attribute selection */
    append_values(f, owner, lost);
    word(f, 20);
    word(f, owner);
    header(f, start, 8);
    return start;
}
static void check(const char *name, Fixture *f, int expected, uint64_t decoded)
{
    char path[] = "perf-data-synthetic-XXXXXX";
    int fd = mkstemp(path);
    if (fd < 0)
        exit(2);
    FILE *file = fdopen(fd, "wb");
    if (!file || fwrite(f->bytes, 1, f->size, file) != f->size || fclose(file))
        exit(2);
    FILE *receipt = tmpfile();
    if (!receipt)
        exit(2);
    PerfDataSummary summary;
    int actual = perf_data_scan(path, receipt, &summary);
    last_summary = summary;
    unlink(path);
    cases++;
    int good = (actual == 0) == expected;
    if (expected)
        good = good && summary.complete && summary.accepted && summary.decoded_events == decoded;
    if (!good)
    {
        failures++;
        fprintf(stderr, "FAIL %s: returned %d, complete %d, decoded %" PRIu64 "\n", name, actual,
                summary.complete, summary.decoded_events);
        rewind(receipt);
        int c;
        while ((c = fgetc(receipt)) != EOF)
            fputc(c, stderr);
    }
    fclose(receipt);
}
static void check_duty(uint64_t known, uint64_t zero, uint64_t partial, uint64_t enabled,
                       uint64_t running)
{
    PerfDataAttribute *a = last_summary.attributes;
    cases++;
    if (a->duty_known_intervals != known || a->duty_zero_intervals != zero ||
        a->duty_partial_intervals != partial || a->duty_min_enabled != enabled ||
        a->duty_min_running != running)
    {
        failures++;
        fputs("FAIL duty interval classification or minimum ratio\n", stderr);
    }
}
int main(int argc, char **argv)
{
    Fixture f;
    if (argc == 3 && (!strcmp(argv[1], "--emit-clean") || !strcmp(argv[1], "--emit-partial-duty") ||
                      !strcmp(argv[1], "--emit-zero-duty") || !strcmp(argv[1], "--emit-two-clean")))
    {
        int two = !strcmp(argv[1], "--emit-two-clean");
        int duty = strcmp(argv[1], "--emit-clean") != 0 && !two;
        init(&f, two ? 2 : 1, duty ? 0x10014 : 0x10004, duty ? 0x17 : 4);
        add_sample(&f, 1, 10, 0);
        if (two)
        {
            add_sample(&f, 2, 11, 0);
            add_sample(&f, 2, 12, 0);
        }
        if (duty)
        {
            int zero = !strcmp(argv[1], "--emit-zero-duty");
            put(&f, f.data + 32, zero ? 0 : 100, 8);
            put(&f, f.data + 40, zero ? 0 : 90, 8);
        }
        FILE *file = fopen(argv[2], "wb");
        if (!file || fwrite(f.bytes, 1, f.size, file) != f.size || fclose(file))
            return 2;
        printf("synthetic_fixture\tattributes\t%u\tsamples\t%u\tdecoded_events\t%u\n", two ? 2 : 1, two ? 3 : 1, two ? 3 : 1);
        return 0;
    }
    if (argc != 1)
        return 2;
    init(&f, 1, 0x10004, 4);
    add_sample(&f, 1, 10, 0);
    check("single event", &f, 1, 1);
    add_sample(&f, 1, 9, 0);
    check("physical time reorder is diagnostic", &f, 1, 2);
    init(&f, 2, 0x10014, 0x1c);
    add_sample(&f, 1, 10, 0);
    check("group supplies both attributes", &f, 1, 2);
    size_t read = add_read(&f, 2, 0);
    check("group READ", &f, 1, 2);
    put(&f, f.size - 8, 999, 8);
    check("unknown READ trailer ID", &f, 0, 0);
    put(&f, f.size - 8, 2, 8);
    put(&f, read + 6, f.size - read - 8, 2);
    check("READ advertised size shorter than ABI", &f, 0, 0);
    init(&f, 1, 0x10014, 0x17);
    add_sample(&f, 1, 10, 0);
    add_read(&f, 1, 0);
    check("non-group value precedes times", &f, 1, 1);
    init(&f, 1, 0x10014, 0x17);
    add_sample(&f, 1, 10, 1);
    check("sample READ lost count", &f, 0, 0);
    init(&f, 2, 0x10014, 0x1c);
    add_sample(&f, 1, 10, 0);
    add_read(&f, 1, 1);
    check("READ lost count", &f, 0, 0);
    init(&f, 1, 0x10004, 4);
    add_sample(&f, 1, 10, 0);
    put(&f, f.data + 8, 999, 8);
    check("unknown sample identifier", &f, 0, 0);
    init(&f, 2, 0x10014, 0x1c);
    add_sample(&f, 1, 10, 0);
    put(&f, f.data + 40, 999, 8);
    check("unknown group identifier", &f, 0, 0);
    put(&f, f.data + 40, 2, 8);
    put(&f, f.data + 64, 2, 8);
    check("duplicate group attribute", &f, 0, 0);
    init(&f, 2, 0x10004, 4);
    add_sample(&f, 1, 10, 0);
    check("missing expected attribute coverage", &f, 0, 0);
    init(&f, 1, 0x10004, 4);
    check("no samples", &f, 0, 0);
    f.bytes[f.size++] = 9;
    put(&f, 48, 1, 8);
    check("trailing partial record header", &f, 0, 0);
    init(&f, 1, 0x10004, 4);
    add_sample(&f, 1, 10, 0);
    put(&f, 40, UINT64_MAX, 8);
    check("overflowing data offset", &f, 0, 0);
    init(&f, 1, 0x10004, 4);
    add_sample(&f, 1, 10, 0);
    put(&f, f.attrs + 80, f.data, 8);
    check("ID table overlaps data", &f, 0, 0);
    init(&f, 1, 0x10004, 4);
    add_sample(&f, 1, 10, 0);
    put(&f, f.attrs + 24, 0x11004, 8);
    check("unsupported sample bit", &f, 0, 0);
    init(&f, 1, 0x10004, 4);
    add_sample(&f, 1, 10, 0);
    put(&f, f.attrs + 4, 97, 4);
    check("attribute body larger than entry", &f, 0, 0);
    init(&f, 2, 0x10004, 4);
    add_sample(&f, 1, 10, 0);
    put(&f, 112, 1, 8);
    check("duplicate attribute identifier", &f, 0, 0);
    init(&f, 1, 0x10004, 4);
    add_sample(&f, 1, 10, 0);
    put(&f, f.data + 6, 25, 2);
    check("record exceeds data section", &f, 0, 0);
    init(&f, 1, 0x10004, 4);
    add_sample(&f, 1, 10, 0);
    put(&f, f.data, 250, 4);
    check("unsupported record type", &f, 0, 0);
    init(&f, 1, 0x10004, 4);
    add_sample(&f, 1, 10, 0);
    put(&f, 72, UINT64_C(1) << 27, 8);
    f.size += 16;
    check("compressed feature", &f, 0, 0);
    for (unsigned type = 68; type <= 82; type++)
    {
        if (type != 68 && type != 69 && type != 73 && type != 74 && type != 78 && type != 79 &&
            type != 82)
            continue;
        init(&f, 1, 0x10004, 4);
        add_sample(&f, 1, 10, 0);
        size_t start = f.size;
        word(&f, 0);
        if (type == 68 || type == 82)
            word(&f, 0); /* Fixed markers must not hide an extra payload. */
        header(&f, start, type);
        check("malformed user metadata payload", &f, 0, 0);
    }
    for (unsigned type = 3; type <= 17; type++)
    {
        if (type != 3 && type != 10 && type != 17)
            continue;
        init(&f, 1, 0x10004, 4);
        add_sample(&f, 1, 10, 0);
        size_t start = f.size;
        f.size += type == 3 ? 16 : type == 10 ? 72 : 24;
        word(&f, 20);
        word(&f, 1);
        header(&f, start, type);
        check("metadata name absent", &f, 0, 0);
    }
    init(&f, 1, 0x10004, 4);
    add_sample(&f, 1, 10, 0);
    put(&f, 56, UINT64_MAX, 8);
    put(&f, 64, 8, 8);
    check("unsupported legacy event section", &f, 0, 0);
    init(&f, 2, 0x10014, 0x1c);
    add_sample(&f, 1, 10, 0);
    put(&f, f.data + 24, 1, 8); /* Keep only second attribute's value triple. */
    put(&f, f.data + 40, 2, 8);
    f.size -= 24;
    header(&f, f.data, 9);
    check("sample group lacks owner", &f, 0, 0);
    init(&f, 1, 0x10014, 0x17);
    add_sample(&f, 1, 10, 0);
    put(&f, f.data + 40, 11, 8); /* running exceeds enabled=10. */
    check("running time exceeds enabled", &f, 0, 0);
    init(&f, 1, 0x10004, 4);
    add_sample(&f, 1, 10, 0);
    size_t start = f.size;
    word(&f, 0);
    word(&f, 1);
    word(&f, 2);
    word(&f, 20);
    word(&f, 1);
    header(&f, start, 2);
    check("LOST record", &f, 0, 0);
    init(&f, 1, 0x10004, 4);
    add_sample(&f, 1, 10, 0);
    start = f.size;
    word(&f, 0);
    word(&f, 2);
    word(&f, 20);
    word(&f, 1);
    header(&f, start, 13);
    check("LOST_SAMPLES record", &f, 0, 0);
    init(&f, 1, 0x101848f, 0x14);
    start = f.size;
    word(&f, 0);
    word(&f, 1); /* identifier */
    word(&f, 0); /* IP */
    word(&f, 0); /* PID/TID */
    word(&f, 10);
    word(&f, 0); /* address */
    word(&f, 0); /* CPU */
    word(&f, 4); /* u32 RAW size=4 and four bytes raw payload */
    word(&f, 0); /* weight structure */
    word(&f, 0); /* data source */
    header(&f, start, 9);
    check("IBS-shaped raw sample", &f, 1, 1);
    put(&f, start + 56, 1000, 4);
    check("raw data length beyond record", &f, 0, 0);
    init(&f, 1, 0x10004, 4);
    add_sample(&f, 1, 10, 0);
    start = f.size;
    word(&f, 0);
    word(&f, 1);
    word(&f, 0); /* one u64 zero-padded comm string */
    word(&f, 0); /* synthetic zero TIME */
    word(&f, 0); /* synthetic zero IDENTIFIER */
    header(&f, start, 3);
    check("synthetic comm with zero identity trailer", &f, 1, 1);
    f.bytes[start + 16] = 'x';
    memset(f.bytes + start + 17, 'x', 7);
    check("metadata string not terminated", &f, 0, 0);
    init(&f, 1, 0x10004, 4);
    add_sample(&f, 1, 10, 0);
    start = f.size;
    word(&f, 0);
    word(&f, 0); /* ID_INDEX count=0 */
    header(&f, start, 69);
    check("empty index metadata retains sample coverage", &f, 1, 1);
    init(&f, 1, 0x10014, 0x17);
    add_sample(&f, 1, 10, 0);
    start = add_read(&f, 1, 0);
    put(&f, start + 16, 999, 8); /* Value, not time_enabled: must remain valid. */
    check("non-group READ high value distinct from duty times", &f, 1, 1);
    init(&f, 1, 0x10004, 4);
    add_sample(&f, 1, 10, 0);
    start = f.size;
    f.size += 17; /* Base plus a single NUL, without ABI alignment padding. */
    word(&f, 20);
    word(&f, 1);
    header(&f, start, 3);
    check("unaligned COMM record", &f, 0, 0);
    init(&f, 1, 0x10004, 4);
    add_sample(&f, 1, 10, 0);
    start = f.size;
    word(&f, 0);
    word(&f, 20);
    word(&f, 1);
    word(&f, 1);
    word(&f, 20);
    word(&f, 1);
    header(&f, start, 6);
    check("lone UNTHROTTLE record", &f, 0, 0);
    init(&f, 1, 0x10014, 0x17);
    add_sample(&f, 1, 10, 0);
    check("known partial duty", &f, 1, 1);
    check_duty(1, 0, 1, 10, 9);
    start = f.size;
    add_sample(&f, 1, 11, 0);
    put(&f, start + 32, 20, 8);
    put(&f, start + 40, 19, 8);
    check("minimum duty ratio keeps lower earlier fraction", &f, 1, 2);
    check_duty(2, 0, 2, 10, 9);
    start = f.size;
    add_sample(&f, 1, 12, 0);
    put(&f, start + 32, 100, 8);
    put(&f, start + 40, 70, 8);
    check("minimum duty ratio replaces with lower later fraction", &f, 1, 3);
    check_duty(3, 0, 3, 100, 70);
    start = f.size;
    add_sample(&f, 1, 13, 0);
    put(&f, start + 32, 0, 8);
    put(&f, start + 40, 0, 8);
    check("zero-zero duty is unavailable", &f, 1, 4);
    check_duty(3, 1, 3, 100, 70);
    init(&f, 1, 0x10014, 0x17);
    add_sample(&f, 1, 10, 0);
    put(&f, f.data + 32, UINT64_MAX, 8);
    put(&f, f.data + 40, UINT64_MAX - 1, 8);
    start = f.size;
    add_sample(&f, 1, 11, 0);
    put(&f, start + 32, UINT64_MAX - 1, 8);
    put(&f, start + 40, UINT64_MAX - 2, 8);
    check("minimum duty fraction cross-products fit 128 bits", &f, 1, 2);
    check_duty(2, 0, 2, UINT64_MAX - 1, UINT64_MAX - 2);
    init(&f, 1, 0x10004, 4);
    add_sample(&f, 1, 10, 0);
    put(&f, f.attrs + 24, 0x10044, 8);
    check("optional group-leader ID profile unsupported", &f, 0, 0);
    put(&f, f.attrs + 24, 0x10204, 8);
    check("optional actual-event STREAM_ID profile unsupported", &f, 0, 0);
    fprintf(stdout, "perf_data_tests\tcases\t%u\tfailures\t%u\n", cases, failures);
    return failures ? 1 : 0;
}
