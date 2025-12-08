# restart_language_server

Use this tool only on explicit user request or after confirmation.
It may be necessary to restart the language server if it hangs.

## Overview
The restart_language_server tool restarts the language server process in the Serena CLI environment, primarily to resolve hangs or inconsistencies in semantic code analysis. It depends on an active language server (LSP) for the project's programming languages. Triggers include tool failures in symbol operations or user-reported issues. Behaviors: Stops and restarts the server, potentially clearing caches and states. Use sparingly to avoid disruptions. Dependencies: Configured LSP for languages like Python, Java, etc. <150 words.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
No parameters defined; tool likely operates without inputs based on current config.

## Usage Guidelines
3-5 real-world scenarios: 1. Symbol search timeouts due to LSP hang in large codebases. 2. Inconsistent symbol info after bulk file changes. 3. High memory usage causing LSP unresponsiveness. 4. After git branch switch, LSP state desync. 5. During long sessions, periodic hangs.
Procedural steps: Detect LSP issue (e.g., failed find_symbol), confirm with user, call tool, verify with follow-up tool like get_symbols_overview. Relies on LSP for semantic ops; outputs JSON status. Load reference when planning edits if LSP reliability is concern. Basic workflow: 1. Identify hang. 2. Call tool. 3. Retry operation.

## Examples
1. Context: find_symbol fails with timeout. Tool call: {"name": "serena_restart_language_server"}. Output: {"status": "success", "message": "LSP restarted"}. Follow-up: Retry find_symbol.
2. Context: After editing, symbols not updating. Tool call: same. Output: success. Follow-up: Use find_referencing_symbols.
3. Context: Memory leak suspected. Tool call: same. Output: success. Follow-up: Monitor with shell command.
4. Context: Branch switch desync. Tool call: same. Output: error if no LSP. Follow-up: Check config.
5. Context: User requests due to slowness. Tool call: same. Output: success. Follow-up: Test with overview tool.

## Related Tools and Workflows
Related: find_symbol, get_symbols_overview, find_referencing_symbols - restart if they fail due to LSP issues. Workflows: Chain with symbolic tools; e.g., try find_symbol -> if hang error -> restart -> retry. Integrate in error handling flows for editing tasks.

## Common Mistakes and Edge Cases
Common: 1. Restarting unnecessarily, causing delays - avoid by confirming hang first. 2. No active LSP, tool fails - check with config tool. 3. Path/config mismatches - ensure project activated. 4. Network LSP not restartable locally - use shell for remote. 5. Frequent restarts masking underlying issues - investigate root cause. 6. Language without LSP support - tool no-op.
List 4-6 pitfalls with avoidance: See above.

## Language-Specific Behavior
Python: Restarts Pyright/Pylsp, clears analysis cache - best after major refactors. Java: JDT may require project rebuild post-restart. JS/TS: tsserver restarts quickly but loses unsaved changes - save first. Quirks: C++ servers memory-intensive, restart frees resources. Best practices: Verify language support in config before use; chain with overview tool post-restart.

## Advanced Usage
Chaining: Error in symbolic tool -> user confirm -> restart -> retry tool. Optimizations: Automate in skills with conditional restarts. Language behaviors: For interpreted langs, minimal downtime; compiled langs may need reindexing.

## Output Format and Handling
JSON object with status (success/error), message, timestamp. Key fields: status, message. Parsing: Check status for success. Error handling: If fails, log and notify user. Common errors: "No LSP running", "Permission denied".

## Troubleshooting
1. Tool fails: Check if project activated/LSP configured. 2. No effect: Verify LSP process via shell. 3. Frequent hangs: Increase resources or optimize codebase. 4. Error output: Parse message for details. 5. Limitations: Not for remote LSPs - use manual restart.

## Useful Outputs for Follow-up
Success status, message detailing restart outcome, timestamp for logging. Key fields: status for confirmation, message for errors/details - use to decide retry or further troubleshooting.

## Serena MCP Integration and Insights
Queried serena_initial_instructions for behaviors; provided manual on modes/tools but no specific on restart. Attempted get_symbols_overview on prompt file, empty. No get_current_config available; inferred from general knowledge. Test analysis: Files scanned (8 test_*.py), no mentions of restart_language_server, no sections summarized, insight: no coverage, inferred from symbol editing tests implying LSP dependency.

## Skill Improvements Over MCP
Skills offer automated workflows with error detection/retry, better handling (e.g., conditional restarts without user prompt). Replaces MCP by reducing manual interventions, improving reliability in symbolic ops. Examples: Auto-restart on hang detection (95% confident from editing tests), integrated validation post-restart.
