# Copy, format and manifest scope

Let Q be the original local input root:
`/home/david/Documents/Codex/2026-10-30/tak/work/ci-msan-caef`.
Native file copying/comparison preserves all 138 included raw files. Every
`cmp` is zero in `raw-copy-verification.tsv`; `raw-files.sha256` binds the
portable relative paths. All producer manifests are copied unchanged.

| Original manifest | Entries | Required original CWD | Included/omitted boundary |
| --- | ---: | --- | --- |
| `reproduction-v1/RAW-SHA256SUMS` | 36 | `Q/reproduction-v1` | 34 named files included; compiled probe and mixed macro dump omitted |
| `reproduction-v2/RAW-SHA256SUMS` | 57 | `Q/reproduction-v2` | 56 named files included; compiled probe omitted |
| `varargs-shadow-diagnostic/qualified-v2/frozen-record/METADATA-SHA256SUMS` | 16 | `Q/varargs-shadow-diagnostic/qualified-v2/frozen-record` | All metadata members plus this manifest included |
| `varargs-shadow-diagnostic/qualified-v2/frozen-record/IR-PAYLOAD-SHA256SUMS` | 1 | `Q/varargs-shadow-diagnostic/qualified-v2`, the parent of frozen-record | Full IR omitted; exact digest/context retained |

All original checks above pass in their owning CWDs. Source/toolchain and
binary identity files may use their original checkouts or absolute paths and
omitted payloads. They are not portable checks over this archive. Run
`sha256sum -c package.sha256` from this measurement directory for all included
regular package files.

Native `unzip -Z -1` retains the exact 22-member artifact list. Native
`unzip -p MEMBER | cmp` checked all 21 included members against their extracted
originals without running the probe. The empty first log download and original
escaped raw log remain separate files; no terminal rendering or normalization
of the raw log was used.

Both raw Clang compile streams are comma-separated `-MJ` fragments, not valid
standalone JSON arrays. Existing native inspection makes readable copies only:

```sh
sed 's/,[[:space:]]*$//' RAW_MJ_STREAM | jq -s .
rg '^#define BUSTER_HOST_VECTOR ' ORIGINAL_MACRO_DUMP
```

Each normalized stream has 41 entries; the original byte streams remain exact.
The selected vector predicate is first-party Buster output, not a full system/
LLVM macro dump. Frozen IR contexts/notes were copied only after their final
metadata pin was supplied; no live output or optional stand-in was included.
The initial copy inherited the frozen directory's read-only mode and stopped;
only the new packet directory was made writable, then copies were completed
and compared. Original frozen files and modes were never changed. This is a
curation event, not a compiler/control attempt.

New prose and C/source contexts receive normal whitespace checks. Any exception
for raw log/license/report/table bytes is exact-path and additive. No new
functional helper, build, test, archived program, SSH/host operation, producer,
benchmark or campaign was executed for curation. Existing records remain intact.
