/* Original synthetic fixture writer. Wire fields follow Perfetto v58.2's
 * published protobuf schemas; this is not a new capture encoding or collector. */
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct
{
    unsigned char data[8192];
    size_t size;
} Buffer;

typedef struct
{
    uint64_t timestamp;
    unsigned field;
    unsigned order;
    Buffer body;
} Pending;

static Pending pending[64];
static size_t pending_count;
static FILE *output;
static const uint64_t origin = 1000000000;

static void varint(Buffer *b, uint64_t value)
{
    do
    {
        assert(b->size < sizeof(b->data));
        b->data[b->size++] = (unsigned char)((value & 127) | (value > 127 ? 128 : 0));
        value >>= 7;
    } while (value);
}

static void number(Buffer *b, unsigned field, uint64_t value)
{
    varint(b, (uint64_t)field << 3);
    varint(b, value);
}

static void bytes(Buffer *b, unsigned field, const void *data, size_t size)
{
    varint(b, ((uint64_t)field << 3) | 2);
    varint(b, size);
    assert(size <= sizeof(b->data) - b->size);
    memcpy(b->data + b->size, data, size);
    b->size += size;
}

static void text_field(Buffer *b, unsigned field, const char *value)
{
    bytes(b, field, value, strlen(value));
}

static void message(Buffer *b, unsigned field, const Buffer *child)
{
    bytes(b, field, child->data, child->size);
}

static void fixed64(Buffer *b, unsigned field, uint64_t value)
{
    varint(b, ((uint64_t)field << 3) | 1);
    assert(8 <= sizeof(b->data) - b->size);
    for (unsigned i = 0; i < 8; ++i)
        b->data[b->size++] = (unsigned char)(value >> (8 * i));
}

static void packet(const Buffer *body, unsigned field, uint64_t timestamp)
{
    Buffer p = {0};
    Buffer trace = {0};
    number(&p, 8, origin + timestamp);
    number(&p, 10, 1);
    number(&p, 58, 6);
    number(&p, 13, 2);
    message(&p, field, body);
    message(&trace, 1, &p);
    assert(fwrite(trace.data, 1, trace.size, output) == trace.size);
}

static void schedule(const Buffer *body, unsigned field, uint64_t timestamp)
{
    assert(pending_count < sizeof(pending) / sizeof(pending[0]));
    Pending *p = &pending[pending_count];
    p->timestamp = timestamp;
    p->field = field;
    p->order = (unsigned)pending_count;
    p->body = *body;
    ++pending_count;
}

static void initial_metadata(void)
{
    Buffer interned = {0};
    const char *names[] = {"main", "parse", "check", "worker", "encode"};
    for (unsigned i = 0; i < 5; ++i)
    {
        Buffer name = {0};
        Buffer frame = {0};
        number(&name, 1, i + 1);
        text_field(&name, 2, names[i]);
        message(&interned, 5, &name);
        number(&frame, 1, i + 1);
        number(&frame, 2, i + 1);
        number(&frame, 3, 1);
        number(&frame, 4, 4096 + 16 * (i + 1));
        message(&interned, 6, &frame);
    }
    Buffer path = {0};
    number(&path, 1, 1);
    text_field(&path, 2, "synthetic-executable");
    message(&interned, 17, &path);
    Buffer mapping = {0};
    number(&mapping, 1, 1);
    number(&mapping, 4, 0);
    number(&mapping, 5, 65536);
    number(&mapping, 7, 1);
    message(&interned, 19, &mapping);
    const unsigned frames[][2] = {{1, 2}, {1, 3}, {4, 5}};
    for (unsigned i = 0; i < 3; ++i)
    {
        Buffer stack = {0};
        number(&stack, 1, i + 1);
        number(&stack, 2, frames[i][0]);
        number(&stack, 2, frames[i][1]);
        message(&interned, 7, &stack);
    }
    Buffer timebase = {0};
    number(&timebase, 1, 1);
    number(&timebase, 4, 20);
    text_field(&timebase, 10, "synthetic sample count");
    Buffer perf_defaults = {0};
    message(&perf_defaults, 1, &timebase);
    Buffer defaults = {0};
    number(&defaults, 58, 6);
    message(&defaults, 12, &perf_defaults);
    Buffer p = {0};
    Buffer trace = {0};
    number(&p, 8, origin);
    number(&p, 10, 1);
    number(&p, 13, 1);
    number(&p, 58, 6);
    message(&p, 12, &interned);
    message(&p, 59, &defaults);
    message(&trace, 1, &p);
    assert(fwrite(trace.data, 1, trace.size, output) == trace.size);
}

static void describe(unsigned uuid, const char *name, unsigned tid, const char *unit)
{
    Buffer d = {0};
    number(&d, 1, uuid);
    text_field(&d, 2, name);
    if (tid)
    {
        Buffer thread = {0};
        number(&thread, 1, 100);
        number(&thread, 2, tid);
        text_field(&thread, 5, name);
        message(&d, 4, &thread);
    }
    if (unit)
    {
        Buffer counter = {0};
        text_field(&counter, 6, unit);
        message(&d, 8, &counter);
    }
    packet(&d, 60, 0);
}

static void track_event(uint64_t at, unsigned track, unsigned type, const char *name, uint64_t value, unsigned flow)
{
    Buffer e = {0};
    number(&e, 9, type);
    number(&e, 11, track);
    if (name)
        text_field(&e, 23, name);
    if (type == 4)
        number(&e, 30, value);
    if (flow)
        fixed64(&e, flow == 1 ? 47 : 48, 1);
    schedule(&e, 11, at);
}

static void switch_event(Buffer *bundle, uint64_t at, unsigned previous, unsigned next, unsigned state)
{
    Buffer s = {0};
    text_field(&s, 1, previous == 100 ? "main" : previous == 101 ? "worker" : "idle");
    number(&s, 2, previous);
    number(&s, 3, 120);
    number(&s, 4, state);
    text_field(&s, 5, next == 100 ? "main" : next == 101 ? "worker" : "idle");
    number(&s, 6, next);
    number(&s, 7, 120);
    Buffer event = {0};
    number(&event, 1, origin + at);
    number(&event, 2, previous);
    message(&event, 4, &s);
    message(bundle, 2, &event);
}

static int compare_pending(const void *left, const void *right)
{
    const Pending *a = left;
    const Pending *b = right;
    int result = a->timestamp < b->timestamp ? -1 : a->timestamp > b->timestamp ? 1 : a->order < b->order ? -1 : a->order > b->order;
    return result;
}

int main(int argc, char **argv)
{
    assert(argc == 2);
    output = fopen(argv[1], "wb");
    assert(output);
    initial_metadata();
    describe(100, "main", 100, NULL);
    describe(101, "worker", 101, NULL);
    describe(200, "Resident bytes", 0, "B");
    describe(201, "Package energy", 0, "uJ");
    describe(300, "Synthetic sample coverage", 0, NULL);
    Buffer tree = {0};
    Buffer process = {0};
    number(&process, 1, 100);
    text_field(&process, 3, "synthetic-profile-contract-example");
    message(&tree, 1, &process);
    for (unsigned tid = 100; tid <= 101; ++tid)
    {
        Buffer thread = {0};
        number(&thread, 1, tid);
        number(&thread, 3, 100);
        text_field(&thread, 2, tid == 100 ? "main" : "worker");
        message(&tree, 2, &thread);
    }
    packet(&tree, 2, 0);
    Buffer cpu2 = {0};
    number(&cpu2, 1, 2);
    switch_event(&cpu2, 0, 0, 100, 0);
    switch_event(&cpu2, 3100000, 100, 0, 0);
    switch_event(&cpu2, 4100000, 0, 100, 0);
    switch_event(&cpu2, 10000000, 100, 0, 1);
    schedule(&cpu2, 1, 0);
    Buffer cpu3 = {0};
    number(&cpu3, 1, 3);
    switch_event(&cpu3, 0, 101, 0, 1);
    switch_event(&cpu3, 3500000, 0, 101, 0);
    switch_event(&cpu3, 6500000, 101, 0, 1);
    schedule(&cpu3, 1, 0);
    track_event(0, 100, 1, "compile", 0, 0);
    track_event(0, 100, 1, "parse", 0, 0);
    track_event(2500000, 100, 2, NULL, 0, 0);
    track_event(3000000, 100, 3, "dispatch", 0, 1);
    track_event(3500000, 101, 1, "encode task", 0, 2);
    track_event(6500000, 101, 2, NULL, 0, 0);
    track_event(6500000, 300, 1, "sample coverage unknown (synthetic)", 0, 0);
    track_event(7500000, 300, 2, NULL, 0, 0);
    track_event(10000000, 100, 2, NULL, 0, 0);
    track_event(10000000, 300, 3, "capture end", 0, 0);
    const uint64_t at[] = {0, 3000000, 6000000, 10000000};
    const unsigned resident[] = {4096, 8192, 12288, 4096};
    const unsigned energy[] = {0, 12, 27, 41};
    for (unsigned i = 0; i < 4; ++i)
    {
        track_event(at[i], 200, 4, NULL, resident[i], 0);
        track_event(at[i], 201, 4, NULL, energy[i], 0);
    }
    const unsigned milliseconds[] = {1, 2, 3, 4, 5, 6, 8, 9};
    const unsigned stack[] = {1, 1, 2, 3, 2, 3, 1, 1};
    unsigned counts[] = {0, 0};
    for (unsigned i = 0; i < 8; ++i)
    {
        unsigned worker = stack[i] == 3;
        Buffer sample = {0};
        number(&sample, 1, worker ? 3 : 2);
        number(&sample, 2, 100);
        number(&sample, 3, worker ? 101 : 100);
        number(&sample, 4, stack[i]);
        number(&sample, 5, 2);
        number(&sample, 6, ++counts[worker]);
        schedule(&sample, 66, (uint64_t)milliseconds[i] * 1000000);
    }
    qsort(pending, pending_count, sizeof(pending[0]), compare_pending);
    for (size_t i = 0; i < pending_count; ++i)
        packet(&pending[i].body, pending[i].field, pending[i].timestamp);
    assert(fclose(output) == 0);
    return 0;
}
