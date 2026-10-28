/* Original Buster performance evidence tooling.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */
#ifndef BUSTER_PERF_DATA_H
#define BUSTER_PERF_DATA_H
#include <stdint.h>
#include <stdio.h>
#define PERF_DATA_ATTR_LIMIT 256
typedef struct
{
    uint32_t type;
    uint64_t config;
    uint64_t sample_type;
    uint64_t read_format;
    uint64_t flags;
    uint64_t id_count;
    uint64_t direct_samples;
    uint64_t group_values;
    uint64_t read_records;
    uint64_t min_time;
    uint64_t max_time;
    /* Times exist only when requested by read_format; zero is not 100% duty. */
    int duty_fields_available;
    /* Counts of observed read-format time tuples; cumulative snapshots may
     * overlap in time. They are not independent or disjoint intervals. */
    uint64_t duty_known_intervals;
    uint64_t duty_zero_intervals;
    uint64_t duty_partial_intervals;
    /* Paired minimum observed running/enabled ratio among known intervals.
     * Zero/zero is unavailable and is never a known ratio. */
    uint64_t duty_min_enabled;
    uint64_t duty_min_running;
} PerfDataAttribute;
typedef struct
{
    int accepted;
    int complete;
    unsigned attribute_count;
    uint64_t file_bytes;
    uint64_t data_offset;
    uint64_t data_size;
    uint64_t parsed_until;
    uint64_t records;
    uint64_t samples;
    uint64_t decoded_events;
    uint64_t reads;
    uint64_t loss_fields_sum;
    uint64_t lost_records;
    uint64_t lost_samples_records;
    uint64_t throttles;
    uint64_t min_time;
    uint64_t max_time;
    uint64_t physical_time_regressions;
    PerfDataAttribute attributes[PERF_DATA_ATTR_LIMIT];
} PerfDataSummary;
/* Validate the supported little-endian, uncompressed PERFILE2 profile and
 * write a tab-separated receipt. Zero means complete, covered and loss-free.
 * Every other result rejects the capture; this is not a general perf reader. */
int perf_data_scan(const char *path, FILE *receipt, PerfDataSummary *summary);
#endif
