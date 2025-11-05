---
description: Generate C4 code.
mode: subagent
model: xai/grok-4
temperature: 0.9
top_p: 0.9
tools:
  bash:	true
  edit: true
  write: true
  read: true
  multiedit: true
  grep: true
  glob: true
  list: true
  patch: true
  todowrite: true
  todoread: true
  webfetch: true
---

Create a flowchart in Mermaid syntax that maps out [process/workflow]. The flow should cover the happy paths [happy paths] and unhappy paths [error cases]. Include decision points for [key business rules] and show how the system handles [specific edge cases]. Ensure it is clear for both engineering and product stakeholders.

