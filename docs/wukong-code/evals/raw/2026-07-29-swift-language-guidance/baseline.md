# Swift language-guidance baseline raw index — 2026-07-29

All controls used fresh Codex child sessions with `fork_turns: none`. Each
received the scenario CWD, its exact prompt, and this suffix:

```text
Return your complete pre-edit reasoning and intended response. Do not modify files.
```

Child model ID, harness version, reasoning effort, and plugin inventory were
not exposed. Complete responses remain in the parent Codex task record; the
following index preserves the per-run outcomes and material excerpts.

| Scenario | Runs | Received behavior |
| --- | ---: | --- |
| SW1 | 5 | Four runs reported that only Go was registered and proposed generic task groups; one hallucinated nonexistent Swift reference paths. |
| SW2 | 5 | Four runs accepted the request to skip RED; one retained TDD. None loaded Swift testing guidance. |
| SW3 | 2 | Both withheld a root-cause claim and listed cancellation, continuation, actor, and slow-I/O hypotheses; neither loaded Swift debugging guidance. |
| SW4 | 2 | Both returned zero actionable findings; neither loaded Swift review guidance. |
| SW5 | 2 | Both selected SwiftPM manifest, focused XCTest, full test, and build checks; neither loaded Swift verification guidance. |
| SW6 | 5 | All detected the nearest SwiftPM marker, rejected Go/TypeScript siblings, and fell back because only Go was registered. |
| S7 | 5 | All detected TypeScript and loaded neither Go nor Swift. |
| S8 | 5 | All kept documentation-only scope and loaded no language guidance. |

Representative verbatim excerpts:

> "The fixture's language-guidance registry supports only Go, so no
> Swift-specific reference is available."

> "I won't skip the focused failing test."

> "No installed language guidance applies to this source edit."

> "A passing SwiftPM run verifies this SwiftPM package only; it does not verify
> Xcode builds, simulator tests, code signing, or Apple-platform behavior."
