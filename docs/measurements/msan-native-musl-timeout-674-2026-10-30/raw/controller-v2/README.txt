Private C-controller revision: PREPARED ONLY; no compilation or execution.

Purpose and immutable inputs

This revision replaces only the diagnostic orchestration. It does not edit
the old diagnostic-controller.sh, diagnostic-supervisor.c, any existing
receipt, source-674, or its approved build output. It reuses exactly:
  source 674ae159503b4b51f2c54865d9cfdd225e9d27a0
  source-674/build/compiler SHA256
    d8ae1c8b5eddab82dacc2e2a04279240e7d7151a9e0744ae44769af7b39b3a98
  diagnostic/binary.sha256, relative to the original source cwd
  diagnostic/source-before.sha256 (the approved 803-file source manifest)
  approved official LLVM23.1.4/release7a941, explicit znver3 scalar host build
  the original frozen corpus, eight source directories and selected count613
  the existing build=0/proof=0/driver0 and fatal86 symbolized MSan proof.

The corpus command itself has the exact original argv: ./build/compiler
test-checker-corpus --clang clang --symbols-minimum354 (separate argv values),
output target x86_64-linux-gnu/-march=znver5, original seven include paths and
eight directories. No limit, report, filter, retry, source patch, diagnostic
compiler rebuild or additional corpus invocation is introduced.

Files and review boundary

diagnostic-controller.c owns preparation, containment, observation, deadlines,
status interpretation, hashing/cache receipts, unconditional report audit and
finalization. ci-configure-exec.sh contains only the unchanged CI configure,
source-env and exec glue needed to apply tools/ci/sanitizers.sh's environment.
The small Bash glue executes inside the single supervised command process,
then execs ./build/compiler with the C-held argv. The 240s command deadline
includes this configure step. SOURCE_DATE_EPOCH1792454400 is applied only to
that runtime child, and is unset for preparation/postchecks.

Only run mode consumes diagnostic/run.started with O_EXCL/O_NOFOLLOW, before
prechecks. This is the retired controller's same shared guard; there is one
attempt across revisions. All other new receipts/cache/tmp/reports go under
controller-v2/run, which must not already exist. Failed prechecks consume the
guard; they do not silently permit another experiment.

The controller sets the fixed private environment in C, clears inherited
compiler overrides and shell startup hooks, and creates a fresh private cache
with BUSTER_ORACLE_CACHE=check. C-written pinned-manifest checks protect the
source/TC/corpus manifests themselves, the source archive, sanitizer audit
script, official Clang/symbolizer/license and both MSan runtime archives.
Existing source and binary manifests are checked before and after. The full
toolchain manifest is also checked before and after. Actual controller source,
executable, glue, fixture, old controls, build records, compile arguments,
source/tool/corpus receipts and system command hashes are retained in before
and after identity manifests; these manifests must compare byte-for-byte.

Containment and observations

The reviewed supervisor's WNOWAIT/subreaper/PDEATHSIG protocol is preserved.
An exiting command stays a zombie until killing its process group; repeated
own-direct-child enumeration/kill/reap handles descendants that changed
process group or session. ECHILD must be proved before the report audit and
again at finalization. Every helper command receives the same containment
protocol and a bounded deadline. Incomplete cleanup is fatal; any audit after
incomplete cleanup is explicitly provisional, regardless of report emptiness.

The corpus command is sampled every5s by bounded /proc reads of the owned
command and at most64 of its direct children, plus bounded fd listings. No
global process search, child tracer or recursive observer is used. Open proc
directory handles keep observations attached to the selected process identity.
At180s, only if that command is still the exact compiler executable, an
available /usr/bin/gdb may take one parent-only batch stack sample. It does not
follow forks; its log preserves attach refusal/denial text and actual status.
The debugger is killed after8s and contained/reaped with the command tree.
No ptrace/kernel/permission settings change. Any sample perturbs execution,
so these receipts establish no benchmark result or uninstrumented runtime.

Finalization and limitations

The original command result, raw waitid code/status, timeout and controller
signal are held separately from helper/postcheck results. After the command's
cleanup (or a refused prelaunch), the exact source Bash sanitizer audit is
attempted unconditionally, followed by source/binary/tool identity checks and
a bounded sorted private-cache SHA receipt. Postcheck failures do not erase
the original result. A status file is opened and held before these operations,
and final fields are emitted even if a postcheck, observer or cache operation
fails. Event-stream delivery is checked before the final status is written;
failed exec records its launch stage and errno before exit127, contrasted by
the normally executed exit127 fixture. I/O/early output-directory failures can prevent durable receipts and
are fatal; a missing final receipt can never be accepted as a pass.

Final status0 requires original command0 and every gate, including ECHILD.
With clean containment, the original nonzero/timeout is also the controller's
exit status; postcheck failures are retained separately and cannot erase it.
Incomplete cleanup/clock/setup failure returns125 while retaining the original
result in the receipt. Only this bounded local diagnostic is in
scope. It is not an identical hosted-native reproduction, full sanitizer
qualification, proof of finite progress, diagnosis of the original timeout,
performance evidence or permission to start another corpus invocation.

Future review/build/use (not performed by the author)

Independent actual-code review must clear these exact files before a normal
uninstrumented C17 -O2 -Wall -Wextra -Werror build of this private controller
and fixture, using the verified official compiler. Preserve argv/log/status
and source/binary hashes. Run the tiny fresh-directory controls described in
CONTROL-PLAN.txt under cores1. The controller executable must reside at the
reviewed task path and its actual hash must be retained by the owner.

Only the coordinating owner may then authorize its single `controller run`
invocation under the existing cores1 grant and an outer deadline long enough
for the 240s command, cleanup, audit and bounded identity checks. No top-level
Bash loop or alternative source/build path is needed. No command was run to
produce this revision except read-only preparation/hash inspection.
