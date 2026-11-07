// TEMPORARY inventory instrumentation (#181), never committed.
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
static void buster_inventory_dump(const char* tag, const X86Instruction* records, uint32_t count)
{
    const char* path = getenv("BUSTER_FORM_INVENTORY");
    if (path != 0 && count != 0)
    {
        int fd = open(path, O_WRONLY | O_APPEND | O_CREAT, 0644);
        if (fd >= 0)
        {
            char buffer[3800];
            uint32_t used = 0;
            for (uint32_t i = 0; i < count; i += 1)
            {
                const X86Instruction* r = &records[i];
                used += (uint32_t)snprintf(buffer + used, sizeof(buffer) - used, "%s %u %u %u %u %u %u %u %d %d\n", tag, r->form, r->mode, r->reg, r->rm, r->index, r->vvvv, r->decorations, r->immediate, r->displacement);
                if (used > sizeof(buffer) - 200 || i + 1 == count)
                {
                    ssize_t w = write(fd, buffer, used);
                    (void)w;
                    used = 0;
                }
            }
            close(fd);
        }
    }
}
