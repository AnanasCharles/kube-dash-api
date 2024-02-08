# Use the Rust base image
FROM rust:latest as builder

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the application source code
COPY . .

# Build the application
RUN cargo build --release

# Final stage: create a minimal runtime image
FROM debian:buster-slim

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    libc6 \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the built binary from the builder stage
COPY --from=builder /usr/src/app/target/release/kube-dash-api ./

# Expose the port your application listens on
EXPOSE 8080

# Command to run the application
CMD ["./kube-dash-api"]
