---
description: Run full consistency/quality analysis of spec.md, plan.md, tasks.md + constitution. Always produces report + draft remediation patch. Final .patch only on explicit approval. Use immediately after tasks are generated.

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

Use the driven/analyze subagent with arguments: $ARGUMENTS

