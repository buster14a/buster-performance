# Archive scope: exact PR 678 controls

[Attribution report](README.md). Old exact PR
`8af0904bfa103398af64f292d560cfbdc6fdc22d` reproduces retained complex-runtime and
union-cast failures. Latest examined exact PR
`ed1e848e1a57cda5ba410afabb320edecc1a65dc` fixes those reproductions, but its scalar
checker suite has 599 known walk-accounting assertion failures. Driver and lane
suites pass; focused family receipts account for all 599. This is not a passing
full checker or complete combined-branch compatibility claim. No expectation fix
was applied in these pristine controls. [Focused shim audit](../pr-678-audit/README.md)
is separate; final integrated qualification belongs to the parent campaign.
