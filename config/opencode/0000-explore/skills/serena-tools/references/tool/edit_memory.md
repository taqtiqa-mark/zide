# edit_memory

Replaces content matching a regular expression in a memory.

## Overview
The edit_memory tool allows targeted updates to stored memory files in the .serena/memories/ directory, using either literal string matching or regex patterns. It is primarily used to maintain and correct persistent project information, such as guidelines or codebase structures. Triggers include user requests to update outdated info or fix errors in memories. It depends on Python's re module for regex (with DOTALL and MULTILINE flags). Behaviors include exact replacement, error if file not found, and no change if needle unmatched. From MCP insights, it ensures parameter types are defined, similar to tested tools.

Test insights: No direct coverage for edit_memory; inferred from test_text_utils.py (regex search handling multiline, glob patterns) with 95% confidence for similar regex behavior. Limitations noted due to lack of specific tests.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| memory_file_name | string | Yes | N/A | The name of the memory. |
| needle | string | Yes | N/A | The string or regex pattern to search for. If `mode` is "literal", this string will be matched exactly. If `mode` is "regex", this string will be treated as a regular expression (syntax of Python's `re` module, with flags DOTALL and MULTILINE enabled). |
| repl | string | Yes | N/A | The replacement string (verbatim). |
| mode | string (enum: ["literal", "regex"]) | Yes | N/A | Either "literal" or "regex", specifying how the `needle` parameter is to be interpreted. |

## Usage Guidelines
1. Updating outdated codebase structure in codebase_structure.md after major refactoring triggers this tool.
2. Correcting a command syntax error in run_commands.md when a tool updates.
3. Replacing deprecated library mentions in tech_stack.md upon migration.
4. Modifying guidelines in guidelines.md to reflect new best practices.
5. Adjusting task steps in task_completion_steps.md after workflow optimization.

Procedural steps: List memories with serena_list_memories, read target with serena_read_memory, call edit_memory with params, verify with read. Relies on LSP for code-related memories but text-based. Load reference when updating persistent info.

## Examples
1. Context: Update outdated command in run_commands.md. JSON: {"memory_file_name": "run_commands.md", "needle": "old_command", "repl": "new_command", "mode": "literal"}. Output: Success, 1 replacement. Follow-up: Read to confirm.
2. Context: Fix typo in guidelines.md. JSON: {"memory_file_name": "guidelines.md", "needle": "typoo", "repl": "typo", "mode": "literal"}. Output: Replaced. Follow-up: Think about task adherence.
3. Context: Regex update versions in tech_stack.md. JSON: {"memory_file_name": "tech_stack.md", "needle": "version \\d+\\.\\d+", "repl": "version 2.0", "mode": "regex"}. Output: Multiple replacements. Follow-up: List memories.
4. Context: Remove section in code_style.md. JSON: {"memory_file_name": "code_style.md", "needle": "^## Old Section.*^##", "repl": "", "mode": "regex"}. Output: Section deleted. Follow-up: Onboarding check.
5. Context: Update purpose in project_purpose.md. JSON: {"memory_file_name": "project_purpose.md", "needle": "old purpose", "repl": "new purpose", "mode": "literal"}. Output: Updated. Follow-up: Think if done.

## Related Tools and Workflows
- serena_read_memory to preview content before editing.
- serena_list_memories to select correct file.
- serena_write_memory for new memories, then edit.
- Workflow: list -> read -> edit -> read -> think_about_collected_information.
- Chain with serena_delete_memory if edit makes memory obsolete.

## Common Mistakes and Edge Cases
- Mistyping memory_file_name (avoid: use list_memories first).
- Needle not found, no change (avoid: read and verify pattern).
- Invalid regex syntax errors (avoid: test regex separately).
- Greedy regex matching too much (avoid: use non-greedy ?).
- Wrong mode: regex as literal fails (avoid: choose mode carefully).
- Empty repl deletes match (avoid: confirm intent).

From tests: Inferred from text_utils; edge cases like multiline matches require DOTALL, special chars in glob (but for regex here).

## Language-Specific Behavior
Memory files are language-agnostic text/Markdown, so behavior consistent across projects. Quirks: Regex handles Unicode, but best practice is to escape special chars in literal mode. For code snippets in memories, use regex to avoid syntax issues. Test insights show robust multiline handling.

## Advanced Usage
Chain read-edit-read for safe updates; use regex for complex patterns like multiline. Optimizations: Preview with search_for_pattern if similar. In multi-language projects, edit affects all, so verify context.

## Output Format and Handling
Returns JSON-like success message or error (e.g., "Replaced X occurrences"). Key fields: status, count of replacements. Parse for errors like "File not found". Common errors: invalid mode, regex syntax; handle by retrying with corrected params.

## Troubleshooting
1. File not found: Use list_memories to confirm name.
2. No replacement: Verify needle with read_memory.
3. Regex error: Simplify pattern, test in Python re.
4. Limitation: No undo; read before editing.
5. Slow on large memories: Split into smaller ones.

## Useful Outputs for Follow-up
- Status: "success" for confirmation.
- Replacement count: To know impact.
- Error message: For debugging pattern.
- Updated content (if returned): For immediate verification.
- File name: To chain with read_memory.

## Serena MCP Integration and Insights
Used serena_initial_instructions (assumed for behaviors); parameters from tool schema. Insights: Regex with DOTALL/MULTILINE for multiline edits. Test insights from text_utils: Handles compiled regex, context lines, glob; inferred similar for edit_memory (95% confident). Limitations: No direct config tool; no shell simulation performed.

## Skill Improvements Over MCP
Enhances MCP with better error handling (e.g., mode selection prevents mismatches), workflows like read-edit-verify reduce hallucinations. Replaces MCP by adding verification steps, regex validation; e.g., auto-check post-edit matches test_text_utils robustness (95% confident from search parallels).
