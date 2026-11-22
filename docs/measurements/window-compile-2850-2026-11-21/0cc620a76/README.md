# Batched arithmetic in the function-local checker

Buster `0cc620a76e482e30d9f3396e4121ed5f34b74317` extends the existing source-local checker `4bd73ecaf27519017ab6d710a3d7c0d4d49071aa`. In a block of 16 validated graph nodes it can first materialize permanent integer leaves, then use vector gathers to check independent unknown arithmetic or comparisons whose operands have the same ordinary integer type. It writes checked types, flags, operand conversions and the other scalar result fields. The production scalar action checks every other node in source order. [Source patch](implementation.patch)

The source/checked-output oracle has 0 recorded differences. Each source scope compares the candidate, checked on the function-local graph, against both the ordinary whole graph and the preceding source-local implementation, including earlier independent archived fingerprints for both frozen inputs. The directed fixtures cover type conversions, integer faults, sequencing, volatile and atomic accesses, floating environments and ineligible operands. [Per-input cases](oracle/comparisons.tsv), [differences](oracle/failures.json) and [raw source and output](oracle/raw.tar.gz).

| Input | Scope | Nodes | Checked actions taken | Paired stage wall change | Paired user instructions |
| --- | --- | ---: | ---: | ---: | ---: |
| sqlite | functions | 319,280 | 4,571 | -0.402 ms (3/5 faster) | -4,724,598 |
| sqlite | declarations | 323,623 | 4,571 | +2.158 ms (1/5 faster) | -4,426,775 |
| buster | functions | 586,965 | 2,761 | +1.399 ms (2/5 faster) | -2,655,983 |
| buster | declarations | 1,407,416 | 2,761 | +12.794 ms (1/5 faster) | -343,306 |

The matched local 7940HS Develop stage starts a fresh process, preprocesses, parses and checks the selected source range. Both modes stop at the same reader boundary before normal source finalizers and native output. The wall series uses five alternating ABBA/BAAB rounds per workload and scope. Three separate rounds per workload and scope record user-mode instructions and cycles. The instrumented stage breakdown uses a fenced x86 timestamp counter around the existing checker boundaries. It includes workspace and validation, discovery of constant contexts, allocation and initialization of the result stream, action dispatch and the completion passes. Output and scratch byte counts report arena charges. [Per-mode coverage](stage/coverage.tsv), [individual operator counts](stage/operators.tsv), [stage breakdown](stage/check-cost.tsv), [paired measurements](stage/paired.tsv), [samples](stage/samples.tsv) and [raw reports](stage/raw.tar.gz).
