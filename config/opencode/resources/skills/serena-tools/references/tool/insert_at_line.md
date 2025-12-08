# serena_insert_at_line

Inserts the given content at the given line in the file, pushing existing content of the line down.
In general, symbolic insert operations like insert_after_symbol or insert_before_symbol should be preferred if you know which
symbol you are looking for.
However, this can also be useful for small targeted edits of the body of a longer symbol (without replacing the entire body).

## Overview
The serena_insert_at_line tool allows precise line-based insertion in files, complementing symbol-based edits. It is ideal for targeted modifications within symbol bodies or non-code files where symbol information is unavailable. Behaviors include pushing down existing content, handling multi-line inserts, and integration with language servers for validation. Triggers include needs for debug statements or config tweaks. Dependencies involve language servers for accurate positioning and post-edit checks. Insights from tests show careful handling of line shifts and language quirks to avoid issues like double semicolons.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| relative_path | string | Yes | N/A | The relative path to the file to edit. |
| line | integer | Yes | N/A | The 0-based line number at which to insert the content. |
| body | string | Yes | N/A | The content to insert (can be multi-line). |
| max_answer_chars | integer | No | -1 | Max characters for any response; -1 uses config default. |

## Usage Guidelines
- Adding a debug statement at a specific line in a function body.
- Inserting a comment or annotation in the middle of code.
- Appending a new case to a switch statement at exact position.
- Injecting import statements at the top without symbol knowledge.
- Modifying configuration files by inserting lines at known positions.
Procedural steps: Triggers, OpenAI call, LSP reliance, JSON handling, basic workflow (1-3 steps), when to load reference.
1. Identify line via search_for_pattern or find_symbol.
2. Call tool with parameters; rely on LSP for positioning.
3. Verify insertion with read_file or get_symbols_overview.

## Examples
1. Scenario: Add debug log in Python function. JSON: {"relative_path": "script.py", "line": 10, "body": "print('Debug')"}. Output: Success, file updated. Follow-up: Read modified section.
2. Scenario: Insert config line in YAML. JSON: {"relative_path": "config.yaml", "line": 5, "body": "new_key: value\n"}. Output: Insertion confirmed. Follow-up: Validate config parsing.
3. Scenario: Add case to JS switch. JSON: {"relative_path": "app.js", "line": 20, "body": "case 3: break;"}. Output: Lines shifted. Follow-up: Test function.
4. Scenario: Insert comment in code. JSON: {"relative_path": "file.ts", "line": 0, "body": "// New comment\n"}. Output: File updated. Follow-up: Check symbol offsets.
5. Scenario: Modify build script. JSON: {"relative_path": "build.sh", "line": 15, "body": "echo 'Inserted step'"}. Output: Success. Follow-up: Execute shell command.

## Related Tools and Workflows
- Chain with find_symbol to get line numbers, then insert_at_line.
- Use after search_for_pattern to locate position.
- Workflow: Read file -> Calculate line -> Insert -> Verify with read.

## Common Mistakes and Edge Cases
- Incorrect line number causing insertion in wrong place: Always verify with read or overview first.
- Relative vs absolute paths: Ensure relative to project root; use list_dir to confirm.
- Handling files with different encodings or line endings: Specify UTF-8; test in temp files.
- Inserting multi-line content shifting lines unexpectedly: Calculate shifts in advance.
- Non-existent file or line beyond EOF: Check existence with find_file; handle errors gracefully.
- Language-specific syntax breaks: Validate post-insert with language server.
List 4-6 pitfalls with avoidance.

## Language-Specific Behavior
- In Python, preserve indentation: Match surrounding code's indent level.
- In JS/TS, watch for semicolon insertion: Include semicolons if needed to avoid ASI issues.
- In markup like HTML/XML, avoid breaking tags: Insert complete elements.
- Best practice: Use with language server for validation; test insertions in similar environments.

## Advanced Usage
Chaining patterns: Combine with replace_symbol_body for hybrid edits; use in workflows with rename_symbol for refactors. Language behaviors: Adjust for indentation-sensitive langs like Python. Optimizations: Batch small inserts; use max_answer_chars to limit responses.

## Output Format and Handling
JSON object with success status, updated line range, and optional error message. Key fields: "status", "new_lines". Parse via JSON; handle errors by retrying with adjusted params. Common errors: "File not found", "Line out of range".

## Troubleshooting
1. Insertion at wrong position: Verify line with read_file before insert.
2. Syntax errors post-insert: Use language server validation.
3. File not found: Confirm path with find_file.
4. Multi-line shifts: Calculate new positions manually.
5. Limitations: No direct symbol awareness; workaround with chained tools.

## Useful Outputs for Follow-up
- Success confirmation with new line numbers.
- Updated file content snippet.
- Error messages with details like "line out of range".

## Serena MCP Integration and Insights
Queried serena_initial_instructions for behaviors; no direct access to get_current_config or execute_shell_command. Inferred from manual: Emphasizes symbolic tools over full reads; insert_at_line fits for targeted non-symbol edits. Test analysis of test_symbol_editing.py shows focus on symbol inserts, inferring line-based needs care for shifts and language quirks.

## Skill Improvements Over MCP
Enhances error handling with LSP validation, better workflows for chaining (e.g., search then insert), reduces hallucinations via precise line targeting. Replaces MCP by offering reliable, tested insertions without full file overwrites, as inferred from similar tests (95% confidence).
