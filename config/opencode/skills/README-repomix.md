# OpenCode Skill for Repomix

A comprehensive OpenCode skill that teaches the LLM AI how to use repomix effectively for packing and exploring codebases in AI-friendly formats.

## What is This?

This is a [OpenCode](https://opencode.ai) skill - a markdown-based instruction set that teaches AI how to use repomix. While the repomix-explorer plugin provides agents and tools for basic operations, this skill complements it by teaching the **philosophy and patterns** of effective repomix usage, including efficient packing, analysis delegation, and token management.

## What Does It Provide?

**Main skill file:**
- Core workflow patterns (packing, exploration, analysis)
- Decision criteria for local vs remote handling
- Session protocols for large codebase efficiency
- Sub-agent delegation patterns (critical for OpenCode context limits)
- Option selection and error handling
- Integration patterns with tools like Grep and Read

**Reference documentation:**
- `references/BOUNDARIES.md` - (If applicable; otherwise omit or adapt based on actual files)
- `references/CLI_REFERENCE.md` - Complete command reference with all flags
- `references/PACK_LOCAL.md` - Local packing intents and options
- `references/PACK_REMOTE.md` - Remote GitHub packing
- `references/EXPLORE_LOCAL.md` - Launching analysis for local codebases
- `references/EXPLORE_REMOTE.md` - Launching analysis for remote repos
- `references/EXPLORER.md` - Sub-agent behavior for exploration
- `references/WORKFLOWS.md` - Step-by-step workflows with checklists

## Why is This Useful?

The skill helps the LLM AI understand:

1. **When to use repomix** - Not every codebase task needs packing. The skill teaches when repomix helps vs when direct file reading is better.

2. **How to structure analysis** - Proper use of compression, filters, and incremental tools to avoid context overload.

3. **Workflow patterns** - Parsing intents for packing, delegating to sub-agents for exploration, handling errors during analysis.

4. **Integration with other tools** - How repomix outputs work with Grep/Read, and when to chain with sub-agents.

## Installation

### Prerequisites

1. Ensure npx is available (comes with npm/Node.js):
   ```bash
   npm --version  # Should show version if installed
   ```

2. The repomix CLI is accessed via `npx repomix@latest` - no local install needed.

### Steps

1. Download this skill as a zip file (or clone the repository)
2. In OpenCode Settings → Skills → Upload Skill
3. Select the zip file or folder
4. The skill will appear in your list of available skills

## How It Works

OpenCode loads skills progressively:
1. Metadata (name + description) always in context
2. SKILL.md body when skill triggers
3. Reference docs loaded as needed

## Usage Examples

Once installed, the LLM AI will automatically:

- Suggest packing for AI when handling large codebases
- Delegate analysis to sub-agents for efficiency
- Use appropriate options like compression for large repos
- Maintain token efficiency during exploration

You can also explicitly ask the LLM AI to use repomix:

```
Pack this codebase for AI analysis
```

```
Explore the structure of https://github.com/facebook/react
```

```
Outline my local project and find authentication patterns
```

## Relationship to Repomix Plugin

This skill complements the repomix-explorer plugin:

- **Plugin**: Provides agents (e.g., repomix-explorer:explorer) and tools for basic operations
- **Skill** (this directory): Teaches the LLM AI the patterns, philosophy, and decision-making for effective repomix usage

You can use both together for the best experience:
- Plugin for optimized agents
- Skill for intelligent workflow decisions

### Why CLI Instead of MCP?

This skill teaches the LLM AI to use the repomix CLI directly (via Bash commands like `npx repomix@latest`, etc.) rather than relying on MCP tools. This approach has several benefits:

- **Lower context usage** - No MCP server prompt loaded into every session, saving tokens
- **Works everywhere** - Only requires npx, no MCP server setup needed
- **Explicit operations** - All repomix commands visible in conversation history for transparency
- **Full functionality** - CLI supports all flags for programmatic use just like MCP

The MCP server is excellent for interactive use, but for autonomous agent workflows where context efficiency matters, direct CLI usage is more practical. The skill provides the guidance the LLM AI needs to use the CLI effectively.

## Contributing

Found ways to improve the skill? Contributions welcome! See CONTRIBUTING.md for guidelines.

## License

MIT License. See LICENSE.
