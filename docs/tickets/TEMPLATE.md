# Ticket [RXX-YYYY]: [Title]
<!-- Format: R03-0001 = ReedACT, Ticket 0001 -->
<!-- Aktuelle Phase: [P|C|D|T] -->
<!-- Phasen: P=Planning, C=Code, D=Dokumentation, T=Testing -->

## Status: 📋 Backlog | 🚧 Active | 🚫 Blocked | 🔍 Review | ✅ Done

## Priority: 🔴 Critical | 🟠 High | 🟡 Medium | 🟢 Low

## Dependencies
- Depends on: [RXX-YYYY] (Liste von Vorbedingungen)
- Blocks: [RXX-YYYY] (Was wartet auf dieses Ticket)

## Decision Log References
- DEC### - [Decision theme]

## Description
Clear, concise description of what needs to be implemented.

## Requirements
### Functional Requirements
- [ ] Requirement 1
- [ ] Requirement 2

### Technical Requirements
- [ ] Must follow reedACT patterns
- [ ] Security considerations
- [ ] Performance targets

## Implementation Plan
1. Step 1: [Specific action]
2. Step 2: [Specific action]
3. Step 3: [Specific action]

## Acceptance Criteria
- [ ] Feature works as specified
- [ ] Tests pass (>80% coverage)
- [ ] Documentation updated
- [ ] Code reviewed
- [ ] Performance verified

## Testing Checklist
- [ ] Unit tests written
- [ ] Integration tests pass
- [ ] Manual testing complete
- [ ] Security tested
- [ ] Performance benchmarked

## Documentation Updates
- [ ] API documentation
- [ ] Usage examples
- [ ] Migration notes (if breaking)
- [ ] ADR created (if architectural)

## Dependencies
- Requires: #XXX
- Blocks: #YYY

## Verification Steps
1. [ ] Code follows reedACT patterns
2. [ ] No breaking changes (unless major version)
3. [ ] Security boundaries maintained
4. [ ] Accessibility maintained

## Pre-Completion Checklist
### Code Quality
- [ ] Matches existing code patterns (checked via grep)
- [ ] Same error handling as rest of codebase
- [ ] Consistent naming conventions
- [ ] No clippy warnings

### Testing
- [ ] All tests pass (`cargo test`)
- [ ] New tests added for new code
- [ ] Tests follow existing test patterns

### Documentation
- [ ] Code comments where needed
- [ ] Docs updated if API changed
- [ ] No TODOs left in code

### Final Check
- [ ] `cargo fmt --check` passes
- [ ] `cargo clippy -- -D warnings` passes
- [ ] Similar code patterns reviewed
- [ ] Decision logged in decisions.csv

## Notes
Additional context, decisions, or concerns.