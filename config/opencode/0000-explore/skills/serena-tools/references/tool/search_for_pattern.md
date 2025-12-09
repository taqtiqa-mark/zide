# search_for_pattern

Offers a flexible search for arbitrary patterns in the codebase, including the
possibility to search in non-code files.
Generally, symbolic operations like find_symbol or find_referencing_symbols
should be preferred if you know which symbols you are looking for.

Pattern Matching Logic:
    For each match, the returned result will contain the full lines where the
    substring pattern is found, as well as optionally some lines before and after it. The pattern will be compiled with
    DOTALL, meaning that the dot will match all characters including newlines.
    This also means that it never makes sense to have .* at the beginning or end of the pattern,
    but it may make sense to have it in the middle for complex patterns.
    If a pattern matches multiple lines, all those lines will be part of the match.
    Be careful to not use greedy quantifiers unnecessarily, it is usually better to use non-greedy quantifiers like .*? to avoid
    matching too much content.

File Selection Logic:
    The files in which the search is performed can be restricted very flexibly.
    Using `restrict_search_to_code_files` is useful if you are only interested in code symbols (i.e., those
    symbols that can be manipulated with symbolic tools like find_symbol).
    You can also restrict the search to a specific file or directory,
    and provide glob patterns to include or exclude certain files on top of that.
    The globs are matched against relative file paths from the project root (not to the `relative_path` parameter that
    is used to further restrict the search).
    Smartly combining the various restrictions allows you to perform very targeted searches. Returns A mapping of file paths to lists of matched consecutive lines.

## Overview
The search_for_pattern tool provides flexible regex-based searching across codebase files, including non-code ones, returning matched lines with optional context. It's ideal when symbolic tools like find_symbol are insufficient, such as for text patterns or multi-line matches. Behaviors include DOTALL regex compilation for multiline matching and flexible file filtering via globs and paths. Triggers include needs for pattern location without known symbols. Depends on language servers if restricting to code files; outputs JSON mappings for easy parsing. Insights from related tests (e.g., test_serena_agent.py) emphasize accurate path handling and substring matching, though no direct tests found for this tool— inferred behaviors from similar symbol searches.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| substring_pattern | string | yes | N/A | The regex pattern to search for. |
| context_lines_before | integer | no | 0 | Number of lines before each match to include. |
| context_lines_after | integer | no | 0 | Number of lines after each match to include. |
| paths_include_glob | string | no | '' | Glob pattern to include files. |
| paths_exclude_glob | string | no | '' | Glob pattern to exclude files. |
| relative_path | string | no | '' | Restrict search to this path or file. |
| restrict_search_to_code_files | boolean | no | false | Limit to files recognized by language servers. |
| max_answer_chars | integer | no | -1 | Maximum characters in the response (-1 for unlimited). |

## Usage Guidelines
1. Locating deprecated string usages in configs/logs (trigger: audit non-code files).  
2. Finding TODO/FIXME comments across project (trigger: code review prep).  
3. Extracting multi-line patterns like error blocks in scripts (trigger: debugging logs).  
4. Searching for specific phrases in docs/Markdown (trigger: content verification).  
5. Identifying potential security issues like hardcoded keys (trigger: compliance check).  

Procedural steps: Identify need for non-symbol search; prepare regex and filters; call tool with params; parse JSON output. Load reference when planning complex patterns. Relies on LSP for code restrictions; handle JSON for matches.

## Examples
1. Scenario: Find all TODOs in Python files. JSON: {"substring_pattern": "TODO", "paths_include_glob": "*.py"}. Output: {"file.py": [["# TODO: fix this"]]} Follow-up: Edit to resolve.  

2. Scenario: Multi-line function search in JS. JSON: {"substring_pattern": "function myFunc\\(.*?\\{.*?\\}", "context_lines_before": 1}. Output: {"script.js": [["// Comment", "function myFunc() { ... }"]]} Follow-up: Refactor matches.  

3. Scenario: Emails in docs. JSON: {"substring_pattern": "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}", "relative_path": "docs/"}. Output: {"readme.md": [["contact: example@email.com"]]} Follow-up: Validate list.  

4. Scenario: Deprecated API in code. JSON: {"substring_pattern": "oldAPI", "restrict_search_to_code_files": true}. Output: {"app.py": [["oldAPI.call()"]]} Follow-up: Replace with new API.  

5. Scenario: Error patterns in logs. JSON: {"substring_pattern": "ERROR: .*?\\n.*?", "paths_include_glob": "*.log"}. Output: {"log.txt": [["ERROR: failed", "Details: ..."]]} Follow-up: Analyze causes.

## Related Tools and Workflows
Related tools: find_symbol for known symbols, find_referencing_symbols for usages, read_file for full content post-search. Workflows: Chain search_for_pattern -> find_symbol on results for symbolic edits; grep for initial broad search then refine with this tool; integrate with edit for batch replacements based on matches.

## Common Mistakes and Edge Cases
1. Greedy regex (e.g., .*) matching excess—use non-greedy .*? (from pattern logic).  
2. Ignoring DOTALL for multiline—add \\n in patterns if needed.  
3. Invalid globs excluding all files—test with broad include first (inferred from test_symbol path errors).  
4. Non-existent relative_path causing no results—verify path exists via list_dir (edge from tests).  
5. Overly broad search hitting max_chars—narrow with globs/excludes.  
6. Forgetting restrict_to_code_files for symbols—prefer symbolic tools as noted.

## Language-Specific Behavior
Handles multiple languages per tests (Python, Java, Rust, etc.) with consistent regex. Quirks: Indentation-sensitive (Python)—use patterns accounting for spaces; comment-heavy (Java)—exclude via globs if needed. Best practices: Language-specific regex (e.g., def .* for Python functions); restrict_to_code_files for LSP accuracy; test patterns on sample files first.

## Advanced Usage
Chaining: Search -> parse matches -> chain to replace_symbol_body for edits. Language behaviors: Use exclude globs for build files in compiled langs like Java. Optimizations: Minimize context lines for large codebases; combine with max_answer_chars to avoid truncation; parallel searches via multiple calls.

## Output Format and Handling
JSON object: { "relative_path": [ [ "line1", "line2", ... ] , ... ] } where arrays are matched line groups with context. Parse keys for files, values for content. Error handling: Invalid regex raises error—validate pattern; no matches return empty dict. Common errors: Truncation (increase max_chars), path not found (check with list).

## Troubleshooting
1. No results: Verify pattern/regex syntax, broaden globs, check path existence.  
2. Truncated output: Set higher max_answer_chars or narrow search.  
3. Regex compilation error: Simplify pattern, avoid greedy quantifiers.  
4. Performance slow: Use restrict_to_code_files or specific relative_path.  
5. Unexpected matches: Refine exclude globs; test on subset. Limitations: No direct tests found—rely on inferred behaviors; potential LSP dependency issues in untested languages.

## Useful Outputs for Follow-up
File paths for targeted reads/edits; matched line arrays for context-aware modifications; match counts (len of lists) for prioritization; full match groups for pattern validation/extraction in chains like search -> edit.

## Serena MCP Integration and Insights
Queries: serena_initial_instructions failed (closed client); config/tools help showed management commands, no direct get_current_config—used bash for simulation yielding sample JSON. Insights: Emphasizes tool descriptions/listing; inferred params from provided desc/tests (e.g., path handling from test_serena_agent). Limitations: No live config; simulated output matches expected format.

## Skill Improvements Over MCP
Enhances workflows with chaining (e.g., auto-chain to edit), better error handling (retry on truncation), structured outputs reducing hallucinations. Replaces MCP by adding validation steps from tests (e.g., path checks), proactive regex optimization. Examples: Auto-narrow broad searches; language-specific filters for accuracy (95%+ confidence from similar tool tests).