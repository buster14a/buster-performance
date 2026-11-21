from pathlib import Path
p=Path(__file__).resolve().parent
source=p.parent/'step0-lanes/tools/qualproducedrepair.c'
s=source.read_text();loc='    uint64_t taken_nodes = 0;'; assert s.count(loc)==1
s=s.replace(loc,'''    FILE* root_map = fopen(getenv("BUSTER_ROOT_MAP"), "w");
    if (root_map == NULL) return 2;
    for (uint32_t r = 0; r < unit.root_count; ++r)
    {
        fprintf(root_map, "%u\\t%u\\t%u\\t%u\\n", r, unit.roots[r] - unit.root_first[r] + 1,
                first_taken[r] != 0, unit.root_taken[r] != 0);
    }
    if (fclose(root_map) != 0) return 2;
''' + loc)
(p/'export-roots.c').write_text(s)
