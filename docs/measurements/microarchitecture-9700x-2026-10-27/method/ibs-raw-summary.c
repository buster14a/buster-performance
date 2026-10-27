#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

enum { BINS=65536, GROUPS=8, MAX_FUNCTIONS=4096 };
typedef struct { uint64_t ip; unsigned function; } Address;
typedef struct { char name[160]; uint64_t count, tag_sum, comp_sum, loads, stores, misses, branches, mispredictions; } Function;
typedef struct { uint64_t count, tag_sum, comp_sum, tag[BINS], comp[BINS], saturated; } Distribution;
static Distribution dist[GROUPS];
static Function functions[MAX_FUNCTIONS];
static unsigned function_count;

static int compare_ip(const void *a,const void *b)
{
    const Address *x=a,*y=b;
    return x->ip < y->ip ? -1 : x->ip > y->ip;
}
static int compare_count(const void *a,const void *b)
{
    const Function *x=a,*y=b;
    return x->count > y->count ? -1 : x->count < y->count;
}
static unsigned value(const char *line,const char *label)
{
    const char *p=strstr(line,label);
    return p ? strtoul(p+strlen(label),NULL,10) : 0;
}
static void add(unsigned group,unsigned tag,unsigned comp)
{
    Distribution *d=dist+group;
    ++d->count; d->tag_sum+=tag; d->comp_sum+=comp;
    ++d->tag[tag]; ++d->comp[comp];
    d->saturated += tag==65535 || comp==65535;
}
static unsigned percentile(const uint64_t *hist,uint64_t count,unsigned percent)
{
    uint64_t wanted=(count*percent+99)/100, total=0;
    for(unsigned i=0;i<BINS;++i) { total+=hist[i]; if(total>=wanted) return i; }
    return 0;
}
int main(int argc,char **argv)
{
    if(argc!=4) { fprintf(stderr,"usage: ibs-raw-summary INSTRUCTION-CSV SUMMARY-JSON FUNCTION-CSV < PERF-SCRIPT-DUMP\n"); return 2; }
    FILE *in=fopen(argv[1],"r"),*out=fopen(argv[2],"w"),*csv=fopen(argv[3],"w");
    if(!in || !out || !csv) return 2;
    size_t count=0,capacity=65536;
    Address *addresses=malloc(capacity*sizeof(*addresses));
    if(!addresses) return 2;
    char line[4096];
    if(!fgets(line,sizeof(line),in)) return 2;
    while(fgets(line,sizeof(line),in))
    {
        char *comma=strchr(line,','),name[160];
        if(!comma || sscanf(comma+1,"\"%159[^\"]",name)!=1) return 2;
        unsigned f=0;
        while(f<function_count && strcmp(functions[f].name,name)!=0) ++f;
        if(f==function_count) {
            if(function_count==MAX_FUNCTIONS) return 2;
            snprintf(functions[f].name,sizeof(functions[f].name),"%s",name); ++function_count;
        }
        if(count==capacity) { capacity*=2; Address *p=realloc(addresses,capacity*sizeof(*addresses)); if(!p) return 2; addresses=p; }
        addresses[count++]=(Address){.ip=strtoull(line,NULL,0),.function=f};
    }
    fclose(in);
    qsort(addresses,count,sizeof(*addresses),compare_ip);
    uint64_t raw_samples=0,matched=0,invalid=0,comp_gt_tag=0;
    uint64_t ip=0;
    unsigned tag=0,comp=0,branch=0,mispredict=0,microcode=0,rip_invalid=0;
    while(fgets(line,sizeof(line),stdin))
    {
        if(strncmp(line,"ibs_op_ctl:",11)==0) { ip=0; tag=comp=branch=mispredict=microcode=rip_invalid=0; ++raw_samples; }
        else if(strncmp(line,"IbsOpRip:",9)==0) ip=strtoull(line+9,NULL,16);
        else if(strncmp(line,"ibs_op_data:",12)==0) {
            tag=value(line,"TagToRetCtr "); comp=value(line,"CompToRetCtr ");
            branch=value(line,"BrnRet "); mispredict=value(line,"OpBrnMisp ");
            microcode=value(line,"Microcode "); rip_invalid=value(line,"RipInvalid ");
        }
        else if(strncmp(line,"ibs_op_data3:",13)==0) {
            if(rip_invalid) { ++invalid; continue; }
            Address key={.ip=ip},*found=bsearch(&key,addresses,count,sizeof(*addresses),compare_ip);
            if(!found) continue;
            if(tag>=BINS || comp>=BINS) return 2;
            unsigned load=value(line,"LdOp "),store=value(line,"StOp "),miss=value(line,"DcMiss ");
            unsigned unaligned=value(line,"DcMisAcc "),tlb=value(line,"DcL2TlbMiss ");
            ++matched; comp_gt_tag+=comp>tag;
            add(0,tag,comp);
            if(load) add(1,tag,comp);
            if(store) add(2,tag,comp);
            if(branch) add(3,tag,comp);
            if(microcode) add(4,tag,comp);
            if(miss && load) add(5,tag,comp);
            if(unaligned && (load || store)) add(6,tag,comp);
            if(tlb && (load || store)) add(7,tag,comp);
            Function *f=functions+found->function;
            ++f->count; f->tag_sum+=tag; f->comp_sum+=comp;
            f->loads+=load; f->stores+=store; f->misses+=load && miss;
            f->branches+=branch; f->mispredictions+=branch && mispredict;
        }
    }
    fprintf(out,"{\"raw_samples\":%llu,\"compiler_samples\":%llu,\"invalid_rip_samples\":%llu,\"comp_greater_than_tag\":%llu,\"groups\":[",(unsigned long long)raw_samples,(unsigned long long)matched,(unsigned long long)invalid,(unsigned long long)comp_gt_tag);
    const char *names[GROUPS]={"all_compiler_operations","loads","stores","branches","microcode","load_L1_misses","unaligned_memory","memory_L2_TLB_misses"};
    for(unsigned g=0;g<GROUPS;++g) {
        Distribution *d=dist+g;
        fprintf(out,"%s{\"group\":\"%s\",\"samples\":%llu,\"mean_tag_to_retire_cycles\":%.4f,\"mean_completion_to_retire_cycles\":%.4f,\"tag_p50\":%u,\"tag_p90\":%u,\"tag_p99\":%u,\"comp_p50\":%u,\"comp_p90\":%u,\"comp_p99\":%u,\"saturated_samples\":%llu}",g?",":"",names[g],(unsigned long long)d->count,d->count?(double)d->tag_sum/d->count:0,d->count?(double)d->comp_sum/d->count:0,percentile(d->tag,d->count,50),percentile(d->tag,d->count,90),percentile(d->tag,d->count,99),percentile(d->comp,d->count,50),percentile(d->comp,d->count,90),percentile(d->comp,d->count,99),(unsigned long long)d->saturated);
    }
    fprintf(out,"]}\n"); fclose(out);
    qsort(functions,function_count,sizeof(*functions),compare_count);
    fprintf(csv,"function,samples,mean_tag_to_retire_cycles,mean_completion_to_retire_cycles,load_samples,store_samples,L1_load_miss_samples,branch_samples,mispredicted_branch_samples\n");
    for(unsigned i=0;i<function_count;++i) {
        Function *f=functions+i;
        if(!f->count) continue;
        fprintf(csv,"\"%s\",%llu,%.4f,%.4f,%llu,%llu,%llu,%llu,%llu\n",f->name,(unsigned long long)f->count,(double)f->tag_sum/f->count,(double)f->comp_sum/f->count,(unsigned long long)f->loads,(unsigned long long)f->stores,(unsigned long long)f->misses,(unsigned long long)f->branches,(unsigned long long)f->mispredictions);
    }
    fclose(csv); free(addresses);
    return ferror(stdin)?2:0;
}
