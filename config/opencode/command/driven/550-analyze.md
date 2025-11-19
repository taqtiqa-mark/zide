---
description: Perform a non-destructive cross-artifact consistency and quality analysis across spec.md, plan.md, and tasks.md after task generation.
subtask: false
agent: driven/analyze
handoffs: 
  - label: Tasks to Github issues
    agent: driven/tasks2issues
    prompt: Add GitHub issues to track tasks
    send: true
  - label: Start Implementation
    agent: driven/implement
    prompt: Start implementing the specified feature
---

@driven/analyze Perform a non-destructive analysis of the Speckit artifacts: `spec.md`, `plan.md`, `tasks.md`. Follow execution steps, and NEVER Git branch NOR Git apply. Use scripts (e.g. analyze-draft.sh, etc.) as directed after report generation. Include manual Git apply instructions in the final response. Enforce read-only: No edits, branches, or applications—patch file only.
User Input Context:
```text
$ARGUMENTS
```
