# Use the Rust base image
FROM rust:latest as builder

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the application source code
COPY . .

# Final stage: create a minimal runtime image
FROM debian:buster-slim

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the application source code from the builder stage
COPY --from=builder /usr/src/app .

# Expose the port your application listens on
EXPOSE 8080

# Command to run the application
CMD ["cargo", "run"]
