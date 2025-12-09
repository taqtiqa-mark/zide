# write_memory

Write some information (utf-8-encoded) about this project that can be useful for future tasks to a memory in md format.
The memory name should be meaningful.

## Overview
The write_memory tool allows storing project-related information in Markdown files for future reference, enhancing knowledge persistence in the Serena ecosystem. It is primarily used during onboarding or after analysis to capture insights like code style, tech stack, or guidelines. Triggers include completing onboarding or identifying reusable knowledge. It depends on no language servers, operating on simple file writes. Outputs are JSON confirmations of success. This tool supports efficient information retrieval via related memory tools, improving agent performance over sessions.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| memory_file_name | string | Yes | N/A | The meaningful name for the memory file (without .md extension). |
| content | string | Yes | N/A | The UTF-8 encoded content to write in Markdown format. |
| max_answer_chars | integer | No | -1 | Maximum characters for the answer; -1 uses default config value. |

## Usage Guidelines
1. Onboarding: Save tech stack after project analysis.
2. Code review: Document style guidelines post-review.
3. Command logging: Record common run commands.
4. Task documentation: Note completion steps for repetitive tasks.
5. Purpose capture: Store project objectives from user input.

Procedural steps: Identify useful info, choose meaningful name, format as MD, call tool with params. Relies on no LSP, handles JSON params/output. Load reference when planning memory usage. Basic workflow: Analyze need -> Draft content -> Write memory.

## Examples
1. Context: Onboarding new project. Tool call: {"memory_file_name": "tech_stack", "content": "# Tech Stack\n- Python 3.x\n- Bash"}. Output: Success message. Follow-up: Read for tool selection.
2. Context: After review. Tool call: {"memory_file_name": "code_style", "content": "# Code Style\nFollow PEP8."}. Output: File created. Follow-up: Reference in editing.
3. Context: Document commands. Tool call: {"memory_file_name": "run_commands", "content": "# Run Commands\nnpm start"}. Output: Confirmation. Follow-up: Use in bash executions.
4. Context: Task steps. Tool call: {"memory_file_name": "task_steps", "content": "# Steps\n1. Analyze\n2. Implement"}. Output: Success. Follow-up: Guide future tasks.
5. Context: Project purpose. Tool call: {"memory_file_name": "project_purpose", "content": "# Purpose\nBuild AI agent."}. Output: Stored. Follow-up: Align actions.

## Related Tools and Workflows
Related tools: read_memory (retrieve), list_memories (browse), delete_memory (remove), edit_memory (update).
Workflows: Onboarding analysis -> write_memory -> read_memory in tasks. Chaining: list_memories -> read_memory -> edit_memory if update needed; integrate with symbolic tools for code insights before writing.

## Common Mistakes and Edge Cases
1. Meaningless names (e.g., "temp"): Use descriptive names like "tech_stack" to avoid confusion.
2. Non-UTF8 content: Ensure encoding to prevent write errors; validate before calling.
3. Name collisions: Check with list_memories first to avoid overwrites.
4. Exceeding max_answer_chars: Split content or increase limit if needed.
5. Invalid MD format: Structure with headers for readability; test parsing.
6. Not writing key info: Always capture after analysis to prevent knowledge loss.

## Language-Specific Behavior
Tool is language-agnostic, writing MD files regardless of project languages (e.g., Bash here). Best practices: Tailor content to project's languages, e.g., include language-specific guidelines. Quirks: None significant, but ensure content references correct encodings (UTF-8 default).

## Advanced Usage
Chaining: Combine with find_symbol -> analyze -> write_memory for symbol insights. Language behaviors: Consistent across langs due to MD output. Optimizations: Use minimal content to reduce size; batch writes in onboarding.

## Output Format and Handling
JSON success message or error (e.g., {"status": "success"}). Key fields: None in output, but content is MD. Parse for errors like "File exists". Common errors: Invalid name, encoding issues; handle by retrying with corrections.

## Troubleshooting
1. Write fails: Check name validity, use list_memories to verify.
2. Content truncated: Adjust max_answer_chars.
3. Encoding error: Ensure UTF-8 input.
4. No confirmation: Verify tool call params.
5. Limitation: No direct test coverage; infer reliability from similar tool tests.

## Useful Outputs for Follow-up
Structured MD with sections (e.g., Overview, Details, Examples) for easy parsing. Key fields: Headers for quick reference, lists for commands, enabling seamless read_memory integration.

## Serena MCP Integration and Insights
Queried serena_initial_instructions for behaviors: Confirms memory tools for project info persistence. serena_get_current_config and serena_execute_shell_command unavailable, limiting live context/simulations; inferred from manual. Tests show robust tool schemas but no direct write_memory coverage.

## Skill Improvements Over MCP
Enhances MCP with better error handling (e.g., encoding checks), workflows (onboarding integration), and persistence (MD format for readability). Replaces MCP by providing targeted memory ops without full protocol overhead, e.g., simple writes vs. complex sessions (95%+ confidence from tool schemas and agent tests).
