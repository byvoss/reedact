# Development Process

## 🚀 Quick Session Start (< 30 seconds)

```bash
# 1. Check current status
git status --short

# 2. Check active tickets in board
grep ",active," docs/tickets/board.csv 2>/dev/null | cut -d',' -f1,2,5 || echo "No active tickets"

# 3. Check last decisions
tail -3 docs/decisions/decisions.csv
```

**Next steps:**
- **New work?** → Go to [Issue-Driven Development](#issue-driven-development)
- **Continue work?** → Check `docs/tickets/*-[PLAN].md` for context
- **Hotfix needed?** → See [Hotfix Process](#6-hotfix-process-critical-fixes)

## Project Phases

### Phase 1: Core Framework (Current)
- [ ] Template engine with Tera extensions
- [ ] Basic RTR pattern implementation
- [ ] Server setup with Axum
- [ ] Language jail architecture design

### Phase 2: Reactive System
- [ ] WebSocket transport implementation
- [ ] Client-side WASM bindings
- [ ] State synchronisation mechanism
- [ ] Event handling system

### Phase 3: Language Maps
- [ ] PHP jail implementation
- [ ] Python jail implementation
- [ ] JavaScript/Node jail implementation
- [ ] Resource limit enforcement

### Phase 4: Optimisations
- [ ] Connection detection system
- [ ] Dynamic CSS generation
- [ ] Adaptive media delivery
- [ ] Performance benchmarks

### Phase 5: reedCMS
- [ ] CMS core implementation
- [ ] Template-defined content types
- [ ] Admin interface
- [ ] Plugin system

## Development Workflow

> **Note**: For detailed contribution guidelines, see [CONTRIBUTING.md](CONTRIBUTING.md)

### ⚠️ MANDATORY: Decision Log

**EVERY architectural or technical decision MUST be logged in `docs/decisions/decisions.csv`**

Format:
```csv
uid,timestamp,theme,decision,reference_uid,rationale
DEC001,2024-01-26T10:00:00Z,Web Framework,Use Axum instead of Actix-web,,Tower ecosystem
```

Rules:
- New decision = New UID (DEC###)
- Changed decision = New row with reference_uid pointing to original
- Update docs/decisions/decisions.csv BEFORE committing code changes

Example entry:
```bash
# Format: uid,timestamp,theme,decision,reference_uid,rationale
echo "DEC006,$(date -u +%Y-%m-%dT%H:%M:%SZ),Cache,Add template caching,,Performance" >> docs/decisions/decisions.csv
```

### Issue-Driven Development mit Phasen

Every change starts with a ticket that moves through phases:
```mermaid
Ticket → P (Planning) → C (Code) → D (Documentation) → T (Testing) → Done
         ↓ commit      ↓ commit   ↓ commit          ↓ commit     ↓ archive
```

**WICHTIG**: Nach JEDER Phase wird committed!

### 1. Ticket Creation & Planning Phase

#### Create Ticket with Category
```bash
# Wähle Kategorie:
# R01=Admin, R02=DevOps, R03=ReedACT, R04=ReedCMS, R05=Extensions
# R06=Security, R07=Performance, R08=Research

CATEGORY="R03"  # z.B. für ReedACT

# Find next ticket number für diese Kategorie
NEXT_NUM=$(grep "^${CATEGORY}-" docs/tickets/board.csv 2>/dev/null | wc -l | xargs expr 1 +)
TICKET_ID="${CATEGORY}-$(printf "%04d" $NEXT_NUM)"

# Create ticket from template
cp docs/tickets/TEMPLATE.md docs/tickets/${TICKET_ID}.md
echo "Created ticket: ${TICKET_ID}"

# Add to board.csv
echo "${TICKET_ID},P,active,,\"Ticket Description\",,$(date -u +%Y-%m-%d),$(date -u +%Y-%m-%d),\"\"" >> docs/tickets/board.csv
```

#### Complete Planning Phase
```bash
# Create [PLAN] from template
cp docs/tickets/PLAN-TEMPLATE.md docs/tickets/${TICKET_ID}-[PLAN].md

# Fill out planning details
# Then commit the planning phase:
git add docs/tickets/${TICKET_ID}*.md docs/tickets/board.csv
git commit -m "feat(planning): ${TICKET_ID} - Feature planning complete"

# Update board.csv: move to Code phase
# Manually edit: current_phase from P to C, add P to phase_completed
```

### 2. Code Development Phase (C)

#### Create Feature Branch
```bash
git checkout -b feature/${TICKET_ID}
```

#### Implementation
- Write tests first (TDD approach)
- Implement feature incrementally
- Follow existing patterns (check with grep)
- Log decisions in docs/decisions/decisions.csv

#### Commit Code Phase
```bash
# Nach Code-Fertigstellung:
./scripts/pre-commit-check.sh
git add -A
git commit -m "feat: ${TICKET_ID} - Implementation complete"

# Update board.csv: current_phase → D, phase_completed += ",C"
```

### 3. Documentation Phase (D)

- Update technical documentation
- Add code examples
- Document breaking changes
- Update ADRs if needed

#### Commit Documentation Phase
```bash
git add docs/
git commit -m "docs: ${TICKET_ID} - Documentation complete"

# Update board.csv: current_phase → T, phase_completed += ",D"
```

### 4. Testing Phase (T)
- Unit tests for all new code (>80% coverage)
- Integration tests for user-facing features
- Performance benchmarks for critical paths
- Manual testing with examples

#### Commit Testing Phase
```bash
cargo test
git add tests/
git commit -m "test: ${TICKET_ID} - Tests complete"

# Update board.csv: current_phase → done, phase_completed += ",T"
# Move ticket to done folder:
mv docs/tickets/${TICKET_ID}*.md docs/tickets/done/
```

### 5. Pre-Commit Quality Check (bei JEDER Phase!)

#### 🚀 Automated Check (Recommended):
```bash
# Run the pre-commit check script
./scripts/pre-commit-check.sh
```

#### 🔍 Manual Checklist (if script fails):
```bash
# 1. CRITICAL: Check if decisions were logged
echo "=== DECISION CHECK ==="
echo "Did you make ANY technical decisions? (new library, pattern, approach)"
echo "If YES → Check decisions.csv has entry!"
tail -5 docs/decisions/decisions.csv
git diff docs/decisions/decisions.csv  # Must show your decision if you made one!

# 2. Check code style consistency
cargo fmt --check                     # Rust formatting
cargo clippy -- -D warnings          # Rust linting

# 3. Verify tests pass
cargo test                            # All tests must pass

# 4. Check for similar patterns in codebase
grep -r "similar_function" src/      # Find similar code
# → Ensure your code follows the same patterns!

# 5. Verify documentation
ls docs/ | xargs grep -l "TODO"      # No TODOs in docs
```

#### ⚠️ Decision Log Verification:
```bash
# Ask yourself these questions:
# 1. Did I choose a new library/crate? → NEEDS DEC entry
# 2. Did I create a new pattern? → NEEDS DEC entry  
# 3. Did I deviate from existing code? → NEEDS DEC entry
# 4. Did I make a performance trade-off? → NEEDS DEC entry

# If ANY answer is YES:
echo "DEC007,$(date -u +%Y-%m-%dT%H:%M:%SZ),Theme,Decision,,Rationale" >> docs/decisions/decisions.csv
git add docs/decisions/decisions.csv
```

#### ✅ Style Consistency Check:
```rust
// BEFORE writing new code, find similar existing code:
// Example: Adding a new template function?
grep -r "pub fn.*template" src/

// Your code MUST match existing patterns:
// - Same error handling style (Result<T> vs Option<T>)  
// - Same naming conventions
// - Same module structure
// - Same test structure
```

#### 📋 Final Commit Checklist:
- [ ] Code matches existing patterns in codebase
- [ ] Tests follow existing test structure  
- [ ] Error handling consistent with rest of code
- [ ] Documentation style matches existing docs
- [ ] No new warnings from clippy
- [ ] Commit message references ticket (#XXX)

### 6. Review & Merge
- Create PR using template
- Ensure CI passes
- Address review feedback
- Squash and merge to main
- Move ticket to `docs/tickets/done/`

### 6. Hotfix Process (Critical Fixes)

For broken CI/CD or production issues:
```bash
# Work directly on main
git checkout main
git pull

# Make fixes
git add -A
git commit -m "fix: Description"

# Squash commits before push
git reset --soft HEAD~2
git commit -m "fix: Complete description

Decisions:
- DEC### if applicable

Fixes #issue"

# Push clean commit
git push origin main
```

## Code Quality Standards

### Rust Code
- Must pass `cargo clippy`
- Must pass `cargo fmt --check`
- Must have >80% test coverage
- Must include documentation comments

### Templates
- Must validate with Tera parser
- Must follow semantic HTML
- Must include accessibility attributes
- Must work without JavaScript

### Performance Targets
- Template render: <10ms
- HTTP response: <50ms
- WebSocket latency: <5ms
- Memory per connection: <1MB

## Release Process

### Version Numbering
Following Semantic Versioning (SemVer):
- MAJOR: Breaking changes
- MINOR: New features (backwards compatible)
- PATCH: Bug fixes

### Release Checklist
1. [ ] All tests passing
2. [ ] Documentation updated
3. [ ] CHANGELOG.md updated
4. [ ] Version bumped in Cargo.toml
5. [ ] Git tag created
6. [ ] GitHub release created
7. [ ] Crates.io published

## Architecture Decisions

Architecture decisions are documented as ADRs (Architecture Decision Records) in [`docs/decisions/`](docs/decisions/).

### Key Decisions
- [ADR-001](docs/decisions/001-why-axum.md): Use Axum as Web Framework
- [ADR-002](docs/decisions/002-why-tera.md): Use Tera as Template Engine
- [ADR-003](docs/decisions/003-security-isolation-model.md): Security Isolation Model

### Creating New ADRs
1. Copy the [template](docs/decisions/000-template.md)
2. Number it sequentially
3. Submit as PR for discussion
4. Update status after decision

## Testing Strategy

### Unit Tests
- All public functions
- Edge cases and error conditions
- Resource limit enforcement
- Security boundaries

### Integration Tests
- End-to-end template rendering
- Language execution pipelines
- WebSocket connections
- HTTP request handling

### Performance Tests
- Template compilation speed
- Rendering performance
- Concurrent connections
- Memory usage under load

### Security Tests
- Jail escape attempts
- Resource exhaustion
- Input validation
- Code injection prevention

## Documentation Standards

### Code Documentation
```rust
/// Brief description of the function.
/// 
/// # Arguments
/// 
/// * `param` - Description of parameter
/// 
/// # Returns
/// 
/// Description of return value
/// 
/// # Examples
/// 
/// ```
/// use reedact::function;
/// let result = function(param);
/// ```
pub fn function(param: Type) -> Result<ReturnType> {
    // Implementation
}
```

### Template Documentation
```html
{# 
  Component: Dashboard
  Description: Main user dashboard with adaptive rendering
  
  Required Variables:
  - user: User object with name, id
  - stats: Dashboard statistics object
  
  Events:
  - refresh: Updates dashboard statistics
  
  Example:
  {% include "dashboard.tera" with user=current_user, stats=dashboard_stats %}
#}
```

## Contribution Guidelines

### Getting Started
1. Fork the repository
2. Create feature branch
3. Make changes
4. Run tests locally
5. Submit pull request

### Commit Message Guidelines
- Use clear, descriptive commit messages
- Reference issues with #issue-number
- Follow conventional commits format
- **IMPORTANT**: Never include AI assistant names in commits
- Keep commits focused on single changes

### Pull Request Template
```markdown
## Description
Brief description of changes

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
```

## Communication

### Issues
- Bug reports: Use bug template
- Feature requests: Use feature template
- Questions: Use discussion forum

### Discussions
- Architecture decisions
- Feature planning
- Community feedback
- Best practices

### Security
- Report security issues privately
- Email: security@byvoss.com
- PGP key available on request

## Resources

### Documentation
- [Project Documentation](docs/reference/reedact-project.md)
- [Development Process](PROCESS_GUIDE.md)
- [Style Guide](STYLE_GUIDE.md)
- [API Reference](docs/api/)
- [Examples](examples/)

### External Resources
- [Axum Documentation](https://docs.rs/axum)
- [Tera Documentation](https://tera.netlify.app)
- [Rust Book](https://doc.rust-lang.org/book)

### Community
- GitHub Discussions
- Discord Server (coming soon)
- Stack Overflow tag: `reedact`

---

*Last updated: 2024*