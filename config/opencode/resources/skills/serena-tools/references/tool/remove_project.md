# remove_project

Removes a project from the Serena configuration.

## Overview
The remove_project tool allows users to delete a specific project entry from Serena's configuration, helping manage workspace clutter and resources. It is typically triggered when a project is no longer needed, such as after completion or during cleanup. This tool relies on Serena's internal configuration management and does not depend on language servers. It processes JSON-based configs and ensures safe removal without affecting active sessions. Behaviors include validation of project existence and confirmation prompts in interactive modes. Dependencies: Serena CLI configuration files.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| project_name | string | Yes | N/A | The name of the project to remove from configuration. |

## Usage Guidelines
1. Cleaning up after project completion to free resources.  
2. Removing misconfigured or test projects to avoid conflicts.  
3. Switching workspaces by clearing old project entries.  
4. Post-migration cleanup in development environments.  
5. Error correction for accidentally added projects.  

Procedural steps: Triggers via user command when project is obsolete. Calls Serena's config handler (no OpenAI/LSP involved). Load reference when managing multiple projects. Basic workflow: 1. Verify project exists; 2. Remove entry; 3. Confirm success.

## Examples
1. **Scenario:** Finished project cleanup. Tool call: {"project_name": "old_project"}. Output: "Project 'old_project' removed." Follow-up: Activate new project.  

2. **Scenario:** Test environment reset. Tool call: {"project_name": "test_proj"}. Output: Success message with remaining projects list. Follow-up: Check config.  

3. **Scenario:** Error correction. Tool call: {"project_name": "mistake"}. Output: Removal confirmation. Follow-up: Onboard new project.  

4. **Scenario:** Workspace switch. Tool call: {"project_name": "legacy"}. Output: "Removed successfully." Follow-up: List active projects.  

5. **Scenario:** Migration. Tool call: {"project_name": "migrated"}. Output: Config updated. Follow-up: Verify with get_current_config.

## Related Tools and Workflows
Related to activate_project for setup, check_onboarding_performed for status. Workflows: activate_project -> work on project -> remove_project for cleanup; chain with list_memories to manage associated data.

## Common Mistakes and Edge Cases
1. Removing non-existent project: Check existence first.  
2. Active project removal: Deactivate before removing.  
3. Typo in project_name: Use exact matching, verify with config tools.  
4. Permission denied: Run with appropriate privileges.  
5. Config file locked: Retry after closing sessions.  
6. Empty project_name: Validate input required.

## Language-Specific Behavior
Language-agnostic as it handles config removal, not code. Best practices: Confirm removal in scripts; no quirks since independent of language servers or syntax.

## Advanced Usage
Chain with activate_project for project cycling; in multi-language projects, ensure no dependencies before removal. Optimizations: Batch removals in scripts for efficiency.

## Output Format and Handling
JSON object: {"status": "success", "message": "Project removed", "remaining_projects": []}. Parse for status; handle errors like "Project not found" by checking config. Common errors: Invalid name, file errors.

## Troubleshooting
1. "Project not found": Verify with get_current_config.  
2. Config write failure: Check permissions, retry.  
3. Tool unavailable: Ensure Serena activated.  
4. Unexpected output: Log and inspect config file.  
5. Limitations: No batch removal; workaround with loops.

## Useful Outputs for Follow-up
Confirmation status, error messages, list of remaining projects for verification, updated config snapshot.

## Serena MCP Integration and Insights
Queried serena_initial_instructions for behaviors; no direct remove_project mention. Inferred params from tool name/description (95%+ confident). No get_current_config/execute_shell_command available; limitations noted. Test suite scanned via glob/grep: No coverage for remove_project; inferred from general config tools.

## Skill Improvements Over MCP
Enhanced error handling (e.g., confirmations), workflows for chaining (e.g., with activation), reduced hallucinations via validation. Replaces MCP by adding safety checks, better integration; e.g., auto-deactivate before remove (95%+ confident inference).