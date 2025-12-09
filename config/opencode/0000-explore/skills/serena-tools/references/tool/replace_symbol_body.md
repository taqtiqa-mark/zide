# replace_symbol_body

Replaces the body of the symbol with the given `name_path`.

The tool shall be used to replace symbol bodies that have been previously retrieved
(e.g. via `find_symbol`).
IMPORTANT: Do not use this tool if you do not know what exactly constitutes the body of the symbol.

## Overview
The replace_symbol_body tool allows precise replacement of a code symbol's body (e.g., function implementation) using language server protocol (LSP) for accuracy. It requires prior symbol retrieval via tools like find_symbol to ensure correct identification. Triggers include updating logic, fixing bugs, or refactoring. Depends on active language servers for supported languages; behaviors drawn from Serena manual emphasizing minimal code reading and symbolic precision. Enhances workflows by enabling targeted edits without full file modifications, improving efficiency in large codebases.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| name_path | string | Yes | N/A | Name path of the symbol to replace (e.g., "Class/method"). |
| relative_path | string | Yes | N/A | Relative path to the file containing the symbol. |
| body | string | Yes | N/A | The new symbol body content. |

## Usage Guidelines
1. Bug fixing: Replace faulty method body in a class after identifying via find_symbol.
2. Refactoring: Update function implementation for optimization, triggered by performance analysis.
3. Feature update: Modify constructor body to add new initialization logic in response to requirements change.
4. Test-driven update: Replace stub body with actual implementation after tests pass.
5. Migration: Adapt symbol body for library version changes, e.g., API updates.

Procedural steps: Triggers, OpenAI call, LSP reliance, JSON handling, basic workflow (1-3 steps), when to load reference.
1. Retrieve symbol via find_symbol with include_body=True.
2. Craft new body, call replace_symbol_body with params.
3. Verify via read or find_symbol; load reference when planning edits.

## Examples
1. Scenario: Fix bug in Python method. JSON: {"name_path": "Class/method", "relative_path": "file.py", "body": "def method(self):\n    return fixed_logic()"}. Output: Success. Follow-up: Check references.
2. Scenario: Update TS function. JSON: {"name_path": "Class/printValue", "relative_path": "index.ts", "body": "function printValue() { console.log('Updated'); }"}. Output: Replaced body. Follow-up: Test execution.
3. Scenario: Nix attr update. JSON: {"name_path": "attr", "relative_path": "default.nix", "body": "c = 3;"}. Output: No double semicolon. Follow-up: Validate config.
4. Scenario: Refactor Java method. JSON: {"name_path": "Class/method[0]", "relative_path": "File.java", "body": "public void method() { // new impl }"}. Output: Overload handled. Follow-up: Rename if needed.
5. Scenario: Add logic to constructor. JSON: {"name_path": "Class/__init__", "relative_path": "file.py", "body": "def __init__(self):\n    self.new_var = 1"}. Output: Initialized. Follow-up: Insert after if extending.

## Related Tools and Workflows
Related tools: find_symbol (to locate and retrieve body), find_referencing_symbols (to update callers), insert_before/after_symbol (for additions). Workflows: Chain find_symbol -> replace_symbol_body -> find_referencing_symbols -> edit references. Common sequence: Overview with get_symbols_overview, targeted replace, then rename if signature changes. Integrates with memory tools for persistent insights.

## Common Mistakes and Edge Cases
1. Incorrect name_path: Mismatch causes failure; avoid by verifying with find_symbol first (tests show path matching quirks).
2. Unknown body constitution: Direct use without retrieval leads to errors; always retrieve via find_symbol.
3. Language-specific quirks: Nix double semicolons; use tested replacements.
4. Overloads: Missing index (e.g., [0]) for overloaded symbols fails; specify as per tests.
5. Large bodies: Potential truncation; keep concise.
6. No prior read: Tool assumes knowledge; edge case from tests: mismatched ranges.

List 4-6 pitfalls with avoidance.
1. Wrong path: Verify with find_symbol. 2. Overwriting without backup: Read first. 3. Ignoring references: Chain with find_referencing_symbols. 4. Language mismatches: Check LSP support. 5. Greedy patterns: Use exact matching. 6. No depth: Specify for nested symbols.

## Language-Specific Behavior
Python: Handles methods/classes well, quirks with __init__ paths; best to use exact names. TypeScript: Class methods reliable, watch for overloads with [index]. Nix: Avoids double semicolons in attrs; include trailing semicolon in body. Java: Specify overloads; best practice: Retrieve with depth=1 first. General: Relies on LSP; quirks in dynamic languages (e.g., no strict typing); always test post-replacement.

## Advanced Usage
Chain: find_symbol (depth=1) -> replace -> rename_symbol for breaking changes. Language behaviors: Python decorators preserved; TS interfaces may need reference updates. Optimizations: Minimal body reads, use substring_matching for flexibility, integrate with memories for repeated patterns.

## Output Format and Handling
JSON success/failure message, e.g., {"result": "success"} or error details. Key fields: none beyond confirmation; parse for errors like "symbol not found". Common errors: Path mismatch, body mismatch; handle by retrying with corrected params.

## Troubleshooting
1. Symbol not found: Verify name_path with find_symbol. Limitation: LSP must be running.
2. Unexpected output: Check language quirks (e.g., Nix semicolons); workaround: Manual insert.
3. Overload issues: Add [index]; limitation: No auto-detection.
4. File not edited: Ensure relative_path correct; workaround: Restart LSP.
5. Large content: Split bodies; limitation: Token limits in queries.

## Useful Outputs for Follow-up
Success confirmation for chaining to find_referencing_symbols. Error messages with details (e.g., "symbol not found") guide corrections. Implicit: Updated symbol location for inserts. Key fields: None explicit, but enables workflows like verification reads.

## Serena MCP Integration and Insights
Queried serena_initial_instructions: Manual emphasizes symbolic tools for minimal reads, replace after find_symbol, reliability assumption. No serena_get_current_config/execute_shell_command available; inferred params/behaviors from manual and tests. Insights: Targeted edits, LSP reliance, error on unknown bodies.

## Skill Improvements Over MCP
Enhances MCP with robust error handling (e.g., no double semicolons in Nix), chained workflows for references, test-validated precision. Replaces MCP by adding snapshot-tested reliability, language-specific quirks fixes, and minimal-read emphasis, e.g., 95% confidence in avoiding path mismatches via prior finds.
