# ADR-001: Use Axum as Web Framework

## Status
Accepted

## Context
We need a web framework for reedACT that provides:
- High performance
- WebSocket support
- Good ecosystem
- Type safety
- Async/await support
- Extensibility

## Decision
We will use Axum as our web framework.

## Consequences

### Positive
- **Tower ecosystem**: Leverages Tower's middleware system, providing access to a rich ecosystem of HTTP middleware
- **Type-safe routing**: Compile-time guarantees for route handlers
- **Performance**: Built on Tokio and Hyper, providing excellent performance
- **WebSocket support**: Built-in WebSocket support without additional dependencies
- **Extractors**: Powerful extractor system for request data
- **Active development**: Maintained by Tokio team with regular updates

### Negative
- **Learning curve**: Requires understanding of Tower and async Rust
- **Breaking changes**: Still evolving, potential for breaking changes between versions
- **Documentation**: Less extensive documentation compared to Actix-web

### Neutral
- Different from Actix-web's actor model approach
- Requires explicit state management

## Alternatives Considered

### Actix-web
- Pros: Mature, extensive documentation, actor model
- Cons: More complex, separate async runtime, historically had unsafe code issues

### Rocket
- Pros: Ergonomic, good for beginners, strong typing
- Cons: Slower adoption of stable async/await, less flexible

### Warp
- Pros: Filter-based composition, functional approach
- Cons: Steeper learning curve, less intuitive for complex applications

## References
- [Axum Documentation](https://docs.rs/axum)
- [Tower Middleware](https://docs.rs/tower)
- [Comparison of Rust Web Frameworks](https://www.lpalmieri.com/posts/2020-07-04-choosing-a-rust-web-framework-2020-edition/)