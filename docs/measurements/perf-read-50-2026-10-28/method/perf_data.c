/* Original Buster performance evidence tooling; written from ABI field
 * descriptions, without incorporating kernel or perf implementation code.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */
#define _POSIX_C_SOURCE 200809L
#include "perf_data.h"
#include <inttypes.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define ATTR_LIMIT PERF_DATA_ATTR_LIMIT
#define ID_LIMIT 16384
/* ID/STREAM_ID group semantics are deliberately outside this bounded profile.
 * Both preserved fixtures identify records with IDENTIFIER alone. */
#define SAMPLE_SUPPORTED UINT64_C(0x101859f)

typedef struct
{
    uint32_t type;
    uint64_t config;
    uint64_t sample_type, read_format, flags, ids, ids_size;
    uint64_t direct_samples, group_values, read_records, min_time, max_time;
    uint64_t duty_known_intervals, duty_zero_intervals, duty_partial_intervals;
    uint64_t duty_min_enabled, duty_min_running;
} Attribute;
typedef struct
{
    uint64_t id;
    unsigned attr;
} Identity;
typedef struct
{
    unsigned char *bytes;
    size_t length;
    FILE *out;
    Attribute attrs[ATTR_LIMIT];
    unsigned nr_attrs;
    Identity ids[ID_LIMIT];
    unsigned nr_ids;
    uint64_t records, samples, decoded_events, reads, loss, lost_records, lost_samples, throttles;
    uint64_t previous_time, regressions, min_time, max_time;
    uint64_t offset;
    const char *error;
    uint64_t data_offset, data_size;
    int complete;
} Scan;
typedef struct
{
    Scan *s;
    uint64_t at, end;
} Cursor;

static int range(Scan *s, uint64_t at, uint64_t size)
{
    return at <= s->length && size <= s->length - at;
}
static uint64_t get64(Scan *s, uint64_t at)
{
    uint64_t v = 0;
    for (unsigned i = 0; i < 8; i++)
        v |= (uint64_t)s->bytes[at + i] << (8 * i);
    return v;
}
static uint32_t get32(Scan *s, uint64_t at)
{
    uint32_t v = 0;
    for (unsigned i = 0; i < 4; i++)
        v |= (uint32_t)s->bytes[at + i] << (8 * i);
    return v;
}
static uint16_t get16(Scan *s, uint64_t at)
{
    return (uint16_t)((uint16_t)s->bytes[at] | ((uint16_t)s->bytes[at + 1] << 8));
}
static int string_present(Scan *s, uint64_t at, uint64_t end)
{
    return at < end && memchr(s->bytes + at, 0, (size_t)(end - at)) != NULL;
}
static int fail(Scan *s, const char *why)
{
    s->error = why;
    return 0;
}
static int take(Cursor *c, uint64_t n)
{
    if (c->at > c->end || n > c->end - c->at)
        return fail(c->s, "record_field_truncated");
    c->at += n;
    return 1;
}
static int number(Cursor *c, uint64_t *v)
{
    if (!take(c, 8))
        return 0;
    *v = get64(c->s, c->at - 8);
    return 1;
}
static int identity_compare(const void *l, const void *r)
{
    uint64_t a = ((const Identity *)l)->id, b = ((const Identity *)r)->id;
    return a < b ? -1 : a > b;
}
static int find(Scan *s, uint64_t id)
{
    unsigned lo = 0, hi = s->nr_ids;
    while (lo < hi)
    {
        unsigned m = lo + (hi - lo) / 2;
        if (s->ids[m].id < id)
            lo = m + 1;
        else
            hi = m;
    }
    return lo < s->nr_ids && s->ids[lo].id == id ? (int)s->ids[lo].attr : -1;
}
static void time_seen(Scan *s, Attribute *a, uint64_t t)
{
    if (!a->min_time || t < a->min_time)
        a->min_time = t;
    if (t > a->max_time)
        a->max_time = t;
    if (!s->min_time || t < s->min_time)
        s->min_time = t;
    if (t > s->max_time)
        s->max_time = t;
    if (s->previous_time && t < s->previous_time)
        s->regressions++;
    s->previous_time = t;
}
static uint64_t trailer_size(Attribute *a)
{
    uint64_t st = a->sample_type, z = 0;
    if (!(a->flags & (UINT64_C(1) << 18)))
        return 0;
    if (st & 2)
        z += 8;
    if (st & 4)
        z += 8;
    if (st & 64)
        z += 8;
    if (st & 512)
        z += 8;
    if (st & 128)
        z += 8;
    if (st & 65536)
        z += 8;
    return z;
}
static int trailer(Scan *s, Attribute *a, uint64_t begin, uint64_t end, int ai)
{
    uint64_t z = trailer_size(a), v = 0;
    Cursor c = {s, begin, end};
    if (end - begin != z)
        return fail(s, "sample_id_trailer_size");
    uint64_t st = a->sample_type;
    if ((st & 2) && !take(&c, 8))
        return 0;
    if (st & 4)
    {
        if (!number(&c, &v))
            return 0;
        time_seen(s, a, v);
    }
    if (st & 64)
    {
        if (!number(&c, &v))
            return 0;
        if (find(s, v) != ai)
            return fail(s, "sample_id_mismatch");
    }
    if (st & 512)
    {
        if (!number(&c, &v))
            return 0;
        if (find(s, v) != ai)
            return fail(s, "stream_id_mismatch");
    }
    if ((st & 128) && !take(&c, 8))
        return 0;
    if (st & 65536)
    {
        if (!number(&c, &v))
            return 0;
        if (find(s, v) != ai)
            return fail(s, "identifier_mismatch");
    }
    return c.at == end;
}
static int values(Cursor *c, Attribute *a, int owner, int sampled)
{
    Scan *s = c->s;
    uint64_t rf = a->read_format, nr = 1, v = 0, enabled = 0, running = 0;
    if ((rf & 8) && !number(c, &nr))
        return 0;
    if (!nr || nr > s->nr_attrs)
        return fail(s, "read_group_count");
    if (!(rf & 8) && !number(c, &v))
        return 0;
    if ((rf & 1) && !number(c, &enabled))
        return 0;
    if ((rf & 2) && !number(c, &running))
        return 0;
    if ((rf & 3) == 3 && running > enabled)
        return fail(s, "running_exceeds_enabled");
    uint64_t seen[ATTR_LIMIT] = {0};
    for (uint64_t i = 0; i < nr; i++)
    {
        if ((rf & 8) && !number(c, &v))
            return 0;
        uint64_t id = 0;
        if (!number(c, &id))
            return 0;
        int ai = find(s, id);
        if (ai < 0)
            return fail(s, "read_unknown_id");
        if (!(rf & 8) && ai != owner)
            return fail(s, "read_owner_mismatch");
        if (seen[ai]++)
            return fail(s, "read_duplicate_attribute");
        if (s->attrs[ai].read_format != rf)
            return fail(s, "read_format_mismatch");
        if ((rf & 3) == 3)
        {
            Attribute *d = s->attrs + ai;
            if (!enabled)
                d->duty_zero_intervals++;
            else
            {
                if (!d->duty_known_intervals || (__uint128_t)running * d->duty_min_enabled <
                                                    (__uint128_t)d->duty_min_running * enabled)
                {
                    d->duty_min_enabled = enabled;
                    d->duty_min_running = running;
                }
                d->duty_known_intervals++;
                if (running < enabled)
                    d->duty_partial_intervals++;
            }
        }
        if (sampled)
            s->attrs[ai].group_values++;
        if (rf & 16)
        {
            if (!number(c, &v))
                return 0;
            if (UINT64_MAX - s->loss < v)
                return fail(s, "loss_overflow");
            s->loss += v;
        }
    }
    if ((rf & 8) && !seen[owner])
        return fail(s, "read_group_owner_missing");
    if (sampled)
        s->decoded_events += nr;
    return 1;
}
static int sample(Scan *s, uint64_t at, uint64_t end)
{
    Cursor c = {s, at + 8, end};
    uint64_t id = 0, v = 0;
    if (!number(&c, &id))
        return 0;
    int ai = find(s, id);
    if (ai < 0)
        return fail(s, "sample_unknown_identifier");
    Attribute *a = s->attrs + ai;
    uint64_t st = a->sample_type;
    if ((st & 1) && !take(&c, 8))
        return 0;
    if ((st & 2) && !take(&c, 8))
        return 0;
    if (st & 4)
    {
        if (!number(&c, &v))
            return 0;
        time_seen(s, a, v);
    }
    if ((st & 8) && !take(&c, 8))
        return 0;
    if (st & 64)
    {
        if (!number(&c, &v))
            return 0;
        if (v != id)
            return fail(s, "sample_id_mismatch");
    }
    if (st & 512)
    {
        if (!number(&c, &v))
            return 0;
        if (find(s, v) != ai)
            return fail(s, "sample_stream_id_mismatch");
    }
    if ((st & 128) && !take(&c, 8))
        return 0;
    if ((st & 256) && !take(&c, 8))
        return 0;
    if ((st & 16) && !values(&c, a, ai, 1))
        return 0;
    if (st & 1024)
    {
        if (!take(&c, 4))
            return 0;
        uint32_t raw = get32(s, c.at - 4);
        if (!take(&c, raw))
            return 0;
    }
    if ((st & (UINT64_C(1) << 24)) && !take(&c, 8))
        return 0;
    if ((st & 32768) && !take(&c, 8))
        return 0;
    if (c.at != end)
        return fail(s, "sample_payload_size");
    a->direct_samples++;
    s->samples++;
    if (!(st & 16))
        s->decoded_events++;
    return 1;
}
static int read_record(Scan *s, uint64_t at, uint64_t end)
{
    /* The identifier at the end selects the ABI before interpreting values.
     * A malformed size must never borrow bytes from the following record. */
    if (end - at < 24)
        return fail(s, "read_record_short");
    uint64_t id = get64(s, end - 8);
    int ai = find(s, id);
    if (ai < 0)
        return fail(s, "read_unknown_trailer_identifier");
    Attribute *a = s->attrs + ai;
    uint64_t tail = trailer_size(a);
    if (end - at < 16 + tail)
        return fail(s, "read_record_short");
    Cursor c = {s, at + 16, end - tail};
    if (!values(&c, a, ai, 0))
        return 0;
    if (c.at != c.end)
        return fail(s, "read_payload_size");
    if (!trailer(s, a, c.end, end, ai))
        return 0;
    a->read_records++;
    s->reads++;
    return 1;
}
static int kernel_metadata(Scan *s, uint64_t at, uint64_t end, uint32_t type)
{
    if (end - at < 16)
        return fail(s, "metadata_record_short");
    uint64_t id = get64(s, end - 8);
    int ai = find(s, id), synthesized = 0;
    if (ai < 0 && id == 0)
    {
        uint64_t zero_tail = trailer_size(s->attrs);
        if (end - at < zero_tail)
            return fail(s, "metadata_record_short");
        for (unsigned i = 1; i < s->nr_attrs; i++)
            if (trailer_size(s->attrs + i) != zero_tail)
                return fail(s, "ambiguous_synthetic_metadata");
        for (uint64_t p = end - zero_tail; p < end; p++)
            if (s->bytes[p])
                return fail(s, "metadata_unknown_identifier");
        /* Perf synthesizes initial maps with an all-zero identity trailer.
         * These bounded metadata records never supply event coverage or time. */
        synthesized = 1;
        ai = 0;
    }
    if (ai < 0)
        return fail(s, "metadata_unknown_identifier");
    Attribute *a = s->attrs + ai;
    uint64_t tail = trailer_size(a), base = 0;
    if (type == 2)
        base = 24;
    else if (type == 3)
        base = 16;
    else if (type == 4 || type == 7)
        base = 32;
    else if (type == 5 || type == 6)
        base = 32;
    else if (type == 10)
        base = 72;
    else if (type == 13)
        base = 16;
    else if (type == 17)
        base = 24;
    if (end - at < base + tail)
        return fail(s, "metadata_payload_size");
    if ((type == 3 || type == 10 || type == 17) && !string_present(s, at + base, end - tail))
        return fail(s, "metadata_name_missing");
    if ((type == 4 || type == 7 || type == 5 || type == 6 || type == 2 || type == 13) &&
        end - at != base + tail)
        return fail(s, "metadata_payload_size");
    if (type == 2)
    {
        s->lost_records++;
        uint64_t loss = get64(s, at + 16);
        if (UINT64_MAX - s->loss < loss)
            return fail(s, "loss_overflow");
        s->loss += loss;
    }
    if (type == 13)
    {
        s->lost_samples++;
        uint64_t loss = get64(s, at + 8);
        if (UINT64_MAX - s->loss < loss)
            return fail(s, "loss_overflow");
        s->loss += loss;
    }
    if (type == 5 || type == 6)
        s->throttles++;
    return synthesized || trailer(s, a, end - tail, end, ai);
}
static int cpu_map(Scan *s, uint64_t at, uint64_t end)
{
    if (end - at < 4)
        return fail(s, "cpu_map_truncated");
    uint16_t type = get16(s, at), nr = get16(s, at + 2);
    uint64_t needed;
    if (type == 0)
        needed = 4 + (uint64_t)nr * 2;
    else if (type == 1)
    {
        if (end - at < 6)
            return fail(s, "cpu_mask_truncated");
        uint16_t word_size = get16(s, at + 4);
        if (word_size != 4 && word_size != 8)
            return fail(s, "cpu_mask_word_size");
        needed = (word_size == 4 ? 6 : 10) + (uint64_t)nr * word_size;
    }
    else if (type == 2)
    {
        needed = 8;
        if (end - at < needed || s->bytes[at + 2] > 1 || get16(s, at + 4) > get16(s, at + 6))
            return fail(s, "cpu_range_invalid");
    }
    else
        return fail(s, "cpu_map_encoding_unsupported");
    return end - at == ((needed + 7) & ~UINT64_C(7)) || fail(s, "cpu_map_size");
}
static int user_metadata(Scan *s, uint64_t at, uint64_t end, uint32_t type)
{
    uint64_t size = end - at;
    if (type == 68 || type == 82)
        return size == 8 || fail(s, "marker_payload_size");
    if (type == 79)
        return size == 56 || fail(s, "time_conversion_profile_unsupported");
    if (type == 74)
        return cpu_map(s, at + 8, end);
    if (type == 69 || type == 73)
    {
        if (size < 16)
            return fail(s, "metadata_count_truncated");
        uint64_t nr = get64(s, at + 8), stride = type == 69 ? 32 : 24;
        if (nr > (size - 16) / stride || size != 16 + nr * stride)
            return fail(s, "metadata_entries_size");
        for (uint64_t i = 0; i < nr; i++)
        {
            uint64_t p = at + 16 + i * stride;
            if (type == 69 && find(s, get64(s, p)) < 0)
                return fail(s, "index_unknown_identifier");
            /* Fixed 16-byte comm may occupy every byte without a NUL. */
        }
        return 1;
    }
    if (type == 78)
    {
        if (size < 24)
            return fail(s, "event_update_truncated");
        uint64_t subtype = get64(s, at + 8);
        if (find(s, get64(s, at + 16)) < 0)
            return fail(s, "event_update_unknown_identifier");
        if (subtype == 0 || subtype == 2)
            return string_present(s, at + 24, end) || fail(s, "event_update_name_missing");
        if (subtype == 1)
            return size == 32 || fail(s, "event_update_scale_size");
        if (subtype == 3)
            return cpu_map(s, at + 24, end);
        return fail(s, "event_update_type_unsupported");
    }
    return fail(s, "unsupported_record_type");
}
static int parse(Scan *s)
{
    if (s->length < 104 || memcmp(s->bytes, "PERFILE2", 8))
        return fail(s, "unsupported_file_header");
    if (get64(s, 8) != 104)
        return fail(s, "unsupported_header_size");
    if (get64(s, 56) || get64(s, 64))
        return fail(s, "legacy_event_types_unsupported");
    uint64_t stride = get64(s, 16), ao = get64(s, 24), az = get64(s, 32), data = get64(s, 40),
             dz = get64(s, 48);
    s->data_offset = data;
    s->data_size = dz;
    if (stride < 80 || stride > 4096 || !az || az % stride || az / stride > ATTR_LIMIT)
        return fail(s, "unsupported_attribute_table");
    if (ao < 104 || !range(s, ao, az) || !range(s, data, dz) || data < ao + az)
        return fail(s, "section_bounds");
    unsigned features = 0;
    for (unsigned bit = 0; bit < 256; bit++)
        if (s->bytes[72 + bit / 8] & (1u << (bit % 8)))
            features++;
    if (!range(s, data + dz, (uint64_t)features * 16))
        return fail(s, "feature_table_bounds");
    unsigned fi = 0;
    for (unsigned bit = 0; bit < 256; bit++)
        if (s->bytes[72 + bit / 8] & (1u << (bit % 8)))
        {
            if (bit == 27)
                return fail(s, "compressed_capture_unsupported");
            uint64_t p = data + dz + (uint64_t)fi++ * 16;
            if (get64(s, p) < data + dz + (uint64_t)features * 16 ||
                !range(s, get64(s, p), get64(s, p + 8)))
                return fail(s, "feature_bounds");
        }
    s->nr_attrs = (unsigned)(az / stride);
    for (unsigned i = 0; i < s->nr_attrs; i++)
    {
        uint64_t p = ao + (uint64_t)i * stride;
        Attribute *a = s->attrs + i;
        uint32_t size = get32(s, p + 4);
        if (size < 64 || size > stride - 16)
            return fail(s, "attribute_size");
        a->type = get32(s, p);
        a->config = get64(s, p + 8);
        a->sample_type = get64(s, p + 24);
        a->read_format = get64(s, p + 32);
        a->flags = get64(s, p + 40);
        a->ids = get64(s, p + stride - 16);
        a->ids_size = get64(s, p + stride - 8);
        if ((a->sample_type & ~SAMPLE_SUPPORTED) || !(a->sample_type & 65536) ||
            !(a->sample_type & 4) || !(a->flags & (UINT64_C(1) << 18)))
            return fail(s, "unsupported_sample_profile");
        if ((a->read_format & ~UINT64_C(31)) || !(a->read_format & 4))
            return fail(s, "unsupported_read_format");
        if (!a->ids_size || a->ids_size % 8 || a->ids < 104 || !range(s, a->ids, a->ids_size) ||
            a->ids > data || a->ids_size > data - a->ids ||
            !(a->ids + a->ids_size <= ao || a->ids >= ao + az) ||
            a->ids_size / 8 > ID_LIMIT - s->nr_ids)
            return fail(s, "attribute_ids_bounds");
        for (uint64_t j = 0; j < a->ids_size; j += 8)
        {
            s->ids[s->nr_ids].id = get64(s, a->ids + j);
            s->ids[s->nr_ids++].attr = i;
        }
        fprintf(s->out,
                "attribute\t%u\tsample_type\t0x%" PRIx64 "\tread_format\t0x%" PRIx64
                "\tflags\t0x%" PRIx64 "\tids\t%" PRIu64 "\n",
                i, a->sample_type, a->read_format, a->flags, a->ids_size / 8);
    }
    qsort(s->ids, s->nr_ids, sizeof(s->ids[0]), identity_compare);
    for (unsigned i = 1; i < s->nr_ids; i++)
        if (s->ids[i - 1].id == s->ids[i].id)
            return fail(s, "duplicate_identifier");
    for (uint64_t p = data; p < data + dz;)
    {
        s->offset = p;
        if (data + dz - p < 8)
            return fail(s, "record_header_truncated");
        uint32_t type = get32(s, p);
        uint64_t z = (uint64_t)s->bytes[p + 6] | ((uint64_t)s->bytes[p + 7] << 8);
        if (z < 8 || z % 8 || z > data + dz - p)
            return fail(s, "record_bounds");
        s->records++;
        if (type == 9)
        {
            if (!sample(s, p, p + z))
                return 0;
        }
        else if (type == 8)
        {
            if (!read_record(s, p, p + z))
                return 0;
        }
        else if (type == 2 || type == 3 || type == 4 || type == 5 || type == 6 || type == 7 ||
                 type == 10 || type == 13 || type == 17)
        {
            if (!kernel_metadata(s, p, p + z, type))
                return 0;
        }
        else if (!user_metadata(s, p, p + z, type))
            return 0;
        p += z;
    }
    s->offset = data + dz;
    s->complete = 1;
    if (!s->samples)
        return fail(s, "no_samples");
    for (unsigned i = 0; i < s->nr_attrs; i++)
        if (!s->attrs[i].direct_samples && !s->attrs[i].group_values)
            return fail(s, "missing_attribute_sample_coverage");
    if (s->loss || s->lost_records || s->lost_samples)
        return fail(s, "loss_recorded");
    if (s->throttles)
        return fail(s, "sampling_throttled");
    return 1;
}
int perf_data_scan(const char *path, FILE *receipt, PerfDataSummary *summary)
{
    if (summary)
        memset(summary, 0, sizeof(*summary));
    Scan *s = calloc(1, sizeof(*s));
    if (!s)
        return 1;
    s->out = receipt;
    FILE *f = fopen(path, "rb");
    if (!f)
    {
        fprintf(receipt, "binary_status\treject\treason\topen_failed\n");
        free(s);
        return 1;
    }
    if (fseek(f, 0, SEEK_END) || ftell(f) < 0)
    {
        fclose(f);
        free(s);
        return 1;
    }
    long file_size = ftell(f);
    rewind(f);
    s->length = (size_t)file_size;
    s->bytes = malloc(s->length ? s->length : 1);
    if (!s->bytes || fread(s->bytes, 1, s->length, f) != s->length)
    {
        fclose(f);
        free(s->bytes);
        free(s);
        return 1;
    }
    fclose(f);
    int ok = parse(s);
    fprintf(receipt, "binary_status\t%s\treason\t%s\toffset\t0x%" PRIx64 "\n",
            ok ? "accept" : "reject", ok ? "complete" : s->error, s->offset);
    fprintf(receipt,
            "binary_totals\tbytes\t%zu\trecords\t%" PRIu64 "\tsamples\t%" PRIu64
            "\tdecoded_events\t%" PRIu64 "\treads\t%" PRIu64 "\tloss\t%" PRIu64
            "\tlost_records\t%" PRIu64 "\tlost_samples_records\t%" PRIu64 "\tthrottles\t%" PRIu64
            "\n",
            s->length, s->records, s->samples, s->decoded_events, s->reads, s->loss,
            s->lost_records, s->lost_samples, s->throttles);
    fprintf(receipt,
            "binary_time\tmin\t%" PRIu64 "\tmax\t%" PRIu64 "\tphysical_order_regressions\t%" PRIu64
            "\n",
            s->min_time, s->max_time, s->regressions);
    for (unsigned i = 0; i < s->nr_attrs; i++)
    {
        Attribute *a = s->attrs + i;
        fprintf(receipt,
                "coverage\t%u\tdirect_samples\t%" PRIu64 "\tgroup_values\t%" PRIu64
                "\tread_records\t%" PRIu64 "\tmin_time\t%" PRIu64 "\tmax_time\t%" PRIu64 "\n",
                i, a->direct_samples, a->group_values, a->read_records, a->min_time, a->max_time);
        fprintf(receipt,
                "duty\t%u\tfields_available\t%d\tknown_intervals\t%" PRIu64
                "\tzero_intervals\t%" PRIu64 "\tpartial_intervals\t%" PRIu64
                "\tminimum_enabled\t%" PRIu64 "\tminimum_running\t%" PRIu64 "\n",
                i, (a->read_format & 3) == 3, a->duty_known_intervals, a->duty_zero_intervals,
                a->duty_partial_intervals, a->duty_min_enabled, a->duty_min_running);
    }
    if (summary)
    {
        summary->accepted = ok;
        summary->complete = s->complete;
        summary->attribute_count = s->nr_attrs;
        summary->file_bytes = s->length;
        summary->data_offset = s->data_offset;
        summary->data_size = s->data_size;
        summary->parsed_until = s->offset;
        summary->records = s->records;
        summary->samples = s->samples;
        summary->decoded_events = s->decoded_events;
        summary->reads = s->reads;
        summary->loss_fields_sum = s->loss;
        summary->lost_records = s->lost_records;
        summary->lost_samples_records = s->lost_samples;
        summary->throttles = s->throttles;
        summary->min_time = s->min_time;
        summary->max_time = s->max_time;
        summary->physical_time_regressions = s->regressions;
        for (unsigned i = 0; i < s->nr_attrs; i++)
        {
            Attribute *a = s->attrs + i;
            PerfDataAttribute *b = summary->attributes + i;
            b->type = a->type;
            b->config = a->config;
            b->sample_type = a->sample_type;
            b->read_format = a->read_format;
            b->flags = a->flags;
            b->id_count = a->ids_size / 8;
            b->direct_samples = a->direct_samples;
            b->group_values = a->group_values;
            b->read_records = a->read_records;
            b->min_time = a->min_time;
            b->max_time = a->max_time;
            b->duty_fields_available = (a->read_format & 3) == 3;
            b->duty_known_intervals = a->duty_known_intervals;
            b->duty_zero_intervals = a->duty_zero_intervals;
            b->duty_partial_intervals = a->duty_partial_intervals;
            b->duty_min_enabled = a->duty_min_enabled;
            b->duty_min_running = a->duty_min_running;
        }
    }
    free(s->bytes);
    free(s);
    return ok ? 0 : 1;
}
