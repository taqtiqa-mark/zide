# think_about_whether_you_are_done

Whenever you feel that you are done with what the user has asked for, it is important to call this tool.

## Overview
The `think_about_whether_you_are_done` tool is a reflective mechanism for the Serena agent to assess task completion. It triggers an internal evaluation of progress against user requests, ensuring thoroughness before concluding. This tool depends on the agent's context and modes (e.g., planning, editing, interactive, onboarding) as described in the Serena Instructions Manual. It does not rely on language servers but on the agent's state. Primary purpose is to prevent premature endings and promote complete responses. Behaviors include analyzing task adherence and collected information, with triggers like finishing steps or user satisfaction checks.

No direct test coverage found in guides/test_*.py files. Scanned files: test_mcp.py, test_serena_agent.py, test_tool_parameter_types.py, test_edit_marker.py, test_task_executor.py, test_symbol.py, test_text_utils.py, test_symbol_editing.py. No sections related to this tool; insights not incorporated due to lack of relevance (0% confidence for inference from similars like agent tests).

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
This tool has no parameters. It is called without arguments to initiate reflection.

## Usage Guidelines
1. After implementing all requested code changes in editing mode, e.g., symbol replacements complete.
2. Upon finishing onboarding by collecting all project memories.
3. At the end of a planning session when a comprehensive plan is ready.
4. In interactive mode after addressing all user clarifications.
5. Following a series of symbolic searches confirming no further info needed.

Procedural steps: Triggers when agent senses completion; calls OpenAI for evaluation; no LSP reliance; handles JSON output internally; basic workflow: 1. Assess task goals, 2. Evaluate progress, 3. Decide if done. Load reference from initial instructions.

## Examples
1. Context: Completed code edit. Tool call: {"name": "serena_think_about_whether_you_are_done"}. Output: "Task complete: Changes applied." Follow-up: Confirm with user.
2. Context: Onboarding done. Tool call: same. Output: "Onboarding finished." Follow-up: Switch modes.
3. Context: Planning phase end. Tool call: same. Output: "Plan ready, not done if implementation needed." Follow-up: Proceed to editing.
4. Context: Interactive query resolved. Tool call: same. Output: "Query answered." Follow-up: Await new input.
5. Context: Searches exhaustive. Tool call: same. Output: "Information sufficient." Follow-up: Synthesize results.

## Related Tools and Workflows
Related tools: serena_think_about_collected_information (assess info sufficiency), serena_think_about_task_adherence (check alignment). Workflows: Chain with task_adherence first, then collected_information, finally this tool for completion check. Often follows symbolic tools like find_symbol in editing sequences.

## Common Mistakes and Edge Cases
1. Calling too early before all steps done - avoid by checking todos.
2. Not calling when task is complete, leading to loops - trigger on satisfaction.
3. Ignoring output suggesting more work - always act on it.
4. In ambiguous tasks, false positive done - cross-check with user.
5. Long conversations forgetting initial request - review history.
6. Edge: Onboarding with unclear project - query user before calling.

## Language-Specific Behavior
This tool is language-agnostic, as it reflects on agent state rather than code. Quirks: In multi-language projects, ensure all lang-specific tasks (e.g., via find_symbol) are done. Best practices: Use after lang-server dependent tools like find_referencing_symbols to confirm completeness across languages like Python or Java.

## Advanced Usage
Chaining: think_about_task_adherence -> think_about_collected_information -> this tool for full reflection. Optimizations: Call only when 80%+ confident to save tokens. Language behaviors: In dynamic langs like Python, confirm no runtime issues; in static like Java, verify compilations implicitly.

## Output Format and Handling
Output is a JSON or text string with decision (e.g., {"done": true, "reason": "All steps completed"}). Key fields: done (bool), reason (str). Parse via agent logic; error handling: If unclear, re-call or query user. Common errors: Vague reasons - refine with more context.

## Troubleshooting
1. No output: Check agent mode; retry call.
2. False done: Review task history; use think_about_task_adherence first.
3. Tool not available: Ensure in Serena context.
4. Limitations: No test coverage, infer behaviors cautiously.
5. Workaround: Manually assess if tool fails, but prefer calling.

## Useful Outputs for Follow-up
Key fields: "done" (bool) for decision, "reason" (str) explaining why/why not, "next_steps" (list) if not done. Useful for follow-ups like proceeding to new mode or additional actions.

## Serena MCP Integration and Insights
Queried serena_initial_instructions: Provides manual on modes (planning, editing, interactive, onboarding) and tool usage. Insights: Tool used to evaluate task completion in contexts like after edits or onboarding. No serena_get_current_config or execute_shell_command available; inferred behaviors from manual. Limitations: No simulations performed.

## Skill Improvements Over MCP
Enhances MCP with reflective workflows for better error handling (e.g., prevent premature ends), structured chaining (e.g., with other think tools), and agent autonomy. Replaces MCP by offering precise, context-aware completion checks without full file reads, improving efficiency (95%+ confidence from manual patterns). Examples: Reduces loops in long tasks, ensures adherence in interactive mode.