Below is a self-contained Problem Statement and Optimal Solution Outline based on the issue we encountered. You can copy-paste this directly into another LLM session (e.g., as a user prompt) to develop the dedicated "safe-patch" agent. I've kept it concise, structured, and aligned with SDD principles for easy adaptation.
---

Problem Statement
In the OpenCode Client (a Claude Code clone) we encounter the following types of errors, per this github issue report:
~~~markdown
## Tools Fail to Unescape XML Entities (e.g., "&amp;&amp;" Becomes Invalid Shell Syntax)

### Description

Disclosure: 1st draft AI generated.

Tool fail to properly unescape XML entities in command arguments, leading to execution errors, or file content corruption. This occurs when commands include chained operators like "&&", which must be escaped as "&amp;&amp;" in the XML function call format to make it valid XML. However, the tool passes the escaped string directly to the shell without unescaping, causing syntax errors.

Also happens with Edit and Write tools where `\n` replaces newlines and a whole file becomes one line of text.



**Environment:**
- Platform: Linux.
- Tools: Bash, Write, Edit tools in opencode.

**Impact:**
- Prevents reliable use of chained Bash commands, breaking workflows like script execution or multi-step operations.

**Suggested Fix:**
- In the Tool handlers, add unescaping logic (e.g., replace "&amp;" with "&", "\n" with new line, etc.) before executing the command string in the shell. Reference standard XML entity handling in tool parsers.

**Additional Context:**
- This aligns with the safety instructions' XML-inspired format, but the parsing layer appears to miss unescaping.
- Reproducible in sessions with function calls: Bash, Write, Edit.

 **Related:**
https://github.com/sst/opencode/issues/3868#issuecomment-3522364197

### OpenCode version

1.0.77

### Steps to reproduce

1. Invoke the Bash tool with a command like: `cd /path &amp;&amp; ls` (escaped for XML validity).
2. The tool executes it as "cd /path &amp;&amp; ls" in the shell.
3. Result: Error like "/bin/sh: 1: Syntax error: "&" unexpected".

**Expected Behavior:**
- The app should unescape the argument (e.g., "&amp;&amp;" -> "&&") before passing to the shell, allowing valid execution (e.g., "cd /path && ls").

**Actual Behavior:**
- Escaped string is passed literally, causing shell syntax errors for any command with "&" (e.g., chaining with "&&").

### Screenshot and/or share link

_No response_

### Operating System

Linux

### Terminal

Alacritty & Zellij
~~~

To try to workaround this:
In our Spec-Driven Development (SDD) workflow, agents like driven/clarify and driven/analyze rely on bash scripts (e.g., analyze-finalize.sh) to create and apply patch files for updating specification documents (e.g., spec.md). However, when these agents are spawned in nested or restricted contexts (e.g., clarify launched by analyze), the scripts often fail due to environmental issues such as "script not found," "unknown feature," or path resolution errors. This leads to hallucinations where the agent reports changes as applied without actually mutating files, breaking traceability and requiring manual fallbacks (e.g., using Edit/Write tools ad-hoc). The root causes include:
- Dependency on bash scripts that may not be available or executable in all agent environments.
- Lack of robust error handling for file mutations, leading to incomplete workflows.
- Inconsistency across agents, violating SDD's emphasis on error-free, traceable processes.
This results in rework, reduced reliability, and potential spec inconsistencies. We need a standardized, agent-based workflow to handle patching safely and consistently, usable by any agent without relying on fragile scripts.

Optimal Solution Outline
Create a new dedicated agent called "driven/safe-patch" (or similar) that all other agents can invoke via the Task tool for reliable, traceable file patching. This agent should encapsulate a "safe-patch" workflow, prioritizing core tools (e.g., Read, Edit, Write) over bash scripts, with built-in fallbacks and validation. Key requirements and design:

Core Functionality
- Input: Accepts parameters like target file path (e.g., spec.md), oldString/newString pairs (for Edit), or full content (for Write), a description of changes, and an optional patch file path for traceability (e.g., ID-analysis.patch).
- Workflow Steps:
  1. Read and Verify: Use Read to load the target file and confirm the oldString exists uniquely (if editing).
  2. Apply Changes Safely:
     - Prefer Edit for precise replacements; if multiples are found, auto-expand oldString context or split into multiple calls.
     - Fallback to Write for full overwrites if Edit isn't suitable (e.g., large structural changes).
     - Handle errors gracefully (e.g., retry on transients, abort with logs on permanents).
  3. Generate Patch File: After mutation, use Read to diff original vs. updated content and Write a .patch file in diff format for traceability.
  4. Validate: Re-read the updated file and confirm changes; report success/failure with excerpts.
- Error Handling: If any step fails, log details, rollback if possible (e.g., via git if in a repo), and return a structured error report. Enforce 100% success or explicit user override.
- Integration: Callable via Task tool (e.g., subagent_type: "driven/safe-patch", prompt: "Apply this patch to spec.md with changes: details"). Ensure it's stateless and works in nested agent contexts.
Non-Functional Requirements
- Reliability: 100% idempotency (e.g., hash-based checks to avoid duplicates); no bash dependencies.
- Traceability: Always output a patch file and log in beads/issues for SDD compliance.
- Scalability: Handle small edits efficiently; limit to <10k lines per file.
- Security: Sanitize inputs; restrict to project directories.
Implementation Notes
- Document in AGENTS.md as a core agent.
- Test with edge cases: multiple matches, file not found, large files.
- Benefits: Standardizes patching across agents, reduces hallucinations, and aligns with SDD's tool-enhanced workflows.
Develop this agent, including its prompt, usage examples, and integration into existing agents like driven/clarify.


