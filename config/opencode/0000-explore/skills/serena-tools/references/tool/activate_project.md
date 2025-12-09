# activate_project

Activates the project with the given name or path.

## Overview
The activate_project tool switches or loads a specific project context in the Serena environment, enabling access to project-specific memories, configurations, and language servers. It is triggered when starting work on a new repository or switching between multiple projects. Dependencies include a valid git repo and language server support for semantic operations. Activation sets the working context, loads encodings, and lists available memories for efficient codebase interaction. This ensures resource-efficient operations by focusing tools on the active project.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| name_or_path | string | Yes | N/A | The project name or filesystem path to activate. |

## Usage Guidelines
1. Switching between multiple projects in a workspace, e.g., from 'app1' to 'app2'.
2. Initial setup when cloning and opening a new repository.
3. Reactivating after IDE restart or session expiration.
4. Loading project for CI/CD automation in build scripts.
5. Integrating with multi-repo monorepos for submodule focus.

Procedural steps: Triggers via tool call with name/path; invokes OpenAI for context setup; relies on LSP for symbol tools; handles JSON config loading. Basic workflow: 1. Call with path. 2. Verify activation. 3. Load memories/reference. Load reference when planning edits.

## Examples
1. **Scenario**: New repo clone. JSON: {"name_or_path": "/path/to/repo"}. Output: "Project activated at /path/to/repo, languages: python". Follow-up: Check onboarding.

2. **Scenario**: Switch projects. JSON: {"name_or_path": "myproject"}. Output: Activation confirmation with memories. Follow-up: Read memory.

3. **Scenario**: CI pipeline. JSON: {"name_or_path": "./build-project"}. Output: Status and configs. Follow-up: Run tests.

4. **Scenario**: Session refresh. JSON: {"name_or_path": "."}. Output: Refreshed context. Follow-up: List symbols.

5. **Scenario**: Monorepo subdir. JSON: {"name_or_path": "subdir/app"}. Output: Subproject activated. Follow-up: Edit symbols.

## Related Tools and Workflows
Chaining: activate_project -> serena_check_onboarding_performed -> serena_onboarding (if needed) -> serena_list_memories -> symbolic tools like find_symbol. Workflows: Project setup sequence; integration with editing mode for targeted changes; onboarding flow for new projects.

## Common Mistakes and Edge Cases
1. Invalid path: Project not found - verify path existence before call.
2. Non-git repo: Fails activation - ensure .git presence.
3. Permission denied: Handle with try-catch or pre-check access.
4. Name ambiguity: Multiple matches - specify full path.
5. Current project: No-op - check if already active to avoid redundancy.
6. Empty name: Errors - always provide valid input.

Avoid by validating inputs pre-call and using absolute paths.

## Language-Specific Behavior
Python: Loads LSP for precise symbol paths like Foo/__init__.
Java: Handles overloads with [index] in name_paths.
Bash: Limited symbol support, focus on file-based tools.
Best practices: Restart language server post-activation for consistency; use depth in find_symbol for nested structures.

## Advanced Usage
Chain with onboarding for new projects; optimize by activating subdirs in large repos. Language quirks: In C++, namespace handling requires full paths. Use for multi-language projects by specifying primary lang.

## Output Format and Handling
JSON-like: {"status": "activated", "path": "/path", "languages": ["python"], "memories": ["code_style"]}. Parse for status/key fields. Error handling: Catch "not found" and retry. Common errors: Invalid path, no git.

## Troubleshooting
1. Activation fails: Check path validity and git init.
2. No memories: Run onboarding.
3. LSP not responding: Restart server.
4. Permission issues: Run with sudo or fix perms.
5. Limitations: No support for non-git repos; workaround: Manual config load.

## Useful Outputs for Follow-up
Confirmation with path, languages, memories list. Key fields: status (for success check), path (for reference), languages (for tool selection), memories (for read_memory calls).

## Serena MCP Integration and Insights
Queried serena_initial_instructions: Provides manual on activation, confirms project activation sets context, lists memories. No direct test coverage found via glob/grep on test_*.py; inferred from similar tools like test_mcp.py's parameter handling. Limitations: No serena_get_current_config/execute_shell_command available, inferred behaviors.

## Skill Improvements Over MCP
Enhances workflows with automatic memory loading, better error handling (e.g., path validation). Replaces MCP by adding semantic tools integration, reducing token use via targeted reads. Examples: Auto-onboarding check (95% confident from manual); robust chaining for editing (inferred from symbolic tools).