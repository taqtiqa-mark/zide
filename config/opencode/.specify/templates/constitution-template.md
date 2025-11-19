# [PROJECT_NAME] Constitution
<!-- Example: Spec Constitution, TaskFlow Constitution, etc. -->

## Core Principles

### I. Clean Architecture **AND** Domain-Driven Design

- Adhere strictly to **Clean Architecture Principles** for every component:
  - **Separation of Concerns Rule**: Divide system into layers (domain, use cases, interface adapters, frameworks). Keep domain logic pure and framework-agnostic.
  - **Dependency Rule**: Dependencies flow inward: Domain → Data → Infrastructure → Presentation → Main. Inner layers unaware of outer layers.
  - **Inversion of Dependencies Rule**: Define abstractions (interfaces) in inner layers; outer layers implement them. Inner layers control dependency direction (e.g., data access, UI).
  - **Isolation of Business Logic Rule**: No domain code imports infrastructure code.
  - **Technology Independence Rule**: Business logic independent of technology choices.
  - **Maintainability and Testability Rule**: Isolate business rules from external dependencies (test core logic without database/UI).
  - **Adaptable Architecture Rule**: Swap external components (e.g., database, web framework) without rewriting core business logic.
- Adhere strictly to **Domain-Driven Design (DDD) Principles and Patterns** for every component:
  - **Core Principles**:
    - **Focus on Core Domain Principle**: Prioritize and model the business's key aspects centrally.
    - **Collaboration Principle**: Jointly understand domain with experts.
    - **Ubiquitous Language Principle**: Use shared vocabulary consistently in discussions, docs, code (e.g., class/method/variable names).
    - **Bounded Contexts Principle**: Break complex domains into self-contained models, each with its own ubiquitous language to avoid over-generalization.
    - **Domain Model Driven Principle**: Derive software structure and implementation directly from the domain model.
  - **Key Patterns**:
    - **Entities Pattern**: Define objects with unique identity and lifecycle (e.g., Customer, LoanApplication).
    - **Value Objects Pattern**: Define immutable objects by attributes, no identity (e.g., Money, Address).
    - **Aggregates Pattern**: Group related entities/value objects as a unit with an Aggregate Root for consistency enforcement and access.
    - **Domain Events Pattern**: Model significant business occurrences for decoupling and event-driven logic.
    - **Repositories Pattern**: Abstract data access to simulate in-memory collections.
    - **Services Pattern**: Encapsulate logic not fitting single entities/value objects (e.g., domain services for cross-aggregate operations).
- **Enforcement Guidelines**:
  - In all code generation: Validate adherence to these rules; refactor if violated.
  - Use examples in reasoning: Map domain concepts to patterns before coding.
  - Prioritize purity: Ensure domain layer testable in isolation.
  - Document mappings: Comment code with principle/pattern references.

### II. SOLID, DRY, KISS, and YAGNI Principles

Adhere strictly to **SOLID Principles** across all layers:

- **Single Responsibility Principle**: Each class/module has one reason to change. Split if handling multiple concerns.
- **Open/Closed Principle**: Entities open for extension, closed for modification. Use abstractions/interfaces for extensibility.
- **Liskov Substitution Principle**: Subtypes interchangeable with base types without altering correctness. No weakening preconditions or strengthening postconditions.
- **Interface Segregation Principle**: Many client-specific interfaces better than one general-purpose. Clients not forced to depend on unused methods.
- **Dependency Inversion Principle**: High-level modules independent of low-level; both depend on abstractions. Invert dependencies via interfaces.

Adhere strictly to **DRY (Don't Repeat Yourself)**:

- Eliminate code duplication. Extract shared logic to utilities, helpers, or base classes.
- Rule: Maximum 3 similar implementations before mandatory abstraction. If copying code, refactor immediately.

Adhere strictly to **KISS (Keep It Simple, Stupid)**:

- Choose simplest working solution. Prioritize readability over cleverness or premature optimization.
- Rule: If an explanation would exceed 250 words, simplify. Optimize only for proven bottlenecks.

Adhere strictly to **YAGNI (You Aren't Gonna Need It)**:

- Build only what's needed now. No speculative features or over-generalization without requirements.
- Rule: Delete unused code. Implement on-demand; no future-proofing for single-use cases.

**Enforcement Guidelines**:

- In code generation: Validate adherence; refactor violations.
- Reason with examples: Check principles before coding.
- Prioritize simplicity: Ensure code readable and minimal.
- Document: Comment adherence to principles.

### III. Library-First Development

Every feature begins as a standalone, independently deployable library. Libraries must be self-contained with clear interfaces, comprehensive documentation (including llms.txt for AI consumption), and isolated testing. Libraries expose functionality through well-defined contracts: REST APIs, gRPC services, or MCP protocols. No feature bypasses library abstraction to directly access infrastructure.

### IV. AI Skills Integration

#### Purpose
AI Skills are modular, self-contained extensions that provide specialized workflows, tools, and enforcement mechanisms for constitutional principles. Skills transform general AI assistants (e.g., Grok, Claude) into domain-specific agents without amending the core constitution.

#### Core Rules for Skills
- **Compliance Requirement**: All skills MUST adhere to constitutional principles (e.g., Clean Architecture, SOLID). Non-compliant skills are invalid.
- **Discovery and Usage**: Skills are discovered via metadata (name and description). Use when the task matches the skill's "Use when..." description.
- **Structure**:
  - Required: SKILL.md with YAML frontmatter (name, description <1024 chars).
  - Optional: references/ (docs), scripts/ (tools), assets/ (templates).
- **Progressive Disclosure**: Load metadata always; SKILL.md body when relevant; resources as needed.
- **Testing and Validation**: Author skills using TDD for documentation—write pressure scenarios, baseline failures, then skill content. Evaluate against writing best practices (concise, imperative language).
- **Persuasion for Compliance**: Use authority ("MUST", "No exceptions") and commitment (announce usage) for discipline-enforcing skills.
- **Integration with Workflows**: Skills may reference tasks.md or CI/CD but cannot override them. Announce skill usage at start of relevant tasks.

#### When to Create/Use Skills
- **Use when**: Task requires specialized knowledge (e.g., TDD enforcement) or tools beyond core constitution.
- **Do not use when**: Core principles suffice; avoid for one-off tasks.
- **Examples**:
  - TDD-Enforcement Skill: For verifying TDD cycles in code generation.
  - Beads-Issue-Tracking Skill: For advanced task management (see below).

#### Skill Authoring Checklist
- [ ] YAML: Name (hyphens only), description starts with "Use when...".
- [ ] Concise: SKILL.md <500 lines; details in references/.
- [ ] Tested: Run baseline scenarios without skill, then with.
- [ ] Ethical: Serves project integrity; no manipulation.

Skills are stored in a skills/ directory and loaded as needed. For best practices, reference external guides on skill authoring.

### V. Test-First Development (NON-NEGOTIABLE)

Strict TDD enforcement following Rodrigo Manguinho's Clean Architecture methodology. Development must follow this exact sequence:

#### TDD Development Order (MANDATORY):

1. **Domain Layer**:

   - Create models (types/interfaces)
   - Create use case interfaces
   - Commit each file individually
   - NO TESTS for domain (pure contracts)

2. **Domain Mocks & Test Doubles**:

   - Create mock implementations of domain models
   - Create spy implementations of domain use cases
   - Commit mocks/spies

3. **Data Layer Protocols**:

   - Create data/protocols interfaces (e.g., AddAccountRepository, Hasher)
   - These are contracts that data layer needs but don't belong in domain
   - Commit protocols

4. **Data Layer Test (Red Phase)**:

   - Write test file using Spies and Stubs
   - **RUN TEST - MUST FAIL** ❌
   - Commit failing test

5. **Data Layer Implementation (Green Phase)**:

   - Implement use case classes injecting protocols
   - Use cases know Domain but Domain doesn't know Data
   - **RUN TEST - MUST PASS** ✅
   - Commit working implementation

6. **Infra Layer Test (Red Phase)** [OPTIONAL]:

   - Only if infrastructure adapter doesn't exist
   - Write failing test for adapter
   - **RUN TEST - MUST FAIL** ❌
   - Commit failing test

7. **Infra Layer Implementation (Green Phase)** [OPTIONAL]:

   - Implement concrete adapter (e.g., BcryptAdapter implements Hasher)
   - **RUN TEST - MUST PASS** ✅
   - Commit working adapter

8. **Presentation Layer Test (Red Phase)**:

   - Write controller/handler tests
   - **RUN TEST - MUST FAIL** ❌
   - Commit failing test

9. **Presentation Layer Implementation (Green Phase)**:

   - Implement controllers/handlers
   - **RUN TEST - MUST PASS** ✅
   - Commit working controller

10. **Main Layer**:

    - Compose using Factories, Adapters, Middlewares
    - NO unit tests (covered by integration)
    - Commit compositions

11. **Integration Tests**:
    - Test complete flow from routes to database
    - **RUN ALL TESTS - MUST PASS** ✅
    - Commit integration tests

#### Critical Rules:

- NEVER create all test files first then all production files
- Each layer must be completed (test → implementation) before moving to next
- Domain Layer has NO tests (pure interfaces/types/models)
- Test Doubles (mocks/stubs/spies) created AFTER domain, BEFORE data layer tests
- Minimum coverage: 80% unit, 70% integration, 100% critical paths

  ### VI. Model Context Protocol Integration

All AI capabilities exposed through standardized MCP servers. TypeScript and Python implementations maintain protocol parity. Resources, Tools, and Prompts clearly defined and versioned. MCP servers follow single-responsibility principle. Transport layer supports both STDIO (local) and HTTP+SSE (remote).

### VII. Observability & Monitoring

Structured logging mandatory (JSON format with correlation IDs). OpenTelemetry for distributed tracing across services. Metrics exposed via Prometheus endpoints. Health checks at /health (liveness) and /ready (readiness). Error tracking with proper context and stack traces.

### VIII. Security by Design

Zero-trust architecture with KeyCloak for authentication/authorization. Secrets managed exclusively through Vault Community - no hardcoded credentials. RBAC enforced at API gateway and service levels. Data encryption at rest (PostgreSQL) and in transit (TLS 1.3+). Regular security scanning in CI/CD pipeline.

### IX. Containerization & Infrastructure as Code

All services containerized with multi-stage Docker builds. Development/production parity through consistent container usage. Infrastructure definitions in docker-compose for local, Kubernetes manifests for production. Makefile as single source of truth for all operations. No manual infrastructure changes - everything through code.

## Technology Standards

### Backend Services (Node.js/TypeScript)

- **Framework**: Express.js with typed middleware chain
- **ORM**: Prisma with migrations tracked in version control
- **Database**: PostgreSQL with pgVector for AI embeddings
- **Cache**: Redis for session management and temporary data
- **Storage**: MinIO for S3-compatible object storage
- **Documentation**: OpenAPI 3.0 via Swagger with auto-generation
- **Testing**: Jest with supertest for API testing
- **Code Quality**: ESLint (airbnb-typescript), Prettier, Husky pre-commit hooks

#### Test Structure (Following Clean Architecture):

```bash
tests/
├── domain/ # NO TESTS HERE - only interfaces
├── data/
│ ├── mocks/ # Test doubles for domain interfaces
│ └── usecases/ # Data layer use case tests
├── infra/
│ ├── mocks/ # External service mocks
│ └── db/ # Repository implementation tests
├── presentation/
│ ├── controllers/ # Controller tests
│ └── middlewares/ # Middleware tests
├── main/ # NO UNIT TESTS - only integration
└── integration/ # Full flow tests
```

#### Test Doubles Patterns:

- **Stub**: Returns fixed values (for simple responses)
- **Spy**: Records calls and returns values (for verification)
- **Mock**: Pre-programmed expectations (for complex scenarios)
- **Fake**: Working implementation for tests (e.g., in-memory DB)

### Frontend Application (React/TypeScript)

- **Framework**: React 18+ with functional components only
- **UI Components**: Shadcn/ui with Tailwind CSS
- **State Management**: React Context + useReducer for complex state
- **Data Fetching**: TanStack Query with proper caching strategies
- **Forms**: React Hook Form with Zod validation
- **Testing**: Jest + React Testing Library
- **Build**: Vite for development, optimized production builds

### MCP Servers

- **TypeScript Server**: Using official @modelcontextprotocol/sdk
- **Python Server**: Using mcp package with FastAPI for HTTP transport
- **Protocol Version**: Latest stable MCP specification
- **Testing**: Integration tests for all exposed tools and resources
- **Python Quality**: Black formatter, pylint, mypy for type checking, pytest

### Infrastructure Requirements

- **Container Registry**: Local registry for development, ECR/GCR for production
- **Orchestration**: Docker Compose for local, Kubernetes for production
- **Service Mesh**: Optional Istio for advanced traffic management
- **Monitoring Stack**: Prometheus + Grafana + Loki
- **CI/CD**: GitHub Actions with matrix testing

## Task Generation Requirements

### Tasks Must Include Test Execution & Progress Tracking

Every implementation must include these task types:

```markdown
## Required Task Types

1. *Implementation Tasks**: Create file with specific content
2. **Test Execution Tasks** (🧪): Run tests verifying RED/GREEN state
3. **Progress Update Tasks** (📝): Mark task complete in tasks.md
4. **Commit Tasks** (💾): Atomic commits with proper messages
5. **Migration Tasks** (🗄️): Database schema changes at correct points
6. **Verification Tasks**: Ensure coverage and quality metrics
```

### Task Progress Tracking (MANDATORY)

```bash
# After EVERY task completion
sed -i 's/\[ \] T001/\[x\] T001/' specs/[###-feature]/tasks.md
git add specs/[###-feature]/tasks.md
git commit -m "chore: mark T001 as completed"
```

### Database Migration Points

Migrations MUST occur at these specific points:

1. Initial Setup: After creating Prisma schema (before any tests)
2. Schema Changes: After domain changes require new fields/tables
3. Pre-Integration: Before running integration tests
4. Pre-Deployment: Final migration check

```bash
# Migration sequence:
npx prisma migrate dev --name [description]  # Generate migration
npx prisma migrate deploy                     # Apply migration
npx prisma generate                           # Update client
npm test -- [affected_tests]                 # Verify tests still pass
```

## Development Workflow

### TDD Workflow Example (MUST FOLLOW)

For a new feature "Create User", the exact development sequence with commits:

```typescript
// STEP 1: DOMAIN LAYER (no tests, just contracts)
// domain/models/user.ts
export type UserModel = { id: string; email: string; name: string };
// COMMIT: "feat(domain): add UserModel type"

// domain/usecases/add-account.ts
export interface AddAccount {
  add(account: AddAccountModel): Promise<AccountModel>;
}
// COMMIT: "feat(domain): add AddAccount interface"

// STEP 2: DOMAIN MOCKS
// tests/domain/mocks/mock-account.ts
export const mockAccountModel = (): AccountModel => ({
  id: "valid_id",
  name: "valid_name",
  email: "valid_email@mail.com",
});
// COMMIT: "test(domain): add account model mock"

// STEP 3: DATA PROTOCOLS
// data/protocols/criptography/hasher.ts
export interface Hasher {
  hash(value: string): Promise<string>;
}
// COMMIT: "feat(data): add Hasher protocol"

// STEP 4: DATA LAYER TEST (Red)
// tests/data/usecases/db-add-account.spec.ts
describe("DbAddAccount", () => {
  test("Should call Hasher with correct password", async () => {
    const { sut, hasherSpy } = makeSut();
    await sut.add(mockAddAccountModel());
    expect(hasherSpy.value).toBe("valid_password");
  });
});
// RUN: npm test -- --watch db-add-account.spec.ts
// VERIFY: Test FAILS ❌
// COMMIT: "test(data): add DbAddAccount test - RED phase"

// STEP 5: DATA LAYER IMPLEMENTATION (Green)
// data/usecases/add-account/db-add-account.ts
export class DbAddAccount implements AddAccount {
  constructor(
    private readonly hasher: Hasher,
    private readonly addAccountRepository: AddAccountRepository
  ) {}

  async add(accountData: AddAccountModel): Promise<AccountModel> {
    const hashedPassword = await this.hasher.hash(accountData.password);
    const account = await this.addAccountRepository.add({
      ...accountData,
      password: hashedPassword,
    });
    return account;
  }
}
// RUN: npm test -- --watch db-add-account.spec.ts
// VERIFY: Test PASSES ✅
// COMMIT: "feat(data): implement DbAddAccount - GREEN phase"

// Continue with INFRA, PRESENTATION, MAIN, INTEGRATION...
```

### Code Simplicity Guidelines (KISS)

    Function Complexity: Max 20 lines, cyclomatic complexity < 5
    Class Size: Max 200 lines, single responsibility
    File Organization: One class/interface per file
    Naming: Self-documenting, no comments needed
    Nesting: Max 3 levels of indentation

### Duplication Detection (DRY)

    Check for duplication before commit

npx jscpd src --min-tokens 30

If duplication > 3%: REFACTOR REQUIRED

### Feature Justification (YAGNI)

Before adding ANY feature/abstraction, document:

    Current Need: What problem exists TODAY?
    User Request: Link to issue/ticket
    Alternative: Simpler solution considered?
    ROI: Implementation time vs value delivered

### TDD Git Workflow (MANDATORY)

Each TDD phase requires specific commit patterns for traceability:

#### Commit Message Format

<type>(<layer>): <description> [- <TDD phase>]

Types: feat, test, refactor, fix, chore
Layers: domain, data, infra, presentation, main, integration
TDD Phases: RED phase, GREEN phase, REFACTOR phase

#### Required Commits per Layer

```ascii
    Domain Layer: 1 commit per file (no TDD phase)
        feat(domain): add UserModel type
        feat(domain): add AddAccount interface

    Test Doubles: 1 commit for mocks/spies
        test(domain): add account mocks and spies

    Data Protocols: 1 commit for protocols
        feat(data): add repository and cryptography protocols

    Each Test File: 2-3 commits minimum
        test(data): add DbAddAccount test - RED phase
        feat(data): implement DbAddAccount - GREEN phase
        refactor(data): improve DbAddAccount - REFACTOR phase (optional)

    Integration: Final validation
        test(integration): add signup route tests
```

#### Git History Must Show

```bash
git log --oneline
# GOOD - Shows TDD flow:
a1b2c3d feat(domain): add UserModel type
d4e5f6g feat(domain): add AddAccount interface
h7i8j9k test(domain): add account mocks and spies
l0m1n2o feat(data): add repository protocols
p3q4r5s test(data): add DbAddAccount test - RED phase
t6u7v8w feat(data): implement DbAddAccount - GREEN phase
x9y0z1a test(infra): add BcryptAdapter test - RED phase
b2c3d4e feat(infra): implement BcryptAdapter - GREEN phase

# BAD - No TDD evidence:
a1b2c3d feat: add user feature
d4e5f6g test: add tests
```

### Code Submission Process

- Feature branch from develop following git-flow
- Pre-commit hooks run automatically (lint, format, type-check)
- All tests must pass locally before push
- PR requires: 2 approvals, passing CI, updated documentation
- Squash merge to maintain clean history

### API Development Standards

- Version all APIs (v1, v2) with deprecation notices
- Rate limiting on all public endpoints
- Request/Response validation with detailed error messages
- Correlation IDs for request tracing
- Pagination for list endpoints (cursor-based preferred)

### Database Migration Policy

-  All schema changes through Prisma migrations
-  Backward compatible changes only (add columns, never remove in same release)
-  Migration testing required in staging environment
-  Rollback plan documented for each migration
-  Vector indexes optimized for similarity search performance

### MCP Server Development

- Each server focuses on single domain capability
- Comprehensive tool descriptions for LLM understanding
- Resource URIs follow consistent naming convention
- Prompt templates tested with multiple LLM providers
- Integration tests with actual AI clients

## Quality Gates

### TDD Anti-Patterns (FORBIDDEN)

These practices violate our TDD principles and will result in PR rejection:

#### ❌ Over-Engineering Anti-Pattern (Violates KISS & YAGNI)

Adding unnecessary complexity or features:

WRONG:
- Generic repository for single entity
- Abstract factory for 2 implementations
- Strategy pattern for non-changing algorithm
- Microservices for <100 requests/minute
- Event sourcing for CRUD operations

#### ❌ Code Duplication Anti-Pattern (Violates DRY)

WRONG:
- Same validation in multiple controllers
- Duplicate error handling logic
- Copy-paste test setups
- Repeated database queries

#### ❌ All-Tests-First Anti-Pattern

Creating all test files first, then all implementation files:

WRONG:
1. Create all *.spec.ts files
2. Create all production *.ts files
3. Make tests pass

#### ❌ Bottom-Up Anti-Pattern

Starting from infrastructure/database layer:

WRONG:
1. Create database schema
2. Create repositories
3. Create use cases
4. Create domain

#### ❌ Mock-Everything Anti-Pattern

Over-mocking leading to brittle tests:

WRONG:
- Mocking primitive values
- Mocking DTOs
- Mocking value objects
- Creating mocks before domain interfaces exist

#### ❌ Integration-Only Anti-Pattern

Skipping unit tests and only writing integration tests:

WRONG:
- No unit tests for use cases
- No unit tests for controllers
- Only testing through HTTP requests

### Pre-Deployment Checklist

    TDD sequence followed correctly (Domain → Data → Infra → Presentation → Main)
    KISS: No over-engineered solutions (complexity justified?)
    YAGNI: No speculative features (all features requested?)
    DRY: Code duplication < 3% (jscpd report clean?)
    All tests passing (unit, integration, e2e)
    Task progress at 100% in tasks.md
    Security scan completed (dependencies, containers)
    Performance benchmarks within acceptable range
    Documentation updated (API, README, CHANGELOG)
    Database migrations tested and reversible
    MCP server contracts validated
    Monitoring dashboards configured

### Performance Standards

    API response time: p95 < 200ms, p99 < 500ms
    Container startup: < 30 seconds
    Database queries: Explain plan reviewed for N+1 issues
    Vector similarity search: < 100ms for 1M embeddings
    Frontend Core Web Vitals: LCP < 2.5s, FID < 100ms, CLS < 0.1

### Security Requirements

    Dependency updates within 30 days for critical vulnerabilities
    Penetration testing quarterly
    OWASP Top 10 compliance verified
    Secrets rotation every 90 days
    Audit logs retained for 1 year

### CI/CD Task Verification

The CI/CD pipeline MUST verify task progress:

```yaml
# .github/workflows/task-progress.yml
name: Verify Task Progress
on: [push, pull_request]

jobs:
  verify-progress:
    steps:
      - name: Check task completion
        run: |
          # Count incomplete tasks
          INCOMPLETE=$(grep -c "^\- \[ \]" specs/*/tasks.md || true)
          if [ $INCOMPLETE -gt 0 ]; then
            echo "❌ Found $INCOMPLETE incomplete tasks"
            echo "All tasks must be marked complete before merge"
            exit 1
          fi

      - name: Verify migration status
        run: |
          npx prisma migrate status
          if [ $? -ne 0 ]; then
            echo "❌ Pending migrations detected"
            exit 1
          fi
```

### Task Execution Monitoring

Every development session MUST:

    Start by reviewing incomplete tasks in tasks.md
    Execute tasks in order (no skipping)
    Mark each task complete immediately after execution
    Commit progress updates at least every 5 tasks
    Never leave tasks.md out of sync with actual progress

### Progress Verification Commands

# Check incomplete tasks
grep "^\- \[ \]" specs/*/tasks.md | wc -l

# Find last completed task
grep "^\- \[x\]" specs/*/tasks.md | tail -1

# Verify migrations are current
npx prisma migrate status

# Generate progress report
echo "Progress: $(grep -c "^\- \[x\]" tasks.md) / $(grep -c "^\- \[" tasks.md)"

## Refactoring Triggers

Mandatory refactoring when:

    Same code appears 3 times (DRY violation)
    Function > 20 lines or complexity > 5 (KISS violation)
    Unused code exists > 1 sprint (YAGNI violation)
    Test coverage drops below 80%
    Performance degrades > 20% from baseline

Refactoring Process:

    Document current behavior with tests
    Refactor in small steps
    Run tests after each change
    Commit working state frequently
    Update documentation

## Architectural Decision Records (ADR)

### ADR Format

All significant architectural decisions documented in docs/adr/ following:

```markdown
# ADR-XXX: Title

Status: [Proposed|Accepted|Deprecated|Superseded]
Date: YYYY-MM-DD
Context: Why this decision is needed
Decision: What we're doing
Consequences: Trade-offs and impacts
```

### Review Triggers

    Introduction of new technology/framework
    Significant performance optimization
    Security architecture changes
    Integration pattern modifications
    Breaking API changes

## Governance

### Constitutional Authority

This constitution supersedes all other development practices and guidelines. In case of conflict, constitutional principles take precedence. Teams may add additional constraints but cannot override constitutional requirements.

### Amendment Process

    Proposed amendments require RFC (Request for Comments) document
    Minimum 2-week discussion period with team input
    Requires 2/3 majority approval from technical leads
    Includes migration plan for existing code
    Grace period of 30 days for implementation

### Compliance Verification

    Automated checks in CI/CD pipeline for constitutional compliance
    Quarterly architecture review against principles
    Exception requests require written justification and expire after 90 days
    Non-compliance blocks production deployment

### Escalation Path

    Team Lead for day-to-day interpretations
    Architecture Committee for principle clarifications
    CTO for constitutional amendments
    External audit annually for compliance verification

## Version: 2.1.0 | Ratified: 2025-01-15 | Last Amended: 2025-01-15

### Changelog

    v2.1.0: Added SOLID, DRY, KISS, YAGNI principles with enforcement rules
    v2.0.0: Complete rewrite with TDD methodology, task tracking, and migration points
    v1.3.0: Added mandatory task progress tracking and database migration timing
    v1.2.0: Added precise TDD workflow with commits and test execution requirements
    v1.1.0: Corrected TDD order following Manguinho's methodology
    v1.0.0: Initial constitution

This constitution is a living document. Regular reviews ensure it evolves with our technical needs while maintaining core architectural integrity. For implementation guidance, refer to /docs/guides/constitutional-compliance.md.

### [PRINCIPLE_2_NAME]
<!-- Example: II. CLI Interface -->
[PRINCIPLE_2_DESCRIPTION]
<!-- Example: Every library exposes functionality via CLI; Text in/out protocol: stdin/args → stdout, errors → stderr; Support JSON + human-readable formats -->

### [PRINCIPLE_3_NAME]
<!-- Example: III. Test-First (NON-NEGOTIABLE) -->
[PRINCIPLE_3_DESCRIPTION]
<!-- Example: TDD mandatory: Tests written → User approved → Tests fail → Then implement; Red-Green-Refactor cycle strictly enforced -->

### [PRINCIPLE_4_NAME]
<!-- Example: IV. Integration Testing -->
[PRINCIPLE_4_DESCRIPTION]
<!-- Example: Focus areas requiring integration tests: New library contract tests, Contract changes, Inter-service communication, Shared schemas -->

### [PRINCIPLE_5_NAME]
<!-- Example: V. Observability, VI. Versioning & Breaking Changes, VII. Simplicity -->
[PRINCIPLE_5_DESCRIPTION]
<!-- Example: Text I/O ensures debuggability; Structured logging required; Or: MAJOR.MINOR.BUILD format; Or: Start simple, YAGNI principles -->

## [SECTION_2_NAME]
<!-- Example: Additional Constraints, Security Requirements, Performance Standards, etc. -->

[SECTION_2_CONTENT]
<!-- Example: Technology stack requirements, compliance standards, deployment policies, etc. -->

## [SECTION_3_NAME]
<!-- Example: Development Workflow, Review Process, Quality Gates, etc. -->

[SECTION_3_CONTENT]
<!-- Example: Code review requirements, testing gates, deployment approval process, etc. -->

## Governance
<!-- Example: Constitution supersedes all other practices; Amendments require documentation, approval, migration plan -->

[GOVERNANCE_RULES]
<!-- Example: All PRs/reviews must verify compliance; Complexity must be justified; Use [GUIDANCE_FILE] for runtime development guidance -->

**Version**: [CONSTITUTION_VERSION] | **Ratified**: [RATIFICATION_DATE] | **Last Amended**: [LAST_AMENDED_DATE]
<!-- Example: Version: 2.1.1 | Ratified: 2025-06-13 | Last Amended: 2025-07-16 -->
