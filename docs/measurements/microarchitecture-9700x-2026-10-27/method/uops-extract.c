#include <libxml/xmlreader.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void attr(xmlTextReaderPtr r, const char *name, char *out, size_t capacity)
{
    xmlChar *v=xmlTextReaderGetAttribute(r,(const xmlChar *)name);
    snprintf(out,capacity,"%s",v?(char *)v:"");
    xmlFree(v);
}

static void quote(const char *s)
{
    putchar('"');
    for (;*s;++s) { if (*s=='"') putchar('"'); putchar(*s); }
    putchar('"');
}

int main(int argc, char **argv)
{
    if (argc!=2) return 2;
    xmlTextReaderPtr r=xmlReaderForFile(argv[1],NULL,XML_PARSE_NONET);
    if (!r) return 2;
    char instruction[240]="",form[240]="",asm_name[40]="",arch[40]="";
    int selected=0,active=0;
    puts("instruction,iform,architecture,kind,TP_loop_cycles,TP_unrolled_cycles,executed_uops,ports,TP_from_ports,documented_latency");
    while (xmlTextReaderRead(r)==1)
    {
        if (xmlTextReaderNodeType(r)!=XML_READER_TYPE_ELEMENT) continue;
        const char *name=(const char *)xmlTextReaderConstName(r);
        if (!strcmp(name,"instruction"))
        {
            attr(r,"string",instruction,sizeof(instruction)); attr(r,"iform",form,sizeof(form)); attr(r,"asm",asm_name,sizeof(asm_name));
            selected = strstr(instruction,"ZMM") && (!strcmp(asm_name,"VPGATHERDD") || !strcmp(asm_name,"VPGATHERDQ") || !strcmp(asm_name,"VPCOMPRESSD") || !strcmp(asm_name,"VPCOMPRESSB") || !strcmp(asm_name,"VMOVDQU64") || !strcmp(asm_name,"VMOVDQA64") || !strcmp(asm_name,"VPERMD") || !strcmp(asm_name,"VPERMB"));
            active=0;
        }
        else if (!strcmp(name,"architecture"))
        {
            attr(r,"name",arch,sizeof(arch));
            active=selected && (!strcmp(arch,"ZEN5") || !strcmp(arch,"ZEN4"));
        }
        else if (active && (!strcmp(name,"measurement") || !strcmp(name,"doc")))
        {
            const char *fields[]={"TP_loop","TP_unrolled","uops","ports","TP_ports","latency"};
            quote(instruction); putchar(','); quote(form); putchar(','); quote(arch); putchar(','); quote(name);
            for (int i=0;i<6;++i)
            {
                char value[256]; attr(r,fields[i],value,sizeof(value));
                if (i==1 && !strcmp(name,"doc")) attr(r,"TP",value,sizeof(value));
                putchar(','); quote(value);
            }
            putchar('\n');
        }
    }
    xmlFreeTextReader(r);
    return 0;
}
