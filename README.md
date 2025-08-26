# reedACT

**Lightning fast. Incredibly powerful. Less complex. Literally speaks your language.**

A revolutionary web framework where templates rule. Write PHP, Python, JavaScript, Ruby, and more in the same template. No more MVC complexity - just Request → Template → Response.

## Features

- 🎯 **Frontend-First**: Templates define what backend must deliver
- 🌐 **Polyglot Execution**: PHP, Python, JavaScript in secure server-side maps
- ⚡ **Connection-Adaptive**: Microsecond detection, optimised delivery
- 🎨 **Dynamic CSS**: 18x smaller stylesheets through client-specific compilation
- 🔒 **Secure by Default**: Language jails with resource limits
- 🚀 **Progressive Enhancement**: Works without JavaScript, enhanced with WASM

## Quick Start

```bash
# Clone the repository
git clone https://github.com/byvoss/reedact
cd reedact

# Build the project
cargo build --release

# Run the development server
cargo run -- serve --dev
```

## Example

```html
{% block dashboard as reedACT via auto %}
  <h1>Welcome {{ user.name }}!</h1>
  <span {% bind "stats" %}>{{ dashboard.stats }}</span>
  <button {% on "click" call="refresh" %}>Refresh</button>
{% endblock %}
```

## Documentation

- [Project Documentation](docs/reference/reedact-project.md) - Comprehensive technical documentation
- [Development Process](PROCESS.md) - Development workflow and guidelines

## License

Apache License 2.0 - See [LICENSE](LICENSE) file for details.

## Author

**Vivian Burkhard Voss**  
ByVoss Technologies

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.