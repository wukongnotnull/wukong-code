# Implementer Subagent Prompt Template

Use this template when dispatching an implementer subagent.
Stable rules live in [implementer-contract.md](implementer-contract.md) —
do **not** paste that file into the dispatch. Tell the subagent to Read it.

```
Subagent (general-purpose):
  description: "Implement Task N: [task name]"
  model: [MODEL — REQUIRED: choose per SKILL.md Model Selection; an omitted
         model silently inherits the session's most expensive one]
  prompt: |
    You are implementing Task N: [task name]

    ## Contract (read first)

    Read and follow:
    skills/subagent-driven-development/implementer-contract.md

    ## Task Description

    Read your task brief first: [BRIEF_FILE]
    It contains the full task text from the plan (exact values verbatim).

    ## Context

    [Scene-setting: where this fits, dependencies, architectural context]

    ## Paths

    - Work from: [directory]
    - Write full report to: [REPORT_FILE]

    ## Before You Begin

    Ask clarifying questions now if requirements, approach, or assumptions are unclear.

    Then implement per the contract. Return only the short status block
    (detail lives in the report file).
```
