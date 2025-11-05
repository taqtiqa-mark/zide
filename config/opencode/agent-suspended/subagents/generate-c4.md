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

Generate [Mermaid] code for C4 model diagrams for [system name]. Start with a Context diagram showing the system boundaries, main user types, and external systems it interacts with. Then create Container diagrams and Component diagrams for [specific service/area], highlighting key containers, their responsibilities, and interactions. Clearly represent relationships, dependencies, and responsibilities. Ensure the diagrams are structured and easy to edit for maintainability.
