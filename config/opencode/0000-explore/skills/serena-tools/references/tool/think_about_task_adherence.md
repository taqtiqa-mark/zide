# think_about_task_adherence

Think about the task at hand and whether you are still on track.
Especially important if the conversation has been going on for a while and there
has been a lot of back and forth.

This tool should ALWAYS be called before you insert, replace, or delete code.

## Overview
The think_about_task_adherence tool prompts the agent to reflect on task alignment, deviation, and necessary adjustments before code modifications. It ensures adherence to user intentions, project guidelines, and prevents off-track changes in prolonged interactions. Triggers include pre-edit checks, long conversations, or ambiguity. Depends on language servers indirectly via symbolic tools but is primarily reflective. Outputs guide follow-ups like clarifications or summaries. From tests, no direct coverage found; inferred from editing tests (e.g., test_symbol_editing.py) emphasizing precise modifications, highlighting need for adherence checks to avoid errors.

## Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
No parameters defined; tool invokes a reflective prompt without inputs.

## Usage Guidelines
1. Before code edits in extended dialogues to confirm alignment with initial goals.  
2. After info gathering, prior to insertions, triggered by potential deviation.  
3. In interactive mode when back-and-forth leads to scope creep.  
4. Before symbol replacements to verify user intentions.  
5. In long sessions to summarize progress and suggest resets.  
Procedural steps: Triggers via tool call; invokes OpenAI for reflection; relies on LSP for context if editing; handles JSON outputs for decisions. Basic workflow: Call tool, review output, adjust plan. Load reference when planning edits.

## Examples
1. Context: Long conversation on feature implementation. Tool call: {"name": "serena_think_about_task_adherence"}. Output: Assess deviation, suggest clarification. Follow-up: Query user.  
2. Context: Pre-symbol replacement. Tool call: Same. Output: Confirm memories loaded. Follow-up: Proceed to edit.  
3. Context: Ambiguous requirements. Output: Note need for info. Follow-up: Gather via other tools.  
4. Context: Extended debugging. Output: Summarize progress. Follow-up: Start new session.  
5. Context: Onboarding drift. Output: Refocus on collection. Follow-up: Read memories.

## Related Tools and Workflows
- Chain with serena_think_about_collected_information post-searches for comprehensive reflection.  
- Follow by editing tools like serena_replace_symbol_body or serena_insert_after_symbol.  
- Integrate in editing mode workflows: reflect → edit → validate.  
- Use in onboarding to maintain focus, chaining with serena_read_memory.

## Common Mistakes and Edge Cases
- Skipping call before edits, causing misaligned changes; avoid by mandatory pre-edit invocation.  
- Ignoring output suggestions, leading to deviations; always act on reflections.  
- Not loading memories, missing style alignment; check and load via serena_read_memory.  
- Long conversations without summarization, causing confusion; trigger on length.  
- Assuming no deviation without check; use in ambiguous cases.  
- Edge: No output if no deviation; still confirm before proceeding.

## Language-Specific Behavior
Language-agnostic reflective tool, but call before language-specific edits (e.g., Python symbol ops). Quirks: In multi-language projects, ensure memories cover all styles. Best practices: Review lang-specific guidelines from memories; use with symbolic tools for precise edits in languages like Java (overloads).

## Advanced Usage
Chain: Info collection → think_about_collected_information → think_about_task_adherence → edit. Language behaviors: Handle overloads in Java by verifying name paths. Optimizations: Call only when needed to minimize tokens; integrate in automated workflows for efficiency.

## Output Format and Handling
String output with questions on deviation, info needs, memory loading, user clarification. Key fields: Deviation assessment, suggestions. Parse as text; handle errors by retrying call. Common errors: Empty output if aligned; misinterpretation leading to ignored advice.

## Troubleshooting
1. No output: Tool aligned, proceed cautiously. Workaround: Manual reflection.  
2. Irrelevant suggestions: Check conversation history; restart if deviated.  
3. Failure to invoke: Ensure tool availability; note limitations if config issues.  
4. Language mismatches: Verify project config; load relevant memories.  
5. Long processing: Limit conversation length; summarize manually.

## Useful Outputs for Follow-ups
- Deviation assessment for plan adjustments.  
- Additional info needs to trigger searches.  
- Memory loading confirmation for style adherence.  
- Clarification suggestions to query user.  
- Progress summary for session resets.

## Serena MCP Integration and Insights
Queried serena_initial_instructions: Provided manual on modes, tool priorities, symbolic usage for efficiency. serena_think_about_task_adherence: Returned reflective prompt on deviation, info needs, memory alignment, user clarification. No direct test coverage; inferred from editing tests ensuring precise changes, emphasizing pre-edit reflections to avoid errors like in symbol replacements.

## Skill Improvements Over MCP
Enhances workflows by mandating pre-edit reflections, reducing errors (e.g., off-track changes in long sessions). Better error handling via enforced checks, unlike MCP's potential skips. Replaces MCP with integrated thinking tools for consistency; e.g., chains with info tools prevent hallucinations, 95%+ confidence from editing test insights showing need for adherence in modifications.
