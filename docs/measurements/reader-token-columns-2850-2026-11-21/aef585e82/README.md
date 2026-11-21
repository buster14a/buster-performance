# Combined ordinary checker change at aef585e82

The parent was 4dd0f0b163d258dd7778cbb14676a7ac4bf3510a. The candidate was aef585e82d341ef4269f642cda891501ee204f8f. The normal checker shares the query slot at each return keyword and allocates the function-body specifier column only in translation units that use the pretty function name. SQLite avoids two arrays of 2,864,548 bytes each.

A locked Ryzen 7 9700X on CPU 2 compiled frozen SQLite (9,507,037 bytes, 716,136 tokens). Fresh ordinary object compilations used seven interleaved ABBA/BAAB rounds. PMU and wall campaigns were separate. Every one of the 140 recorded objects had SHA-256 efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa. Each paired round averages two measurements per binary, then subtracts the parent from the candidate.

| Measurement | Parent median | Candidate median | Median paired change | Paired range |
| --- | ---: | ---: | ---: | ---: |
| Ordinary wall, default page policy (ms) | 121.1865 | 120.0840 | −1.1895 | −2.0810 to +2.2645 |
| Ordinary wall, huge pages allowed (ms) | 121.0290 | 120.2545 | −0.6850 | −1.2075 to −0.4100 |
| User + kernel cycles/token, huge pages allowed | 932.7263 | 925.5432 | −7.0422 | −11.1335 to −4.8139 |
| User + kernel cycles/token, base pages | 1106.5181 | 1093.1724 | −13.4914 | −22.4627 to +39.7203 |
| Minor faults, base pages (PMU) | 59949.5 | 58384.0 | −1566.0 | −1567.0 to −1464.5 |

The default-wall candidate won six of seven rounds, and the huge-page candidate won all seven in both campaigns. At the default-policy median the candidate processed 79.17 MB/s. The base-page peak fell by 5,182 KiB. The huge-page peak was essentially unchanged. All eight checker partitions passed with 845,265 checks. The 243 return comparisons, 210 pretty-name comparisons and 2,742 corpus comparisons (default and −Wall −Wextra) had identical status, diagnostics and object bytes wherever an object was expected. These include the case where the pretty name is the only candidate spelling in a SIMD group. During development the prefilter lost that spelling, and then the synthetic scalar census omitted its new presence bit. Both failures were corrected before recording this revision.

The archive contains the original perf and time-runs observations with object digest lists. The table files include all measured columns, including faults and paired ranges. Scripts and the exact source change are alongside. Reproduction uses the corpora, build helper and fixture generators in the parent directory.
