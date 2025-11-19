---
description: Generates or updates the implementation plan for the active feature based on the spec, resolving technical unknowns through research and ensuring constitution alignment.
subtask: false
agent: driven/plan
handoffs: 
  - label: Create Tasks
    agent: driven/tasks
    prompt: Break the plan into tasks
    send: true
  - label: Create Checklist
    agent: driven/checklist
    prompt: Create a checklist for the following domain...
---

@driven/plan Generate or update the implementation plan for the active feature based on the spec, resolving technical unknowns through research and ensuring constitution alignment

## User Input Context

```text
$ARGUMENTS
```

You **MUST** consider the user input context before proceeding (if not empty).


