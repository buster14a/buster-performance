#define _GNU_SOURCE
#include <immintrin.h>
#include <pthread.h>
#include <sched.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <time.h>

typedef struct
{
    uint64_t *a, *b, *c;
    int cpu, passes, nt;
    pthread_barrier_t *barrier;
} Worker;

static const size_t elements = 1u << 23;
static volatile uint64_t check;

static double seconds(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return t.tv_sec + t.tv_nsec * 1e-9;
}

static void *work(void *p)
{
    Worker *w = p;
    cpu_set_t set;
    CPU_ZERO(&set); CPU_SET(w->cpu, &set);
    if (pthread_setaffinity_np(pthread_self(), sizeof(set), &set) != 0) abort();
    for (size_t i = 0; i < elements; ++i) { w->a[i] = i + 17; w->b[i] = i * 33 + 7; w->c[i] = 0; }
    pthread_barrier_wait(w->barrier);
    pthread_barrier_wait(w->barrier);
    for (int pass = 0; pass < w->passes; ++pass)
    {
        for (size_t i = 0; i < elements; i += 8)
        {
            __m512i a = _mm512_load_si512(w->a+i);
            __m512i b = _mm512_load_si512(w->b+i);
            __m512i c = _mm512_xor_si512(a,b);
            if (w->nt) _mm512_stream_si512((__m512i *)(w->c+i),c);
            else _mm512_store_si512(w->c+i,c);
        }
        _mm_sfence();
        __asm__ volatile("" ::: "memory");
    }
    pthread_barrier_wait(w->barrier);
    return NULL;
}

int main(void)
{
    cpu_set_t allowed;
    sched_getaffinity(0,sizeof(allowed),&allowed);
    int cpus[8], count = 0;
    for (int i = 0; i < 8; ++i) if (CPU_ISSET(i,&allowed)) cpus[count++] = i;
    if (count == 0) return 1;
    for (int round = 0; round < 3; ++round)
        for (int requested = 1; requested <= 8; requested *= 2)
            for (int nt = 0; nt < 2; ++nt)
            {
                int n = requested < count ? requested : count;
                if (requested == 8 && count < 8 && count <= 4) continue;
                pthread_barrier_t barrier;
                pthread_barrier_init(&barrier,NULL,n+1);
                Worker w[8]; pthread_t threads[8];
                for (int i = 0; i < n; ++i)
                {
                    w[i] = (Worker){.cpu=cpus[i],.passes=16,.nt=nt,.barrier=&barrier};
                    w[i].a = mmap(NULL,elements*8,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
                    w[i].b = mmap(NULL,elements*8,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
                    w[i].c = mmap(NULL,elements*8,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
                    if (w[i].a==MAP_FAILED || w[i].b==MAP_FAILED || w[i].c==MAP_FAILED) return 1;
                    if (pthread_create(threads+i,NULL,work,w+i) != 0) return 1;
                }
                pthread_barrier_wait(&barrier);
                double start = seconds();
                pthread_barrier_wait(&barrier);
                pthread_barrier_wait(&barrier);
                double elapsed = seconds()-start;
                for (int i = 0; i < n; ++i)
                {
                    pthread_join(threads[i],NULL);
                    check = w[i].c[719];
                    if (check != ((719+17) ^ (719*33+7))) return 1;
                    munmap(w[i].a,elements*8); munmap(w[i].b,elements*8); munmap(w[i].c,elements*8);
                }
                pthread_barrier_destroy(&barrier);
                printf("{\"round\":%d,\"cores\":%d,\"non_temporal\":%s,\"wall_s\":%.9f,\"logical_bytes\":%llu,\"GB_s\":%.6f}\n",round,n,nt?"true":"false",elapsed,(unsigned long long)elements*8*3*16*n,elements*8*3.0*16*n/elapsed/1e9);
                fflush(stdout);
            }
    return 0;
}
