# patch_faults.py TREE: #490's diagnostic only: page-fault marks around the C driver's link steps (runtime_open, the
# runtime's room, bind_begin, bind_end, dynamic_inputs, executable_write), printed to standard error when BUSTER_FAULTS
# is set, as the process's minor faults so far (getrusage), by wrappers of the calls.
import re, sys
tree = sys.argv[1]
mark = '''
#include <sys/resource.h>
static void {name}(const char* label)
{{
    if (getenv("BUSTER_FAULTS") != 0)
    {{
        struct rusage usage;
        getrusage(RUSAGE_SELF, &usage);
        fprintf(stderr, "faults %s %ld\\n", label, usage.ru_minflt);
    }}
}}
'''
def patch(path, edits, helper):
    s = open(path).read()
    for old, new in edits:
        assert s.count(old) == 1, (path, old)
        s = s.replace(old, new)
    # The helpers at the file's start, which main.c includes after the C library's headers.
    s = helper + s
    open(path, 'w').write(s)

emit = tree + '/src/buster/compiler/c_check_program_emit.c'
s = open(emit).read()
capacity = 'bind_capacity_needed(binding->runtime, externals, external_count, scratch, &name_bytes, &atom_bytes)' if 'bind_capacity_needed(binding->runtime' in s else 'bind_capacity(binding->runtime, &name_bytes, &atom_bytes)'
wrapper_args = '(binding->runtime, externals, external_count, scratch, &name_bytes, &atom_bytes)' if 'needed' in capacity else '(binding->runtime, &name_bytes, &atom_bytes)'
helper = mark.format(name='emit_faults_mark') + '''
#define EMIT_FAULTS_CALL(label, expression) (emit_faults_mark("before " label), emit_faults_value(label, (expression)))
'''
# Wrap with a statement expression: the value, then the mark.
patch(emit, [
    (capacity, '({ emit_faults_mark("before room"); const LinkCapacity room_value = ' + capacity + '; emit_faults_mark("room"); room_value; })'),
    ('!bind_begin(binding->bind, &result->link, binding->runtime, binding->path, bytes, 1, binding->arena)',
     '!({ emit_faults_mark("before bind_begin"); const bool begun_value = bind_begin(binding->bind, &result->link, binding->runtime, binding->path, bytes, 1, binding->arena); emit_faults_mark("bind_begin"); begun_value; })'),
], mark.format(name='emit_faults_mark'))
driver = tree + '/src/buster/compiler/c_checker_driver.c'
patch(driver, [
    ('const SnapshotResult opened = runtime_open(&runtime, cached ? cache : NULL);',
     'driver_faults_mark("before runtime_open"); const SnapshotResult opened = runtime_open(&runtime, cached ? cache : NULL); driver_faults_mark("runtime_open");'),
    ('valid = bind_end(&bind, &code.link);', 'driver_faults_mark("before bind_end"); valid = bind_end(&bind, &code.link); driver_faults_mark("bind_end");'),
    ('valid = checked == LINK_ERROR_NONE && dynamic_inputs(&dynamic, &runtime, &bind, &arena);',
     'driver_faults_mark("before dynamic_inputs"); valid = checked == LINK_ERROR_NONE && dynamic_inputs(&dynamic, &runtime, &bind, &arena); driver_faults_mark("dynamic_inputs");'),
    ('write->succeeded = executable_write(write->link, &write->options, &write->result);',
     'driver_faults_mark("before executable_write"); write->succeeded = executable_write(write->link, &write->options, &write->result); driver_faults_mark("executable_write");'),
], mark.format(name='driver_faults_mark'))
print('patched', tree, 'with', capacity.split('(')[0])
