FROM golang:1.23 AS builder

# Install gvm
RUN apt-get update && apt-get install -y curl git mercurial make binutils bison gcc build-essential
RUN bash -c "curl -s -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash"
RUN bash -c "source /root/.gvm/scripts/gvm && gvm install go1.22 && gvm use go1.22 --default"

# Set GOPATH
ENV GOPATH=/go
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

# Set the working directory
WORKDIR /go/src/your_project

# Copy the source code into the container
COPY . .

# Build the Go application
RUN bash -c "source /root/.gvm/scripts/gvm && gvm use go1.22 && go build -v -o /go/bin/app-binary"

FROM gcr.io/distroless/static-debian12

ENV PORT=80
EXPOSE 80

WORKDIR /app
COPY --from=builder /go/bin/app-binary . 
CMD ["/app/app-binary"]
