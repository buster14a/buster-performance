#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and THIRD_PARTY_NOTICES.md.
"""Apply test-only compile-time seams to isolated source copies, never the shared worktree."""
from pathlib import Path
root = Path(__file__).resolve().parent
p = root/'runner.c'; s = p.read_text()
for name, value in [('BUSTER_SAMPLE_SECONDS', '1u'), ('BUSTER_HOLD_SECONDS', '3u'), ('BUSTER_HOLD_GRACE_SECONDS', '1u'), ('BUSTER_REAP_SECONDS', '1u'), ('BUSTER_LOCK_SECONDS', '8u')]:
    import re
    pattern = rf'(?m)^(#define {name} .*)$'
    s, n = re.subn(pattern, rf'#ifdef WAIT_OBSERVE_E2E_TEST\n#define {name} {value}\n#else\n\1\n#endif', s); assert n == 1
p.write_text(s)
p = root/'wait-observe.c'; s = p.read_text(); marker = '#undef main\n'; hook = r'''
#ifdef WAIT_OBSERVE_E2E_TEST
/* Compile-time-only test hooks: not available in production builds. */
static bool e2e_held_lock(void)
{
    const char* held = getenv("BUSTER_9700X_HELD");
    const char* lock = getenv("WAIT_E2E_LOCK_PATH");
    struct stat a, b;
    return held && strcmp(held, "1") == 0 && lock && fstat(9, &a) == 0 && stat(lock, &b) == 0 &&
           S_ISREG(a.st_mode) && a.st_dev == b.st_dev && a.st_ino == b.st_ino && flock(9, LOCK_EX | LOCK_NB) == 0;
}
static bool e2e_host_receipt(const char* directory, const char* suffix)
{
    char name[64], path[PATH_MAX];
    snprintf(name, sizeof(name), "host.%s.txt", suffix);
    bool valid = path_join(path, sizeof(path), directory, name) && write_text(path, "synthetic host\n");
    snprintf(name, sizeof(name), "host-policy.%s.txt", suffix);
    return valid && path_join(path, sizeof(path), directory, name) && write_text(path, "synthetic policy\n");
}
#define held_lock e2e_held_lock
#define host_receipt e2e_host_receipt
#endif
'''; assert marker in s; s=s.replace(marker,marker+hook,1)
needle='''    const Configuration* c = &options->run;
    const char* changed = " M src/buster/compiler/lane.c\\n M src/buster/compiler/lane_test.c\\n";'''
replacement=r'''    const Configuration* c = &options->run;
#ifdef WAIT_OBSERVE_E2E_TEST
    const char* manifest = getenv("WAIT_E2E_IDENTITIES");
    char ignored[32], path[PATH_MAX], fixture_buffer[65536];
    char* verify[] = { "sha256sum", "--check", "--strict", "--status", (char*)manifest, NULL };
    char* capture_hashes[] = { "sha256sum", "--", (char*)c->compiler, (char*)options->diagnostic_binary, (char*)options->validator, NULL };
    bool fixture = manifest && capture(verify, ignored, sizeof(ignored)) && capture(capture_hashes, fixture_buffer, sizeof(fixture_buffer));
    const char* names[] = { "applied.diff", "control.identity", "diagnostic.identity" };
    for (size_t i = 0; fixture && i < 3; i += 1)
        fixture = path_join(path, sizeof(path), out, names[i]) && write_text(path, i == 0 ? "synthetic diff\n" : fixture_buffer);
    return fixture;
#endif
    const char* changed = " M src/buster/compiler/lane.c\n M src/buster/compiler/lane_test.c\n";''';assert needle in s;s=s.replace(needle,replacement,1)
s=s.replace('char* owner = valid ? read_text("/var/lib/buster-9700x/owner", &owner_length) : NULL;', '''#ifdef WAIT_OBSERVE_E2E_TEST
    const char* owner_path = getenv("WAIT_E2E_OWNER_PATH");
#else
    const char* owner_path = "/var/lib/buster-9700x/owner";
#endif
    char* owner = valid && owner_path ? read_text(owner_path, &owner_length) : NULL;''')
s=s.replace('''    CPU_ZERO(&mask);
    for (unsigned cpu = 0; cpu < BUSTER_LANES; cpu += 1) CPU_SET(cpu, &mask);
    Process process''', '''    CPU_ZERO(&mask);
#ifdef WAIT_OBSERVE_E2E_TEST
    valid = valid && sched_getaffinity(0, sizeof(mask), &mask) == 0;
#else
    for (unsigned cpu = 0; cpu < BUSTER_LANES; cpu += 1) CPU_SET(cpu, &mask);
#endif
    Process process''')
p.write_text(s)
