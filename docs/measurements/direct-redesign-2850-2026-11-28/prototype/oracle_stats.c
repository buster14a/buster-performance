#include "oracle.h"
int main(int argc, char** argv)
{
    Oracle o;
    if (argc < 3) { fprintf(stderr, "usage: oracle_stats DUMP SOURCE\n"); return 2; }
    const bool ok = oracle_load(&o, argv[1], argv[2]);
    uint64_t replayed = 0, with_binds = 0, empty = 0, directive_events = 0;
    for (uint32_t i = 0; i < o.event_count; i += 1)
    {
        const OracleEvent* e = o.events + i;
        replayed += e->out_end - e->out_begin;
        with_binds += e->bind_end > e->bind_begin;
        empty += e->out_end == e->out_begin;
        directive_events += e->stop < o.src_size && o.src[e->stop] == '#';
    }
    uint64_t code = 0, comment = 0, literal = 0;
    for (size_t i = 0; i < o.src_size; i += 1) { code += o.mode[i] == M_CODE; comment += o.mode[i] == M_COMMENT; literal += o.mode[i] >= M_QUOTE; }
    printf("ok %d: %u tokens, %u the text's, %u events (%llu at a '#', %llu with no token, %llu with bindings), %llu replayed tokens\n", ok, o.count, o.text_tokens,
           o.event_count, (unsigned long long)directive_events, (unsigned long long)empty, (unsigned long long)with_binds, (unsigned long long)replayed);
    printf("source %zu bytes: %llu code, %llu comment, %llu literal; %zu directive lines; %u identifiers, %u bindings\n", o.src_size, (unsigned long long)code,
           (unsigned long long)comment, (unsigned long long)literal, o.directive_count, o.ident_count, o.bind_count);
    // The text bytes the stream's own tokens cover: from an event's resume to the next event's stop.
    uint64_t run_bytes = 0;
    uint32_t pos = 0;
    for (uint32_t i = 0; i < o.event_count; i += 1) { run_bytes += o.events[i].stop - pos; pos = o.events[i].resume; }
    run_bytes += o.src_size - pos;
    printf("bytes in the text's own runs %llu, in events %llu\n", (unsigned long long)run_bytes, (unsigned long long)(o.src_size - run_bytes));
    return ok ? 0 : 1;
}
