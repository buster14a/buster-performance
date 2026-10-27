#define _GNU_SOURCE
#define _XOPEN_SOURCE 700
#include <ftw.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdint.h>

extern char **environ;
static const char *secret_values[256];
static size_t secret_lengths[256];
static unsigned secret_count;
static uint64_t files,bytes,uuid_redactions,serial_redactions;
static const char *root;

static int is_uuid(const char *p,size_t n)
{
    if(n<36) return 0;
    for(size_t i=0;i<36;++i)
    {
        if(i==8 || i==13 || i==18 || i==23) { if(p[i]!='-') return 0; }
        else if(!isxdigit((unsigned char)p[i])) return 0;
    }
    return 1;
}
static int visit(const char *path,const struct stat *st,int type,struct FTW *ftw)
{
    (void)ftw;
    if(type!=FTW_F || st->st_size==0) return 0;
    ++files; bytes+=(uint64_t)st->st_size;
    int metadata=strstr(path,"/hardware/")!=NULL;
    int fd=open(path,metadata?O_RDWR:O_RDONLY);
    if(fd<0) { perror(path); return 1; }
    size_t size=(size_t)st->st_size;
    char *data=mmap(NULL,size,PROT_READ|(metadata?PROT_WRITE:0),metadata?MAP_SHARED:MAP_PRIVATE,fd,0);
    if(data==MAP_FAILED) { perror(path); close(fd); return 1; }
    for(unsigned i=0;i<secret_count;++i)
        if(memmem(data,size,secret_values[i],secret_lengths[i])!=NULL)
        {
            fprintf(stderr,"Known environment secret found in %s; value suppressed\n",path);
            munmap(data,size); close(fd); return 3;
        }
    unsigned changed_uuid=0,changed_serial=0;
    if(metadata)
    {
        for(size_t p=0;p<size;++p)
        {
            if(is_uuid(data+p,size-p))
            {
                for(size_t i=0;i<36;++i) if(data[p+i]!='-') data[p+i]='0';
                ++uuid_redactions; ++changed_uuid; p+=35;
            }
        }
        const char *labels[]={"Serial Number:","Asset Tag:"};
        for(unsigned l=0;l<2;++l)
        {
            size_t offset=0,label_n=strlen(labels[l]);
            while(offset<size)
            {
                char *p=memmem(data+offset,size-offset,labels[l],label_n);
                if(!p) break;
                p+=label_n;
                while(p<data+size && *p!='\n' && *p!='\r')
                {
                    if(!isspace((unsigned char)*p)) *p='*';
                    ++p;
                }
                ++serial_redactions; ++changed_serial;
                offset=(size_t)(p-data);
            }
        }
        if(changed_uuid || changed_serial)
        {
            if(msync(data,size,MS_SYNC)!=0) { perror(path); munmap(data,size); close(fd); return 1; }
            fprintf(stderr,"Redacted incidental machine IDs in %s: %u UUIDs, %u serial/asset fields\n",path+strlen(root)+1,changed_uuid,changed_serial);
        }
    }
    munmap(data,size); close(fd);
    return 0;
}
int main(int argc,char **argv)
{
    if(argc!=2) return 2;
    root=argv[1];
    for(char **entry=environ;*entry && secret_count<256;++entry)
    {
        const char *eq=strchr(*entry,'=');
        if(!eq) continue;
        char key[256]; size_t n=(size_t)(eq-*entry);
        if(n>=sizeof(key)) continue;
        memcpy(key,*entry,n); key[n]=0;
        if((strstr(key,"TOKEN") || strstr(key,"SECRET") || strstr(key,"PASSWORD") || strstr(key,"API_KEY")) && strlen(eq+1)>=12)
        {
            secret_values[secret_count]=eq+1;
            secret_lengths[secret_count++]=strlen(eq+1);
        }
    }
    int result=nftw(root,visit,24,FTW_PHYS);
    if(result==0) printf("{\"scanned_nonempty_files\":%llu,\"scanned_bytes\":%llu,\"known_environment_secret_matches\":0,\"uuid_redactions\":%llu,\"serial_asset_redactions\":%llu}\n",(unsigned long long)files,(unsigned long long)bytes,(unsigned long long)uuid_redactions,(unsigned long long)serial_redactions);
    return result;
}
