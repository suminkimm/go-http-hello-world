FROM golang:1.23 AS builder

WORKDIR /build

# Copy the source code into the container
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -v -o app-binary

FROM gcr.io/distroless/static-debian12

ENV PORT=80
EXPOSE 80

WORKDIR /app
COPY --from=builder /build/app-binary . 
CMD ["/app/app-binary"]
