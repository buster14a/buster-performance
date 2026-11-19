// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Temporary observer included just before ir_vector_split restores its scratch mark.
// At this point the complete split output and every allocation in split scratch coexist.
if (result->split && getenv("BUSTER_SPLIT_CAPTURE") != NULL)
{
    const IrFunction* f = &result->function;
    fprintf(stderr, "SPLIT width=%u rows=%u wide=%u outrows=%u scratch_mark=%" PRIu64 " scratch=%" PRIu64 " output=%" PRIu64 " debug=%u\n",
            piece_bytes, function->instruction_count, result->wide, f->instruction_count, scratch_mark, scratch->length - scratch_mark,
            output->length - output_mark, (unsigned)(f->debug != NULL));
    FILE* stream = fopen(getenv("BUSTER_SPLIT_CAPTURE"), "ab");
    Arena printing = arena_reserve(128u << 20);
    if (stream == NULL || printing.base == NULL || ir_print(f, &printing, stream) != IR_OK)
    {
        fprintf(stderr, "Could not verify or serialize the split function\n");
        abort();
    }
    arena_release(&printing);
    // Also retain instruction columns, superseded table slices and origins that the readable IR omits.
#define BUSTER_CAPTURE_ARRAY(array, n) do { uint64_t length = (n); if (fwrite(&length, sizeof(length), 1, stream) != 1 || (length != 0 && fwrite((array), sizeof(*(array)), length, stream) != length)) abort(); } while (0)
    BUSTER_CAPTURE_ARRAY(f->op, f->instruction_count);
    BUSTER_CAPTURE_ARRAY(f->type, f->instruction_count);
    BUSTER_CAPTURE_ARRAY(f->flags, f->instruction_count);
    BUSTER_CAPTURE_ARRAY(f->alignment_log2, f->instruction_count);
    BUSTER_CAPTURE_ARRAY(f->a, f->instruction_count);
    BUSTER_CAPTURE_ARRAY(f->b, f->instruction_count);
    BUSTER_CAPTURE_ARRAY(f->c, f->instruction_count);
    BUSTER_CAPTURE_ARRAY(f->block_offsets, (uint64_t)f->block_count + 1);
    BUSTER_CAPTURE_ARRAY(f->extra, f->extra_count);
    BUSTER_CAPTURE_ARRAY(f->vector_constants, f->vector_constant_count);
    if (f->debug != NULL)
    {
        const IrDebugInfo* d = f->debug;
        fprintf(stream, "\nD %u %u %u %u %u %u %u\n", d->entry_count, d->origin_count, d->local_count, d->first_block_end, d->scalar_count, d->binding_count, d->region_count);
        BUSTER_CAPTURE_ARRAY(d->origins, d->instruction_count);
        BUSTER_CAPTURE_ARRAY(d->locals, d->slot_count);
        BUSTER_CAPTURE_ARRAY(d->binding_flags, d->binding_flags != NULL ? d->local_count : 0);
        BUSTER_CAPTURE_ARRAY(d->inlines, d->inline_count);
        for (uint32_t k = 0; k < d->scalar_count; k++)
        {
            const IrDebugScalar s = d->scalars[k];
            fprintf(stream, "\nS %" PRIu64 " %u %u %u %u", s.value, s.local, s.entry, s.kind, s.bytes);
        }
        for (uint32_t k = 0; k < d->binding_count; k++)
        {
            const IrDebugBinding b = d->bindings[k];
            fprintf(stream, "\nB %" PRIu64 " %u %u %u %u %u %u %u", b.literal, b.local, b.entry, b.value, b.anchor, b.kind, b.bytes, b.type);
        }
        for (uint32_t k = 0; k < d->region_count; k++)
        {
            const IrDebugRegion r = d->regions[k];
            fprintf(stream, "\nR %" PRIu64 " %u %u %u %u %u %u %u %u %u %u", r.literal, r.local, r.block, r.begin, r.end, r.block_end, r.value, r.next, r.kind, r.bytes, r.type);
        }
    }
#undef BUSTER_CAPTURE_ARRAY
    if (fclose(stream) != 0) abort();
}
