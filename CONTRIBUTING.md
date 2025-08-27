# Contributing to reedACT

Thank you for your interest in contributing to reedACT! This document provides guidelines and workflows for contributing to the project.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Ticket Workflow](#ticket-workflow)
- [Development Process](#development-process)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing Requirements](#testing-requirements)

## Code of Conduct

Be respectful, constructive, and professional. We're building something amazing together.

## Project Governance

### File Ownership
- **docs/PROCESS_GUIDE.md**: Development workflow (maintained by team lead)
- **docs/STYLE_GUIDE.md**: Code style patterns (maintained by team)
- **docs/decisions/decisions.csv**: Technical decisions (updated by all developers)
- **docs/tickets/**: Active work tracking (managed by developers)
- **docs/decisions/**: Architecture decisions (maintained by architects)

### Decision Making
- Technical decisions must be logged in `docs/decisions/decisions.csv`
- Architectural changes require an ADR in `docs/decisions/`
- All changes must reference a ticket number

## Ticket Workflow

### 1. Issue Creation
Every change starts with an issue. No exceptions.

```mermaid
Issue → Branch → Code → PR → Review → Merge
```

#### Issue Types
- **feature**: New functionality
- **fix**: Bug fixes
- **docs**: Documentation only
- **refactor**: Code improvement without functional changes
- **test**: Adding or updating tests
- **chore**: Maintenance tasks

#### Issue Template
```markdown
## Description
Brief description of the issue

## Acceptance Criteria
- [ ] Clear, measurable criteria
- [ ] What defines "done"

## Technical Notes
Any technical considerations or constraints

## Related Issues
Links to related issues or dependencies
```

### 2. Branch Naming Convention

Format: `{type}/{issue-number}-{brief-description}`

Examples:
- `feature/42-add-websocket-transport`
- `fix/13-template-render-error`
- `docs/27-update-security-section`
- `refactor/35-optimize-jail-execution`

### 3. Work Tracking

#### Issue States
1. **Backlog**: Not yet started
2. **In Progress**: Active development
3. **Review**: PR submitted
4. **Done**: Merged to main

#### Definition of Ready
Before starting work, ensure:
- [ ] Issue has clear acceptance criteria
- [ ] Dependencies are identified
- [ ] Technical approach is agreed upon
- [ ] Issue is assigned

#### Definition of Done
- [ ] Code complete and working
- [ ] Tests written and passing
- [ ] Documentation updated
- [ ] PR reviewed and approved
- [ ] CI/CD pipeline green
- [ ] Merged to main

## Development Process

### 1. Start Work
```bash
# Create branch from main
git checkout main
git pull origin main
git checkout -b feature/42-your-feature

# Link to issue in commit messages
git commit -m "feat: Add WebSocket transport (#42)"
```

### 2. Development Guidelines

#### Code Style
- Rust: Follow `rustfmt` and `clippy` recommendations
- Templates: Semantic HTML, accessible by default
- Comments: Explain "why", not "what"

#### Testing Strategy
- Unit tests for all public functions
- Integration tests for user-facing features
- Document test scenarios in PR

### 3. Documentation
Update documentation in the same PR as code changes:
- API changes → Update technical docs
- New features → Add examples
- Breaking changes → Update migration guide

## Commit Guidelines

### Conventional Commits Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation only
- **style**: Formatting (no code change)
- **refactor**: Code restructuring
- **test**: Adding tests
- **chore**: Maintenance

### Examples
```bash
feat(template): Add reactive bind primitive
fix(jail): Prevent memory leak in Python execution
docs(security): Clarify template isolation model
refactor(server): Extract routing logic
test(websocket): Add connection failure scenarios
```

### Commit Rules
1. Use present tense ("Add feature" not "Added feature")
2. Use imperative mood ("Move cursor" not "Moves cursor")
3. Reference issues and PRs (`#42`)
4. Keep subject line under 50 characters
5. Wrap body at 72 characters
6. **Never include AI assistant names**

## Pull Request Process

### PR Template
```markdown
## Description
Brief description of changes

## Related Issue
Closes #42

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Tests added/updated
- [ ] Breaking changes documented
```

### Review Process

#### Author Responsibilities
1. Create focused, reviewable PRs (<500 lines preferred)
2. Provide context in PR description
3. Respond to feedback constructively
4. Update PR based on review

#### Reviewer Responsibilities
1. Review within 24-48 hours
2. Provide actionable feedback
3. Approve explicitly when satisfied
4. Use conventional comments:
   - `nit:` Minor issues (non-blocking)
   - `question:` Clarification needed
   - `suggestion:` Alternative approach
   - `issue:` Must be addressed

### Merge Requirements
- [ ] All CI checks pass
- [ ] At least one approval
- [ ] No unresolved conversations
- [ ] Up-to-date with main branch
- [ ] Squash and merge for clean history

## Testing Requirements

### Test Coverage
- Minimum 80% code coverage
- Critical paths require 100% coverage
- All public APIs must have tests

### Test Categories

#### Unit Tests
```rust
#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_feature() {
        // Test implementation
    }
}
```

#### Integration Tests
```rust
// tests/integration_test.rs
#[test]
fn test_end_to_end_flow() {
    // Test user-facing functionality
}
```

#### Performance Tests
- Benchmark critical paths
- Document baseline metrics
- Flag regressions in PR

### Running Tests
```bash
# Run all tests
cargo test

# Run with coverage
cargo tarpaulin

# Run benchmarks
cargo bench

# Run specific test
cargo test test_name
```

## Architecture Decisions

Major architectural changes require an Architecture Decision Record (ADR).

See [docs/decisions/](docs/decisions/) for:
- ADR template
- Existing decisions
- Decision process

## Getting Help

- **Questions**: Open a [Discussion](https://github.com/byvoss/reedact/discussions)
- **Bugs**: Create an [Issue](https://github.com/byvoss/reedact/issues)
- **Security**: Email security@byvoss.com (PGP available)

## Recognition

Contributors are recognized in:
- [CONTRIBUTORS.md](CONTRIBUTORS.md)
- Release notes
- Project documentation

Thank you for contributing to reedACT! 🚀