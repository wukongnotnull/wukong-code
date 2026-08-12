# Product Design / Frontend Design Composition Evaluation — 2026-08-12

## Methodology

Fresh Codex desktop child contexts used `fork_turns: none`, neutral task names,
and no expected answers. Children inspected only the Product Design files needed
to route and could not mutate files or external state. Harness/model version
and identifiers were not exposed. Complete records are [RED](raw/2026-08-12-product-design-frontend-composition/red.md), [GREEN](raw/2026-08-12-product-design-frontend-composition/green.md), and [boundary probes](raw/2026-08-12-product-design-frontend-composition/refactor.md).

## Critical Verdict Contract

Eligible original directions and substantial redesigns must load
`frontend-design` only after the Wukong lifecycle gate and before ideation.
Audits, research-only work, faithful cloning, selected-visual implementation,
QA, and sharing must exclude it. User constraints, supplied sources, design
systems, and selected visuals must outrank its suggestions.

## RED Results

The original skills produced 5/5 omissions for original design, an omission
for research-plus-redesign, and an omission for substantial URL redesign.
Faithful clone controls (5/5), audit, selected-visual implementation, and
research-only controls already excluded `frontend-design`.

## GREEN and REFACTOR Results

The final candidate produced 5/5 inclusion for original direction, inclusion
for research-plus-redesign and substantial URL redesign, and exclusion for all
fidelity/read-only controls. Initial ambiguity probes showed `make better` and
`match but modernize` could be guessed as redesigns. The final explicit
conditional generated the required fidelity question in both final probes.

## Routing Matrix

| Work | Final route |
| --- | --- |
| Original direction or substantial redesign | `frontend-design` before `product-design-ideate` |
| Faithful URL clone or selected visual | Exclude `frontend-design` |
| Audit or research-only | Exclude `frontend-design` |
| `inspired by` | Original-direction branch |
| `make better` / `match but modernize` | Ask one fidelity question before branch selection |

## RED-to-GREEN Failure Mapping

| Observed failure | Final guidance |
| --- | --- |
| Original direction omitted visual guidance | Router inclusion predicate plus Ideate loading recipe |
| Substantial redesign omitted visual guidance | Same inclusion predicate names redesign explicitly |
| Ambiguous URL wording guessed as redesign | Observable phrase conditional and one-question recipe |
| Fidelity controls risked design drift | Explicit exclusion list and authority order |

## Static Validation

| Check | Status |
| --- | --- |
| Product Design integration test | PASS |
| Product Design import-integrity unit test | PASS |
| Product Design integrity checker | PASS |
| Upstream `frontend-design` files | Unchanged by SHA-256 and Git diff |

## Limitations

The behavior samples cover the Codex desktop multi-agent runtime only. They
prove behavior after the named skill files are read, not implicit discovery on
every supported harness. The final ambiguity refinement received one fresh
sample per ambiguous phrase; the primary matched matrix is stronger at five
repetitions for original direction and faithful clone.

## Conclusion

The evidence supports conditional composition: original visual work receives
distinctive visual-design guidance, and source-fidelity/read-only work retains
its existing source of truth.
