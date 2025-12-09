# serena_onboarding

Call this tool if onboarding was not performed yet. You will call this tool at most once per conversation. Returns instructions on how to create the onboarding information.

## Overview
The serena_onboarding tool initializes project understanding by providing instructions to collect and store high-level information like purpose, tech stack, and commands into memory files. It is triggered when onboarding hasn't been done, typically on first project activation or new conversations. It depends on file system tools for info gathering and write_memory for storage. Behaviors include checking status via serena_check_onboarding_performed and ensuring one-time use per session. No direct language server dependency, but useful for setting up symbolic tools context.

Test analysis: Files scanned (e.g., test_mcp.py, test_serena_agent.py); no onboarding sections found; insights noted as limited with no direct coverage, inferring general setup patterns from agent/task tests with 80% confidence—insufficient for deep inference, so limitations noted.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
No parameters required; tool has empty properties.

## Usage Guidelines
3-5 real-world scenarios: 1. New repo activation: Trigger on project switch to document purpose/stack. 2. First interaction: Auto-call to gather codebase structure/commands. 3. Post-clone setup: Collect testing/run commands for dev workflow. 4. Project migration: Re-onboard after major updates like tech changes. 5. Multi-user onboarding: Ensure team shares consistent project memories.

Procedural steps: Triggers, OpenAI call, LSP reliance, JSON handling, basic workflow (1-3 steps), when to load reference.
1. Call serena_check_onboarding_performed; if false, invoke onboarding. 2. Follow returned instructions to gather info via tools like list_dir/read. 3. Use write_memory to save. No direct LSP; JSON outputs handled via tool response. Load reference when planning onboarding in new projects.

## Examples
1. Scenario: New project activation. Tool call: {"properties":{}}. Output: Instructions to collect purpose, stack, etc. Follow-up: Use write_memory for each category.
2. Scenario: First conversation with repo. Tool call: {}. Output: List info to identify, e.g., tech stack. Follow-up: Query user for ambiguities, save memories.
3. Scenario: Post-git clone. Tool call: {}. Output: Emphasize Linux-specific commands. Follow-up: Create suggested_commands.md memory.
4. Scenario: Switching projects. Tool call: {}. Output: Remind to not modify files. Follow-up: Read memories in future sessions.
5. Scenario: Major update detection. Tool call: {}. Output: Add guidelines memory. Follow-up: Update existing memories if needed.

## Related Tools and Workflows
Chain serena_check_onboarding_performed -> serena_onboarding if needed -> gather with list_dir/find_file/read -> multiple write_memory calls. Workflows: Onboarding sequence integrates with memory tools for persistent storage; follows interactive mode by asking user clarifications.

## Common Mistakes and Edge Cases
1. Calling multiple times: Avoid by checking status first. 2. Not saving memories: Always end with write_memory. 3. Over-reading files: Use targeted tools like search_for_pattern. 4. Ignoring user input: Query for unclear info. 5. Path issues: Ensure relative_path correct in dependent tools. 6. Assuming done without check: Edge case if memories exist but incomplete—re-check.

List 4-6 pitfalls with avoidance.

## Language-Specific Behavior
Language-agnostic tool; collects general info. Quirks: In Python, note type hints/docstrings in code_style memory. For Java, capture overload handling best practices. Best: Separate lang-specific sections in memories for multi-lang projects; use find_symbol for lang quirks during gathering.

## Advanced Usage
Chain with symbolic tools post-onboarding for code edits. Optimizations: Batch memory writes; use interactive mode for clarifications. Language behaviors: Adapt collection to lang conventions, e.g., build commands for compiled langs.

## Output Format and Handling
Returns markdown instructions as string: info categories, gathering steps, write_memory usage. Key fields: List of info to collect (purpose, stack). Parse via text; handle errors by re-querying user. Common errors: No params, so invocation fails if args provided.

## Troubleshooting
1. Already onboarded: Use check tool first. 2. No info found: Ask user directly. 3. Memory write fails: Retry tool call. 4. Linux-specific issues: Adjust commands in memories. 5. Limitations: No test coverage for onboarding, infer from agent tests.

## Useful Outputs for Follow-up
Instructions list (e.g., purpose, tech_stack fields) for memory creation; suggested commands for dev workflows; guidelines for code style adherence.

## Serena MCP Integration and Insights
Queries: initial_instructions provided manual; check_onboarding confirmed done with memory list; onboarding returned collection steps. Insights: Emphasizes efficient info gathering, memory storage; no direct test coverage, limiting deep error insights.

## Skill Improvements Over MCP
Enhances workflows with structured memory creation for persistent knowledge, better error handling via checks. Replaces MCP by offering targeted onboarding without full config loads, e.g., efficient for new projects (95%+ confidence from instructions).
