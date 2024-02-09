# Start with a Rust image for building the application
FROM rust:latest as builder

# Install musl-tools for static compilation
RUN apt-get update && apt-get install -y musl-tools && rm -rf /var/lib/apt/lists/*

# Add musl target for static compilation
RUN rustup target add x86_64-unknown-linux-musl

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the application source code
COPY . .

# Build the application for the musl target (statically linked)
RUN cargo build --target x86_64-unknown-linux-musl --release

# Start from scratch for a minimal runtime image
FROM scratch

# Set the working directory inside the container
WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /usr/src/app/target/x86_64-unknown-linux-musl/release/kube-dash-api .

# Expose the port your application listens on
EXPOSE 8080

# Command to run the application
CMD ["./kube-dash-api"]