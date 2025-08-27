# ADR-002: Use Tera as Template Engine

## Status
Accepted

## Context
reedACT needs a template engine that:
- Has familiar syntax for web developers
- Is extensible with custom functions and filters
- Provides good performance
- Supports template inheritance
- Has stable API
- Can be extended for our reactive features

## Decision
We will use Tera as our base template engine and extend it with reedACT-specific functionality.

## Consequences

### Positive
- **Familiar syntax**: Django/Jinja2-like syntax is well-known among developers
- **Extensibility**: Easy to add custom functions, filters, and testers
- **Template inheritance**: Built-in support for template inheritance and includes
- **Auto-escaping**: Security by default with automatic HTML escaping
- **Mature**: Stable API, well-tested in production
- **Pure Rust**: No FFI or unsafe code required
- **Good performance**: Compiles templates to efficient code

### Negative
- **Not reactive by default**: Requires our extensions for reactivity
- **Limited compared to JSX**: Less powerful than JavaScript-based templating
- **Compilation overhead**: Templates must be parsed and compiled

### Neutral
- Different from Go templates or Handlebars syntax
- Requires learning for developers unfamiliar with Django/Jinja2

## Alternatives Considered

### Handlebars
- Pros: Logic-less templates, JavaScript familiarity
- Cons: Less extensible, limited control structures

### Askama
- Pros: Compile-time templates, type-safe, fastest performance
- Cons: Templates must be known at compile time, less flexible for CMS use case

### Liquid
- Pros: Safe by design, popular in Ruby world
- Cons: More limited, less extensible

### Custom Template Engine
- Pros: Perfect fit for our needs
- Cons: Massive development effort, reinventing the wheel

## References
- [Tera Documentation](https://tera.netlify.app)
- [Template Engine Comparison](https://github.com/djc/template-benchmarks-rs)
- Related: ADR-003 (Reactive Extensions)