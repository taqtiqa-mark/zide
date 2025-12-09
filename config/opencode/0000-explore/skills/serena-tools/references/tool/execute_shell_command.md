# execute_shell_command

Execute a shell command and return its output. If there is a memory about suggested commands, read that first.
Never execute unsafe shell commands!
IMPORTANT: Do not use this tool to start
  * long-running processes (e.g. servers) that are not intended to terminate quickly,
  * processes that require user interaction. Returns a JSON object containing the command's stdout and optionally stderr output.

## Overview
The execute_shell_command tool allows safe execution of shell commands within the Serena environment, primarily for tasks like checking system state, installing dependencies, or running tests. It emphasizes safety by prohibiting unsafe or interactive commands and encourages checking memories for suggested commands first. Behaviors include returning JSON with stdout/stderr, and it's triggered when needing to interact with the filesystem or run utilities without direct tool support. It depends on the underlying shell and may rely on language servers for context in code-related commands. Insights from tests show no direct coverage, limiting specific error handling knowledge; inferred from similar task executors emphasizing exception handling and cancellation.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| command | string | Yes | N/A | The shell command to execute. |
| timeout | number | No | None | Optional timeout in seconds for command execution. |

## Usage Guidelines
1. Verifying git repository status before commits.  
2. Installing project dependencies (e.g., pip install -r requirements.txt).  
3. Running unit tests with pytest.  
4. Checking disk space with df -h.  
5. Compiling source code using make.  
Procedural steps: Triggers, OpenAI call, LSP reliance, JSON handling, basic workflow (1-3 steps), when to load reference.

## Examples
1. Context: Check git status. Tool call: {"command": "git status"}. Expected: JSON with stdout showing changes. Follow-up: Analyze changes for commit.  
2. Context: Install npm packages. Tool call: {"command": "npm install"}. Expected: JSON with installation log. Follow-up: Verify package.json updates.  
3. Context: Run tests. Tool call: {"command": "pytest tests/"}. Expected: JSON with test results. Follow-up: Fix failing tests.  
4. Context: List files. Tool call: {"command": "ls -la"}. Expected: JSON with directory listing. Follow-up: Read specific file.  
5. Context: Check memory. Tool call: {"command": "free -h"}. Expected: JSON with memory usage. Follow-up: Optimize resource-heavy processes.

## Related Tools and Workflows
Related tools: bash (for persistent sessions), list (for directory listing), read (for file content). Workflows: Chain with grep for searching outputs, or follow with edit based on command results (e.g., git status -> edit files -> git commit). Common sequence: execute_shell_command -> parse JSON -> conditional tool calls.

## Common Mistakes and Edge Cases
No direct test coverage; inferred from similar executors.  
1. Running interactive commands (e.g., vim) - avoid by checking non-interactive.  
2. Long-running processes - use timeout to prevent hangs.  
3. Unsafe commands (e.g., rm -rf) - prohibit per guidelines.  
4. Path issues (absolute vs relative) - use absolute paths.  
5. Timeout not set for slow commands - always specify.  
6. Ignoring memories - always read suggested commands first.

## Language-Specific Behavior
In Bash/Python: Handles stdout/stderr well, but watch for encoding quirks (use UTF-8). Java: May need classpath setup in command. JavaScript: npm commands reliable, but async outputs might truncate. Best practices: Quote paths, handle errors in JSON, test in safe env. Quirks: Windows vs Linux line endings in outputs.

## Advanced Usage
Chain with grep on output for pattern matching, or use in loops for batch processing (e.g., multiple installs). Optimize by minimizing commands via combined ops (e.g., &&). Language behaviors: Python subprocess quirks with env vars; ensure cross-platform commands.

## Output Format and Handling
JSON object: {"stdout": "output text", "stderr": "error text" (optional)}. Parse with JSON libraries, handle missing stderr as success. Error handling: Check for non-empty stderr. Common errors: Timeout exceeded, command not found.

## Troubleshooting
1. Command fails: Verify syntax and permissions.  
2. No output: Check if command produces stdout.  
3. Timeout: Increase timeout or optimize command.  
4. Unsafe rejection: Rewrite to safe alternative.  
5. Limitations: No interactive support; use non-interactive equivalents.

## Useful Outputs for Follow-up
Stdout for parsing results (e.g., test passes), stderr for error diagnosis. Key fields: stdout (primary data), stderr (issues). Use for conditional logic, like if no errors, proceed to next tool.

## Serena MCP Integration and Insights
Queried serena_initial_instructions: Manual emphasizes safe, efficient tool use, modes (planning, editing), prioritize symbolic tools over full reads. No direct info on execute_shell_command. Queries for serena_get_current_config and serena_execute_shell_command failed (tools unavailable). Limitations: Inferred behaviors from general guidelines; no live simulations.

## Skill Improvements Over MCP
Skills offer structured workflows (e.g., mandatory memory checks), better error handling (exception propagation), cancellation support. Replaces MCP by adding safety filters, JSON outputs for parsing, integration with memories for suggestions. Examples: Prevents unsafe commands, handles timeouts natively (95% confident from similar tools).