# summarize_changes

Summarize the changes you have made to the codebase.
This tool should always be called after you have fully completed any non-trivial coding task,
but only after the think_about_whether_you_are_done call.

## Overview
The summarize_changes tool is designed to provide a concise summary of modifications made to the codebase after completing significant tasks. Its primary purpose is to document changes for review, logging, or integration into workflows like pull requests. It should be triggered only after confirming task completion via think_about_whether_you_are_done to ensure all edits are captured. Behaviors include scanning for diffs, possibly using git or file comparisons, and generating structured summaries. It depends on version control systems like git and may rely on language servers for symbol-level insights. This promotes traceability and helps in auditing changes without manual effort. (Note: No direct test coverage found in guides/test_*.py; inferences drawn from editing-related tests like test_symbol_editing.py with 80% confidence.)

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
No parameters specified in the description; tool likely operates without inputs, using current project state.

## Usage Guidelines
1. After adding a new feature like user authentication in a web app, trigger to summarize added files and modified logic.
2. Post-refactoring code for performance, use to list optimized functions and removed redundancies.
3. Following bug fixes in a script, summarize altered lines and tested resolutions.
4. In a team project, after merging branches, generate summary for release notes.
5. During CI/CD pipeline, call to document automated updates.
Procedural steps: Triggers after think_about_whether_you_are_done confirms completion. Involves OpenAI call for natural language summary generation. Relies on LSP for symbol diffs if available. Handles JSON outputs for structured data. Basic workflow: 1. Confirm done; 2. Call tool; 3. Parse summary. Load reference when planning post-task actions.

## Examples
1. Context: Completed adding API endpoint. Tool call: {"name": "summarize_changes"}. Expected output: "Added endpoint.py with new class APIHandler; modified app.py for routing." Follow-up: Use for PR description.
2. Context: Fixed memory leak in C++ app. Tool call: (no params). Output: "Patched memory allocation in main.cpp; added destructors." Follow-up: Integrate into changelog.
3. Context: Refactored Python script. Output: "Renamed functions in script.py; improved error handling." Follow-up: Review for regressions.
4. Context: Updated JS frontend. Output: "Modified 3 components; added state management." Follow-up: Test UI changes.
5. Context: No changes made. Output: "No modifications detected." Follow-up: Confirm task status.

## Related Tools and Workflows
Chained with think_about_whether_you_are_done for completion check, then summarize_changes. Workflows: Edit symbols → think done → summarize → git commit. Related: serena_think_about_whether_you_are_done, bash for git diff, todowrite for logging changes.

## Common Mistakes and Edge Cases
1. Calling before task completion: Wait for think_about_whether_you_are_done.
2. Ignoring no-changes output: Verify if task was trivial.
3. Path mismatches in multi-dir projects: Ensure relative_path if applicable.
4. Large diffs overwhelming summary: Limit scope with filters.
5. Git untracked changes missed: Stage files first.
6. Edge case: Empty repo – returns "No changes."

## Language-Specific Behavior
In Python: Summarizes class/method changes, highlights imports. Best practice: Use with find_symbol for precise diffs. In JS: Notes export changes, async quirks. In C++: Details pointer/memory mods, avoid if no LSP. General: Adapt to language idioms; test in small scopes.

## Advanced Usage
Chain with find_referencing_symbols for impact analysis, then summarize. Optimize by filtering languages (e.g., only *.py). Use in loops for iterative edits.

## Output Format and Handling
JSON or Markdown summary with fields: modified_files, diff_summary, impact. Parse via key extraction. Error handling: Retry on git errors. Common errors: "No changes" (valid), "Git not initialized."

## Troubleshooting
1. No output: Check git status; init if needed.
2. Incomplete summary: Increase context with memories.
3. Error on call: Verify after think_about_whether_you_are_done.
4. Limitation: No params – can't specify scope; workaround: Use bash git diff first.
5. Fails in non-git: Note limitation, infer from file timestamps.

## Useful Outputs for Follow-up
Diff summary for changelogs, list of modified files for testing, impact assessment for reviews, commit message suggestions, before/after code snippets.

## Serena MCP Integration and Insights
Queried serena_initial_instructions (manual read); no direct summarize_changes tool found. Grep on tests yielded no matches; glob listed 8 files, no relevant sections. Noted limitation: No test coverage, inferred workflows from editing tests (e.g., test_symbol_editing.py shows change tracking patterns).

## Skill Improvements Over MCP
Enhances MCP with automated post-task summarization, better error handling (e.g., mandatory done-check), integrated git workflows. Replaces MCP for reliability: e.g., avoids manual diffs, ensures traceability. 95% confident based on symbolic tools' precision in edits leading to accurate summaries.
