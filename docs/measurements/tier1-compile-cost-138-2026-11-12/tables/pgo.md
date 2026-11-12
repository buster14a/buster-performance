| corpus | compile | runs | plain, wall ms | profile-guided | change | plain, user cycles, M | profile-guided | change | objects |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| sqlite | `--tier1` | 7 | 426.4 | 403.5 | -5.4% | 2,258.9 | 2,133.7 | -5.5% | objects agree |
| sqlite | default | 7 | 124.3 | 117.8 | -5.2% | 599.5 | 566.7 | -5.5% | objects agree |
| lua | `--tier1` | 7 | 167.0 | 154.6 | -7.4% | 827.9 | 760.3 | -8.2% | objects agree |
| lua | default | 7 | 91.7 | 82.3 | -10.2% | 439.7 | 388.5 | -11.7% | objects agree |
| musl | `--tier1` | 5 | 1351.6 | 1187.9 | -12.1% | 6,207.4 | 5,335.5 | -14.0% | objects agree |
| musl | default | 5 | 1053.3 | 916.3 | -13.0% | 4,750.1 | 4,022.4 | -15.3% | objects agree |
