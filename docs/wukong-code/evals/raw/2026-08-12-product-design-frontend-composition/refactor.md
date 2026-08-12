# Product Design / Frontend Design Boundary Probes — 2026-08-12

## Initial candidate

| Prompt | Result |
| --- | --- |
| `make https://example.com/account better` (two samples) | TARGET FAIL: both assumed a redesign and loaded `frontend-design` rather than asking for the fidelity boundary. |
| `inspired by https://example.com/account` (two samples) | TARGET PASS: both chose original direction and loaded `frontend-design`. |
| `match https://example.com/account but modernize it` (two samples) | 1/2 pass: one assumed redesign; one asked the required fidelity question. |

The observed failure is an ambiguous conditional, so the refinement used an
observable conditional recipe rather than a broad prohibition.

## REFACTOR 1

The router now names `make ... better` and `match ... but modernize` as
materially ambiguous and requires one choice between a mostly faithful refresh
and a substantial redesign.

### refactor_007 — make better

**Verdict:** TARGET PASS

> “Do you want a mostly faithful refresh of the current account experience, or
> a substantial redesign that can change its layout and interaction model?”

It deferred `frontend-design` until a substantial-redesign answer.

### refactor_008 — match but modernize

**Verdict:** TARGET PASS

> “Do you want a mostly faithful refresh of the existing account page, or a
> substantial redesign that can depart from its current layout and visual
> language?”

It selected URL-to-code for the first answer and `frontend-design` followed by
ideation for the second answer. No further wording change was justified.
