# Build stage
FROM golang:1.22-alpine AS builder

WORKDIR /build

# Copy go.mod files first for better caching
COPY skeys-core/go.mod skeys-core/go.sum ./skeys-core/
COPY skeys-daemon/go.mod skeys-daemon/go.sum ./skeys-daemon/

# Download dependencies
RUN cd skeys-daemon && go mod download

# Copy source
COPY skeys-core ./skeys-core
COPY skeys-daemon ./skeys-daemon

# Build static binary
ARG VERSION=dev
ARG COMMIT=unknown
RUN cd skeys-daemon && CGO_ENABLED=0 GOOS=linux go build \
    -ldflags="-s -w -X main.version=${VERSION} -X main.commit=${COMMIT}" \
    -o /skeys-daemon ./cmd/skeys-daemon

# Runtime stage - distroless
FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=builder /skeys-daemon /skeys-daemon

# Socket will be mounted from host
VOLUME ["/tmp"]

ENTRYPOINT ["/skeys-daemon"]
CMD ["--socket", "/tmp/skeys-dev.sock"]
