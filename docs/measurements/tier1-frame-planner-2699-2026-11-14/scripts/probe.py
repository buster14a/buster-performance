import sys
p=sys.argv[1]+'/src/buster/compiler/tier1_frame.c'
s=open(p).read()
a='''static Tier1FrameError tier1_frame_plan_path(const Tier1FrameRequest* request, Arena* output, Arena* scratch, bool scalar, Tier1Frame* result)
{
    (void)scalar;
'''
assert a in s
s=s.replace(a,'''static uint64_t tier1_frame_probe_ticks;
static uint64_t tier1_frame_probe_calls;
static uint64_t tier1_frame_probe_objects;
static int tier1_frame_probe_on = -1;
static Tier1FrameError tier1_frame_plan_path_probed(const Tier1FrameRequest* request, Arena* output, Arena* scratch, bool scalar, Tier1Frame* result);
static Tier1FrameError tier1_frame_plan_path(const Tier1FrameRequest* request, Arena* output, Arena* scratch, bool scalar, Tier1Frame* result)
{
    const uint64_t before = __rdtsc();
    const Tier1FrameError error = tier1_frame_plan_path_probed(request, output, scratch, scalar, result);
    tier1_frame_probe_ticks += __rdtsc() - before;
    tier1_frame_probe_calls += 1;
    tier1_frame_probe_objects += request->slots.count;
    if (tier1_frame_probe_on < 0)
    {
        tier1_frame_probe_on = getenv("BUSTER_FRAME_PROBE") != 0;
    }
    if (tier1_frame_probe_on > 0)
    {
        fprintf(stderr, "FRAMEPROBE ticks=%llu calls=%llu objects=%llu\\n", (unsigned long long)tier1_frame_probe_ticks,
            (unsigned long long)tier1_frame_probe_calls, (unsigned long long)tier1_frame_probe_objects);
    }
    return error;
}
static Tier1FrameError tier1_frame_plan_path_probed(const Tier1FrameRequest* request, Arena* output, Arena* scratch, bool scalar, Tier1Frame* result)
{
    (void)scalar;
''',1)
open(p,'w').write(s)
