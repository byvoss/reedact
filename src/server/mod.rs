use anyhow::Result;
use axum::{
    routing::get,
    Router,
};
use tower_http::{compression::CompressionLayer, cors::CorsLayer};
use tracing::info;

pub async fn run() -> Result<()> {
    // Build the application
    let app = Router::new()
        .route("/", get(root_handler))
        .route("/health", get(health_handler))
        .layer(CompressionLayer::new())
        .layer(CorsLayer::permissive());

    // Create the listener
    let listener = tokio::net::TcpListener::bind("127.0.0.1:8080").await?;
    info!("reedACT server listening on http://127.0.0.1:8080");
    
    // Serve the application
    axum::serve(listener, app).await?;
    
    Ok(())
}

async fn root_handler() -> &'static str {
    "reedACT - Reactive Templates in Action"
}

async fn health_handler() -> &'static str {
    "OK"
}