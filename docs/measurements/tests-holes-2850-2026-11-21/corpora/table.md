sqlite: orders left out: before None, after 76
sqlite: own objects: before None, after 0
sqlite: pragma-labelled: before None, after 0
sqlite -Wall -Wextra: orders left out: before None, after 0
sqlite -Wall -Wextra: own objects: before None, after 0
sqlite -Wall -Wextra: pragma-labelled: before None, after 0
lua: orders left out: before None, after 36
lua: own objects: before None, after 0
lua: pragma-labelled: before None, after 0
lua -Wall -Wextra: orders left out: before None, after 0
lua -Wall -Wextra: own objects: before None, after 0
lua -Wall -Wextra: pragma-labelled: before None, after 0
musl: nothing listed: before 28847, after 28839
musl: orders left out: before None, after 47
musl: own objects: before None, after 0
musl: pragma-labelled: before None, after 0
musl -Wall -Wextra: nothing listed: before 18279, after 18278
musl -Wall -Wextra: orders left out: before None, after 0
musl -Wall -Wextra: own objects: before None, after 0
musl -Wall -Wextra: pragma-labelled: before None, after 0
main: orders left out: before None, after 32
main: own objects: before None, after 0
main: pragma-labelled: before None, after 0
main -Wall -Wextra: orders left out: before None, after 0
main -Wall -Wextra: own objects: before None, after 0
main -Wall -Wextra: pragma-labelled: before None, after 0
counts that differ: 26
| | sqlite | sqlite -Wall -Wextra | lua | lua -Wall -Wextra | musl | musl -Wall -Wextra | main | main -Wall -Wextra |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| T taken | 50,996 | 50,996 | 10,839 | 10,839 | 43,415 | 43,415 | 52,163 | 52,163 |
| T expressions | 51,137 | 51,137 | 10,889 | 10,889 | 43,830 | 43,830 | 53,105 | 53,105 |
| T refused callee | 133 | 133 | 50 | 50 | 124 | 124 | 890 | 890 |
| T refused leaf | - | - | - | - | 40 | 40 | - | - |
| tests taken there | 50,158 | 46,949 | 10,158 | 9,640 | 40,770 | 38,836 | 39,756 | 34,398 |
| tests refused | 560 | 3,771 | 302 | 822 | 435 | 2,397 | 8,321 | 13,692 |
| C decided | 50,112 | 50,112 | 10,715 | 10,715 | 42,776 | 42,776 | 45,074 | 45,074 |
| C refused | 178 | 178 | 438 | 438 | 2,099 | 2,099 | 1,460 | 1,460 |
| rows taken | 49,842 | 49,842 | 10,246 | 10,246 | 40,441 | 40,441 | 41,890 | 41,890 |
| rows entries | 315,485 | 315,485 | 64,738 | 64,738 | 204,112 | 204,112 | 301,625 | 301,625 |
| kernel made | 247,906 | 247,906 | 62,855 | 62,855 | 191,502 | 191,502 | 311,487 | 311,487 |
| kernel left | 2,919 | 2,919 | 2,110 | 2,110 | 6,836 | 6,836 | 8,892 | 8,892 |
| lines made again | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| summaries kept | 49,842 | 49,842 | 10,246 | 10,246 | 40,441 | 40,441 | 41,890 | 41,890 |
| nothing listed | 41,456 | 21,516 | 6,907 | 4,025 | 28,839 | 18,278 | 25,812 | 12,355 |
| orders left out | 76 | 0 | 36 | 0 | 47 | 0 | 32 | 0 |
| own objects | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| pragma-labelled | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| objects | 4,864 | 4,864 | 13,220 | 13,220 | 255,903 | 255,903 | 10,278 | 10,278 |
| library calls | 332 | 332 | 53 | 53 | 0 | 0 | 1,168 | 1,168 |
