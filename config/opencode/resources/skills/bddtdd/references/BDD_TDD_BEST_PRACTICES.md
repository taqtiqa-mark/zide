# BDD and TDD Best Practices

## Overview

Behavior-Driven Development (BDD) and Test-Driven Development (TDD) are collaborative practices that ensure software meets business needs through clear, testable behaviors. BDD focuses on defining system behavior in human-readable language (using Gherkin) to bridge stakeholders and developers, while TDD emphasizes writing tests before code to drive implementation. Together, they minimize iterations by sequencing BDD-first: define behaviors via Gherkin scenarios, then use them to guide TDD cycles (RED-GREEN-REFACTOR).

Key emphases:
- **Declarative style**: Describe *what* happens (outcomes and behaviors), not *how* (procedural steps like UI interactions).
- **Conciseness**: Keep scenarios short, focused, and readable to maintain clarity and reduce maintenance.
- **Behavior focus**: Center on business value and user outcomes, avoiding implementation details.
- **BDD-first sequencing for TDD**: Write Gherkin scenarios before code to establish acceptance criteria, then decompose into TDD tasks for unit-level confidence.

These practices are synthesized from resources including Cucumber Best Practices (SmartBear, BrowserStack, Cucumber.io), Gherkin Best Practices GitHub (andredesousa), Automation Panda, and AM Digital BDD Best Practices. They promote collaboration, maintainability, and reduced defects.

## Gherkin Syntax & Structure

Gherkin is a DSL for writing BDD scenarios in a structured, readable format. Use it with Cucumber for automation.

### Core Keywords and Structure
- **Feature**: High-level description of functionality. Start with a concise title and optional multi-line description (e.g., "As a [role], I want [feature] so that [benefit]").
- **Background**: Common setup steps run before every scenario in the feature (e.g., navigation or authentication).
- **Scenario**: A specific use case with Given-When-Then steps.
- **Scenario Outline**: For parameterized testing with <placeholders> and an Examples table.
- **Given**: Preconditions or initial state (present/present perfect tense).
- **When**: Action or trigger (present tense).
- **Then**: Expected outcome (present tense).
- **And/But**: Chain additional steps under Given, When, or Then.
- **Tags**: e.g., @smoke, @regression for filtering and organization.

### Best Practices for Syntax
- Capitalize keywords (e.g., `Given`, `When`, `Then`).
- Use third-person perspective (e.g., "the user" instead of "I") for consistency and reusability.
- Avoid punctuation at step ends; use quotes for parameters (convention for clarity).
- Limit files: One feature per file, focused on a single functionality; 5-10 scenarios max per feature.
- Use Data Tables or Examples for multiple inputs to avoid repetition.
- Maintain chronological order: Given (past/setup) → When (present/action) → Then (future/outcome).
- Avoid procedural details like URLs or field names to keep syntax declarative.

## Scenario Writing Tips

- **Write Early (BDD-First)**: Define scenarios before coding to clarify requirements and guide TDD. Involve the team in Example Mapping sessions.
- **Focus on One Behavior**: Each scenario tests a single rule or outcome; one When-Then pair preferred. Start Given on the target page to reduce navigation.
- **Declarative Over Imperative**: Describe outcomes (e.g., "logs in with valid credentials") vs. steps (e.g., "types username and clicks button").
- **Conciseness**: Limit steps (2-3 And per keyword); avoid long tables or conjunctive steps (e.g., split "sees message and button").
- **Behavior Focus**: Emphasize business value; use personas (e.g., "Free Frieda") for clarity; map to requirements (e.g., Jira IDs).
- **Reusability**: Word steps consistently for shared definitions; use Background for common setup. Use Third-person.
- **Independence**: Scenarios should run standalone without state dependency.
- **Native Language**: Write in the team's native tongue for better flow.

## Collaboration & Review

- **Three Amigos Approach**: Involve Product Owners, Developers, and Testers in defining behaviors via collaborative sessions (e.g., Example Mapping). Colaborate across roles to avoid isolated writing.
- **Shared Understanding**: Gherkin’s readability allows non-technical stakeholders to review and contribute, ensuring alignment on business rules.
- **Review Process**: Share scenarios with unfamiliar team members; if misunderstood, revise for clarity. Use tools like SpecFlow Gherkin Editor for validation and formatting. Use tags for selective execution during reviews.
- **Team Standards**: Establish a style guide (e.g., no jargon, consistent tags) and linting (e.g., gherkin-lint) for consistency.
- **In Scaled Environments**: Apply BDD at team level; share steps/frameworks across teams.

## Integration with TDD (BDD as Guide, Hierarchical via Bead)

BDD acts as the higher-level framework guiding TDD, ensures we write scenarios before code: Define behaviors in Gherkin first (BDD), then decompose into unit tests (TDD). Use Bead for hierarchical tracking and workflow enforcement.

- **Hierarchical Structure**: 
  - BDD at feature level: Store Gherkin scenarios in Bead epics (use `acceptance` field for scenarios, `description` for user story format like "As a... I want... so that...").
  - TDD at unit level: Create child tasks via Bead `parent-child` dependencies (e.g., BDD epic parents TDD subtasks with `design` for implementation notes).
- **Sequential Workflow (BDD-First for TDD)**: 
  - Enforce RED-GREEN-REFACTOR with Bead `blocks` dependencies: "Define BDD scenario" blocks "Write failing TDD test (Red)", which blocks "Implement minimal code (Green)", which blocks "Refactor".
  - This ensures BDD scenarios drive TDD cycles, aligning "what" (behavior) with "how" (code).
- **Handling Iterations**: Update Bead notes during TDD discoveries to refine BDD scenarios, ensuring persistence across sessions.
- **Benefits**: Reduces mismatches (code passes TDD but fails BDD); Bead automates ready work via dependencies.

## Common Pitfalls

- **Imperative Style**: Including UI details (e.g., "click button") makes tests brittle (Cucumber.io, andredesousa).
- **Vague/Overly Abstract Scenarios**: Lacks specifics, causing ambiguity (SmartBear, andredesousa).
- **Dependent Scenarios**: Leads to flakiness; ensure independence (andredesousa, Automation Panda).
- **Conjunctive/Overloaded Steps**: Combines actions, reducing reusability (SmartBear, BrowserStack).
- **Mixing Perspectives**: First vs. third-person causes inconsistency (SmartBear, Automation Panda).
- **Redundant Scenarios**: Obvious basics clutter suites; remove them (SmartBear, andredesousa).
- **Procedure-Driven**: Treats Gherkin like scripts; focus on behavior (Cucumber.io).
- **Overuse of Outlines/Tables**: Bloats tests; limit to key variations (BrowserStack, andredesousa).
- **UI-Level Testing**: Fragile to changes; test business logic (andredesousa).

## Checklists

### Scenario Quality Checklist
- [ ] Declarative: Describes what, not how?
- [ ] Concise: Under 10 lines, 2-3 And per keyword?
- [ ] Behavior-Focused: Centers on business value/outcomes?
- [ ] Independent: Runs standalone?
- [ ] Chronological: Given-When-Then order?
- [ ] Third-Person: Consistent perspective?
- [ ] Reusable: Consistent wording for steps?
- [ ] Mapped to Requirements: Includes IDs/tags?
- [ ] Reviewed: Understood by non-experts?

### Feature File Checklist (from AM Digital)
- [ ] Starts with Feature keyword and concise title?
- [ ] Uses simple, non-technical language?
- [ ] Limited scenarios (5-10 max)?
- [ ] Background for common setup?

### TDD Integration Checklist
- [ ] BDD-First: Scenarios written before TDD?
- [ ] Hierarchical: BDD epic with TDD children in Bead?
- [ ] Sequenced: Blocks for Red-Green-Refactor?
- [ ] Resumable: Notes for discoveries?

## Examples (Good vs Bad)

### Example 1: Login (from Cucumber.io, andredesousa)
- **Bad (Imperative)**:  
  ```gherkin
  Given I visit "/login"  
  When I enter "Bob" in the "user name" field  
  And When I enter "tester" in the "password" field  
  And When I press the "login" button  
  Then I should see the "welcome" page  
  ```
- **Good (Declarative)**:  
  ```gherkin
  When "Bob" logs in  
  Then he sees the welcome page  
  ```

### Example 2: Balance Check (from SmartBear)
- **Bad (Procedural)**:  
  ```gherkin
  Given I sign up as "JohnSmith"  
  And Given my password is "password"  
  And Given my password confirmation is "password"  
  And Given I have deposited "$60" in my account  
  And Given I have deposited "$40" in my account  
  When I check my bank balance  
  Then my bank balance is "$100"  
  ```
- **Good (Behavior-Focused)**:  
  ```gherkin
  Given a user signed up as "JohnSmith"  
  And has deposited "$60" in their account  
  And has deposited "$40" in their account  
  When that user checks their bank balance  
  Then the balance should be "$100"  
  ```

### Example 3: Scenario Outline (from BrowserStack)
- **Bad (Vague/Redundant)**:  
  ```gherkin
  Scenario: Login Validation  
    Given I navigate to the Website  
    When I enter email and password to login Page  
    And User click on sign-in button  
    Then Validate the title after login  
  ```
- **Good (Parameterized, Concise)**:  
  ```gherkin
  Scenario Outline: Login Validation  
    Given I navigate to the Website  
    When I enter "<email>" and "<validpassword>" to login Page  
    And User click on sign-in button  
    Then Validate the "<title>" after login  

  Examples:  
    | email                  | validpassword | title |  
    | qatubeupdate@yopmail.com | 12345       | Home  |  
  ```

These examples illustrate how to achieve declarative, concise, behavior-focused Gherkin that supports BDD-first TDD.
