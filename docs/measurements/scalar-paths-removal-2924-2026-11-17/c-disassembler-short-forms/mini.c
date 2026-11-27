#include "buster/compiler/x86_64_disassembler_benchmark.c"
int main(int argc, char** argv)
{
    if (argc == 2 && strcmp(argv[1],"--samples")==0)
    {
        if (!x86_disassembler_initialize()) return 1;
        uint32_t state=3451;
        for(unsigned i=0;i<265793;i++)
        {
            uint8_t bytes[64]; X86Decoded decoded[16];
            const unsigned n=i==0?0:i<=256?1:i<=65792?2:(state%62)+3;
            for(unsigned j=0;j<n;j++){state=state*1664525+1013904223;bytes[j]=(uint8_t)(state>>24);}
            if(i>0 && i<=256)bytes[0]=(uint8_t)(i-1);
            if(i>=257 && i<=65792){bytes[0]=(uint8_t)(i-257);bytes[1]=(uint8_t)((i-257)>>8);}
            for(unsigned cap=0;cap<=3;cap++)
            {
                memset(decoded,0,sizeof(decoded));const X86DecodeResult r=x86_disassemble(bytes,n,decoded,cap);
                printf("%u %lu %lu %u ",i,r.count,r.consumed,r.status);
                for(unsigned q=0;q<r.count;q++){const uint8_t* raw=(const uint8_t*)(decoded+q);for(unsigned b=0;b<sizeof(*decoded);b++)printf("%02x",raw[b]);}
                putchar('\n');
            }
        }
        return 0;
    }
    return run_x86_disassembler_benchmark(argc,argv);
}
