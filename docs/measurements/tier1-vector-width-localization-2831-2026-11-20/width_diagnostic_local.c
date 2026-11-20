
#ifndef WIDTH_PROFILE_LOCAL
#define WIDTH_PROFILE_LOCAL
#include <linux/perf_event.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
static _Thread_local int width_fd=-2;
static _Thread_local unsigned width_id,width_summary;
static _Thread_local uint64_t (*width_totals)[2][32];
static _Thread_local uint32_t (*width_calls)[2][32];
static const char *const width_labels[]={"ir_optimize_gvn", "ir_optimize_sroa", "ssa_ir_promote_verified", "ssa_ir_promote", "ir_wide_split", "ir_vector_split", "ir_truth_simplify", "ir_thread", "ir_if_convert", "ir_optimize_licm", "ir_vectorize_loops", "ir_optimize_unroll", "tier1_schedule_ir_function", "ir_optimize_verified", "tier1_select_verified", "tier1_select_prepare", "tier1_emit_function", "check_tier1_inline_expand", "check_tier1_passes", "check_tier1_inline_own", "ir_typed_lower", "check_tier1_schedule", "tier1_select_plan_verified", "ir_optimize_inline", "ir_verify", "check_tier1_sink_optimize", "check_tier1_compile"};
static uint64_t width_read(void) {
    if (width_fd == -2) {
        width_fd=-1;
        if (getenv("BUSTER_2831_TRACE")) {
            struct perf_event_attr a={.type=PERF_TYPE_HARDWARE,.size=sizeof(a),.config=PERF_COUNT_HW_INSTRUCTIONS,.exclude_kernel=1,.exclude_hv=1,.pinned=1};
            width_fd=(int)syscall(SYS_perf_event_open,&a,0,-1,-1,PERF_FLAG_FD_CLOEXEC);
            width_totals=calloc(16384,sizeof(*width_totals)); width_calls=calloc(16384,sizeof(*width_calls));
            if (width_fd<0 || !width_totals || !width_calls) abort();
        }
    }
    uint64_t v=0;
    if (width_fd>=0 && read(width_fd,&v,8)!=8) abort();
    return v;
}
static void width_row(unsigned id, const uint8_t *s, unsigned length) {
    if (!width_totals || id>=16384) return;
    for (unsigned category=0;category<2;category++) for (unsigned i=0;i<sizeof(width_labels)/sizeof(*width_labels);i++) {
        if (width_calls[id][category][i]) fprintf(stderr,"W\t%u\t%.*s\t%u\t%s\t%u\t%" PRIu64 "\n",id,(int)length,s,category,width_labels[i],width_calls[id][category][i],width_totals[id][category][i]);
    }
}
#define WIDTH_SAMPLE(k, expression) __extension__ ({ unsigned width_saved_id=width_id,width_saved_class=width_summary; uint64_t width_start=width_read(); __auto_type width_value=(expression); uint64_t width_end=width_read(); if (width_start && width_saved_id<16384) {width_totals[width_saved_id][width_saved_class][k]+=width_end-width_start; width_calls[width_saved_id][width_saved_class][k]++;} width_value; })
#endif
