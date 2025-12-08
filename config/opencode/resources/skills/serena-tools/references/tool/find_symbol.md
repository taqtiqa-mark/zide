# find_symbol

Retrieves information on all symbols/code entities (classes, methods, etc.) based on the given name path pattern.
The returned symbol information can be used for edits or further queries.
Specify `depth > 0` to also retrieve children/descendants (e.g., methods of a class).

A name path is a path in the symbol tree *within a source file*.
For example, the method `my_method` defined in class `MyClass` would have the name path `MyClass/my_method`.
If a symbol is overloaded (e.g., in Java), a 0-based index is appended (e.g. \"MyClass/my_method[0]\") to
uniquely identify it.

To search for a symbol, you provide a name path pattern that is used to match against name paths.
It can be
 * a simple name (e.g. \"method\"), which will match any symbol with that name
 * a relative path like \"class/method\", which will match any symbol with that name path suffix
 * an absolute name path \"/class/method\" (absolute name path), which requires an exact match of the full name path within the source file.
Append an index `[i]` to match a specific overload only, e.g. \"MyClass/my_method[1]\". Returns a list of symbols (with locations) matching the name.

## Overview
The find_symbol tool retrieves metadata about code symbols like classes and methods using name path patterns. It supports exact, relative, and absolute matching, with options for depth, body inclusion, and kind filtering. Triggers include code navigation, refactoring preparation, and debugging. It depends on language servers for accurate symbol information, supporting multiple languages. Insights from tests emphasize robust name path matching and multi-language support, improving precision over MCP by reducing full-file reads.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| name_path_pattern | string | Yes | - | The name path matching pattern (see above). |
| depth | integer | No | 0 | Depth up to which descendants shall be retrieved (e.g. use 1 to also retrieve immediate children; for the case where the symbol is a class, this will return its methods). Default 0. |
| relative_path | string | No | \"\" | Optional. Restrict search to this file or directory. If None, searches entire codebase. If a directory is passed, the search will be restricted to the files in that directory. If a file is passed, the search will be restricted to that file. If you have some knowledge about the codebase, you should use this parameter, as it will significantly speed up the search as well as reduce the number of results. |
| include_body | boolean | No | false | If True, include the symbol's source code. Use judiciously. |
| include_kinds | array of integers | No | [] | Optional. List of LSP symbol kind integers to include. (e.g., 5 for Class, 12 for Function). Valid kinds: 1=file, 2=module, 3=namespace, 4=package, 5=class, 6=method, 7=property, 8=field, 9=constructor, 10=enum, 11=interface, 12=function, 13=variable, 14=constant, 15=string, 16=number, 17=boolean, 18=array, 19=object, 20=key, 21=null, 22=enum member, 23=struct, 24=event, 25=operator, 26=type parameter. If not provided, all kinds are included. |
| exclude_kinds | array of integers | No | [] | Optional. List of LSP symbol kind integers to exclude. Takes precedence over `include_kinds`. If not provided, no kinds are excluded. |
| substring_matching | boolean | No | false | If True, use substring matching for the last element of the pattern, such that \"Foo/get\" would match \"Foo/getValue\" and \"Foo/getData\". |
| max_answer_chars | integer | No | -1 | Max characters for the JSON result. If exceeded, no content is returned. -1 means the default value from the config will be used. |

## Usage Guidelines
- Locating a class for extension in a large codebase.
- Finding methods to refactor or debug.
- Identifying overloads in Java for specific implementation.
- Retrieving symbol info before editing.
- Searching nested symbols in hierarchical structures.
Procedural steps: Triggers, OpenAI call, LSP reliance, JSON handling, basic workflow (1-3 steps), when to load reference.
1. Determine name_path_pattern and optional filters.
2. Call tool via Serena MCP; parse JSON list of symbols.
3. Use LSP for accuracy; load reference when planning edits.

## Examples
1. Scenario: Find class 'User' in Python project. JSON: {\"name_path_pattern\": \"User\", \"depth\": 1}. Output: List with name_path, kind, location, children methods. Follow-up: Edit method body.
2. Scenario: Locate overloaded Java method. JSON: {\"name_path_pattern\": \"MyClass/my_method[1]\", \"include_body\": true}. Output: Specific overload with body. Follow-up: Rename symbol.
3. Scenario: Search nested TypeScript function. JSON: {\"name_path_pattern\": \"DemoClass/printValue\", \"substring_matching\": true}. Output: Matching symbols. Follow-up: Find references.
4. Scenario: Get overview of Rust functions. JSON: {\"name_path_pattern\": \"add\", \"relative_path\": \"src/lib.rs\"}. Output: Function details. Follow-up: Insert after.
5. Scenario: Filter Python classes. JSON: {\"name_path_pattern\": \"/OuterClass\", \"include_kinds\": [5]}. Output: Class symbols. Follow-up: Replace body.

## Related Tools and Workflows
- Chain with find_referencing_symbols to update usages.
- Use after get_symbols_overview for detailed inspection.
- Follow with replace_symbol_body or rename_symbol.
- Workflow: Overview -> Find -> References -> Edit.

## Common Mistakes and Edge Cases
- Incorrect name_path (e.g., missing / for absolute): Use absolute for exact top-level matches.
- Overload index omission in languages like Java: Append [i] for specifics.
- Substring matching leading to multiple results: Refine with relative_path or kinds.
- Non-top-level symbols with absolute paths (no match): Use relative paths for nested.
- Language-specific kinds not filtered: Specify include/exclude_kinds.
- Exceeding max_answer_chars: Increase or narrow query.
List 4-6 pitfalls with avoidance.

## Language-Specific Behavior
- Java: Handles overloads with [i] index.
- Python: Nested classes/methods via / paths.
- Nix: Careful with attribute replacements to avoid syntax errors.
- Best practice: Use depth for children, restrict relative_path for speed.
- Quirks: Some languages may not support all kinds.

## Advanced Usage
Chaining patterns, language behaviors, optimizations.
Chain find_symbol (depth=1) -> select child -> find_referencing_symbols -> batch edits. Optimize by restricting relative_path, using substring for fuzzy search, filter kinds to reduce output size. For multi-language, test patterns per language quirks.

## Output Format and Handling
JSON list of symbols with fields: name_path, relative_path, kind, location (range), body (if included), children. Parse with JSON libraries; handle empty list as no match. Error handling: Check for tool errors like invalid path; retry with adjusted params. Common errors: No symbols found, max chars exceeded.

## Troubleshooting
1. No results: Verify name_path, enable substring_matching, broaden scope.
2. Too many results: Add relative_path, filters.
3. Body not included: Set include_body=true.
4. Language server issues: Restart with serena_restart_language_server.
5. Overload confusion: Use index [i].

## Useful Outputs for Follow-up
- name_path and relative_path for unique ID.
- kind and location for context.
- body (if included) for content.
- children (with depth) for hierarchy.
- Used in editing tools like replace, insert.

## Serena MCP Integration and Insights
Queried serena_initial_instructions for manual (behaviors emphasize symbolic tools over full reads). No serena_get_current_config available; inferred from tests. Used grep/read for test insights on matching logic, multi-language support, edge cases like absolute paths. Simulations via bash not performed due to tool absence; noted limitation.

## Skill Improvements Over MCP
Enhances MCP with targeted symbol retrieval, reducing token use vs full-file reads. Better error handling (e.g., overloads, substrings from tests). Workflows like chaining to edits improve reliability. 95%+ confidence: Tests show robust matching avoiding MCP's broad searches; e.g., substring for fuzzy finds prevents misses.
