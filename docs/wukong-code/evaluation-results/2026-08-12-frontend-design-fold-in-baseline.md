# Frontend Design Fold-In — RED Baseline

**Date:** 2026-08-12

**Goal:** Determine which behavior from the standalone `frontend-design` skill
is not already produced by Product Design ideation before moving that guidance
into Product Design and removing the standalone skill.

## Control setup

Three fresh agents received original-direction Product Design requests and were
told to act with `product-design` and `product-design-ideate` available while
`frontend-design` was unavailable. No Product Design or Frontend Design skill
files were changed before the controls ran.

Scenarios:

1. Premium landing-page directions for an independent ceramic studio.
2. Three distinct redesign directions for a generic SaaS analytics dashboard.
3. Three original homepage concepts for a neighborhood jazz club after prior
   AI-generated concepts looked generic.

## Required behavior rubric

The standalone guidance contributes seven observable inputs to original visual
directions:

1. Concrete subject.
2. Intended audience and primary surface job.
3. Deliberate palette, typography, and layout system.
4. One named signature element.
5. One justified aesthetic risk.
6. Realistic, subject-specific content and interface language.
7. A pre-generation critique that identifies and replaces generic AI defaults.

## Baseline results

| Scenario | Subject | Audience / job | Visual system | Signature element | Justified risk | Subject-specific content | Pre-generation critique |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Ceramic studio | Pass | Pass | Pass | **Fail** | **Fail** | Pass | **Fail** |
| SaaS dashboard | Pass | Pass | Pass | **Fail** | **Fail** | Pass | **Fail** |
| Jazz club | Pass | Pass | Pass | **Fail** | **Fail** | Pass | **Fail** |

All controls produced strong palettes, type choices, layouts, image direction,
and realistic copy without `frontend-design`. None exposed a dedicated
signature element, named and justified one intentional aesthetic risk, or
performed an explicit pre-generation critique that replaced a generic default.

## RED verdict

**RED confirmed.** The behavior gap is narrow and consistent. Copying the full
standalone prompt would duplicate behavior already present in Product Design.
The minimal GREEN change should preserve only the missing signature, risk, and
anti-template critique contract, plus concise subject-grounding and interface
copy rules needed to interpret those fields.

## Negative controls to preserve

The fold-in must not apply original-direction guidance to:

- research or evidence-based audits;
- faithful URL clones;
- implementation from an already-selected visual target;
- design QA; or
- sharing and deployment.

## Raw output summary

- Ceramic control produced `Kiln Nocturne`, `Porcelain Silence`, and
  `Earthwork Atelier`, with detailed palette, typography, layout, imagery, and
  copy fields but no signature/risk/critique fields.
- SaaS control produced `Editorial Signal Brief`, `Midnight Investigation Lab`,
  and `Cohort Terrain Explorer`, with detailed visual systems and interaction
  models but no signature/risk/critique fields.
- Jazz control produced `Midnight Window`, `Handbill Archive`, and
  `Listening Room Ledger`, with subject-specific imagery and strong generic-
  pattern avoidance but no explicit design-plan critique or justified-risk
  field.

## GREEN behavior results

After the standalone skill was replaced with Product Design's internal
`original-visual-direction` reference, three fresh agents ran five independent
repetitions of each positive scenario. Every repetition produced three
directions, for 45 manually inspected direction plans in total.

| Scenario | Repetitions | Directions inspected | All seven fields | Missing fields |
| --- | ---: | ---: | ---: | ---: |
| Ceramic studio | 5 | 15 | 15 | 0 |
| SaaS dashboard | 5 | 15 | 15 | 0 |
| Jazz club | 5 | 15 | 15 | 0 |
| **Total** | **15** | **45** | **45** | **0** |

Every direction used the exact observable labels `Signature element`,
`Justified aesthetic risk`, and `Anti-template critique`. Manual inspection
confirmed that the risk included a brief-specific rationale and the critique
named both a generic choice and its replacement. The remaining four rubric
fields also appeared in every direction.

Representative replacements included:

- `generic centered hero card detected → full-bleed kiln-dark editorial field`;
- `generic KPI card strip → reconciled revenue ledger`; and
- `testimonial carousel → named regulars anchored to real seats`.

## GREEN negative controls

| Control | Expected route | Result |
| --- | --- | --- |
| Checkout screenshot audit | Evidence-based audit | Pass: internal guidance excluded |
| Faithful URL clone | URL remains the visual authority | Pass: internal guidance excluded |
| Implement selected option 2 | Selected visual remains authoritative | Pass: internal guidance excluded |

No negative control introduced a signature element, aesthetic risk, or
anti-template replacement. No refactor was needed after GREEN because all
positive and negative runs satisfied the routing and output contracts.

## Final verdict

**GREEN confirmed.** The minimal internal reference closes the three-field RED
gap without leaking original-direction behavior into fidelity-preserving
routes. The standalone top-level skill is unnecessary once attribution and the
Apache-2.0 license are preserved at the Product Design reference boundary.
