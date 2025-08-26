use tera::Tera;
use once_cell::sync::Lazy;
use anyhow::Result;

pub static TEMPLATES: Lazy<Tera> = Lazy::new(|| {
    let mut tera = match Tera::new("templates/**/*.tera") {
        Ok(t) => t,
        Err(e) => {
            eprintln!("Template parsing error: {}", e);
            ::std::process::exit(1);
        }
    };
    tera.autoescape_on(vec![".html", ".tera"]);
    tera
});

pub fn render_template(name: &str, context: &tera::Context) -> Result<String> {
    Ok(TEMPLATES.render(name, context)?)
}