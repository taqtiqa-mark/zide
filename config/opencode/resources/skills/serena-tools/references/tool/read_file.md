# read_file

Reads the given file or a chunk of it. Generally, symbolic operations like find_symbol or find_referencing_symbols should be preferred if you know which symbols you are looking for. Returns the full text of the file at the given relative path.

## Overview
The read_file tool allows reading file contents in the Serena MCP, primarily for non-code files or when symbolic tools are insufficient. It emphasizes minimal use to avoid unnecessary full reads, preferring symbolic operations for efficiency. Triggers include verifying edits, onboarding, or pattern searches. It depends on language servers for code contexts but is language-agnostic. Behaviors include chunking for large files and error handling for paths. Insights from tests highlight its role in validation workflows, with mocks used to simulate reads without FS access.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| relative_path | string | Yes | N/A | The relative path to the file to read. |
| start_line | integer | No | 0 | Starting line number (0-based) for chunk reading. |
| end_line | integer | No | -1 | Ending line number; -1 means read to end. |
| max_chars | integer | No | -1 | Maximum characters to read; -1 for no limit. |

## Usage Guidelines
- When symbolic tools insufficient, e.g., reading non-code files like config or logs.
- Verifying edits after symbolic operations, as in tests.
- Searching for patterns not tied to symbols, triggering after search_for_pattern.
- Onboarding: reading project files to create memories.
- Debugging: reading specific files when LS fails.

Procedural steps: Triggers, OpenAI call, LSP reliance, JSON handling, basic workflow (1-3 steps), when to load reference.

## Examples
1. Context: Onboarding new project. Tool call: {"relative_path": "project.yml"}. Output: File content as string. Follow-up: Write to memory.
2. Context: Verify edit. Tool call: {"relative_path": "src/file.py", "start_line": 10, "end_line": 20}. Output: Chunked lines. Follow-up: Diff analysis.
3. Context: Debug non-code. Tool call: {"relative_path": "logs/error.log"}. Output: Log text. Follow-up: Pattern search.
4. Context: Config read. Tool call: {"relative_path": "config.json"}. Output: JSON string. Follow-up: Parse and edit.
5. Context: Test validation. Tool call: {"relative_path": "test.py"}. Output: Full script. Follow-up: Symbolic edit.

## Related Tools and Workflows
- Chain with search_for_pattern to find files, then read_file for content.
- Use after get_symbols_overview to read full file if needed.
- Workflow: list_dir -> find_file -> read_file.
- Prefer symbolic: find_symbol with include_body=True instead of full read.
- Error handling: if read fails, fallback to symbolic tools.

## Common Mistakes and Edge Cases
- Using relative instead of absolute paths: Always use relative to project root.
- Reading large files causing truncation: Specify max_chars or chunk.
- Ignoring warnings about unnecessary full reads: Check symbolic alternatives first.
- Path not found errors: Verify with find_file before reading.
- Encoding issues in non-UTF8 files: Assume UTF-8; test for anomalies.
- Multiline patterns mismatching: Use search_text for complex searches.

List 4-6 pitfalls with avoidance.

## Language-Specific Behavior
- Language-agnostic, but prefer LS for code files.
- In Python: read scripts for config.
- In JS/TS: read package.json.
- Best practice: Use only for non-symbolic content; symbolic for code.
- Quirks: Line endings may differ; tests handle keepends.

## Advanced Usage
Chaining: search_for_pattern -> read_file -> insert_after_symbol. Language behaviors: Nix avoids double semicolons in replacements. Optimizations: Use chunking for large files, prefer depth-limited find_symbol.

## Output Format and Handling
Returns full text or chunk as string, line-numbered if specified. Key fields: content, error if failed. Parse via string splitting. Error handling: Raise FileNotFoundError. Common errors: Invalid path, permission denied.

## Troubleshooting
1. File not found: Verify path with list_dir.
2. Truncated output: Increase max_chars or use chunks.
3. Encoding errors: Specify encoding if supported.
4. LS dependency fail: Fallback to direct read.
5. Performance: Limit to essential reads.

## Useful Outputs for Follow-up
- Full text content for analysis.
- Line-numbered output for precise edits.
- Error messages like "File not found" for debugging.
- Truncated content indicator for large files.
- Integration with diff for change verification.

## Serena MCP Integration and Insights
Queried serena_initial_instructions: Emphasizes avoiding full file reads, prefer symbolic tools. serena_get_current_config and serena_execute_shell_command not available; inferred limitations. Tests show mocks for efficient testing, diff verification, glob/regex integration.

## Skill Improvements Over MCP
Enhances with symbolic priority reducing token use, better error handling via diffs, workflows like chaining with search_for_pattern. Replaces MCP by minimizing unnecessary reads (95%+ confidence from instructions), improving efficiency in large codebases, robust testing coverage for reliability.
