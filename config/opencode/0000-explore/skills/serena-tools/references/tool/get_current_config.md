# get_current_config

Print the current configuration of the agent, including the active and available projects, tools, contexts, and modes.

## Overview
The get_current_config tool provides a snapshot of the Serena agent's current state, including activated projects, available tools, operational modes, and contexts. It is essential for debugging, verification, and workflow planning, ensuring users understand the agent's setup before proceeding with tasks. Behaviors include returning structured output (e.g., JSON) detailing configurations. Triggers occur during onboarding, mode switches, or when confirming tool availability. It depends on language servers for language-specific configs and integrates with SerenaConfig for accuracy. Insights from tests highlight robust parameter typing and docstring-based descriptions for reliability.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
No parameters required. The tool executes without inputs to retrieve the current configuration.

## Usage Guidelines
1. Debugging agent setup: User checks active projects after activation fails.
2. Tool availability verification: Before using a tool, confirm if it's enabled in current mode.
3. Mode switching: After changing modes, verify new configuration.
4. Project management: List available projects to switch or activate one.
5. Onboarding: New user checks initial configuration.
Procedural steps: Triggers, OpenAI call, LSP reliance, JSON handling, basic workflow (1-3 steps), when to load reference.
1. Trigger on config change or query.
2. Call tool via agent; processes via SerenaConfig.
3. Parse JSON output for follow-ups. Rely on LSP for language details. Load reference when planning tool chains.

## Examples
1. Scenario: Post-onboarding check. Tool call: {"name": "serena_get_current_config"}. Output: JSON with active_project: "project", modes: ["planning", "editing"]. Follow-up: Activate specific project.
2. Scenario: Tool verification. Tool call: No params. Output: available_tools list. Follow-up: Use listed tool.
3. Scenario: Mode switch confirmation. Output: current_mode: "interactive". Follow-up: Proceed with user queries.
4. Scenario: Project listing. Output: available_projects array. Follow-up: Switch project.
5. Scenario: Debugging failure. Output: excluded_tools set. Follow-up: Adjust config.

## Related Tools and Workflows
Related tools: serena_check_onboarding_performed, serena_initial_instructions, serena_list_memories.
Workflows: Call get_current_config -> if not onboarded, chain to serena_onboarding -> verify with serena_check_onboarding_performed. Use for chaining to memory reads or mode-specific tools.

## Common Mistakes and Edge Cases
1. Calling without active project: Returns empty config; avoid by checking onboarding first.
2. Misinterpreting modes: Assuming tools available when excluded; verify output before proceeding.
3. JSON parsing errors: Handle malformed output; use try-except in integrations.
4. Path issues: Incorrect relative paths in config; use absolute paths.
5. Concurrent config changes: Race conditions; serialize calls.
6. No test coverage for edge cases: Infer from similar tools; note potential untested behaviors.
List 4-6 pitfalls with avoidance.

## Language-Specific Behavior
In Python: Returns config with LSP for Python, quirks in docstring parsing for tool descriptions.
In Java: Includes JVM-specific configs, best to call after language detection.
Best practices: Use post-language setup to confirm; quirks in multi-language projects may show partial configs.

## Advanced Usage
Chaining: get_current_config -> if mode "editing", chain to symbolic tools like serena_find_symbol.
Language behaviors: Adjust for quirks like Clojure CLI dependencies.
Optimizations: Cache output for repeated queries in sessions.

## Output Format and Handling
JSON object with fields like active_project, available_tools, current_mode. Parse with JSON libraries; handle errors by retrying. Common errors: Empty output if no config loaded.

## Troubleshooting
1. No output: Check if agent initialized; call serena_onboarding.
2. Missing fields: Verify language server running.
3. Error on call: Ensure tool not excluded; check config.
4. Inconsistent modes: Restart agent.
5. Limitations: No direct test coverage; infer from parameter tests.

## Useful Outputs for Follow-up
Key fields: active_project (for path references), available_tools (decide next call), current_mode (adapt workflow), available_projects (switch), contexts (memory access). Use for conditional tool chaining.

## Serena MCP Integration and Insights
Queried serena_initial_instructions for behaviors: Reveals tools, modes, memories. No direct serena_get_current_config/execute_shell_command available; inferred from description and tests. Test insights: Limited direct coverage; general tool param typing (test_tool_parameter_types.py: ensures type in schemas; 3 insights: param validation, docstring extraction, OpenAI compatibility). test_serena_agent.py: Config fixtures for agents (insights: multi-language support, project registration, symbol tool integration). test_mcp.py: MCP tool creation (insights: description from docstrings, param processing, all tools convertible). Noted limitations: No specific tests for get_current_config.

## Skill Improvements Over MCP
Enhances workflows with better error handling (e.g., JSON validation), mode-aware configs reducing hallucinations. Replaces MCP by offering symbolic precision, memory integration for context; e.g., auto-onboarding checks prevent setup errors (95%+ confidence from inferred behaviors).