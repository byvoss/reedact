# reedACT Style Guide

## Finding Existing Patterns

Before writing ANY new code, find similar existing patterns:

```bash
# For new functions
grep -r "pub fn" src/ | grep similar_concept

# For error handling  
grep -r "Result<.*>" src/ | head -20

# For test patterns
grep -r "#\[test\]" src/ -A 5

# For module structure
find src/ -name "mod.rs" | xargs grep "pub mod"
```

## Rust Code Patterns

### Error Handling
```rust
// ✅ ALWAYS use Result<T> for fallible operations
pub fn load_template(path: &Path) -> Result<Template> {
    // Not Option<Template> or panic!
}

// ✅ Use anyhow for error propagation
use anyhow::{Context, Result};

pub fn process() -> Result<()> {
    let template = load_template(&path)
        .context("Failed to load template")?;
    Ok(())
}
```

### Function Naming
```rust
// ✅ Verb prefixes for actions
pub fn parse_template()     // Not: template_parser
pub fn validate_config()    // Not: config_validation
pub fn create_jail()        // Not: jail_creation

// ✅ is/has for boolean returns
pub fn is_valid() -> bool
pub fn has_cache() -> bool
```

### Module Structure
```rust
// ✅ Each module has clear responsibility
mod template;    // Template operations
mod jail;        // Security isolation
mod transport;   // Communication

// ✅ Public API in mod.rs
pub use template::Template;
pub use jail::Jail;
```

### Testing Patterns
```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_descriptive_name() {
        // Arrange
        let input = create_test_input();
        
        // Act
        let result = function_under_test(input);
        
        // Assert
        assert_eq!(result, expected);
    }
}
```

## Documentation Patterns

### Function Documentation
```rust
/// Brief description of what the function does.
///
/// # Arguments
/// 
/// * `param` - What this parameter is for
///
/// # Returns
///
/// What the function returns
///
/// # Errors
///
/// When this function returns an error
pub fn example(param: &str) -> Result<String> {
    // Implementation
}
```

### Code Comments
```rust
// ✅ Explain WHY, not WHAT
// We need to clone here because the template engine takes ownership
let template_copy = template.clone();

// ❌ Bad: Explains what is obvious
// Clone the template
let template_copy = template.clone();
```

## Pre-Commit Verification

**ALWAYS run before committing:**

```bash
# 1. Find similar code
grep -r "similar_function" src/

# 2. Check your code matches patterns
cargo fmt --check
cargo clippy -- -D warnings

# 3. Run tests
cargo test

# 4. Verify consistency
# Compare your code side-by-side with similar existing code
```

## Common Mistakes to Avoid

### ❌ Inconsistent Error Handling
```rust
// File A uses Result<T>
pub fn load() -> Result<Config>

// File B uses Option<T> for similar operation
pub fn parse() -> Option<Config>  // WRONG!
```

### ❌ Different Test Styles
```rust
// Existing tests use descriptive names
#[test]
fn test_template_renders_with_empty_context()

// Your test uses abbreviations
#[test] 
fn tpl_rndr_empty()  // WRONG!
```

### ❌ New Patterns Without Decision
```rust
// Existing code uses anyhow::Result
// You introduce thiserror without decision log
#[derive(thiserror::Error)]  // Need DEC entry!
```

## Quick Reference

| Check | Command | What to Look For |
|-------|---------|------------------|
| Similar code | `grep -r "pattern" src/` | Match style |
| Formatting | `cargo fmt --check` | Must pass |
| Linting | `cargo clippy` | No warnings |
| Tests | `cargo test` | All green |
| Docs | `cargo doc --no-deps` | No warnings |

## Remember

> **When in doubt, copy existing patterns!**

The codebase consistency is more important than perfect code.