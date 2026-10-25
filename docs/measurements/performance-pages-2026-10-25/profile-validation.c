/* Original native reader/half-open range and bounded malformed-input probes.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception */
#define BUSTER_TRACE_QUERY_NO_MAIN
#include "trace_query.c"

static TraceQuery profile_test_query(PerfBytes input, uint64_t start, uint64_t end)
{
    TraceQuery query = {.start = start, .end = end, .first = UINT64_MAX, .clock = 6, .valid = true};
    query.dictionary = calloc(BUSTER_TRACE_DICT_SLOTS, sizeof(*query.dictionary));
    query.valid = query.dictionary != NULL;
    if (query.valid)
    {
        trace_query(&query, input);
    }
    free(query.dictionary);
    query.dictionary = NULL;
    return query;
}

int main(int argc, char **argv)
{
    PerfBuffer fixture = {0};
    PerfBuffer real = {0};
    bool valid = argc == 3 && perf_read_file(argv[1], &fixture) && perf_read_file(argv[2], &real);
    perf_expect(valid, "fixture and reviewed real native trace readable");
    if (valid)
    {
        TraceQuery all = profile_test_query(perf_buffer_bytes(&fixture), 0, UINT64_MAX);
        perf_expect(all.valid && all.total == 8 && all.selected == 8 && all.unweighted == 8 && all.period_ns == 0, "eight native samples; cumulative source counts are not periods");
        TraceQuery selected = profile_test_query(perf_buffer_bytes(&fixture), UINT64_C(1002000000), UINT64_C(1007000000));
        perf_expect(selected.valid && selected.selected == 5 && selected.total == 8, "native SQL reference half-open interval selects five samples");
        selected = profile_test_query(perf_buffer_bytes(&fixture), UINT64_C(1003000000), UINT64_C(1007000000));
        perf_expect(selected.valid && selected.selected == 4, "separate half-open interval selects four");
        all = profile_test_query(perf_buffer_bytes(&real), 0, UINT64_MAX);
        perf_expect(all.valid && all.total == 871 && all.selected == 871 && all.unweighted == 0 && all.period_ns == UINT64_C(871000000) && all.lost == 0 && all.clock == 3, "real 9700X samples and source periods exactly match independent native importer");
        selected = profile_test_query(perf_buffer_bytes(&real), UINT64_C(2652773000000000), UINT64_C(2652773500000000));
        perf_expect(selected.valid && selected.selected == 500 && selected.period_ns == UINT64_C(500000000), "real half-open interval matches browser and independent native importer");
        const unsigned char malformed[][12] = {{0}, {8, 128}, {10, 9, 1}, {8, 128, 128, 128, 128, 128, 128, 128, 128, 128, 2}, {11, 1}};
        const size_t sizes[] = {1, 2, 3, 11, 2};
        for (size_t i = 0; i < 5; ++i)
        {
            TraceQuery query = profile_test_query((PerfBytes){.data = malformed[i], .size = sizes[i]}, 0, UINT64_MAX);
            perf_expect(!query.valid, "truncated/overflowing/invalid native wire rejected");
        }
        uint64_t accepted_prefixes = 0;
        for (size_t i = 0; i < 64; ++i)
        {
            size_t size = fixture.size * i / 64;
            TraceQuery query = profile_test_query((PerfBytes){.data = fixture.data, .size = size}, 0, UINT64_MAX);
            accepted_prefixes += query.valid;
        }
        printf("{\"native_prefix_safety_probes\":64,\"accepted_valid_prefixes\":\"%llu\",\"note\":\"A complete native packet prefix can be a valid smaller trace. Resource size/hash and capture receipt establish the intended complete artifact.\"}\n", (unsigned long long)accepted_prefixes);
    }
    free(fixture.data);
    free(real.data);
    printf("{\"first_party\":true,\"checks\":%u,\"failures\":%u,\"real_samples\":871,\"real_period_ns\":\"871000000\",\"range_samples\":500}\n", perf_checks, perf_failures);
    return valid && perf_failures == 0 ? 0 : 1;
}
