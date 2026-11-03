# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# gdb script: log each mmap (length, prot, call stack, result) and the process's smaps at exit_group.
import gdb, os
gdb.execute("set pagination off")
gdb.execute("set confirm off")
out = open(os.environ["MMAP_LOG"], "w")

class FinishMmap(gdb.FinishBreakpoint):
    def __init__(self, frame, info):
        super().__init__(frame, internal=True)
        self.info = info
    def stop(self):
        out.write("MMAP %x %s\n" % (int(gdb.parse_and_eval("$rax")) & 0xffffffffffffffff, self.info))
        return False
    def out_of_scope(self):
        pass

class MmapBreak(gdb.Breakpoint):
    def stop(self):
        f = gdb.newest_frame()
        length = int(gdb.parse_and_eval("$rsi"))
        prot = int(gdb.parse_and_eval("$rdx"))
        frames = []
        fr = f.older()
        while fr is not None and len(frames) < 8:
            sal = fr.find_sal()
            name = fr.name() or "?"
            file = sal.symtab.filename.split("/")[-1] if sal.symtab else "?"
            frames.append("%s@%s:%d" % (name, file, sal.line))
            fr = fr.older()
        FinishMmap(f, "len=%d prot=%d %s" % (length, prot, " <- ".join(frames)))
        return False

class ExitCatch(gdb.Breakpoint):
    def stop(self):
        pid = gdb.selected_inferior().pid
        status = open("/proc/%d/status" % pid).read()
        out.write("STATUS " + " ".join(l.replace("\t", " ") for l in status.splitlines() if l.startswith(("VmPTE", "VmRSS", "RssAnon"))) + "\n")
        out.write("SMAPS\n")
        out.write(open("/proc/%d/smaps" % pid).read())
        out.flush()
        return False

MmapBreak("mmap")
ExitCatch("_exit")
gdb.execute("run")
