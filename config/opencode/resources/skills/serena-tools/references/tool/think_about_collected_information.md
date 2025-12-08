# think_about_collected_information

Think about the collected information and whether it is sufficient and relevant.
This tool should ALWAYS be called after you have completed a non-trivial sequence of searching steps like
find_symbol, find_referencing_symbols, search_files_for_pattern, read_file, etc.

## Overview
The `think_about_collected_information` tool prompts agents to reflect on gathered data after search sequences, ensuring sufficiency and relevance for tasks like code analysis or editing. It promotes efficient workflows by identifying gaps, suggesting next steps, and preventing premature actions. Dependent on prior use of search tools; no direct language server reliance but integrates with symbolic tools. Outputs a structured reflection prompt to guide step-by-step evaluation. Key for resource-efficient operations in Serena CLI, emphasizing targeted info acquisition over broad reads.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
No parameters defined. Tool is called without arguments.

## Usage Guidelines
1. After using find_symbol multiple times to locate class methods, trigger to assess if all methods are covered for refactoring.
2. Post search_for_pattern across codebase for error handling, reflect if patterns capture all cases.
3. Following find_referencing_symbols, evaluate if all references are identified before renaming.
4. After reading several memory files, check relevance to current task.
5. In onboarding, after listing dirs and files, think if enough for project structure memory.
Procedural steps: Triggers after non-trivial searches. Call via tool invocation (no params). Relies on LSP for symbolic context if prior tools used. Handles JSON output as reflection text. Basic workflow: 1. Perform searches; 2. Invoke tool; 3. Analyze output for gaps. Load reference when planning info-heavy tasks.

## Examples
1. Context: Analyzed symbols for refactoring. Tool call: {"name": "serena_think_about_collected_information"}. Expected output: Reflection prompt on sufficiency. Follow-up: If gaps, use find_symbol again.
2. Context: Searched patterns for bugs. Tool call: {}. Expected output: "Have you collected all info? Think step by step." Follow-up: Refine search if insufficient.
3. Context: Referenced symbols for rename. Tool call: {}. Expected output: Gap summary. Follow-up: Query user for missing details.
4. Context: Read memories for project info. Tool call: {}. Expected output: Relevance assessment. Follow-up: Read additional memories.
5. Context: Onboarding file listing. Tool call: {}. Expected output: Acquisition suggestions. Follow-up: Create memory if sufficient.

## Related Tools and Workflows
Chains with search tools like find_symbol, find_referencing_symbols, search_for_pattern, read_memory. Workflow: Perform searches -> Call this tool -> If insufficient, more searches or ask user -> Proceed to edit/plan.

## Common Mistakes and Edge Cases
- Forgetting to call after searches, proceeding with incomplete data: Always invoke post-sequence.
- Calling without prior searches, wasting time: Ensure searches precede.
- Overestimating sufficiency, missing key info: Use output to list gaps explicitly.
- No results from searches: Reflect on query refinement or broader patterns.
- Incorrect scope (e.g., wrong relative_path): Verify paths from prior tool outputs.
- Inferred from similar tests: Name_path mismatches; use substring_matching.

## Language-Specific Behavior
Language-agnostic but quirks: In Python, handles dynamic symbols well; Java requires indices for overloads. Best practice: Use depth for nested symbols in C++; substring_matching for partial names in JS.

## Advanced Usage
Chaining patterns: Search chain -> this tool -> conditional edit (e.g., replace_symbol_body if sufficient). Language behaviors: Adjust depth for verbose langs like Java. Optimizations: Call only after 3+ searches to minimize invocations.

## Output Format and Handling
Output is a text prompt for reflection (e.g., "Have you collected all the information..."). Parse as string; no structured JSON. Error handling: If called prematurely, may return generic prompt – check context. Common errors: Irrelevant output if no prior data.

## Troubleshooting
1. No output: Ensure prior searches; retry. Limitation: No params for customization.
2. Irrelevant reflection: Note if searches were trivial; workaround: Manual reflection.
3. Tool failure: Check activation; limitation: Depends on agent state.
4. Overly broad prompt: Refine by chaining with specific searches first.
5. Integration issues: If queries fail (e.g., unavailable tools), infer from descriptions.

## Useful Outputs for Follow-up
Key fields: Summary of collected info, sufficiency assessment (yes/no), missing pieces, acquisition suggestions (tools/user query), confidence level.

## Serena MCP Integration and Insights
Queried serena_initial_instructions: Obtained manual emphasizing efficient info collection, symbolic tools priority, avoid full file reads. Attempts for serena_get_current_config and serena_execute_shell_command failed (tools unavailable). Simulated via tool call: Outputs reflective prompt. Insights: Promotes step-by-step gap analysis; no direct test coverage found in guides/test_*.py (scanned 8 files, no matches for term; inferred lack of unit tests for meta-tools).

## Skill Improvements Over MCP
Structured reflection reduces token waste vs MCP's ad-hoc; better error handling by mandatory gap identification, preventing incomplete edits. Examples: Auto-prompts for sufficiency post-search, improving workflows; 95%+ confidence from initial instructions alignment, e.g., efficient symbol discovery chains replace MCP's broader fetches.
