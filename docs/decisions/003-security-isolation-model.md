# ADR-003: Security Isolation Model for Language Execution

## Status
Accepted

## Context
reedACT allows execution of multiple programming languages (PHP, Python, JavaScript, etc.) within templates. This creates significant security risks:
- Code injection attacks
- Resource exhaustion
- File system access
- Network access
- Information disclosure

We need a security model that provides strong isolation while maintaining good performance.

## Decision
Implement a jail-based isolation model inspired by FreeBSD jails, using:
- Process isolation via Linux namespaces/cgroups (or equivalent)
- Resource limits (memory, CPU, execution time)
- Syscall filtering
- Filesystem restrictions
- Network isolation by default

Each language execution happens in a fresh, isolated environment with no persistent state.

## Consequences

### Positive
- **Strong security**: Complete isolation between executions
- **Resource control**: Prevents denial-of-service attacks
- **No state leakage**: Fresh environment for each execution
- **Language-agnostic**: Same security model for all languages
- **Configurable**: Admins can adjust security policies

### Negative
- **Performance overhead**: Creating jails has a cost
- **Complexity**: Requires platform-specific implementation
- **Limited functionality**: Some language features unavailable in jails
- **Debugging difficulty**: Harder to debug jailed code

### Neutral
- Similar to container-based isolation but lighter weight
- Requires careful configuration of allowed functions/modules

## Alternatives Considered

### Docker Containers
- Pros: Industry standard, good isolation, portable
- Cons: Heavy weight, slower startup, requires Docker

### WebAssembly (WASM)
- Pros: Designed for sandboxing, portable, fast
- Cons: Limited language support, can't use existing libraries

### V8 Isolates Style
- Pros: Very fast, lightweight
- Cons: Only for JavaScript, complex to implement

### No Isolation
- Pros: Simple, fast, full language features
- Cons: Completely insecure, unacceptable risk

## Implementation Details

```rust
struct ExecutionJail {
    memory_limit: usize,      // e.g., 256MB
    cpu_quota: f32,          // e.g., 0.5 (50% of one core)
    timeout: Duration,       // e.g., 30 seconds
    allowed_syscalls: Vec<Syscall>,
    filesystem_access: Vec<PathBuf>,
    network_access: bool,    // default: false
}
```

## References
- [FreeBSD Jails](https://docs.freebsd.org/en/books/handbook/jails/)
- [Linux Namespaces](https://man7.org/linux/man-pages/man7/namespaces.7.html)
- Related: ADR-004 (Resource Limits)