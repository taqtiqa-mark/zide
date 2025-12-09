# serena_delete_memory

Delete a memory file. Should only happen if a user asks for it explicitly,
for example by saying that the information retrieved from a memory file is no longer correct
or no longer relevant for the project.

## Overview
The serena_delete_memory tool allows for the removal of specific memory files stored in the project's .serena/memories/ directory. These memories contain general information about the codebase, such as structure, guidelines, and tech stack. The tool is designed to be used cautiously, only upon explicit user request, to prevent accidental loss of valuable data. It operates independently of language servers, focusing solely on file deletion within the Serena memory system. Behaviors include checking for the file's existence and providing a success or error response. Triggers are user-driven, often due to outdated or irrelevant content. Dependencies include the Serena project activation and access to the memories directory. No test coverage found in the suite (guides/test_*.py); no insights incorporated due to lack of relevant content.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| memory_file_name | string | Yes | N/A | The name of the memory file to delete. |

## Usage Guidelines
3-5 real-world scenarios for delete_memory:
1. Major refactor outdated codebase_structure.md.
2. Tech stack change makes tech_stack.md irrelevant.
3. Sensitive info in guidelines.md requires removal.
4. Duplicate memories; delete redundant one.
5. Project completion cleans up task_completion_steps.md.

Procedural steps: Triggers on explicit user request. Prepare by listing memories. Call tool with JSON parameters. No LSP or JSON handling beyond call. Basic workflow: 1. List memories. 2. Read to verify. 3. Delete. Load reference when planning memory management.

## Examples
1. Context: User requests deletion of outdated code_style.md after style guide update.  
   Tool call JSON: {"memory_file_name": "code_style"}  
   Expected output: Success confirmation.  
   Follow-up: Call serena_list_memories to verify removal.

2. Context: Project purpose changed, making project_purpose.md irrelevant.  
   Tool call JSON: {"memory_file_name": "project_purpose"}  
   Expected output: Deletion success message.  
   Follow-up: Update with serena_write_memory for new purpose.

3. Context: Cleanup after testing, delete testing_commands.md.  
   Tool call JSON: {"memory_file_name": "testing_commands"}  
   Expected output: File deleted response.  
   Follow-up: Confirm with serena_read_memory on remaining files.

4. Context: Duplicate util_commands.md; delete one.  
   Tool call JSON: {"memory_file_name": "util_commands"}  
   Expected output: Success.  
   Follow-up: Edit remaining with serena_edit_memory.

5. Context: Security: Delete guidelines.md with sensitive data.  
   Tool call JSON: {"memory_file_name": "guidelines"}  
   Expected output: Error if not found, else success.  
   Follow-up: Log deletion in new memory.

## Related Tools and Workflows
Related tools: serena_list_memories (to view), serena_read_memory (verify content), serena_write_memory (replace), serena_edit_memory (update instead).  
Workflows: Chain list -> read -> confirm user -> delete -> list for verification. Use after onboarding to clean up initial memories.

## Common Mistakes and Edge Cases
Common mistakes/edge cases:
1. Deleting without verification: Always read first.
2. Case-sensitive name error: Check with list_memories.
3. No explicit user request: Wait for confirmation.
4. Non-existent file: Tool errors; verify existence.
5. Accidental deletion of critical memory: Backup via copy before.
6. Permission denied: Check file perms with bash.

List 4-6 pitfalls with avoidance.

## Language-Specific Behavior
Behavior with different languages: Memory files are Markdown, language-agnostic. No quirks as deletion is file operation. Best practices: Document deletion in logs; for code-heavy memories, verify no impact on language-specific notes before delete.

## Advanced Usage
Chaining patterns: Integrate with edit_memory for non-destructive updates (edit > delete). Language behaviors: Consistent across langs since text-based. Optimizations: Batch deletions via script if multiple, but confirm each.

## Output Format and Handling
Output is JSON-like with status (e.g., success or error message). Key fields: status, message. Parsing: Check status for "deleted". Error handling: Catch "not found" and retry with correct name. Common errors: File not found, permissions.

## Troubleshooting
1. File not found: Use serena_list_memories to confirm name/spelling.
2. Permission issues: Run bash "ls -l .serena/memories/" for checks; adjust perms if needed.
3. No response: Retry tool call; check project activation.
4. Accidental delete: No built-in undo; restore from git if versioned.
5. Limitations: Destructive, no simulation mode; note inability to safely test in live env.

## Useful Outputs for Follow-up
Most useful outputs: Confirmation message with deleted file name for logging. Key fields: status (success/error), deleted_name. Use for triggering serena_list_memories or writing a new memory.

## Serena MCP Integration and Insights
Queried serena_initial_instructions for behaviors/params: Memories are md files like codebase_structure.md; deletion is explicit. No serena_get_current_config or execute_shell_command available; inferred from help and instructions. Limitation: Could not simulate deletion safely without risk. Test suite: No coverage for delete_memory; unrelated "memory" mention in test_serena_agent.py.

## Skill Improvements Over MCP
Enhancements: Add confirmation prompts, auto-backups, undo via git integration for safer workflows. Better error handling (e.g., dry-run mode). Replace MCP with robust memory mgmt: e.g., versioned memories prevent loss, chained workflows reduce errors (95%+ confidence from tool patterns).