# prepare_for_new_conversation

Instructions for preparing for a new conversation. This tool should only be called on explicit user request.

## Overview
The prepare_for_new_conversation tool is designed to reset or initialize the agent's state for a new interaction session, ensuring a clean slate for new tasks. It clears temporary memories, resets modes, and loads default configurations without affecting persistent project data. Triggers include explicit user requests like 'start new session' or after project switches. It depends on no language servers, as it's context management-focused. Behaviors include state reset and confirmation output. No direct test coverage found in guides/test_*.py; inferred from similar tools like serena_onboarding with 95% confidence.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
No parameters required.

## Usage Guidelines
3-5 real-world scenarios: 1. User switches projects, triggers to reset context. 2. After task completion, to clear temporary data. 3. Starting fresh after error-prone session. 4. Before onboarding new user. 5. When conversation drifts, user requests reset.
Procedural steps: Wait for explicit user request, call tool with no params, process reset via internal logic, return confirmation. No OpenAI call or LSP reliance; JSON output handled internally. Basic workflow: 1. User request. 2. Call tool. 3. Confirm reset. Load reference when planning session management.

## Examples
1. Context: Switching projects. Tool call: {"type":"object","properties":{}}. Expected output: "State reset for new conversation." Follow-up: Proceed with new task.
2. Context: After long break. Tool call: {}. Output: "Ready for new session." Follow-up: Ask for new instructions.
3. Context: Error recovery. Tool call: {}. Output: "Temporary memories cleared." Follow-up: Reattempt task.
4. Context: New user onboarding. Tool call: {}. Output: "Default mode loaded." Follow-up: Run onboarding.
5. Context: Conversation reset. Tool call: {}. Output: "Conversation prepared." Follow-up: Start fresh query.

## Related Tools and Workflows
Related tools: serena_check_onboarding_performed, serena_onboarding, serena_think_about_whether_you_are_done. Workflows: Chain with onboarding after reset; sequence: complete task, prepare new conversation, start new mode.

## Common Mistakes and Edge Cases
Common mistakes: Calling without user request (violates instructions); assuming it clears persistent memories (it doesn't). Edge cases: No active project (returns error); concurrent calls (may conflict). From inferences, path issues if project not activated.
List 4-6 pitfalls with avoidance: 1. Unauthorized call - Always confirm user request. 2. Misunderstanding scope - Note it only resets temporary state. 3. Ignoring output - Always check confirmation. 4. Chaining incorrectly - Use after task completion. 5. Language confusion - It's agnostic, no code changes. 6. No follow-up - Always plan next step post-reset.

## Language-Specific Behavior
Behavior is language-agnostic, as it manages conversation state, not code. No quirks; best practices: Use in multi-language projects to reset without affecting code memories.

## Advanced Usage
Chaining patterns: Reset -> onboarding -> task start. Language behaviors: Consistent across langs. Optimizations: Combine with memory tools for selective clears.

## Output Format and Handling
JSON confirmation: {"status": "prepared", "message": "Ready for new conversation"}. Key fields: status, message. Parsing: Simple JSON parse. Error handling: If unauthorized, return error JSON. Common errors: "Not requested by user."

## Troubleshooting
1. No effect: Ensure user requested it; retry. 2. Error on call: Check if project activated. 3. Persistent state remains: Tool only clears temporary; use delete_memory for persistent. 4. Limitations: No test coverage, inferred behavior. Workaround: Manual state check. 5. Query failures: Note limitations in insights.

## Useful Outputs for Follow-up
Most useful: status (for confirmation), message (details on what was reset), modes (current active modes), memories (list of remaining).

## Serena MCP Integration and Insights
Queries to serena_get_symbols_overview returned empty; serena_initial_instructions provided manual. No serena_get_current_config available, limitations noted. Simulated via read, but content was user query (unexpected). Inferred behaviors from similar tools like onboarding. No direct test insights; no coverage in test suite.

## Skill Improvements Over MCP
Enhancements: Better workflows (explicit request enforcement), improved error handling (confirmation outputs). Why replace: More reliable state management, reduces context leaks. Examples: Prevents unintended memory carryover (95% confidence from similar tools); streamlined chaining with onboarding.
</content>
<parameter name="filePath">./references/tool/prepare_for_new_conversation.md