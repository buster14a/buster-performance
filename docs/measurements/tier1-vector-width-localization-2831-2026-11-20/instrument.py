from pathlib import Path
import re,subprocess
w=Path(__file__).resolve().parents[1];root=w/'width-profile';base=root/'src/buster/compiler'
def original(name):return subprocess.check_output(['git','-C',root,'show','HEAD:src/buster/compiler/'+name],text=True)
def wrap(src,func,label):
    starts=[m.start() for m in re.finditer(r'(?<![A-Za-z_0-9])'+func+r'\(',src)]
    for i in reversed(starts):
        if '//' in src[src.rfind('\n',0,i)+1:i]:continue
        pre=src[src.rfind('\n',0,i)+1:i]
        if pre.startswith('static ') or pre.startswith('#'):continue
        j=i+len(func)+1;depth=1
        while depth:
            depth+=(src[j]=='(')-(src[j]==')');j+=1
        src=src[:i]+'WIDTH_SAMPLE('+str(label)+', '+src[i:j]+')'+src[j:]
    return src
funcs=['ir_optimize_gvn','ir_optimize_sroa','ssa_ir_promote_verified','ssa_ir_promote','ir_wide_split','ir_vector_split','ir_truth_simplify','ir_thread','ir_if_convert','ir_optimize_licm','ir_vectorize_loops','ir_optimize_unroll','tier1_schedule_ir_function','ir_optimize_verified','tier1_select_verified','tier1_select_prepare','tier1_emit_function','check_tier1_inline_expand','check_tier1_passes','check_tier1_inline_own','ir_typed_lower','check_tier1_schedule','tier1_select_plan_verified','ir_optimize_inline','ir_verify','check_tier1_sink_optimize','check_tier1_compile']
# Keep totals by source body and also by owner: summary construction vs own final code. The per-thread counter
# excludes kernel/hypervisor instructions. Instrumentation only runs in requested single-lane profiling experiments.
names=', '.join('"'+f+'"' for f in funcs)
hdr=r'''
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
static const char *const width_labels[]={LABELS};
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
'''.replace('LABELS',names)
(base/'width_diagnostic_local.c').write_text(hdr)
p='c_check_program_emit.c';s=original(p);needle='#include "worker_budget.c"';s=s.replace(needle,'#include "width_diagnostic_local.c"\n'+needle);needle='    CheckTier1Outcome outcome = naked ?';assert s.count(needle)==1;s=s.replace(needle,'    width_id=b; width_summary=0;\n'+needle)
s=wrap(s,'check_tier1_compile',funcs.index('check_tier1_compile'));needle='    // With --tier1-refusals, each body';assert s.count(needle)==1
s=s.replace(needle,'''    if (valid && width_totals) for (uint32_t b=0;b<count;b++) {
        const SymbolId sym=check_program_body_symbol(program,b);
        if (sym<result->link.symbols.count) {const NameId nm=result->link.symbols.name[sym]; if(nm) width_row(b,result->link.names.bytes[nm],result->link.names.length[nm]);}
    }
'''+needle);(base/p).write_text(s)
p='c_check_tier1.c';s=original(p);needle='        ir_vectorize_target_tier1(lane->allowed, lane->vectorize);';assert s.count(needle)==1
s=s.replace(needle,needle+'''
        const char *cap=getenv("BUSTER_2831_WIDTH");
        if (cap) lane->vectorize->moves &= (uint8_t)(atoi(cap)==16 ? 1u : atoi(cap)==32 ? 3u : 7u);''')
for i,f in enumerate(funcs):s=wrap(s,f,i)
(base/p).write_text(s)
p='c_check_tier1_inline.c';s=original(p);a=s.index('static void check_tier1_inline_build(');e=s.index('\n}',a);sub=s[a:e];i=sub.index('\n{')+2;sub=sub[:i]+'\n    const unsigned saved_id=width_id,saved_class=width_summary; width_id=b; width_summary=1;'+sub[i:];s=s[:a]+sub+'\n    width_id=saved_id; width_summary=saved_class;'+s[e:]
for i,f in enumerate(funcs):s=wrap(s,f,i)
(base/p).write_text(s)
for p in ['c_check_program_emit.c','c_check_tier1.c','c_check_tier1_inline.c']:
    print(p,[(f,(base/p).read_text().count('WIDTH_SAMPLE('+str(i)+',')) for i,f in enumerate(funcs) if ('WIDTH_SAMPLE('+str(i)+',') in (base/p).read_text()])
