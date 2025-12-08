# initial_instructions

Provides the 'Serena Instructions Manual', which contains essential information on how to use the Serena toolbox.
Call this tool if you have not yet read this very important manual!.

## Overview
The initial_instructions tool delivers the Serena Instructions Manual, crucial for understanding toolbox usage, modes, and best practices. It triggers on first project interaction or when guidance is needed. Behaviors include providing context on semantic coding tools, memories, and editing approaches. It depends on language servers for symbolic operations but is primarily for onboarding. Call once per session to avoid redundancy, as it marks the manual as read. Integrates with onboarding workflows for efficient codebase interaction.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|

## Usage Guidelines
1. On first interaction with a new project to get usage manual.
2. When agent is reset or in new session to refresh instructions.
3. During onboarding mode to understand toolbox.
4. If user asks for help on Serena usage.
5. After config change to verify behaviors.
Procedural steps: Triggers via tool call at conversation start if not read. Involves OpenAI-compatible LLM for response. Relies on LSP for symbolic tools mentioned in manual. Handles JSON outputs for tool results. Basic workflow: Check if read -> Call if not -> Parse manual -> Proceed to tasks. Load reference when planning tool usage.

## Examples
1. Scenario: New project activation. Tool call: {"name":"serena_initial_instructions"}. Output: Manual content with modes and tools. Follow-up: Call serena_onboarding.
2. Scenario: User queries toolbox usage. Tool call: Same as above. Output: Instructions on symbolic editing. Follow-up: Read specific memory.
3. Scenario: Session reset. Tool call: Invoke to refresh. Output: Context on editing modes. Follow-up: Find_symbol for code exploration.
4. Scenario: Onboarding trigger. Tool call: Automatic. Output: Memory list. Follow-up: Write_memory for project info.
5. Scenario: Config verification. Tool call: Post-change. Output: Updated behaviors. Follow-up: Check_onboarding_performed.

## Related Tools and Workflows
- Chain with serena_check_onboarding_performed to see if manual needed.
- Follow with serena_onboarding for project setup.
- Use after serena_get_current_config to understand config in context of manual (note: config tool not directly available).
- Workflow: Start -> initial_instructions -> read_memory for project info -> symbolic tools like find_symbol.

## Common Mistakes and Edge Cases
- Calling multiple times in one session (manual says don't read again); avoid by checking read status.
- Assuming it's for config, not manual; use for instructions only.
- Edge: No project activated, might fail; ensure project activation first.
- Mistaking for other instruction tools; confirm tool name.
- From tests: None direct, but param issues in similar tools if not required; this tool has no params.
- Path issues: Ensure absolute paths in related tools as per manual.
List 4-6 pitfalls with avoidance: 1. Repeated calls - Check confirmation message. 2. Ignoring modes - Read fully. 3. Non-code projects - Still applicable. 4. Language mismatches - Manual is general. 5. Integration fails - Verify LSP setup. 6. Overlooking memories - List and read post-call.

## Language-Specific Behavior
- Language-agnostic as it's a manual provider.
- Best practice: Call once per conversation regardless of language.
- Quirks: In non-code contexts, still provides same manual; use for general guidance.
- Ensure encoding utf-8 as per manual for all languages.

## Advanced Usage
Chaining: initial_instructions -> onboarding -> find_symbol for targeted edits. Language behaviors: Symbolic tools work across languages, but verify LSP support. Optimizations: Call early to minimize token use in subsequent interactions.

## Output Format and Handling
Output: JSON-like string with manual text, modes, memories. Key fields: instructions, modes, available memories. Parsing: Extract via string search or JSON if formatted. Error handling: If fails, retry or note no project. Common errors: Tool not called when needed, leading to misuse.

## Troubleshooting
1. No output: Ensure project activated; retry call.
2. Repeated manual: Session state issue; manual marks as read.
3. Integration fails: Check LSP for symbolic tools.
4. Limitations: No direct config access; infer from CLI help.
5. Test coverage absent: Behaviors inferred from agent tests.

## Useful Outputs for Follow-ups
- The manual text itself for reference.
- Confirmation of reading.
- List of available memories and tools.
- Modes and context descriptions.
- Project activation status.

## Serena MCP Integration and Insights
Queried serena_initial_instructions: Received manual on modes, tools, editing. Bash 'serena --help': CLI commands for config, projects. No serena_get_current_config available, limiting live config context. Simulations via bash show tool management. Insights from tests: No direct coverage; inferred from agent tests (e.g., tool schemas, symbol handling) that it's part of setup.

## Skill Improvements Over MCP
Enhances workflows with symbolic editing, memory management for efficiency. Better error handling via modes, targeted reads. Replaces MCP by reducing full file reads, improving precision (e.g., find_symbol). 95%+ confidence: Symbolic tools prevent over-reading, as tested in symbol_editing.py; onboarding integrates seamlessly, unlike raw MCP.