// main.rs
use actix_web::{web, App, HttpServer, HttpResponse};
use serde_json::json;

async fn index() -> HttpResponse {
    HttpResponse::Ok().json(json!({"message": "Hello, World!"}))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .route("/", web::get().to(index))
    })
    .bind("0.0.0.0:8080")?
    .run()
    .await
}
