# PAIN_POINTS.md

## Overview

This reference outlines key pain points in BDD and TDD processes, drawing from established best practices in resources like Cucumber Best Practices (SmartBear, BrowserStack, Cucumber.io), Gherkin Best Practices GitHub (andredesousa), Automation Panda, and AM Digital BDD. These pain points often lead to increased iterations between user stories and working code, higher defect rates, and rework. The bdd-tdd skill minimizes them by integrating Bead for persistence, dependency enforcement, and structured tracking, combined with best practices such as declarative Gherkin, concise scenarios, and collaborative writing. For each pain point, we detail the issue, minimization strategies using Bead (e.g., fields like `acceptance` for Gherkin, dependencies for sequencing), and best practices, with examples from resources.

## Ambiguous or Mismatched Expectations

**Description**: User stories often lack precise acceptance criteria, resulting in implementations that technically pass TDD but fail to meet business behaviors in BDD validation. This causes rework, as the code "works" but doesn't align with stakeholder intent, increasing cycles from story to implementation.

**Minimization Using Bead**: Store Gherkin scenarios directly in the `acceptance` field of Bead epics to define clear, testable outcomes early. Use `description` for the user story format ("As a... I want... so that...") and `parent-child` dependencies to link BDD epics to TDD subtasks, ensuring behaviors guide units. This creates a persistent, queryable record that survives sessions, reducing ambiguity.

**Best Practices Integration**: Emphasize declarative Gherkin (focus on outcomes, not steps) and collaborative review (Three Amigos) to clarify expectations upfront. From Automation Panda: Use third-person and outcome-focused language to avoid vagueness.

**Example from Resources**: In SmartBear Cucumber Best Practices, a vague scenario like "User logs in" leads to mismatched expectations; mitigated by declarative "User is authenticated and sees dashboard," which would be stored in Bead `acceptance` for alignment.

## Unstructured Iterations from Test Failures

**Description**: Without enforced cycles, developers face excessive iterations on failing tests due to unclear root causes, skipped steps, or ad-hoc refinements, prolonging the path from red (failing) to green (passing) and increasing defects.

**Minimization Using Bead**: Enforce RED-GREEN-REFACTOR via `blocks` dependencies (e.g., red phase issue blocks green, green blocks refactor), automating sequence and preventing skips. Update `design` notes during iterations for traceable refinements, minimizing unstructured loops.

**Best Practices Integration**: Adhere to tests-first (BDD scenarios before TDD) and minimal implementation in green phase. From BrowserStack: Use Scenario Outlines for variations to structure iterations systematically.

**Example from Resources**: Cucumber.io highlights unstructured TDD leading to brittle code; a bad example is implementing without failing tests first, causing endless tweaks—mitigated by Bead blocks enforcing "Write failing test" before "Implement minimal code."

## Context Loss in Multi-Session or Collaborative Work

**Description**: In long-running features, decisions, discoveries, or partial progress are lost across sessions or team handoffs, leading to duplicated effort, inconsistent code, or forgotten refinements between BDD scenarios and TDD implementations.

**Minimization Using Bead**: Leverage compaction-survival notes in issues (e.g., "COMPLETED: Green phase; IN PROGRESS: Refactor duplicates; BLOCKERS: Edge case") for resumability. Use `discovered-from` dependencies to link emergent findings, preserving context without relying on conversation history.

**Best Practices Integration**: Write concise, readable scenarios (limit steps) and review collaboratively to embed shared understanding. From AM Digital: Use simple language in Gherkin to aid handoffs.

**Example from Resources**: Andredesousa's Gherkin Best Practices notes context loss from imperative, detailed scenarios that become outdated; a good concise example ("User adds item to cart") in Bead notes prevents loss during multi-session TDD refinements.

## Dependency Oversights Leading to Out-of-Order Development

**Description**: Implementing without resolving prerequisites (e.g., TDD before complete BDD specs) results in brittle code, integration failures, or rework when dependencies like schema changes or related features are overlooked.

**Minimization Using Bead**: Use `hierarchies` via `parent-child` (BDD epic parents TDD tasks) and `ready` commands to surface unblocked work automatically. `Blocks` dependencies prevent starting TDD until BDD is refined, avoiding out-of-order issues.

**Best Practices Integration**: Ensure scenario independence and BDD-first sequencing. From SmartBear: Avoid dependent scenarios to reduce flakiness.

**Example from Resources**: BrowserStack warns of oversight in complex flows like login with dependencies on auth services; mitigated by Bead hierarchies, e.g., "Auth BDD epic" blocking "Endpoint TDD task," preventing premature implementation.

## Over-Engineering or Scope Creep

**Description**: Fuzzy boundaries in stories lead to unnecessary features or expanding scope, where TDD adds extras not validated by BDD, inflating development time and maintenance.

**Minimization Using Bead**: Apply boundaries with TodoWrite for linear steps (e.g., single TDD cycle) vs. Bead for complex flows; use checklists in notes (e.g., "One concept per scenario") to constrain scope. Prioritize issues (0-3) to focus efforts.

**Best Practices Integration**: Limit to one behavior per scenario and use Examples tables sparingly. From AM Digital: Focus on business value to curb creep.

**Example from Resources**: Cucumber.io's Better Gherkin advises against overloaded scenarios (e.g., combining add/update in one); Bead checklists enforce "Split if >1 concept," preventing creep in features like shopping carts.
