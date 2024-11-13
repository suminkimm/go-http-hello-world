# Use the official Golang image as the builder
FROM golang:1.23 AS builder

# Set the working directory inside the container
WORKDIR /build

# Copy the go.mod file first
COPY go.mod ./

# Download dependencies
RUN go mod download

# Copy the rest of the source code
COPY hello_world/ ./hello_world/

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -v -o app-binary ./hello_world

# Use the distroless image for the final stage
FROM gcr.io/distroless/static-debian12

# Set environment variables
ENV PORT=80

# Expose the port
EXPOSE 80

# Set the working directory inside the container
WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /build/app-binary .

# Command to run the application
CMD ["/app/app-binary"]
