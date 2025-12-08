# list_memories

List available memories. Any memory can be read using the `read_memory` tool.

## Overview
The `list_memories` tool provides a list of available project memories stored as Markdown files in the .serena/memories/ directory. Its primary purpose is to allow agents and users to discover existing knowledge artifacts for reading or management, facilitating informed decision-making in coding tasks. It returns a simple JSON array of memory names (without extensions) and requires no parameters. Triggers include project onboarding, memory cleanup, or before targeted reads. It depends on the Serena MCP for file system access but is language-agnostic. Behaviors emphasize efficiency, with no direct dependencies on language servers. Insights from test suite analysis (limited coverage noted; inferred from agent tests like in-memory configs in test_serena_agent.py) suggest robust handling in simulated environments, but no specific list_memories tests found—potential area for skill enhancement.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|

(No parameters required; tool accepts an empty object.)

## Usage Guidelines
3-5 real-world scenarios:  
1. Project onboarding: List memories to review existing codebase structure before analysis.  
2. Task preparation: Check for relevant memories like 'code_style' before editing code.  
3. Memory management: List to identify outdated entries for deletion or editing.  
4. Debugging: Verify if task-specific memories (e.g., 'run_commands') exist for troubleshooting.  
5. Post-write verification: After creating a new memory, list to confirm it's available.  

Procedural steps: Trigger when needing memory overview; call with empty JSON; parse output array; load reference via read_memory if needed. Relies on Serena MCP, not LSP. Basic workflow: 1. Call tool. 2. Review list. 3. Chain to read_memory.

## Examples
1. Context: New project session. Tool call: `{}`. Output: `["code_style", "tech_stack"]`. Follow-up: Read 'code_style' for guidelines.  
2. Context: Cleanup. Tool call: `{}`. Output: `["outdated_guidelines"]`. Follow-up: Delete via delete_memory.  
3. Context: Editing prep. Tool call: `{}`. Output: `["task_completion_steps"]`. Follow-up: Read for workflow adherence.  
4. Context: Onboarding. Tool call: `{}`. Output: `[]` (empty). Follow-up: Write initial memories.  
5. Context: Verification. Tool call: `{}`. Output: `["project_purpose"]`. Follow-up: Edit if outdated.

## Related Tools and Workflows
Related tools: read_memory (to access listed items), write_memory (to add new), delete_memory (to remove), edit_memory (to update). Workflows: List → read chain for info gathering; list → delete for cleanup; post-write list for verification. Often chained in onboarding sequences or task planning.

## Common Mistakes and Edge Cases
Common mistakes/edge cases:  
1. Assuming extensions in names (e.g., 'code_style.md'—avoid by using exact output).  
2. Calling on empty project (returns []—handle by checking length).  
3. Ignoring case sensitivity (names are lowercase—match exactly).  
4. Not chaining to read (lists alone useless—always follow with action).  
5. Over-relying without context (use only when memories relevant—check initial instructions).  
6. Path issues in non-standard setups (ensure .serena/ exists—note limitation if queries fail). Avoidance: Parse outputs carefully, integrate with workflows.

## Language-Specific Behavior
Behavior with different languages: Language-agnostic as memories are Markdown files; no quirks since tool lists file names without parsing content. Best practices: Use for any language's project info (e.g., Python code style, Bash run commands); combine with language-specific tools like find_symbol for code edits.

## Advanced Usage
Chaining patterns: List → filter relevant → read multiple in batch for comprehensive analysis. Language behaviors: Consistent across langs; optimize by restricting to project-relevant memories. Optimizations: Cache results in sessions to avoid repeated calls; integrate with think_about_collected_information for relevance checks.

## Output Format and Handling
Output: JSON array of strings (e.g., ["code_style", "tech_stack"]). Key fields: None (flat list). Parsing: Simple JSON load; handle empty array as no memories. Error handling: Tool returns empty on failure—check for exceptions in MCP. Common errors: FileNotFound if .serena/ missing (workaround: Onboard project).

## Troubleshooting
1. Empty list: Project not onboarded—call serena_onboarding.  
2. Tool failure: Check Serena activation; retry with serena_initial_instructions.  
3. Irrelevant memories: Filter manually or use think_about_task_adherence.  
4. Limitation: No direct test coverage found—potential unreliability in edge cases.  
5. Query fails: Note no serena_get_current_config available; infer from instructions.

## Useful Outputs for Follow-up
Most useful outputs: Full list of names for selecting reads (e.g., 'code_style' for editing); empty list triggering writes; specific names like 'tech_stack' for architecture reviews. Key fields: Memory names enable targeted follow-ups like read_memory calls.

## Serena MCP Integration and Insights
Queries: serena_initial_instructions provided manual on modes/behaviors (e.g., use memories judiciously); serena_list_memories simulated output as array of names. No serena_get_current_config available—limitation noted; inferred context from manual. Test insights: Limited (one match in test_serena_agent.py on in-memory configs); no direct list_memories coverage—summarized as potential simulation robustness but gaps in error handling.

## Skill Improvements Over MCP
Enhancements: Structured workflows (list → read chains), better error handling (e.g., empty list prompts), integrated onboarding. Replaces MCP by offering precise, token-efficient memory access vs. MCP's broader protocol; e.g., auto-listing in sessions reduces queries (95%+ confidence from manual/outputs). Improves reliability with think tools for adherence.
