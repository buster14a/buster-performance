#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <ctype.h>

typedef struct
{
    uint64_t address, count;
    char op[32], text[240], function[120];
    int width;
} Instruction;

static int by_address(const void *a, const void *b)
{
    const Instruction *x=a,*y=b;
    return x->address < y->address ? -1 : x->address > y->address;
}

static int by_count(const void *a, const void *b)
{
    const Instruction *x=a,*y=b;
    return x->count > y->count ? -1 : x->count < y->count;
}

static void quoted(FILE *f, const char *s)
{
    fputc('"',f);
    for (;*s;++s) { if (*s=='"') fputc('"',f); fputc(*s,f); }
    fputc('"',f);
}

int main(int argc, char **argv)
{
    if (argc != 5) { fprintf(stderr,"usage: profile-join DISASSEMBLY PERF-IP-TEXT CSV SUMMARY\n"); return 2; }
    FILE *dis=fopen(argv[1],"r"),*samples=fopen(argv[2],"r");
    FILE *csv=fopen(argv[3],"w"),*summary=fopen(argv[4],"w");
    if (!dis || !samples || !csv || !summary) return 2;
    size_t count=0,capacity=16384;
    Instruction *ins=malloc(capacity*sizeof(*ins));
    if (!ins) return 2;
    char line[2048],function[120]="";
    while (fgets(line,sizeof(line),dis))
    {
        unsigned long long address;
        char name[120];
        if (sscanf(line,"%llx <%119[^>]>",&address,name)==2)
        {
            snprintf(function,sizeof(function),"%s",name);
            continue;
        }
        char *p=line;
        while (isspace((unsigned char)*p)) ++p;
        if (!isxdigit((unsigned char)*p)) continue;
        char *end;
        uint64_t addr=strtoull(p,&end,16);
        if (*end!=':') continue;
        p=end+1;
        while (isspace((unsigned char)*p)) ++p;
        if (!isalpha((unsigned char)*p) && *p!='.') continue;
        if (count==capacity)
        {
            capacity*=2;
            Instruction *next=realloc(ins,capacity*sizeof(*ins));
            if (!next) return 2;
            ins=next;
        }
        Instruction *i=ins+count++;
        *i=(Instruction){.address=addr};
        sscanf(p,"%31s",i->op);
        p[strcspn(p,"\r\n")]=0;
        snprintf(i->text,sizeof(i->text),"%.239s",p);
        snprintf(i->function,sizeof(i->function),"%s",function);
        i->width = strstr(p,"zmm") || strstr(p,"ZMMWORD") ? 512 : strstr(p,"ymm") || strstr(p,"YMMWORD") ? 256 : strstr(p,"xmm") || strstr(p,"XMMWORD") ? 128 : 0;
    }
    fclose(dis);
    qsort(ins,count,sizeof(*ins),by_address);
    uint64_t all=0,owned=0,matched=0,width[4]={0};
    while (fgets(line,sizeof(line),samples))
    {
        ++all;
        if (strstr(line,"compiler-native")==NULL) continue;
        ++owned;
        unsigned long long address;
        if (sscanf(line,"%llx",&address)!=1) continue;
        Instruction key={.address=address};
        Instruction *found=bsearch(&key,ins,count,sizeof(*ins),by_address);
        if (!found) continue;
        ++matched; ++found->count;
        ++width[found->width==512?3:found->width==256?2:found->width==128?1:0];
    }
    fclose(samples);
    qsort(ins,count,sizeof(*ins),by_count);
    fprintf(csv,"address,function,mnemonic,instruction,register_width,samples,percent_of_compiler_samples\n");
    for (size_t n=0;n<count && ins[n].count;++n)
    {
        Instruction *i=ins+n;
        fprintf(csv,"0x%llx,",(unsigned long long)i->address);
        quoted(csv,i->function); fputc(',',csv); quoted(csv,i->op); fputc(',',csv); quoted(csv,i->text);
        fprintf(csv,",%d,%llu,%.6f\n",i->width,(unsigned long long)i->count,100.0*i->count/owned);
    }
    fprintf(summary,"{\"all_samples\":%llu,\"compiler_samples\":%llu,\"matched_samples\":%llu,\"scalar_or_mask_samples\":%llu,\"xmm_samples\":%llu,\"ymm_samples\":%llu,\"zmm_samples\":%llu,\"top_instructions\":[",(unsigned long long)all,(unsigned long long)owned,(unsigned long long)matched,(unsigned long long)width[0],(unsigned long long)width[1],(unsigned long long)width[2],(unsigned long long)width[3]);
    for (size_t n=0;n<30 && n<count && ins[n].count;++n)
    {
        Instruction *i=ins+n;
        fprintf(summary,"%s{\"address\":\"0x%llx\",\"function\":",n?",":"",(unsigned long long)i->address);
        quoted(summary,i->function); fprintf(summary,",\"instruction\":"); quoted(summary,i->text);
        fprintf(summary,",\"samples\":%llu,\"pct\":%.6f}",(unsigned long long)i->count,100.0*i->count/owned);
    }
    fprintf(summary,"]}\n");
    fclose(csv); fclose(summary); free(ins);
    return 0;
}
