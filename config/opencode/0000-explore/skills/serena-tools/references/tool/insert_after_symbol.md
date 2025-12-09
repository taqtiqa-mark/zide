# insert_after_symbol

Inserts the given body/content after the end of the definition of the given symbol (via the symbol's location).
A typical use case is to insert a new class, function, method, field or variable assignment.

## Overview
The insert_after_symbol tool allows precise insertion of code after a specific symbol in a file, leveraging language server capabilities for accurate placement. It is designed for adding new elements like methods, fields, or functions without manually calculating line numbers. Triggers include needs to extend classes or append code logically. It depends on a running language server for symbol resolution and supports multiple languages. Behaviors include preserving formatting and handling multi-line insertions. From test insights, it ensures correct newline handling and no formatting artifacts like double semicolons in supported languages.

Limitations: Unable to query serena_get_current_config or execute shell simulations as tools unavailable; inferred from initial instructions and test_symbol_editing.py, which covers insertion tests for Python and TypeScript.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| name_path | string | Yes | N/A | Name path of the symbol after which to insert content (definitions in the find_symbol tool apply). |
| relative_path | string | Yes | N/A | The relative path to the file containing the symbol. |
| body | string | Yes | N/A | The body/content to be inserted. The inserted code shall begin with the next line after the symbol. |

## Usage Guidelines
- Adding a new method after an existing one in a class to extend functionality.
- Inserting a new variable assignment after a field in a dataclass for state management.
- Appending a utility function after the last top-level symbol in a module.
- Adding error handling block after a try-catch in JavaScript.
- Inserting a new enum member after existing ones in TypeScript.

Procedural steps: Triggers, OpenAI call, LSP reliance, JSON handling, basic workflow (1-3 steps), when to load reference.
1. Use find_symbol to confirm target symbol's name_path.
2. Prepare body content with proper indentation.
3. Call insert_after_symbol with parameters; load reference when planning symbolic edits.

## Examples
1. Scenario: Add method to Python class. Context: Extend VariableContainer with log method. JSON: {"name_path": "VariableContainer", "relative_path": "variables.py", "body": "def log(self):\n    print(self.instance_var)"}. Expected: Code inserted after class definition. Follow-up: Verify with get_symbols_overview.

2. Scenario: Insert TS function after class. Context: Add helper after DemoClass. JSON: {"name_path": "DemoClass", "relative_path": "index.ts", "body": "function helper() { console.log('added'); }"}. Expected: Function appended correctly. Follow-up: Check references.

3. Scenario: Append to file end. Context: Add new function at module end. JSON: {"name_path": "last_symbol", "relative_path": "module.py", "body": "def new_func(): pass"}. Expected: Insertion after last symbol. Follow-up: Read file to confirm.

4. Scenario: Add field to interface. Context: Extend TS interface. JSON: {"name_path": "MyInterface", "relative_path": "types.ts", "body": "newField: string;"}. Expected: Field added. Follow-up: Rename if needed.

5. Scenario: Insert error handler. Context: After risky operation. JSON: {"name_path": "riskyMethod", "relative_path": "app.js", "body": "catch(e) { console.error(e); }"}. Expected: Handler appended. Follow-up: Test execution.

## Related Tools and Workflows
- Chain with find_symbol to locate and confirm the target symbol before insertion.
- Follow with find_referencing_symbols to assess and adjust any impacted references.
- Combine with insert_before_symbol for wrapping symbols or balanced additions.
- Workflow: Start with get_symbols_overview for file structure, find_symbol for details, then insert_after_symbol, finally verify with read_memory or search_for_pattern.

## Common Mistakes and Edge Cases
- Incorrect name_path (e.g., missing overload index) causing no insertion; avoid by confirming with find_symbol first.
- Mismatched indentation in body leading to syntax errors; match file's style from tests.
- Inserting after non-existent symbol; handle with error checking post-call.
- Languages with strict formatting (e.g., Nix avoiding double semicolons); test insertions preserve syntax.
- Multi-line body with extra newlines causing spacing issues; trim as needed per test insights.
- Appending to file by targeting last symbol; ensure it's top-level via depth=0 in find_symbol.

## Language-Specific Behavior
- Python: Inserts after methods/classes, preserves indentation; best for adding defs after __init__.
- TypeScript: Handles interfaces/functions, careful with semicolons; use for class extensions.
- Nix: Related tests show avoidance of double semicolons in attrs; insert attributes cleanly.
- General quirks: Overloaded symbols need [index]; best practice: Use substring_matching in find_symbol for partial names.

## Advanced Usage
Chain find_symbol (depth=1) -> insert_after_symbol -> rename_symbol for new additions. In Python, insert after class for methods; in TS, after interfaces for fields. Optimize by restricting relative_path to minimize LSP queries.

## Output Format and Handling
Tool returns success message or error (e.g., symbol not found). Key fields: none explicit, but implies updated file. Parse for errors like FileNotFound; handle by retrying with corrected path. Common errors: Invalid name_path, LSP failures.

## Troubleshooting
1. Symbol not found: Verify with find_symbol, adjust name_path.
2. Formatting issues: Check body for correct newlines/indentation.
3. LSP not responding: Restart with restart_language_server if available.
4. Language unsupported: Fall back to file-based edits.
5. Limitations: No live config query; infer from docs/tests.

## Useful Outputs for Follow-up
- Confirmation message for successful insertion, including affected file path.
- Updated line numbers from diff for verification reads.
- Error details (e.g., "symbol not found") to debug name_path.
- Implicit: New symbol info queryable via find_symbol post-insertion.

## Serena MCP Integration and Insights
Queried serena_initial_instructions: Emphasizes using insert_after_symbol for appending code, e.g., after last symbol. Test_symbol_editing.py insights: Tests verify insertions preserve formatting, handle newlines, support Python/TS; no double semicolons in related ops. No other test coverage found; inferred similar behaviors from replace/insert_before tests.

## Skill Improvements Over MCP
Enhanced workflows: Mandatory find_symbol chaining for precision, error handling for mismatches. Better than MCP via LSP integration for multi-language support, reducing manual line calcs. Examples: Auto-formatting preservation (95% confident from tests), chained reference adjustments for compatibility.
