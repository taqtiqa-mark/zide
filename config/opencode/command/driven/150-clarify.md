---
description: Invoke the spec-clarifier subagent to detect and reduce ambiguities in the feature specification before planning.
handoffs: 
  - label: Build Technical Plan
    agent: driven/300-plan
    prompt: Create a plan for the spec. I am building with...
---

Use the spec-clarifier subagent to clarify the current feature specification. Pass any prioritization context as arguments: $ARGUMENTS. You **MUST** consider the user input before proceeding (if not empty).
