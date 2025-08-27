# reedACT

**Lightning fast. Incredibly powerful. Less complex. Literally speaks your language.**

A revolutionary web framework where templates rule. Write PHP, Python, JavaScript, Ruby, and more in the same template. No more MVC complexity - just Request → Template → Response.

## Features

- 🎯 **Frontend-First**: Templates define what backend must deliver
- 🌐 **Polyglot Execution**: PHP, Python, JavaScript in secure server-side maps
- ⚡ **Connection-Adaptive**: Microsecond detection, optimised delivery
- 🎨 **Dynamic CSS**: 18x smaller stylesheets through client-specific compilation
- 🔒 **Secure by Default**: Templates never exposed, code runs in isolated jails
- 🚀 **Progressive Enhancement**: Works without JavaScript, enhanced with WASM

## Security

Like Twig, Blade, and other server-side template engines, **reedACT templates are never sent to the client**. All `.tera` files are rendered server-side, and only the resulting HTML/JSON is sent to browsers. Code in `.php.tera`, `.py.tera` files executes in secure, isolated environments on the server.

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
- [Development Process](docs/PROCESS_GUIDE.md) - Development workflow and guidelines
- [Style Guide](docs/STYLE_GUIDE.md) - Code style and patterns

## License

Apache License 2.0 - See [LICENSE](LICENSE) file for details.

## Author

**Vivian Burkhard Voss**  
ByVoss Technologies

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.