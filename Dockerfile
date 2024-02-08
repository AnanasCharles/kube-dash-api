# Use the Rust base image
FROM rust:latest as builder

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the dependency manifests
COPY Cargo.toml Cargo.lock ./

# Build the dependencies (to cache them if unchanged)
RUN mkdir src && \
    echo "fn main() {}" > src/main.rs && \
    cargo build --release

# Remove the dummy source file
RUN rm -f src/main.rs

# Copy the application source code
COPY src ./src

# Build the application
RUN cargo build --release

# Final stage: create a minimal runtime image
FROM debian:buster-slim

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the built binary from the previous stage
COPY --from=builder /usr/src/app/target/release/kube-dash-api ./

# Expose the port your application listens on
EXPOSE 8080

# Command to run the application
CMD ["./kube-dash-api"]
