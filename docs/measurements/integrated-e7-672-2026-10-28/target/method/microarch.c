#define _GNU_SOURCE
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <sched.h>
#include <time.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <limits.h>
#include <linux/perf_event.h>
#include <sys/syscall.h>

static char self[PATH_MAX];
static int run_id;
static const char *host;
static const char *out;

static double now(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return t.tv_sec + t.tv_nsec * 1e-9;
}

static void make_dir(const char *p)
{
    if (mkdir(p, 0755) != 0 && errno != EEXIST)
    {
        perror(p);
        exit(2);
    }
}

static int cpu_inventory(int *cpus, bool physical)
{
    cpu_set_t allowed;
    sched_getaffinity(0, sizeof(allowed), &allowed);
    int n = 0;
    int seen[CPU_SETSIZE];
    int seen_n = 0;
    for (int c = 0; c < CPU_SETSIZE; ++c)
    {
        if (!CPU_ISSET(c, &allowed)) continue;
        char path[256];
        snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%d/topology/core_id", c);
        FILE *f = fopen(path, "r");
        int core = c;
        if (f != NULL) { if (fscanf(f, "%d", &core) != 1) core = c; fclose(f); }
        bool duplicate = false;
        for (int i = 0; i < seen_n; ++i) duplicate |= seen[i] == core;
        if (!duplicate) { cpus[n++] = c; seen[seen_n++] = core; }
    }
    if (!physical)
    {
        for (int c = 0; c < CPU_SETSIZE; ++c)
        {
            if (!CPU_ISSET(c, &allowed)) continue;
            bool exists = false;
            for (int i = 0; i < n; ++i) exists |= cpus[i] == c;
            if (!exists) cpus[n++] = c;
        }
    }
    return n;
}

static int bench(int argc, char **argv)
{
    if (argc != 9) return 2;
    const char *stage = argv[2];
    int jobs = atoi(argv[3]);
    int tasks = atoi(argv[4]);
    int lanes = atoi(argv[5]);
    bool scalar = atoi(argv[6]) != 0;
    bool timing = atoi(argv[7]) != 0;
    const char *binary = argv[8];
    int cpus[CPU_SETSIZE];
    int cpu_n = cpu_inventory(cpus, jobs <= 8);
    if (cpu_n == 0 || jobs < 1 || tasks < 1 || jobs > 64) return 2;
    if (jobs > cpu_n) jobs = cpu_n;
    if (jobs > tasks) jobs = tasks;
    // The dedicated benchmark core on the 9700X is CPU 2.
    if (jobs == 1 && lanes == 1)
    {
        for (int i = 0; i < cpu_n; ++i)
        {
            if (cpus[i] == 2) { int tmp = cpus[0]; cpus[0] = 2; cpus[i] = tmp; }
        }
    }
    const char *label = getenv("BENCH_LABEL");
    if (label == NULL) label = "manual";
    char dir[512];
    make_dir("scratch");
    snprintf(dir, sizeof(dir), "scratch/%s", label);
    make_dir(dir);
    FILE *details;
    char detail_path[600];
    snprintf(detail_path, sizeof(detail_path), "%s/children.tsv", dir);
    details = fopen(detail_path, "w");
    if (details == NULL) return 2;
    fprintf(details, "task\tpid\tcpu\tstatus\tuser_s\tsystem_s\tmaxrss_kb\tminor_faults\tmajor_faults\tvoluntary_cs\tinvoluntary_cs\tobject_bytes\n");
    struct stat input;
    if (stat("corpus/sqlite/sqlite3.c", &input) != 0) return 2;
    pid_t pids[64] = {0};
    int event_fds[64][5];
    uint64_t totals[5] = {0};
    double minimum_running = 100.0;
    bool own_counters = getenv("BENCH_COUNTERS") != NULL;
    const char *raw_config = getenv("BENCH_RAW_CONFIG");
    const char *raw_name = getenv("BENCH_RAW_NAME");
    int counter_errors = 0;
    int indices[64] = {0};
    int launched = 0, finished = 0, failures = 0;
    long maxrss = 0;
    double user = 0, system = 0;
    long minflt = 0, majflt = 0, nvcsw = 0, nivcsw = 0;
    uint64_t output_bytes = 0;
    double start = now();
    while (finished < tasks)
    {
        for (int slot = 0; slot < jobs && launched < tasks; ++slot)
        {
            if (pids[slot] != 0) continue;
            int index = launched++;
            int barrier[2];
            if (pipe(barrier) != 0) return 2;
            pid_t p = fork();
            if (p == 0)
            {
                close(barrier[1]);
                cpu_set_t set;
                CPU_ZERO(&set);
                if (lanes == 1) CPU_SET(cpus[slot], &set);
                else for (int c = 0; c < cpu_n; ++c) CPU_SET(cpus[c], &set);
                if (sched_setaffinity(0, sizeof(set), &set) != 0) _exit(125);
                char log[600], object[600], lane_arg[32];
                snprintf(log, sizeof(log), "%s/child-%03d.log", dir, index);
                snprintf(object, sizeof(object), "%s/output-%03d.o", dir, index);
                snprintf(lane_arg, sizeof(lane_arg), "%d", lanes);
                int err = open(log, O_WRONLY | O_CREAT | O_TRUNC, 0644);
                int devnull = open("/dev/null", O_WRONLY);
                if (err < 0 || devnull < 0) _exit(125);
                dup2(err, 2); dup2(devnull, 1); close(err); close(devnull);
                char *a[80]; int n = 0;
                a[n++] = (char *)binary;
                if (strcmp(stage, "parse") == 0) a[n++] = "parse";
                bool reference = strstr(binary, "tcc") != NULL || strstr(binary, "clang") != NULL;
                if (!reference && lanes > 0 && strcmp(stage, "pp") != 0 && strcmp(stage, "parse") != 0)
                {
                    a[n++] = "--lanes"; a[n++] = lane_arg;
                }
                if (scalar) a[n++] = "--scalar";
                if (timing) a[n++] = "--time-stages";
                a[n++] = strcmp(stage, "pp") == 0 ? "-E" : strcmp(stage, "compile") == 0 ? "-c" : "-fsyntax-only";
                a[n++] = "-DSQLITE_OMIT_LOAD_EXTENSION";
                a[n++] = "-DSQLITE_THREADSAFE=0";
                a[n++] = "-DSQLITE_ENABLE_MEMSYS5";
                a[n++] = "-DSQLITE_ENABLE_RTREE";
                a[n++] = "-std=gnu17";
                if (!reference)
                {
                    a[n++] = "--predefines"; a[n++] = "corpus/gnu17-pinned-predefines.txt";
                    a[n++] = "--clang-features";
                    a[n++] = "--target=x86_64-linux-gnu";
                    a[n++] = "-march=znver5";
                    a[n++] = "-nostdinc";
                    a[n++] = "-isystem"; a[n++] = "corpus/headers/usr/lib/clang/23/include";
                    a[n++] = "-isystem"; a[n++] = "corpus/headers/usr/local/include";
                    a[n++] = "-isystem"; a[n++] = "corpus/headers/usr/include";
                }
                a[n++] = "-Icorpus/sqlite";
                a[n++] = "corpus/sqlite/sqlite3.c";
                if (strcmp(stage, "compile") == 0 || strcmp(stage, "pp") == 0)
                {
                    a[n++] = "-o";
                    a[n++] = strcmp(stage, "pp") == 0 ? "/dev/null" : object;
                }
                a[n] = NULL;
                char token;
                if (read(barrier[0], &token, 1) != 1) _exit(125);
                close(barrier[0]);
                execvp(binary, a);
                _exit(127);
            }
            if (p < 0) { perror("fork"); return 2; }
            close(barrier[0]);
            for (int e = 0; e < 5; ++e)
            {
                event_fds[slot][e] = -1;
                if (own_counters && (raw_config == NULL || e < 3))
                {
                    uint64_t configs[] = {PERF_COUNT_HW_CPU_CYCLES, PERF_COUNT_HW_INSTRUCTIONS, PERF_COUNT_HW_BRANCH_INSTRUCTIONS, PERF_COUNT_HW_BRANCH_MISSES, 0xc1};
                    struct perf_event_attr attr = {0};
                    attr.size = sizeof(attr);
                    attr.type = e == 4 ? PERF_TYPE_RAW : PERF_TYPE_HARDWARE;
                    attr.config = configs[e];
                    if (raw_config != NULL && e == 2)
                    {
                        attr.type = PERF_TYPE_RAW;
                        attr.config = strtoull(raw_config, NULL, 0);
                    }
                    attr.disabled = 1;
                    attr.enable_on_exec = 1;
                    attr.inherit = 1;
                    attr.exclude_kernel = 1;
                    attr.exclude_hv = 1;
                    attr.read_format = PERF_FORMAT_TOTAL_TIME_ENABLED | PERF_FORMAT_TOTAL_TIME_RUNNING;
                    event_fds[slot][e] = syscall(SYS_perf_event_open, &attr, p, -1, -1, PERF_FLAG_FD_CLOEXEC);
                    counter_errors += event_fds[slot][e] < 0;
                }
            }
            if (write(barrier[1], "x", 1) != 1) return 2;
            close(barrier[1]);
            pids[slot] = p;
            indices[slot] = index;
        }
        int status;
        struct rusage usage;
        pid_t p = wait4(-1, &status, 0, &usage);
        if (p < 0) { if (errno == EINTR) continue; perror("wait4"); return 2; }
        for (int slot = 0; slot < jobs; ++slot)
        {
            if (pids[slot] != p) continue;
            int result = WIFEXITED(status) ? WEXITSTATUS(status) : 128 + WTERMSIG(status);
            failures += result != 0;
            double u = usage.ru_utime.tv_sec + usage.ru_utime.tv_usec * 1e-6;
            double s = usage.ru_stime.tv_sec + usage.ru_stime.tv_usec * 1e-6;
            user += u; system += s;
            minflt += usage.ru_minflt; majflt += usage.ru_majflt;
            nvcsw += usage.ru_nvcsw; nivcsw += usage.ru_nivcsw;
            if (usage.ru_maxrss > maxrss) maxrss = usage.ru_maxrss;
            char object[600];
            snprintf(object, sizeof(object), "%s/output-%03d.o", dir, indices[slot]);
            struct stat os;
            uint64_t bytes = strcmp(stage, "compile") == 0 && result == 0 && stat(object, &os) == 0 ? (uint64_t)os.st_size : 0;
            output_bytes += bytes;
            for (int e = 0; e < 5; ++e)
            {
                if (event_fds[slot][e] >= 0)
                {
                    uint64_t values[3] = {0};
                    if (read(event_fds[slot][e], values, sizeof(values)) == sizeof(values))
                    {
                        totals[e] += values[0];
                        double percent = values[1] ? 100.0 * values[2] / values[1] : 0;
                        if (percent < minimum_running) minimum_running = percent;
                    }
                    else ++counter_errors;
                    close(event_fds[slot][e]);
                }
            }
            fprintf(details, "%d\t%d\t%d\t%d\t%.6f\t%.6f\t%ld\t%ld\t%ld\t%ld\t%ld\t%llu\n", indices[slot], p, cpus[slot], result, u, s, usage.ru_maxrss, usage.ru_minflt, usage.ru_majflt, usage.ru_nvcsw, usage.ru_nivcsw, (unsigned long long)bytes);
            pids[slot] = 0;
            ++finished;
        }
    }
    double elapsed = now() - start;
    fclose(details);
    printf("{\"label\":\"%s\",\"stage\":\"%s\",\"binary\":\"%s\",\"jobs\":%d,\"tasks\":%d,\"lanes\":%d,\"scalar\":%s,\"timing\":%s,\"failures\":%d,\"wall_s\":%.9f,\"user_s\":%.6f,\"system_s\":%.6f,\"maxrss_per_process_kb\":%ld,\"minor_faults\":%ld,\"major_faults\":%ld,\"voluntary_cs\":%ld,\"involuntary_cs\":%ld,\"input_bytes_per_task\":%lld,\"completed_bytes\":%lld,\"output_bytes\":%llu,\"MB_per_s\":%.6f,\"CPU_seconds_per_MB\":%.9f,\"CPU_utilization\":%.5f,\"cpus\":[", label, stage, binary, jobs, tasks, lanes, scalar ? "true" : "false", timing ? "true" : "false", failures, elapsed, user, system, maxrss, minflt, majflt, nvcsw, nivcsw, (long long)input.st_size, (long long)input.st_size * (tasks - failures), (unsigned long long)output_bytes, input.st_size * (tasks - failures) / elapsed / 1e6, (user + system) / (input.st_size * tasks / 1e6), (user + system) / elapsed);
    for (int i = 0; i < (lanes > 1 ? cpu_n : jobs); ++i) printf("%s%d", i ? "," : "", cpus[i]);
    printf("],\"counter_errors\":%d,\"counter_min_running_pct\":%.5f,\"cycles_u\":%llu,\"instructions_u\":%llu,\"branches_u\":%llu,\"branch_misses_u\":%llu,\"retired_ops_u\":%llu,\"raw_event\":\"%s\",\"raw_event_count\":%llu}\n", counter_errors, minimum_running, (unsigned long long)totals[0], (unsigned long long)totals[1], (unsigned long long)(raw_config ? 0 : totals[2]), (unsigned long long)totals[3], (unsigned long long)totals[4], raw_name ? raw_name : "", (unsigned long long)(raw_config ? totals[2] : 0));
    // Retain one real object per measurement for inspection; cleanup is outside the timed span.
    for (int i = 1; i < tasks; ++i)
    {
        char object[600];
        snprintf(object, sizeof(object), "%s/output-%03d.o", dir, i);
        unlink(object);
    }
    return failures != 0;
}

static int suite(const char *mode)
{
    setenv("BENCH_COUNTERS", "1", 1);
    int result = 0;
    if (strcmp(mode, "throughput") == 0)
    {
        int jobs[] = {1, 2, 4, 8, 15};
        for (int r = 0; r < 5; ++r)
            for (int j = 0; j < 5; ++j)
            {
                int k = jobs[(j+r)%5];
                char label[100], sj[32], st[32];
                snprintf(label, sizeof(label), "suite-throughput-r%d-j%d", r, k);
                setenv("BENCH_LABEL", label, 1);
                snprintf(sj, sizeof(sj), "%d", k); snprintf(st, sizeof(st), "%d", k*4);
                char *a[] = {self,"bench","compile",sj,st,"1","0","0","./compiler-native"};
                result |= bench(9, a);
                fflush(stdout);
            }
    }
    else if (strcmp(mode, "budgets") == 0)
    {
        const char *bins[]={"./compiler-native","./compiler-common","/usr/bin/tcc","/usr/bin/clang"};
        for (int r=0;r<3;++r)
        {
            for (int j=0;j<3;++j)
            {
                int cfg=(j+r)%3;
                const char *l=cfg==0?"1":cfg==1?"8":"0";
                char label[100]; snprintf(label,sizeof(label),"suite-budget-r%d-l%s",r,l); setenv("BENCH_LABEL",label,1);
                char *a[]={self,"bench","compile","8","16",(char *)l,"0","0","./compiler-native"};
                result |= bench(9,a); fflush(stdout);
            }
            for (int j=0;j<2;++j)
            {
                int scalar=(j+r)%2;
                char label[100]; snprintf(label,sizeof(label),"suite-simd-r%d-s%d",r,scalar); setenv("BENCH_LABEL",label,1);
                char *a[]={self,"bench","compile","8","16","1",scalar?"1":"0","0","./compiler-native"};
                result |= bench(9,a); fflush(stdout);
            }
            for (int j=0;j<4;++j)
            {
                const char *bin=bins[(j+r)%4];
                char label[100]; snprintf(label,sizeof(label),"suite-reference-r%d-b%d",r,(j+r)%4); setenv("BENCH_LABEL",label,1);
                char *a[]={self,"bench","compile","8","16","1","0","0",(char *)bin};
                result |= bench(9,a); fflush(stdout);
            }
        }
    }
    else if (strcmp(mode, "phases") == 0)
    {
        const char *stages[] = {"pp", "parse", "check", "compile"};
        for (int r = 0; r < 3; ++r)
            for (int j = 0; j < 2; ++j)
                for (int s = 0; s < 4; ++s)
                {
                    const char *stage = stages[(s+r)%4];
                    char label[100];
                    snprintf(label, sizeof(label), "suite-phase-r%d-j%d-%s", r, j ? 8 : 1, stage);
                    setenv("BENCH_LABEL", label, 1);
                    char *a[] = {self,"bench",(char *)stage,j ? "8" : "1",j ? "16" : "2","1","0","0","./compiler-native"};
                    result |= bench(9, a); fflush(stdout);
                }
        for (int r = 0; r < 5; ++r)
            for (int l = 1; l <= 8; l *= 2)
            {
                char label[100], sl[32];
                snprintf(label, sizeof(label), "suite-lanes-r%d-l%d", r, l); snprintf(sl,sizeof(sl),"%d",l);
                setenv("BENCH_LABEL",label,1);
                char *a[] = {self,"bench","compile","1","1",sl,"0","1","./compiler-native"};
                result |= bench(9,a); fflush(stdout);
            }
        for (int r = 0; r < 3; ++r)
        {
            char label[100]; snprintf(label,sizeof(label),"suite-scalar-r%d",r); setenv("BENCH_LABEL",label,1);
            char *a[] = {self,"bench","compile","8","8","1","1","1","./compiler-native"};
            result |= bench(9,a); fflush(stdout);
        }
    }
    return result;
}

static int counter_suite(int start, int end)
{
    FILE *f = fopen("events.tsv", "r");
    if (f == NULL) return 2;
    setenv("BENCH_COUNTERS", "1", 1);
    char line[2048];
    int index = 0, result = 0;
    while (fgets(line, sizeof(line), f) != NULL)
    {
        if (index >= start && index < end)
        {
            char *tab = strchr(line, '\t');
            if (tab == NULL) return 2;
            *tab++ = 0;
            char *ev = strstr(tab, "event=");
            char *um = strstr(tab, "umask=");
            char *cm = strstr(tab, "cmask=");
            char *iv = strstr(tab, "inv=");
            char *ed = strstr(tab, "edge=");
            if (ev == NULL) return 2;
            uint64_t event = strtoull(ev+6, NULL, 0);
            uint64_t umask = um ? strtoull(um+6, NULL, 0) : 0;
            uint64_t config = (event & 255) | ((event & 0xf00) << 24) | (umask << 8);
            if (cm) config |= strtoull(cm+6, NULL, 0) << 24;
            if (iv) config |= strtoull(iv+4, NULL, 0) << 23;
            if (ed) config |= strtoull(ed+5, NULL, 0) << 18;
            char conf[40], label[100];
            snprintf(conf, sizeof(conf), "0x%llx", (unsigned long long)config);
            snprintf(label, sizeof(label), "suite-event-%03d", index);
            setenv("BENCH_RAW_CONFIG", conf, 1); setenv("BENCH_RAW_NAME", line, 1); setenv("BENCH_LABEL", label, 1);
            char *a[] = {self,"bench","compile","8","8","1","0","0","./compiler-native"};
            result |= bench(9,a); fflush(stdout);
        }
        ++index;
    }
    fclose(f);
    return result;
}

static int metric_suite(int start, int end)
{
    FILE *catalog = fopen("metrics.txt", "r");
    if (catalog == NULL) return 2;
    make_dir("results");
    make_dir("results/metric-isolated");
    FILE *manifest = fopen("results/metric-isolated/manifest.tsv", "a");
    if (manifest == NULL) { fclose(catalog); return 2; }
    char metric[512];
    int index = 0, result = 0;
    while (fgets(metric, sizeof(metric), catalog) != NULL)
    {
        metric[strcspn(metric, "\r\n")] = 0;
        if (index >= start && index < end)
        {
            char label[80], json[256], log[256], workload[256];
            snprintf(label,sizeof(label),"metric-isolated-%03d",index);
            snprintf(json,sizeof(json),"results/metric-isolated/%s.perf.json",label);
            snprintf(log,sizeof(log),"results/metric-isolated/%s.log",label);
            snprintf(workload,sizeof(workload),"results/metric-isolated/%s.work.json",label);
            fflush(NULL);
            pid_t child = fork();
            if (child == 0)
            {
                int err = open(log,O_CREAT|O_TRUNC|O_WRONLY,0644);
                int output = open(workload,O_CREAT|O_TRUNC|O_WRONLY,0644);
                if (err < 0 || output < 0) _exit(125);
                dup2(err,2); dup2(output,1); close(err); close(output);
                setenv("BENCH_LABEL",label,1);
                unsetenv("BENCH_COUNTERS"); unsetenv("BENCH_RAW_CONFIG"); unsetenv("BENCH_RAW_NAME");
                execlp("perf","perf","stat","-a","-C","0-7","-j","--no-big-num","--metric-no-group","-o",json,"-M",metric,"--",self,"bench","compile","8","8","1","0","0","./compiler-native",(char *)NULL);
                _exit(127);
            }
            if (child < 0) { result = 2; break; }
            int status;
            while (waitpid(child,&status,0) < 0 && errno == EINTR) { }
            int code = WIFEXITED(status) ? WEXITSTATUS(status) : 128 + WTERMSIG(status);
            fprintf(manifest,"%s\t%s\t%d\n",label,metric,code); fflush(manifest);
            printf("%s\t%s\t%d\n",label,metric,code); fflush(stdout);
            result |= code;
        }
        ++index;
    }
    fclose(manifest); fclose(catalog);
    return result;
}

static int run(const char *label, const char *stage, int jobs, int tasks, int lanes, int scalar, int timing,
               const char *events, const char *metric, const char *record, const char *binary)
{
    char full[256], json[PATH_MAX], log[PATH_MAX], work[PATH_MAX], data[PATH_MAX];
    snprintf(full, sizeof(full), "%s-%04d", label, run_id++);
    snprintf(json, sizeof(json), "%s/%s.perf.json", out, full);
    snprintf(log, sizeof(log), "%s/%s.log", out, full);
    snprintf(work, sizeof(work), "%s/%s.work.json", out, full);
    snprintf(data, sizeof(data), "%s/%s.data", out, full);
    char sj[32], st[32], sl[32], ss[32], sc[32], grant[32];
    snprintf(sj, sizeof(sj), "%d", jobs); snprintf(st, sizeof(st), "%d", tasks);
    snprintf(sl, sizeof(sl), "%d", lanes); snprintf(ss, sizeof(ss), "%d", scalar);
    snprintf(sc, sizeof(sc), "%d", timing); snprintf(grant, sizeof(grant), "%d", jobs > 8 ? 8 : jobs > lanes ? jobs : lanes);
    char *a[80]; int n = 0;
    bool remote = strcmp(host, "9700x") == 0;
    if (remote) a[n++] = "/home/david/buster-fast-bench/exclusive.sh";
    else { a[n++] = "/home/david/dev/scripts/cores"; a[n++] = "-n"; a[n++] = grant; a[n++] = "--"; }
    a[n++] = "timeout"; a[n++] = "55";
    if (events != NULL || metric != NULL || record != NULL)
    {
        a[n++] = "perf";
        if (record != NULL)
        {
            a[n++] = "record"; a[n++] = "-q"; a[n++] = "-o"; a[n++] = data;
            if (strcmp(record, "cycles") == 0 || strcmp(record, "cycles-stack") == 0)
            {
                a[n++] = "-e"; a[n++] = "cycles"; a[n++] = "-F"; a[n++] = "4999";
                a[n++] = "-m"; a[n++] = "16M";
                if (strcmp(record, "cycles-stack") == 0)
                {
                    a[n-3] = "999";
                    a[n++] = "--call-graph"; a[n++] = "dwarf,8192";
                }
            }
            else if (strcmp(record, "combined") == 0 || strcmp(record, "triad") == 0 || strcmp(record, "joint") == 0)
            {
                a[n++] = "-e"; a[n++] = "{cycles:u,instructions:u,branches:u,branch-misses:u}:S";
                a[n++] = "-c"; a[n++] = "4000003";
                if (strcmp(record, "joint") != 0) a[n++] = "-s";
                a[n++] = "-m"; a[n++] = "64M";
                if (strcmp(record, "triad") == 0 || strcmp(record, "joint") == 0)
                {
                    a[n++] = "-e"; a[n++] = "ibs_op/cnt_ctl=1,period=400003/";
                    a[n++] = "-e"; a[n++] = "ibs_fetch/period=1000003/";
                    a[n++] = "-d"; a[n++] = "-W"; a[n++] = "-R"; a[n++] = "--sample-cpu";
                }
            }
            else if (strcmp(record, "lbr") == 0)
            {
                a[n++] = "-e"; a[n++] = "cycles:u"; a[n++] = "-c"; a[n++] = "1000003";
                a[n++] = "-j"; a[n++] = "any,u";
            }
            else
            {
                a[n++] = "-e"; a[n++] = (char *)record; a[n++] = "-c"; a[n++] = "100003";
                a[n++] = "-d"; a[n++] = "--sample-cpu"; a[n++] = "-W"; a[n++] = "-R";
                a[n++] = "-m"; a[n++] = "16M";
            }
        }
        else
        {
            a[n++] = "stat"; a[n++] = "-j"; a[n++] = "--no-big-num";
            a[n++] = "-o"; a[n++] = json;
            if (events != NULL) { a[n++] = "-e"; a[n++] = (char *)events; }
            if (metric != NULL) { a[n++] = "-M"; a[n++] = (char *)metric; }
        }
        a[n++] = "--";
    }
    a[n++] = self; a[n++] = "bench"; a[n++] = (char *)stage;
    a[n++] = sj; a[n++] = st; a[n++] = sl; a[n++] = ss; a[n++] = sc; a[n++] = (char *)binary; a[n] = NULL;
    char manifest[PATH_MAX]; snprintf(manifest, sizeof(manifest), "%s/manifest.tsv", out);
    FILE *f = fopen(manifest, "a");
    if (f == NULL) return 2;
    fprintf(f, "%s\t%s\t%d\t%d\t%d\t%d\t%d\t%s\t%s\t%s\t%s\n", full, stage, jobs, tasks, lanes, scalar, timing, events ? events : "", metric ? metric : "", record ? record : "", binary);
    fclose(f);
    fflush(stdout);
    pid_t pid = fork();
    if (pid == 0)
    {
        int fd = open(log, O_CREAT | O_TRUNC | O_WRONLY, 0644);
        int wd = open(work, O_CREAT | O_TRUNC | O_WRONLY, 0644);
        if (fd < 0 || wd < 0) _exit(125);
        dup2(fd, 2); dup2(wd, 1); close(fd); close(wd);
        setenv("BENCH_LABEL", full, 1);
        setenv("EXCLUSIVE_OWNER", "codex-microarch", 1);
        setenv("EXCLUSIVE_TITLE", "Buster all-core 1 GB/s microarchitecture investigation", 1);
        setenv("EXCLUSIVE_LINK", "codex://threads/01a17f1c-d48d-75d3-a93c-b8c53419636a", 1);
        setenv("CORES_TITLE", "Buster microarchitecture investigation", 1);
        setenv("CORES_LINK", "codex://threads/01a17f1c-d48d-75d3-a93c-b8c53419636a", 1);
        setenv("LC_ALL", "C", 1); unsetenv("CPATH"); unsetenv("C_INCLUDE_PATH");
        execvp(a[0], a); _exit(127);
    }
    int status;
    while (waitpid(pid, &status, 0) < 0 && errno == EINTR) { }
    int result = WIFEXITED(status) ? WEXITSTATUS(status) : 128 + WTERMSIG(status);
    printf("%s\t%d\n", full, result);
    fflush(stdout);
    return result;
}

static void campaign(const char *mode)
{
    const char *primary = "./compiler-native";
    const char *basic = "{cycles:u,instructions:u,branches:u,branch-misses:u},task-clock,context-switches,cpu-migrations,page-faults,major-faults";
    if (strcmp(mode, "throughput") == 0)
    {
        int jobs[] = {1, 2, 4, 8, 15};
        for (int r = 0; r < 7; ++r)
            for (int j = 0; j < 5; ++j)
            {
                int k = jobs[(j + r) % 5];
                run("throughput", "compile", k, k * 8, 1, 0, 0, basic, NULL, NULL, primary);
            }
        for (int r = 0; r < 5; ++r)
            for (int l = 1; l <= 8; l *= 2)
                run("single-tu-lanes", "compile", 1, 1, l, 0, 0, basic, NULL, NULL, primary);
    }
    else if (strcmp(mode, "phases") == 0)
    {
        const char *stages[] = {"pp", "parse", "check", "compile"};
        for (int r = 0; r < 3; ++r)
            for (int j = 0; j < 2; ++j)
                for (int s = 0; s < 4; ++s)
                    run("phase", stages[(s+r)%4], j ? 8 : 1, j ? 32 : 4, 1, 0, 0, basic, NULL, NULL, primary);
        for (int r = 0; r < 7; ++r)
        {
            run("stages", "compile", 1, 1, 1, 0, 1, NULL, NULL, NULL, primary);
            run("stages-allcore", "compile", 8, 8, 1, 0, 1, NULL, NULL, NULL, primary);
        }
        for (int r = 0; r < 3; ++r)
        {
            run("scalar", "compile", 1, 2, 1, 1, 0, basic, NULL, NULL, primary);
            run("scalar-allcore", "compile", 8, 16, 1, 1, 0, basic, NULL, NULL, primary);
        }
    }
    else if (strcmp(mode, "joint") == 0)
    {
        run_id = 9100;
        run("combined-readable", "compile", 8, 64, 1, 0, 0, NULL, NULL, "joint", primary);
    }
    else if (strcmp(mode, "quality") == 0)
    {
        run_id = 9000;
        run("combined-lowrate", "compile", 8, 64, 1, 0, 0, NULL, NULL, "triad", primary);
        run("ibs-ops-standalone", "compile", 8, 32, 1, 0, 0, NULL, NULL, "ibs_op/cnt_ctl=1/", primary);
    }
    else if (strcmp(mode, "triad") == 0)
    {
        run_id = 8000;
        run("triad", "compile", 8, 64, 1, 0, 0, NULL, NULL, "triad", primary);
        run("ibs-cycles", "compile", 8, 32, 1, 0, 0, NULL, NULL, "ibs_op/cnt_ctl=0/", primary);
        run("branches", "compile", 8, 32, 1, 0, 0, NULL, NULL, "lbr", primary);
    }
    else if (strcmp(mode, "sweep") == 0 || strcmp(mode, "metrics") == 0)
    {
        FILE *f = fopen(strcmp(mode, "sweep") == 0 ? "events.txt" : "metrics.txt", "r");
        if (f == NULL) { perror("catalog"); exit(2); }
        char line[1024];
        while (fgets(line, sizeof(line), f) != NULL)
        {
            line[strcspn(line, "\r\n")] = 0;
            if (line[0] == 0) continue;
            if (strcmp(mode, "metrics") == 0)
                run("metric", "compile", 8, 8, 1, 0, 0, NULL, line, NULL, primary);
            else
            {
                char events[1600];
                snprintf(events, sizeof(events), "{cycles:u,instructions:u,%s:u}", line);
                run("event", "compile", 8, 8, 1, 0, 0, events, NULL, NULL, primary);
            }
        }
        fclose(f);
    }
    else if (strcmp(mode, "samples") == 0 || strcmp(mode, "samples2") == 0)
    {
        if (strcmp(mode, "samples2") == 0) run_id = 7000;
        run("cycles-allcore", "compile", 8, 64, 1, 0, 0, NULL, NULL, "cycles", primary);
        run("cycles-single", "compile", 1, 16, 1, 0, 0, NULL, NULL, "cycles", primary);
        run("cycles-stacks", "compile", 8, 32, 1, 0, 0, NULL, NULL, "cycles-stack", primary);
        run("combined", "compile", 8, 32, 1, 0, 0, NULL, NULL, "combined", primary);
        run("ibs-ops-allcore", "compile", 8, 32, 1, 0, 0, NULL, NULL, "ibs_op/cnt_ctl=1/", primary);
        run("ibs-cycles-allcore", "compile", 8, 32, 1, 0, 0, NULL, NULL, "ibs_op/cnt_ctl=0/", primary);
        run("ibs-fetch-allcore", "compile", 8, 32, 1, 0, 0, NULL, NULL, "ibs_fetch//", primary);
        run("branches-allcore", "compile", 8, 32, 1, 0, 0, NULL, NULL, "lbr", primary);
    }
    else if (strcmp(mode, "system") == 0)
    {
        const char *sets[] = {
            "{cycles:k,instructions:k},task-clock,minor-faults,major-faults,context-switches,cpu-migrations",
            "{cycles:u,instructions:u,cache-references:u,cache-misses:u}",
            "msr/aperf/,msr/mperf/,msr/tsc/,msr/irperf/",
            "power/energy-pkg/,power_core/energy-core/",
            "stalled-cycles-frontend,stalled-cycles-backend,alignment-faults,emulation-faults",
            "{cycles:u,instructions:u,ex_ret_ops:u,ex_ret_ucode_ops:u}",
            "{cycles:u,instructions:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,de_no_dispatch_per_slot.backend_stalls:u}",
            "{cycles:u,instructions:u,de_dispatch_stall_cycle_dynamic_tokens_part1.fp_sch_rsrc_stall:u,de_dispatch_stall_cycle_dynamic_tokens_part2.retq:u}"
        };
        for (int r = 0; r < 3; ++r)
            for (int s = 0; s < 8; ++s)
                run("system", "compile", 8, 16, 1, 0, 0, sets[s], NULL, NULL, primary);
    }
    else if (strcmp(mode, "reference") == 0)
    {
        const char *bins[] = {"./compiler-native", "./compiler-common", "/usr/bin/tcc", "/usr/bin/clang"};
        for (int r = 0; r < 3; ++r)
            for (int b = 0; b < 4; ++b)
                run("reference", "compile", 8, 32, 1, 0, 0, basic, NULL, NULL, bins[(b+r)%4]);
    }
}

int main(int argc, char **argv)
{
    ssize_t n = readlink("/proc/self/exe", self, sizeof(self)-1);
    if (n < 0) return 2;
    self[n] = 0;
    if (argc > 1 && strcmp(argv[1], "bench") == 0) return bench(argc, argv);
    if (argc == 3 && strcmp(argv[1], "suite") == 0) return suite(argv[2]);
    if (argc == 4 && strcmp(argv[1], "counter-suite") == 0) return counter_suite(atoi(argv[2]),atoi(argv[3]));
    if (argc == 4 && strcmp(argv[1], "metric-suite") == 0) return metric_suite(atoi(argv[2]),atoi(argv[3]));
    if (argc != 5) { fprintf(stderr, "usage: microarch ROOT local|9700x OUTPUT MODE\n"); return 2; }
    if (chdir(argv[1]) != 0) { perror(argv[1]); return 2; }
    host = argv[2]; out = argv[3];
    make_dir(out);
    const char *mode = argv[4];
    // Each mode has its own run numbering, allowing disjoint resumable manifests.
    const char *modes[] = {"throughput", "phases", "sweep", "metrics", "samples", "system", "reference"};
    for (int i = 0; i < 7; ++i) if (strcmp(mode, modes[i]) == 0) run_id = i * 1000;
    campaign(mode);
    return 0;
}
