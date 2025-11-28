# Copyright (c) 2025 John Nelson
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
